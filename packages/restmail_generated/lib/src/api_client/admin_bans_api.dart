// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:http/http.dart' as _i9;
import 'package:restmail_generated/src/model/api_v1_admin_bans_parameters_model.dart'
    as _i10;
import 'package:restmail_generated/src/model/api_v1_admin_bans_parameters_model2.dart'
    as _i11;
import 'package:restmail_generated/src/model/create_ban_request.dart' as _i13;
import 'package:restmail_generated/src/operation/create_ban.dart' as _i3;
import 'package:restmail_generated/src/operation/delete_ban.dart' as _i5;
import 'package:restmail_generated/src/operation/list_bans.dart' as _i2;
import 'package:restmail_generated/src/operation/unban_ip.dart' as _i4;
import 'package:restmail_generated/src/response_wrapper/create_ban_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/delete_ban_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/list_bans_response.dart'
    as _i8;
import 'package:restmail_generated/src/response_wrapper/unban_ip_response.dart'
    as _i14;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

class AdminBansApi {
  AdminBansApi(_i1.Server server)
    : _listBans = _i2.ListBans(server.baseUrl, () => server.client),
      _createBan = _i3.CreateBan(server.baseUrl, () => server.client),
      _unbanIp = _i4.UnbanIp(server.baseUrl, () => server.client),
      _deleteBan = _i5.DeleteBan(server.baseUrl, () => server.client);

  final _i2.ListBans _listBans;

  final _i3.CreateBan _createBan;

  final _i4.UnbanIp _unbanIp;

  final _i5.DeleteBan _deleteBan;

  /// List IP bans
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted list is empty:
  /// A current, setup-complete session with the required capability reads an empty database snapshot through the production handler. Pagination and response metadata are preserved.
  ///
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie is sent. The production JWT middleware refuses the request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — The account has not completed setup:
  /// The signed session is current but still requires initial account setup. The production SetupDone middleware refuses the request before reading data.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A current session sends Content-Length above APIMaxBodyBytes, including on this GET. The focused Vertrag test supplies a real oversized body; no typed body is declared.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_limit" — The page size cannot bind to an integer:
  /// The limit query parameter is a string that cannot bind to the registered integer page size. The typed binder refuses it before any database read.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "limit": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The list dependency fails:
  /// Session and permission checks pass, but the list dependency fails. The production handler and error writer produce this refusal without exposing dependency details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// The database-backed current-session lookup fails. The production session-cache builder and stale-session middleware produce this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i8.ListBansResponse, _i9.Response>> listBans({
    _i6.int? limit,
    _i6.int? offset,
    _i10.ApiV1AdminBansParametersModel? protocol,
    _i11.ApiV1AdminBansParametersModel2? active,
    _i6.String? ip,
    _i7.TonikCancellation? cancellation,
  }) async => _listBans(
    limit: limit,
    offset: offset,
    protocol: protocol,
    active: active,
    ip: ip,
    cancellation: cancellation,
  );

  /// Create an IP ban
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "clear_expiry":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "ip": "192.0.2.20",
  ///   "protocol": "all",
  ///   "reason": "Permanent override"
  /// }
  /// ```
  ///
  /// **Example** "compound_duration":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h30m",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "created_by_empty":
  /// ```json
  /// {
  ///   "created_by": "",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "created_by_missing":
  /// ```json
  /// {
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "duration_invalid":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "not-a-duration",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "duration_overflow":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "9223372036854775808h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "duration_wrong_type":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": 1,
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "fractional_duration":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1.5h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "insert_unavailable":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.40",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "ip_empty":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "ip_missing":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "ip_wrong_type":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": 1,
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "ipv6":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "2001:db8::1",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.30",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "negative_duration":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "-1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "null_duration":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": null,
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "permanent":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "protocol_imap":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "imap",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "protocol_invalid":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "SMTP",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "protocol_missing":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "protocol_pop3":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "pop3",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "protocol_smtp":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "smtp",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins",
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.21",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "created_by": "operator@restmail.test",
  ///   "duration": "2h",
  ///   "ip": "192.0.2.20",
  ///   "protocol": "imap",
  ///   "reason": "Updated reason"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "1h",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// **Example** "zero_duration":
  /// ```json
  /// {
  ///   "created_by": "admin@restmail.test",
  ///   "duration": "0",
  ///   "ip": "192.0.2.10",
  ///   "protocol": "all",
  ///   "reason": "Repeated failed sign-ins"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "clear_expiry":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2025-12-31T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "id": 20,
  ///     "ip": "192.0.2.20",
  ///     "protocol": "all",
  ///     "reason": "Permanent override"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2025-12-31T00:00:00Z",
  ///     "created_by": "operator@restmail.test",
  ///     "expires_at": "2026-01-01T02:00:00Z",
  ///     "id": 20,
  ///     "ip": "192.0.2.20",
  ///     "protocol": "imap",
  ///     "reason": "Updated reason"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "compound_duration":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:30:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created_by_empty":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "fractional_duration":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:30:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ipv6":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "2001:db8::1",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "negative_duration":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2025-12-31T23:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_duration":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "permanent":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "protocol_imap":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "imap",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "protocol_pop3":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "pop3",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "protocol_smtp":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "smtp",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T01:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "zero_duration":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "created_by": "admin@restmail.test",
  ///     "expires_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "ip": "192.0.2.10",
  ///     "protocol": "all",
  ///     "reason": "Repeated failed sign-ins"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "body_array":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "created_by_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "created_by": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duration_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "duration": "invalid duration format (e.g. 24h, 168h)"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duration_overflow":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "duration": "invalid duration format (e.g. 24h, 168h)"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duration_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "duration": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ip_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ip": "IP address is required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ip_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ip": "IP address is required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ip_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ip": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "protocol_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "protocol": "protocol must be one of smtp, imap, pop3, all"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "protocol_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "protocol": "protocol must be one of smtp, imap, pop3, all"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "insert_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i12.CreateBanResponse, _i9.Response>> createBan({
    required _i13.CreateBanRequest body,
    _i7.TonikCancellation? cancellation,
  }) async => _createBan(body: body, cancellation: cancellation);

  /// Remove all bans for a specific IP
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "literal_address":
  /// The current address lookup accepts a literal string rather than parsing an IP; this change preserves that request contract. An absent path segment never matches the route, so no binding 422 is advertised.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No ban found for this IP"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No ban found for this IP"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i14.UnbanIpResponse, _i9.Response>> unbanIp({
    required _i6.String ip,
    _i7.TonikCancellation? cancellation,
  }) async => _unbanIp(ip: ip, cancellation: cancellation);

  /// Delete a ban by ID
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Missing authorization header"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "request_too_large",
  ///     "message": "Request body too large"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i15.DeleteBanResponse, _i9.Response>> deleteBan({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _deleteBan(id: id, cancellation: cancellation);
}
