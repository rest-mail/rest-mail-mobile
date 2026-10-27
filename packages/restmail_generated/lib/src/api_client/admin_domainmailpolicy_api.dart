// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i16;

import 'package:http/http.dart' as _i19;
import 'package:restmail_generated/src/model/add_sender_rule_request.dart'
    as _i21;
import 'package:restmail_generated/src/model/api_v1_admin_tls_reports_parameters_model.dart'
    as _i36;
import 'package:restmail_generated/src/model/set_mtasts_body.dart' as _i28;
import 'package:restmail_generated/src/model/set_relay_body.dart' as _i32;
import 'package:restmail_generated/src/operation/add_to_allowlist.dart' as _i3;
import 'package:restmail_generated/src/operation/add_to_blocklist.dart' as _i6;
import 'package:restmail_generated/src/operation/clear_suppression.dart'
    as _i14;
import 'package:restmail_generated/src/operation/delete_mta_sts_policy.dart'
    as _i10;
import 'package:restmail_generated/src/operation/get_domain_relay.dart' as _i11;
import 'package:restmail_generated/src/operation/get_mta_sts_policy.dart'
    as _i8;
import 'package:restmail_generated/src/operation/list_allowlist.dart' as _i2;
import 'package:restmail_generated/src/operation/list_blocklist.dart' as _i5;
import 'package:restmail_generated/src/operation/list_suppressions.dart'
    as _i13;
import 'package:restmail_generated/src/operation/list_tls_reports.dart' as _i15;
import 'package:restmail_generated/src/operation/remove_from_allowlist.dart'
    as _i4;
import 'package:restmail_generated/src/operation/remove_from_blocklist.dart'
    as _i7;
import 'package:restmail_generated/src/operation/set_domain_relay.dart' as _i12;
import 'package:restmail_generated/src/operation/set_mta_sts_policy.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/add_to_allowlist_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/add_to_blocklist_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/clear_suppression_response.dart'
    as _i34;
import 'package:restmail_generated/src/response_wrapper/delete_mta_sts_policy_response.dart'
    as _i29;
import 'package:restmail_generated/src/response_wrapper/get_domain_relay_response.dart'
    as _i30;
import 'package:restmail_generated/src/response_wrapper/get_mta_sts_policy_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/list_allowlist_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/list_blocklist_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/list_suppressions_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/list_tls_reports_response.dart'
    as _i35;
import 'package:restmail_generated/src/response_wrapper/remove_from_allowlist_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/remove_from_blocklist_response.dart'
    as _i25;
import 'package:restmail_generated/src/response_wrapper/set_domain_relay_response.dart'
    as _i31;
import 'package:restmail_generated/src/response_wrapper/set_mta_sts_policy_response.dart'
    as _i27;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i17;

