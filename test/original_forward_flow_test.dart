import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/original_forward_sheet.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, RestmailClient, Future<void> Function())> open(
    WidgetTester tester, {
    bool discard = false,
    int maxBytes = 10 * 1024 * 1024,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(
      scenario: FakeScenario.empty,
      discardForwards: discard,
      maxForwardMessageBytes: maxBytes,
    );
    fake.deliver(
      to: FakeAccounts.email,
      from: 'ada@example.test',
      subject: 'Forward attachment fixture',
      body: 'original receipt',
      attachments: [
        FakeAttachment(
          filename: 'invoice.bin',
          contentType: 'application/octet-stream',
          bytes: [0, 255, 42],
        ),
      ],
    );
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    final client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    // Widget-test invariants run before addTearDown callbacks. Close the
    // live event stream inside the test body so its silence timer is gone.
    Future<void> close() async {
      await tester.pumpWidget(const SizedBox());
      client.close();
      state.dispose();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    }

    await tester.tap(find.text('Forward attachment fixture').last);
    await tester.pumpAndSettle();
    final forward = find.text('Forward');
    await tester.tap(
      tester.any(forward) ? forward.last : find.byTooltip('Forward'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OriginalForwardSheet), findsOneWidget);
    expect(find.text('Attachments'), findsWidgets);
    return (fake, client, close);
  }

  Future<void> fill(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const ValueKey('forward-to')),
      'reader@example.test',
    );
    await tester.enterText(
      find.byKey(const ValueKey('forward-note')),
      'Please review',
    );
  }

  Future<List<Message>> sent(RestmailClient client) async {
    final account = (await client.accounts()).firstWhere((a) => a.isPrimary);
    return (await client.messages(account.id, StandardFolder.sent)).items;
  }

  Future<void> send(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('forward-send')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'reader forwards its original attachments with only the new note',
    (tester) async {
      final (_, client, close) = await open(tester);
      try {
        await fill(tester);
        await send(tester);
        expect(find.byType(OriginalForwardSheet), findsNothing);
        final messages = await sent(client);
        expect(messages, hasLength(1));
        expect(
          messages.single.bodyText,
          startsWith(
            'Please review\n\n---------- Forwarded message ----------',
          ),
        );
        expect(
          'original receipt'.allMatches(messages.single.bodyText!).length,
          1,
        );
        final parts = await client.attachments(messages.single.id);
        expect(parts.single.filename, 'invoice.bin');
        expect(await client.downloadAttachment(parts.single.id), [0, 255, 42]);
      } finally {
        await close();
      }
    },
  );

  testWidgets('undo cancels the forward without losing the note', (
    tester,
  ) async {
    final (_, client, close) = await open(tester);
    try {
      await fill(tester);
      await tester.tap(find.byKey(const ValueKey('forward-send')));
      await tester.pump();
      await tester.tap(find.text('Undo'));
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expect(await sent(client), isEmpty);
      expect(find.byType(OriginalForwardSheet), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('forward-note')))
            .controller!
            .text,
        'Please review',
      );
    } finally {
      await close();
    }
  });

  testWidgets(
    'size refusal keeps recipients and note and stores no replacement send',
    (tester) async {
      final (_, client, close) = await open(tester, maxBytes: 100);
      try {
        await fill(tester);
        await send(tester);
        expect(find.byType(OriginalForwardSheet), findsOneWidget);
        expect(find.byType(ErrorText), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('forward-to')))
              .controller!
              .text,
          'reader@example.test',
        );
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('forward-note')))
              .controller!
              .text,
          'Please review',
        );
        expect(await sent(client), isEmpty);
      } finally {
        await close();
      }
    },
  );

  testWidgets('policy discard is not reported as a sent message', (
    tester,
  ) async {
    final (_, client, close) = await open(tester, discard: true);
    try {
      await fill(tester);
      await send(tester);
      expect(find.byType(OriginalForwardSheet), findsNothing);
      expect(
        find.text('Forward discarded by the server’s mail policy.'),
        findsOneWidget,
      );
      expect(find.text('Message sent'), findsNothing);
      expect(await sent(client), isEmpty);
    } finally {
      await close();
    }
  });
}
