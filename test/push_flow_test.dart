import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/push_offer.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'fake_push_service.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// From the welcome screen, through Add an account, to the inbox.
Future<void> _signIn(WidgetTester tester) async {
  await tester.tap(find.text('Add an account'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
  await tester.pump(const Duration(milliseconds: 600)); // past the debounce
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byTooltip('App settings'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  late FakeRestmail fake;
  late AppState state;

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  /// Closes the event streams so no timer outlives the test.
  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('after sign-in the app explains notifications and asks; '
      'Settings turns them off again', (tester) async {
    phone(tester);
    fake = FakeRestmail();
    final push = FakePushService();
    state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
      pushService: push,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    // Not at first launch.
    expect(find.text('Get notified of new mail?'), findsNothing);

    await _signIn(tester);

    expect(find.text('Get notified of new mail?'), findsOneWidget);
    expect(find.textContaining('none of it passes through Apple'), findsOne);
    expect(
      find.text(
        "Gmail and other IMAP accounts get no notifications: REST Mail isn't told when their mail arrives. They update while the app is open.",
      ),
      findsNothing,
    );
    expect(push.prompts, 0);
    await tester.tap(find.text('Turn on'));
    await tester.pumpAndSettle();

    expect(push.prompts, 1);
    expect(fake.devicesOf(FakeAccounts.email), hasLength(1));
    expect(find.text('Get notified of new mail?'), findsNothing);

    await _openSettings(tester);
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    final notificationsSwitch = find.byKey(const Key('notifications-switch'));
    expect(tester.widget<RmSwitch>(notificationsSwitch).value, isTrue);
    await tester.tap(notificationsSwitch);
    await tester.pumpAndSettle();

    expect(fake.devicesOf(FakeAccounts.email), isEmpty);
    expect(tester.widget<RmSwitch>(notificationsSwitch).value, isFalse);

    await finish(tester);
  });

  testWidgets('a server without push: no prompt, and no Notifications in '
      'Settings', (tester) async {
    phone(tester);
    fake = FakeRestmail(pushPlatforms: const {});
    final push = FakePushService();
    state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
      pushService: push,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    await _signIn(tester);

    expect(find.text('Get notified of new mail?'), findsNothing);
    await _openSettings(tester);
    expect(find.text('NOTIFICATIONS'), findsNothing);
    expect(find.text('THIS PHONE'), findsOneWidget);
    expect(push.prompts, 0);

    await finish(tester);
  });

  testWidgets('with Gmail on the phone too, the offer and Settings say it '
      'gets no notifications', (tester) async {
    phone(tester);
    fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    // A Gmail account already on the phone, beside the REST Mail one on
    // screen. It is never shown, so it never connects.
    final first = AppState(store: store, httpClientFactory: () => fake.client);
    await first.start();
    await first.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    final restKey = first.accounts.single.key;
    first.dispose();
    const gmailKey = 'imaps://imap.gmail.com|ada@gmail.com';
    await store.write(
      'account:$gmailKey',
      jsonEncode({
        'kind': 'imap',
        'address': 'ada@gmail.com',
        'display_name': 'Ada',
        'password': 'abcd efgh ijkl mnop',
        'settings': const MailServerSettings(
          imapHost: 'imap.gmail.com',
          smtpHost: 'smtp.gmail.com',
          filesSentMail: true,
        ).toJson(),
        'provider': 'gmail',
      }),
    );
    await store.write(
      'accounts',
      jsonEncode({
        'order': [restKey, gmailKey],
        'current': restKey,
      }),
    );
    state = AppState(
      store: store,
      httpClientFactory: () => fake.client,
      mailSockets: (host, port, {required tls}) =>
          throw const SocketException('not in this test'),
      pushService: FakePushService(),
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Get notified of new mail?'), findsOneWidget);
    expect(
      find.text(
        "Gmail and other IMAP accounts get no notifications: REST Mail isn't told when their mail arrives. They update while the app is open.",
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(fake.devicesOf(FakeAccounts.email), isEmpty);

    await _openSettings(tester);
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(
      find.text(
        "Gmail and other IMAP accounts get no notifications: REST Mail isn't told when their mail arrives. They update while the app is open.",
      ),
      findsOneWidget,
    );

    await finish(tester);
  });
}
