// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i6;

import 'package:http/http.dart' as _i9;
import 'package:restmail_generated/src/model/put_sieve_body.dart' as _i11;
import 'package:restmail_generated/src/model/validate_sieve_body.dart' as _i14;
import 'package:restmail_generated/src/operation/delete_sieve_script.dart'
    as _i4;
import 'package:restmail_generated/src/operation/get_sieve_script.dart' as _i2;
import 'package:restmail_generated/src/operation/put_sieve_script.dart' as _i3;
import 'package:restmail_generated/src/operation/validate_sieve_script.dart'
    as _i5;
import 'package:restmail_generated/src/response_wrapper/delete_sieve_script_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/get_sieve_script_response.dart'
    as _i8;
import 'package:restmail_generated/src/response_wrapper/put_sieve_script_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/validate_sieve_script_response.dart'
    as _i13;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i7;

class SieveApi {
  SieveApi(_i1.Server server)
    : _getSieveScript = _i2.GetSieveScript(server.baseUrl, () => server.client),
      _putSieveScript = _i3.PutSieveScript(server.baseUrl, () => server.client),
      _deleteSieveScript = _i4.DeleteSieveScript(
        server.baseUrl,
        () => server.client,
      ),
      _validateSieveScript = _i5.ValidateSieveScript(
        server.baseUrl,
        () => server.client,
      );

  final _i2.GetSieveScript _getSieveScript;

  final _i3.PutSieveScript _putSieveScript;

  final _i4.DeleteSieveScript _deleteSieveScript;

  final _i5.ValidateSieveScript _validateSieveScript;

