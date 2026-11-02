// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i11;

import 'package:http/http.dart' as _i14;
import 'package:restmail_generated/src/model/api_v1_accounts_id_contacts_parameters_model.dart'
    as _i18;
import 'package:restmail_generated/src/model/block_sender_body.dart' as _i22;
import 'package:restmail_generated/src/model/contact_reply_time_setting.dart'
    as _i16;
import 'package:restmail_generated/src/model/create_contact_body.dart' as _i20;
import 'package:restmail_generated/src/model/import_contacts_body.dart' as _i24;
import 'package:restmail_generated/src/model/update_contact_body.dart' as _i28;
import 'package:restmail_generated/src/operation/block_sender.dart' as _i6;
import 'package:restmail_generated/src/operation/create_contact.dart' as _i5;
import 'package:restmail_generated/src/operation/delete_contact.dart' as _i9;
import 'package:restmail_generated/src/operation/get_contact_reply_time_setting.dart'
    as _i2;
import 'package:restmail_generated/src/operation/import_contacts.dart' as _i7;
import 'package:restmail_generated/src/operation/list_contacts.dart' as _i4;
import 'package:restmail_generated/src/operation/set_contact_reply_time_setting.dart'
    as _i3;
import 'package:restmail_generated/src/operation/suggest_contacts.dart' as _i8;
import 'package:restmail_generated/src/operation/update_contact.dart' as _i10;
import 'package:restmail_generated/src/response_wrapper/block_sender_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/create_contact_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/delete_contact_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/get_contact_reply_time_setting_response.dart'
    as _i13;
import 'package:restmail_generated/src/response_wrapper/import_contacts_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/list_contacts_response.dart'
    as _i17;
import 'package:restmail_generated/src/response_wrapper/set_contact_reply_time_setting_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/suggest_contacts_response.dart'
    as _i25;
import 'package:restmail_generated/src/response_wrapper/update_contact_response.dart'
    as _i27;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i12;

class ContactsApi {
  ContactsApi(_i1.Server server)
    : _getContactReplyTimeSetting = _i2.GetContactReplyTimeSetting(
        server.baseUrl,
        () => server.client,
      ),
      _setContactReplyTimeSetting = _i3.SetContactReplyTimeSetting(
        server.baseUrl,
        () => server.client,
      ),
      _listContacts = _i4.ListContacts(server.baseUrl, () => server.client),
      _createContact = _i5.CreateContact(server.baseUrl, () => server.client),
      _blockSender = _i6.BlockSender(server.baseUrl, () => server.client),
      _importContacts = _i7.ImportContacts(server.baseUrl, () => server.client),
      _suggestContacts = _i8.SuggestContacts(
        server.baseUrl,
        () => server.client,
      ),
      _deleteContact = _i9.DeleteContact(server.baseUrl, () => server.client),
      _updateContact = _i10.UpdateContact(server.baseUrl, () => server.client);

  final _i2.GetContactReplyTimeSetting _getContactReplyTimeSetting;

  final _i3.SetContactReplyTimeSetting _setContactReplyTimeSetting;

  final _i4.ListContacts _listContacts;

  final _i5.CreateContact _createContact;

  final _i6.BlockSender _blockSender;

  final _i7.ImportContacts _importContacts;

  final _i8.SuggestContacts _suggestContacts;

  final _i9.DeleteContact _deleteContact;

  final _i10.UpdateContact _updateContact;

