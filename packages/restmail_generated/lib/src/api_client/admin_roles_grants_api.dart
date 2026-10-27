// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i11;

import 'package:http/http.dart' as _i14;
import 'package:restmail_generated/src/model/activate_request.dart' as _i21;
import 'package:restmail_generated/src/model/create_grant_request.dart' as _i17;
import 'package:restmail_generated/src/model/second_factor_request.dart'
    as _i24;
import 'package:restmail_generated/src/operation/activate_grant.dart' as _i7;
import 'package:restmail_generated/src/operation/create_grant.dart' as _i4;
import 'package:restmail_generated/src/operation/deactivate_grant.dart' as _i8;
import 'package:restmail_generated/src/operation/delete_grant.dart' as _i6;
import 'package:restmail_generated/src/operation/list_capabilities.dart' as _i2;
import 'package:restmail_generated/src/operation/list_grants.dart' as _i3;
import 'package:restmail_generated/src/operation/list_my_grants.dart' as _i5;
import 'package:restmail_generated/src/operation/list_roles.dart' as _i10;
import 'package:restmail_generated/src/operation/make_grant_eligible.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/activate_grant_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/create_grant_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/deactivate_grant_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/delete_grant_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/list_capabilities_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/list_grants_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/list_my_grants_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/list_roles_response.dart'
    as _i25;
import 'package:restmail_generated/src/response_wrapper/make_grant_eligible_response.dart'
    as _i23;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i12;

class AdminRolesGrantsApi {
  AdminRolesGrantsApi(_i1.Server server)
    : _listCapabilities = _i2.ListCapabilities(
        server.baseUrl,
        () => server.client,
      ),
      _listGrants = _i3.ListGrants(server.baseUrl, () => server.client),
      _createGrant = _i4.CreateGrant(server.baseUrl, () => server.client),
      _listMyGrants = _i5.ListMyGrants(server.baseUrl, () => server.client),
      _deleteGrant = _i6.DeleteGrant(server.baseUrl, () => server.client),
      _activateGrant = _i7.ActivateGrant(server.baseUrl, () => server.client),
      _deactivateGrant = _i8.DeactivateGrant(
        server.baseUrl,
        () => server.client,
      ),
      _makeGrantEligible = _i9.MakeGrantEligible(
        server.baseUrl,
        () => server.client,
      ),
      _listRoles = _i10.ListRoles(server.baseUrl, () => server.client);

  final _i2.ListCapabilities _listCapabilities;

  final _i3.ListGrants _listGrants;

  final _i4.CreateGrant _createGrant;

  final _i5.ListMyGrants _listMyGrants;

  final _i6.DeleteGrant _deleteGrant;

  final _i7.ActivateGrant _activateGrant;

  final _i8.DeactivateGrant _deactivateGrant;

  final _i9.MakeGrantEligible _makeGrantEligible;

  final _i10.ListRoles _listRoles;

  /// List capabilities
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — A permitted session reads the capability catalogue:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "action": "read",
  ///       "description": "Read accounts and grants",
  ///       "id": 1,
  ///       "name": "users:read",
  ///       "resource": "users"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie. The real production router proves this refusal.
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
  /// **Example** "insufficient_permissions" — The session lacks users:read at the server scope:
  /// Precondition: the session is current and setup is complete, but its live grants do not cover users:read at *. The real capability middleware proves this refusal.
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
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the configured transport body cap:
  /// Precondition: a current session sends Content-Length above APIMaxBodyBytes, even on this GET. The registered-route test sets the transport size directly; there is no typed request body.
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
  /// **Example** "internal_error" — The capability store read fails:
  /// Fault precondition: session and permission checks pass, but the capability table cannot be read. The real registration proves this refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to fetch capabilities"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// Fault precondition: the database-backed current-session check fails. The real production router with a failing database proves this response.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i11.Future<_i12.TonikResult<_i13.ListCapabilitiesResponse, _i14.Response>>
  listCapabilities({_i12.TonikCancellation? cancellation}) async =>
      _listCapabilities(cancellation: cancellation);

  /// List grants, oldest first
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
  ///     "message": "Failed to fetch grants"
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
  _i11.Future<_i12.TonikResult<_i15.ListGrantsResponse, _i14.Response>>
  listGrants({
    _i11.String? holderKind,
    _i11.int? holderId,
    _i11.String? scope,
    _i11.int? limit,
    _i11.int? offset,
    _i12.TonikCancellation? cancellation,
  }) async => _listGrants(
    holderKind: holderKind,
    holderId: holderId,
    scope: scope,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Grant a role at a scope
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i11.Future<_i12.TonikResult<_i16.CreateGrantResponse, _i14.Response>>
  createGrant({
    required _i17.CreateGrantRequest body,
    _i12.TonikCancellation? cancellation,
  }) async => _createGrant(body: body, cancellation: cancellation);

  /// The caller's own grants
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
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
  ///     "message": "Failed to fetch grants"
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
  _i11.Future<_i12.TonikResult<_i18.ListMyGrantsResponse, _i14.Response>>
  listMyGrants({_i12.TonikCancellation? cancellation}) async =>
      _listMyGrants(cancellation: cancellation);

  /// Remove a grant
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
  /// **Example** "grant_exceeds_held":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "grant_exceeds_held",
  ///     "message": "you can only grant or remove a role whose capabilities you hold, at a scope within your own"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "session_required",
  ///     "message": "Sign in with your password to manage eligible permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "session_required",
  ///     "message": "Sign in with your password to manage eligible permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "session_required",
  ///     "message": "Sign in with your password to manage eligible permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "session_required",
  ///     "message": "Sign in with your password to manage eligible permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "session_required",
  ///     "message": "Sign in with your password to manage eligible permissions"
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
  /// **Example** "two_factor_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "Changing grants needs a session signed in with two-factor authentication: sign in again with your code"
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
  ///     "message": "Grant not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "last_superadmin":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "last_superadmin",
  ///     "message": "Refused: this is the last grant of every capability at \"*\" held by an active account that can use it; nobody could grant anything after it"
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
  /// **Example** "activation_audit_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "activation_delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "activation_lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "audit_read_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "audit_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "authorize_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cancelled":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "lock_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "remaining_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "role_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
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
  _i11.Future<_i12.TonikResult<_i19.DeleteGrantResponse, _i14.Response>>
  deleteGrant({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _deleteGrant(id: id, cancellation: cancellation);

  /// Switch an eligible grant on
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i11.Future<_i12.TonikResult<_i20.ActivateGrantResponse, _i14.Response>>
  activateGrant({
    required _i21.ActivateRequest body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _activateGrant(body: body, id: id, cancellation: cancellation);

  /// Switch a grant off
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i11.Future<_i12.TonikResult<_i22.DeactivateGrantResponse, _i14.Response>>
  deactivateGrant({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _deactivateGrant(id: id, cancellation: cancellation);

  /// Make an active grant eligible
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i11.Future<_i12.TonikResult<_i23.MakeGrantEligibleResponse, _i14.Response>>
  makeGrantEligible({
    required _i24.SecondFactorRequest body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async =>
      _makeGrantEligible(body: body, id: id, cancellation: cancellation);

  /// List roles
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
  ///     "message": "Failed to fetch roles"
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
  _i11.Future<_i12.TonikResult<_i25.ListRolesResponse, _i14.Response>>
  listRoles({_i12.TonikCancellation? cancellation}) async =>
      _listRoles(cancellation: cancellation);
}
