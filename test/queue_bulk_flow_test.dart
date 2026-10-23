import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
    String? email,
  }) async {
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
      email: email ?? FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> text(WidgetTester tester, String label) =>
      tap(tester, find.text(label).last);

  Future<void> queue(WidgetTester tester) async {
    await tap(tester, find.byTooltip('Mailboxes'));
    await text(tester, 'Administration');
    await text(tester, 'Outbound queue');
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

  testWidgets('retry selected messages asks first, then opens fresh detail', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final waiting = fake.queue
        .where((entry) => entry.status == 'deferred')
        .toList();
    await queue(tester);
    await text(tester, 'Deferred');
    await text(tester, 'Select messages');
    await text(tester, 'Select loaded messages');
    await text(tester, 'Retry messages');
    await text(tester, 'Cancel');
    expect(waiting.every((entry) => entry.status == 'deferred'), isTrue);
    await text(tester, 'Retry messages');
    await text(tester, 'Retry');
    expect(waiting.every((entry) => entry.status == 'pending'), isTrue);

    await text(tester, 'Pending');
    await text(tester, waiting.first.recipient);
    expect(find.text('Queue ID'), findsOneWidget);
    expect(find.text('8BITMIME'), findsOneWidget);
    await close(tester, fake, state);
  });

  testWidgets('all matches uses the applied filter and supports cancellation', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final sender = fake.queue.first.sender;
    final matches = fake.queue
        .where((entry) => entry.sender.toLowerCase() == sender.toLowerCase())
        .length;
    final count = fake.queue.length;
    await queue(tester);
    await text(tester, 'Filter queue');
    await tester.enterText(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Sender',
      ),
      sender.toUpperCase(),
    );
    await text(tester, 'Apply filters');
    await text(tester, 'Select messages');
    await text(tester, 'All matching entries');
    await text(tester, 'Delete messages');
    await text(tester, 'Cancel');
    expect(fake.queue.length, count);
    await text(tester, 'Delete messages');
    await text(tester, 'Delete');
    expect(fake.queue.length, count - matches);
    expect(
      fake.queue.every(
        (entry) => entry.sender.toLowerCase() != sender.toLowerCase(),
      ),
      isTrue,
    );
    await close(tester, fake, state);
  });

  testWidgets('a queue reader sees filters and no bulk controls', (
    tester,
  ) async {
    final (fake, state) = await open(tester, email: FakeAccounts.queueWatcher);
    await queue(tester);
    expect(find.text('Filter queue'), findsOneWidget);
    expect(find.text('Select messages'), findsNothing);
    await close(tester, fake, state);
  });
}
