import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('scheduled messages are listed, and each can be cancelled', (
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

    final at = DateTime.now().add(const Duration(hours: 2));
    final backend = state.mailbox!.backend;
    await backend.schedule(
      OutgoingMessage(
        from: FakeAccounts.email,
        to: [FakeAccounts.email],
        subject: 'Later one',
        bodyText: 'body',
      ),
      at,
    );
    await backend.schedule(
      OutgoingMessage(
        from: FakeAccounts.email,
        to: [FakeAccounts.email],
        subject: 'Later two',
        bodyText: 'body',
      ),
      at.add(const Duration(hours: 1)),
    );

    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Scheduled'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Scheduled'));
    await tester.pumpAndSettle();

    expect(find.text('Later one'), findsOneWidget);
    expect(find.text('Later two'), findsOneWidget);
    expect(fake.scheduledFrom(FakeAccounts.email), hasLength(2));

    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    expect(find.text('Later one'), findsNothing);
    expect(find.text('Later two'), findsOneWidget);
    expect(fake.scheduledFrom(FakeAccounts.email), hasLength(1));

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing is waiting to be sent.'), findsOneWidget);
    expect(fake.scheduledFrom(FakeAccounts.email), isEmpty);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
