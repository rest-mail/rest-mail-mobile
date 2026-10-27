// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:http/http.dart' as _i8;
import 'package:restmail_generated/src/model/set_vacation_body.dart' as _i10;
import 'package:restmail_generated/src/operation/disable_vacation.dart' as _i4;
import 'package:restmail_generated/src/operation/get_vacation.dart' as _i2;
import 'package:restmail_generated/src/operation/set_vacation.dart' as _i3;
import 'package:restmail_generated/src/response_wrapper/disable_vacation_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/get_vacation_response.dart'
    as _i7;
import 'package:restmail_generated/src/response_wrapper/set_vacation_response.dart'
    as _i9;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i6;

class VacationApi {
  VacationApi(_i1.Server server)
    : _getVacation = _i2.GetVacation(server.baseUrl, () => server.client),
      _setVacation = _i3.SetVacation(server.baseUrl, () => server.client),
      _disableVacation = _i4.DisableVacation(
        server.baseUrl,
        () => server.client,
      );

  final _i2.GetVacation _getVacation;

  final _i3.SetVacation _setVacation;

  final _i4.DisableVacation _disableVacation;

  /// Get vacation auto-reply settings
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "defaults" — A genuinely absent configuration returns its documented defaults:
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "",
  ///     "enabled": false,
  ///     "subject": ""
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant" — A mail-read grant covering the domain reaches this account:
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back on Monday.",
  ///     "enabled": true,
  ///     "end_date": "2026-10-27T00:00:00Z",
  ///     "start_date": "2026-10-20T00:00:00Z",
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found" — A linked account is readable through its mailbox grant:
  /// The real account resolver loads mail:read from the grant tables and maps the full public result. No credential hash or secret is returned.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back on Monday.",
  ///     "enabled": true,
  ///     "end_date": "2026-10-27T00:00:00Z",
  ///     "start_date": "2026-10-20T00:00:00Z",
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — A scoped API key reads the permitted account:
  /// A temporary key passes the production key parser, hash comparison and repository verifier. Both its mail:read mailbox scope and its holder ceiling permit this account.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back on Monday.",
  ///     "enabled": true,
  ///     "end_date": "2026-10-27T00:00:00Z",
  ///     "start_date": "2026-10-20T00:00:00Z",
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary" — The active primary account has implicit owner capabilities:
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back on Monday.",
  ///     "enabled": true,
  ///     "end_date": "2026-10-27T00:00:00Z",
  ///     "start_date": "2026-10-20T00:00:00Z",
  ///     "subject": "Away"
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
  /// **Example** "key_holder_missing" — A valid key cannot exceed its holder's current grants:
  /// The production verifier accepts the scoped key, but the actual grant loader supplies only mail:write for its holder on this account. The old key permission cannot supply the missing mail:read capability.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only" — A valid API key with only mail-write permission cannot read:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope" — A valid API key scoped to another mailbox is refused:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing" — A missing account retains the existing privacy refusal:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "write_only" — A mail-write grant alone does not permit a read:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
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
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Repeated malformed API-key guesses exhaust the real refusal budget:
  /// The test primes a one-token per-peer budget with an invalid key, then repeats it without sleeping. The actual API-key authentication middleware returns 429 and a positive Retry-After.
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
  /// **Example** "content_unavailable" — A failed configuration query cannot silently become defaults:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable" — The account exists but its grant lookup fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — An account lookup fault is not an authorization decision:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable" — Implicit ownership cannot be loaded:
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
  _i5.Future<_i6.TonikResult<_i7.GetVacationResponse, _i8.Response>>
  getVacation({
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _getVacation(id: id, cancellation: cancellation);

  /// Set vacation auto-reply settings
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "body_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "enabled": true,
  ///   "subject": "Out of office"
  /// }
  /// ```
  ///
  /// **Example** "clear_dates":
  /// ```json
  /// {
  ///   "body": "",
  ///   "enabled": false,
  ///   "subject": ""
  /// }
  /// ```
  ///
  /// **Example** "configured":
  /// ```json
  /// {
  ///   "body": "I will reply when I return.",
  ///   "enabled": true,
  ///   "subject": "Out of office"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "create_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "create unavailable"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "dates_equal":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "end_date": "2030-01-01T00:00:00Z",
  ///   "start_date": "2030-01-01T00:00:00Z",
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "dates_null":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "end_date": null,
  ///   "start_date": null,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "dates_offset":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "end_date": "2030-01-02T12:00:00+02:00",
  ///   "start_date": "2030-01-01T12:00:00+02:00",
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "dates_reversed":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "body": "I will reply when I return.",
  ///   "enabled": true,
  ///   "end_date": "2030-01-01T00:00:00Z",
  ///   "start_date": "2030-01-02T00:00:00Z",
  ///   "subject": "Out of office"
  /// }
  /// ```
  ///
  /// **Example** "disabled":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "enabled_false_create":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "enabled_missing":
  /// ```json
  /// {
  ///   "body": "I will reply when I return.",
  ///   "subject": "Out of office"
  /// }
  /// ```
  ///
  /// **Example** "enabled_null":
  /// Nullable enabled is schema-valid but runtime-refused as missing.
  ///
  /// ```json
  /// {
  ///   "body": "I will reply when I return.",
  ///   "enabled": null,
  ///   "subject": "Out of office"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The real registered route, JWT/Basic/scoped-key checks, current holder ceilings and CSRF guards precede mailbox-bound configuration reads and writes. Local SQL verifies selectors, all configuration fields and date clearing; lookup errors do not become creation or success. Fixed rows do not prove PostgreSQL/audit persistence or actual vacation delivery; owner-blocked pipeline migration #772 remains unchanged.
  ///
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
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
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "reply_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is 256 bytes. The test and Vertrag hook send 257 bytes so the real transport guard refuses the request before body parsing.
  ///
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "subject_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "body": "I will reply when I return.",
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "update unavailable"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "body": "Back soon.",
  ///   "enabled": true,
  ///   "subject": "Away"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "clear_dates":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "",
  ///     "enabled": false,
  ///     "subject": ""
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "configured":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "I will reply when I return.",
  ///     "enabled": true,
  ///     "subject": "Out of office"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dates_equal":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "end_date": "2030-01-01T00:00:00Z",
  ///     "start_date": "2030-01-01T00:00:00Z",
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dates_null":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dates_offset":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "end_date": "2030-01-02T12:00:00+02:00",
  ///     "start_date": "2030-01-01T12:00:00+02:00",
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "disabled":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "",
  ///     "enabled": false,
  ///     "subject": ""
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "enabled_false_create":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "",
  ///     "enabled": false,
  ///     "subject": ""
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The real registered route, JWT/Basic/scoped-key checks, current holder ceilings and CSRF guards precede mailbox-bound configuration reads and writes. Local SQL verifies selectors, all configuration fields and date clearing; lookup errors do not become creation or success. Fixed rows do not prove PostgreSQL/audit persistence or actual vacation delivery; owner-blocked pipeline migration #772 remains unchanged.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "body": "Back soon.",
  ///     "enabled": true,
  ///     "subject": "Away"
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
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
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
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is 256 bytes. The test and Vertrag hook send 257 bytes so the real transport guard refuses the request before body parsing.
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
  /// **Example** "body_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "body": "required when enabled"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "dates_reversed":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "end_date": "must be after start_date"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "enabled_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "enabled_null":
  /// Nullable enabled is schema-valid but runtime-refused as missing.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "required"
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
  /// **Example** "reply_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "body": "required when enabled",
  ///         "subject": "required when enabled"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "subject_missing":
  /// The JSON request validates against its published type. Conditional required fields and cross-field date ordering are refused at runtime with the documented 422; the invalid-body marker does not describe these business rules.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "subject": "required when enabled"
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
  /// **Example** "create_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to create vacation config"
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
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to update vacation config"
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
  _i5.Future<_i6.TonikResult<_i9.SetVacationResponse, _i8.Response>>
  setVacation({
    required _i10.SetVacationBody body,
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _setVacation(body: body, id: id, cancellation: cancellation);

  /// Disable vacation auto-reply
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
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
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Access denied"
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
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is 256 bytes. The test and Vertrag hook send 257 bytes so the real transport guard refuses the request before body parsing.
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
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to disable vacation config"
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
  _i5.Future<_i6.TonikResult<_i11.DisableVacationResponse, _i8.Response>>
  disableVacation({
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _disableVacation(id: id, cancellation: cancellation);
}
