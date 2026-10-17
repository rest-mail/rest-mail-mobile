import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';

/// Who signs a mail account in for IMAP and SMTP, in place of a password.
enum OAuthKind {
  /// Outlook.com, Hotmail and Live, and work or school Microsoft 365
  /// accounts. Microsoft turned passwords off for both.
  microsoft('Microsoft'),

  /// Gmail and Google Workspace, on an unverified client: for the owner's
  /// personal use only (#37). App passwords stay the way in for everyone
  /// else.
  google('Google');

  const OAuthKind(this.label);

  final String label;
}

/// One OAuth client the app signs in with: a public client, so PKCE and no
/// secret (RFC 8252). Its id comes from the build (see [OAuthClients]).
class OAuthProvider {
  const OAuthProvider({
    required this.kind,
    required this.clientId,
    required this.redirectUri,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.scopes,
    this.scopeOnRefresh = false,
    this.revocationEndpoint,
  });

  /// Microsoft's common endpoint, so personal accounts (Outlook.com) and
  /// work or school ones both sign in. The token is for Exchange Online's
  /// IMAP and SMTP; `openid email profile` add the ID token the address and
  /// name are read from.
  factory OAuthProvider.microsoft(String clientId) => OAuthProvider(
    kind: OAuthKind.microsoft,
    clientId: clientId,
    redirectUri: microsoftRedirect,
    authorizationEndpoint: Uri.parse(
      'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
    ),
    tokenEndpoint: Uri.parse(
      'https://login.microsoftonline.com/common/oauth2/v2.0/token',
    ),
    scopes: const [
      'https://outlook.office.com/IMAP.AccessAsUser.All',
      'https://outlook.office.com/SMTP.Send',
      'offline_access',
      'openid',
      'email',
      'profile',
    ],
    // Microsoft's v2 endpoint wants the scopes again on a refresh.
    scopeOnRefresh: true,
  );

  /// `https://mail.google.com/` is the one scope Gmail's IMAP and SMTP take.
  factory OAuthProvider.google(String clientId, {required Uri redirectUri}) =>
      OAuthProvider(
        kind: OAuthKind.google,
        clientId: clientId,
        redirectUri: redirectUri,
        authorizationEndpoint: Uri.parse(
          'https://accounts.google.com/o/oauth2/v2/auth',
        ),
        tokenEndpoint: Uri.parse('https://oauth2.googleapis.com/token'),
        revocationEndpoint: Uri.parse('https://oauth2.googleapis.com/revoke'),
        scopes: const ['https://mail.google.com/', 'openid', 'email'],
      );

  /// Microsoft takes any scheme for a mobile client, so it comes back
  /// through the app's own.
  static final microsoftRedirect = Uri.parse('rest-mail://oauth/microsoft');

  /// Google takes only the app's package name as the scheme of an Android
  /// client's redirect, and only once "custom URI scheme" is turned on in
  /// the client's advanced settings.
  static final googleAndroidRedirect = Uri.parse(
    'com.antimatterstudios.restmail:/oauth2redirect',
  );

  /// An iOS client's redirect is its own id, reversed:
  /// `com.googleusercontent.apps.<id>:/oauth2redirect`. The system browser
  /// sheet catches it, so it needs no entry in Info.plist.
  static Uri googleIosRedirect(String clientId) {
    const suffix = '.apps.googleusercontent.com';
    final id = clientId.endsWith(suffix)
        ? clientId.substring(0, clientId.length - suffix.length)
        : clientId;
    return Uri.parse('com.googleusercontent.apps.$id:/oauth2redirect');
  }

  final OAuthKind kind;
  final String clientId;
  final Uri redirectUri;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final List<String> scopes;
  final bool scopeOnRefresh;

  /// Where a refresh token is given back on signing out (RFC 7009).
  /// Microsoft has none for a mobile app's tokens.
  final Uri? revocationEndpoint;

  String get name => kind.label;
}

/// The OAuth clients this build has. Their ids come from `--dart-define`,
/// never from the source, and a provider with none has no sign-in button:
///
/// - `MS_CLIENT_ID`: the Microsoft Entra app registration;
/// - `GOOGLE_IOS_CLIENT_ID` and `GOOGLE_ANDROID_CLIENT_ID`: Google's two
///   clients, one for each platform, as Google gives a mobile app.
///
/// They are public clients: an id is no secret, and there is no secret.
class OAuthClients {
  const OAuthClients({this.microsoft, this.google});

