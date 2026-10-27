// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:http/http.dart' as _i11;
import 'package:restmail_generated/src/model/create_account_request.dart'
    as _i13;
import 'package:restmail_generated/src/model/link_account_request.dart' as _i15;
import 'package:restmail_generated/src/operation/create_account.dart' as _i3;
import 'package:restmail_generated/src/operation/get_account.dart' as _i5;
import 'package:restmail_generated/src/operation/get_quota.dart' as _i7;
import 'package:restmail_generated/src/operation/link_account.dart' as _i4;
import 'package:restmail_generated/src/operation/list_accounts.dart' as _i2;
import 'package:restmail_generated/src/operation/unlink_account.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/create_account_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/get_account_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/get_quota_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/link_account_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/list_accounts_response.dart'
    as _i10;
import 'package:restmail_generated/src/response_wrapper/unlink_account_response.dart'
    as _i17;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

class AccountsApi {
  AccountsApi(_i1.Server server)
    : _listAccounts = _i2.ListAccounts(server.baseUrl, () => server.client),
      _createAccount = _i3.CreateAccount(server.baseUrl, () => server.client),
      _linkAccount = _i4.LinkAccount(server.baseUrl, () => server.client),
      _getAccount = _i5.GetAccount(server.baseUrl, () => server.client),
      _unlinkAccount = _i6.UnlinkAccount(server.baseUrl, () => server.client),
      _getQuota = _i7.GetQuota(server.baseUrl, () => server.client);

  final _i2.ListAccounts _listAccounts;

  final _i3.CreateAccount _createAccount;

  final _i4.LinkAccount _linkAccount;

  final _i5.GetAccount _getAccount;

  final _i6.UnlinkAccount _unlinkAccount;

  final _i7.GetQuota _getQuota;

  /// List the accounts this one reaches
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password" — An actual HTTP Basic app password lists only its own account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — The same production route accepts the session cookie:
  /// The SQL boundary requires active unexpired mailbox-scoped mail grants, a holder restriction, distinct mailboxes, exclusion of the primary account and address ordering. Controlled rows prove mapping and wiring; PostgreSQL filtering and ordering semantics are not claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
  ///     },
  ///     {
  ///       "address": "empty@example.com",
  ///       "display_name": "Empty",
  ///       "id": 2,
  ///       "is_primary": false
  ///     },
  ///     {
  ///       "address": "linked@example.com",
  ///       "display_name": "Linked café",
  ///       "id": 1,
  ///       "is_primary": false
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_manager" — Domain administration does not list every domain mailbox as a linked account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "found" — The primary account is first, followed by linked accounts in address order:
  /// The SQL boundary requires active unexpired mailbox-scoped mail grants, a holder restriction, distinct mailboxes, exclusion of the primary account and address ordering. Controlled rows prove mapping and wiring; PostgreSQL filtering and ordering semantics are not claimed.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
  ///     },
  ///     {
  ///       "address": "empty@example.com",
  ///       "display_name": "Empty",
  ///       "id": 2,
  ///       "is_primary": false
  ///     },
  ///     {
  ///       "address": "linked@example.com",
  ///       "display_name": "Linked café",
  ///       "id": 1,
  ///       "is_primary": false
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
  ///     },
  ///     {
  ///       "address": "empty@example.com",
  ///       "display_name": "Empty",
  ///       "id": 2,
  ///       "is_primary": false
  ///     },
  ///     {
  ///       "address": "linked@example.com",
  ///       "display_name": "Linked café",
  ///       "id": 1,
  ///       "is_primary": false
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing" — A key cannot restore read permission absent from its holder:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// An ephemeral key passes the real parser, secret hash verification and repository verifier. Both the key scope and its holder must permit mail:read; the primary account is omitted when the key does not cover it.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "linked@example.com",
  ///       "display_name": "Linked café",
  ///       "id": 1,
  ///       "is_primary": false
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "no_grants" — A session without linked grants still sees its primary account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "address": "user@example.com",
  ///       "display_name": "Account café",
  ///       "id": 10,
  ///       "is_primary": true
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
  /// **Example** "primary_missing":
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
  /// **Example** "list_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_unavailable":
  /// A primary-account query failure must not masquerade as a missing account.
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
  /// **Example** "key_permissions_unavailable":
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
  _i8.Future<_i9.TonikResult<_i10.ListAccountsResponse, _i11.Response>>
  listAccounts({_i9.TonikCancellation? cancellation}) async =>
      _listAccounts(cancellation: cancellation);

