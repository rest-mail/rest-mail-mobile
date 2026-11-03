// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:http/http.dart' as _i10;
import 'package:restmail_generated/src/model/create_alias_request.dart' as _i12;
import 'package:restmail_generated/src/model/update_alias_request.dart' as _i16;
import 'package:restmail_generated/src/operation/create_alias.dart' as _i3;
import 'package:restmail_generated/src/operation/delete_alias.dart' as _i5;
import 'package:restmail_generated/src/operation/get_alias.dart' as _i4;
import 'package:restmail_generated/src/operation/list_aliases.dart' as _i2;
import 'package:restmail_generated/src/operation/update_alias.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/create_alias_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/delete_alias_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/get_alias_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/list_aliases_response.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/update_alias_response.dart'
    as _i15;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

class AdminAliasesApi {
  AdminAliasesApi(_i1.Server server)
    : _listAliases = _i2.ListAliases(server.baseUrl, () => server.client),
      _createAlias = _i3.CreateAlias(server.baseUrl, () => server.client),
      _getAlias = _i4.GetAlias(server.baseUrl, () => server.client),
      _deleteAlias = _i5.DeleteAlias(server.baseUrl, () => server.client),
      _updateAlias = _i6.UpdateAlias(server.baseUrl, () => server.client);

  final _i2.ListAliases _listAliases;

  final _i3.CreateAlias _createAlias;

  final _i4.GetAlias _getAlias;

  final _i5.DeleteAlias _deleteAlias;

  final _i6.UpdateAlias _updateAlias;

  /// List aliases, optionally filtered by domain
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
  ///     "message": "Failed to list aliases"
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
  _i7.Future<_i8.TonikResult<_i9.ListAliasesResponse, _i10.Response>>
  listAliases({
    _i7.int? domainId,
    _i7.int? limit,
    _i7.int? offset,
    _i8.TonikCancellation? cancellation,
  }) async => _listAliases(
    domainId: domainId,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Create a new alias
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "domain_missing":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@missing.test"
  /// }
  /// ```
  ///
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "duplicate@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Production registration, JWT/scoped-key checks, current holder grants and CSRF precede mutation. The source domain is the authority boundary; mailbox and destination-domain grants cannot configure an alias. Loaded domain fields additionally require domains:read; creation has no loaded association. Controlled SQL proves wiring, not PostgreSQL uniqueness/durability or mail routing.
  ///
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes before body parsing.
  ///
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "source_invalid":
  /// This request matches the published string type but is refused by runtime address validation. Preserve the exact 422 answer without marking this schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "destination_address": "admin@restmail.test",
  ///   "source_address": "not-an-email"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "sales@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test",
  ///   "source_address": "write-failure@restmail.test"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "found":
  /// Production registration, JWT/scoped-key checks, current holder grants and CSRF precede mutation. The source domain is the authority boundary; mailbox and destination-domain grants cannot configure an alias. Loaded domain fields additionally require domains:read; creation has no loaded association. Controlled SQL proves wiring, not PostgreSQL uniqueness/durability or mail routing.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "destination_address": "new@destination.test",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "source_address": "sales@restmail.test"
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
  /// Response 404 (application/json):
  /// **Example** "domain_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "domain_not_found",
  ///     "message": "Domain not found for source address"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Alias already exists"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes before body parsing.
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
  /// **Example** "source_invalid":
  /// This request matches the published string type but is refused by runtime address validation. Preserve the exact 422 answer without marking this schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "source_address": "must be a valid email address"
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
  _i7.Future<_i8.TonikResult<_i11.CreateAliasResponse, _i10.Response>>
  createAlias({
    required _i12.CreateAliasRequest body,
    _i8.TonikCancellation? cancellation,
  }) async => _createAlias(body: body, cancellation: cancellation);

  /// Get an alias by ID
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — Read the full public resource:
  /// The global capability permits this lookup. Stored fields are mapped by the production handler; the private DKIM key has no public field.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "destination_address": "owned@destination.test",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "reject",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "bulk",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "source_address": "support@example.com"
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
  /// **Example** "destination_mailbox_scope" — An individual destination mailbox grant cannot administer aliases:
  /// Alias configuration belongs to the source domain. Holding accounts:read for this individual destination mailbox does not grant domain administration.
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
  /// Response 404 (application/json):
  /// **Example** "missing" — The resource does not exist:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Alias not found"
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
  /// **Example** "internal_error" — A database fault is not a missing resource:
  /// The production lookup encounters a controlled database error. The error writer returns a sanitized response without the dependency detail.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get alias"
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
  _i7.Future<_i8.TonikResult<_i13.GetAliasResponse, _i10.Response>> getAlias({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _getAlias(id: id, cancellation: cancellation);

  /// Delete an alias
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Alias not found"
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
  _i7.Future<_i8.TonikResult<_i14.DeleteAliasResponse, _i10.Response>>
  deleteAlias({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _deleteAlias(id: id, cancellation: cancellation);

  /// Update an alias
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Production registration, JWT/scoped-key checks, current holder grants and CSRF precede mutation. The source domain is the authority boundary; mailbox and destination-domain grants cannot configure an alias. Loaded domain fields additionally require domains:read; creation has no loaded association. Controlled SQL proves wiring, not PostgreSQL uniqueness/durability or mail routing.
  ///
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "active": false
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "active": false
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
  ///   "destination_address": "admin@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes before body parsing.
  ///
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "destination_address": "new@destination.test"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Production registration, JWT/scoped-key checks, current holder grants and CSRF precede mutation. The source domain is the authority boundary; mailbox and destination-domain grants cannot configure an alias. Loaded domain fields additionally require domains:read; creation has no loaded association. Controlled SQL proves wiring, not PostgreSQL uniqueness/durability or mail routing.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "destination_address": "new@destination.test",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "reject",
  ///       "id": 1,
  ///       "name": "restmail.test",
  ///       "sending_policy": "bulk",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "source_address": "sales@restmail.test"
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Alias not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes before body parsing.
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
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
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
  _i7.Future<_i8.TonikResult<_i15.UpdateAliasResponse, _i10.Response>>
  updateAlias({
    required _i16.UpdateAliasRequest body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => _updateAlias(body: body, id: id, cancellation: cancellation);
}