  static const none = OAuthClients();

  /// The clients this build was given, for [android] or iOS.
  factory OAuthClients.fromEnvironment({required bool android}) {
    const microsoft = String.fromEnvironment('MS_CLIENT_ID');
    const googleIos = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
    const googleAndroid = String.fromEnvironment('GOOGLE_ANDROID_CLIENT_ID');
    final google = android ? googleAndroid : googleIos;
    return OAuthClients(
      microsoft: microsoft.isEmpty ? null : OAuthProvider.microsoft(microsoft),
      google: google.isEmpty
          ? null
          : OAuthProvider.google(
              google,
              redirectUri: android
                  ? OAuthProvider.googleAndroidRedirect
                  : OAuthProvider.googleIosRedirect(google),
            ),
    );
  }

  final OAuthProvider? microsoft;
  final OAuthProvider? google;

  OAuthProvider? operator [](OAuthKind kind) => switch (kind) {
    OAuthKind.microsoft => microsoft,
    OAuthKind.google => google,
  };
}

/// Shows [authorize] in the system browser (ASWebAuthenticationSession on
/// iOS, a Custom Tab on Android) and returns the URL the provider sent it
/// back to, which starts with [redirect]. Throws an [ApiException] coded
/// `cancelled` when the person closes it.
typedef OAuthBrowser = Future<Uri> Function(Uri authorize, Uri redirect);

/// An access token and when it runs out.
class AccessGrant {
  const AccessGrant(this.token, this.expiresAt);

  final String token;
  final DateTime expiresAt;
}

/// What signing in gave: the tokens, and who signed in, as the ID token
/// says.
class OAuthGrant {
  const OAuthGrant({
    required this.access,
    required this.refreshToken,
    this.email,
    this.name,
  });

  final AccessGrant access;
  final String refreshToken;

  /// The address of the account that signed in, which may not be the one
  /// typed: IMAP and SMTP must be told this one.
  final String? email;
  final String? name;
}

/// The PKCE pair (RFC 7636): a random verifier kept here, and its SHA-256
/// sent with the request, so a code caught on its way back to the app is no
/// use to whoever caught it.
class Pkce {
  Pkce._(this.verifier) : challenge = challengeOf(verifier);

  /// 32 random bytes, 43 characters once encoded: RFC 7636's own advice.
  factory Pkce.generate([Random? random]) => Pkce._(randomToken(32, random));

  final String verifier;
  final String challenge;

  static String challengeOf(String verifier) =>
      _base64Url(sha256.convert(ascii.encode(verifier)).bytes);
}

/// [bytes] random bytes, base64url without padding: only RFC 3986's
/// unreserved characters, as PKCE wants of its verifier.
String randomToken(int bytes, [Random? random]) {
  final source = random ?? Random.secure();
  return _base64Url([for (var i = 0; i < bytes; i++) source.nextInt(256)]);
}

