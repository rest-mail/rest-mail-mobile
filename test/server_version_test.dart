import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The mailbox's settings say which server it is on and the version it runs.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets('the footer names the host and the REST Mail version', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()..serverVersion = '0.22.0';
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

    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailbox settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(FakeAccounts.email).last);
    await tester.pumpAndSettle();

    final footer = find.textContaining(
      '${FakeAccounts.host} · REST Mail 0.22.0',
    );
    await tester.scrollUntilVisible(
      footer,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(footer, findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });
}
