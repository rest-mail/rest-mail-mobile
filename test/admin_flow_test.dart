import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
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

  Future<void> signInAdmin(AppState state, String username) =>
      state.signInAdmin(
        server: _server,
        username: username,
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

  const sections = ['Outbound queue', 'Domains', 'Mailboxes', 'Aliases'];

  testWidgets('an administrator signs in with a code and opens on every '
      'section, and runs the server from there', (tester) async {
    final (fake, state) = await open(tester);
    await tester.pumpWidget(RestmailApp(state: state));

    await tap(tester, 'Add an account');
    await tap(tester, 'Sign in as an administrator');
    await tester.enterText(find.byType(TextField).at(0), FakeAccounts.host);
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeAccounts.adminUsername,
    );
    await tester.enterText(
      find.byType(TextField).at(2),
      FakeAccounts.adminPassword,
    );
    await tester.pump();
    await tap(tester, 'Sign in');
    expect(find.text('TWO-FACTOR CODE'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(3), FakeAccounts.totpCode);
    await tester.pump();
    await tap(tester, 'Sign in');

    // No mailbox, and no complaint about it: Administration, all of it.
    expect(state.mailbox, isNull);
    expect(find.text('This session has no mailbox'), findsNothing);
    expect(find.text('Administration'), findsOneWidget);
    for (final section in sections) {
      expect(find.text(section), findsOneWidget, reason: section);
    }

    // A deferred message, retried.
    await tap(tester, 'Outbound queue');
    expect(find.text('tom@ryeworks.test'), findsOneWidget);
    await tap(tester, 'tom@ryeworks.test');
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
    await tester.enterText(find.byType(TextField), 'new.test');
    await tester.pump();
    await tap(tester, 'Add domain');
    expect(find.text('new.test'), findsOneWidget);
    expect(fake.domains.map((d) => d.name), contains('new.test'));
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // An alias deleted.
    await tap(tester, 'Aliases');
    await tap(tester, 'hello@${FakeAccounts.host}');
    await tap(tester, 'Delete alias');
    await tap(tester, 'Delete');
    expect(find.text('Deleted hello@${FakeAccounts.host}'), findsOneWidget);
    expect(fake.aliases, isEmpty);

    await close(tester, fake, state);
  });

  testWidgets('an administrator with only queue:read sees only the queue, '
      'and nothing to change in it', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.queueWatcher);
    await tester.pumpWidget(RestmailApp(state: state));

    expect(find.text('Outbound queue'), findsOneWidget);
    for (final section in sections.skip(1)) {
      expect(find.text(section), findsNothing, reason: section);
    }

    await tap(tester, 'Outbound queue');
    await tap(tester, 'tom@ryeworks.test');
    expect(find.text('Deferred'), findsOneWidget);
    for (final action in ['Retry now', 'Bounce to sender', 'Delete']) {
      expect(find.text(action), findsNothing, reason: action);
    }

    await close(tester, fake, state);
  });

  testWidgets('a capability taken away on the server goes from the app at '
      'the next refresh', (tester) async {
    final (fake, state) = await open(tester);
    await signInAdmin(state, FakeAccounts.adminUsername);
    await tester.pumpWidget(RestmailApp(state: state));
    await tap(tester, 'Domains');
    expect(find.text(FakeAccounts.host), findsOneWidget);

    fake.grant(FakeAccounts.adminUsername, {'queue:read'});
    await (state.current! as RestAccount).client.refresh();
    await tester.pumpAndSettle();

    // The screen open on it says so, and the section is gone behind it.
    expect(find.text(noPermission), findsOneWidget);
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

    await tap(tester, 'Mailboxes');
    expect(find.text(noPermission), findsOneWidget);
    expect(find.text(FakeAccounts.email), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tap(tester, 'Outbound queue');
    await tap(tester, 'ana@harbor.test');
    await tap(tester, 'Retry now');
    expect(find.text(noPermission), findsOneWidget);
    expect(
      fake.queue.firstWhere((e) => e.recipient == 'ana@harbor.test').status,
      'pending',
    );

    await close(tester, fake, state);
  });

  testWidgets('a mailbox session reaches Administration from the drawer only '
      'when it holds a capability', (tester) async {
    final (fake, state) = await open(tester);
    // Grants on a mailbox, as rest-mail-server#347 has them.
    fake.grant(FakeAccounts.otherEmail, {'queue:read'});
    await state.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Folders and accounts'));
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
    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tap(tester, 'Administration');
    expect(find.text('Outbound queue'), findsOneWidget);
    expect(find.text('Domains'), findsNothing);

    await close(tester, fake, state);
  });
}