String _base64Url(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

/// Signs an account in at [provider]: the authorisation code flow with
/// PKCE, in the system browser, then the code exchanged for tokens here.
/// Tokens are asked for over the app's own HTTPS client.
Future<OAuthGrant> signInWithOAuth(
  OAuthProvider provider, {
  required http.Client httpClient,
  required OAuthBrowser browser,
  String? loginHint,
  Random? random,
  DateTime Function() now = DateTime.now,
}) async {
  final pkce = Pkce.generate(random);
  final state = randomToken(16, random);
  final authorize = provider.authorizationEndpoint.replace(
    queryParameters: {
      ...provider.authorizationEndpoint.queryParameters,
      'client_id': provider.clientId,
      'response_type': 'code',
      'redirect_uri': '${provider.redirectUri}',
      'scope': provider.scopes.join(' '),
      'state': state,
      'code_challenge': pkce.challenge,
      'code_challenge_method': 'S256',
      if (loginHint != null && loginHint.trim().isNotEmpty)
        'login_hint': loginHint.trim(),
    },
  );
  final back = await browser(authorize, provider.redirectUri);
  final code = codeFromRedirect(back, provider: provider, expectedState: state);
  final json = await _tokenRequest(provider, httpClient, {
    'grant_type': 'authorization_code',
    'code': code,
    'redirect_uri': '${provider.redirectUri}',
    'client_id': provider.clientId,
    'code_verifier': pkce.verifier,
  });
  final refreshToken = json['refresh_token'];
  if (refreshToken is! String || refreshToken.isEmpty) {
    throw ApiException(
      502,
      'oauth_error',
      "${provider.name} didn't give REST Mail a way to stay signed in.",
    );
  }
  final claims = idTokenClaims(json['id_token']);
  final email = claims['email'] ?? claims['preferred_username'];
  final name = claims['name'];
  return OAuthGrant(
    access: _accessFrom(json, provider, now()),
    refreshToken: refreshToken,
    email: email is String && email.contains('@') ? email : null,
    name: name is String && name.trim().isNotEmpty ? name.trim() : null,
  );
}

/// The code from the URL the browser came back with, once it is shown to be
/// the answer to this request: sent to [provider]'s redirect, carrying the
/// `state` the request went with. Anything else is refused before a code
/// is used.
String codeFromRedirect(
  Uri back, {
  required OAuthProvider provider,
  required String expectedState,
}) {
  final expected = provider.redirectUri;
  if (back.scheme != expected.scheme ||
      back.host != expected.host ||
      back.path != expected.path) {
    throw ApiException(
      0,
      'oauth_redirect',
      "${provider.name}'s sign-in came back somewhere it shouldn't have.",
    );
  }
  final params = back.queryParameters;
  final state = params['state'];
  if (state == null || !_sameText(state, expectedState)) {
    throw ApiException(
      0,
      'oauth_state',
      "That sign-in didn't come from this request, so REST Mail didn't use "
          'it. Try again.',
    );
  }
  final error = params['error'];
  if (error != null) {
    throw ApiException(
      error == 'access_denied' ? 403 : 400,
      error == 'access_denied' ? 'access_denied' : 'oauth_error',
      error == 'access_denied'
          ? "REST Mail can't add the account without your permission to read "
                'and send its mail.'
          : '${provider.name} said: ${params['error_description'] ?? error}',
    );
  }
  final code = params['code'];
  if (code == null || code.isEmpty) {
    throw ApiException(
      502,
      'oauth_error',
      "${provider.name}'s sign-in came back with nothing to sign in with.",
    );
  }
  return code;
}

/// A refresh token that no longer works: revoked by its owner, a changed
/// password, or a sign-in the provider wants to see again.
bool _signInEnded(String? error) =>
    error == 'invalid_grant' || error == 'interaction_required';

/// Asks [provider]'s token endpoint for tokens: the code exchange, or a
/// refresh. Failures are [ApiException]s; a refresh token that no longer
/// works is `invalid_grant`, with status 401.
Future<Map<String, dynamic>> _tokenRequest(
  OAuthProvider provider,
  http.Client client,
  Map<String, String> form,
) async {
  final http.Response response;
  try {
    response = await client
        .post(
          provider.tokenEndpoint,
          headers: const {'Accept': 'application/json'},
          body: form,
        )
        .timeout(const Duration(seconds: 30));
  } on TimeoutException {
    throw ApiException(
      0,
      'timeout',
      '${provider.tokenEndpoint.host} took too long to answer.',
    );
  } on Object {
    throw ApiException(
      0,
      'network_error',
      "Can't reach ${provider.tokenEndpoint.host}.",
    );
  }
  Map<String, dynamic>? json;
  try {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) json = decoded;
  } on FormatException {
    json = null;
  }
  if (response.statusCode == 200 && json != null) return json;
  final error = json?['error'];
  if (error is String && _signInEnded(error)) {
    throw ApiException(
      401,
      'invalid_grant',
      '${provider.name} no longer lets REST Mail into this account. Sign in '
          'again to carry on.',
    );
  }
  final description = json?['error_description'];
  throw ApiException(
    response.statusCode == 200 ? 502 : response.statusCode,
    'oauth_error',
    description is String && description.trim().isNotEmpty
        ? '${provider.name} said: ${description.trim().split('\n').first}'
        : "${provider.name} wouldn't sign REST Mail in.",
  );
}

