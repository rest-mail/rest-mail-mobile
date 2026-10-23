import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The vacation reply and mail filters under Settings → the mailbox, against
/// the fake.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
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

  Future<void> tap(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text).last);

  /// Lets a toast clear: it sits over the bottom of the screen.
  Future<void> settleToast(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  /// Settings → the mailbox → [row].
  Future<void> openRow(WidgetTester tester, String row) async {
    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await tapText(tester, FakeAccounts.email);
    await tapText(tester, row);
  }

  testWidgets('the vacation reply is turned on with its subject and message, '
      'and off again', (tester) async {
    final (fake, state) = await open(tester);
    await openRow(tester, 'Vacation reply');
    expect(find.text('Send a vacation reply'), findsOneWidget);

    // On, without a subject or message: refused, and said why.
    await tap(tester, find.byType(RmSwitch));
    await tapText(tester, 'Save');
    expect(
      find.text('Add a subject and a message to turn the reply on.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).at(0), 'Away');
    await tester.enterText(find.byType(TextField).at(1), 'Back on Monday.');
    await tester.pump();
    await tapText(tester, 'Save');
    expect(find.text('Vacation reply is on'), findsOneWidget);
    final reply = fake.vacationOf(FakeAccounts.email)!;
    expect(reply['enabled'], isTrue);
    expect(reply['subject'], 'Away');
    expect(reply['body'], 'Back on Monday.');
    await settleToast(tester);

    // Opened again, it shows what was saved; turned off, it keeps it.
    await tapText(tester, 'Vacation reply');
    expect(find.text('Away'), findsOneWidget);
    await tap(tester, find.byType(RmSwitch));
    await tapText(tester, 'Save');
    expect(find.text('Vacation reply is off'), findsOneWidget);
    expect(fake.vacationOf(FakeAccounts.email)!['enabled'], isFalse);
    expect(fake.vacationOf(FakeAccounts.email)!['subject'], 'Away');

    await close(tester, fake, state);
  });

  testWidgets('a Sieve script is checked, refused with the parser\'s message, '
      'saved and deleted', (tester) async {
    final (fake, state) = await open(tester);
    await openRow(tester, 'Mail filters');
    expect(find.text('Delete filters'), findsNothing);

    final editor = find.byType(TextField).first;
    await tester.enterText(editor, 'if true { fileinto "Later"; }');
    await tester.pump();
    await tapText(tester, 'Check');
    expect(find.textContaining('add: require "fileinto";'), findsOneWidget);

    // Saving it is refused the same way, and nothing is stored.
    await tapText(tester, 'Save');
    expect(find.textContaining('add: require "fileinto";'), findsOneWidget);
    expect(fake.sieveScriptOf(FakeAccounts.email), isNull);

    const script = 'require "fileinto";\nif true { fileinto "Later"; }';
    await tester.enterText(editor, script);
    await tester.pump();
    await tapText(tester, 'Check');
    expect(find.text('Script is valid'), findsOneWidget);
    await tapText(tester, 'Save');
    expect(find.text('Filters saved'), findsOneWidget);
    expect(fake.sieveScriptOf(FakeAccounts.email)!['script'], script);
    expect(fake.sieveScriptOf(FakeAccounts.email)!['active'], isTrue);
    await settleToast(tester);

    await tapText(tester, 'Mail filters');
    expect(find.text(script), findsOneWidget);
    await tapText(tester, 'Delete filters');
    expect(find.text('Delete the filters?'), findsOneWidget);
    await tapText(tester, 'Delete');
    expect(find.text('Filters deleted'), findsOneWidget);
    expect(fake.sieveScriptOf(FakeAccounts.email), isNull);

    await close(tester, fake, state);
  });
}
