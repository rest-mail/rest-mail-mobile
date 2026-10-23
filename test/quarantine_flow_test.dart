import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// Answers the quarantine list with a server error when [failing] is set, and
/// passes everything else to the fake.
class _FlakyQuarantine extends http.BaseClient {
  _FlakyQuarantine(this.inner);
  final http.Client inner;
  bool failing = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (failing &&
        request.method == 'GET' &&
        request.url.path.endsWith('/quarantine')) {
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode({
              'error': {'code': 'internal_error', 'message': 'Database down'},
            }),
          ),
        ),
        500,
        headers: {'content-type': 'application/json'},
      );
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, _FlakyQuarantine)> open(
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final transport = _FlakyQuarantine(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => transport,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state, transport);
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

  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Lets a toast clear: it sits over the bottom of the screen.
  Future<void> settleToast(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  Future<void> openQuarantine(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tap(tester, 'Quarantine');
  }

  testWidgets('held mail is counted, explained, released into the inbox and '
      'deleted', (tester) async {
    final (fake, state, _) = await open(tester);
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    // The Mailboxes row says how many are held.
    expect(find.text('Quarantine'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    await tap(tester, 'Quarantine');

    expect(find.text('2 HELD'), findsOneWidget);
    expect(find.text('You have been selected'), findsOneWidget);
    expect(find.text('Scored as spam · prizes@winner.test'), findsOneWidget);
    expect(find.text('Failed DMARC · billing@paypa1.test'), findsOneWidget);

    // One held message, explained, then released.
    await tap(tester, 'You have been selected');
    expect(find.text('Scored as spam'), findsOneWidget);
    expect(
      find.text('The spam filter scored it above the line.'),
      findsOneWidget,
    );
    expect(find.text('9.4'), findsOneWidget);
    expect(
      find.text('Claim your reward today by confirming your card details.'),
      findsOneWidget,
    );
    await tap(tester, 'Release to inbox');
    expect(find.text('1 HELD'), findsOneWidget);
    expect(find.text('You have been selected'), findsNothing);
    expect(fake.quarantined, hasLength(1));
    expect(
      fake.messagesIn(FakeAccounts.email, 'INBOX').map((m) => m.subject),
      contains('You have been selected'),
    );
    await settleToast(tester);

    // The other, deleted after asking.
    await tap(tester, 'Your account is limited');
    await tap(tester, 'Delete');
    expect(find.text('Delete this message?'), findsOneWidget);
    await tap(tester, 'Delete');
    expect(fake.quarantined, isEmpty);
    expect(find.text('Nothing is held back.'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('several at once: select, delete, and the empty state', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    await openQuarantine(tester);

    await tap(tester, 'Select');
    await tap(tester, 'You have been selected');
    await tap(tester, 'Your account is limited');
    expect(find.text('Delete 2'), findsOneWidget);
    await tap(tester, 'Delete 2');
    expect(find.text('Delete 2 messages?'), findsOneWidget);
    await tap(tester, 'Delete');
    expect(fake.quarantined, isEmpty);
    expect(find.text('Nothing is held back.'), findsOneWidget);
    expect(find.text('Select'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('held mail is explained in the language the app is set to', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Postfächer'));
    await tester.pumpAndSettle();
    await tap(tester, 'Quarantäne');

    expect(find.text('2 ZURÜCKGEHALTEN'), findsOneWidget);
    expect(find.text('Als Spam bewertet · prizes@winner.test'), findsOneWidget);
    expect(find.text('Auswählen'), findsOneWidget);
    await tap(tester, 'You have been selected');
    expect(find.text('Zurückgehaltene Nachricht'), findsOneWidget);
    expect(
      find.text('Der Spamfilter hat sie über der Grenze bewertet.'),
      findsOneWidget,
    );
    expect(find.text('In den Posteingang freigeben'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a list the server cannot give says so, and tries again', (
    tester,
  ) async {
    final (fake, state, transport) = await open(tester);
    transport.failing = true;
    await openQuarantine(tester);
    expect(find.text('Database down'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    transport.failing = false;
    await tap(tester, 'Try again');
    expect(find.text('2 HELD'), findsOneWidget);

    await close(tester, fake, state);
  });
}
