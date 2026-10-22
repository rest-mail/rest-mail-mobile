import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('a private note is added, edited, kept, and removed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    final state = AppState(store: store, httpClientFactory: () => fake.client);
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    Future<void> openMessage() async {
      await tester.tap(find.text('Re: sync latency on flaky networks'));
      await tester.pumpAndSettle();
    }

    await openMessage();
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add note'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Call Nadia back about the migration',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    const first = 'Call Nadia back about the migration';
    expect(find.text(first), findsOneWidget);
    expect(store.values.values, contains(first));

    // It is on this phone, not the server: reopen and it is still there.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await openMessage();
    expect(find.text(first), findsOneWidget);

    // Edit it from the note card.
    await tester.tap(find.byTooltip('Edit note'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Ask about the new relay',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Ask about the new relay'), findsOneWidget);
    expect(find.text(first), findsNothing);

    // Remove it.
    await tester.tap(find.byTooltip('Edit note'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Ask about the new relay'), findsNothing);
    expect(
      store.values.values.where((value) => value == 'Ask about the new relay'),
      isEmpty,
    );

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