class AdminDomainmailpolicyApi {
  AdminDomainmailpolicyApi(_i1.Server server)
    : _listAllowlist = _i2.ListAllowlist(server.baseUrl, () => server.client),
      _addToAllowlist = _i3.AddToAllowlist(server.baseUrl, () => server.client),
      _removeFromAllowlist = _i4.RemoveFromAllowlist(
        server.baseUrl,
        () => server.client,
      ),
      _listBlocklist = _i5.ListBlocklist(server.baseUrl, () => server.client),
      _addToBlocklist = _i6.AddToBlocklist(server.baseUrl, () => server.client),
      _removeFromBlocklist = _i7.RemoveFromBlocklist(
        server.baseUrl,
        () => server.client,
      ),
      _getMtaStsPolicy = _i8.GetMtaStsPolicy(
        server.baseUrl,
        () => server.client,
      ),
      _setMtaStsPolicy = _i9.SetMtaStsPolicy(
        server.baseUrl,
        () => server.client,
      ),
      _deleteMtaStsPolicy = _i10.DeleteMtaStsPolicy(
        server.baseUrl,
        () => server.client,
      ),
      _getDomainRelay = _i11.GetDomainRelay(
        server.baseUrl,
        () => server.client,
      ),
      _setDomainRelay = _i12.SetDomainRelay(
        server.baseUrl,
        () => server.client,
      ),
      _listSuppressions = _i13.ListSuppressions(
        server.baseUrl,
        () => server.client,
      ),
      _clearSuppression = _i14.ClearSuppression(
        server.baseUrl,
        () => server.client,
      ),
      _listTlsReports = _i15.ListTlsReports(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListAllowlist _listAllowlist;

  final _i3.AddToAllowlist _addToAllowlist;

  final _i4.RemoveFromAllowlist _removeFromAllowlist;

  final _i5.ListBlocklist _listBlocklist;

  final _i6.AddToBlocklist _addToBlocklist;

  final _i7.RemoveFromBlocklist _removeFromBlocklist;

  final _i8.GetMtaStsPolicy _getMtaStsPolicy;

  final _i9.SetMtaStsPolicy _setMtaStsPolicy;

  final _i10.DeleteMtaStsPolicy _deleteMtaStsPolicy;

  final _i11.GetDomainRelay _getDomainRelay;

  final _i12.SetDomainRelay _setDomainRelay;

  final _i13.ListSuppressions _listSuppressions;

  final _i14.ClearSuppression _clearSuppression;

  final _i15.ListTlsReports _listTlsReports;

  /// List allowlist entries for a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The caller can read this domain:
  /// The real domain-scope lookup resolves domain1 to example.com. The session holds only domains:read at domain:example.com; the actual handler reads an empty list restricted to domain1.
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list allowlist rules"
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
  _i16.Future<_i17.TonikResult<_i18.ListAllowlistResponse, _i19.Response>>
  listAllowlist({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _listAllowlist(id: id, cancellation: cancellation);

  /// Add an allowlist entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "already_exists":
  /// The SQL driver returns PostgreSQL23505. GORM and the production repository conflict mapping produce409, without exposing database details.
  ///
  /// ```json
  /// {
  ///   "pattern": "already@example.net",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "created":
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "created_without_reason" — An omitted reason stays omitted in the response:
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com"
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant only for other.test is refused by the real domain-scope middleware.
  ///
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "pattern_missing":
  /// ```json
  /// {
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte fixture cap; the production transport limiter refuses it before insertion.
  ///
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "pattern": "saving@example.net",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "translated_conflict":
  /// A wrapped GORM duplicate-key error follows the same409 mapping as a PostgreSQL23505.
  ///
  /// ```json
  /// {
  ///   "pattern": "translated@example.net",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No session credential was sent:
  /// ```json
  /// {
  ///   "pattern": "@partner.example.com",
  ///   "reason": "A trusted partner"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "list_type": "allow",
  ///     "pattern": "@partner.example.com",
  ///     "reason": "A trusted partner"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created_without_reason" — An omitted reason stays omitted in the response:
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "list_type": "allow",
  ///     "pattern": "@partner.example.com"
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
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant only for other.test is refused by the real domain-scope middleware.
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
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "domain_not_found",
  ///     "message": "Domain not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "already_exists":
  /// The SQL driver returns PostgreSQL23505. GORM and the production repository conflict mapping produce409, without exposing database details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Sender is already on the allowlist"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "translated_conflict":
  /// A wrapped GORM duplicate-key error follows the same409 mapping as a PostgreSQL23505.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Sender is already on the allowlist"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte fixture cap; the production transport limiter refuses it before insertion.
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
  /// **Example** "pattern_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "pattern": "required"
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
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to create allowlist rule"
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
  _i16.Future<_i17.TonikResult<_i20.AddToAllowlistResponse, _i19.Response>>
  addToAllowlist({
    required _i21.AddSenderRuleRequest body,
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _addToAllowlist(body: body, id: id, cancellation: cancellation);

  /// Remove an allowlist entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant on other.test does not permit changing domain1, whose real scope is example.com.
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
  /// **Example** "missing" — No policy belongs to the requested domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Allowlist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "opposite_list" — An entry on the opposite list is not found:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Allowlist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_domain" — An entry owned by another domain is not found:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Allowlist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A nine-byte transport body exceeds the eight-byte fixture cap. The production limiter refuses the request; the focused replay sends actual bytes.
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
  /// **Example** "invalid_entry" — The entry ID cannot bind to an integer:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "eid": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "delete_unavailable" — Persistence fails while deleting the scoped entry:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete allowlist rule"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — The domain-policy query fails:
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
  _i16.Future<_i17.TonikResult<_i22.RemoveFromAllowlistResponse, _i19.Response>>
  removeFromAllowlist({
    required _i16.int id,
    required _i16.int eid,
    _i17.TonikCancellation? cancellation,
  }) async =>
      _removeFromAllowlist(id: id, eid: eid, cancellation: cancellation);

  /// List blocklist entries for a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The caller can read this domain:
  /// The real domain-scope lookup resolves domain1 to example.com. The session holds only domains:read at domain:example.com; the actual handler reads an empty list restricted to domain1.
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list blocklist rules"
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
  _i16.Future<_i17.TonikResult<_i23.ListBlocklistResponse, _i19.Response>>
  listBlocklist({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _listBlocklist(id: id, cancellation: cancellation);

  /// Add a blocklist entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "already_exists":
  /// The SQL driver returns PostgreSQL23505. GORM and the production repository conflict mapping produce409, without exposing database details.
  ///
  /// ```json
  /// {
  ///   "pattern": "already@example.net",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "created":
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "created_without_reason" — An omitted reason stays omitted in the response:
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com"
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant only for other.test is refused by the real domain-scope middleware.
  ///
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "pattern_missing":
  /// ```json
  /// {
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte fixture cap; the production transport limiter refuses it before insertion.
  ///
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "pattern": "saving@example.net",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "translated_conflict":
  /// A wrapped GORM duplicate-key error follows the same409 mapping as a PostgreSQL23505.
  ///
  /// ```json
  /// {
  ///   "pattern": "translated@example.net",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No session credential was sent:
  /// ```json
  /// {
  ///   "pattern": "spam@spammer.example.com",
  ///   "reason": "Sends spam"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "list_type": "block",
  ///     "pattern": "spam@spammer.example.com",
  ///     "reason": "Sends spam"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created_without_reason" — An omitted reason stays omitted in the response:
  /// A domains:write grant for example.com permits creation. The real handler inserts the exact domain, list type, pattern and reason using GORM; its returned ID and timestamp are serialized.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "list_type": "block",
  ///     "pattern": "spam@spammer.example.com"
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
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant only for other.test is refused by the real domain-scope middleware.
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
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "domain_not_found",
  ///     "message": "Domain not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "already_exists":
  /// The SQL driver returns PostgreSQL23505. GORM and the production repository conflict mapping produce409, without exposing database details.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Sender is already on the blocklist"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "translated_conflict":
  /// A wrapped GORM duplicate-key error follows the same409 mapping as a PostgreSQL23505.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Sender is already on the blocklist"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte fixture cap; the production transport limiter refuses it before insertion.
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
  /// **Example** "pattern_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "pattern": "required"
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
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to create blocklist rule"
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
  _i16.Future<_i17.TonikResult<_i24.AddToBlocklistResponse, _i19.Response>>
  addToBlocklist({
    required _i21.AddSenderRuleRequest body,
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _addToBlocklist(body: body, id: id, cancellation: cancellation);

  /// Remove a blocklist entry
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant on other.test does not permit changing domain1, whose real scope is example.com.
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
  /// **Example** "missing" — No policy belongs to the requested domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Blocklist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "opposite_list" — An entry on the opposite list is not found:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Blocklist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_domain" — An entry owned by another domain is not found:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Blocklist rule not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A nine-byte transport body exceeds the eight-byte fixture cap. The production limiter refuses the request; the focused replay sends actual bytes.
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
  /// **Example** "invalid_entry" — The entry ID cannot bind to an integer:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "eid": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "delete_unavailable" — Persistence fails while deleting the scoped entry:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete blocklist rule"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — The domain-policy query fails:
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
  _i16.Future<_i17.TonikResult<_i25.RemoveFromBlocklistResponse, _i19.Response>>
  removeFromBlocklist({
    required _i16.int id,
    required _i16.int eid,
    _i17.TonikCancellation? cancellation,
  }) async =>
      _removeFromBlocklist(id: id, eid: eid, cancellation: cancellation);

  /// Get the MTA-STS policy for a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — The permitted domain policy operation succeeds:
  /// The session holds the required capability at domain:example.com. The real target lookup resolves domain1 and the handler maps stored settings or executes the policy deletion inside GORM transaction callbacks.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 7,
  ///     "max_age": 604800,
  ///     "mode": "testing",
  ///     "mx_hosts": "mail.example.com",
  ///     "updated_at": "2026-10-20T00:00:00Z"
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "policy_absent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No MTA-STS policy found for this domain"
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// A dependency failure is preserved as a sanitized500, rather than mistaken for an absent domain or policy. The real handler and error writer execute against a controlled database fault.
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
  /// **Example** "settings_unavailable" — The domain exists but its settings query fails:
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
  _i16.Future<_i17.TonikResult<_i26.GetMtaStsPolicyResponse, _i19.Response>>
  getMtaStsPolicy({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _getMtaStsPolicy(id: id, cancellation: cancellation);

  /// Create or update the MTA-STS policy for a domain
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
  /// **Example** "created" — Create preserving explicit zero/false:
  /// ```json
  /// {
  ///   "active": false,
  ///   "max_age": 0,
  ///   "mode": "enforce",
  ///   "mx_hosts": "mail.direct.test"
  /// }
  /// ```
  ///
  /// **Example** "created_defaults" — Omitted fields use policy defaults:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "max_age_negative":
  /// ```json
  /// {
  ///   "active": true,
  ///   "max_age": -1,
  ///   "mode": "testing",
  ///   "mx_hosts": "mail.example.org"
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "mode_invalid":
  /// ```json
  /// {
  ///   "active": true,
  ///   "max_age": 86400,
  ///   "mode": "strict",
  ///   "mx_hosts": "mail.example.org"
  /// }
  /// ```
  ///
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A current session holding domains:write only for other.test is refused by production permission middleware.
  ///
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "policy":
  /// ```json
  /// {
  ///   "active": true,
  ///   "max_age": 86400,
  ///   "mode": "testing",
  ///   "mx_hosts": "mail.example.org"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte test cap. The production body limiter refuses it before policy writes.
  ///
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "settings_unavailable":
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No session credential was sent:
  /// ```json
  /// {
  ///   "mode": "testing"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "policy":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 7,
  ///     "max_age": 86400,
  ///     "mode": "testing",
  ///     "mx_hosts": "mail.example.org",
  ///     "updated_at": "2026-10-25T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created" — Create preserving explicit zero/false:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-10-25T00:00:00Z",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 2,
  ///       "name": "direct.test",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 2,
  ///     "id": 8,
  ///     "max_age": 0,
  ///     "mode": "enforce",
  ///     "mx_hosts": "mail.direct.test",
  ///     "updated_at": "2026-10-25T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created_defaults" — Omitted fields use policy defaults:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-25T00:00:00Z",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 2,
  ///       "name": "direct.test",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 2,
  ///     "id": 8,
  ///     "max_age": 604800,
  ///     "mode": "testing",
  ///     "mx_hosts": "",
  ///     "updated_at": "2026-10-25T00:00:00Z"
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
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A current session holding domains:write only for other.test is refused by production permission middleware.
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
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte test cap. The production body limiter refuses it before policy writes.
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
  /// **Example** "max_age_negative":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "max_age": "Must be a non-negative integer (seconds)"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mode_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "mode": "Must be one of: none, testing, enforce"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to save MTA-STS policy"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "settings_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to save MTA-STS policy"
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
  _i16.Future<_i17.TonikResult<_i27.SetMtaStsPolicyResponse, _i19.Response>>
  setMtaStsPolicy({
    required _i28.SetMtastsBody body,
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _setMtaStsPolicy(body: body, id: id, cancellation: cancellation);

  /// Delete the MTA-STS policy for a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "missing" — No policy belongs to the requested domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No MTA-STS policy found for this domain"
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// A dependency failure is preserved as a sanitized500, rather than mistaken for an absent domain or policy. The real handler and error writer execute against a controlled database fault.
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
  _i16.Future<_i17.TonikResult<_i29.DeleteMtaStsPolicyResponse, _i19.Response>>
  deleteMtaStsPolicy({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _deleteMtaStsPolicy(id: id, cancellation: cancellation);

  /// Get the domain’s outbound transport
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "direct" — No configured relay uses direct delivery:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 2,
  ///     "password_set": false,
  ///     "transport": "direct"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found" — The permitted domain policy operation succeeds:
  /// The session holds the required capability at domain:example.com. The real target lookup resolves domain1 and the handler maps stored settings or executes the policy deletion inside GORM transaction callbacks.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "host": "smtp.example.net",
  ///     "password_set": true,
  ///     "port": 587,
  ///     "tls_mode": "starttls",
  ///     "transport": "relay",
  ///     "username": "apikey"
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// A dependency failure is preserved as a sanitized500, rather than mistaken for an absent domain or policy. The real handler and error writer execute against a controlled database fault.
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
  /// **Example** "settings_unavailable" — The domain exists but its settings query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to load the relay settings"
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
  _i16.Future<_i17.TonikResult<_i30.GetDomainRelayResponse, _i19.Response>>
  getDomainRelay({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _getDomainRelay(id: id, cancellation: cancellation);

  /// Set the domain’s outbound transport
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
  /// **Example** "credentials_mismatch":
  /// The body satisfies its field schema. The handler refuses the credential relationship or bare-host rule with422.
  ///
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "",
  ///   "port": 587,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "credentials_retained" — Omitting the password preserves the stored credential:
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "port": 587,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "direct" — Deliver straight to each recipient's MX:
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "host_invalid":
  /// The body satisfies its field schema. The handler refuses the credential relationship or bare-host rule with422.
  ///
  /// ```json
  /// {
  ///   "host": "smtp://smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": 587,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "master_key_required" — A new relay credential requires the server master key:
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": 587,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A current session holding domains:write only for other.test is refused by production permission middleware.
  ///
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "port_invalid":
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": 65536,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "port_wrong_type":
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": "587",
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "relay" — Send through an authenticated relay:
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": 587,
  ///   "tls_mode": "starttls",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte test cap. The production body limiter refuses it before policy writes.
  ///
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "settings_unavailable":
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// **Example** "tls_mode_invalid":
  /// ```json
  /// {
  ///   "host": "smtp.example.net",
  ///   "password": "relay-password",
  ///   "port": 587,
  ///   "tls_mode": "none",
  ///   "transport": "relay",
  ///   "username": "apikey"
  /// }
  /// ```
  ///
  /// **Example** "transport_invalid":
  /// ```json
  /// {
  ///   "transport": "smtp"
  /// }
  /// ```
  ///
  /// **Example** "transport_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated" — No session credential was sent:
  /// ```json
  /// {
  ///   "transport": "direct"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "credentials_retained" — Omitting the password preserves the stored credential:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "host": "smtp.example.net",
  ///     "password_set": true,
  ///     "port": 587,
  ///     "tls_mode": "starttls",
  ///     "transport": "relay",
  ///     "username": "apikey"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "direct" — Deliver straight to each recipient's MX:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "password_set": false,
  ///     "transport": "direct"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "relay" — Send through an authenticated relay:
  /// ```json
  /// {
  ///   "data": {
  ///     "domain_id": 1,
  ///     "host": "smtp.example.net",
  ///     "password_set": true,
  ///     "port": 587,
  ///     "tls_mode": "starttls",
  ///     "transport": "relay",
  ///     "username": "apikey"
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
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A current session holding domains:write only for other.test is refused by production permission middleware.
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
  /// Response 409 (application/json):
  /// **Example** "master_key_required" — A new relay credential requires the server master key:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "master_key_required",
  ///     "message": "A relay password can only be stored when the server has a MASTER_KEY"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// The published JSON body exceeds the eight-byte test cap. The production body limiter refuses it before policy writes.
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
  /// **Example** "credentials_mismatch":
  /// The body satisfies its field schema. The handler refuses the credential relationship or bare-host rule with422.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "password": "A username and a password are set together, or neither"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "host_invalid":
  /// The body satisfies its field schema. The handler refuses the credential relationship or bare-host rule with422.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "host": "Must be a bare host name or IP address, with no scheme, port or path"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "port_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "port": "Must be between 1 and 65535"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "port_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "port": "must be an integer"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "tls_mode_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "tls_mode": "Must be one of: starttls, implicit"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "transport_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "transport": "Must be one of: direct, relay"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "transport_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "transport": "Must be one of: direct, relay"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "save_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to save the relay settings"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "settings_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to load the relay settings"
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
  _i16.Future<_i17.TonikResult<_i31.SetDomainRelayResponse, _i19.Response>>
  setDomainRelay({
    required _i32.SetRelayBody body,
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _setDomainRelay(body: body, id: id, cancellation: cancellation);

  /// List a domain’s suppressed recipients
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The caller can read this domain:
  /// The real domain-scope lookup resolves domain1 to example.com. The session holds only domains:read at domain:example.com; the actual handler reads an empty list restricted to domain1.
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// The setup-complete session holds domains:read only at domain:other.test. The real scope lookup resolves the requested domain1 to example.com, so permission middleware refuses access before listing data.
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
  /// **Example** "invalid_domain" — The domain ID cannot bind to an integer:
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list suppressions"
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
  _i16.Future<_i17.TonikResult<_i33.ListSuppressionsResponse, _i19.Response>>
  listSuppressions({
    required _i16.int id,
    _i17.TonikCancellation? cancellation,
  }) async => _listSuppressions(id: id, cancellation: cancellation);

  /// Clear a suppression
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
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
  /// **Example** "outside_domain" — A grant on another domain is refused:
  /// A domains:write grant on other.test does not permit changing domain1, whose real scope is example.com.
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
  /// **Example** "missing" — No policy belongs to the requested domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Suppression not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_domain" — An entry owned by another domain is not found:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Suppression not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// A nine-byte transport body exceeds the eight-byte fixture cap. The production limiter refuses the request; the focused replay sends actual bytes.
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
  /// **Example** "invalid_entry" — The entry ID cannot bind to an integer:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "sid": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "delete_unavailable" — Persistence fails while deleting the scoped entry:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to clear suppression"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — The domain-policy query fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to clear suppression"
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
  _i16.Future<_i17.TonikResult<_i34.ClearSuppressionResponse, _i19.Response>>
  clearSuppression({
    required _i16.int id,
    required _i16.int sid,
    _i17.TonikCancellation? cancellation,
  }) async => _clearSuppression(id: id, sid: sid, cancellation: cancellation);

  /// List received TLS-RPT reports
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
  _i16.Future<_i17.TonikResult<_i35.ListTlsReportsResponse, _i19.Response>>
  listTlsReports({
    _i16.int? domainId,
    _i16.int? limit,
    _i16.int? offset,
    _i36.ApiV1AdminTlsReportsParametersModel? policyType,
    _i16.String? reportingOrg,
    _i17.TonikCancellation? cancellation,
  }) async => _listTlsReports(
    domainId: domainId,
    limit: limit,
    offset: offset,
    policyType: policyType,
    reportingOrg: reportingOrg,
    cancellation: cancellation,
  );
}