  /// Get the account's contact reply-time setting
  /// Off by default. Only this account's stored mail is used; no history is calculated or returned while disabled. Nothing is sent to contacts or external services.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "disabled" — Account-local opt-in, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": false
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
  /// **Example** "without_capability":
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
  /// **Example** "missing":
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
  _i11.Future<
    _i12.TonikResult<_i13.GetContactReplyTimeSettingResponse, _i14.Response>
  >
  getContactReplyTimeSetting({
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _getContactReplyTimeSetting(id: id, cancellation: cancellation);

  /// Set the account's contact reply-time setting
  /// Opt in to contact reply-time estimates in contact lists and suggestions. Uses the median of at least three first replies matched by In-Reply-To, or the last References ID when In-Reply-To is absent, to this account's Sent messages addressed to the contact. Uses stored received_at timestamps, ignores drafts, deleted mail and nonpositive delays, and counts each sent Message-ID once. This is a local estimate, not a signal from the contact. No headers, outbound requests or tracking are added.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "enabled" — Account-local opt-in, off by default:
  /// ```json
  /// {
  ///   "enabled": true
  /// }
  /// ```
  ///
  /// **Example** "enabled_invalid":
  /// ```json
  /// {
  ///   "enabled": "yes"
  /// }
  /// ```
  ///
  /// **Example** "enabled_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "enabled": false
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
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "turned_off" — Account-local opt-in, off by default:
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// **Example** "without_capability":
  /// ```json
  /// {
  ///   "enabled": false
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "enabled" — Account-local opt-in, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": true
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "turned_off" — Account-local opt-in, off by default:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": false
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
  /// **Example** "without_capability":
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
  /// **Example** "missing":
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
  /// **Example** "enabled_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "enabled": "must be a boolean"
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
  _i11.Future<
    _i12.TonikResult<_i15.SetContactReplyTimeSettingResponse, _i14.Response>
  >
  setContactReplyTimeSetting({
    required _i16.ContactReplyTimeSetting body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _setContactReplyTimeSetting(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// List contacts for an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
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
  _i11.Future<_i12.TonikResult<_i17.ListContactsResponse, _i14.Response>>
  listContacts({
    required _i11.int id,
    _i18.ApiV1AccountsIdContactsParametersModel? trustLevel,
    _i11.String? search,
    _i11.int? limit,
    _i11.int? offset,
    _i12.TonikCancellation? cancellation,
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
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "email": "duplicate@example.com"
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "email": "created@example.com"
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
  /// **Example** "unauthenticated":
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
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "email": "created@example.com",
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
  /// Response 404 (application/json):
  /// **Example** "no_grants":
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
  _i11.Future<_i12.TonikResult<_i19.CreateContactResponse, _i14.Response>>
  createContact({
    required _i20.CreateContactBody body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
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
  /// **Example** "created":
  /// ```json
  /// {
  ///   "email": "new@example.com"
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
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
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "email": "existing@example.com"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
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
  /// Response 404 (application/json):
  /// **Example** "no_grants":
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i11.Future<_i12.TonikResult<_i21.BlockSenderResponse, _i14.Response>>
  blockSender({
    required _i22.BlockSenderBody body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
  }) async => _blockSender(body: body, id: id, cancellation: cancellation);

  /// Bulk import contacts
  /// As many contacts as fit the API's request size limit. Every entry is checked first, and contacts the account already has are skipped.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "found":
  /// Real authentication, scoped credentials/current holder grants and CSRF precede full-batch validation. Inserts use one transaction and mailbox/email conflict skipping; only inserted rows count. Local SQL verifies begin/commit/rollback and parameters; PostgreSQL rollback tests run with a database.
  ///
  /// ```json
  /// {
  ///   "contacts": [
  ///     {
  ///       "email": "imported@example.com",
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
  /// Response 200 (application/json):
  /// **Example** "found":
  /// Real authentication, scoped credentials/current holder grants and CSRF precede full-batch validation. Inserts use one transaction and mailbox/email conflict skipping; only inserted rows count. Local SQL verifies begin/commit/rollback and parameters; PostgreSQL rollback tests run with a database.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "imported": 1,
  ///     "skipped": 0
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
  /// Response 404 (application/json):
  /// **Example** "no_grants":
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
  _i11.Future<_i12.TonikResult<_i23.ImportContactsResponse, _i14.Response>>
  importContacts({
    required _i24.ImportContactsBody body,
    required _i11.int id,
    _i12.TonikCancellation? cancellation,
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
  /// Response 404 (application/json):
  /// **Example** "no_grants":
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
  _i11.Future<_i12.TonikResult<_i25.SuggestContactsResponse, _i14.Response>>
  suggestContacts({
    required _i11.int id,
    _i11.String? q,
    _i12.TonikCancellation? cancellation,
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
  /// **Example** "no_grants":
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
  _i11.Future<_i12.TonikResult<_i26.DeleteContactResponse, _i14.Response>>
  deleteContact({
    required _i11.int id,
    required _i11.int cid,
    _i12.TonikCancellation? cancellation,
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
  /// **Example** "found":
  /// Real registered routes authenticate JWT/Basic/scoped keys and current holder grants/CSRF before contact operations. Local SQL verifies row/mailbox selectors, create fields, partial updates and reload outcomes. Fixed rows do not prove PostgreSQL/audit persistence or uniqueness constraints.
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
  /// **Example** "rate_limited":
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
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "name": "Changed"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
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
  /// **Example** "no_grants":
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
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i11.Future<_i12.TonikResult<_i27.UpdateContactResponse, _i14.Response>>
  updateContact({
    required _i28.UpdateContactBody body,
    required _i11.int id,
    required _i11.int cid,
    _i12.TonikCancellation? cancellation,
  }) async =>
      _updateContact(body: body, id: id, cid: cid, cancellation: cancellation);
}
