import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// Forwarding the original from a message's More menu, against the fake.
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

  testWidgets('Forward original sends from the More menu', (tester) async {
    final (fake, state) = await open(tester);
    await tester.tap(find.text(subject).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forward original').last);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'bob@restmail.test');
    await tester.tap(find.text('Forward'));
    await tester.pumpAndSettle();
    expect(find.text('Original message forwarded'), findsOneWidget);
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'Sent')
          .where((m) => m.subject == 'Fwd: $subject')
          .single
          .subject,
      'Fwd: $subject',
    );

    await close(tester, fake, state);
  });
}