  /// Create an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "address_missing":
  /// ```json
  /// {
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "hash_imported":
  /// ```json
  /// {
  ///   "address": "imported@restmail.test",
  ///   "display_name": "Imported Account",
  ///   "password_hash": "{SHA512-CRYPT}$6$importsalt$ObInO4qcr134i8FQT.XNC6Ma04n9aRTAUNHmm8Yb1idoDBOXKoDTmdosY1xwfageGXo4ZSSrkIPRk9zMWfsG7/"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "new-account@restmail.test",
  ///     "display_name": "New Account",
  ///     "id": 2,
  ///     "is_primary": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "hash_imported":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "imported@restmail.test",
  ///     "display_name": "Imported Account",
  ///     "id": 3,
  ///     "is_primary": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "address_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i8.Future<_i9.TonikResult<_i12.CreateAccountResponse, _i11.Response>>
  createAccount({
    required _i13.CreateAccountRequest body,
    _i9.TonikCancellation? cancellation,
  }) async => _createAccount(body: body, cancellation: cancellation);

  /// Link an existing account by proving its password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "address_blank":
  /// ```json
  /// {
  ///   "address": "   ",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "address_missing":
  /// ```json
  /// {
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "linked":
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "password_empty":
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": ""
  /// }
  /// ```
  ///
  /// **Example** "password_missing":
  /// ```json
  /// {
  ///   "address": "eve@restmail.test"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "linked":
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "eve@restmail.test",
  ///     "display_name": "Eve",
  ///     "id": 2,
  ///     "is_primary": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "address_blank":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "address_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "password_empty":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "password": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "password_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "password": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i8.Future<_i9.TonikResult<_i14.LinkAccountResponse, _i11.Response>>
  linkAccount({
    required _i15.LinkAccountRequest body,
    _i9.TonikCancellation? cancellation,
  }) async => _linkAccount(body: body, cancellation: cancellation);

  /// Get an account this one may read
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "domain_grant" — A mail-read grant covering the domain reaches this account:
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "linked@example.com",
  ///     "display_name": "Account café",
  ///     "id": 1,
  ///     "is_primary": false
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
  ///     "address": "linked@example.com",
  ///     "display_name": "Account café",
  ///     "id": 1,
  ///     "is_primary": false
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
  ///     "address": "linked@example.com",
  ///     "display_name": "Account café",
  ///     "id": 1,
  ///     "is_primary": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary" — The active primary account has implicit owner capabilities:
  /// ```json
  /// {
  ///   "data": {
  ///     "address": "user@example.com",
  ///     "display_name": "Account café",
  ///     "id": 10,
  ///     "is_primary": true
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
  /// **Example** "key_holder_missing" — A valid key cannot exceed its holder's current grants:
  /// The production verifier accepts the scoped key, but the actual grant loader supplies only mail:write for its holder on this account. The old key permission cannot supply the missing mail:read capability.
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
  /// **Example** "key_write_only" — A valid API key with only mail-write permission cannot read:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
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
  /// **Example** "key_wrong_scope" — A valid API key scoped to another mailbox is refused:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
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
  /// **Example** "missing" — A missing account retains the existing privacy refusal:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
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
  /// **Example** "write_only" — A mail-write grant alone does not permit a read:
  /// Unknown and inaccessible accounts remain indistinguishable to the caller.
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
  _i8.Future<_i9.TonikResult<_i16.GetAccountResponse, _i11.Response>>
  getAccount({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _getAccount(id: id, cancellation: cancellation);

  /// Give up access to an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i8.Future<_i9.TonikResult<_i17.UnlinkAccountResponse, _i11.Response>>
  unlinkAccount({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _unlinkAccount(id: id, cancellation: cancellation);

  /// Get quota usage for an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "domain_grant" — A mail-read grant covering the domain reaches this account:
  /// ```json
  /// {
  ///   "data": {
  ///     "message_count": 3,
  ///     "percent_used": 25,
  ///     "quota_bytes": 1024,
  ///     "quota_used_bytes": 256
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
  ///     "message_count": 3,
  ///     "percent_used": 25,
  ///     "quota_bytes": 1024,
  ///     "quota_used_bytes": 256
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
  ///     "message_count": 3,
  ///     "percent_used": 25,
  ///     "quota_bytes": 1024,
  ///     "quota_used_bytes": 256
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary" — The active primary account has implicit owner capabilities:
  /// ```json
  /// {
  ///   "data": {
  ///     "message_count": 3,
  ///     "percent_used": 25,
  ///     "quota_bytes": 1024,
  ///     "quota_used_bytes": 256
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unlimited" — An unlimited quota retains finite JSON and actual usage:
  /// A zero byte ceiling means unlimited storage. Its percentage is zero instead of NaN or infinity; message count and used bytes remain accurate.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "message_count": 3,
  ///     "percent_used": 0,
  ///     "quota_bytes": 0,
  ///     "quota_used_bytes": 256
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
  /// Response 404 (application/json):
  /// **Example** "disappeared" — An authorized mailbox disappears before the quota reload:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Mailbox not found"
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
  /// **Example** "count_unavailable" — A failed message count cannot silently become zero:
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
  /// **Example** "mailbox_unavailable" — A failed quota reload is not a missing mailbox:
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
  _i8.Future<_i9.TonikResult<_i18.GetQuotaResponse, _i11.Response>> getQuota({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => _getQuota(id: id, cancellation: cancellation);
}
