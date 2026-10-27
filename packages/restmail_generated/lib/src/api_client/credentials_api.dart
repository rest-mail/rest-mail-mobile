// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:http/http.dart' as _i11;
import 'package:restmail_generated/src/model/create_api_key_body.dart' as _i13;
import 'package:restmail_generated/src/model/create_credential_body.dart'
    as _i17;
import 'package:restmail_generated/src/operation/create_api_key.dart' as _i3;
import 'package:restmail_generated/src/operation/create_app_password.dart'
    as _i6;
import 'package:restmail_generated/src/operation/list_api_keys.dart' as _i2;
import 'package:restmail_generated/src/operation/list_credentials.dart' as _i5;
import 'package:restmail_generated/src/operation/revoke_api_key.dart' as _i4;
import 'package:restmail_generated/src/operation/revoke_credential.dart' as _i7;
import 'package:restmail_generated/src/response_wrapper/create_api_key_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/create_app_password_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/list_api_keys_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/list_credentials_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/revoke_api_key_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/revoke_credential_response.dart'
    as _i18;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

class CredentialsApi {
  CredentialsApi(_i1.Server server)
    : _listApiKeys = _i2.ListApiKeys(server.baseUrl, () => server.client),
      _createApiKey = _i3.CreateApiKey(server.baseUrl, () => server.client),
      _revokeApiKey = _i4.RevokeApiKey(server.baseUrl, () => server.client),
      _listCredentials = _i5.ListCredentials(
        server.baseUrl,
        () => server.client,
      ),
      _createAppPassword = _i6.CreateAppPassword(
        server.baseUrl,
        () => server.client,
      ),
      _revokeCredential = _i7.RevokeCredential(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListApiKeys _listApiKeys;

  final _i3.CreateApiKey _createApiKey;

  final _i4.RevokeApiKey _revokeApiKey;

  final _i5.ListCredentials _listCredentials;

  final _i6.CreateAppPassword _createAppPassword;

  final _i7.RevokeCredential _revokeCredential;

  /// List an account's API keys
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "cookie_session" — A current cookie session has the same management ceiling:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "api_key",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "permissions": [
  ///         {
  ///           "capability": "mail:read",
  ///           "scope": "mailbox:linked@example.com"
  ///         },
  ///         {
  ///           "capability": "mail:send",
  ///           "scope": "domain:example.com"
  ///         }
  ///       ],
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "api_key",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "permissions": [],
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_manager" — A domain-scoped mailbox manager reaches this account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "api_key",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "permissions": [
  ///         {
  ///           "capability": "mail:read",
  ///           "scope": "mailbox:linked@example.com"
  ///         },
  ///         {
  ///           "capability": "mail:send",
  ///           "scope": "domain:example.com"
  ///         }
  ///       ],
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "api_key",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "permissions": [],
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty" — No credentials are returned as an empty array, never null:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "found" — A mailbox manager reads metadata, including expired credentials and nullable last-use times:
  /// The real repository query restricts account, credential kind and revocation and orders newest first. Fixed rows contain private hash/encrypted-secret sentinels, neither of which is returned. SQL semantics and persistence require PostgreSQL; only wiring and exact response mapping are claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "api_key",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "permissions": [
  ///         {
  ///           "capability": "mail:read",
  ///           "scope": "mailbox:linked@example.com"
  ///         },
  ///         {
  ///           "capability": "mail:send",
  ///           "scope": "domain:example.com"
  ///         }
  ///       ],
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "api_key",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "permissions": [],
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary" — Implicit ownership permits management of the primary account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "api_key",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "permissions": [
  ///         {
  ///           "capability": "mail:read",
  ///           "scope": "mailbox:linked@example.com"
  ///         },
  ///         {
  ///           "capability": "mail:send",
  ///           "scope": "domain:example.com"
  ///         }
  ///       ],
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "api_key",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "permissions": [],
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "app_password" — Credential management accepts no HTTP Basic app password:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Credential management accepts no API key, even one valid for mail reads:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "setup_required" — A session still in setup cannot use account reads:
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
  /// **Example** "inaccessible":
  /// Unknown and inaccessible accounts retain the same privacy refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "write_only" — Mail-write permission is insufficient to manage credentials:
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
  /// **Example** "invalid_format" — The account ID cannot bind to an integer:
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
  /// **Example** "content_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
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
  _i8.Future<_i9.TonikResult<_i10.ListApiKeysResponse, _i11.Response>>
  listApiKeys({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _listApiKeys(id: id, cancellation: cancellation);

  /// Make a scoped API key
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:read",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:read",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "permissions_missing":
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password"
  /// }
  /// ```
  ///
  /// **Example** "wildcard_capability":
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "*",
  ///       "scope": "*"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "expires_at": "2026-04-01T00:00:00Z",
  ///     "id": 2,
  ///     "kind": "api_key",
  ///     "last_used_at": null,
  ///     "name": "Invoice robot",
  ///     "permissions": [
  ///       {
  ///         "capability": "mail:read",
  ///         "scope": "mailbox:robot@example.com"
  ///       }
  ///     ],
  ///     "public_id": "9Hm3yU1cNp5Q",
  ///     "token": "rmk_9Hm3yU1cNp5Q_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "name_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "permissions_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "permissions": "must contain between 1 and 64 scoped permissions"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wildcard_capability":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "permissions": "each permission needs a named capability and a valid scope"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i8.Future<_i9.TonikResult<_i12.CreateApiKeyResponse, _i11.Response>>
  createApiKey({
    required _i13.CreateApiKeyBody body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _createApiKey(body: body, id: id, cancellation: cancellation);

  /// Revoke an API key
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_send":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "no_two_factor":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "Sign in with two-factor authentication to revoke API keys"
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
  /// **Example** "already_revoked":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "API key not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_outside":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "foreign_owner":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "API key not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "API key not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_account":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
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
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_kind":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "API key not found"
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
  /// **Example** "invalid_credential":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "credential_id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_credential_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "credential_id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
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
  /// Response 500 (application/json):
  /// **Example** "audit_unavailable":
  /// Current policy: API-key revocation and its audit append share a transaction, so an audit failure refuses it. App-password revocation audits through middleware after the handler and preserves its successful response when that audit fails. This change tests those existing policies without claiming durable SQL outcomes locally.
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
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
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
  _i8.Future<_i9.TonikResult<_i14.RevokeApiKeyResponse, _i11.Response>>
  revokeApiKey({
    required _i8.int id,
    required _i8.int credentialId,
    _i9.TonikCancellation? cancellation,
  }) async => _revokeApiKey(
    id: id,
    credentialId: credentialId,
    cancellation: cancellation,
  );

  /// List an account's app passwords
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "cookie_session" — A current cookie session has the same management ceiling:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "app_password",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "app_password",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_manager" — A domain-scoped mailbox manager reaches this account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "app_password",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "app_password",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty" — No credentials are returned as an empty array, never null:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "found" — A mailbox manager reads metadata, including expired credentials and nullable last-use times:
  /// The real repository query restricts account, credential kind and revocation and orders newest first. Fixed rows contain private hash/encrypted-secret sentinels, neither of which is returned. SQL semantics and persistence require PostgreSQL; only wiring and exact response mapping are claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "app_password",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "app_password",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary" — Implicit ownership permits management of the primary account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "expires_at": "2027-10-20T00:00:00Z",
  ///       "id": 102,
  ///       "kind": "app_password",
  ///       "last_used_at": "2026-10-20T01:00:00Z",
  ///       "name": "Phone café",
  ///       "public_id": "public-new"
  ///     },
  ///     {
  ///       "created_at": "2026-10-18T00:00:00Z",
  ///       "expires_at": "2025-10-20T00:00:00Z",
  ///       "id": 101,
  ///       "kind": "app_password",
  ///       "last_used_at": null,
  ///       "name": "Expired",
  ///       "public_id": "public-old"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "app_password" — Credential management accepts no HTTP Basic app password:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Credential management accepts no API key, even one valid for mail reads:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "setup_required" — A session still in setup cannot use account reads:
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
  /// **Example** "inaccessible":
  /// Unknown and inaccessible accounts retain the same privacy refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "write_only" — Mail-write permission is insufficient to manage credentials:
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
  /// **Example** "invalid_format" — The account ID cannot bind to an integer:
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
  /// **Example** "content_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
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
  _i8.Future<_i9.TonikResult<_i15.ListCredentialsResponse, _i11.Response>>
  listCredentials({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _listCredentials(id: id, cancellation: cancellation);

  /// Make an app password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "name": "Mail\nClient"
  /// }
  /// ```
  ///
  /// **Example** "name_empty":
  /// ```json
  /// {
  ///   "name": ""
  /// }
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "name": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "expires_at": null,
  ///     "id": 1,
  ///     "kind": "app_password",
  ///     "last_used_at": null,
  ///     "name": "iPhone Mail",
  ///     "password": "rm_7Kq2xT9bLm4P_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  ///     "public_id": "7Kq2xT9bLm4P"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "name_control":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must not contain control characters"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "name_too_long":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be at most 100 characters"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i8.Future<_i9.TonikResult<_i16.CreateAppPasswordResponse, _i11.Response>>
  createAppPassword({
    required _i17.CreateCredentialBody body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async =>
      _createAppPassword(body: body, id: id, cancellation: cancellation);

  /// Revoke an app password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_send":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "already_revoked":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Credential not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_outside":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "foreign_owner":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Credential not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Credential not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_account":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
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
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Account not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_kind":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Credential not found"
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
  /// **Example** "invalid_credential":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "credential_id": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_credential_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "credential_id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
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
  /// Response 500 (application/json):
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
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
  _i8.Future<_i9.TonikResult<_i18.RevokeCredentialResponse, _i11.Response>>
  revokeCredential({
    required _i8.int id,
    required _i8.int credentialId,
    _i9.TonikCancellation? cancellation,
  }) async => _revokeCredential(
    id: id,
    credentialId: credentialId,
    cancellation: cancellation,
  );
}
