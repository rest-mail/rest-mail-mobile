// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i12;

import 'package:http/http.dart' as _i15;
import 'package:restmail_generated/src/model/create_api_key_body.dart' as _i17;
import 'package:restmail_generated/src/model/create_credential_body.dart'
    as _i26;
import 'package:restmail_generated/src/model/update_api_key_body.dart' as _i20;
import 'package:restmail_generated/src/operation/create_api_key.dart' as _i3;
import 'package:restmail_generated/src/operation/create_app_password.dart'
    as _i10;
import 'package:restmail_generated/src/operation/create_client_secret.dart'
    as _i7;
import 'package:restmail_generated/src/operation/list_api_keys.dart' as _i2;
import 'package:restmail_generated/src/operation/list_client_secrets.dart'
    as _i6;
import 'package:restmail_generated/src/operation/list_credentials.dart' as _i9;
import 'package:restmail_generated/src/operation/revoke_api_key.dart' as _i4;
import 'package:restmail_generated/src/operation/revoke_client_secret.dart'
    as _i8;
import 'package:restmail_generated/src/operation/revoke_credential.dart'
    as _i11;
import 'package:restmail_generated/src/operation/update_api_key.dart' as _i5;
import 'package:restmail_generated/src/response_wrapper/create_api_key_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/create_app_password_response.dart'
    as _i25;
import 'package:restmail_generated/src/response_wrapper/create_client_secret_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/list_api_keys_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/list_client_secrets_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/list_credentials_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/revoke_api_key_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/revoke_client_secret_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/revoke_credential_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/update_api_key_response.dart'
    as _i19;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i13;

