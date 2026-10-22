import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/ui/mailboxes_screen.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');
const _chris = 'chris@${FakeAccounts.host}';

/// Settings → Accounts: creating a mailbox this account owns, with no
/// password of its own, and linking one by its password (and code), against
/// the fake, which keeps the server's rules for both.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState)> open(
    WidgetTester tester, {
    String email = FakeAccounts.adminEmail,
    String password = FakeAccounts.adminPassword,
    String? totpCode = FakeAccounts.totpCode,
    http.Client Function(FakeRestmail)? client,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => client?.call(fake) ?? fake.client,
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: email,
      password: password,
      totpCode: totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tapText(tester, 'Settings');
  }

  /// Settings → Create a mailbox, the local part (and name) typed in.
  Future<void> create(WidgetTester tester, String local, {String? name}) async {
    await openSettings(tester);
    await tapText(tester, 'Create a mailbox');
    await tester.enterText(find.byType(TextField).first, local);
    if (name != null) await tester.enterText(find.byType(TextField).last, name);
    await tester.pump();
    await tapText(tester, 'Create mailbox');
  }

  /// Waits out the snackbar a change shows, which covers the bottom of the
  /// screen.
  Future<void> snackGone(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 5));
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

  testWidgets('a mailbox created from Settings is listed at once, owned by '
      'this account, switchable, and sends', (tester) async {
    final (fake, state) = await open(tester);

    await create(tester, 'chris', name: 'Chris');

    expect(find.text('Created $_chris'), findsOneWidget);
    expect(fake.hasMailbox(_chris), isTrue);
    expect(fake.passwordOf(_chris), isNull);
    expect(fake.ownedBy(FakeAccounts.adminEmail), [_chris]);
    // In Settings, as a mailbox of this account.
    expect(find.text(_chris), findsOneWidget);
    expect(
      find.text('Mailbox of this account · ${FakeAccounts.host}'),
      findsOneWidget,
    );

    // Mail arrives for it; switch to it from the drawer and reply.
    fake.deliver(
      to: _chris,
      from: 'tom@ryeworks.test',
      fromName: 'Tom Rye',
      subject: 'Welcome aboard',
      body: 'Glad to have you.',
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Folders and accounts'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_chris));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(MailboxesScreen),
        matching: find.text('Inbox'),
      ),
    );
    await tester.pumpAndSettle();
    expect(state.mailbox!.account!.address, _chris);
    await snackGone(tester);
    await tapText(tester, 'Welcome aboard');
    await tapText(tester, 'Reply');
    await tapText(tester, 'Send');
    expect(find.text('Message sent'), findsOneWidget);
    expect(
      fake.messagesIn(_chris, 'Sent').single.subject,
      'Re: Welcome aboard',
    );

    await close(tester, fake, state);
  });

  testWidgets('without mailboxes:write there is no way to create one', (
    tester,
  ) async {
    final (fake, state) = await open(
      tester,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
      totpCode: null,
    );

    await openSettings(tester);
    expect(find.text('Link another mailbox'), findsOneWidget);
    expect(find.text('Create a mailbox'), findsNothing);

    await close(tester, fake, state);
  });

  testWidgets('what the server refuses is said plainly: 403, 409 and 422', (
    tester,
  ) async {
    final (fake, state) = await open(tester);

    // 409: the address is taken.
    await create(tester, 'dana');
    expect(find.text('${FakeAccounts.email} already exists.'), findsOneWidget);

    // 422: the server's own words.
    await tester.enterText(find.byType(TextField).first, 'two words');
    await tester.pump();
    await tapText(tester, 'Create mailbox');
    expect(find.text('must be a mail address: local@domain'), findsOneWidget);

    // 403: its grant taken away on the server since it signed in.
    fake.grant(FakeAccounts.adminEmail, {});
    await tester.enterText(find.byType(TextField).first, 'pat');
    await tester.pump();
    await tapText(tester, 'Create mailbox');
    expect(
      find.text(
        "${FakeAccounts.adminEmail} can't create mailboxes on "
        '${FakeAccounts.host}.',
      ),
      findsOneWidget,
    );
    expect(fake.hasMailbox('pat@${FakeAccounts.host}'), isFalse);
    expect(fake.ownedBy(FakeAccounts.adminEmail), isEmpty);

    await close(tester, fake, state);
  });

  testWidgets('a server with no such route says it is too old, and nothing '
      'else is tried', (tester) async {
    final sent = <String>[];
    final (fake, state) = await open(
      tester,
      client: (fake) => _OldServer(fake.client, sent),
    );

    await create(tester, 'chris');

    expect(
      find.text(
        "${FakeAccounts.host} can't create mailboxes: its REST Mail is older "
        'than this app.',
      ),
      findsOneWidget,
    );
    // Asked once, of the one route there is, and nothing tried in its place.
    expect(sent.where((r) => r.startsWith('POST') && !r.contains('/auth/')), [
      'POST /api/v1/accounts',
    ]);
    expect(fake.hasMailbox(_chris), isFalse);

    await close(tester, fake, state);
  });

  testWidgets('linking a mailbox with two-factor authentication says why a '
      'link is refused, asks for its code, and never renews the session for '
      'a refusal', (tester) async {
    final sent = <String>[];
    final (fake, state) = await open(
      tester,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
      totpCode: null,
      client: (fake) => _Noting(fake.client, sent),
    );
    fake.enableTwoFactor(FakeAccounts.otherEmail);

    await openSettings(tester);
    await tapText(tester, 'Link another mailbox');
    await tester.enterText(
      find.byType(TextField).at(0),
      FakeAccounts.otherEmail,
    );
    await tester.enterText(find.byType(TextField).at(1), 'not its password');
    await tester.pump();
    await tapText(tester, 'Link mailbox');
    expect(find.text('Wrong address or password.'), findsOneWidget);
    expect(find.text('TWO-FACTOR CODE'), findsNothing);

    await tester.enterText(find.byType(TextField).at(1), FakeAccounts.password);
    await tester.pump();
    await tapText(tester, 'Link mailbox');
    expect(find.text('TWO-FACTOR CODE'), findsOneWidget);
    expect(find.text('Wrong address or password.'), findsNothing);

    await tester.enterText(find.byType(TextField).at(2), '000000');
    await tester.pump();
    await tapText(tester, 'Link mailbox');
    expect(find.text("That code didn't work."), findsOneWidget);
    // The wrong code is cleared for the next one.
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
      isEmpty,
    );

    await tester.enterText(find.byType(TextField).at(2), FakeAccounts.totpCode);
    await tester.pump();
    await tapText(tester, 'Link mailbox');
    expect(find.text('Linked ${FakeAccounts.otherEmail}'), findsOneWidget);
    expect(fake.ownedBy(FakeAccounts.email), [FakeAccounts.otherEmail]);
    // Each try was sent once: a refused link is 403, so the session was
    // neither renewed nor the guess sent again.
    expect(sent.where((r) => r == 'POST /api/v1/accounts/link'), hasLength(4));
    expect(sent.where((r) => r.endsWith('/auth/refresh')), isEmpty);
    expect(state.mailbox!.accounts.map((a) => a.address), [
      FakeAccounts.email,
      FakeAccounts.otherEmail,
    ]);

    // And unlinked again.
    await snackGone(tester);
    await tapText(tester, FakeAccounts.otherEmail);
    await tapText(tester, 'Unlink from this account');
    await tapText(tester, 'Unlink');
    expect(find.text('Unlinked ${FakeAccounts.otherEmail}'), findsOneWidget);
    expect(fake.ownedBy(FakeAccounts.email), isEmpty);

    await close(tester, fake, state);
  });
}

/// The fake as it is, with every request noted.
class _Noting extends http.BaseClient {
  _Noting(this._inner, this._sent);

  final http.Client _inner;
  final List<String> _sent;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    _sent.add('${request.method} ${request.url.path}');
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// A server from before accounts were made this way: no route for creating
/// one, answered as Go's router does. Every request is noted.
class _OldServer extends http.BaseClient {
  _OldServer(this._inner, this._sent);

  final http.Client _inner;
  final List<String> _sent;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _sent.add('${request.method} ${request.url.path}');
    if (request.method == 'POST' && request.url.path == '/api/v1/accounts') {
      return http.StreamedResponse(
        Stream.value('404 page not found\n'.codeUnits),
        404,
        headers: {'content-type': 'text/plain; charset=utf-8'},
      );
    }
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
