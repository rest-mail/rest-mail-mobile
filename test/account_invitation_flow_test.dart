import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/invitation_screen.dart';
import 'package:restmail/ui/server_setup_screen.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');
const _invited = 'new@${FakeAccounts.host}';
const _password = 'a brand new passphrase';

/// An administrator issues a first-password invitation, and its owner uses
/// it from the server's sign-in, against the fake, which keeps the server's
/// rules for both.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail()
      ..addAccount(_invited, password: null, twoFactor: false);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
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

  Future<void> push(WidgetTester tester, Widget screen) async {
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).last);
    unawaited(navigator.push(MaterialPageRoute<void>(builder: (_) => screen)));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<(RestAccount, AdminMailbox)> mailbox(
    WidgetTester tester,
    AppState state,
    String address,
  ) async {
    final account = state.accounts.whereType<RestAccount>().single;
    final page = await tester.runAsync(
      () => account.client.mailboxes(limit: 500),
    );
    return (account, page!.items.firstWhere((box) => box.address == address));
  }

  testWidgets('an invitation is issued, revealed only on request, and works '
      'once', (tester) async {
    final (fake, state) = await open(tester);
    final (account, box) = await mailbox(tester, state, _invited);
    await push(tester, InvitationScreen(account: account, mailbox: box));
    expect(find.text('Invite to choose a password'), findsWidgets);
    expect(find.text('Show invitation code'), findsNothing);

    await tapText(tester, 'Generate invitation');
    expect(find.text('Show invitation code'), findsOneWidget);
    expect(find.textContaining('Expires '), findsOneWidget);

    await tapText(tester, 'Show invitation code');
    final token = tester
        .widget<SelectableText>(find.byType(SelectableText))
        .data!;
    expect(token, isNotEmpty);

    final owner = RestmailClient(server: _server, httpClient: fake.client);
    addTearDown(owner.close);
    final result = await tester.runAsync(
      () => owner.acceptInvitation(token: token, password: _password),
    );
    expect(result!.user.email, _invited);
    expect(fake.passwordOf(_invited), _password);
    await close(tester, fake, state);
  });

  testWidgets('an account that has a password is not reset', (tester) async {
    final (fake, state) = await open(tester);
    final (account, box) = await mailbox(tester, state, FakeAccounts.email);
    await push(tester, InvitationScreen(account: account, mailbox: box));
    await tapText(tester, 'Generate invitation');
    expect(
      find.text(
        'Only an active account that has never had sign-in credentials can be '
        'invited. This does not reset an existing account.',
      ),
      findsOneWidget,
    );
    expect(find.text('Show invitation code'), findsNothing);
    expect(fake.passwordOf(FakeAccounts.email), FakeAccounts.password);
    await close(tester, fake, state);
  });

  testWidgets('Use an invitation sets the first password from the sign-in '
      'screen', (tester) async {
    final (fake, state) = await open(tester);
    final (account, box) = await mailbox(tester, state, _invited);
    final invitation = await tester.runAsync(
      () => account.client.inviteAccount(box.id),
    );
    await push(tester, ServerSetupScreen(server: _server, invitation: true));
    expect(find.text('Use an invitation'), findsWidgets);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), invitation!.token);
    await tester.enterText(fields.at(1), _password);
    await tester.enterText(fields.at(2), _password);
    await tester.pump();
    await tapText(tester, 'Continue');
    expect(fake.passwordOf(_invited), _password);
    await close(tester, fake, state);
  });

  testWidgets('a spent invitation says so', (tester) async {
    final (fake, state) = await open(tester);
    await push(tester, ServerSetupScreen(server: _server, invitation: true));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'not-an-invitation');
    await tester.enterText(fields.at(1), _password);
    await tester.enterText(fields.at(2), _password);
    await tester.pump();
    await tapText(tester, 'Continue');
    expect(
      find.text(
        'This invitation is invalid, expired or already used. Ask your '
        'administrator for a new one.',
      ),
      findsOneWidget,
    );
    expect(fake.passwordOf(_invited), isNull);
    await close(tester, fake, state);
  });
}
