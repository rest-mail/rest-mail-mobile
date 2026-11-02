import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/compose_sheet.dart';
import 'package:restmail/ui/contact_reply_time.dart';
import 'package:restmail/ui/settings_screen.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _toggle = 'Show usual reply times beside contacts';
const _twoHours = 'Usually replies in about 2 hours';
const _ada = 'ada@example.test';

/// The fake, with the reply-time route able to hold or fail a request.
class _Gate extends http.BaseClient {
  _Gate(this.inner);

  final http.Client inner;
  Completer<void>? hold;
  bool fail = false;
  int puts = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/contact-reply-time')) {
      if (request.method == 'PUT') puts++;
      await hold?.future;
      if (fail) {
        return http.StreamedResponse(
          Stream.value('{"error":"no","code":"internal_error"}'.codeUnits),
          500,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, _Gate)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()
      ..addContact(FakeAccounts.email, _ada, name: 'Ada')
      ..addContact(FakeAccounts.email, 'bob@example.test', name: 'Bob')
      ..setContactReplySeconds(FakeAccounts.email, _ada, 7200);
    final gate = _Gate(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => gate,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state, gate);
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Finder switchFinder() => find.descendant(
    of: find.byType(ContactReplyTimeSettings),
    matching: find.byType(RmSwitch),
  );

  RmSwitch replySwitch(WidgetTester tester) =>
      tester.widget<RmSwitch>(switchFinder());

  /// From the mailbox, Mailboxes → Mailbox settings, scrolled to the section.
  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailbox settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      switchFinder(),
      300,
      scrollable: find
          .descendant(
            of: find.byType(MailboxSettingsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Back').last);
    await tester.pumpAndSettle();
  }

  /// Turns the setting to [enabled] from the mailbox, and comes back.
  Future<void> optIn(WidgetTester tester, {bool enabled = true}) async {
    await openSettings(tester);
    expect(replySwitch(tester).value, !enabled);
    await tester.tap(switchFinder());
    await tester.pumpAndSettle();
    expect(replySwitch(tester).value, enabled);
    await back(tester);
  }

  /// Mailboxes → Contacts, last in the list: scrolled to, then tapped.
  Future<void> openContacts(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Contacts'),
      200,
      scrollable: find
          .ancestor(
            of: find.text('Quarantine'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contacts'));
    await tester.pumpAndSettle();
  }

  testWidgets('the figure is worded and rounded as the webmail words it', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            for (final (seconds, text) in const [
              (null, null),
              (0, null),
              (-1, null),
              (1, 'Usually replies in about less than a minute'),
              (59, 'Usually replies in about less than a minute'),
              (60, 'Usually replies in about 1 minute'),
              (89, 'Usually replies in about 1 minute'),
              (90, 'Usually replies in about 2 minutes'),
              (3599, 'Usually replies in about 60 minutes'),
              (3600, 'Usually replies in about 1 hour'),
              (5400, 'Usually replies in about 2 hours'),
              (7200, _twoHours),
              (86399, 'Usually replies in about 24 hours'),
              (86400, 'Usually replies in about 1 day'),
              (172800, 'Usually replies in about 2 days'),
            ]) {
              expect(
                contactReplyTimeLabel(context, seconds),
                text,
                reason: '$seconds',
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('off by default: no figure, until the account opts in, and none '
      'again once it opts out', (tester) async {
    final (fake, state, _) = await open(tester);
    await openContacts(tester);
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text(_twoHours), findsNothing);
    await back(tester);
    await back(tester);

    await openSettings(tester);
    expect(replySwitch(tester).value, isFalse);
    expect(find.text(_toggle), findsOneWidget);
    expect(find.textContaining('Nothing leaves the server'), findsOneWidget);
    await back(tester);
    expect(fake.contactReplyTimeEnabled(FakeAccounts.email), isFalse);

    await optIn(tester);
    expect(fake.contactReplyTimeEnabled(FakeAccounts.email), isTrue);
    await openContacts(tester);
    expect(find.text(_twoHours), findsOneWidget, reason: 'Ada, and not Bob');
    await back(tester);
    await back(tester);

    await optIn(tester, enabled: false);
    expect(fake.contactReplyTimeEnabled(FakeAccounts.email), isFalse);
    await openContacts(tester);
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text(_twoHours), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('the figure says where it comes from, and a tap on it still '
      'opens the contact, which shows it too', (tester) async {
    final (fake, state, _) = await open(tester);
    await optIn(tester);
    await openContacts(tester);
    final tip = tester.widget<Tooltip>(
      find.ancestor(of: find.text(_twoHours), matching: find.byType(Tooltip)),
    );
    expect(tip.message, contains("this account's own history"));
    expect(tip.message, contains('not a signal from the contact'));

    await tester.tap(find.text(_twoHours));
    await tester.pumpAndSettle();
    expect(find.text('Contact'), findsOneWidget);
    expect(find.text(_twoHours), findsOneWidget);
    await close(tester, fake, state);
  });

  Future<Finder> suggest(WidgetTester tester, String typed) async {
    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    final to = find
        .descendant(
          of: find.byType(ComposeSheet),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(to, typed);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    return find.descendant(
      of: find.byType(ComposeSheet),
      matching: find.text(_twoHours),
    );
  }

  testWidgets('a suggestion shows no figure while the setting is off', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    expect(await suggest(tester, 'ada@'), findsNothing);
    expect(find.textContaining(_ada), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('a suggestion shows the figure once opted in, and a tap on it '
      'still picks the contact', (tester) async {
    final (fake, state, _) = await open(tester);
    await optIn(tester);
    final figure = await suggest(tester, 'ada@');
    expect(figure, findsOneWidget);
    await tester.tap(figure);
    await tester.pumpAndSettle();
    expect(find.textContaining('Ada <$_ada>'), findsWidgets);
    expect(find.text(_twoHours), findsNothing, reason: 'the suggestions close');
    await close(tester, fake, state);
  });

  testWidgets('a message shows the figure beside a sender who has one', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    fake
      ..deliver(to: FakeAccounts.email, from: _ada, subject: 'Known', body: 'x')
      ..deliver(
        to: FakeAccounts.email,
        from: 'bob@example.test',
        subject: 'Unknown',
        body: 'x',
      );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    Future<void> read(String subject) async {
      await tester.tap(find.text(subject).last);
      await tester.pumpAndSettle();
    }

    await read('Known');
    expect(find.text(_twoHours), findsNothing, reason: 'the setting is off');
    await back(tester);
    await optIn(tester);

    await read('Known');
    expect(find.text(_twoHours), findsOneWidget);
    await back(tester);

    await read('Unknown');
    expect(find.text(_twoHours), findsNothing, reason: 'too little history');
    await close(tester, fake, state);
  });

  testWidgets('the switch waits for the server, says so, and cannot change '
      'until it knows', (tester) async {
    final (fake, state, gate) = await open(tester);
    gate.hold = Completer<void>();
    await openSettings(tester);
    expect(find.text('Loading setting…'), findsOneWidget);
    expect(replySwitch(tester).value, isFalse);
    await tester.tap(switchFinder());
    await tester.pump();
    expect(gate.puts, 0, reason: 'unknown, so it cannot change');
    gate.hold!.complete();
    gate.hold = null;
    await tester.pumpAndSettle();
    expect(find.text('Loading setting…'), findsNothing);

    gate.hold = Completer<void>();
    await tester.tap(switchFinder());
    await tester.pump();
    expect(find.text('Saving…'), findsOneWidget);
    await tester.tap(switchFinder());
    await tester.pump();
    expect(gate.puts, 1, reason: 'one save at a time');
    gate.hold!.complete();
    gate.hold = null;
    await tester.pumpAndSettle();
    expect(find.text('Saving…'), findsNothing);
    expect(replySwitch(tester).value, isTrue);
    await close(tester, fake, state);
  });

  testWidgets('a failed load says so and leaves the switch unusable', (
    tester,
  ) async {
    final (fake, state, gate) = await open(tester);
    gate.fail = true;
    await openSettings(tester);
    expect(
      find.text('Could not load the contact reply-time setting.'),
      findsOneWidget,
    );
    expect(find.text('Loading setting…'), findsNothing);
    await tester.tap(switchFinder());
    await tester.pump();
    expect(gate.puts, 0);
    await close(tester, fake, state);
  });

  testWidgets('a failed save says so and keeps what the server has', (
    tester,
  ) async {
    final (fake, state, gate) = await open(tester);
    await openSettings(tester);
    gate.fail = true;
    await tester.tap(switchFinder());
    await tester.pumpAndSettle();
    expect(
      find.text('Could not save the contact reply-time setting.'),
      findsOneWidget,
    );
    expect(replySwitch(tester).value, isFalse);
    expect(fake.contactReplyTimeEnabled(FakeAccounts.email), isFalse);

    gate.fail = false;
    await tester.tap(switchFinder());
    await tester.pumpAndSettle();
    expect(
      find.text('Could not save the contact reply-time setting.'),
      findsNothing,
    );
    expect(replySwitch(tester).value, isTrue);
    await close(tester, fake, state);
  });

  testWidgets('another language reads the figure from its own pack', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    await optIn(tester);
    await openContacts(tester);
    expect(find.text(_twoHours), findsOneWidget);
    await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
    await tester.pumpAndSettle();
    expect(find.text(_twoHours), findsNothing);
    expect(
      find.text('Antwortet normalerweise in etwa 2 Stunden'),
      findsOneWidget,
    );
    await close(tester, fake, state);
  });
}
