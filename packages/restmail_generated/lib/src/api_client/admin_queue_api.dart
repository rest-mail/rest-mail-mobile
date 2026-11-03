// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i11;

import 'package:http/http.dart' as _i14;
import 'package:restmail_generated/src/model/api_v1_admin_queue_parameters_model.dart'
    as _i15;
import 'package:restmail_generated/src/model/bulk_queue_request.dart' as _i17;
import 'package:restmail_generated/src/operation/bounce_queue_entry.dart'
    as _i9;
import 'package:restmail_generated/src/operation/bulk_bounce_queue.dart' as _i3;
import 'package:restmail_generated/src/operation/bulk_delete_queue.dart' as _i4;
import 'package:restmail_generated/src/operation/bulk_retry_queue.dart' as _i5;
import 'package:restmail_generated/src/operation/delete_queue_entry.dart'
    as _i8;
import 'package:restmail_generated/src/operation/get_queue_entry.dart' as _i7;
import 'package:restmail_generated/src/operation/get_queue_stats.dart' as _i6;
import 'package:restmail_generated/src/operation/list_queue.dart' as _i2;
import 'package:restmail_generated/src/operation/retry_queue_entry.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/bounce_queue_entry_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/bulk_bounce_queue_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/bulk_delete_queue_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/bulk_retry_queue_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/delete_queue_entry_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/get_queue_entry_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/get_queue_stats_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/list_queue_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/retry_queue_entry_response.dart'
    as _i24;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i12;

