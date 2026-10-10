import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/server_setup_screen.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail/util/setup_code.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A server just installed is claimed with the setup code it printed, or, given
/// a bootstrap admin password, signed in to with that. The app takes the owner
/// from there to reading their own mailbox: authenticator, own password where
/// the deploy chose it, sign back in, mailbox, signed in.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> openFreshServer(
    WidgetTester tester, {
    FakeScenario scenario = FakeScenario.freshInstall,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: scenario);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Set up a new server'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), FakeAccounts.host);
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use this server'));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    final button = find.text(label);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  Future<void> usePassword(WidgetTester tester) async {
    await tapButton(tester, 'Have an admin password instead?');
  }

  Future<void> signInAsBootstrapAdmin(WidgetTester tester) async {
    await usePassword(tester);
    expect(find.text('Step 1 of 4'), findsOneWidget);
    // Username is filled in; the password is the deploy's.
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.bootstrapPassword,
    );
    await tester.pump();
    await tapButton(tester, 'Continue');
  }

  testWidgets('a fresh server, set up from the phone, ends in its mailbox', (
    tester,
  ) async {
    final (fake, state) = await openFreshServer(tester);
    await signInAsBootstrapAdmin(tester);

    // Authenticator, recovery codes kept.
    expect(find.text('Step 2 of 4'), findsOneWidget);
    await tapButton(tester, 'Set up authenticator');
    expect(find.text(FakeAccounts.recoveryCode), findsOneWidget);
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.pump();
    // Not until the codes are saved.
    expect(
      tester
          .widget<RmPrimaryButton>(
            find.ancestor(
              of: find.text('Confirm'),
              matching: find.byType(RmPrimaryButton),
            ),
          )
          .onPressed,
      isNull,
      reason: 'confirming before the recovery codes are saved',
    );
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tapButton(tester, 'Confirm');

    // Own password.
    expect(find.text('Step 3 of 4'), findsOneWidget);
    const chosen = 'a passphrase only I know';
    await tester.enterText(find.byType(TextField).at(0), chosen);
    await tester.enterText(find.byType(TextField).at(1), chosen);
    await tester.pump();
    await tapButton(tester, 'Change password');
    expect(fake.adminPassword, chosen);

    // Signed out everywhere by the change: back in with a code.
    expect(find.text('Sign back in'), findsWidgets);
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.pump();
    await tapButton(tester, 'Continue');

    // The mailbox, on the server's own domain.
    expect(find.text('Step 4 of 4'), findsOneWidget);
    expect(find.text(FakeAccounts.host), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'me');
    await tester.enterText(find.byType(TextField).at(2), 'Me');
    await tester.enterText(find.byType(TextField).at(3), 'my mailbox password');
    await tester.pump();
    await tapButton(tester, 'Create mailbox and sign in');

    expect(fake.hasMailbox('me@${FakeAccounts.host}'), isTrue);
    expect(state.phase, AppPhase.signedIn);
    expect(find.text('Live · me@${FakeAccounts.host}'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('mismatched passwords are caught before the server sees them', (
    tester,
  ) async {
    final (fake, state) = await openFreshServer(tester);
    await signInAsBootstrapAdmin(tester);
    await tapButton(tester, 'Set up authenticator');
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tapButton(tester, 'Confirm');

    await tester.enterText(
      find.byType(TextField).at(0),
      'a passphrase only I know',
    );
    await tester.enterText(
      find.byType(TextField).at(1),
      'a different passphrase',
    );
    await tester.pump();
    await tapButton(tester, 'Change password');

    expect(find.text("The passwords don't match."), findsOneWidget);
    expect(fake.adminPassword, FakeAccounts.bootstrapPassword);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  testWidgets('a wrong bootstrap password says so', (tester) async {
    final (fake, state) = await openFreshServer(tester);
    await usePassword(tester);
    await tester.enterText(find.byType(TextField).at(1), 'not the password');
    await tester.pump();
    await tapButton(tester, 'Continue');

    expect(find.text('Wrong username or password.'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  Future<void> enterClaim(
    WidgetTester tester, {
    String code = FakeAccounts.setupCode,
    String password = 'a passphrase only I know',
    String repeat = 'a passphrase only I know',
  }) async {
    expect(find.text('Step 1 of 4'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), code);
    await tester.enterText(find.byType(TextField).at(1), 'owner');
    await tester.enterText(find.byType(TextField).at(2), password);
    await tester.enterText(find.byType(TextField).at(3), repeat);
    await tester.pump();
    await tapButton(tester, 'Claim this server');
  }

  testWidgets('a server claimed with its setup code ends in its mailbox', (
    tester,
  ) async {
    final (fake, state) = await openFreshServer(
      tester,
      scenario: FakeScenario.unclaimed,
    );
    // Typed off a screen: lower case, spaces for dashes, O for 0.
    await enterClaim(
      tester,
      code: FakeAccounts.setupCode.toLowerCase().replaceAll('-', ' '),
    );
    expect(fake.adminUsername, 'owner');
    expect(fake.adminPassword, 'a passphrase only I know');

    // The password is the owner's already: only the authenticator is owed.
    expect(find.text('Step 2 of 4'), findsOneWidget);
    await tapButton(tester, 'Set up authenticator');
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tapButton(tester, 'Confirm');

    expect(find.text('Sign back in'), findsWidgets);
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.pump();
    await tapButton(tester, 'Continue');

    expect(find.text('Step 4 of 4'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'me');
    await tester.enterText(find.byType(TextField).at(3), 'my mailbox password');
    await tester.pump();
    await tapButton(tester, 'Create mailbox and sign in');

    expect(fake.hasMailbox('me@${FakeAccounts.host}'), isTrue);
    expect(state.phase, AppPhase.signedIn);

    await tester.pumpWidget(const SizedBox());
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('a wrong setup code says so, and claims nothing', (tester) async {
    final (fake, state) = await openFreshServer(
      tester,
      scenario: FakeScenario.unclaimed,
    );
    await enterClaim(tester, code: 'AAAA-BBBB-CCCC-DDDD-EEEE-FFFF');

    expect(find.textContaining("That setup code didn't work"), findsOneWidget);
    // Still on the claim step, to try again.
    expect(find.text('Have an admin password instead?'), findsOneWidget);
    expect(fake.adminUsername, isNull);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  testWidgets('mismatched passwords are caught before a claim', (tester) async {
    final (fake, state) = await openFreshServer(
      tester,
      scenario: FakeScenario.unclaimed,
    );
    await enterClaim(tester, repeat: 'a different passphrase');

    expect(find.text("The passwords don't match."), findsOneWidget);
    expect(fake.adminUsername, isNull);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  group('scanning the QR code', () {
    final scanner = ServerSetupScreen.scanSetupCode;
    tearDown(() => ServerSetupScreen.scanSetupCode = scanner);

    testWidgets('fills in the code, and the claim goes on from there', (
      tester,
    ) async {
      ServerSetupScreen.scanSetupCode = (_) async =>
          const SetupCodeScan(FakeAccounts.setupCode);
      final (fake, state) = await openFreshServer(
        tester,
        scenario: FakeScenario.unclaimed,
      );
      await tapButton(tester, 'Scan the QR code');
      expect(find.text(FakeAccounts.setupCode), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(1), 'owner');
      await tester.enterText(
        find.byType(TextField).at(2),
        'a passphrase only I know',
      );
      await tester.enterText(
        find.byType(TextField).at(3),
        'a passphrase only I know',
      );
      await tester.pump();
      await tapButton(tester, 'Claim this server');
      expect(fake.adminUsername, 'owner');
      expect(find.text('Step 2 of 4'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      fake.close();
      state.mailbox?.dispose();
    });

    testWidgets('a code for another server says so', (tester) async {
      ServerSetupScreen.scanSetupCode = (_) async => SetupCodeScan(
        FakeAccounts.setupCode,
        server: Uri.parse('https://mail.elsewhere.test'),
      );
      final (fake, state) = await openFreshServer(
        tester,
        scenario: FakeScenario.unclaimed,
      );
      await tapButton(tester, 'Scan the QR code');

      expect(
        find.text(
          'That code is for mail.elsewhere.test, not ${FakeAccounts.host}.',
        ),
        findsOneWidget,
      );
      expect(find.text(FakeAccounts.setupCode), findsNothing);

      await tester.pumpWidget(const SizedBox());
      fake.close();
      state.mailbox?.dispose();
    });
  });
}
