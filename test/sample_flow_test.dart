import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('sign in, read, reply, and the reply lands in Sent', (
    tester,
  ) async {
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
    await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
    await tester.pump(const Duration(milliseconds: 600)); // past the debounce
    await tester.pumpAndSettle();
    expect(find.text('Found ${FakeAccounts.host}'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(state.phase, AppPhase.signedIn);
    expect(find.text('Live · ${FakeAccounts.email}'), findsOneWidget);

    await tester.tap(find.text('Re: sync latency on flaky networks'));
    await tester.pumpAndSettle();
    // Below the body, so possibly under the fold of the test's screen.
    expect(find.text('backoff-bench.pdf', skipOffstage: false), findsOneWidget);

    await tester.tap(find.text('Reply'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Message sent'), findsOneWidget);
    final reply = fake.messagesIn(FakeAccounts.email, 'Sent').last;
    expect(reply.subject, 'Re: sync latency on flaky networks');
    expect(reply.to.single.address, 'nadia@oakline.test');
    expect(reply.inReplyTo, isNotNull);

    // Close the event stream so no timer outlives the test.
    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
