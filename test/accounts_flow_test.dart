import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/ui/mailboxes_screen.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// From the Add account screen: the address, the server (found from it, or
/// typed in when [server] is given), the password, Continue.
Future<void> _signIn(
  WidgetTester tester,
  String email, {
  String? server,
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.pump(const Duration(milliseconds: 600)); // past the debounce
  await tester.pumpAndSettle();
  if (server != null) {
    await tester.tap(find.text('Configure manually'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), server);
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use this server'));
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Folders and accounts'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
}

/// Replies to [subject] in the folder on screen and comes back to it.
Future<void> _reply(WidgetTester tester, String subject) async {
  await tester.tap(find.text(subject));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Reply'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Send'));
  await tester.pumpAndSettle();
  expect(find.text('Message sent'), findsOneWidget);
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('two accounts at once: switch from the drawer and from '
      'Settings, send from each, sign out of one', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await _signIn(tester, FakeAccounts.email);
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);

    // A second account, from Settings.
    await _openSettings(tester);
    expect(find.text('OTHER ACCOUNTS'), findsOneWidget);
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    // Its domain has no server of its own: it is served from the first's.
    await _signIn(tester, FakeAccounts.otherEmail, server: FakeAccounts.host);
    expect(find.text('Live · ${FakeAccounts.otherEmail}'), findsOneWidget);
    expect(state.accounts, hasLength(2));

    await _reply(tester, 'Rota for next week');
    expect(
      fake.messagesIn(FakeAccounts.otherEmail, 'Sent').single.subject,
      'Re: Rota for next week',
    );

    // Back to the first, from the drawer.
    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(MailboxesScreen),
        matching: find.text(FakeAccounts.email),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(MailboxesScreen),
        matching: find.text('Inbox'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);
    // The other account's snackbar stayed with it.
    expect(find.text('Message sent'), findsNothing);

    await _reply(tester, 'Re: sync latency on flaky networks');
    expect(
      fake.messagesIn(FakeAccounts.email, 'Sent').last.subject,
      'Re: sync latency on flaky networks',
    );

    // And to the second again, from Settings.
    await _openSettings(tester);
    await tester.tap(find.text(FakeAccounts.otherEmail));
    await tester.pumpAndSettle();
    expect(find.text('Live · ${FakeAccounts.otherEmail}'), findsOneWidget);

    // Signing out ends only the session and keeps the account on the phone.
    await _openSettings(tester);
    await tester.tap(find.text(FakeAccounts.otherEmail));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Your other accounts stay signed in.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Sign out').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(state.phase, AppPhase.signedIn);
    expect(
      [for (final a in state.accounts) a.address],
      [FakeAccounts.email, FakeAccounts.otherEmail],
    );
    expect(state.current!.signedOut, isNotNull);
    expect(find.text('Signed out · ${FakeAccounts.host}'), findsOneWidget);
    expect(
      find.text('Signed out of ${FakeAccounts.otherEmail}'),
      findsOneWidget,
    );

    // Close the event streams so no timer outlives the test.
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('an account whose session ends stays, signed out: it says why, '
      'signs in again where it is, or comes off the phone', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await _signIn(tester, FakeAccounts.email);
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);

    fake.revokeSessionsOf(FakeAccounts.email);
    await tester.tap(find.byTooltip('Refresh'));
    await tester.pumpAndSettle();

    expect(state.accounts, hasLength(1));
    expect(
      find.text(
        'Your session for ${FakeAccounts.email} ended. Sign in again to '
        'carry on.',
      ),
      findsOneWidget,
    );
    expect(find.text('Signed out · ${FakeAccounts.email}'), findsOneWidget);
    expect(find.byTooltip('New message'), findsNothing);
    expect(find.byTooltip('Search'), findsNothing);

    // The address and the server are filled in: the password is all it
    // takes.
    await tester.tap(find.text('Sign in again'));
    await tester.pumpAndSettle();
    expect(find.text('Using ${FakeAccounts.host}'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);
    expect(state.accounts, hasLength(1));
    expect(state.current!.signedOut, isNull);

    fake.revokeSessionsOf(FakeAccounts.email);
    await tester.tap(find.byTooltip('Refresh'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from this phone'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Your mail stays on ${FakeAccounts.host}.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(state.accounts, isEmpty);
    expect(state.phase, AppPhase.signedOut);
    expect(find.text('Add an account'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('the mailboxes screen shows the account at a glance, and Back '
      'returns to its mail', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await _signIn(tester, FakeAccounts.email);

    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();

    expect(find.byType(MailboxesScreen), findsOneWidget);
    expect(find.text('THIS ACCOUNT'), findsOneWidget);
    expect(find.text(FakeAccounts.email), findsWidgets);
    expect(find.text('Inbox unread'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(MailboxesScreen), findsNothing);
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
