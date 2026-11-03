import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/recover_account_screen.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The external recovery email from settings, and its link on the forgotten
/// password path, against the fake.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const account = FakeAccounts.email, password = FakeAccounts.password;
  const backup = 'backup@external.test';
  final server = Uri.parse('https://${FakeAccounts.host}');

  final address = find.byKey(const ValueKey('recoveryEmail.address'));
  final current = find.byKey(const ValueKey('recoveryEmail.currentPassword'));

  Future<void> tapText(WidgetTester tester, String label) async {
    final target = find.text(label);
    for (final step in const [300.0, -300.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, step));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target.last);
    await tester.pumpAndSettle();
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
    FakeRestmail? fake,
    bool enterScreen = true,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    fake ??= FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake!.client,
    );
    await state.start();
    await state.signIn(
      server: server,
      email: account,
      password: password,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailbox settings'));
    await tester.pumpAndSettle();
    await tapText(tester, account);
    if (enterScreen) await tapText(tester, 'Recovery email');
    return (fake, state);
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> send(
    WidgetTester tester, {
    String email = backup,
    String with_ = password,
  }) async {
    await tester.ensureVisible(address);
    await tester.enterText(address, email);
    await tester.enterText(current, with_);
    await tester.pump();
    await tapText(tester, 'Send verification link');
  }

  Future<void> openLink(FakeRestmail fake, FakeRecoveryMail mail) async {
    final response = await fake.client.post(
      Uri.parse('https://${fake.host}/api/v1/auth/recovery-email/verify'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'token': mail.token}),
    );
    expect(response.statusCode, 200);
  }

  group('settings', () {
    testWidgets('none, add, pending, check, verified, change', (tester) async {
      final (fake, state) = await open(tester);
      expect(find.text('None'), findsOneWidget);
      expect(address, findsOneWidget);
      expect(find.text('Cancel'), findsNothing);
      expect(find.text('Waiting for verification'), findsNothing);
      // Removing is not on offer: the server has no such route.
      expect(find.textContaining('Remove'), findsNothing);

      // Pending, and it tells the person where the link went.
      await send(tester);
      expect(find.text('Waiting for verification'), findsOneWidget);
      expect(find.text(backup), findsOneWidget);
      expect(find.textContaining('Open the link sent to $backup'), findsOne);
      expect(
        find.text(
          'Verification link sent. The address cannot recover your account '
          'until verified.',
        ),
        findsOneWidget,
      );
      expect(address, findsNothing);
      expect(fake.recoveryEmailOf(account)!.verified, isFalse);
      expect(fake.recoveryMail.single.to, backup);

      // Still pending until the link is opened.
      await tapText(tester, 'Check again');
      expect(find.text('Waiting for verification'), findsOneWidget);
      await openLink(fake, fake.recoveryMail.single);
      await tapText(tester, 'Check again');
      expect(find.text('Verified'), findsOneWidget);
      expect(find.text('Waiting for verification'), findsNothing);
      expect(find.textContaining('Verification link sent'), findsNothing);

      // Changing warns first, and can be cancelled.
      await tapText(tester, 'Change address');
      expect(
        find.textContaining('Changing the address clears its verification'),
        findsOneWidget,
      );
      await tapText(tester, 'Cancel');
      expect(find.text('Verified'), findsOneWidget);
      expect(address, findsNothing);

      await tapText(tester, 'Change address');
      await send(tester, email: 'other@external.test');
      expect(find.text('Waiting for verification'), findsOneWidget);
      expect(find.text('other@external.test'), findsOneWidget);
      expect(fake.recoveryEmailOf(account)!.address, 'other@external.test');

      await close(tester, fake, state);
    });

    testWidgets('a pending address can have a new link sent', (tester) async {
      final fake = FakeRestmail()
        ..setRecoveryEmail(account, backup, verified: false);
      final (_, state) = await open(tester, fake: fake);
      await tapText(tester, 'Send a new link or change address');
      expect(tester.widget<TextField>(address).controller!.text, backup);
      expect(tester.widget<TextField>(current).controller!.text, isEmpty);
      await send(tester);
      expect(fake.recoveryMail, hasLength(1));
      expect(find.text('Waiting for verification'), findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('coming back to the app reads a pending address again', (
      tester,
    ) async {
      final fake = FakeRestmail()
        ..setRecoveryEmail(account, backup, verified: false);
      final (_, state) = await open(tester, fake: fake);
      expect(find.text('Waiting for verification'), findsOneWidget);
      fake.setRecoveryEmail(account, backup);
      for (final lifecycle in const [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(lifecycle);
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.text('Verified'), findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('refusals show at their fields, and clear on an edit', (
      tester,
    ) async {
      final (fake, state) = await open(tester);

      await send(tester, email: 'not an address');
      expect(find.text('must be a valid email'), findsOneWidget);
      await tester.enterText(address, backup);
      await tester.pump();
      expect(find.text('must be a valid email'), findsNothing);

      await send(tester, email: 'someone@${FakeAccounts.host}', with_: 'wrong');
      expect(find.text('Current password is incorrect.'), findsOneWidget);

      await send(tester, email: account);
      expect(
        find.text("must be outside this server's hosted domains"),
        findsOneWidget,
      );
      expect(fake.recoveryEmailOf(account), isNull);
      // The form keeps what was typed.
      expect(tester.widget<TextField>(address).controller!.text, account);
      expect(tester.widget<TextField>(current).controller!.text, password);

      await close(tester, fake, state);
    });

    testWidgets('a frozen address says so, and stays as it was', (
      tester,
    ) async {
      final fake = FakeRestmail()..setRecoveryEmail(account, backup);
      final (_, state) = await open(tester, fake: fake);
      fake.freezeRecoveryEmail(account, const Duration(days: 3));
      await tapText(tester, 'Change address');
      await send(tester, email: 'other@external.test');
      expect(
        find.text(
          'Recovery address changes are frozen for three days after email '
          'recovery.',
        ),
        findsOneWidget,
      );
      expect(fake.recoveryEmailOf(account)!.address, backup);
      expect(find.text('Verified'), findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('too many tries say for how long', (tester) async {
      final (fake, state) = await open(tester);
      fake.throttleSignIns(const Duration(minutes: 2));
      await send(tester);
      expect(find.text('Too many requests. Try again in 2 min.'), findsOne);
      expect(fake.recoveryEmailOf(account), isNull);
      await close(tester, fake, state);
    });

    testWidgets("a server that can't send links keeps its own words", (
      tester,
    ) async {
      final fake = FakeRestmail()..recoveryEmailConfigured = false;
      final (_, state) = await open(tester, fake: fake);
      await send(tester);
      expect(
        find.text(
          'Email recovery requires an HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL',
        ),
        findsOneWidget,
      );
      await close(tester, fake, state);
    });

    testWidgets('a load failure offers a retry and no form', (tester) async {
      final (fake, state) = await open(tester, enterScreen: false);
      fake.online = false;
      await tapText(tester, 'Recovery email');
      expect(find.text('Could not load your recovery email.'), findsOneWidget);
      expect(address, findsNothing);
      expect(find.text('None'), findsNothing);

      fake.online = true;
      await tapText(tester, 'Try again');
      expect(find.text('Could not load your recovery email.'), findsNothing);
      expect(find.text('None'), findsOneWidget);
      expect(address, findsOneWidget);
      await close(tester, fake, state);
    });

    testWidgets('a failed check keeps what was shown', (tester) async {
      final fake = FakeRestmail()
        ..setRecoveryEmail(account, backup, verified: false);
      final (_, state) = await open(tester, fake: fake);
      fake.online = false;
      await tapText(tester, 'Check again');
      expect(find.text('Could not load your recovery email.'), findsOneWidget);
      expect(find.text('Waiting for verification'), findsOneWidget);
      fake.online = true;
      await close(tester, fake, state);
    });

    testWidgets('a server without the route says it has none', (tester) async {
      final fake = FakeRestmail()..recoveryEmailRoutes = false;
      final (_, state) = await open(tester, fake: fake);
      expect(
        find.text("This server doesn't offer a recovery email."),
        findsOneWidget,
      );
      expect(address, findsNothing);
      expect(find.text('Try again'), findsNothing);
      await close(tester, fake, state);
    });

    testWidgets('German shows the screen in German', (tester) async {
      final (fake, state) = await open(tester, enterScreen: false);
      await state.updateSettings(state.settings.copyWith(languageCode: 'de'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Wiederherstellungs-E-Mail');
      expect(find.text('Keine'), findsOneWidget);
      expect(find.text('Bestätigungslink senden'), findsOneWidget);
      await close(tester, fake, state);
    });
  });

  group('forgotten password', () {
    const methodCodes = 'Use an authenticator and recovery code instead';
    const methodEmail = 'Use a recovery email link instead';
    const answer =
        'If this account has a verified recovery email, a recovery link will '
        'be sent.';

    Future<(FakeRestmail, AppState)> forgot(
      WidgetTester tester,
      String email, {
      FakeRestmail? fake,
    }) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      fake ??= FakeRestmail();
      final state = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => fake!.client,
      );
      await state.start();
      await tester.pumpWidget(RestmailApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add an account'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), email);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tapText(tester, 'Forgot password?');
      return (fake, state);
    }

    /// The reset screen's fields, built or not, but not the sign-in's below.
    final recoverFields = find.descendant(
      of: find.byType(RecoverAccountScreen),
      matching: find.byType(TextField, skipOffstage: false),
      skipOffstage: false,
    );

    /// Everything the screen says.
    List<String> shown(WidgetTester tester) => [
      for (final text in tester.widgetList<Text>(find.byType(Text)))
        '${text.data}',
    ];

    testWidgets('the codes stay the first method, and the link is the other', (
      tester,
    ) async {
      final (fake, state) = await forgot(tester, account);
      expect(recoverFields, findsNWidgets(4));
      expect(find.text(methodCodes), findsNothing);

      await tapText(tester, methodEmail);
      expect(find.text(methodCodes), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        account,
      );
      expect(find.text('Email me a link'), findsOneWidget);

      await tapText(tester, methodCodes);
      expect(recoverFields, findsNWidgets(4));
      expect(
        find.text('Reset password', skipOffstage: false),
        findsNWidgets(2),
      );
      await close(tester, fake, state);
    });

    testWidgets('a known and an unknown address look exactly the same', (
      tester,
    ) async {
      const verified = 'verified@restmail.test';
      const pending = 'pending@restmail.test';
      const none = 'none@restmail.test';
      const disabled = 'disabled@restmail.test';
      const unknown = 'nobody@restmail.test';

      FakeRestmail fresh() {
        final fake = FakeRestmail()
          ..addAccount(verified)
          ..setRecoveryEmail(verified, backup)
          ..addAccount(pending)
          ..setRecoveryEmail(pending, 'p@external.test', verified: false)
          ..addAccount(none)
          ..addAccount(disabled)
          ..setRecoveryEmail(disabled, 'd@external.test');
        fake.disableAccount(disabled);
        return fake;
      }

      List<String>? first;
      for (final email in [verified, pending, none, disabled, unknown]) {
        final (fake, state) = await forgot(tester, email, fake: fresh());
        await tapText(tester, methodEmail);
        await tapText(tester, 'Email me a link');
        expect(find.text(answer), findsOneWidget, reason: email);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          email,
        );
        final now = shown(tester);
        first ??= now;
        expect(now, first, reason: email);
        expect(
          fake.recoveryMail.map((mail) => mail.to),
          email == verified ? [backup] : isEmpty,
        );

        // Hold-off and the server's state look the same for each address too.
        for (var i = 0; i < 4; i++) {
          await tapText(tester, 'Email me a link');
        }
        await tapText(tester, 'Email me a link');
        expect(
          find.text('Too many requests. Try again in 15 min.'),
          findsOneWidget,
          reason: email,
        );
        expect(find.text(answer), findsNothing);
        await close(tester, fake, state);
      }
    });

    testWidgets('asking for a link never signs in, and the codes still work '
        'after it', (tester) async {
      const ada = 'ada@restmail.test';
      const fresh = 'a brand new passphrase';
      final fake = FakeRestmail()
        ..addAccount(ada)
        ..setRecoveryEmail(ada, backup);
      final (_, state) = await forgot(tester, ada, fake: fake);
      await tapText(tester, methodEmail);
      await tapText(tester, 'Email me a link');
      expect(state.accounts, isEmpty);
      expect(fake.passwordOf(ada), FakeAccounts.adminPassword);
      expect(fake.recoveryMail.single.mode, 'recover');

      await tapText(tester, methodCodes);
      expect(find.text(answer), findsNothing);
      await tester.enterText(recoverFields.at(1), FakeAccounts.totpCode);
      await tester.enterText(recoverFields.at(2), FakeAccounts.recoveryCode);
      await tester.enterText(recoverFields.at(3), fresh);
      await tester.pump();
      await tapText(tester, 'Reset password');
      expect(fake.passwordOf(ada), fresh);
      expect(state.accounts.map((a) => a.address), [ada]);
      await close(tester, fake, state);
    });

    testWidgets('editing the address clears the answer', (tester) async {
      final (fake, state) = await forgot(tester, account);
      await tapText(tester, methodEmail);
      await tapText(tester, 'Email me a link');
      expect(find.text(answer), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'other@restmail.test');
      await tester.pump();
      expect(find.text(answer), findsNothing);
      await close(tester, fake, state);
    });

    testWidgets('a malformed address is refused at its field', (tester) async {
      final (fake, state) = await forgot(tester, account);
      await tapText(tester, methodEmail);
      await tester.enterText(find.byType(TextField), 'not an address');
      await tester.pump();
      await tapText(tester, 'Email me a link');
      expect(find.text('must be a valid email'), findsOneWidget);
      expect(find.text(answer), findsNothing);
      await close(tester, fake, state);
    });

    for (final (name, setUp) in <(String, void Function(FakeRestmail))>[
      (
        "a server that can't send links",
        (fake) => fake.recoveryEmailConfigured = false,
      ),
      (
        'a server without the route',
        (fake) => fake.recoveryEmailRoutes = false,
      ),
    ]) {
      testWidgets('$name points back to the codes', (tester) async {
        final fake = FakeRestmail()..setRecoveryEmail(account, backup);
        setUp(fake);
        final (_, state) = await forgot(tester, account, fake: fake);
        await tapText(tester, methodEmail);
        await tapText(tester, 'Email me a link');
        expect(
          find.text(
            "This server can't send recovery links. Use your authenticator "
            'and a recovery code, or ask your administrator.',
          ),
          findsOneWidget,
        );
        expect(find.text(answer), findsNothing);
        await close(tester, fake, state);
      });
    }

    testWidgets('a failed request says so and sends nothing', (tester) async {
      final (fake, state) = await forgot(tester, account);
      await tapText(tester, methodEmail);
      fake.online = false;
      await tapText(tester, 'Email me a link');
      expect(find.text(answer), findsNothing);
      expect(find.text("Can't reach ${FakeAccounts.host}."), findsOneWidget);
      fake.online = true;
      await close(tester, fake, state);
    });
  });
}
