/// The cookie rest-mail delivers the access token in.
const accessCookieName = 'restmail_access';

/// The cookie rest-mail delivers the refresh token in. The server reads it
/// only on `/api/v1/auth/refresh` and `/api/v1/auth/logout`.
const refreshCookieName = 'restmail_refresh';

/// The two tokens behind one signed-in session.
///
/// rest-mail gives tokens to browsers as httpOnly cookies and never in a JSON
/// body. A native client can read Set-Cookie, so it lifts both values out of
/// the login and refresh responses. The access token goes back as an
/// `Authorization: Bearer` header, which also exempts the request from the
/// CSRF check; the refresh token goes back as a cookie on the two auth routes
/// that read it.
class SessionTokens {
  const SessionTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
  });

  factory SessionTokens.fromJson(Map<String, dynamic> json) => SessionTokens(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
    accessExpiresAt: DateTime.parse(json['access_expires_at'] as String),
  );

  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;

  /// Whether the access token runs out within [margin] from [now].
  bool expiresWithin(Duration margin, {DateTime? now}) =>
      !(now ?? DateTime.now()).add(margin).isBefore(accessExpiresAt);

  Map<String, String> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'access_expires_at': accessExpiresAt.toUtc().toIso8601String(),
  };
}

/// Reads `name=value` out of each Set-Cookie line, ignoring the attributes.
/// A cookie being cleared (sent with an empty value) is left out.
Map<String, String> parseSetCookies(Iterable<String> setCookieLines) {
  final cookies = <String, String>{};
  for (final line in setCookieLines) {
    final pair = line.split(';').first;
    final equals = pair.indexOf('=');
    if (equals <= 0) continue;
    var value = pair.substring(equals + 1).trim();
    if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1);
    }
    if (value.isNotEmpty) cookies[pair.substring(0, equals).trim()] = value;
  }
  return cookies;
}

/// Path endings people paste along with their server that are not part of it.
const _pastedSuffixes = [
  ['api', 'v1'],
  ['api'],
  ['webmail'],
  ['admin'],
];

/// Turns what someone typed as their server into the base URL the API hangs
/// off.
///
/// A bare host gets `https://`. Any other scheme is refused: rest-mail serves
/// clients over TLS only, and this client will not send a password in clear.
/// A pasted webmail, admin or API address is trimmed back to the server; any
/// other path is kept, for a server behind a reverse-proxy prefix.
Uri parseServerUrl(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    throw const FormatException('Enter your server address');
  }
  final uri = Uri.tryParse(
    trimmed.contains('://') ? trimmed : 'https://$trimmed',
  );
  if (uri == null || uri.host.isEmpty) {
    throw FormatException('"$trimmed" is not a server address');
  }
  if (uri.scheme.toLowerCase() != 'https') {
    throw const FormatException(
      'rest-mail servers are reached over HTTPS only',
    );
  }
  var segments = [...uri.pathSegments.where((s) => s.isNotEmpty)];
  for (final suffix in _pastedSuffixes) {
    if (_endsWith(segments, suffix)) {
      segments = segments.sublist(0, segments.length - suffix.length);
      break;
    }
  }
  return Uri(
    scheme: 'https',
    host: uri.host,
    port: uri.hasPort ? uri.port : null,
    pathSegments: segments,
  );
}

bool _endsWith(List<String> segments, List<String> suffix) {
  if (segments.length < suffix.length) return false;
  final tail = segments.sublist(segments.length - suffix.length);
  for (var i = 0; i < suffix.length; i++) {
    if (tail[i].toLowerCase() != suffix[i]) return false;
  }
  return true;
}
