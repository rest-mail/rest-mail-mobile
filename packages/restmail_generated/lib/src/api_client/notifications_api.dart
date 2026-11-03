// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:http/http.dart' as _i7;
import 'package:restmail_generated/src/model/quiet_hours_body.dart' as _i9;
import 'package:restmail_generated/src/operation/get_quiet_hours.dart' as _i2;
import 'package:restmail_generated/src/operation/set_quiet_hours.dart' as _i3;
import 'package:restmail_generated/src/response_wrapper/get_quiet_hours_response.dart'
    as _i6;
import 'package:restmail_generated/src/response_wrapper/set_quiet_hours_response.dart'
    as _i8;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

class NotificationsApi {
  NotificationsApi(_i1.Server server)
    : _getQuietHours = _i2.GetQuietHours(server.baseUrl, () => server.client),
      _setQuietHours = _i3.SetQuietHours(server.baseUrl, () => server.client);

  final _i2.GetQuietHours _getQuietHours;

  final _i3.SetQuietHours _setQuietHours;

  /// Get the account's notification quiet hours
  /// Off by default. Local HH:MM start (inclusive) and end (exclusive), with an IANA time zone. A start later than end crosses midnight. Mail delivery and reading are unaffected.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "disabled" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": false,
  ///     "end": "",
  ///     "start": "",
  ///     "time_zone": ""
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
  /// **Example** "without_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i4.Future<_i5.TonikResult<_i6.GetQuietHoursResponse, _i7.Response>>
  getQuietHours({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => _getQuietHours(id: id, cancellation: cancellation);

  /// Set the account's notification quiet hours
  /// Hold push notifications during this daily local-time range, then send one account summary containing arrival and unread counts only. Nothing is sent if nothing arrived. Start and end must differ; enabled schedules require both times and an IANA time zone. Empty times and zone are allowed only while disabled. Skipped local times end at the first real instant outside the range; repeated local times are quiet whenever the local clock is inside the range. Mail still arrives and is readable normally.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "enabled" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "enabled_invalid":
  /// ```json
  /// {
  ///   "enabled": "yes",
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "enabled_missing":
  /// ```json
  /// {
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "equal_times" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "end": "22:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "invalid_zone" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Mars/Olympus"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "turned_off" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// **Example** "without_capability":
  /// ```json
  /// {
  ///   "enabled": false,
  ///   "end": "08:00",
  ///   "start": "22:00",
  ///   "time_zone": "Europe/Berlin"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "enabled" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": true,
  ///     "end": "08:00",
  ///     "start": "22:00",
  ///     "time_zone": "Europe/Berlin"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "turned_off" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": false,
  ///     "end": "08:00",
  ///     "start": "22:00",
  ///     "time_zone": "Europe/Berlin"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type. The route and Vertrag transport hook send those exact bytes rather than JSON-quoting them.
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
  /// **Example** "without_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
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
  /// **Example** "enabled_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "must be a boolean"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "enabled_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "equal_times" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "end": "must differ from start"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "invalid_zone" — Account-local notification quiet hours, off by default:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "time_zone": "must be an IANA time zone name"
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i4.Future<_i5.TonikResult<_i8.SetQuietHoursResponse, _i7.Response>>
  setQuietHours({
    required _i9.QuietHoursBody body,
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => _setQuietHours(body: body, id: id, cancellation: cancellation);
}