class AdminQueueApi {
  AdminQueueApi(_i1.Server server)
    : _listQueue = _i2.ListQueue(server.baseUrl, () => server.client),
      _bulkBounceQueue = _i3.BulkBounceQueue(
        server.baseUrl,
        () => server.client,
      ),
      _bulkDeleteQueue = _i4.BulkDeleteQueue(
        server.baseUrl,
        () => server.client,
      ),
      _bulkRetryQueue = _i5.BulkRetryQueue(server.baseUrl, () => server.client),
      _getQueueStats = _i6.GetQueueStats(server.baseUrl, () => server.client),
      _getQueueEntry = _i7.GetQueueEntry(server.baseUrl, () => server.client),
      _deleteQueueEntry = _i8.DeleteQueueEntry(
        server.baseUrl,
        () => server.client,
      ),
      _bounceQueueEntry = _i9.BounceQueueEntry(
        server.baseUrl,
        () => server.client,
      ),
      _retryQueueEntry = _i10.RetryQueueEntry(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListQueue _listQueue;

  final _i3.BulkBounceQueue _bulkBounceQueue;

  final _i4.BulkDeleteQueue _bulkDeleteQueue;

  final _i5.BulkRetryQueue _bulkRetryQueue;

  final _i6.GetQueueStats _getQueueStats;

  final _i7.GetQueueEntry _getQueueEntry;

  final _i8.DeleteQueueEntry _deleteQueueEntry;

  final _i9.BounceQueueEntry _bounceQueueEntry;

  final _i10.RetryQueueEntry _retryQueueEntry;

  /// List outbound queue entries
  /// Database work follows the HTTP request context, including cancellation and deadlines.
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
  ///   "data": {
  ///     "items": [],
  ///     "limit": 20,
  ///     "offset": 0,
  ///     "total": 0
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
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i13.ListQueueResponse, _i14.Response>>
  listQueue({
    _i15.ApiV1AdminQueueParametersModel? status,
    _i11.String? domain,
    _i11.String? sender,
    _i11.String? recipient,
    _i11.int? limit,
    _i11.int? offset,
    _i12.TonikCancellation? cancellation,
  }) async => _listQueue(
    status: status,
    domain: domain,
    sender: sender,
    recipient: recipient,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Bounce multiple queue entries
  /// Select entries by nonempty IDs (which take precedence) or by an explicit filter object. An empty filter object selects all entries subject to the action's status eligibility. A supplied filter must never be null, even with IDs; null is refused with 422 before queue access. Database work follows the HTTP request context, including cancellation and deadlines.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "filter": {}
  /// }
  /// ```
  ///
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "ids": []
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null,
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "ids": "1"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
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
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "ids or filter required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "body": "the body is not a JSON object"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "must be an array"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i16.BulkBounceQueueResponse, _i14.Response>>
  bulkBounceQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkBounceQueue(body: body, cancellation: cancellation);

  /// Delete multiple queue entries
  /// Select entries by nonempty IDs (which take precedence) or by an explicit filter object. An empty filter object selects all entries subject to the action's status eligibility. A supplied filter must never be null, even with IDs; null is refused with 422 before queue access. Database work follows the HTTP request context, including cancellation and deadlines.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "filter": {}
  /// }
  /// ```
  ///
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "ids": []
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null,
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "ids": "1"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
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
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "ids or filter required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "body": "the body is not a JSON object"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "must be an array"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i18.BulkDeleteQueueResponse, _i14.Response>>
  bulkDeleteQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkDeleteQueue(body: body, cancellation: cancellation);

  /// Retry multiple queue entries
  /// Select entries by nonempty IDs (which take precedence) or by an explicit filter object. An empty filter object selects all entries subject to the action's status eligibility. A supplied filter must never be null, even with IDs; null is refused with 422 before queue access. Database work follows the HTTP request context, including cancellation and deadlines.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "filter": {}
  /// }
  /// ```
  ///
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "ids": []
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null,
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "ids": "1"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "example.test",
  ///     "recipient": "recipient%_\\",
  ///     "sender": "sender%_\\",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "by_filter":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter object intentionally selects every entry eligible for the action. Null is not an empty filter. Controlled SQL proves route wiring, not PostgreSQL persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
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
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "ids or filter required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "body": "the body is not a JSON object"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "ids": "must be an array"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// A supplied filter must be an object, never null, even when nonempty IDs are present. Binding refuses null with 422 before any queue SQL.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "filter": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i19.BulkRetryQueueResponse, _i14.Response>>
  bulkRetryQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkRetryQueue(body: body, cancellation: cancellation);

  /// Get queue status counts
  /// Database work follows the HTTP request context, including cancellation and deadlines.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted read succeeds:
  /// A current, setup-complete session reads the controlled database snapshot through the production registration. Lists are empty; statistics include two delivered queue entries. Push routes are configured for APNs, without sending a notification.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "bounced": 0,
  ///     "deferred": 0,
  ///     "delivered": 2,
  ///     "pending": 0,
  ///     "total": 2
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
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  /// **Example** "internal_error" — The read dependency fails:
  /// Session and permission checks pass, but the database read fails. The production handler and error writer produce this refusal without exposing dependency details.
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
  _i11.Future<_i12.TonikResult<_i20.GetQueueStatsResponse, _i14.Response>>
  getQueueStats({_i12.TonikCancellation? cancellation}) async =>
      _getQueueStats(cancellation: cancellation);

  /// Get a single queue entry
  /// Database work follows the HTTP request context, including cancellation and deadlines.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — The full stored resource is mapped to public fields:
  /// A current session holds the required installation-wide read capability. The trace path binds a delivered message ID, not the separate trace ID; queue null associations remain explicit.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "attempts": 0,
  ///     "body_type": "8BITMIME",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "domain": "destination.test",
  ///     "expires_at": "2026-10-21T00:00:00Z",
  ///     "failure_category": "",
  ///     "id": 1,
  ///     "last_attempt": null,
  ///     "last_error": "",
  ///     "last_error_code": 0,
  ///     "max_retries": 10,
  ///     "message_id": null,
  ///     "next_attempt": "2026-10-20T01:00:00Z",
  ///     "recipient": "recipient@destination.test",
  ///     "sender": "sender@example.com",
  ///     "status": "pending"
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
  /// **Example** "domain_scope" — A domain-scoped grant does not satisfy installation-wide reads:
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
  /// **Example** "missing" — An absent resource keeps its not-found response:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Queue entry not found"
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
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  /// **Example** "internal_error" — A database failure is not a missing resource:
  /// The production lookup encounters a controlled database fault. Its private error detail is omitted from the public500 response.
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
  _i11.Future<_i12.TonikResult<_i21.GetQueueEntryResponse, _i14.Response>>
  getQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _getQueueEntry(id: id, cancellation: cancellation);

  /// Delete a queue entry
  /// Answers 404 not_found when the ID does not exist. Database work follows the HTTP request context, including cancellation and deadlines.
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Queue entry not found"
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
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i22.DeleteQueueEntryResponse, _i14.Response>>
  deleteQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _deleteQueueEntry(id: id, cancellation: cancellation);

  /// Bounce a single queue entry
  /// Database work follows the HTTP request context, including cancellation and deadlines. The entry is locked in one transaction before the update is written; lookup, update or commit failures cannot return success.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production routes, actual JWT/session and capability middleware, controlled grant-cache states and actual GORM ID-bound lookups/mutations are exercised. Mutation fields and failure-before-write boundaries are captured. SQL snapshots prove wiring, not PostgreSQL transactions, state races, audit persistence or actual mail delivery.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "bounced"
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Queue entry not found"
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
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i23.BounceQueueEntryResponse, _i14.Response>>
  bounceQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _bounceQueueEntry(id: id, cancellation: cancellation);

  /// Retry a single queue entry
  /// Database work follows the HTTP request context, including cancellation and deadlines. The entry is locked in one transaction before eligibility is checked and the update is written; lookup, update or commit failures cannot return success.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production routes, actual JWT/session and capability middleware, controlled grant-cache states and actual GORM ID-bound lookups/mutations are exercised. Mutation fields and failure-before-write boundaries are captured. SQL snapshots prove wiring, not PostgreSQL transactions, state races, audit persistence or actual mail delivery.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "retrying"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "already_bounced":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Only pending or deferred entries can be retried"
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Queue entry not found"
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
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
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
  _i11.Future<_i12.TonikResult<_i24.RetryQueueEntryResponse, _i14.Response>>
  retryQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _retryQueueEntry(id: id, cancellation: cancellation);
}
