// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i15;

import 'package:http/http.dart' as _i18;
import 'package:restmail_generated/src/model/activate_request.dart' as _i25;
import 'package:restmail_generated/src/model/create_grant_request.dart' as _i21;
import 'package:restmail_generated/src/model/second_factor_request.dart'
    as _i28;
import 'package:restmail_generated/src/model/update_server_capabilities_request.dart'
    as _i32;
import 'package:restmail_generated/src/model/update_server_limits_request.dart'
    as _i35;
import 'package:restmail_generated/src/operation/activate_grant.dart' as _i7;
import 'package:restmail_generated/src/operation/create_grant.dart' as _i4;
import 'package:restmail_generated/src/operation/deactivate_grant.dart' as _i8;
import 'package:restmail_generated/src/operation/delete_grant.dart' as _i6;
import 'package:restmail_generated/src/operation/get_server_capabilities.dart'
    as _i11;
import 'package:restmail_generated/src/operation/get_server_limits.dart'
    as _i13;
import 'package:restmail_generated/src/operation/list_capabilities.dart' as _i2;
import 'package:restmail_generated/src/operation/list_grants.dart' as _i3;
import 'package:restmail_generated/src/operation/list_my_grants.dart' as _i5;
import 'package:restmail_generated/src/operation/list_roles.dart' as _i10;
import 'package:restmail_generated/src/operation/make_grant_eligible.dart'
    as _i9;
import 'package:restmail_generated/src/operation/update_server_capabilities.dart'
    as _i12;
import 'package:restmail_generated/src/operation/update_server_limits.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/activate_grant_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/create_grant_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/deactivate_grant_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/delete_grant_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/get_server_capabilities_response.dart'
    as _i30;
import 'package:restmail_generated/src/response_wrapper/get_server_limits_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/list_capabilities_response.dart'
    as _i17;
import 'package:restmail_generated/src/response_wrapper/list_grants_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/list_my_grants_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/list_roles_response.dart'
    as _i29;
import 'package:restmail_generated/src/response_wrapper/make_grant_eligible_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/update_server_capabilities_response.dart'
    as _i31;
