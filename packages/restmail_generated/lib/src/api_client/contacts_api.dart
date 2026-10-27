// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i9;

import 'package:http/http.dart' as _i12;
import 'package:restmail_generated/src/model/api_v1_accounts_id_contacts_parameters_model.dart'
    as _i13;
import 'package:restmail_generated/src/model/block_sender_body.dart' as _i17;
import 'package:restmail_generated/src/model/create_contact_body.dart' as _i15;
import 'package:restmail_generated/src/model/import_contacts_body.dart' as _i19;
import 'package:restmail_generated/src/model/update_contact_body.dart' as _i23;
import 'package:restmail_generated/src/operation/block_sender.dart' as _i4;
import 'package:restmail_generated/src/operation/create_contact.dart' as _i3;
import 'package:restmail_generated/src/operation/delete_contact.dart' as _i7;
import 'package:restmail_generated/src/operation/import_contacts.dart' as _i5;
import 'package:restmail_generated/src/operation/list_contacts.dart' as _i2;
import 'package:restmail_generated/src/operation/suggest_contacts.dart' as _i6;
import 'package:restmail_generated/src/operation/update_contact.dart' as _i8;
import 'package:restmail_generated/src/response_wrapper/block_sender_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/create_contact_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/delete_contact_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/import_contacts_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/list_contacts_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/suggest_contacts_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/update_contact_response.dart'
    as _i22;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i10;

class ContactsApi {
  ContactsApi(_i1.Server server)
    : _listContacts = _i2.ListContacts(server.baseUrl, () => server.client),
      _createContact = _i3.CreateContact(server.baseUrl, () => server.client),
      _blockSender = _i4.BlockSender(server.baseUrl, () => server.client),
      _importContacts = _i5.ImportContacts(server.baseUrl, () => server.client),
      _suggestContacts = _i6.SuggestContacts(
        server.baseUrl,
        () => server.client,
      ),
      _deleteContact = _i7.DeleteContact(server.baseUrl, () => server.client),
      _updateContact = _i8.UpdateContact(server.baseUrl, () => server.client);

  final _i2.ListContacts _listContacts;

  final _i3.CreateContact _createContact;

  final _i4.BlockSender _blockSender;

  final _i5.ImportContacts _importContacts;

  final _i6.SuggestContacts _suggestContacts;

  final _i7.DeleteContact _deleteContact;

  final _i8.UpdateContact _updateContact;

