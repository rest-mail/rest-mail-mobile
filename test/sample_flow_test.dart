import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/interface_prefs.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/compose_sheet.dart';
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

  testWidgets('a new message waits, and Undo takes the send back', (
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
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    final sentBefore = fake.messagesIn(FakeAccounts.email, 'Sent').length;
    await tester.enterText(
      find
          .descendant(
            of: find.byType(ComposeSheet),
            matching: find.byType(TextField),
          )
          .first,
      'nadia@oakline.test',
    );
    await tester.pump();

    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Sending in 5s'), findsOneWidget);
    expect(fake.messagesIn(FakeAccounts.email, 'Sent'), hasLength(sentBefore));

    await tester.tap(find.text('Undo'));
    await tester.pump();
    expect(find.text('Sending in 5s'), findsNothing);
    expect(find.text('Send'), findsOneWidget);
    expect(fake.messagesIn(FakeAccounts.email, 'Sent'), hasLength(sentBefore));

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Message sent'), findsOneWidget);
    expect(
      fake.messagesIn(FakeAccounts.email, 'Sent'),
      hasLength(sentBefore + 1),
    );

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('the Send later panel holds the message, and Undo cancels it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    await store.write(
      'settings',
      const AppSettings(
        interface: InterfacePrefs(enabled: {'composer_later': true}),
      ).encode(),
    );
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

    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    final sentBefore = fake.messagesIn(FakeAccounts.email, 'Sent').length;
    await tester.enterText(
      find
          .descendant(
            of: find.byType(ComposeSheet),
            matching: find.byType(TextField),
          )
          .first,
      'nadia@oakline.test',
    );
    await tester.pump();

    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();
    expect(find.text('Send later'), findsOneWidget);
    await tester.tap(find.text('In an hour'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Scheduled for'), findsOneWidget);
    expect(fake.scheduledFrom(FakeAccounts.email), hasLength(1));
    expect(fake.messagesIn(FakeAccounts.email, 'Sent'), hasLength(sentBefore));

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(fake.scheduledFrom(FakeAccounts.email), isEmpty);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('a bulk domain opens the unsubscribe fields, and the message '
      'goes with them', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    fake.domains.firstWhere((d) => d.name == FakeAccounts.host).sendingPolicy =
        'bulk';
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
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

    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    final sentBefore = fake.messagesIn(FakeAccounts.email, 'Sent').length;
    await tester.enterText(
      find
          .descendant(
            of: find.byType(ComposeSheet),
            matching: find.byType(TextField),
          )
          .first,
      'nadia@oakline.test',
    );
    await tester.pump();
    // The panel is off, so the fields are not there until the domain asks.
    expect(find.text('Opt-out'), findsNothing);

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Message sent'), findsNothing);
    expect(find.text('Opt-out'), findsOneWidget);
    expect(fake.messagesIn(FakeAccounts.email, 'Sent'), hasLength(sentBefore));

    await tester.enterText(
      find.widgetWithText(TextField, 'Unsubscribe address'),
      'leave@restmail.test',
    );
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Message sent'), findsOneWidget);
    expect(
      fake.messagesIn(FakeAccounts.email, 'Sent'),
      hasLength(sentBefore + 1),
    );

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