import 'package:restmail_generated/src/response_wrapper/update_server_limits_response.dart'
    as _i34;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i16;

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
      _listRoles = _i10.ListRoles(server.baseUrl, () => server.client),
      _getServerCapabilities = _i11.GetServerCapabilities(
        server.baseUrl,
        () => server.client,
      ),
      _updateServerCapabilities = _i12.UpdateServerCapabilities(
        server.baseUrl,
        () => server.client,
      ),
      _getServerLimits = _i13.GetServerLimits(
        server.baseUrl,
        () => server.client,
      ),
      _updateServerLimits = _i14.UpdateServerLimits(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListCapabilities _listCapabilities;

  final _i3.ListGrants _listGrants;

  final _i4.CreateGrant _createGrant;

  final _i5.ListMyGrants _listMyGrants;

  final _i6.DeleteGrant _deleteGrant;

  final _i7.ActivateGrant _activateGrant;

  final _i8.DeactivateGrant _deactivateGrant;

  final _i9.MakeGrantEligible _makeGrantEligible;

  final _i10.ListRoles _listRoles;

  final _i11.GetServerCapabilities _getServerCapabilities;

  final _i12.UpdateServerCapabilities _updateServerCapabilities;

  final _i13.GetServerLimits _getServerLimits;

  final _i14.UpdateServerLimits _updateServerLimits;

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
  _i15.Future<_i16.TonikResult<_i17.ListCapabilitiesResponse, _i18.Response>>
  listCapabilities({_i16.TonikCancellation? cancellation}) async =>
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
  _i15.Future<_i16.TonikResult<_i19.ListGrantsResponse, _i18.Response>>
  listGrants({
    _i15.String? holderKind,
    _i15.int? holderId,
    _i15.String? scope,
    _i15.int? limit,
    _i15.int? offset,
    _i16.TonikCancellation? cancellation,
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
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "exceeds_held" — The granter does not hold the role's capabilities:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "role": "superadmin",
  ///   "scope": "*"
  /// }
  /// ```
  ///
  /// **Example** "exists" — The holder already has that grant:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "eligible",
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
  /// }
  /// ```
  ///
  /// **Example** "granted" — An eligible admin grant on one domain:
  /// Changing grants needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "eligible",
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "eligible",
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
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
  /// **Example** "no_holder" — The holder does not exist:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2147483647,
  ///     "kind": "account"
  ///   },
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "role": "superadmin",
  ///   "scope": "*"
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "active",
  ///   "role": "admin",
  ///   "scope": "domain:example.test"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "eligible",
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "active",
  ///   "role": "admin",
  ///   "scope": "domain:example.test"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "holder": {
  ///     "id": 2,
  ///     "kind": "account"
  ///   },
  ///   "mode": "eligible",
  ///   "role": "admin",
  ///   "scope": "domain:example.com"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "granted" — An eligible admin grant on one domain:
  /// Changing grants needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "activation": null,
  ///     "expires_at": null,
  ///     "granted_at": "2026-10-20T00:00:00Z",
  ///     "granted_by": {
  ///       "id": 1,
  ///       "kind": "account"
  ///     },
  ///     "holder": {
  ///       "id": 2,
  ///       "kind": "account"
  ///     },
  ///     "id": 7,
  ///     "mode": "eligible",
  ///     "role": "admin",
  ///     "role_id": 2,
  ///     "scope": "domain:example.com"
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
  /// **Example** "exceeds_held" — The granter does not hold the role's capabilities:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "grant_exceeds_held",
  ///     "message": "you can only grant or remove a role whose capabilities you hold, at a scope within your own"
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
  /// Response 409 (application/json):
  /// **Example** "exists" — The holder already has that grant:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "conflict",
  ///     "message": "the holder already holds this role at this scope"
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
  /// **Example** "no_holder" — The holder does not exist:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "holder": "no such account"
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
  /// **Example** "internal_error" — A database fault is not a client error:
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
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i15.Future<_i16.TonikResult<_i20.CreateGrantResponse, _i18.Response>>
  createGrant({
    required _i21.CreateGrantRequest body,
    _i16.TonikCancellation? cancellation,
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
  _i15.Future<_i16.TonikResult<_i22.ListMyGrantsResponse, _i18.Response>>
  listMyGrants({_i16.TonikCancellation? cancellation}) async =>
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
  _i15.Future<_i16.TonikResult<_i23.DeleteGrantResponse, _i18.Response>>
  deleteGrant({
    required _i15.int id,
    _i16.TonikCancellation? cancellation,
  }) async => _deleteGrant(id: id, cancellation: cancellation);

  /// Switch an eligible grant on
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "activated" — An eligible grant is switched on for an hour:
  /// ```json
  /// {
  ///   "minutes": 60,
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "already_active" — The grant is on already:
  /// ```json
  /// {
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
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
  ///   "minutes": 60,
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "invalid_code" — The second factor does not match:
  /// ```json
  /// {
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "000000"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
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
  /// **Example** "missing" — No such grant of the caller's:
  /// ```json
  /// {
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "minutes": 60,
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "minutes": 60,
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "minutes": 60,
  ///   "reason": "Rotate the DKIM key",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "activated" — An eligible grant is switched on for an hour:
  /// ```json
  /// {
  ///   "data": {
  ///     "capabilities": [],
  ///     "grant": {
  ///       "activation": {
  ///         "activated_at": "2026-10-20T00:00:00Z",
  ///         "expires_at": "2026-10-20T01:00:00Z",
  ///         "id": 3,
  ///         "reason": "Rotate the DKIM key",
  ///         "seconds_left": 3600
  ///       },
  ///       "expires_at": null,
  ///       "granted_at": "2026-10-20T00:00:00Z",
  ///       "granted_by": {
  ///         "id": 1,
  ///         "kind": "account"
  ///       },
  ///       "holder": {
  ///         "id": 2,
  ///         "kind": "account"
  ///       },
  ///       "id": 7,
  ///       "mode": "eligible",
  ///       "role": "admin",
  ///       "role_id": 2,
  ///       "scope": "domain:example.com"
  ///     },
  ///     "scoped_capabilities": [
  ///       {
  ///         "capability": "admin:session",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "domains:read",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "mail:read",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_as",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_on_behalf",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:write",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:manage",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:session",
  ///         "scope": "mailbox:admin@example.com"
  ///       }
  ///     ]
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
  /// **Example** "invalid_code" — The second factor does not match:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_totp",
  ///     "message": "Invalid two-factor authentication code"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — No such grant of the caller's:
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
  /// **Example** "already_active" — The grant is on already:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_active",
  ///     "message": "this grant is already switched on"
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
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
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
  ///     "message": "Failed to change grants"
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
  _i15.Future<_i16.TonikResult<_i24.ActivateGrantResponse, _i18.Response>>
  activateGrant({
    required _i25.ActivateRequest body,
    required _i15.int id,
    _i16.TonikCancellation? cancellation,
  }) async => _activateGrant(body: body, id: id, cancellation: cancellation);

  /// Switch a grant off
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "switched_off" — The running activation ends:
  /// ```json
  /// {
  ///   "data": {
  ///     "capabilities": [],
  ///     "grant": {
  ///       "activation": null,
  ///       "expires_at": null,
  ///       "granted_at": "2026-10-20T00:00:00Z",
  ///       "granted_by": {
  ///         "id": 1,
  ///         "kind": "account"
  ///       },
  ///       "holder": {
  ///         "id": 2,
  ///         "kind": "account"
  ///       },
  ///       "id": 7,
  ///       "mode": "eligible",
  ///       "role": "admin",
  ///       "role_id": 2,
  ///       "scope": "domain:example.com"
  ///     },
  ///     "scoped_capabilities": [
  ///       {
  ///         "capability": "admin:session",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "domains:read",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "mail:read",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_as",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_on_behalf",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:write",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:manage",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:session",
  ///         "scope": "mailbox:admin@example.com"
  ///       }
  ///     ]
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
  /// **Example** "csrf_mismatch" — A cookie session sends no CSRF header:
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
  /// **Example** "missing" — No such grant of the caller's:
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
  /// **Example** "not_active" — Nothing to switch off:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_active",
  ///     "message": "this grant is not switched on"
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
  /// **Example** "internal_error" — A database fault is not a client error:
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
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i15.Future<_i16.TonikResult<_i26.DeactivateGrantResponse, _i18.Response>>
  deactivateGrant({
    required _i15.int id,
    _i16.TonikCancellation? cancellation,
  }) async => _deactivateGrant(id: id, cancellation: cancellation);

  /// Make an active grant eligible
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "already_eligible" — The grant is eligible already:
  /// ```json
  /// {
  ///   "totp_code": "123456"
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
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "invalid_code" — The second factor does not match:
  /// ```json
  /// {
  ///   "totp_code": "000000"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "totp_code": "123456"
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
  /// **Example** "missing" — No such grant of the caller's:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "now_eligible" — An active grant becomes eligible:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "now_eligible" — An active grant becomes eligible:
  /// ```json
  /// {
  ///   "data": {
  ///     "capabilities": [],
  ///     "grant": {
  ///       "activation": null,
  ///       "expires_at": null,
  ///       "granted_at": "2026-10-20T00:00:00Z",
  ///       "granted_by": {
  ///         "id": 1,
  ///         "kind": "account"
  ///       },
  ///       "holder": {
  ///         "id": 2,
  ///         "kind": "account"
  ///       },
  ///       "id": 7,
  ///       "mode": "eligible",
  ///       "role": "admin",
  ///       "role_id": 2,
  ///       "scope": "domain:example.com"
  ///     },
  ///     "scoped_capabilities": [
  ///       {
  ///         "capability": "admin:session",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "domains:read",
  ///         "scope": "domain:example.com"
  ///       },
  ///       {
  ///         "capability": "mail:read",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_as",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:send_on_behalf",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mail:write",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:manage",
  ///         "scope": "mailbox:admin@example.com"
  ///       },
  ///       {
  ///         "capability": "mailbox:session",
  ///         "scope": "mailbox:admin@example.com"
  ///       }
  ///     ]
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
  /// **Example** "invalid_code" — The second factor does not match:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_totp",
  ///     "message": "Invalid two-factor authentication code"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing" — No such grant of the caller's:
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
  /// **Example** "already_eligible" — The grant is eligible already:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_eligible",
  ///     "message": "this grant is eligible already"
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
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
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
  ///     "message": "Failed to change grants"
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
  _i15.Future<_i16.TonikResult<_i27.MakeGrantEligibleResponse, _i18.Response>>
  makeGrantEligible({
    required _i28.SecondFactorRequest body,
    required _i15.int id,
    _i16.TonikCancellation? cancellation,
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
  _i15.Future<_i16.TonikResult<_i29.ListRolesResponse, _i18.Response>>
  listRoles({_i16.TonikCancellation? cancellation}) async =>
      _listRoles(cancellation: cancellation);

  /// The server capability ceiling
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — A superadmin reads the ceiling stored in the database:
  /// ```json
  /// {
  ///   "data": {
  ///     "capabilities": [
  ///       "admin:session",
  ///       "mail:read",
  ///       "mail:send",
  ///       "mailbox:session"
  ///     ],
  ///     "source": "database"
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
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "superadmin_required",
  ///     "message": "only a superadmin can read or change the server capability ceiling"
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
  _i15.Future<
    _i16.TonikResult<_i30.GetServerCapabilitiesResponse, _i18.Response>
  >
  getServerCapabilities({_i16.TonikCancellation? cancellation}) async =>
      _getServerCapabilities(cancellation: cancellation);

  /// Replace the server capability ceiling
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "from_environment" — The environment sets the ceiling:
  /// Precondition: RESTMAIL_SERVER_CAPABILITIES is set, so the stored ceiling cannot be changed here.
  ///
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read"
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
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The shared throttle is spent:
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read",
  ///     "mail:send"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "replaced" — A superadmin replaces the stored ceiling:
  /// Changing the ceiling needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read",
  ///     "mail:send"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read",
  ///     "mail:send"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "storage_unavailable":
  /// An authenticated human session with a second factor reaches unavailable storage; the account lookup fails, or the server-ceiling transaction cannot start.
  ///
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read",
  ///     "mail:send"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:read",
  ///     "mail:send"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unknown_capability" — A name outside the capability vocabulary is refused:
  /// ```json
  /// {
  ///   "capabilities": [
  ///     "mail:reed"
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "replaced" — A superadmin replaces the stored ceiling:
  /// Changing the ceiling needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "capabilities": [
  ///       "mail:read",
  ///       "mail:send"
  ///     ],
  ///     "source": "database"
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
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "superadmin_required",
  ///     "message": "only a superadmin can read or change the server capability ceiling"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "from_environment" — The environment sets the ceiling:
  /// Precondition: RESTMAIL_SERVER_CAPABILITIES is set, so the stored ceiling cannot be changed here.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "server_capabilities_from_environment",
  ///     "message": "the server capability ceiling is set by RESTMAIL_SERVER_CAPABILITIES; change it there and restart, or unset it to manage the ceiling here"
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
  /// **Example** "unknown_capability" — A name outside the capability vocabulary is refused:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "capabilities": "unknown capability \"mail:reed\""
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
  /// Response 500 (application/json):
  /// **Example** "storage_unavailable":
  /// An authenticated human session with a second factor reaches unavailable storage; the account lookup fails, or the server-ceiling transaction cannot start.
  ///
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
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i15.Future<
    _i16.TonikResult<_i31.UpdateServerCapabilitiesResponse, _i18.Response>
  >
  updateServerCapabilities({
    required _i32.UpdateServerCapabilitiesRequest body,
    _i16.TonikCancellation? cancellation,
  }) async => _updateServerCapabilities(body: body, cancellation: cancellation);

  /// The server's limits
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — A superadmin reads the server's limits:
  /// ```json
  /// {
  ///   "data": {
  ///     "contact_import_max_bytes": 10485760
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
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "superadmin_required",
  ///     "message": "only a superadmin can read or change the server's limits"
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
  _i15.Future<_i16.TonikResult<_i33.GetServerLimitsResponse, _i18.Response>>
  getServerLimits({_i16.TonikCancellation? cancellation}) async =>
      _getServerLimits(cancellation: cancellation);

  /// Change the server's limits
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The shared throttle is spent:
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// **Example** "storage_unavailable":
  /// A signed-in administrator with a second factor reaches a server-limits transaction that cannot start; private storage errors are not returned.
  ///
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// **Example** "too_small" — A limit must be at least one byte:
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 0
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// **Example** "updated" — A superadmin changes the contact import limit:
  /// Changing it needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "contact_import_max_bytes": 20971520
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "updated" — A superadmin changes the contact import limit:
  /// Changing it needs a session that signed in with a second factor.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "contact_import_max_bytes": 20971520
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
  /// **Example** "not_superadmin" — An administrator who is not superadmin is refused:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "superadmin_required",
  ///     "message": "only a superadmin can read or change the server's limits"
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
  /// **Example** "too_small" — A limit must be at least one byte:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contact_import_max_bytes": "must be at least 1"
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
  /// Response 500 (application/json):
  /// **Example** "storage_unavailable":
  /// A signed-in administrator with a second factor reaches a server-limits transaction that cannot start; private storage errors are not returned.
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
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i15.Future<_i16.TonikResult<_i34.UpdateServerLimitsResponse, _i18.Response>>
  updateServerLimits({
    required _i35.UpdateServerLimitsRequest body,
    _i16.TonikCancellation? cancellation,
  }) async => _updateServerLimits(body: body, cancellation: cancellation);
}
