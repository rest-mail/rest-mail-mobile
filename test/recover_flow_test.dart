import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// A forgotten password reset from the sign-in screen, against the fake.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const address = 'ada@restmail.test', newPassword = 'a brand new passphrase';

  Future<(FakeRestmail, AppState)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()..addAccount(address);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
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
    state.mailbox?.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Add an account, with [email]'s server looked up.
  Future<void> signInWith(WidgetTester tester, String email) async {
    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), email);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  Future<void> fill(
    WidgetTester tester, {
    String code = FakeAccounts.totpCode,
    String recovery = FakeAccounts.recoveryCode,
    String password = newPassword,
  }) async {
    await tester.enterText(find.byType(TextField).at(1), code);
    await tester.enterText(find.byType(TextField).at(2), recovery);
    await tester.enterText(find.byType(TextField).at(3), password);
    await tester.pump();
  }

  testWidgets('a forgotten password is reset with both codes, and the '
      'account opens', (tester) async {
    final (fake, state) = await open(tester);
    await signInWith(tester, address);
    await tap(tester, 'Forgot password?');
    expect(find.text('Reset password'), findsNWidgets(2));
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      address,
    );

    await fill(tester, code: '000000');
    await tap(tester, 'Reset password');
    expect(
      find.text(
        "That address, authenticator code or recovery code isn't right.",
      ),
      findsOneWidget,
    );
    await fill(tester, password: 'short');
    await tap(tester, 'Reset password');
    expect(find.text('Use at least 12 characters.'), findsOneWidget);
    expect(fake.passwordOf(address), FakeAccounts.adminPassword);

    await fill(tester);
    await tap(tester, 'Reset password');
    expect(fake.passwordOf(address), newPassword);
    expect(state.accounts.map((a) => a.address), [address]);
    expect(find.text('Reset password'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('five refusals hold the address off, and say for how long', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    await signInWith(tester, address);
    await tap(tester, 'Forgot password?');
    for (var i = 0; i < 5; i++) {
      await fill(tester, recovery: 'WRONG-$i');
      await tap(tester, 'Reset password');
    }
    await fill(tester);
    await tap(tester, 'Reset password');
    expect(
      find.text('Too many tries for this address. Try again in 15 min.'),
      findsOneWidget,
    );
    expect(fake.passwordOf(address), FakeAccounts.adminPassword);

    await close(tester, fake, state);
  });

  testWidgets('an address at a mail provider offers no reset here', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    await signInWith(tester, 'someone@gmail.com');
    expect(find.text('Forgot password?'), findsNothing);

    await close(tester, fake, state);
  });
}
