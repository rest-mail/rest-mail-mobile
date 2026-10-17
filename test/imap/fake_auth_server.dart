import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/imap/oauth.dart';

/// One authorisation request the person has said yes to, waiting for its
/// code to be exchanged.
class _Pending {
  _Pending(this.challenge, this.method, this.redirect, this.clientId);

  final String? challenge;
  final String? method;
  final String? redirect;
  final String? clientId;
}

/// A pretend Microsoft or Google: an authorisation endpoint, played by
/// [browser] as the person's browser would reach it, and a token endpoint
/// behind [client]. It checks what a real one checks (the PKCE verifier
/// against the challenge, the redirect, the client) and can revoke a
/// refresh token, as its owner would by taking the app's access away.
class FakeAuthServer {
  FakeAuthServer({
    this.clientId = 'client-1',
    Uri? redirect,
    this.rotate = true,
    this.email = 'ada@outlook.com',
    this.name = 'Ada Lovelace',
  }) : redirect = redirect ?? Uri.parse('rest-mail://oauth/microsoft');

  static final authorizeEndpoint = Uri.parse(
    'https://login.example/oauth2/authorize?tenant=common',
  );
  static final tokenEndpoint = Uri.parse('https://login.example/oauth2/token');
  static final revokeEndpoint = Uri.parse(
    'https://login.example/oauth2/revoke',
  );

  final String clientId;
  final Uri redirect;

  /// Sends a new refresh token with every refresh, as Microsoft does;
  /// Google doesn't.
  bool rotate;

  /// Who signs in at the consent page, as the ID token will say.
  String? email;
  String? name;

  /// How long each access token lasts.
  Duration lifetime = const Duration(hours: 1);

  /// What the person does at the consent page: null to allow, or an OAuth
  /// error such as `access_denied`.
  String? refuse;

  /// Makes the redirect carry this state instead of the request's.
  String? forgeState;

  final authorizations = <Uri>[];
  final tokenRequests = <Map<String, String>>[];
  final revocations = <String>[];

  /// The access tokens issued, newest last.
  final accessTokens = <String>[];

  final _pending = <String, _Pending>{};
  final _refreshTokens = <String>{};
  var _serial = 0;

  /// The refresh tokens that still work.
  Set<String> get liveRefreshTokens => {..._refreshTokens};

  /// The owner takes the app's access away: every refresh token stops
  /// working.
  void revokeAll() => _refreshTokens.clear();

  OAuthProvider provider({
    OAuthKind kind = OAuthKind.microsoft,
    bool scopeOnRefresh = true,
  }) => OAuthProvider(
    kind: kind,
    clientId: clientId,
    redirectUri: redirect,
    authorizationEndpoint: authorizeEndpoint,
    tokenEndpoint: tokenEndpoint,
    revocationEndpoint: revokeEndpoint,
    scopes: const ['imap', 'smtp', 'offline_access', 'openid', 'email'],
    scopeOnRefresh: scopeOnRefresh,
  );

  /// The person's browser at the authorisation endpoint: they sign in, say
  /// yes (or [refuse]), and are sent back to the redirect the request named.
  Future<Uri> browser(Uri authorize, Uri expectedRedirect) async {
    authorizations.add(authorize);
    final q = authorize.queryParameters;
    final back = Uri.parse(q['redirect_uri']!);
    final state = forgeState ?? q['state'];
    final refusal = refuse;
    if (refusal != null) {
      return back.replace(queryParameters: {'error': refusal, 'state': ?state});
    }
    final code = 'code-${++_serial}';
    _pending[code] = _Pending(
      q['code_challenge'],
      q['code_challenge_method'],
      q['redirect_uri'],
      q['client_id'],
    );
    return back.replace(queryParameters: {'code': code, 'state': ?state});
  }

  late final http.Client client = MockClient(_handle);

  /// A client that [close] doesn't close, as the app closes each one it is
  /// given.
  http.Client Function() get clients =>
      () => client;

  Future<http.Response> _handle(http.Request request) async {
    if (request.url == revokeEndpoint) {
      final token = request.bodyFields['token']!;
      revocations.add(token);
      _refreshTokens.remove(token);
      return http.Response('', 200);
    }
    if (request.url != tokenEndpoint || request.method != 'POST') {
      return http.Response('not here', 404);
    }
    final form = request.bodyFields;
    tokenRequests.add(form);
    if (form['client_id'] != clientId || form.containsKey('client_secret')) {
      return _error('invalid_client', status: 401);
    }
    switch (form['grant_type']) {
      case 'authorization_code':
        final pending = _pending.remove(form['code']);
        if (pending == null) return _error('invalid_grant');
        if (pending.clientId != clientId ||
            form['redirect_uri'] != pending.redirect) {
          return _error('invalid_grant', description: 'redirect_uri mismatch');
        }
        if (pending.method != 'S256') return _error('invalid_request');
        final verifier = form['code_verifier'] ?? '';
        final challenge = base64Url
            .encode(sha256.convert(ascii.encode(verifier)).bytes)
            .replaceAll('=', '');
        if (challenge != pending.challenge) {
          return _error(
            'invalid_grant',
            description: 'PKCE verification failed',
          );
        }
        return _issue(refresh: true, idToken: true);
      case 'refresh_token':
        final token = form['refresh_token'];
        if (!_refreshTokens.contains(token)) {
          return _error(
            'invalid_grant',
            description: 'AADSTS70000: consent revoked',
          );
        }
        if (rotate) _refreshTokens.remove(token);
        return _issue(refresh: rotate, idToken: false);
      default:
        return _error('unsupported_grant_type');
    }
  }

  http.Response _issue({required bool refresh, required bool idToken}) {
    final n = ++_serial;
    final access = 'access-$n';
    accessTokens.add(access);
    final body = <String, Object>{
      'token_type': 'Bearer',
      'access_token': access,
      'expires_in': lifetime.inSeconds,
    };
    if (refresh) {
      final token = 'refresh-$n';
      _refreshTokens.add(token);
      body['refresh_token'] = token;
    }
    if (idToken) body['id_token'] = _jwt({'email': ?email, 'name': ?name});
    return http.Response(
      jsonEncode(body),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  static http.Response _error(
    String error, {
    String? description,
    int status = 400,
  }) => http.Response(
    jsonEncode({'error': error, 'error_description': ?description}),
    status,
    headers: {'content-type': 'application/json'},
  );

  static String _jwt(Map<String, Object> claims) {
    String part(Object json) =>
        base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
    return '${part({'alg': 'none'})}.${part(claims)}.sig';
  }
}
