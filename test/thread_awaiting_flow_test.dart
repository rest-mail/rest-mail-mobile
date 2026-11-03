import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/message_row.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);
  late FakeRestmail fake;
  late AppState state;
  late DateTime now;
  late FakeMessage sent;
  bool closed = false;

  Future<void> open(WidgetTester tester, {String language = 'en'}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    now = DateTime.now().toUtc().subtract(const Duration(days: 2));
    fake = FakeRestmail(scenario: FakeScenario.empty, clock: () => now);
    sent = fake.deliver(
      to: FakeAccounts.email,
      from: FakeAccounts.email,
      subject: 'Unanswered question',
      threadId: 'waiting/1',
    )..folder = 'Sent';
    fake.deliver(
      to: FakeAccounts.email,
      from: 'friend@example.test',
      subject: 'Incoming mail',
    );
    now = now.add(const Duration(days: 2));
    state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    closed = false;
    addTearDown(() {
      if (!closed) {
        state.dispose();
        fake.close();
      }
    });
    await state.start();
    await state.updateSettings(state.settings.copyWith(languageCode: language));
    await state.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
  }

  Future<void> toggle(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilterChip, 'Waiting'));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    closed = true;
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets(
    'waiting filter spans folders, opens the reader, and returns to inbox',
    (tester) async {
      await open(tester);
      expect(find.text('Incoming mail'), findsOneWidget);
      expect(find.text('waiting 2d'), findsNothing);
      await toggle(tester);
      expect(find.text('Incoming mail'), findsNothing);
      expect(find.text('Unanswered question'), findsOneWidget);
      expect(find.text('waiting 2d'), findsOneWidget);
      expect(state.mailbox!.showingWaiting, isTrue);
      await tester.tap(find.text('Unanswered question'));
      await tester.pumpAndSettle();
      expect(find.text('waiting 2d'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await toggle(tester);
      expect(find.text('Incoming mail'), findsOneWidget);
      expect(find.text('waiting 2d'), findsNothing);
      await close(tester);
    },
  );

  testWidgets('search clears waiting, dense rows and reader carry the chip', (
    tester,
  ) async {
    await open(tester);
    await toggle(tester);
    await tester.enterText(find.byType(TextField).first, 'Unanswered');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(state.mailbox!.showingWaiting, isFalse);
    expect(find.text('waiting 2d'), findsOneWidget);
    expect(tester.widget<MessageRow>(find.byType(MessageRow)).dense, isTrue);
    await tester.tap(find.text('Unanswered question'));
    await tester.pumpAndSettle();
    expect(find.text('waiting 2d'), findsOneWidget);
    await close(tester);
  });

  testWidgets(
    'incoming reply removes waiting row, folder change clears filter',
    (tester) async {
      await open(tester);
      await toggle(tester);
      fake
              .deliver(
                to: FakeAccounts.email,
                from: 'friend@example.test',
                subject: 'An answer',
                threadId: sent.threadId,
              )
              .inReplyTo =
          sent.messageId;
      await tester.pumpAndSettle();
      expect(find.text('waiting 2d'), findsNothing);
      expect(find.text('No threads are waiting on a reply.'), findsOneWidget);
      await state.mailbox!.selectFolder('Sent');
      await tester.pumpAndSettle();
      expect(state.mailbox!.showingWaiting, isFalse);
      expect(find.text('Unanswered question'), findsOneWidget);
      expect(find.text('waiting 2d'), findsNothing);
      await close(tester);
    },
  );

  for (final (language, label, age) in [
    ('de', 'Wartend', 'wartet 2d'),
    ('ar', 'بانتظار الرد', 'ينتظر منذ 2 يوم'),
    ('fa', 'در انتظار پاسخ', '2 روز در انتظار'),
    ('hi', 'जवाब की प्रतीक्षा', '2 दिन से प्रतीक्षा'),
    ('ne', 'जवाफ पर्खँदै', '2 दिनदेखि पर्खँदै'),
  ]) {
    testWidgets('waiting controls fit a narrow $language screen', (
      tester,
    ) async {
      await open(tester, language: language);
      tester.view.physicalSize = const Size(960, 2532);
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilterChip, label));
      await tester.pumpAndSettle();
      expect(find.text(age), findsOneWidget);
      expect(tester.takeException(), isNull);
      await close(tester);
    });
  }
}
