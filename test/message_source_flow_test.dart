import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A message's source from its More menu, against the fake.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const subject = 'Re: sync latency on flaky networks';

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

  Future<void> viewSource(WidgetTester tester) async {
    await tester.tap(find.text(subject).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View source').last);
    await tester.pumpAndSettle();
  }

  testWidgets('the source shows its headers, with a way to share it', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    await viewSource(tester);
    expect(find.text('Message source'), findsOneWidget);
    expect(find.textContaining('Subject: $subject'), findsOneWidget);
    expect(find.textContaining('MIME-Version: 1.0'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a message with no source kept says so', (tester) async {
    final (fake, state) = await open(tester);
    fake
            .messagesIn(FakeAccounts.email, 'INBOX')
            .firstWhere((m) => m.subject == subject)
            .raw =
        '';
    await viewSource(tester);
    expect(
      find.text('The server kept no source for this message.'),
      findsOneWidget,
    );
    expect(find.text('Share'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);

    await close(tester, fake, state);
  });
}
