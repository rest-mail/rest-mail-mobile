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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
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
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test",
  ///     "sender": "ignored"
  ///   },
  ///   "ids": [
  ///     1,
  ///     2
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
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {}
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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 0
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
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
  /// **Example** "setup_required":
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
  _i11.Future<_i12.TonikResult<_i16.BulkBounceQueueResponse, _i14.Response>>
  bulkBounceQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkBounceQueue(body: body, cancellation: cancellation);

  /// Delete multiple queue entries
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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
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
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test",
  ///     "sender": "ignored"
  ///   },
  ///   "ids": [
  ///     1,
  ///     2
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
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {}
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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 0
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
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
  /// **Example** "setup_required":
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
  _i11.Future<_i12.TonikResult<_i18.BulkDeleteQueueResponse, _i14.Response>>
  bulkDeleteQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkDeleteQueue(body: body, cancellation: cancellation);

  /// Retry multiple queue entries
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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
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
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test",
  ///     "sender": "ignored"
  ///   },
  ///   "ids": [
  ///     1,
  ///     2
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
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "filter": {
  ///     "domain": "no-match.test"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "filter": null
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "ids": [
  ///     987654
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {}
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
  /// **Example** "by_ids":
  /// The registered operation and actual GORM SQL are exercised with controlled transaction/row-count responses. IDs select the mutation; retry/bounce retain their transition-state guards. Controlled SQL proves wiring rather than PostgreSQL selection or persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_filter":
  /// An explicit empty filter selects the entire controlled queue fixture, as the existing client flow expects. No live database or queue is mutated by these tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ids_take_precedence":
  /// Nonempty IDs take precedence over every supplied filter; filter predicates must not appear in the mutation.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_match":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 0
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "required_capability":
  /// ```json
  /// {
  ///   "data": {
  ///     "affected": 1
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "empty_ids":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_filter":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selection_missing":
  /// The body is structurally valid. Selecting IDs or a filter is the handler semantic guard, so this 400 is not marked as a schema-invalid request.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "ids or filter required"
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
  /// **Example** "setup_required":
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
  _i11.Future<_i12.TonikResult<_i19.BulkRetryQueueResponse, _i14.Response>>
  bulkRetryQueue({
    required _i17.BulkQueueRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _bulkRetryQueue(body: body, cancellation: cancellation);

  /// Get queue status counts
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
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "deferred" — A deferred delivery retains retry and failure metadata:
  /// ```json
  /// {
  ///   "data": {
  ///     "attempts": 2,
  ///     "body_type": "8BITMIME",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "domain": "destination.test",
  ///     "expires_at": "2026-10-21T00:00:00Z",
  ///     "failure_category": "greylisted",
  ///     "id": 2,
  ///     "last_attempt": "2026-10-20T00:00:00Z",
  ///     "last_error": "Try again later",
  ///     "last_error_code": 451,
  ///     "max_retries": 10,
  ///     "message_id": 42,
  ///     "next_attempt": "2026-10-20T01:00:00Z",
  ///     "recipient": "recipient@destination.test",
  ///     "sender": "sender@example.com",
  ///     "status": "deferred"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "queue_capability" — Only queue capability grants this operation:
  /// The session holds exactly one installation-wide read capability. The two resource-specific capabilities cannot substitute for each other.
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
  /// **Example** "required_capability" — The specific read capability grants access:
  /// The session holds queue:read and observability:read at *. Neither domains:read nor pipelines:read substitutes for those capabilities.
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
  /// **Example** "observability_capability" — Observability capability alone cannot read this operation:
  /// The session holds exactly one installation-wide read capability. The two resource-specific capabilities cannot substitute for each other.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_capability" — Other administrator read capabilities do not grant this operation:
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
  /// **Example** "invalid_format" — The domain ID cannot bind to an integer:
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
  /// **Example** "permission_store_unavailable" — The grant-store lookup fails:
  /// The current session is valid, but its held grants cannot be loaded; permission middleware fails closed.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
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
  _i11.Future<_i12.TonikResult<_i22.DeleteQueueEntryResponse, _i14.Response>>
  deleteQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _deleteQueueEntry(id: id, cancellation: cancellation);

  /// Bounce a single queue entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "already_delivered":
  /// The existing single-entry bounce action accepts an entry regardless of its prior status; this contract change preserves that behavior and does not infer the bulk action transition policy.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "bounced"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "already_delivering":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "bounced"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "deferred":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "bounced"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "required_capability":
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
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
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
  _i11.Future<_i12.TonikResult<_i23.BounceQueueEntryResponse, _i14.Response>>
  bounceQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _bounceQueueEntry(id: id, cancellation: cancellation);

  /// Retry a single queue entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "deferred":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "retrying"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "required_capability":
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
  /// **Example** "already_delivered":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Only pending or deferred entries can be retried"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "already_delivering":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Only pending or deferred entries can be retried"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "expired":
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
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
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
  _i11.Future<_i12.TonikResult<_i24.RetryQueueEntryResponse, _i14.Response>>
  retryQueueEntry({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _retryQueueEntry(id: id, cancellation: cancellation);
}
