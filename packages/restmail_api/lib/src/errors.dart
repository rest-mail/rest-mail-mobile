import 'dart:convert';

/// The server refused a request, or could not be reached at all.
///
/// [code] is the machine-readable code from rest-mail's error envelope
/// (`{"error": {"code", "message", "details"}}`) — `not_found`,
/// `validation_failed`, `unauthorized` and so on. A request that never got an
/// answer has [statusCode] 0 and one of `network_error`, `timeout` or
/// `tls_error`.
class ApiException implements Exception {
  const ApiException(
    this.statusCode,
    this.code,
    this.message, {
    this.fields = const {},
    this.retryAfter,
  });

  /// Reads rest-mail's error envelope, falling back to the status line when
  /// the body is not one (a reverse proxy's HTML error page, say).
  factory ApiException.fromResponse(
    int statusCode,
    String body, {
    String? reason,
    Duration? retryAfter,
  }) {
    var code = 'http_$statusCode';
    var message = reason ?? 'The server answered $statusCode';
    var fields = const <String, String>{};
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> &&
          decoded['error'] is Map<String, dynamic>) {
        final error = decoded['error'] as Map<String, dynamic>;
        code = error['code'] as String? ?? code;
        message = error['message'] as String? ?? message;
        fields = _fieldsOf(error['details']);
      } else if (decoded is Map<String, dynamic> &&
          decoded['error'] is String) {
        // Custom-filter execution forwards the sidecar's bare error object.
        message = decoded['error'] as String;
      }
    } on FormatException {
      // Not an envelope; the status line is all there is.
    }
    if (code == 'totp_required') {
      return TotpRequiredException(statusCode, message);
    }
    return ApiException(
      statusCode,
      code,
      message,
      fields: fields,
      retryAfter: retryAfter,
    );
  }

  /// The HTTP status, or 0 when there was no response.
  final int statusCode;
  final String code;
  final String message;

  /// Per-field messages from a `validation_failed` response.
  final Map<String, String> fields;

  /// How long a 429 says to wait, from its `Retry-After`.
  final Duration? retryAfter;

  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// The password was right but the account has two-factor authentication.
/// Send it again with a TOTP or recovery code. Signing in answers it as 401;
/// linking another account answers 403, since this session is still good.
class TotpRequiredException extends ApiException {
  const TotpRequiredException(int statusCode, String message)
    : super(statusCode, 'totp_required', message);
}

/// The session is over and cannot be renewed; the user has to sign in again.
class SessionExpiredException extends ApiException {
  const SessionExpiredException()
    : super(401, 'session_expired', 'Your session has ended. Sign in again.');
}

/// `details` is `{"fields": {name: message}}` in the schema; a flat
/// `{name: message}` map is read the same way.
Map<String, String> _fieldsOf(Object? details) {
  if (details is! Map<String, dynamic>) return const {};
  final nested = details['fields'];
  final fields = nested is Map<String, dynamic> ? nested : details;
  return {
    for (final MapEntry(:key, :value) in fields.entries)
      if (value is String) key: value,
  };
}
