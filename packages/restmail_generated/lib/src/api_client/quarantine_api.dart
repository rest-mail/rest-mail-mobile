// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:http/http.dart' as _i8;
import 'package:restmail_generated/src/operation/delete_quarantine.dart' as _i3;
import 'package:restmail_generated/src/operation/list_quarantine.dart' as _i2;
import 'package:restmail_generated/src/operation/release_quarantine.dart'
    as _i4;
import 'package:restmail_generated/src/response_wrapper/delete_quarantine_response.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/list_quarantine_response.dart'
    as _i7;
import 'package:restmail_generated/src/response_wrapper/release_quarantine_response.dart'
    as _i10;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i6;

class QuarantineApi {
  QuarantineApi(_i1.Server server)
    : _listQuarantine = _i2.ListQuarantine(server.baseUrl, () => server.client),
      _deleteQuarantine = _i3.DeleteQuarantine(
        server.baseUrl,
        () => server.client,
      ),
      _releaseQuarantine = _i4.ReleaseQuarantine(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListQuarantine _listQuarantine;

  final _i3.DeleteQuarantine _deleteQuarantine;

  final _i4.ReleaseQuarantine _releaseQuarantine;

  /// List quarantined messages
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — Unreleased quarantine metadata includes optional scores and excludes raw message source:
  /// Actual production routes, repositories and credential/grant checks map controlled rows. SQL restrictions and returned fields are asserted, but PostgreSQL aggregation, filtering, ordering and persistence are not claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_preview": "Preview only",
  ///       "expires_at": "2026-10-27T00:00:00Z",
  ///       "id": 41,
  ///       "mailbox_id": 1,
  ///       "quarantine_reason": "spam",
  ///       "received_at": "2026-10-20T00:00:00Z",
  ///       "released": false,
  ///       "sender": "sender@example.net",
  ///       "spam_score": 4.5,
  ///       "subject": "Held café"
  ///     },
  ///     {
  ///       "body_preview": "Review this",
  ///       "expires_at": "2026-10-26T00:00:00Z",
  ///       "id": 40,
  ///       "mailbox_id": 1,
  ///       "quarantine_reason": "custom_filter",
  ///       "received_at": "2026-10-19T00:00:00Z",
  ///       "released": false,
  ///       "sender": "other@example.net",
  ///       "subject": "No score"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
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
  /// **Example** "write_only":
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
  /// **Example** "key_wrong_scope":
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
  /// **Example** "count_unavailable":
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
  _i5.Future<_i6.TonikResult<_i7.ListQuarantineResponse, _i8.Response>>
  listQuarantine({
    required _i5.int id,
    _i5.int? limit,
    _i5.int? offset,
    _i6.TonikCancellation? cancellation,
  }) async => _listQuarantine(
    id: id,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Permanently delete a quarantined message
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production credentials, session/cookie CSRF, grant ceilings and path binding precede actual GORM mutation. Controlled SQL captures exact row/owner or row/mailbox predicates, cancellation pending-state compare-and-update and zero-row responses. No live messages are cancelled or deleted; PostgreSQL isolation, worker races, physical storage and audit persistence remain outside this proof.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
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
  /// **Example** "key_read":
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
  ///     "message": "Quarantined message not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
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
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete"
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
  _i5.Future<_i6.TonikResult<_i9.DeleteQuarantineResponse, _i8.Response>>
  deleteQuarantine({
    required _i5.int id,
    required _i5.int mid,
    _i6.TonikCancellation? cancellation,
  }) async => _deleteQuarantine(id: id, mid: mid, cancellation: cancellation);

  /// Release a quarantined message to inbox
  /// Releasing held mail requires a human session signed in with two-factor authentication.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "released" — The held message goes to the inbox:
  /// ```json
  /// {
  ///   "data": {
  ///     "message_id": "41",
  ///     "status": "released"
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No credential is sent:
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
  /// **Example** "read_only" — The caller cannot change the mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — Releasing held mail requires a human second factor:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — No such held message:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Quarantined message not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
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
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "must be at least 1",
  ///         "mid": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — The limit is already spent:
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
  /// **Example** "internal_error" — A database fault is not a client error:
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
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i5.Future<_i6.TonikResult<_i10.ReleaseQuarantineResponse, _i8.Response>>
  releaseQuarantine({
    required _i5.int id,
    required _i5.int mid,
    _i6.TonikCancellation? cancellation,
  }) async => _releaseQuarantine(id: id, mid: mid, cancellation: cancellation);
}