class CredentialsApi {
  CredentialsApi(_i1.Server server)
    : _listApiKeys = _i2.ListApiKeys(server.baseUrl, () => server.client),
      _createApiKey = _i3.CreateApiKey(server.baseUrl, () => server.client),
      _revokeApiKey = _i4.RevokeApiKey(server.baseUrl, () => server.client),
      _updateApiKey = _i5.UpdateApiKey(server.baseUrl, () => server.client),
      _listClientSecrets = _i6.ListClientSecrets(
        server.baseUrl,
        () => server.client,
      ),
      _createClientSecret = _i7.CreateClientSecret(
        server.baseUrl,
        () => server.client,
      ),
      _revokeClientSecret = _i8.RevokeClientSecret(
        server.baseUrl,
        () => server.client,
      ),
      _listCredentials = _i9.ListCredentials(
        server.baseUrl,
        () => server.client,
      ),
      _createAppPassword = _i10.CreateAppPassword(
        server.baseUrl,
        () => server.client,
      ),
      _revokeCredential = _i11.RevokeCredential(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListApiKeys _listApiKeys;

  final _i3.CreateApiKey _createApiKey;

  final _i4.RevokeApiKey _revokeApiKey;

  final _i5.UpdateApiKey _updateApiKey;

  final _i6.ListClientSecrets _listClientSecrets;

  final _i7.CreateClientSecret _createClientSecret;

  final _i8.RevokeClientSecret _revokeClientSecret;

  final _i9.ListCredentials _listCredentials;

  final _i10.CreateAppPassword _createAppPassword;

  final _i11.RevokeCredential _revokeCredential;

  /// List an account's API keys
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
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
  /// Response 500 (application/json):
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
  _i12.Future<_i13.TonikResult<_i14.ListApiKeysResponse, _i15.Response>>
  listApiKeys({
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => _listApiKeys(id: id, cancellation: cancellation);

  /// Make a scoped API key
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
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
  /// **Example** "internal_error" — A database fault is not a client error:
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
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing" — The account does not exist or is out of reach:
  /// ```json
  /// {
  ///   "name": "n8n invoices",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:read",
  ///       "scope": "mailbox:admin@restmail.test"
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
  /// **Example** "password_only" — A session without a second factor:
  /// ```json
  /// {
  ///   "name": "n8n invoices",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:read",
  ///       "scope": "mailbox:admin@restmail.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
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
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
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
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
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
  /// **Example** "session_unavailable" — The current-session lookup fails:
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
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
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
  /// **Example** "unauthenticated" — No credential is sent:
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
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
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
  /// **Example** "password_only" — A session without a second factor:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recent_two_factor_required",
  ///     "message": "Sign in again with two-factor authentication: a recent second factor is required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
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
  /// **Example** "missing" — The account does not exist or is out of reach:
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
  /// **Example** "body_array" — The body is not a JSON object:
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
  _i12.Future<_i13.TonikResult<_i16.CreateApiKeyResponse, _i15.Response>>
  createApiKey({
    required _i17.CreateApiKeyBody body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => _createApiKey(body: body, id: id, cancellation: cancellation);

  /// Revoke an API key
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
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
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
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
  /// Response 500 (application/json):
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
  _i12.Future<_i13.TonikResult<_i18.RevokeApiKeyResponse, _i15.Response>>
  revokeApiKey({
    required _i12.int id,
    required _i12.int credentialId,
    _i13.TonikCancellation? cancellation,
  }) async => _revokeApiKey(
    id: id,
    credentialId: credentialId,
    cancellation: cancellation,
  );

  /// Change what an API key may do, keeping its secret
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "beyond_grants" — The permissions go beyond what the account holds:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "*"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "permissions_missing":
  /// ```json
  /// {
  ///   "password": "current-password"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "wrong_password" — The current password is entered wrongly:
  /// ```json
  /// {
  ///   "password": "not-the-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mail:send",
  ///       "scope": "mailbox:robot@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "updated":
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
  ///         "capability": "mail:send",
  ///         "scope": "mailbox:robot@example.com"
  ///       }
  ///     ],
  ///     "public_id": "9Hm3yU1cNp5Q"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
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
  /// **Example** "beyond_grants" — The permissions go beyond what the account holds:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "API key permissions must be within the account's and your current grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recent_two_factor_required",
  ///     "message": "Sign in again with two-factor authentication: a recent second factor is required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_password" — The current password is entered wrongly:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_password",
  ///     "message": "The password is incorrect"
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
  ///     "message": "API key not found"
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
  /// **Example** "body_array" — The body is not a JSON object:
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
  _i12.Future<_i13.TonikResult<_i19.UpdateApiKeyResponse, _i15.Response>>
  updateApiKey({
    required _i20.UpdateApiKeyBody body,
    required _i12.int id,
    required _i12.int credentialId,
    _i13.TonikCancellation? cancellation,
  }) async => _updateApiKey(
    body: body,
    id: id,
    credentialId: credentialId,
    cancellation: cancellation,
  );

  /// List an account's client secrets
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "listed":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "expires_at": "2026-04-01T00:00:00Z",
  ///       "id": 34,
  ///       "kind": "client_secret",
  ///       "last_used_at": null,
  ///       "name": "Invoice robot",
  ///       "permissions": [
  ///         {
  ///           "capability": "pipelines:write",
  ///           "scope": "domain:example.test"
  ///         }
  ///       ],
  ///       "public_id": "9Hm3yU1cNp5Q"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — A session still in setup cannot use this route:
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
  ///     "message": "Account not found"
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
  _i12.Future<_i13.TonikResult<_i21.ListClientSecretsResponse, _i15.Response>>
  listClientSecrets({
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => _listClientSecrets(id: id, cancellation: cancellation);

  /// Make a scoped OAuth client secret
  /// Requires a human session signed in with a second factor, the current password, and mailbox:manage on the account. Returns client_id and client_secret once; stores only the secret hash. Permissions must be within both the creator's and the account's live grants. The client-secret tier accepts mail:read, mail:write, mail:send and mail:receive; domains:read, mailboxes:read and pipelines:read/write/delete require a domain scope. It rejects all other capabilities, including account/credential creation, granting, password/2FA, audit, retention and server-ceiling controls. expires_at defaults to 90 days. Credential creation is audited as client_secrets.create with actor and credential id. Client secrets exchange at /api/v1/oauth/token; they are never accepted as bearer API keys or mail-client passwords.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing" — The account does not exist:
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
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
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "password_only":
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The shared throttle is spent:
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "pipelines:write",
  ///       "scope": "domain:example.test"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "tier_refused" — Account creation is beyond the client-secret tier:
  /// ```json
  /// {
  ///   "name": "Invoice robot",
  ///   "password": "current-password",
  ///   "permissions": [
  ///     {
  ///       "capability": "mailboxes:write",
  ///       "scope": "domain:example.test"
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
  ///     "client_id": "9Hm3yU1cNp5Q",
  ///     "client_secret": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "expires_at": "2026-04-01T00:00:00Z",
  ///     "id": 34,
  ///     "kind": "client_secret",
  ///     "last_used_at": null,
  ///     "name": "Invoice robot",
  ///     "permissions": [
  ///       {
  ///         "capability": "pipelines:write",
  ///         "scope": "domain:example.test"
  ///       }
  ///     ],
  ///     "public_id": "9Hm3yU1cNp5Q"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
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
  /// Response 403 (application/json):
  /// **Example** "password_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "Sign in with a second factor to create client secrets"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — The account does not exist:
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
  /// **Example** "body_array":
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
  /// **Example** "tier_refused" — Account creation is beyond the client-secret tier:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "permissions": "client secrets may hold mailbox capabilities and ordinary domain administration, never human-2FA-only capabilities"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — The shared throttle is spent:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rate_limited",
  ///     "message": "Too many requests; please slow down"
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
  _i12.Future<_i13.TonikResult<_i22.CreateClientSecretResponse, _i15.Response>>
  createClientSecret({
    required _i17.CreateApiKeyBody body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      _createClientSecret(body: body, id: id, cancellation: cancellation);

  /// Revoke a client secret and its tokens
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 403 (application/json):
  /// **Example** "setup_required" — A session still in setup cannot use this route:
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
  ///     "message": "Client secret not found"
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
  _i12.Future<_i13.TonikResult<_i23.RevokeClientSecretResponse, _i15.Response>>
  revokeClientSecret({
    required _i12.int id,
    required _i12.int credentialId,
    _i13.TonikCancellation? cancellation,
  }) async => _revokeClientSecret(
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
  /// Response 500 (application/json):
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
  _i12.Future<_i13.TonikResult<_i24.ListCredentialsResponse, _i15.Response>>
  listCredentials({
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => _listCredentials(id: id, cancellation: cancellation);

  /// Make an app password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "credential" — HTTP Basic credentials cannot authenticate a session-only route:
  /// ```json
  /// {
  ///   "name": "Thunderbird"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing" — The account does not exist or is out of reach:
  /// ```json
  /// {
  ///   "name": "Thunderbird"
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
  /// **Example** "password_only" — A session without the mailbox's second factor:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "name": "iPhone Mail"
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
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
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
  /// **Example** "credential" — HTTP Basic credentials cannot authenticate a session-only route:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "password_only" — A session without the mailbox's second factor:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recent_two_factor_required",
  ///     "message": "Sign in again with two-factor authentication: a recent second factor is required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
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
  /// **Example** "missing" — The account does not exist or is out of reach:
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
  /// **Example** "body_array" — The body is not a JSON object:
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
  _i12.Future<_i13.TonikResult<_i25.CreateAppPasswordResponse, _i15.Response>>
  createAppPassword({
    required _i26.CreateCredentialBody body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      _createAppPassword(body: body, id: id, cancellation: cancellation);

  /// Revoke an app password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
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
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
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
  /// Response 500 (application/json):
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
  _i12.Future<_i13.TonikResult<_i27.RevokeCredentialResponse, _i15.Response>>
  revokeCredential({
    required _i12.int id,
    required _i12.int credentialId,
    _i13.TonikCancellation? cancellation,
  }) async => _revokeCredential(
    id: id,
    credentialId: credentialId,
    cancellation: cancellation,
  );
}
