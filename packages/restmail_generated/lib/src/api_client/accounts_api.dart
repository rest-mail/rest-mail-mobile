// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i10;

import 'package:http/http.dart' as _i13;
import 'package:restmail_generated/src/model/create_account_request.dart'
    as _i15;
import 'package:restmail_generated/src/model/link_account_request.dart' as _i17;
import 'package:restmail_generated/src/model/send_limit_values.dart' as _i23;
import 'package:restmail_generated/src/operation/create_account.dart' as _i3;
import 'package:restmail_generated/src/operation/get_account.dart' as _i5;
import 'package:restmail_generated/src/operation/get_account_send_limits.dart'
    as _i8;
import 'package:restmail_generated/src/operation/get_quota.dart' as _i7;
import 'package:restmail_generated/src/operation/link_account.dart' as _i4;
import 'package:restmail_generated/src/operation/list_accounts.dart' as _i2;
import 'package:restmail_generated/src/operation/set_account_send_limits.dart'
    as _i9;
import 'package:restmail_generated/src/operation/unlink_account.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/create_account_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/get_account_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/get_account_send_limits_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/get_quota_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/link_account_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/list_accounts_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/set_account_send_limits_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/unlink_account_response.dart'
    as _i19;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i11;

class AccountsApi {
  AccountsApi(_i1.Server server)
    : _listAccounts = _i2.ListAccounts(server.baseUrl, () => server.client),
      _createAccount = _i3.CreateAccount(server.baseUrl, () => server.client),
      _linkAccount = _i4.LinkAccount(server.baseUrl, () => server.client),
      _getAccount = _i5.GetAccount(server.baseUrl, () => server.client),
      _unlinkAccount = _i6.UnlinkAccount(server.baseUrl, () => server.client),
      _getQuota = _i7.GetQuota(server.baseUrl, () => server.client),
      _getAccountSendLimits = _i8.GetAccountSendLimits(
        server.baseUrl,
        () => server.client,
      ),
      _setAccountSendLimits = _i9.SetAccountSendLimits(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListAccounts _listAccounts;

  final _i3.CreateAccount _createAccount;

  final _i4.LinkAccount _linkAccount;

  final _i5.GetAccount _getAccount;

  final _i6.UnlinkAccount _unlinkAccount;

  final _i7.GetQuota _getQuota;

  final _i8.GetAccountSendLimits _getAccountSendLimits;

  final _i9.SetAccountSendLimits _setAccountSendLimits;

  /// List the accounts this one reaches
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
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
  _i10.Future<_i11.TonikResult<_i12.ListAccountsResponse, _i13.Response>>
  listAccounts({_i11.TonikCancellation? cancellation}) async =>
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
  /// **Example** "already_exists" — The address is already an account:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
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
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
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
  /// **Example** "outside_domain" — The caller cannot create accounts on that domain:
  /// ```json
  /// {
  ///   "address": "chris@other.test"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "address": "new-account@restmail.test",
  ///   "display_name": "New Account",
  ///   "password": "correct-horse-battery"
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
  /// **Example** "outside_domain" — The caller cannot create accounts on that domain:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "You cannot create accounts on other.test"
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
  /// **Example** "already_exists" — The address is already an account:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "An account with this address already exists"
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
  _i10.Future<_i11.TonikResult<_i14.CreateAccountResponse, _i13.Response>>
  createAccount({
    required _i15.CreateAccountRequest body,
    _i11.TonikCancellation? cancellation,
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
  /// **Example** "already_linked" — The account is linked already:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
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
  ///   "address": "eve@restmail.test",
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
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "supplied-by-contract-hook"
  /// }
  /// ```
  ///
  /// **Example** "wrong_password" — The password does not prove the account:
  /// A refused proof is 403, never 401: the session that sent it is still good.
  ///
  /// ```json
  /// {
  ///   "address": "eve@restmail.test",
  ///   "password": "contract-wrong-password"
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
  /// **Example** "wrong_password" — The password does not prove the account:
  /// A refused proof is 403, never 401: the session that sent it is still good.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_credentials",
  ///     "message": "Invalid email or password"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "already_linked" — The account is linked already:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "This account is already linked"
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
  _i10.Future<_i11.TonikResult<_i16.LinkAccountResponse, _i13.Response>>
  linkAccount({
    required _i17.LinkAccountRequest body,
    _i11.TonikCancellation? cancellation,
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
  _i10.Future<_i11.TonikResult<_i18.GetAccountResponse, _i13.Response>>
  getAccount({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => _getAccount(id: id, cancellation: cancellation);

  /// Give up access to an account
  /// Missing links retain 404; account lookup and grant-removal failures return 500. The lookup and removal transaction follow request cancellation.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
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
  /// **Example** "missing" — No link to that account:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Linked account not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "own_account" — The caller's own account is not a link:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "own_account",
  ///     "message": "You cannot unlink your own account"
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to look up linked account"
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
  _i10.Future<_i11.TonikResult<_i19.UnlinkAccountResponse, _i13.Response>>
  unlinkAccount({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
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
  /// **Example** "write_only" — A mail-write grant alone does not permit a read:
  /// A caller that can see the account is told this action is what it lacks.
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
  _i10.Future<_i11.TonikResult<_i20.GetQuotaResponse, _i13.Response>> getQuota({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => _getQuota(id: id, cancellation: cancellation);

  /// Read effective account send limits
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "effective" — The account's effective limits; zero is unlimited:
  /// ```json
  /// {
  ///   "data": {
  ///     "messages_per_day": 1000,
  ///     "messages_per_hour": 100,
  ///     "recipients_per_day": 10000,
  ///     "recipients_per_hour": 1000
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
  /// No account exists at the ID; an account the caller cannot manage answers the same.
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
  _i10.Future<
    _i11.TonikResult<_i21.GetAccountSendLimitsResponse, _i13.Response>
  >
  getAccountSendLimits({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => _getAccountSendLimits(id: id, cancellation: cancellation);

  /// Set account send limits with a two-factor session
  /// All four values are required; zero is unlimited. Owned accounts may only be capped below their owner's live limits. A two-factor person session and mailbox:manage are required. Changes are audited with the actual actor and session. Domain and server ceilings still apply.
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
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "messages_per_day": 1000,
  ///   "messages_per_hour": 100,
  ///   "recipients_per_day": 10000,
  ///   "recipients_per_hour": 1000
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
  /// No account exists at the ID; an account the caller cannot manage answers the same.
  ///
  /// ```json
  /// {
  ///   "messages_per_day": 500,
  ///   "messages_per_hour": 50,
  ///   "recipients_per_day": 2000,
  ///   "recipients_per_hour": 200
  /// }
  /// ```
  ///
  /// **Example** "owner_limit_exceeded" — An owned account cannot be allowed more than its owner:
  /// ```json
  /// {
  ///   "messages_per_day": 2000,
  ///   "messages_per_hour": 200,
  ///   "recipients_per_day": 20000,
  ///   "recipients_per_hour": 2000
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "messages_per_day": 1000,
  ///   "messages_per_hour": 100,
  ///   "recipients_per_day": 10000,
  ///   "recipients_per_hour": 1000
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "messages_per_day": 1000,
  ///   "messages_per_hour": 100,
  ///   "recipients_per_day": 10000,
  ///   "recipients_per_hour": 1000
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "messages_per_day": 1000,
  ///   "messages_per_hour": 100,
  ///   "recipients_per_day": 10000,
  ///   "recipients_per_hour": 1000
  /// }
  /// ```
  ///
  /// **Example** "updated" — A two-factor session sets the account's own limits:
  /// ```json
  /// {
  ///   "messages_per_day": 500,
  ///   "messages_per_hour": 50,
  ///   "recipients_per_day": 2000,
  ///   "recipients_per_hour": 200
  /// }
  /// ```
  ///
  /// **Example** "without_two_factor" — A session without a second factor cannot change limits:
  /// ```json
  /// {
  ///   "messages_per_day": 1000,
  ///   "messages_per_hour": 100,
  ///   "recipients_per_day": 10000,
  ///   "recipients_per_hour": 1000
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "updated" — A two-factor session sets the account's own limits:
  /// ```json
  /// {
  ///   "data": {
  ///     "messages_per_day": 500,
  ///     "messages_per_hour": 50,
  ///     "recipients_per_day": 2000,
  ///     "recipients_per_hour": 200
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
  /// **Example** "without_two_factor" — A session without a second factor cannot change limits:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "Sign in as a person with two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// No account exists at the ID; an account the caller cannot manage answers the same.
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
  /// Response 409 (application/json):
  /// **Example** "owner_limit_exceeded" — An owned account cannot be allowed more than its owner:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "owner_limit_exceeded",
  ///     "message": "owned account send limits must not exceed the owner's limits"
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
  _i10.Future<
    _i11.TonikResult<_i22.SetAccountSendLimitsResponse, _i13.Response>
  >
  setAccountSendLimits({
    required _i23.SendLimitValues body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async =>
      _setAccountSendLimits(body: body, id: id, cancellation: cancellation);
}
