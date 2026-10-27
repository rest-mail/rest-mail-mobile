// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:http/http.dart' as _i9;
import 'package:restmail_generated/src/model/create_certificate_request.dart'
    as _i11;
import 'package:restmail_generated/src/operation/create_certificate.dart'
    as _i3;
import 'package:restmail_generated/src/operation/delete_certificate.dart'
    as _i5;
import 'package:restmail_generated/src/operation/get_certificate.dart' as _i4;
import 'package:restmail_generated/src/operation/list_certificates.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/create_certificate_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/delete_certificate_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/get_certificate_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/list_certificates_response.dart'
    as _i8;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

class AdminCertificatesApi {
  AdminCertificatesApi(_i1.Server server)
    : _listCertificates = _i2.ListCertificates(
        server.baseUrl,
        () => server.client,
      ),
      _createCertificate = _i3.CreateCertificate(
        server.baseUrl,
        () => server.client,
      ),
      _getCertificate = _i4.GetCertificate(server.baseUrl, () => server.client),
      _deleteCertificate = _i5.DeleteCertificate(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListCertificates _listCertificates;

  final _i3.CreateCertificate _createCertificate;

  final _i4.GetCertificate _getCertificate;

  final _i5.DeleteCertificate _deleteCertificate;

  /// List TLS certificates
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
  _i6.Future<_i7.TonikResult<_i8.ListCertificatesResponse, _i9.Response>>
  listCertificates({
    _i6.int? limit,
    _i6.int? offset,
    _i7.TonikCancellation? cancellation,
  }) async => _listCertificates(
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Upload a new TLS certificate
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "association_unavailable" — Association unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 7,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "auto_renew_null" — Auto renew null:
  /// ```json
  /// {
  ///   "auto_renew": null,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "auto_renew_true" — Auto renew true:
  /// ```json
  /// {
  ///   "auto_renew": true,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "auto_renew_wrong_type" — Auto renew wrong type:
  /// ```json
  /// {
  ///   "auto_renew": "false",
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "cert_empty" — Cert empty:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "cert_invalid" — Cert invalid:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "not PEM",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "default_renew" — Default renew:
  /// ```json
  /// {
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "domain_wrong_type" — Domain wrong type:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": "bad",
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "domain_zero" — Domain zero:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 0,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "fields_missing" — Required certificate fields are missing:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "insert_unavailable" — Insert unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 4,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "invalid_body" — An array cannot decode as a certificate request:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "key_empty" — Key empty:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": ""
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 3,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "missing" — Missing:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 2147483647,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Rate limited:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "reload_missing" — Reload missing:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 6,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "reload_unavailable" — Reload unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 5,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — Request too large:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unauthenticated:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "valid" — The hook supplies a fresh certificate and the created domain:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
  /// ```json
  /// {
  ///   "auto_renew": false,
  ///   "cert_pem": "certificate",
  ///   "domain_id": 1,
  ///   "key_pem": "key"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "auto_renew_null" — Auto renew null:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "auto_renew_true" — Auto renew true:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "body_boundary" — Body boundary:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — Cookie session:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "default_renew" — Default renew:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write" — Key write:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid" — The hook supplies a fresh certificate and the created domain:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only" — Write only:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "domain": {
  ///       "active": false,
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "contract.example.org",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "issuer": "CN=contract.example.org",
  ///     "not_after": "2026-01-31T00:00:00Z",
  ///     "not_before": "2026-01-01T00:00:00Z",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "invalid_body" — An array cannot decode as a certificate request:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — Malformed json:
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
  /// **Example** "unauthenticated" — Unauthenticated:
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
  /// **Example** "csrf_mismatch" — Csrf mismatch:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing" — Csrf missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope" — Domain scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain" — Key domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — Key holder missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_mailbox" — Key mailbox:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — Key read:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain" — Key wrong domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope" — Mailbox scope:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only" — Read only:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain" — Wrong domain:
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
  /// **Example** "missing" — Missing:
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
  /// **Example** "request_too_large" — Request too large:
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
  /// **Example** "auto_renew_wrong_type" — Auto renew wrong type:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "auto_renew": "must be a boolean"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cert_empty" — Cert empty:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cert_pem": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cert_invalid" — Cert invalid:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cert_pem": "Invalid certificate PEM"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_wrong_type" — Domain wrong type:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain_id": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_zero" — Domain zero:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "domain_id": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "fields_missing" — Required certificate fields are missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cert_pem": "required",
  ///         "domain_id": "required",
  ///         "key_pem": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_empty" — Key empty:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "key_pem": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Rate limited:
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
  /// **Example** "association_unavailable" — Association unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cancelled_after_lookup" — Cancelled after lookup:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "insert_unavailable" — Insert unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable" — Lookup unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "reload_missing" — Reload missing:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "reload_unavailable" — Reload unavailable:
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
  /// **Example** "permission_store_unavailable" — Permission store unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — Session unavailable:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i10.CreateCertificateResponse, _i9.Response>>
  createCertificate({
    required _i11.CreateCertificateRequest body,
    _i7.TonikCancellation? cancellation,
  }) async => _createCertificate(body: body, cancellation: cancellation);

  /// Get certificate details (includes cert_pem)
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "disabled" — Disabled configuration remains readable to administrators:
  /// ```json
  /// {
  ///   "data": {
  ///     "auto_renew": false,
  ///     "cert_pem": "-----BEGIN CERTIFICATE-----\npublic-fixture\n-----END CERTIFICATE-----\n",
  ///     "created_at": "2026-10-20T00:00:00Z",
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
  ///     "id": 2,
  ///     "issuer": "Fixture CA",
  ///     "not_after": "2027-10-20T00:00:00Z",
  ///     "not_before": "2026-10-20T00:00:00Z",
  ///     "updated_at": "2026-10-20T00:00:00Z"
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
  ///     "auto_renew": true,
  ///     "cert_pem": "-----BEGIN CERTIFICATE-----\npublic-fixture\n-----END CERTIFICATE-----\n",
  ///     "created_at": "2026-10-20T00:00:00Z",
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
  ///     "issuer": "Fixture CA",
  ///     "not_after": "2027-10-20T00:00:00Z",
  ///     "not_before": "2026-10-20T00:00:00Z",
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
  /// **Example** "domain_scope" — A domain-scoped grant cannot read an installation-wide resource:
  /// The current installation-wide permission ceiling is preserved. A grant on example.com does not satisfy read access at *.
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
  /// **Example** "missing" — The requested certificate does not exist:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Certificate not found"
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
  /// **Example** "domain_unavailable" — The certificate exists but its domain preload fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get certificate"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a missing resource:
  /// A controlled dependency error exercises the real GORM lookup. The production error writer omits internal fault detail.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get certificate"
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
  _i6.Future<_i7.TonikResult<_i12.GetCertificateResponse, _i9.Response>>
  getCertificate({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _getCertificate(id: id, cancellation: cancellation);

  /// Delete a certificate
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Certificate not found"
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
  _i6.Future<_i7.TonikResult<_i13.DeleteCertificateResponse, _i9.Response>>
  deleteCertificate({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _deleteCertificate(id: id, cancellation: cancellation);
}
