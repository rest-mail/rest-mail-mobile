import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

/// Administration, and what each capability shows of it, against the fake,
/// which answers each admin route only with the capability the real server
/// asks for.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

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
    return (fake, state);
  }

  /// An administrator is an account: it signs in by its address, and opens
  /// on its mail.
  Future<void> signInAdmin(AppState state, String email) => state.signIn(
    server: _server,
    email: email,
    password: FakeAccounts.adminPassword,
    totpCode: FakeAccounts.totpCode,
  );

  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// A queued message's details: a lazy list, whose actions are built only
  /// once they are scrolled near.
  Finder entryDetails() => find
      .ancestor(of: find.text('To'), matching: find.byType(Scrollable))
      .first;

  Future<void> scrollToAction(WidgetTester tester, String action) => tester
      .scrollUntilVisible(find.text(action), 200, scrollable: entryDetails());

  /// Administration, from the drawer.
  Future<void> administer(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tap(tester, 'Administration');
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

  const sections = [
    'Outbound queue',
    'Domains',
    'Mailboxes',
    'Aliases',
    'Bans',
    'Overview',
  ];

  testWidgets('an administrator signs in as its account, with a code, and '
      'runs the server from Administration', (tester) async {
    final (fake, state) = await open(tester);
    await tester.pumpWidget(RestmailApp(state: state));

    // The ordinary sign-in: there is no other.
    await tap(tester, 'Add an account');
    expect(find.text('Sign in as an administrator'), findsNothing);
    await tester.enterText(
      find.byType(TextField).at(0),
      FakeAccounts.adminEmail,
    );
    await tester.pump(const Duration(milliseconds: 600)); // past the debounce
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.adminPassword,
    );
    await tester.pump();
    await tap(tester, 'Continue');
    expect(find.text('TWO-FACTOR CODE'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(2), FakeAccounts.totpCode);
    await tester.pump();
    await tap(tester, 'Continue');

    // Its own mail, and Administration, all of it, by capability.
    expect(find.text('Live · ${FakeAccounts.adminEmail}'), findsOneWidget);
    await administer(tester);
    for (final section in sections) {
      expect(find.text(section), findsOneWidget, reason: section);
    }

    // A deferred message, retried.
    await tap(tester, 'Outbound queue');
    expect(find.text('tom@ryeworks.test'), findsOneWidget);
    await tap(tester, 'tom@ryeworks.test');
    await scrollToAction(tester, 'Retry now');
    await tap(tester, 'Retry now');
    expect(find.text('Retrying tom@ryeworks.test'), findsOneWidget);
    expect(
      fake.queue.firstWhere((e) => e.recipient == 'tom@ryeworks.test').status,
      'pending',
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // A domain added.
    await tap(tester, 'Domains');
    await tap(tester, 'Add a domain');
    await tester.enterText(find.byType(TextField).first, 'new.test');
    await tester.pump();
    await tap(tester, 'Add domain');
    expect(fake.domains.map((d) => d.name), contains('new.test'));
    // It opens on the new domain; the list has it too.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('new.test'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // An alias deleted.
    await tap(tester, 'Aliases');
    await tap(tester, 'hello@${FakeAccounts.host}');
    await tap(tester, 'Delete alias');
    await tap(tester, 'Delete');
    expect(find.text('Deleted hello@${FakeAccounts.host}'), findsOneWidget);
    expect(fake.aliases, isEmpty);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // An address banned, and the server's own ban lifted.
    await tap(tester, 'Bans');
    await tap(tester, 'Ban an address');
    await tester.enterText(find.byType(TextField).first, '198.51.100.4');
    await tester.pump();
    await tap(tester, 'Ban');
    expect(find.text('198.51.100.4'), findsOneWidget);
    await tester.tap(find.byTooltip('Lift the ban on 203.0.113.7'));
    await tester.pumpAndSettle();
    await tap(tester, 'Lift ban');
    expect(fake.bans.map((b) => b.ip), ['198.51.100.4']);
    expect(fake.bans.single.createdBy, FakeAccounts.adminEmail);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // And the server at a glance.
    await tap(tester, 'Overview');
    expect(find.text('MESSAGES A DAY'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Bounced: nobody@ryeworks.test'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Bounced: nobody@ryeworks.test'), findsOneWidget);

    await close(tester, fake, state);
  });

  testWidgets('a mailbox added in Administration is made through the one '
      'account route, owned by the administrator, with no password unless '
      'given one', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.adminEmail);
    await tester.pumpWidget(RestmailApp(state: state));
    await administer(tester);

    await tap(tester, 'Mailboxes');
    await tap(tester, 'Add a mailbox');
    await tester.enterText(
      find.byType(TextField).at(0),
      'hello@${FakeAccounts.host}',
    );
    await tester.enterText(find.byType(TextField).at(1), 'Hello');
    await tester.pump();
    await tap(tester, 'Add mailbox');

    expect(find.text('hello@${FakeAccounts.host}'), findsOneWidget);
    expect(fake.passwordOf('hello@${FakeAccounts.host}'), isNull);
    expect(fake.ownedBy(FakeAccounts.adminEmail), [
      'hello@${FakeAccounts.host}',
    ]);
    expect(fake.auditLog.last.action, 'accounts.create');
    // It is among the administrator's own mailboxes at once.
    await tester.pumpAndSettle();
    expect(
      state.mailbox!.accounts.map((a) => a.address),
      contains('hello@${FakeAccounts.host}'),
    );

    await close(tester, fake, state);
  });

  testWidgets('an administrator with only queue:read sees only the queue, '
      'and nothing to change in it', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.queueWatcher);
    await tester.pumpWidget(RestmailApp(state: state));
    await administer(tester);

    expect(find.text('Outbound queue'), findsOneWidget);
    for (final section in sections.skip(1)) {
      expect(find.text(section), findsNothing, reason: section);
    }

    await tap(tester, 'Outbound queue');
    await tap(tester, 'tom@ryeworks.test');
    expect(find.text('Deferred'), findsOneWidget);
    // To the end of the details, where the actions would be.
    await tester.drag(entryDetails(), const Offset(0, -2000));
    await tester.pumpAndSettle();
    for (final action in ['Retry now', 'Bounce to sender', 'Delete']) {
      expect(find.text(action), findsNothing, reason: action);
    }

    await close(tester, fake, state);
  });

  testWidgets('a capability taken away on the server goes from the app at '
      'the next refresh', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.adminEmail);
    await tester.pumpWidget(RestmailApp(state: state));
    await administer(tester);
    await tap(tester, 'Domains');
    expect(find.text(FakeAccounts.host), findsOneWidget);

    fake.grant(FakeAccounts.adminEmail, {'queue:read'});
    await (state.current! as RestAccount).client.refresh();
    await tester.pumpAndSettle();

    // The screen open on it says so, and the section is gone behind it.
    expect(find.text("You don't have permission for this"), findsOneWidget);
    expect(find.text(FakeAccounts.host), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Outbound queue'), findsOneWidget);
    expect(find.text('Domains'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('an app that shows more than the session holds is refused by '
      'the server, and says only that', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.queueWatcher);
    // A modified app, which believes it may do everything.
    (state.current! as RestAccount).capabilities = const Capabilities({'*'});
    await tester.pumpWidget(RestmailApp(state: state));
    await administer(tester);

    await tap(tester, 'Mailboxes');
    expect(find.text("You don't have permission for this"), findsOneWidget);
    expect(find.text(FakeAccounts.email), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tap(tester, 'Outbound queue');
    await tap(tester, 'ana@harbor.test');
    await scrollToAction(tester, 'Retry now');
    await tap(tester, 'Retry now');
    expect(find.text("You don't have permission for this"), findsOneWidget);
    expect(
      fake.queue.firstWhere((e) => e.recipient == 'ana@harbor.test').status,
      'pending',
    );

    await close(tester, fake, state);
  });

  testWidgets('a mailbox session reaches Administration from the drawer only '
      'when it holds a capability', (tester) async {
    final (fake, state) = await open(tester);
    // An account's grants give its session capabilities.
    fake.grant(FakeAccounts.otherEmail, {'queue:read'});
    await state.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    expect(find.text('Administration'), findsNothing);
    await tester.tapAt(const Offset(370, 400)); // close the drawer
    await tester.pumpAndSettle();

    await state.signIn(
      server: _server,
      email: FakeAccounts.otherEmail,
      password: FakeAccounts.password,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tap(tester, 'Administration');
    expect(find.text('Outbound queue'), findsOneWidget);
    expect(find.text('Domains'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets("a domain's DMARC policy is raised, and Reject, for a domain "
      'whose people write ordinary mail, asks first', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.adminEmail);
    await tester.pumpWidget(RestmailApp(state: state));
    await administer(tester);
    String policy() =>
        fake.domains.firstWhere((d) => d.name == FakeAccounts.host).dmarcPolicy;

    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    expect(find.text('None: reports only'), findsOneWidget);

    await tap(tester, 'DMARC policy');
    await tap(tester, 'Quarantine');
    await tap(tester, 'Save');
    expect(policy(), 'quarantine');
    expect(find.text('Quarantine'), findsOneWidget);

    // Reject warns that mailing lists break; cancelled, nothing changes.
    await tap(tester, 'DMARC policy');
    await tap(tester, 'Reject');
    await tap(tester, 'Save');
    expect(find.text('Reject failing mail?'), findsOneWidget);
    await tap(tester, 'Cancel');
    expect(policy(), 'quarantine');

    await tap(tester, 'DMARC policy');
    await tap(tester, 'Reject');
    await tap(tester, 'Save');
    await tap(tester, 'Reject');
    expect(policy(), 'reject');
    expect(find.text('Reject'), findsOneWidget);

    await close(tester, fake, state);
  });
}