AccessGrant _accessFrom(
  Map<String, dynamic> json,
  OAuthProvider provider,
  DateTime now,
) {
  final token = json['access_token'];
  final type = json['token_type'];
  if (token is! String ||
      token.isEmpty ||
      (type is String && type.toLowerCase() != 'bearer')) {
    throw ApiException(
      502,
      'oauth_error',
      "${provider.name} answered with a token REST Mail can't use.",
    );
  }
  final raw = json['expires_in'];
  final seconds = raw is int ? raw : int.tryParse('$raw') ?? 3600;
  return AccessGrant(token, now.add(Duration(seconds: seconds)));
}

/// What an ID token says, unchecked. It came straight from the token
/// endpoint over TLS, which OpenID Connect allows in place of checking its
/// signature (Core 3.1.3.7), and it is only read for the address and name.
Map<String, dynamic> idTokenClaims(Object? idToken) {
  if (idToken is! String) return const {};
  final parts = idToken.split('.');
  if (parts.length != 3) return const {};
  try {
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final claims = jsonDecode(payload);
    return claims is Map<String, dynamic> ? claims : const {};
  } on FormatException {
    return const {};
  }
}

/// Compares in time that doesn't depend on where they differ.
bool _sameText(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}

/// One account's sign-in with Microsoft or Google: the refresh token, kept
/// in the Keychain or Keystore with the account, and the access token IMAP
/// and SMTP sign in with, kept in memory only and renewed before it runs
/// out.
///
/// A refresh token that stops working (consent revoked, password changed)
/// ends the session for good: every call after that fails at once with
/// `invalid_grant`, and [onEnded] is called, once.
class OAuthSession {
  OAuthSession({
    required this.kind,
    required this.provider,
    required this._refreshToken,
    required this.httpClient,
    this._access,
    this.onRefreshTokenChanged,
    this.onEnded,
    this.now = DateTime.now,
  });

  final OAuthKind kind;

  /// The client this build has for [kind], or null if it has none, when
  /// the account can't renew its token.
  final OAuthProvider? provider;

  /// Makes the HTTPS client each refresh uses.
  final http.Client Function() httpClient;

  /// The provider gave a new refresh token (Microsoft does, every time);
  /// the old one may soon stop working, so it must be kept.
  final void Function(String refreshToken)? onRefreshTokenChanged;

  /// The refresh token no longer works.
  final void Function()? onEnded;

  final DateTime Function() now;

  /// How long before it runs out a token is renewed, so one isn't handed
  /// to a server just as it expires.
  static const margin = Duration(minutes: 5);

  String _refreshToken;
  AccessGrant? _access;
  Future<String>? _refreshing;
  ApiException? _ended;

  String get refreshToken => _refreshToken;

  bool get hasEnded => _ended != null;

  /// An access token good for a few minutes more: the one held, or a new
  /// one. [rejected] is one a server just turned down; unless a newer one
  /// has come since, it is replaced whatever its expiry says. Concurrent
  /// callers share one refresh.
  Future<String> accessToken({String? rejected}) async {
    final ended = _ended;
    if (ended != null) throw ended;
    final held = _access;
    if (held != null &&
        held.token != rejected &&
        held.expiresAt.isAfter(now().add(margin))) {
      return held.token;
    }
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<String> _refresh() async {
    final provider = this.provider;
    if (provider == null) {
      throw ApiException(
        401,
        'oauth_unavailable',
        "This build of REST Mail can't sign in with ${kind.label}.",
      );
    }
    final client = httpClient();
    try {
      final json = await _tokenRequest(provider, client, {
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken,
        'client_id': provider.clientId,
        if (provider.scopeOnRefresh) 'scope': provider.scopes.join(' '),
      });
      final access = _accessFrom(json, provider, now());
      _access = access;
      // Google keeps the refresh token it gave; Microsoft sends a new one.
      final next = json['refresh_token'];
      if (next is String && next.isNotEmpty && next != _refreshToken) {
        _refreshToken = next;
        onRefreshTokenChanged?.call(next);
      }
      return access.token;
    } on ApiException catch (e) {
      if (e.code == 'invalid_grant') {
        _ended = e;
        _access = null;
        // After the caller has its error, so it isn't torn down under it.
        if (onEnded != null) scheduleMicrotask(onEnded!);
      }
      rethrow;
    } finally {
      client.close();
    }
  }
}
