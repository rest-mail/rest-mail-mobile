import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A server just installed has only its bootstrap admin. The app takes the
/// owner from that admin to reading their own mailbox: authenticator, own
/// password, sign back in, mailbox, signed in.
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
    await tester.enterText(find.byType(TextField).at(1), 'not the password');
    await tester.pump();
    await tapButton(tester, 'Continue');

    expect(find.text('Wrong username or password.'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
    state.mailbox?.dispose();
  });
}