  /// List contacts for an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password" — An actual HTTP Basic app password reads its own account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 10,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 10,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "blank_search" — An explicit blank search does not add a LIKE filter:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "clamped" — An excessive limit is capped and a negative offset becomes zero:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant" — A domain-scoped mail-read grant reaches this account:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "empty" — An accessible account without rows returns an empty array:
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "filtered" — Trust and literal search filters reach both the count and row queries:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "first_page" — The first page retains the total and reports more results:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": true,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The production route loads current grants and maps fixed SQL rows through the real handler. Controlled rows prove wiring and response grouping, not PostgreSQL filtering, ordering or persistence.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read" — A real API key and its holder both permit this mailbox read:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 1,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "paged" — Offset pagination retains the total count:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 1,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "\"a100%_\\\\\"@example.com",
  ///       "id": 31,
  ///       "mailbox_id": 10,
  ///       "name": "Friend café",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "email": "z@example.com",
  ///       "id": 32,
  ///       "mailbox_id": 10,
  ///       "name": "Blocked",
  ///       "source": "import",
  ///       "trust_level": "blocked",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 2
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
  /// **Example** "app_password_other" — An app password cannot read a linked account:
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
  /// **Example** "inaccessible" — An inaccessible account and a missing one have the same refusal:
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
  /// **Example** "invalid_limit":
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
  /// **Example** "invalid_trust":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "trust_level": "must be one of auto, trusted, blocked"
  ///       }
  ///     },
  ///     "message": "Query parameters failed validation"
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
  /// **Example** "content_unavailable" — A dependency fault is an internal error, not an empty result or a permission decision:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list contacts"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "count_unavailable" — A dependency fault is an internal error, not an empty result or a permission decision:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list contacts"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable" — A dependency fault is an internal error, not an empty result or a permission decision:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable" — A dependency fault is an internal error, not an empty result or a permission decision:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable" — A dependency fault is an internal error, not an empty result or a permission decision:
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
  _i9.Future<_i10.TonikResult<_i11.ListContactsResponse, _i12.Response>>
  listContacts({
    required _i9.int id,
    _i13.ApiV1AccountsIdContactsParametersModel? trustLevel,
    _i9.String? search,
    _i9.int? limit,
    _i9.int? offset,
    _i10.TonikCancellation? cancellation,
  }) async => _listContacts(
    id: id,
    trustLevel: trustLevel,
    search: search,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Create a new contact
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
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "email": "someone@example.com",
  ///   "name": "Someone",
  ///   "trust_level": "trusted"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "email": "duplicate@example.com"
  /// }
  /// ```
  ///
  /// **Example** "email_invalid":
  /// The request matches its published field types but violates runtime address/trust rules. Keep its exact 422 answer without marking a schema-valid business-rule refusal invalid.
  ///
  /// ```json
  /// {
  ///   "email": "Refused <refused@example.com>",
  ///   "name": "Someone",
  ///   "trust_level": "trusted"
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "name": "Someone",
  ///   "trust_level": "trusted"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "email": "new@example.com"
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
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
  ///
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "trust_auto":
  /// ```json
  /// {
  ///   "email": "new@example.com",
  ///   "trust_level": "auto"
  /// }
  /// ```
  ///
  /// **Example** "trust_blocked":
  /// ```json
  /// {
  ///   "email": "new@example.com",
  ///   "trust_level": "blocked"
  /// }
  /// ```
  ///
  /// **Example** "trust_default":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "trust_level_invalid":
  /// The request matches its published field types but violates runtime address/trust rules. Keep its exact 422 answer without marking a schema-valid business-rule refusal invalid.
  ///
  /// ```json
  /// {
  ///   "email": "refused@example.com",
  ///   "name": "Someone",
  ///   "trust_level": "friend"
  /// }
  /// ```
  ///
  /// **Example** "trust_null":
  /// ```json
  /// {
  ///   "email": "new@example.com",
  ///   "trust_level": null
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "email": "create-failure@example.com"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "someone@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Someone",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "trust_auto":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "trust_blocked":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "trust_default":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "trust_null":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
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
  /// Response 409 (application/json):
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "already_exists",
  ///     "message": "Contact already exists"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
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
  /// **Example** "email_invalid":
  /// The request matches its published field types but violates runtime address/trust rules. Keep its exact 422 answer without marking a schema-valid business-rule refusal invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "must be an email address"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// **Example** "trust_level_invalid":
  /// The request matches its published field types but violates runtime address/trust rules. Keep its exact 422 answer without marking a schema-valid business-rule refusal invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "trust_level": "must be auto, trusted, or blocked"
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
  _i9.Future<_i10.TonikResult<_i14.CreateContactResponse, _i12.Response>>
  createContact({
    required _i15.CreateContactBody body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _createContact(body: body, id: id, cancellation: cancellation);

  /// Block a sender
  /// 201 when the sender was not a contact (a new contact, blocked), 200 when an existing contact was changed to blocked.
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
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "create_unavailable":
  /// ```json
  /// {
  ///   "email": "create-failure@example.com"
  /// }
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "email": "new@example.com"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "email": "spam@example.org"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "email": "lookup-failure@example.com"
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
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "reload_missing":
  /// ```json
  /// {
  ///   "email": "reload-missing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "reload_unavailable":
  /// ```json
  /// {
  ///   "email": "reload-failure@example.com"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
  ///
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "email": "update-failure@example.com"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "spam@example.org",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "existing@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "new@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "manual",
  ///     "trust_level": "blocked",
  ///     "updated_at": "2026-01-01T00:00:00Z"
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
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
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
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// **Example** "create_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to block sender"
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
  /// **Example** "reload_missing":
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
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to block sender"
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
  _i9.Future<_i10.TonikResult<_i16.BlockSenderResponse, _i12.Response>>
  blockSender({
    required _i17.BlockSenderBody body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _blockSender(body: body, id: id, cancellation: cancellation);

  /// Bulk import contacts
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "all_duplicate":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "duplicate@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "batch_failure":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "first@example.com"
  ///     },
  ///     {
  ///       "email": "fail@example.com"
  ///     },
  ///     {
  ///       "email": "last@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "contacts_empty":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "contacts": []
  /// }
  /// ```
  ///
  /// **Example** "contacts_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "duplicates":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com"
  ///     },
  ///     {
  ///       "email": "duplicate@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "email_invalid":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "not-an-email"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {}
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real authentication, scoped credentials/current holder grants and CSRF precede full-batch validation. Inserts use one transaction and mailbox/email conflict skipping; only inserted rows count. Local SQL verifies begin/commit/rollback and parameters; PostgreSQL rollback tests run with a database.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "imported":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "carol@example.org",
  ///       "name": "Carol"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
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
  /// **Example** "mixed_batch":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "valid-import@example.org",
  ///       "name": "Must not be imported"
  ///     },
  ///     {
  ///       "email": "not-an-email"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "repeat_batch":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "repeat@example.com"
  ///     },
  ///     {
  ///       "email": "repeat@example.com"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise its real body guard.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "new@example.com",
  ///       "name": "New"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "all_duplicate":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 0
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duplicates":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real authentication, scoped credentials/current holder grants and CSRF precede full-batch validation. Inserts use one transaction and mailbox/email conflict skipping; only inserted rows count. Local SQL verifies begin/commit/rollback and parameters; PostgreSQL rollback tests run with a database.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "imported":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "repeat_batch":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1
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
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise its real body guard.
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
  /// **Example** "contacts_empty":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contacts": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "contacts_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contacts": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_invalid":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contacts[0].email": "must be an email address"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contacts[0].email": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
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
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
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
  /// **Example** "mixed_batch":
  /// The request matches the published field types but is refused by runtime batch/address validation. Preserve its exact 422 answer without marking the schema-valid request invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "contacts[1].email": "must be an email address"
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
  /// **Example** "batch_failure":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
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
  _i9.Future<_i10.TonikResult<_i18.ImportContactsResponse, _i12.Response>>
  importContacts({
    required _i19.ImportContactsBody body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _importContacts(body: body, id: id, cancellation: cancellation);

  /// Autocomplete contacts by query
  /// At most 10 contacts whose address or name contains q, blocked ones left out; an empty q answers none.
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
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 10,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 10,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 1,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 1,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 1,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 1,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "empty_query":
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real read-capability and holder gates precede mailbox-bound, escaped literal email/name matching, blocked-contact exclusion, stable name/email ordering and limit10. Empty query does not access contacts. Fixed SQL proves wiring; PostgreSQL tests prove literal filtering when a database is available.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 1,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 1,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 1,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 1,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "literal_backslash":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "backslash@example.com",
  ///       "id": 5,
  ///       "mailbox_id": 1,
  ///       "name": "path\\name",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "literal_percent":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "percent@example.com",
  ///       "id": 3,
  ///       "mailbox_id": 1,
  ///       "name": "50% offer",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "literal_underscore":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "underscore@example.com",
  ///       "id": 4,
  ///       "mailbox_id": 1,
  ///       "name": "part_one",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 10,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 10,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "alpha@example.com",
  ///       "id": 1,
  ///       "mailbox_id": 10,
  ///       "name": "Alpha",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     },
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "beta@example.com",
  ///       "id": 2,
  ///       "mailbox_id": 10,
  ///       "name": "Beta",
  ///       "source": "manual",
  ///       "trust_level": "trusted",
  ///       "updated_at": "2026-01-01T00:00:00Z"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unicode":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-01-01T00:00:00Z",
  ///       "email": "unicode@example.com",
  ///       "id": 6,
  ///       "mailbox_id": 1,
  ///       "name": "Élodie",
  ///       "source": "sent",
  ///       "trust_level": "auto",
  ///       "updated_at": "2026-01-01T00:00:00Z"
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
  /// **Example** "key_write_domain":
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
  /// **Example** "key_write_only":
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
  /// **Example** "write_only":
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
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise its real body guard.
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
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
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
  /// A valid request body/query reaches the real path binder; the malformed path value is refused without storage access.
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
  /// **Example** "query_unavailable":
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
  _i9.Future<_i10.TonikResult<_i20.SuggestContactsResponse, _i12.Response>>
  suggestContacts({
    required _i9.int id,
    _i9.String? q,
    _i10.TonikCancellation? cancellation,
  }) async => _suggestContacts(id: id, q: q, cancellation: cancellation);

  /// Delete a contact
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
  /// **Example** "key_send":
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
  /// **Example** "missing_account":
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Contact not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_mailbox":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Contact not found"
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
  /// **Example** "invalid_cid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cid": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_cid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cid": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to delete contact"
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
  _i9.Future<_i10.TonikResult<_i21.DeleteContactResponse, _i12.Response>>
  deleteContact({
    required _i9.int id,
    required _i9.int cid,
    _i10.TonikCancellation? cancellation,
  }) async => _deleteContact(id: id, cid: cid, cancellation: cancellation);

  /// Update a contact
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
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "clear_name":
  /// ```json
  /// {
  ///   "name": ""
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "csrf_mismatch":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "csrf_missing":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "invalid_cid":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "invalid_cid_format":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "key_write_holder_missing":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_scope":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "lookup_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
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
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "null_fields":
  /// ```json
  /// {
  ///   "name": null,
  ///   "trust_level": null
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "reload_missing":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "reload_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
  ///
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "setup_required":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "target_unavailable":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "trust_invalid":
  /// ```json
  /// {
  ///   "trust_level": "friend"
  /// }
  /// ```
  ///
  /// **Example** "trust_only":
  /// ```json
  /// {
  ///   "trust_level": "trusted"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "name": "update unavailable"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "clear_name":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "null_fields":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "primary_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 10,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "trust_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "sent",
  ///     "trust_level": "trusted",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unchanged":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Before",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "before@example.com",
  ///     "id": 1,
  ///     "mailbox_id": 1,
  ///     "name": "Changed",
  ///     "source": "sent",
  ///     "trust_level": "auto",
  ///     "updated_at": "2026-01-01T00:00:00Z"
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Contact not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "reload_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Contact not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The configured route cap is512 bytes; the route and Vertrag transport hook send513 bytes to exercise the real guard before body parsing.
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
  /// **Example** "invalid_cid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cid": "must be at least 1"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_cid_format":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "cid": "must be a non-negative integer"
  ///       }
  ///     },
  ///     "message": "Path parameters failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_format":
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// The JSON body is valid. The real path binder refuses the malformed account identifier; a body-invalid marker would not describe path binding.
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
  /// **Example** "trust_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "trust_level": "must be auto, trusted, or blocked"
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
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to update contact"
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
  _i9.Future<_i10.TonikResult<_i22.UpdateContactResponse, _i12.Response>>
  updateContact({
    required _i23.UpdateContactBody body,
    required _i9.int id,
    required _i9.int cid,
    _i10.TonikCancellation? cancellation,
  }) async =>
      _updateContact(body: body, id: id, cid: cid, cancellation: cancellation);
}