  /// Get the Sieve filter script
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
  ///     "active": false,
  ///     "mailbox_id": 2,
  ///     "script": ""
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant" — A mail-read grant covering the domain reaches this account:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "id": 101,
  ///     "mailbox_id": 1,
  ///     "script": "require [\"fileinto\"];\nfileinto \"Archive\";\n",
  ///     "script_hash": "be7a2f84b9288b159538f3bd8632a5a7bd34d0a14432a4ba686005867350c9bf",
  ///     "updated_at": "2026-10-20T00:00:00Z",
  ///     "validated_at": "2026-10-20T00:00:00Z"
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
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "id": 101,
  ///     "mailbox_id": 1,
  ///     "script": "require [\"fileinto\"];\nfileinto \"Archive\";\n",
  ///     "script_hash": "be7a2f84b9288b159538f3bd8632a5a7bd34d0a14432a4ba686005867350c9bf",
  ///     "updated_at": "2026-10-20T00:00:00Z",
  ///     "validated_at": "2026-10-20T00:00:00Z"
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
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "id": 101,
  ///     "mailbox_id": 1,
  ///     "script": "require [\"fileinto\"];\nfileinto \"Archive\";\n",
  ///     "script_hash": "be7a2f84b9288b159538f3bd8632a5a7bd34d0a14432a4ba686005867350c9bf",
  ///     "updated_at": "2026-10-20T00:00:00Z",
  ///     "validated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary" — The active primary account has implicit owner capabilities:
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "id": 110,
  ///     "mailbox_id": 10,
  ///     "script": "require [\"fileinto\"];\nfileinto \"Archive\";\n",
  ///     "script_hash": "be7a2f84b9288b159538f3bd8632a5a7bd34d0a14432a4ba686005867350c9bf",
  ///     "updated_at": "2026-10-20T00:00:00Z",
  ///     "validated_at": "2026-10-20T00:00:00Z"
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
  _i6.Future<_i7.TonikResult<_i8.GetSieveScriptResponse, _i9.Response>>
  getSieveScript({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _getSieveScript(id: id, cancellation: cancellation);

  /// Create or replace the Sieve filter script
  /// 201 when it creates the script, 200 when it replaces it. A script that does not parse, or fails its dry run, is 400 invalid_sieve with the parser's message, and is not stored.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "active_false":
  /// ```json
  /// {
  ///   "active": false,
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "active_null":
  /// ```json
  /// {
  ///   "active": null,
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "active_true":
  /// ```json
  /// {
  ///   "active": true,
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "create_unavailable":
  /// ```json
  /// {
  ///   "script": "# create unavailable\nkeep;"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "empty_script":
  /// ```json
  /// {
  ///   "script": ""
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered route, JWT/Basic/scoped-key verification, holder grants and CSRF precede installation. Local SQL asserts exact mailbox selection, script bytes/hash, active defaults and explicit false, persistence-clock markers and lookup/create/update failures. Fixed rows do not prove PostgreSQL durability or delivery execution; PostgreSQL regression cases run when TEST_DATABASE_URL is configured.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_syntax":
  /// ```json
  /// {
  ///   "script": "if"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
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
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is 256 bytes. The test and Vertrag hook send 257 bytes so the real transport guard refuses the request before body parsing.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "script_missing":
  /// ```json
  /// {
  ///   "active": true
  /// }
  /// ```
  ///
  /// **Example** "script_null":
  /// Null is permitted by the published nullable string schema but refused as a missing required value at the runtime boundary. This pair is a schema-valid refusal, not an invalid-schema example.
  ///
  /// ```json
  /// {
  ///   "active": true,
  ///   "script": null
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "update_unavailable":
  /// ```json
  /// {
  ///   "script": "# update unavailable\nkeep;"
  /// }
  /// ```
  ///
  /// **Example** "utf8_script":
  /// ```json
  /// {
  ///   "script": "# café\r\nkeep;"
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "active": true,
  ///   "script": "require [\"fileinto\"];\nif header :contains \"subject\" \"invoice\" {\n  fileinto \"Invoices\";\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_script":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "",
  ///     "script_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered route, JWT/Basic/scoped-key verification, holder grants and CSRF precede installation. Local SQL asserts exact mailbox selection, script bytes/hash, active defaults and explicit false, persistence-clock markers and lookup/create/update failures. Fixed rows do not prove PostgreSQL durability or delivery execution; PostgreSQL regression cases run when TEST_DATABASE_URL is configured.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "require [\"fileinto\"];\nif header :contains \"subject\" \"invoice\" {\n  fileinto \"Invoices\";\n}\n",
  ///     "script_hash": "7091965918f81b8726f2ff1b22731eacb1290c04718b14ee96821456767384b4",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "active_false":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 2,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "active_null":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 2,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "active_true":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 2,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 2,
  ///     "script": "keep;",
  ///     "script_hash": "b417a17598906ccac858842b18641400c875995a9c052e7bda50b4c802456956",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "utf8_script":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "id": 1,
  ///     "mailbox_id": 2,
  ///     "script": "# café\r\nkeep;",
  ///     "script_hash": "94573e8207294aadb4d3e82b98336f4d4ec51d432252284224924422f381e54f",
  ///     "updated_at": "2026-01-01T00:00:00Z",
  ///     "validated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "invalid_syntax":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_sieve",
  ///     "message": "sieve parse error: sieve: line 1: expected a test, got end of script"
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
  /// **Example** "script_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "script_null":
  /// Null is permitted by the published nullable string schema but refused as a missing required value at the runtime boundary. This pair is a schema-valid refusal, not an invalid-schema example.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "required"
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
  ///     "message": "Failed to create script"
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
  ///     "message": "Failed to update script"
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
  _i6.Future<_i7.TonikResult<_i10.PutSieveScriptResponse, _i9.Response>>
  putSieveScript({
    required _i11.PutSieveBody body,
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _putSieveScript(body: body, id: id, cancellation: cancellation);

  /// Delete the Sieve filter script
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Production route/session/credential/holder/CSRF gates precede mailbox-bound deletion or side-effect-free validation. Local SQL proves exact mailbox selection, idempotent zero-row deletion and fault refusal; validation never reads or writes stored scripts. Fixed local rows do not prove PostgreSQL/audit persistence or delivery-time execution.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "deleted"
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
  /// **Example** "key_domain":
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i12.DeleteSieveScriptResponse, _i9.Response>>
  deleteSieveScript({
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async => _deleteSieveScript(id: id, cancellation: cancellation);

  /// Validate a Sieve script without saving
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
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "empty_script":
  /// ```json
  /// {
  ///   "script": ""
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Production route/session/credential/holder/CSRF gates precede mailbox-bound deletion or side-effect-free validation. Local SQL proves exact mailbox selection, idempotent zero-row deletion and fault refusal; validation never reads or writes stored scripts. Fixed local rows do not prove PostgreSQL/audit persistence or delivery-time execution.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body validates; the malformed path value is refused by the real path binder with 422. The invalid-body marker does not describe path binding.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "invalid_syntax":
  /// ```json
  /// {
  ///   "script": "if"
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "script": "keep;"
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
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is 256 bytes. The test and Vertrag hook send 257 bytes so the real transport guard refuses the request before body parsing.
  ///
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "script_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "script_null":
  /// Null is permitted by the published nullable string schema but refused as a missing required value at the runtime boundary. This pair is a schema-valid refusal, not an invalid-schema example.
  ///
  /// ```json
  /// {
  ///   "script": null
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "script": "require [\"fileinto\"];\nif header :contains \"subject\" \"invoice\" {\n  fileinto \"Invoices\";\n}\n"
  /// }
  /// ```
  ///
  /// **Example** "valid_keep":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "script": "keep;"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty_script":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Empty script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Production route/session/credential/holder/CSRF gates precede mailbox-bound deletion or side-effect-free validation. Local SQL proves exact mailbox selection, idempotent zero-row deletion and fault refusal; validation never reads or writes stored scripts. Fixed local rows do not prove PostgreSQL/audit persistence or delivery-time execution.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_syntax":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "sieve parse error: sieve: line 1: expected a test, got end of script",
  ///     "valid": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid_keep":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Script is valid",
  ///     "valid": true
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
  /// **Example** "key_domain":
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
  /// **Example** "script_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "script_null":
  /// Null is permitted by the published nullable string schema but refused as a missing required value at the runtime boundary. This pair is a schema-valid refusal, not an invalid-schema example.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "script": "required"
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i6.Future<_i7.TonikResult<_i13.ValidateSieveScriptResponse, _i9.Response>>
  validateSieveScript({
    required _i14.ValidateSieveBody body,
    required _i6.int id,
    _i7.TonikCancellation? cancellation,
  }) async =>
      _validateSieveScript(body: body, id: id, cancellation: cancellation);
}
