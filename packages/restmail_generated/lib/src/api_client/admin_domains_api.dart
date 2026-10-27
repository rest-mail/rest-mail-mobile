// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:http/http.dart' as _i11;
import 'package:restmail_generated/src/model/create_domain_request.dart'
    as _i13;
import 'package:restmail_generated/src/model/update_domain_body.dart' as _i17;
import 'package:restmail_generated/src/operation/create_domain.dart' as _i3;
import 'package:restmail_generated/src/operation/delete_domain.dart' as _i5;
import 'package:restmail_generated/src/operation/domain_dns_check_operation.dart'
    as _i7;
import 'package:restmail_generated/src/operation/get_domain.dart' as _i4;
import 'package:restmail_generated/src/operation/list_domains.dart' as _i2;
import 'package:restmail_generated/src/operation/update_domain.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/create_domain_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/delete_domain_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/domain_dns_check_operation_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/get_domain_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/list_domains_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/update_domain_response.dart'
    as _i16;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

class AdminDomainsApi {
  AdminDomainsApi(_i1.Server server)
    : _listDomains = _i2.ListDomains(server.baseUrl, () => server.client),
      _createDomain = _i3.CreateDomain(server.baseUrl, () => server.client),
      _getDomain = _i4.GetDomain(server.baseUrl, () => server.client),
      _deleteDomain = _i5.DeleteDomain(server.baseUrl, () => server.client),
      _updateDomain = _i6.UpdateDomain(server.baseUrl, () => server.client),
      _domainDnsCheckOperation = _i7.DomainDnsCheckOperation(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListDomains _listDomains;

  final _i3.CreateDomain _createDomain;

  final _i4.GetDomain _getDomain;

  final _i5.DeleteDomain _deleteDomain;

  final _i6.UpdateDomain _updateDomain;

  final _i7.DomainDnsCheckOperation _domainDnsCheckOperation;

  /// List all domains
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
  _i8.Future<_i9.TonikResult<_i10.ListDomainsResponse, _i11.Response>>
  listDomains({
    _i8.int? limit,
    _i8.int? offset,
    _i9.TonikCancellation? cancellation,
  }) async =>
      _listDomains(limit: limit, offset: offset, cancellation: cancellation);

  /// Create a new domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "active_field":
  /// ```json
  /// {
  ///   "active": true,
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "bulk_policy":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "sending_policy": "bulk",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "canonical_name":
  /// ```json
  /// {
  ///   "name": " EXAMPLE.Org. ",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "default_values":
  /// ```json
  /// {
  ///   "name": "example.org"
  /// }
  /// ```
  ///
  /// **Example** "dmarc_invalid":
  /// ```json
  /// {
  ///   "dmarc_policy": "strict",
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "dmarc_reject":
  /// ```json
  /// {
  ///   "dmarc_policy": "reject",
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "name": "duplicate.test",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "id": 987654,
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "forged_key":
  /// ```json
  /// {
  ///   "dkim_private_key": "injected-key",
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "idna":
  /// ```json
  /// {
  ///   "name": "BÜCHER.Example.",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "inbound_unavailable":
  /// ```json
  /// {
  ///   "name": "inbound-failure.test",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "invalid_name":
  /// ```json
  /// {
  ///   "name": "localhost",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "name_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "name": 1,
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "nested_mailboxes":
  /// ```json
  /// {
  ///   "mailboxes": [
  ///     {
  ///       "address": "injected@example.org"
  ///     }
  ///   ],
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "outbound_unavailable":
  /// ```json
  /// {
  ///   "name": "outbound-failure.test",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "quota_custom":
  /// ```json
  /// {
  ///   "default_quota_bytes": 2048,
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "quota_null":
  /// ```json
  /// {
  ///   "default_quota_bytes": null,
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "quota_zero":
  /// ```json
  /// {
  ///   "default_quota_bytes": 0,
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "sending_policy_invalid":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "sending_policy": "newsletter",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "server_empty":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": ""
  /// }
  /// ```
  ///
  /// **Example** "server_null":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": null
  /// }
  /// ```
  ///
  /// **Example** "server_type_invalid":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "external"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail",
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "name": "write-failure.test",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
  /// ```json
  /// {
  ///   "name": "example.org",
  ///   "server_type": "restmail"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "bulk_policy":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "bulk",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "canonical_name":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "default_values":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dmarc_reject":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "reject",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "idna":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "xn--bcher-kva.example",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_custom":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 2048,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_null":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_zero":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "server_empty":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "server_null":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
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
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
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
  /// Response 409 (application/json):
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Domain already exists"
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
  /// **Example** "active_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "active": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dmarc_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "dmarc_policy": "must be 'none', 'quarantine' or 'reject'"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_key":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "dkim_private_key": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_name":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "Invalid domain name: domain name must be fully-qualified"
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
  /// **Example** "name_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "name": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "nested_mailboxes":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "mailboxes": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sending_policy_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "sending_policy": "must be 'transactional', 'bulk' or empty"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "server_type_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "server_type": "must be 'traditional' or 'restmail'"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "inbound_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "outbound_unavailable":
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
  _i8.Future<_i9.TonikResult<_i12.CreateDomainResponse, _i11.Response>>
  createDomain({
    required _i13.CreateDomainRequest body,
    _i9.TonikCancellation? cancellation,
  }) async => _createDomain(body: body, cancellation: cancellation);

  /// Get a domain by ID
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "domain_scope" — A grant on the source domain permits this lookup:
  /// The production permission query resolves example.com and evaluates the session grants. Domain data is included only when domains:read also permits it.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "restmail",
  ///     "dmarc_policy": "reject",
  ///     "id": 1,
  ///     "name": "example.com",
  ///     "sending_policy": "bulk",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found" — Read the full public resource:
  /// The global capability permits this lookup. Stored fields are mapped by the production handler; the private DKIM key has no public field.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "restmail",
  ///     "dmarc_policy": "reject",
  ///     "id": 1,
  ///     "name": "example.com",
  ///     "sending_policy": "bulk",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inactive" — Inactive resources remain readable to administrators:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "default_quota_bytes": 1073741824,
  ///     "dkim_selector": "restmail",
  ///     "dmarc_policy": "reject",
  ///     "id": 2,
  ///     "name": "inactive.test",
  ///     "sending_policy": "bulk",
  ///     "server_type": "traditional",
  ///     "updated_at": "2026-10-20T00:00:00Z"
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
  /// **Example** "outside_domain" — A grant on another domain cannot read this resource:
  /// The real scope query resolves example.com; a grant restricted to other.test does not reach it.
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
  ///     "code": "domain_not_found",
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
  /// The production lookup encounters a controlled database error. The error writer returns a sanitized response without the dependency detail.
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
  _i8.Future<_i9.TonikResult<_i14.GetDomainResponse, _i11.Response>> getDomain({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _getDomain(id: id, cancellation: cancellation);

  /// Delete a domain
  /// A domain containing accounts or aliases is refused with 409 domain_not_empty. An empty domain and its live pipelines, custom filters, sender rules, certificates, rotation keys, MTA-STS policy, relay credentials and suppressions are removed atomically. Grants on the domain and its mailbox scopes, including eligible activations, are removed through the audited grant-change mechanism; cached permissions are invalidated only after commit. Historical TLS reports, message traces, aggregate reports and audit entries are retained under their original identities and existing retention rules. A cleanup, audit or cancellation failure rolls the deletion back.
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
  /// **Example** "has_accounts":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "domain_not_empty",
  ///     "message": "The domain still has accounts or aliases: delete them first"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "has_aliases":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "domain_not_empty",
  ///     "message": "The domain still has accounts or aliases: delete them first"
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
  /// **Example** "account_count_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "alias_count_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "delete_unavailable":
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
  _i8.Future<_i9.TonikResult<_i15.DeleteDomainResponse, _i11.Response>>
  deleteDomain({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _deleteDomain(id: id, cancellation: cancellation);

  /// Update a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "activate":
  /// ```json
  /// {
  ///   "active": true
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "certificate_missing":
  /// ```json
  /// {
  ///   "active": true
  /// }
  /// ```
  ///
  /// **Example** "certificate_unavailable":
  /// ```json
  /// {
  ///   "active": true
  /// }
  /// ```
  ///
  /// **Example** "clear_sending_policy":
  /// ```json
  /// {
  ///   "sending_policy": ""
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "deactivate":
  /// ```json
  /// {
  ///   "active": false
  /// }
  /// ```
  ///
  /// **Example** "dmarc_invalid":
  /// ```json
  /// {
  ///   "dmarc_policy": "strict",
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "dmarc_quarantine":
  /// ```json
  /// {
  ///   "dmarc_policy": "quarantine"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "id": 987654,
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "forged_key":
  /// ```json
  /// {
  ///   "dkim_private_key": "injected-key",
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "nested_mailboxes":
  /// ```json
  /// {
  ///   "mailboxes": [
  ///     {
  ///       "address": "injected@example.org"
  ///     }
  ///   ],
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "null_fields":
  /// ```json
  /// {
  ///   "active": null,
  ///   "default_quota_bytes": null,
  ///   "dmarc_policy": null,
  ///   "sending_policy": null
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "quota_custom":
  /// ```json
  /// {
  ///   "default_quota_bytes": 2048
  /// }
  /// ```
  ///
  /// **Example** "quota_zero_patch":
  /// ```json
  /// {
  ///   "default_quota_bytes": 0
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "reload_missing":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "reload_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The route and Vertrag transport hook send exactly513 bytes against the configured512-byte cap.
  ///
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "scope_lookup_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "sending_policy_invalid":
  /// ```json
  /// {
  ///   "sending_policy": "newsletter"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "sending_policy": "transactional",
  ///   "surprise": true
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
  /// ```json
  /// {
  ///   "sending_policy": "transactional"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "activate":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "body_boundary":
  /// The readable request is padded with JSON whitespace to exactly512 bytes by the route and Vertrag transport tests.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "clear_sending_policy":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "deactivate":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 2,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dmarc_quarantine":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "quarantine",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_fields":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_custom":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 2048,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_zero_patch":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "default_quota_bytes": 0,
  ///     "dkim_selector": "",
  ///     "dmarc_policy": "none",
  ///     "id": 1,
  ///     "name": "example.org",
  ///     "sending_policy": "transactional",
  ///     "server_type": "restmail",
  ///     "updated_at": "2026-01-01T00:00:00Z"
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
  /// The route and Vertrag transport hook send the raw truncated JSON byte { with application/json content type.
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
  /// **Example** "reload_missing":
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
  /// **Example** "certificate_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "certificate_required",
  ///     "message": "This domain has no currently valid certificate, so it cannot go live. Add one first."
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
  /// **Example** "dmarc_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "dmarc_policy": "must be 'none', 'quarantine' or 'reject'"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "id": "not allowed"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "forged_key":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "dkim_private_key": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
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
  /// **Example** "nested_mailboxes":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "mailboxes": "not allowed"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sending_policy_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "sending_policy": "must be 'transactional', 'bulk' or empty"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "surprise": "not allowed"
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
  /// **Example** "certificate_unavailable":
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
  /// **Example** "reload_unavailable":
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
  _i8.Future<_i9.TonikResult<_i16.UpdateDomainResponse, _i11.Response>>
  updateDomain({
    required _i17.UpdateDomainBody body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _updateDomain(body: body, id: id, cancellation: cancellation);

  /// Live DNS record check (MX, SPF, DMARC, DKIM, MTA-STS, TLS-RPT) for a domain
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — A grant on the source domain permits this lookup:
  /// The production permission query resolves example.com and evaluates the session grants. Domain data is included only when domains:read also permits it.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The complete production response uses real bounded local UDP DNS exchanges for all six records, including the stored signing selector; no external DNS service is consulted.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_stored_name":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "not a domain",
  ///     "records": [
  ///       {
  ///         "message": "The domain name is not a valid DNS name, so its records cannot be checked",
  ///         "name": "not a domain",
  ///         "status": "error",
  ///         "type": "DOMAIN"
  ///       }
  ///     ],
  ///     "summary": "0/1 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_signing_key":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "message": "The domain has no DKIM key, so its mail is not signed",
  ///         "name": "example.com",
  ///         "status": "missing",
  ///         "type": "DKIM"
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "5/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "example.com",
  ///     "records": [
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.example.com. (pri 10)"
  ///       },
  ///       {
  ///         "name": "example.com",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.example.com",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.example.com",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.example.com",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.example.com",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@example.com"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unicode_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "domain": "Bücher.Test",
  ///     "records": [
  ///       {
  ///         "name": "xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "MX",
  ///         "value": "mx.xn--bcher-kva.test. (pri 10)"
  ///       },
  ///       {
  ///         "name": "xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "SPF",
  ///         "value": "v=spf1 mx -all"
  ///       },
  ///       {
  ///         "name": "_dmarc.xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "DMARC",
  ///         "value": "v=DMARC1; p=reject"
  ///       },
  ///       {
  ///         "name": "rm2026._domainkey.xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "DKIM",
  ///         "value": "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWfjK7u4WCd4JfWHGw4RzZC0P0Y="
  ///       },
  ///       {
  ///         "name": "_mta-sts.xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "MTA-STS",
  ///         "value": "v=STSv1; id=fixture"
  ///       },
  ///       {
  ///         "name": "_smtp._tls.xn--bcher-kva.test",
  ///         "status": "ok",
  ///         "type": "TLS-RPT",
  ///         "value": "v=TLSRPTv1; rua=mailto:tls@xn--bcher-kva.test"
  ///       }
  ///     ],
  ///     "summary": "6/6 records verified"
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
  /// **Example** "key_write":
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
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — A grant on another domain cannot read this resource:
  /// The real scope query resolves example.com; a grant restricted to other.test does not reach it.
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
  /// **Example** "invalid_overflow":
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
  /// **Example** "internal_error" — A database fault is not a missing resource:
  /// The production lookup encounters a controlled database error. The error writer returns a sanitized response without the dependency detail.
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
  _i8.Future<
    _i9.TonikResult<_i18.DomainDnsCheckOperationResponse, _i11.Response>
  >
  domainDnsCheckOperation({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _domainDnsCheckOperation(id: id, cancellation: cancellation);
}
