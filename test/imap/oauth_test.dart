import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/imap/oauth.dart';
import 'package:restmail_api/restmail_api.dart';

import 'fake_auth_server.dart';

Matcher _apiError(String code, [int? status]) => isA<ApiException>()
    .having((e) => e.code, 'code', code)
    .having((e) => e.statusCode, 'statusCode', status ?? anything);

void main() {
  late FakeAuthServer server;

  setUp(() => server = FakeAuthServer());

  Future<OAuthGrant> signIn({String? hint = 'ada@outlook.com'}) =>
      signInWithOAuth(
        server.provider(),
        httpClient: server.client,
        browser: server.browser,
        loginHint: hint,
      );

  group('signing in', () {
    test('PKCE: the challenge is the S256 of the verifier, as RFC 7636 '
        'Appendix B has it', () {
      expect(
        Pkce.challengeOf('dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk'),
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
      );
      final pkce = Pkce.generate();
      expect(pkce.verifier, matches(RegExp(r'^[A-Za-z0-9\-._~]{43,128}$')));
      expect(Pkce.generate().verifier, isNot(pkce.verifier));
    });

    test('the request carries a challenge and never the verifier, and the '
        'code is exchanged with the verifier that matches it', () async {
      final grant = await signIn();

      final q = server.authorizations.single.queryParameters;
      expect(q['response_type'], 'code');
      expect(q['client_id'], 'client-1');
      expect(q['redirect_uri'], 'rest-mail://oauth/microsoft');
      expect(q['code_challenge_method'], 'S256');
      expect(q['code_challenge'], hasLength(43));
      expect(q['login_hint'], 'ada@outlook.com');
      expect(q['scope'], 'imap smtp offline_access openid email');
      expect(q['state'], isNotEmpty);
      expect(q.containsKey('code_verifier'), isFalse);
      // What the endpoint had in its own query stays.
      expect(q['tenant'], 'common');

      final exchange = server.tokenRequests.single;
      expect(exchange['grant_type'], 'authorization_code');
      expect(Pkce.challengeOf(exchange['code_verifier']!), q['code_challenge']);
      // A public client: the same redirect at both ends, and no secret.
      expect(exchange['redirect_uri'], q['redirect_uri']);
      expect(exchange.containsKey('client_secret'), isFalse);

      expect(grant.access.token, server.accessTokens.single);
      expect(server.liveRefreshTokens, {grant.refreshToken});
      // Who signed in, from the ID token.
      expect(grant.email, 'ada@outlook.com');
      expect(grant.name, 'Ada Lovelace');
    });

    test('each sign-in has its own state and verifier', () async {
      await signIn();
      await signIn();
      final [first, second] = server.authorizations
          .map((u) => u.queryParameters)
          .toList();
      expect(first['state'], isNot(second['state']));
      expect(first['code_challenge'], isNot(second['code_challenge']));
    });

    test("a redirect whose state isn't this request's is refused, and its "
        'code never used', () async {
      server.forgeState = 'someone-elses';
      await expectLater(signIn(), throwsA(_apiError('oauth_state')));
      expect(server.tokenRequests, isEmpty);
    });

    test('a redirect with no state at all is refused', () async {
      final provider = server.provider();
      expect(
        () => codeFromRedirect(
          Uri.parse('rest-mail://oauth/microsoft?code=abc'),
          provider: provider,
          expectedState: 'expected',
        ),
        throwsA(_apiError('oauth_state')),
      );
    });

    test('a redirect anywhere but the registered one is refused', () {
      final provider = server.provider();
      for (final wrong in [
        'rest-mail://setup/microsoft?code=abc&state=s',
        'rest-mail://oauth/google?code=abc&state=s',
        'evil://oauth/microsoft?code=abc&state=s',
      ]) {
        expect(
          () => codeFromRedirect(
            Uri.parse(wrong),
            provider: provider,
            expectedState: 's',
          ),
          throwsA(_apiError('oauth_redirect')),
          reason: wrong,
        );
      }
    });

    test('saying no at the consent page is reported, and nothing is '
        'exchanged', () async {
      server.refuse = 'access_denied';
      await expectLater(signIn(), throwsA(_apiError('access_denied', 403)));
      expect(server.tokenRequests, isEmpty);
    });

    test(
      "a code the server won't take back is an error, not an account",
      () async {
        final provider = server.provider();
        // The browser came back with a code this server never gave out.
        await expectLater(
          signInWithOAuth(
            provider,
            httpClient: server.client,
            browser: (authorize, redirect) async => redirect.replace(
              queryParameters: {
                'code': 'made-up',
                'state': authorize.queryParameters['state'],
              },
            ),
          ),
          throwsA(_apiError('invalid_grant', 401)),
        );
      },
    );

    test('Google: an iOS client comes back to its own id, reversed', () {
      expect(
        OAuthProvider.googleIosRedirect('123-abc.apps.googleusercontent.com')
            .toString(),
        'com.googleusercontent.apps.123-abc:/oauth2redirect',
      );
      expect(
        OAuthProvider.googleAndroidRedirect.toString(),
        'com.antimatterstudios.restmail:/oauth2redirect',
      );
    });

    test('a build given no client ids has no sign-in at all', () {
      for (final android in [true, false]) {
        final clients = OAuthClients.fromEnvironment(android: android);
        expect(clients.microsoft, isNull);
        expect(clients.google, isNull);
      }
    });

    test('Outlook.com and Microsoft 365 sign in with Microsoft, Gmail and '
        'Workspace with Google, the rest with a password', () {
      expect(oauthKindFor(MailProviders.outlook, null), OAuthKind.microsoft);
      expect(oauthKindFor(MailProviders.gmail, null), OAuthKind.google);
      expect(oauthKindFor(MailProviders.icloud, null), isNull);
      expect(
        oauthKindFor(
          null,
          const MailServerSettings(
            imapHost: 'outlook.office365.com',
            smtpHost: 'smtp.office365.com',
          ),
        ),
        OAuthKind.microsoft,
      );
      expect(
        oauthKindFor(
          null,
          const MailServerSettings(
            imapHost: 'imap.gmail.com',
            smtpHost: 'smtp.gmail.com',
          ),
        ),
        OAuthKind.google,
      );
    });

    test('the ID token is read for the address, and junk is ignored', () {
      String jwt(Object claims) =>
          'e30.${base64Url.encode(utf8.encode(jsonEncode(claims)))}.x';
      expect(idTokenClaims(jwt({'preferred_username': 'a@b.c'})), {
        'preferred_username': 'a@b.c',
      });
      expect(idTokenClaims('not a jwt'), isEmpty);
      expect(idTokenClaims('a.!!!.c'), isEmpty);
      expect(idTokenClaims(null), isEmpty);
    });
  });

  group('the session', () {
    late DateTime now;
    late List<String> kept;
    late int ended;

    setUp(() {
      now = DateTime(2026, 10, 17, 9);
      kept = [];
      ended = 0;
    });

    Future<OAuthSession> session({bool scopeOnRefresh = true}) async {
      final grant = await signInWithOAuth(
        server.provider(),
        httpClient: server.client,
        browser: server.browser,
        now: () => now,
      );
      return OAuthSession(
        kind: OAuthKind.microsoft,
        provider: server.provider(scopeOnRefresh: scopeOnRefresh),
        refreshToken: grant.refreshToken,
        httpClient: server.clients,
        access: grant.access,
        onRefreshTokenChanged: kept.add,
        onEnded: () => ended++,
        now: () => now,
      );
    }

    int refreshes() => server.tokenRequests
        .where((r) => r['grant_type'] == 'refresh_token')
        .length;

    test(
      'a fresh token is used as it is; one within five minutes of '
      'running out is renewed first, and the new refresh token kept',
      () async {
        final s = await session();
        final first = await s.accessToken();
        expect(first, server.accessTokens.single);
        now = now.add(const Duration(minutes: 54));
        expect(await s.accessToken(), first);
        expect(refreshes(), 0);

        now = now.add(const Duration(minutes: 2));
        final second = await s.accessToken();
        expect(second, isNot(first));
        expect(refreshes(), 1);
        final refresh = server.tokenRequests.last;
        expect(refresh['client_id'], 'client-1');
        expect(refresh['scope'], 'imap smtp offline_access openid email');
        expect(refresh.containsKey('client_secret'), isFalse);
        // Microsoft sent a new refresh token; the old one is spent.
        expect(kept, [s.refreshToken]);
        expect(server.liveRefreshTokens, {s.refreshToken});
      },
    );

    test('Google sends no new refresh token, so the first one is kept, and '
        'its refresh carries no scope', () async {
      server.rotate = false;
      final s = await session(scopeOnRefresh: false);
      final before = s.refreshToken;
      await s.accessToken(rejected: await s.accessToken());
      expect(s.refreshToken, before);
      expect(kept, isEmpty);
      expect(server.tokenRequests.last.containsKey('scope'), isFalse);
    });

    test('a token a server turned down is replaced, once, however many '
        'connections were turned down with it', () async {
      final s = await session();
      final stale = await s.accessToken();
      final fresh = await Future.wait([
        s.accessToken(rejected: stale),
        s.accessToken(rejected: stale),
      ]);
      expect(fresh.toSet(), hasLength(1));
      expect(fresh.first, isNot(stale));
      // Late to the news, it gets the new one rather than another refresh.
      expect(await s.accessToken(rejected: stale), fresh.first);
      expect(refreshes(), 1);
    });

    test('revoked consent ends the session: invalid_grant, onEnded once, '
        'and nothing more is asked of the server', () async {
      final s = await session();
      server.revokeAll();
      now = now.add(const Duration(hours: 2));

      await expectLater(
        s.accessToken(),
        throwsA(_apiError('invalid_grant', 401)),
      );
      await Future<void>.delayed(Duration.zero);
      expect(ended, 1);
      expect(s.hasEnded, isTrue);

      final asked = server.tokenRequests.length;
      await expectLater(
        s.accessToken(),
        throwsA(_apiError('invalid_grant', 401)),
      );
      await Future<void>.delayed(Duration.zero);
      expect(server.tokenRequests, hasLength(asked));
      expect(ended, 1);
    });

    test(
      'a network failure on refresh is only that: the session goes on',
      () async {
        final grant = await signIn();
        var down = true;
        final s = OAuthSession(
          kind: OAuthKind.microsoft,
          provider: server.provider(),
          refreshToken: grant.refreshToken,
          httpClient: () => down
              ? MockClient((_) => Future.error(const SocketException('down')))
              : server.client,
          onEnded: () => ended++,
        );
        await expectLater(s.accessToken(), throwsA(_apiError('network_error')));
        down = false;
        expect(await s.accessToken(), server.accessTokens.last);
        expect(ended, 0);
      },
    );

    test('with no client in this build, an account says so and asks '
        'nobody', () async {
      final s = OAuthSession(
        kind: OAuthKind.google,
        provider: null,
        refreshToken: 'refresh',
        httpClient: server.clients,
      );
      await expectLater(
        s.accessToken(),
        throwsA(_apiError('oauth_unavailable', 401)),
      );
      expect(server.tokenRequests, isEmpty);
    });
  });
}
