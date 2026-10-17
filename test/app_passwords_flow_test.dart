import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/util/secret_clipboard.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// App passwords under Settings → the account, against the fake, which
/// keeps the server's rules: the current password again, the second factor,
/// the secret answered once, and revoking that stops one at once.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
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
    await state.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tap(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text).last);

  /// Settings → the account → App passwords.
  Future<void> openAppPasswords(WidgetTester tester) async {
    await tap(tester, find.byTooltip('Folders and accounts'));
    await tapText(tester, 'Settings');
    await tapText(tester, FakeAccounts.email);
    await tapText(tester, 'App passwords');
  }

  Finder field(String hint) =>
      find.ancestor(of: find.text(hint), matching: find.byType(TextField));

  Future<void> fillIn(
    WidgetTester tester, {
    String name = 'iPhone Mail',
    String password = FakeAccounts.password,
  }) async {
    await tester.enterText(field('iPhone Mail'), name);
    await tester.enterText(field('The password you sign in with'), password);
    await tester.pump();
  }

  /// The secret on screen, if there is one.
  String? shownSecret(WidgetTester tester) {
    final shown = find.textContaining(RegExp(r'^rm_'));
    return shown.evaluate().isEmpty
        ? null
        : tester.widget<Text>(shown.first).data;
  }

  /// Copies go through the platform channel; [expires] is its answer.
  List<MethodCall> mockClipboard(WidgetTester tester, {required bool expires}) {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SecretClipboard.channel,
      (call) async {
        calls.add(call);
        return expires;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SecretClipboard.channel,
        null,
      ),
    );
    return calls;
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

  testWidgets('create one, copy it once, see it listed, revoke it', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final copies = mockClipboard(tester, expires: true);

    await openAppPasswords(tester);
    expect(find.text('None yet.'), findsOneWidget);

    await tapText(tester, 'Create an app password');
    await fillIn(tester);
    await tapText(tester, 'In 90 days');
    await tapText(tester, 'Create app password');

    // Shown once, with what a mail app needs.
    final secret = shownSecret(tester);
    expect(secret, matches(RegExp(r'^rm_[A-Za-z0-9]{12}_[A-Za-z0-9]{43}$')));
    expect(find.textContaining("won't be shown again"), findsOneWidget);
    expect(find.text('Port 993, SSL/TLS'), findsOneWidget);
    expect(find.text('Port 465, SSL/TLS'), findsOneWidget);
    expect(fake.acceptsAppPassword(FakeAccounts.email, secret!), isTrue);

    await tapText(tester, 'Copy app password');
    expect(copies.single.method, 'copy');
    expect(copies.single.arguments, {'text': secret, 'seconds': 120});
    expect(find.textContaining('Copied to this phone only'), findsOneWidget);

    // Hidden while the app is in the background.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(shownSecret(tester), isNull);
    expect(
      find.text('Hidden while REST Mail is in the background'),
      findsOneWidget,
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(shownSecret(tester), secret);

    // Gone for good once the screen closes; the list has it, without it.
    await tapText(tester, 'Done');
    expect(shownSecret(tester), isNull);
    expect(find.text('App passwords'), findsWidgets);
    expect(find.text('iPhone Mail'), findsOneWidget);
    expect(find.textContaining('Never used'), findsOneWidget);
    expect(find.textContaining('Expires '), findsOneWidget);
    expect(find.textContaining(secret), findsNothing);

    await tap(tester, find.byTooltip('Revoke iPhone Mail'));
    expect(find.text('Revoke “iPhone Mail”?'), findsOneWidget);
    await tapText(tester, 'Revoke');
    expect(find.text('Revoked “iPhone Mail”'), findsOneWidget);
    expect(find.text('None yet.'), findsOneWidget);
    expect(fake.acceptsAppPassword(FakeAccounts.email, secret), isFalse);

    await close(tester, fake, state);
  });

  testWidgets('a wrong password asks for it again, and the session stays', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    final account = state.current! as RestAccount;
    final tokens = account.client.tokens;
    mockClipboard(tester, expires: true);

    await openAppPasswords(tester);
    await tapText(tester, 'Create an app password');

    // The field is the current password's, never offered to save as new.
    final passwordField = tester.widget<TextField>(
      field('The password you sign in with'),
    );
    expect(passwordField.obscureText, isTrue);
    expect(passwordField.autofillHints, [AutofillHints.password]);

    await fillIn(tester, password: 'not my password');
    await tapText(tester, 'Create app password');

    expect(
      find.text(
        "That isn't the password of ${FakeAccounts.email}. Enter it again.",
      ),
      findsOneWidget,
    );
    // Not kept past the request.
    expect(
      tester
          .widget<TextField>(field('The password you sign in with'))
          .controller!
          .text,
      isEmpty,
    );
    // Still signed in, with the same session: nothing renewed or ended.
    expect(state.accounts, [account]);
    expect(identical(account.client.tokens, tokens), isTrue);
    expect(fake.appPasswordsOf(FakeAccounts.email), isEmpty);

    await tester.enterText(
      field('The password you sign in with'),
      FakeAccounts.password,
    );
    await tester.pump();
    await tapText(tester, 'Create app password');
    expect(shownSecret(tester), isNotNull);

    await close(tester, fake, state);
  });

  testWidgets('a mailbox with two-factor authentication needs a sign-in '
      'with the code, and offers one', (tester) async {
    final (fake, state) = await open(tester);
    mockClipboard(tester, expires: true);
    fake.enableTwoFactor(FakeAccounts.email);

    await openAppPasswords(tester);
    await tapText(tester, 'Create an app password');
    await fillIn(tester);
    await tapText(tester, 'Create app password');

    expect(find.textContaining('Sign in again with your code'), findsOneWidget);
    expect(state.accounts, hasLength(1));

    // Signing in again, with the address filled in, replaces the session.
    await tapText(tester, 'Sign in again');
    expect(find.text('Add account'), findsOneWidget);
    expect(find.text(FakeAccounts.email), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tapText(tester, 'Continue');
    await tester.enterText(find.byType(TextField).at(2), FakeAccounts.totpCode);
    await tester.pump();
    await tapText(tester, 'Continue');
    expect(state.accounts, hasLength(1));

    await openAppPasswords(tester);
    await tapText(tester, 'Create an app password');
    await fillIn(tester);
    await tapText(tester, 'Create app password');
    expect(shownSecret(tester), isNotNull);

    await close(tester, fake, state);
  });

  testWidgets('when sign-in\'s budget is spent, it says how long to wait', (
    tester,
  ) async {
    // The fake's clock stands still, so the wait is the same when it is
    // read as when it was set.
    final now = DateTime.now();
    final (fake, state) = await open(
      tester,
      fake: FakeRestmail(clock: () => now),
    );
    fake.throttleSignIns(const Duration(seconds: 30));

    await openAppPasswords(tester);
    await tapText(tester, 'Create an app password');
    await fillIn(tester);
    await tapText(tester, 'Create app password');

    expect(
      find.text('Too many attempts. Try again in 30 seconds.'),
      findsOneWidget,
    );
    expect(state.accounts, hasLength(1));

    await close(tester, fake, state);
  });

  testWidgets('where the clipboard is not private, the copy says so', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    mockClipboard(tester, expires: false);

    await openAppPasswords(tester);
    await tapText(tester, 'Create an app password');
    await fillIn(tester);
    await tapText(tester, 'Create app password');
    await tapText(tester, 'Copy app password');

    expect(
      find.textContaining('Other apps can read the clipboard'),
      findsOneWidget,
    );

    await close(tester, fake, state);
  });

  testWidgets('a server from before app passwords says it has none', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      fake: FakeRestmail(appPasswords: false),
    );

    await openAppPasswords(tester);

    expect(
      find.text("This server doesn't support app passwords yet."),
      findsOneWidget,
    );
    expect(find.text('Create an app password'), findsNothing);
    expect(state.accounts, hasLength(1));

    await close(tester, fake, state);
  });

  testWidgets('a linked mailbox has no app passwords of its own here', (
    tester,
  ) async {
    final (fake, state) = await open(tester);
    await state.mailbox!.backend.linkAccount(
      address: FakeAccounts.otherEmail,
      password: FakeAccounts.password,
    );
    await state.mailbox!.reloadAccounts();
    await tester.pumpAndSettle();

    await tap(tester, find.byTooltip('Folders and accounts'));
    await tapText(tester, 'Settings');
    await tapText(tester, FakeAccounts.otherEmail);
    expect(find.text('Linked mailbox · ${FakeAccounts.host}'), findsOneWidget);
    expect(find.text('App passwords'), findsNothing);

    await close(tester, fake, state);
  });

  group('SecretClipboard', () {
    testWidgets('with no channel, it falls back to the plain clipboard and '
        'says the copy stays', (tester) async {
      // A channel nobody answers is how a platform without it looks.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SecretClipboard.channel,
        (call) async => throw MissingPluginException(),
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SecretClipboard.channel,
          null,
        ),
      );
      final copied = <Object?>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') copied.add(call.arguments);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      final expires = await const SecretClipboard().copy('rm_secret');

      expect(expires, isFalse);
      expect(copied, [
        {'text': 'rm_secret'},
      ]);
    });
  });
}
