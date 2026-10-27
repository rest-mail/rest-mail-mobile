// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:http/http.dart' as _i7;
import 'package:restmail_generated/src/model/api_v1_admin_audit_parameters_model.dart'
    as _i8;
import 'package:restmail_generated/src/model/api_v1_admin_audit_parameters_model2.dart'
    as _i9;
import 'package:restmail_generated/src/operation/list_audit_entries.dart'
    as _i2;
import 'package:restmail_generated/src/operation/verify_audit_log.dart' as _i3;
import 'package:restmail_generated/src/response_wrapper/list_audit_entries_response.dart'
    as _i6;
import 'package:restmail_generated/src/response_wrapper/verify_audit_log_response.dart'
    as _i10;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

class AdminAuditApi {
  AdminAuditApi(_i1.Server server)
    : _listAuditEntries = _i2.ListAuditEntries(
        server.baseUrl,
        () => server.client,
      ),
      _verifyAuditLog = _i3.VerifyAuditLog(server.baseUrl, () => server.client);

  final _i2.ListAuditEntries _listAuditEntries;

  final _i3.VerifyAuditLog _verifyAuditLog;

  /// Read the audit log, newest first
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
  _i4.Future<_i5.TonikResult<_i6.ListAuditEntriesResponse, _i7.Response>>
  listAuditEntries({
    _i8.ApiV1AdminAuditParametersModel? actorKind,
    _i4.int? actorId,
    _i4.String? actor,
    _i4.String? action,
    _i9.ApiV1AdminAuditParametersModel2? outcome,
    _i4.DateTime? since,
    _i4.DateTime? until,
    _i4.int? beforeSeq,
    _i4.int? limit,
    _i5.TonikCancellation? cancellation,
  }) async => _listAuditEntries(
    actorKind: actorKind,
    actorId: actorId,
    actor: actor,
    action: action,
    outcome: outcome,
    since: since,
    until: until,
    beforeSeq: beforeSeq,
    limit: limit,
    cancellation: cancellation,
  );

  /// Check the audit log's hash chain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "anchor_blank":
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "anchor_mismatch":
  /// ```json
  /// {
  ///   "data": {
  ///     "anchor": {
  ///       "hash": "0000000000000000000000000000000000000000000000000000000000000000",
  ///       "seq": 2
  ///     },
  ///     "broken_at_seq": 2,
  ///     "checked": 1,
  ///     "first_seq": 1,
  ///     "last_hash": "a80f07a19f2e0addd466cc2ee548e74d7335ef434b5c77652c28fde2e8383f53",
  ///     "last_seq": 1,
  ///     "ok": false,
  ///     "reason": "hash does not match the anchor: the log was rewritten up to here"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "anchor_missing":
  /// ```json
  /// {
  ///   "data": {
  ///     "anchor": {
  ///       "hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///       "seq": 3
  ///     },
  ///     "broken_at_seq": 3,
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": false,
  ///     "reason": "the log ends at seq 2, before the anchor at seq 3"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "anchor_uppercase":
  /// ```json
  /// {
  ///   "data": {
  ///     "anchor": {
  ///       "hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///       "seq": 2
  ///     },
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "anchor_valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "anchor": {
  ///       "hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///       "seq": 2
  ///     },
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "audit_capability":
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "broken":
  /// ```json
  /// {
  ///   "data": {
  ///     "broken_at_seq": 2,
  ///     "checked": 1,
  ///     "first_seq": 1,
  ///     "last_hash": "a80f07a19f2e0addd466cc2ee548e74d7335ef434b5c77652c28fde2e8383f53",
  ///     "last_seq": 1,
  ///     "ok": false,
  ///     "reason": "hash does not match the entry's contents"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty":
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 0,
  ///     "first_seq": 0,
  ///     "last_hash": "0000000000000000000000000000000000000000000000000000000000000000",
  ///     "last_seq": 0,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The real bounded database audit verifier walks fixed, production-hashed entries. Complete pairs expose valid/empty/broken/gapped/truncated chains and anchored matches/mismatches/missing anchors. Controlled rows prove verifier and response wiring, not PostgreSQL traversal or audit append persistence.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 2,
  ///     "first_seq": 1,
  ///     "last_hash": "52bcb3083c3f488bdc23d26f1fd7ca9e546465aa60e25235d999609d8d82005c",
  ///     "last_seq": 2,
  ///     "ok": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "gap":
  /// ```json
  /// {
  ///   "data": {
  ///     "broken_at_seq": 3,
  ///     "checked": 1,
  ///     "first_seq": 1,
  ///     "last_hash": "a80f07a19f2e0addd466cc2ee548e74d7335ef434b5c77652c28fde2e8383f53",
  ///     "last_seq": 1,
  ///     "ok": false,
  ///     "reason": "expected seq 2, found 3"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "truncated":
  /// ```json
  /// {
  ///   "data": {
  ///     "checked": 2,
  ///     "first_seq": 5,
  ///     "last_hash": "3ca65e929281aac68198b5f812775657ad3c146ea3325c72932cd649f9ffb289",
  ///     "last_seq": 6,
  ///     "note": "the log starts at seq 5; the check starts from that entry's prev_hash",
  ///     "ok": true
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
  /// **Example** "wrong_capability":
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
  /// **Example** "invalid_anchor":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "anchor": "must be <seq>:<hash>, a positive whole number and 64 hex digits"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
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
  _i4.Future<_i5.TonikResult<_i10.VerifyAuditLogResponse, _i7.Response>>
  verifyAuditLog({
    _i4.String? anchor,
    _i5.TonikCancellation? cancellation,
  }) async => _verifyAuditLog(anchor: anchor, cancellation: cancellation);
}
