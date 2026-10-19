import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/imap/oauth.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'fake_auth_server.dart';
import 'scripted_server.dart';

/// Outlook.com's servers, with SMTP over TLS from the first byte: the
/// scripted server plays TLS in the clear, and doesn't do STARTTLS.
const _outlook = MailServerSettings(
  imapHost: 'outlook.office365.com',
  smtpHost: 'smtp-mail.outlook.com',
);

const _gmail = MailServerSettings(
  imapHost: 'imap.gmail.com',
  smtpHost: 'smtp.gmail.com',
  filesSentMail: true,
);

/// What XOAUTH2 sends, decoded: `user=…^Aauth=Bearer …^A^A`.
({String user, String token})? _xoauth2(String base64Text) {
  try {
    final text = utf8.decode(base64.decode(base64Text.trim()));
    final match = RegExp(
      '^user=([^\u0001]*)\u0001auth=Bearer ([^\u0001]*)\u0001\u0001\$',
    ).firstMatch(text);
    if (match == null) return null;
    return (user: match[1]!, token: match[2]!);
  } on FormatException {
    return null;
  }
}

void main() {
  late FakeAuthServer auth;
  late FakeRestmail rest;
  late ScriptedServer imap;
  late ScriptedServer smtp;
  late MemoryKeyValueStore store;

  /// Access tokens the mail servers turn down, as Google does at once for
  /// the tokens of an app whose access was taken away.
  late Set<String> refused;

  /// Who signed in to IMAP and SMTP, and with which token.
  late List<({String user, String token})> imapLogins;
  late List<({String user, String token})> smtpLogins;

  bool takes(({String user, String token})? login) =>
      login != null &&
      auth.accessTokens.contains(login.token) &&
      !refused.contains(login.token);

  setUp(() async {
    auth = FakeAuthServer();
    rest = FakeRestmail();
    store = MemoryKeyValueStore();
    refused = {};
    imapLogins = [];
    smtpLogins = [];
    imap = await ScriptedServer.start(
      '* OK The Microsoft Exchange IMAP4 service is ready.',
      [
        Rule.answering(r'^AUTHENTICATE XOAUTH2 ', (command) {
          final login = _xoauth2(command.split(' ').last);
          if (login != null) imapLogins.add(login);
          return takes(login)
              ? '{tag} OK [CAPABILITY IMAP4 IMAP4rev1 AUTH=PLAIN '
                    'AUTH=XOAUTH2 SASL-IR UIDPLUS MOVE ID UNSELECT CHILDREN '
                    'IDLE NAMESPACE LITERAL+ SPECIAL-USE] AUTHENTICATE '
                    'completed.'
              : '{tag} NO AUTHENTICATE failed.';
        }, repeat: true),
        Rule(r'^LIST ', r'''* LIST (\HasNoChildren) "/" "INBOX"
* LIST (\HasNoChildren \Sent) "/" "Sent"
* LIST (\HasNoChildren \Trash) "/" "Deleted"
* LIST (\HasNoChildren \Drafts) "/" "Drafts"
* LIST (\HasNoChildren \Junk) "/" "Junk"
{tag} OK LIST completed.''', repeat: true),
        Rule(r'^SELECT', selected('INBOX', exists: 0), repeat: true),
        Rule(
          r'^STATUS',
          '* STATUS "x" (MESSAGES 0 UNSEEN 0)\n{tag} OK STATUS completed.',
          repeat: true,
        ),
        Rule(r'^LOGOUT', '* BYE\n{tag} OK LOGOUT completed.', repeat: true),
      ],
    );
    smtp = await ScriptedServer.start('220 smtp-mail.outlook.com ESMTP', [
      Rule(
        r'^EHLO',
        '250-smtp-mail.outlook.com\n250-AUTH LOGIN XOAUTH2\n250 8BITMIME',
        repeat: true,
      ),
      Rule(r'^AUTH XOAUTH2$', '334 ', repeat: true),
      Rule.answering(r'^[A-Za-z0-9+/]{16,}=*$', (command) {
        final login = _xoauth2(command);
        if (login != null) smtpLogins.add(login);
        // Refused, the server says why in base64 and waits for an empty
        // line before its 535.
        return takes(login)
            ? '235 2.7.0 Authentication successful'
            : '334 eyJzdGF0dXMiOiI0MDEifQ==';
      }, repeat: true),
      Rule(r'^$', '535 5.7.3 Authentication unsuccessful', repeat: true),
      Rule(r'^QUIT', '221 2.0.0 Service closing', repeat: true),
    ], smtp: true);
  });
  tearDown(() async {
    rest.close();
    await imap.close();
    await smtp.close();
  });

  AppState newState({OAuthClients? oauth, OAuthBrowser? browser}) {
    final state = AppState(
      store: store,
      httpClientFactory: () => _Routes(auth.client, rest.client),
      mailSockets: (host, port, {required tls}) =>
          (host.startsWith('smtp') ? smtp : imap).sockets(host, port, tls: tls),
      oauth:
          oauth ??
          OAuthClients(
            microsoft: auth.provider(),
            google: auth.provider(
              kind: OAuthKind.google,
              scopeOnRefresh: false,
            ),
          ),
      oauthBrowser: browser ?? auth.browser,
    );
    addTearDown(state.dispose);
    return state;
  }

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 150));

  Map<String, dynamic> saved(String key) =>
      jsonDecode(store.values['account:$key']!) as Map<String, dynamic>;

  test('Sign in with Microsoft adds Outlook.com over XOAUTH2, keeps only the '
      'refresh token, and after a restart renews the access token before '
      'signing in to IMAP', () async {
    final state = newState();
    await state.start();

    await state.addOAuthAccount(
      kind: OAuthKind.microsoft,
      address: 'ada@outlook.com',
      settings: _outlook,
      provider: MailProviders.outlook,
    );
    await settle();

    final account = state.current! as ImapAccount;
    expect(account.address, 'ada@outlook.com');
    // The name came from Microsoft, as none was typed.
    expect(account.displayName, 'Ada Lovelace');
    expect(account.oauth?.kind, OAuthKind.microsoft);
    expect(state.mailbox!.error, isNull);

    // Both servers were signed in to with the token, never a password.
    expect(imap.commands.where((c) => c.startsWith('LOGIN')), isEmpty);
    expect(imapLogins.first.user, 'ada@outlook.com');
    expect(imapLogins.first.token, auth.accessTokens.first);
    expect(smtpLogins.single.user, 'ada@outlook.com');
    expect(smtp.commands, contains('AUTH XOAUTH2'));

    const key = 'imaps://outlook.office365.com|ada@outlook.com';
    final entry = saved(key);
    expect(entry['kind'], 'imap');
    expect(entry.containsKey('password'), isFalse);
    expect(entry['oauth'], {
      'provider': 'microsoft',
      'refresh_token': auth.liveRefreshTokens.single,
    });
    // The access token is kept in memory only.
    for (final token in auth.accessTokens) {
      expect(store.values.values.where((v) => v.contains(token)), isEmpty);
    }

    final again = newState();
    await again.start();
    await settle();

    expect(again.current?.address, 'ada@outlook.com');
    expect(again.mailbox!.error, isNull);
    final refresh = auth.tokenRequests.last;
    expect(refresh['grant_type'], 'refresh_token');
    // The first sign-in after the restart used the renewed token...
    expect(imapLogins.last.token, auth.accessTokens.last);
    // ...and Microsoft's new refresh token replaced the spent one.
    expect(saved(key)['oauth']['refresh_token'], auth.liveRefreshTokens.single);
    expect(refresh['refresh_token'], isNot(auth.liveRefreshTokens.single));
  });

  test(
    'the account is the one that signed in, not the address typed',
    () async {
      auth.email = 'ada.lovelace@outlook.com';
      final state = newState();
      await state.start();

      await state.addOAuthAccount(
        kind: OAuthKind.microsoft,
        address: 'ada@outlook.com',
        displayName: 'Countess',
        settings: _outlook,
        provider: MailProviders.outlook,
      );

      expect(state.current?.address, 'ada.lovelace@outlook.com');
      expect(state.current?.displayName, 'Countess');
      expect(imapLogins.first.user, 'ada.lovelace@outlook.com');
      expect(
        auth.authorizations.single.queryParameters['login_hint'],
        'ada@outlook.com',
      );
    },
  );

  test(
    'revoking the app at Microsoft signs the account out at its next '
    'sign-in and keeps it; signing in again brings it back as it was',
    () async {
      const key = 'imaps://outlook.office365.com|ada@outlook.com';
      final state = newState();
      await state.start();
      await state.addOAuthAccount(
        kind: OAuthKind.microsoft,
        address: 'ada@outlook.com',
        displayName: 'Countess',
        settings: _outlook,
        provider: MailProviders.outlook,
      );
      await settle();

      auth.revokeAll();
      final again = newState();
      await again.start();
      await settle();

      final account = again.current! as ImapAccount;
      expect(again.phase, AppPhase.signedIn);
      expect(again.accounts, [account]);
      expect(account.address, 'ada@outlook.com');
      expect(account.displayName, 'Countess');
      expect(
        account.signedOut,
        'Microsoft no longer lets REST Mail into ada@outlook.com. Sign in '
        'again to carry on.',
      );
      // Kept as it was, but for the refresh token that stopped working.
      expect(saved(key)['display_name'], 'Countess');
      expect(saved(key)['settings'], isNotNull);
      expect(saved(key)['oauth'], {'provider': 'microsoft'});

      // The next launch starts it signed out, and asks Microsoft nothing.
      final asked = auth.tokenRequests.length;
      final logins = imapLogins.length;
      final third = newState();
      await third.start();
      await settle();
      expect(third.current!.signedOut, isNotNull);
      expect(auth.tokenRequests, hasLength(asked));
      expect(imapLogins, hasLength(logins));

      // Signing in as somebody else doesn't sign it in.
      auth.email = 'grace@outlook.com';
      await expectLater(
        third.signInAgain(third.current! as ImapAccount),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'other_account'),
        ),
      );
      expect(third.accounts.single.signedOut, isNotNull);
      expect(saved(key)['oauth'], {'provider': 'microsoft'});

      auth.email = 'ada@outlook.com';
      await third.signInAgain(third.current! as ImapAccount);
      await settle();

      final back = third.current! as ImapAccount;
      expect(third.accounts, [back]);
      expect(back.signedOut, isNull);
      expect(back.displayName, 'Countess');
      expect(third.mailbox!.error, isNull);
      expect(imapLogins.last.token, auth.accessTokens.last);
      expect(
        auth.authorizations.last.queryParameters['login_hint'],
        'ada@outlook.com',
      );
      // Kept with the refresh token Microsoft has just given, one that
      // works.
      final kept = saved(key)['oauth'] as Map<String, dynamic>;
      expect(kept['provider'], 'microsoft');
      expect(auth.liveRefreshTokens, contains(kept['refresh_token']));
    },
  );

  test('Google: a token turned down at once is renewed, and when the '
      'renewal is refused too the account signs out, and stays', () async {
    final state = newState();
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    auth.email = 'ada@gmail.com';
    await state.addOAuthAccount(
      kind: OAuthKind.google,
      address: 'ada@gmail.com',
      settings: _gmail,
      provider: MailProviders.gmail,
    );
    await settle();
    expect(state.accounts, hasLength(2));
    final notices = <String>[];
    final listening = state.notices.listen(notices.add);
    addTearDown(listening.cancel);

    // The owner takes REST Mail's access away at Google: the token it holds
    // stops working at once, and so does the refresh token.
    auth.revokeAll();
    refused.addAll(auth.accessTokens);
    final gmail = state.current! as ImapAccount;
    await gmail.backend.disconnect();
    final logins = imapLogins.length;
    await state.mailbox!.refresh();
    await settle();

    // One more try, with a renewal that Google refused.
    expect(imapLogins.length, logins + 1);
    expect(auth.tokenRequests.last['grant_type'], 'refresh_token');
    expect(state.accounts.map((a) => a.kind), [
      AccountKind.rest,
      AccountKind.imap,
    ]);
    // On screen, where it says so itself: no notice.
    expect(state.current, same(gmail));
    expect(
      gmail.signedOut,
      'Google no longer lets REST Mail into ada@gmail.com. Sign in again to '
      'carry on.',
    );
    expect(notices, isEmpty);
    expect(saved('imaps://imap.gmail.com|ada@gmail.com')['oauth'], {
      'provider': 'google',
    });
  });

  test('a token the server turns down while the refresh token still works '
      'is renewed, and the account goes on', () async {
    final state = newState();
    await state.start();
    await state.addOAuthAccount(
      kind: OAuthKind.microsoft,
      address: 'ada@outlook.com',
      settings: _outlook,
      provider: MailProviders.outlook,
    );
    await settle();

    refused.addAll(auth.accessTokens);
    final account = state.current! as ImapAccount;
    await account.backend.disconnect();
    await state.mailbox!.refresh();
    await settle();

    expect(state.current, same(account));
    expect(imapLogins.last.token, auth.accessTokens.last);
    expect(refused, isNot(contains(imapLogins.last.token)));
  });

  test('IMAP and SMTP each replace a turned-down token once, on the same '
      'connection', () async {
    auth.accessTokens.add('fresh');
    final asked = <String?>[];
    Future<String> token({String? rejected}) async {
      asked.add(rejected);
      return rejected == null ? 'stale' : 'fresh';
    }

    final connection = await ImapConnection.open(
      _outlook,
      address: 'ada@outlook.com',
      accessToken: token,
      openSocket: imap.sockets,
    );
    await connection.close();
    final client = await openSmtp(
      _outlook,
      address: 'ada@outlook.com',
      accessToken: token,
      openSocket: smtp.sockets,
    );
    await client.quit();

    expect(asked, [null, 'stale', null, 'stale']);
    expect(imapLogins.map((l) => l.token), ['stale', 'fresh']);
    expect(smtpLogins.map((l) => l.token), ['stale', 'fresh']);
    expect(smtp.commands.where((c) => c == 'AUTH XOAUTH2'), hasLength(2));
    expect(imap.connections, 1);
    expect(smtp.connections, 1);
  });

  test(
    'signing out of a Google account gives its refresh token back and keeps '
        'the account',
    () async {
      final state = newState();
      await state.start();
      auth.email = 'ada@gmail.com';
      await state.addOAuthAccount(
        kind: OAuthKind.google,
        address: 'ada@gmail.com',
        settings: _gmail,
        provider: MailProviders.gmail,
      );
      final token = (state.current! as ImapAccount).oauth!.refreshToken;

      await state.signOut();

      expect(auth.revocations, [token]);
      expect(state.accounts, hasLength(1));
      expect(state.current!.signedOut, isNotNull);
      expect(store.values, isNotEmpty);

      final restarted = newState();
      await restarted.start();
      expect(restarted.accounts, hasLength(1));
      expect(restarted.current!.signedOut, isNotNull);
      expect((restarted.current! as ImapAccount).oauth!.kind, OAuthKind.google);

      await state.removeAccount(state.current);
      expect(state.accounts, isEmpty);
      expect(store.values, isEmpty);
    },
  );

  test(
    'closing the sign-in page, or a build with no client, adds nothing',
    () async {
      final cancelled = newState(
        browser: (_, _) async =>
            throw const ApiException(0, 'cancelled', 'Sign-in was cancelled.'),
      );
      await cancelled.start();
      await expectLater(
        cancelled.addOAuthAccount(
          kind: OAuthKind.microsoft,
          address: 'ada@outlook.com',
          settings: _outlook,
        ),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'cancelled')),
      );

      final none = newState(oauth: OAuthClients.none);
      await none.start();
      await expectLater(
        none.addOAuthAccount(
          kind: OAuthKind.google,
          address: 'ada@gmail.com',
          settings: _gmail,
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'oauth_unavailable',
          ),
        ),
      );

      expect(cancelled.accounts, isEmpty);
      expect(none.accounts, isEmpty);
      expect(store.values, isEmpty);
      expect(auth.tokenRequests, isEmpty);
      expect(imap.connections, 0);
    },
  );
}

/// The app's one HTTP client, as the tests see it: the token requests to
/// the fake authorisation server, everything else to the REST Mail fake.
class _Routes extends http.BaseClient {
  _Routes(this.auth, this.rest);

  final http.Client auth;
  final http.Client rest;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      (request.url.host == FakeAuthServer.tokenEndpoint.host ? auth : rest)
          .send(request);

  // Both fakes outlive the clients the app makes and closes.
  @override
  void close() {}
}
