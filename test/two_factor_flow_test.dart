import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail/util/secret_clipboard.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<void> tapText(WidgetTester tester, String label) async {
    final target = find.text(label);
    for (final step in const [300.0, -300.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, step));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target.last);
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<(FakeRestmail, AppState, MemoryKeyValueStore)> open(
    WidgetTester tester, {
    FakeRestmail? fake,
    String email = FakeAccounts.email,
    String password = FakeAccounts.password,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    fake ??= FakeRestmail();
    final store = MemoryKeyValueStore();
    final state = AppState(store: store, httpClientFactory: () => fake!.client);
    await state.start();
    await state.signIn(
      server: _server,
      email: email,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailbox settings'));
    await tester.pumpAndSettle();
    await tapText(tester, email);
    return (fake, state, store);
  }

  Future<void> code(WidgetTester tester, String value) async {
    final field = find.byKey(const ValueKey('two-factor-code'));
    await tester.scrollUntilVisible(
      field,
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(field, value);
    await tester.pump();
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

  testWidgets(
    'enroll, save codes, retry a wrong code, hide secrets and confirm',
    (tester) async {
      final (fake, state, _) = await open(tester);
      final copies = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SecretClipboard.channel,
        (call) async {
          copies.add(call);
          return true;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SecretClipboard.channel,
          null,
        ),
      );
      await tapText(tester, 'Two-factor sign-in');
      expect(find.text('Off'), findsOneWidget);
      await tapText(tester, 'Set up authenticator');
      expect(find.text(FakeAccounts.totpSecret), findsOneWidget);
      await tapText(tester, 'Copy setup key');
      expect(copies.single.method, 'copy');
      expect(copies.single.arguments, {
        'text': FakeAccounts.totpSecret,
        'seconds': 120,
      });
      await tapText(tester, 'Copy recovery codes');
      expect(copies.last.arguments, {
        'text': FakeAccounts.recoveryCode,
        'seconds': 120,
      });
      await code(tester, '000000');
      final confirm = tester.widget<RmPrimaryButton>(
        find.ancestor(
          of: find.text('Confirm authenticator'),
          matching: find.byType(RmPrimaryButton),
        ),
      );
      expect(confirm.onPressed, isNull);
      await tapText(tester, "I've saved my recovery codes");
      await tapText(tester, 'Confirm authenticator');
      expect(
        find.text("That authenticator code didn't work. Try a current code."),
        findsOneWidget,
      );
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(find.text(FakeAccounts.totpSecret), findsNothing);
      expect(find.text(FakeAccounts.recoveryCode), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      await code(tester, FakeAccounts.totpCode);
      await tapText(tester, 'Confirm authenticator');
      expect(find.text('On'), findsOneWidget);
      expect(find.text(FakeAccounts.totpSecret), findsNothing);
      expect(find.text('Sign in again'), findsOneWidget);
      expect(
        (await (state.current! as RestAccount).client.twoFactorStatus())
            .enabled,
        isTrue,
      );
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'pending enrollment is shown without secrets and can be restarted',
    (tester) async {
      final (fake, state, _) = await open(tester);
      await (state.current! as RestAccount).client.enrollTwoFactor();
      await tapText(tester, 'Two-factor sign-in');
      expect(find.text('Not confirmed'), findsOneWidget);
      expect(find.text(FakeAccounts.totpSecret), findsNothing);
      await tapText(tester, 'Restart enrollment');
      expect(find.text(FakeAccounts.totpSecret), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets('wrong disable code and cancel leave sessions signed in', (
    tester,
  ) async {
    final (fake, state, _) = await open(
      tester,
      fake: FakeRestmail(scenario: FakeScenario.twoFactor),
    );
    final tokens = (state.current! as RestAccount).client.tokens;
    await tapText(tester, 'Two-factor sign-in');
    await tapText(tester, 'Turn off two-factor sign-in');
    await code(tester, '000000');
    await tapText(tester, 'Turn off and sign out');
    await tapText(tester, 'Turn off and sign out');
    expect(
      find.text("That authenticator code didn't work. Try a current code."),
      findsOneWidget,
    );
    expect((state.current! as RestAccount).client.tokens, same(tokens));
    await code(tester, FakeAccounts.totpCode);
    await tapText(tester, 'Turn off and sign out');
    await tapText(tester, 'Cancel');
    expect(
      (await (state.current! as RestAccount).client.twoFactorStatus()).enabled,
      isTrue,
    );
    expect((state.current! as RestAccount).client.tokens, same(tokens));
    await close(tester, fake, state);
  });

  testWidgets(
    'confirmed disable clears the saved pair and stays signed out after reopening',
    (tester) async {
      final (fake, state, store) = await open(
        tester,
        fake: FakeRestmail(scenario: FakeScenario.twoFactor),
      );
      final account = state.current! as RestAccount;
      await tapText(tester, 'Two-factor sign-in');
      await tapText(tester, 'Turn off two-factor sign-in');
      await code(tester, FakeAccounts.totpCode);
      await tapText(tester, 'Turn off and sign out');
      await tapText(tester, 'Turn off and sign out');
      expect(account.client.tokens, isNull);
      expect(state.current!.signedOut, isNotNull);
      final saved = jsonDecode(
        store.values['account:${account.key}']!,
      ) as Map<String, dynamic>;
      expect(saved['tokens'], isNull);
      final restored = AppState(
        store: store,
        httpClientFactory: () => fake.client,
      );
      await restored.start();
      expect(restored.current!.signedOut, isNotNull);
      expect((restored.current! as RestAccount).client.tokens, isNull);
      restored.dispose();
      await state.signIn(
        server: _server,
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await tester.pumpAndSettle();
      expect(state.current!.signedOut, isNull);
      await close(tester, fake, state);
    },
  );

  testWidgets('unused recovery proof is obscured and can disable 2FA', (
    tester,
  ) async {
    final (fake, state, _) = await open(
      tester,
      fake: FakeRestmail(scenario: FakeScenario.twoFactor),
    );
    await tapText(tester, 'Two-factor sign-in');
    await tapText(tester, 'Turn off two-factor sign-in');
    await tapText(tester, 'Recovery code');
    await code(tester, FakeAccounts.recoveryCode);
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('two-factor-code')))
          .obscureText,
      isTrue,
    );
    await tapText(tester, 'Turn off and sign out');
    await tapText(tester, 'Turn off and sign out');
    expect((state.current! as RestAccount).client.tokens, isNull);
    await close(tester, fake, state);
  });

  testWidgets('mandatory 2FA explains the server refusal without signing out', (
    tester,
  ) async {
    final fake = FakeRestmail();
    final email = 'required@${fake.host}';
    fake.addAccount(email, twoFactorRequired: true);
    final (_, state, _) = await open(
      tester,
      fake: fake,
      email: email,
      password: FakeAccounts.adminPassword,
    );
    await tapText(tester, 'Two-factor sign-in');
    await tapText(tester, 'Turn off two-factor sign-in');
    await code(tester, FakeAccounts.totpCode);
    await tapText(tester, 'Turn off and sign out');
    await tapText(tester, 'Turn off and sign out');
    expect(
      find.text(
        'This account must keep two-factor sign-in. The server will not turn it off.',
      ),
      findsOneWidget,
    );
    expect(
      (await (state.current! as RestAccount).client.twoFactorStatus()).enabled,
      isTrue,
    );
    expect(state.current!.signedOut, isNull);
    await close(tester, fake, state);
  });

  testWidgets(
    'failed status refresh removes stale controls and retry restores them',
    (tester) async {
      final (fake, state, _) = await open(
        tester,
        fake: FakeRestmail(scenario: FakeScenario.twoFactor),
      );
      await tapText(tester, 'Two-factor sign-in');
      expect(find.text('Turn off two-factor sign-in'), findsOneWidget);
      fake.online = false;
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator).last)
          .onRefresh();
      await tester.pumpAndSettle();
      expect(find.text('Turn off two-factor sign-in'), findsNothing);
      expect(find.text('Try again'), findsOneWidget);
      expect(state.current!.signedOut, isNull);
      fake.online = true;
      await tapText(tester, 'Try again');
      expect(find.text('Turn off two-factor sign-in'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets('linked mailbox settings cannot manage the owner authenticator', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    expect(find.text('Two-factor sign-in'), findsOneWidget);
    await tester.tap(find.byTooltip('Back').last);
    await tester.pumpAndSettle();
    await tapText(tester, FakeAccounts.otherEmail);
    expect(find.text('App passwords'), findsOneWidget);
    expect(find.text('Two-factor sign-in'), findsNothing);
    await close(tester, fake, state);
  });
}
