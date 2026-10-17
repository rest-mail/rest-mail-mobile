import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/server_setup_screen.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail/util/sign_in_link.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A server just installed is signed in to as its bootstrap account,
/// `admin@` its domain, with the password its installer showed, typed or
/// scanned off the installer's QR code. The app takes the owner from there to
/// reading that account's mail: authenticator, own password, sign back in,
/// signed in, with Administration by its capabilities.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> openFreshServer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
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

  Future<void> signInAsBootstrapAdmin(WidgetTester tester) async {
    expect(find.text('Step 1 of 3'), findsOneWidget);
    // The address is filled in; the password is the installer's.
    expect(find.text(FakeAccounts.adminEmail), findsOneWidget);
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.bootstrapPassword,
    );
    await tester.pump();
    await tapButton(tester, 'Continue');
  }

  testWidgets('a fresh server, set up from the phone, ends in its first '
      "account's mail, which may administer it", (tester) async {
    final (fake, state) = await openFreshServer(tester);
    await signInAsBootstrapAdmin(tester);

    // Authenticator, recovery codes kept.
    expect(find.text('Step 2 of 3'), findsOneWidget);
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
    expect(find.text('Step 3 of 3'), findsOneWidget);
    const chosen = 'a passphrase only I know';
    await tester.enterText(find.byType(TextField).at(0), chosen);
    await tester.enterText(find.byType(TextField).at(1), chosen);
    await tester.pump();
    await tapButton(tester, 'Change password');
    expect(fake.passwordOf(FakeAccounts.adminEmail), chosen);

    // Signed out everywhere by the change: back in with a code.
    expect(find.text('Sign back in'), findsWidgets);
    await tester.enterText(find.byType(TextField), FakeAccounts.totpCode);
    await tester.pump();
    await tapButton(tester, 'Continue');

    // That session is the account's, kept: its mail, and Administration.
    expect(state.phase, AppPhase.signedIn);
    expect(state.accounts.single.address, FakeAccounts.adminEmail);
    expect(find.text('Live · ${FakeAccounts.adminEmail}'), findsOneWidget);
    expect(
      (state.current! as RestAccount).capabilities.allows('mailboxes:write'),
      isTrue,
    );

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
    expect(
      fake.passwordOf(FakeAccounts.adminEmail),
      FakeAccounts.bootstrapPassword,
    );

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  testWidgets('a wrong bootstrap password says so', (tester) async {
    final (fake, state) = await openFreshServer(tester);
    await tester.enterText(find.byType(TextField).at(1), 'not the password');
    await tester.pump();
    await tapButton(tester, 'Continue');

    expect(find.text('Wrong address or password.'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });

  testWidgets('an account in setup signing in as any account does is taken '
      'to its setup', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.freshInstall);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tapButton(tester, 'Add an account');
    await tester.enterText(
      find.byType(TextField).at(0),
      FakeAccounts.adminEmail,
    );
    await tester.pump(const Duration(milliseconds: 600)); // past the debounce
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.bootstrapPassword,
    );
    await tester.pump();
    await tapButton(tester, 'Continue');

    // Kept nowhere until it is set up; its setup goes on from here.
    expect(state.accounts, isEmpty);
    expect(find.text('Set up ${FakeAccounts.host}'), findsWidgets);
    await tapButton(tester, 'Continue');
    expect(find.text('Step 2 of 3'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
  });

  group("scanning the installer's QR code", () {
    final scanner = ServerSetupScreen.scanSignIn;
    tearDown(() => ServerSetupScreen.scanSignIn = scanner);

    testWidgets('fills in the sign-in, and setup goes on from there', (
      tester,
    ) async {
      ServerSetupScreen.scanSignIn = (_) async => SignInLink(
        server: Uri.parse('https://${FakeAccounts.host}'),
        address: FakeAccounts.adminEmail,
        password: FakeAccounts.bootstrapPassword,
      );
      final (fake, state) = await openFreshServer(tester);
      await tapButton(tester, 'Scan the QR code');
      expect(find.text(FakeAccounts.bootstrapPassword), findsOneWidget);

      await tapButton(tester, 'Continue');
      expect(find.text('Step 2 of 3'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      fake.close();
      state.mailbox?.dispose();
    });

    testWidgets('a code for another server says so', (tester) async {
      ServerSetupScreen.scanSignIn = (_) async => SignInLink(
        server: Uri.parse('https://mail.elsewhere.test'),
        password: FakeAccounts.bootstrapPassword,
      );
      final (fake, state) = await openFreshServer(tester);
      await tapButton(tester, 'Scan the QR code');

      expect(
        find.text(
          'That code is for mail.elsewhere.test, not ${FakeAccounts.host}.',
        ),
        findsOneWidget,
      );
      expect(find.text(FakeAccounts.bootstrapPassword), findsNothing);

      await tester.pumpWidget(const SizedBox());
      fake.close();
      state.mailbox?.dispose();
    });
  });
}
