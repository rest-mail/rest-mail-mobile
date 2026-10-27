// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:http/http.dart' as _i10;
import 'package:restmail_generated/src/model/set_dkim_key_body.dart' as _i12;
import 'package:restmail_generated/src/model/set_dkim_rotation_body.dart'
    as _i16;
import 'package:restmail_generated/src/operation/delete_dkim_key.dart' as _i4;
import 'package:restmail_generated/src/operation/get_dkim_rotation.dart' as _i5;
import 'package:restmail_generated/src/operation/list_dkim_keys.dart' as _i2;
import 'package:restmail_generated/src/operation/set_dkim_key.dart' as _i3;
import 'package:restmail_generated/src/operation/set_dkim_rotation.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/delete_dkim_key_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/get_dkim_rotation_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/list_dkim_keys_response.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/set_dkim_key_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/set_dkim_rotation_response.dart'
    as _i15;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

class AdminDkimApi {
  AdminDkimApi(_i1.Server server)
    : _listDkimKeys = _i2.ListDkimKeys(server.baseUrl, () => server.client),
      _setDkimKey = _i3.SetDkimKey(server.baseUrl, () => server.client),
      _deleteDkimKey = _i4.DeleteDkimKey(server.baseUrl, () => server.client),
      _getDkimRotation = _i5.GetDkimRotation(
        server.baseUrl,
        () => server.client,
      ),
      _setDkimRotation = _i6.SetDkimRotation(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListDkimKeys _listDkimKeys;

  final _i3.SetDkimKey _setDkimKey;

  final _i4.DeleteDkimKey _deleteDkimKey;

  final _i5.GetDkimRotation _getDkimRotation;

  final _i6.SetDkimRotation _setDkimRotation;

  /// List DKIM key entries for all domains
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
  ///   "data": []
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
  _i7.Future<_i8.TonikResult<_i9.ListDkimKeysResponse, _i10.Response>>
  listDkimKeys({_i8.TonikCancellation? cancellation}) async =>
      _listDkimKeys(cancellation: cancellation);

  /// Set or replace DKIM key for a domain
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
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "cancelled_after_lookup":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "installed":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "legacy_age_unknown":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "private_key_empty":
  /// ```json
  /// {
  ///   "private_key": "",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "private_key_invalid":
  /// ```json
  /// {
  ///   "private_key": "not a key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "private_key_missing":
  /// ```json
  /// {
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "private_key_wrong_type":
  /// ```json
  /// {
  ///   "private_key": 42,
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "replaced":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "scope_lookup_unavailable":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "selector_changed":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "other"
  /// }
  /// ```
  ///
  /// **Example** "selector_empty":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": ""
  /// }
  /// ```
  ///
  /// **Example** "selector_invalid":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "invalid_selector"
  /// }
  /// ```
  ///
  /// **Example** "selector_missing":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key"
  /// }
  /// ```
  ///
  /// **Example** "selector_wrong_type":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": 42
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
  /// ```json
  /// {
  ///   "private_key": "fixture-signing-key",
  ///   "selector": "contract"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "installed":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "legacy_age_unknown":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": null,
  ///     "created_at": null,
  ///     "domain": "example.com",
  ///     "domain_id": 10,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "replaced":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 2,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selector_changed":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "other"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "age_seconds": 0,
  ///     "created_at": "2026-10-01T12:00:00Z",
  ///     "domain": "example.com",
  ///     "domain_id": 1,
  ///     "has_key": true,
  ///     "selector": "contract"
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
  /// **Example** "key_wrong_domain":
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
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
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
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not found"
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
  /// **Example** "private_key_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "private_key": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "private_key_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "private_key": "is not a PEM-encoded private key"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "private_key_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "private_key": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "private_key_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "private_key": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selector_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "selector": "Must be a DNS label (letters, digits, hyphens), at most 63 characters"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selector_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "selector": "Must be a DNS label (letters, digits, hyphens), at most 63 characters"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selector_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "selector": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "selector_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "selector": "must be a string"
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
  /// **Example** "cancelled_after_lookup":
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
  /// **Example** "scope_lookup_unavailable":
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
  _i7.Future<_i8.TonikResult<_i11.SetDkimKeyResponse, _i10.Response>>
  setDkimKey({
    required _i12.SetDkimKeyBody body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _setDkimKey(body: body, id: id, cancellation: cancellation);

  /// Delete DKIM key for a domain
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
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
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
  ///     "message": "Domain not found"
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
  /// **Example** "scoped_lookup_unavailable":
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
  /// **Example** "scope_lookup_unavailable":
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
  _i7.Future<_i8.TonikResult<_i13.DeleteDkimKeyResponse, _i10.Response>>
  deleteDkimKey({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _deleteDkimKey(id: id, cancellation: cancellation);

  /// Read a domain's DKIM rotation interval
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "awaiting_publication" — Rotation state: awaiting_publication:
  /// A deterministic public RFC8032 test key exercises the real public-record mapping. Unreadable stored key material keeps an empty record_value; no private signing material is returned.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 5,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": {
  ///       "published_at": null,
  ///       "record_name": "restmail-next._domainkey.example.com",
  ///       "record_value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo=",
  ///       "selector": "restmail-next"
  ///     },
  ///     "state": "awaiting_publication"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "disabled" — Disabled configuration remains readable to administrators:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 2,
  ///     "previous": null,
  ///     "rotation_interval_days": 0,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — The domain-scoped reader can inspect rotation:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found" — The full public resource is returned:
  /// A current session holds the installation-wide read capability. Stored public fields pass through the production mapper; private certificate and signing keys have no response field.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "retiring" — Rotation state: retiring:
  /// A deterministic public RFC8032 test key exercises the real public-record mapping. Unreadable stored key material keeps an empty record_value; no private signing material is returned.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 7,
  ///     "previous": {
  ///       "published_at": "2026-10-20T00:00:00Z",
  ///       "record_name": "restmail-previous._domainkey.example.com",
  ///       "record_value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo=",
  ///       "retire_after": "2026-10-21T00:00:00Z",
  ///       "selector": "restmail-previous"
  ///     },
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "retiring"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unreadable_key" — Rotation state: unreadable_key:
  /// A deterministic public RFC8032 test key exercises the real public-record mapping. Unreadable stored key material keeps an empty record_value; no private signing material is returned.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 9,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": {
  ///       "published_at": null,
  ///       "record_name": "restmail-next._domainkey.example.com",
  ///       "record_value": "",
  ///       "selector": "restmail-next"
  ///     },
  ///     "state": "awaiting_publication"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "waiting_ttl" — Rotation state: waiting_ttl:
  /// A deterministic public RFC8032 test key exercises the real public-record mapping. Unreadable stored key material keeps an empty record_value; no private signing material is returned.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 6,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": {
  ///       "activates_at": "2026-10-20T01:00:00Z",
  ///       "published_at": "2026-10-20T00:00:00Z",
  ///       "record_name": "restmail-next._domainkey.example.com",
  ///       "record_value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo=",
  ///       "selector": "restmail-next"
  ///     },
  ///     "state": "waiting_ttl"
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
  /// **Example** "outside_domain" — A grant on another domain cannot read this configuration:
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
  /// **Example** "missing" — The requested domain does not exist:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not found"
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
  /// **Example** "internal_error" — A database fault is not a missing resource:
  /// A controlled dependency error exercises the real GORM lookup. The production error writer omits internal fault detail.
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
  /// **Example** "keys_unavailable" — Rotation configuration exists but its key query fails:
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
  ///
  /// **Example** "target_lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  _i7.Future<_i8.TonikResult<_i14.GetDkimRotationResponse, _i10.Response>>
  getDkimRotation({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _getDkimRotation(id: id, cancellation: cancellation);

  /// Set a domain's DKIM rotation interval
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
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "cancelled_after_lookup":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "configured":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "disabled":
  /// ```json
  /// {
  ///   "rotation_interval_days": 0
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "field_unknown":
  /// ```json
  /// {
  ///   "private_key": "injected",
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "interval_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "interval_negative":
  /// ```json
  /// {
  ///   "rotation_interval_days": -1
  /// }
  /// ```
  ///
  /// **Example** "interval_null":
  /// ```json
  /// {
  ///   "rotation_interval_days": null
  /// }
  /// ```
  ///
  /// **Example** "interval_too_large":
  /// ```json
  /// {
  ///   "rotation_interval_days": 3651
  /// }
  /// ```
  ///
  /// **Example** "interval_wrong_type":
  /// ```json
  /// {
  ///   "rotation_interval_days": "90"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "maximum":
  /// ```json
  /// {
  ///   "rotation_interval_days": 3650
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "scope_lookup_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "status_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
  /// ```json
  /// {
  ///   "rotation_interval_days": 90
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "body_boundary":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "configured":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "disabled":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 0,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "maximum":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 3650,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "previous": null,
  ///     "rotation_interval_days": 90,
  ///     "staged": null,
  ///     "state": "stable"
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
  /// **Example** "key_wrong_domain":
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
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
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
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Domain not found"
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
  /// **Example** "field_unknown":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "private_key": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "interval_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "rotation_interval_days": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "interval_negative":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "rotation_interval_days": "Must be an integer between 0 and 3650 days; 0 disables rotation"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "interval_null":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "rotation_interval_days": "must not be null"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "interval_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "rotation_interval_days": "Must be an integer between 0 and 3650 days; 0 disables rotation"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "interval_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "rotation_interval_days": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "cancelled_after_lookup":
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
  /// **Example** "status_unavailable":
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
  /// **Example** "scope_lookup_unavailable":
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
  _i7.Future<_i8.TonikResult<_i15.SetDkimRotationResponse, _i10.Response>>
  setDkimRotation({
    required _i16.SetDkimRotationBody body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _setDkimRotation(body: body, id: id, cancellation: cancellation);
}
