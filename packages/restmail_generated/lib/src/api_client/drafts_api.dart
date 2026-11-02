// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:http/http.dart' as _i8;
import 'package:restmail_generated/src/model/api_v1_messages_draft_id_send_post_body_body_one_of_model.dart'
    as _i13;
import 'package:restmail_generated/src/model/save_draft_body.dart' as _i9;
import 'package:restmail_generated/src/model/update_draft_body.dart' as _i11;
import 'package:restmail_generated/src/operation/save_draft.dart' as _i2;
import 'package:restmail_generated/src/operation/send_draft.dart' as _i4;
import 'package:restmail_generated/src/operation/update_draft.dart' as _i3;
import 'package:restmail_generated/src/response_wrapper/save_draft_response.dart'
    as _i7;
import 'package:restmail_generated/src/response_wrapper/send_draft_response.dart'
    as _i12;
import 'package:restmail_generated/src/response_wrapper/update_draft_response.dart'
    as _i10;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i6;

class DraftsApi {
  DraftsApi(_i1.Server server)
    : _saveDraft = _i2.SaveDraft(server.baseUrl, () => server.client),
      _updateDraft = _i3.UpdateDraft(server.baseUrl, () => server.client),
      _sendDraft = _i4.SendDraft(server.baseUrl, () => server.client);

  final _i2.SaveDraft _saveDraft;

  final _i3.UpdateDraft _updateDraft;

  final _i4.SendDraft _sendDraft;

  /// Save a new draft
  /// Sender lookup and storage follow request cancellation; dependency failures return 500, not forbidden.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "empty" — Start an empty draft in the signed-in account:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "foreign_sender":
  /// ```json
  /// {
  ///   "from": "other@restmail.test"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {. The production request and Vertrag hook send those exact bytes.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The fixture cap is 512 bytes; the transport sends 513 bytes. Binding and draft side effects are never reached.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "wrong_type":
  /// ```json
  /// {
  ///   "subject": 12
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "empty" — Start an empty draft in the signed-in account:
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-10-27T07:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "Drafts",
  ///     "has_attachments": false,
  ///     "id": 12,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": true,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "",
  ///     "raw_size": 0,
  ///     "received_at": "2026-10-27T07:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [],
  ///     "references": "",
  ///     "sender": "",
  ///     "sender_name": "",
  ///     "size_bytes": 0,
  ///     "subject": "",
  ///     "thread_id": "",
  ///     "updated_at": "2026-10-27T07:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {. The production request and Vertrag hook send those exact bytes.
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
  /// **Example** "foreign_sender":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "You are not authorized to send from this address"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The fixture cap is 512 bytes; the transport sends 513 bytes. Binding and draft side effects are never reached.
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
  /// **Example** "wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "subject": "must be a string"
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
  ///     "message": "Failed to check the sender"
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
  _i5.Future<_i6.TonikResult<_i7.SaveDraftResponse, _i8.Response>> saveDraft({
    required _i9.SaveDraftBody body,
    _i6.TonikCancellation? cancellation,
  }) async => _saveDraft(body: body, cancellation: cancellation);

  /// Update an existing draft
  /// Update and reload commit together. A failed write/reload returns 500 and rolls back; an absent or no-longer-draft row is 404. Declared in_reply_to and references fields are persisted; omitted/null fields stay unchanged. Dependency errors are distinct from denied access, and SQL follows request cancellation.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "body_text": "Ready to send.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft, edited",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "foreign_owner":
  /// The draft belongs to another account; the signed-in principal has no authority over it.
  ///
  /// ```json
  /// {
  ///   "subject": "not authorized"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "body_text": "Ready to send.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft, edited",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// The path ID is invalid. Its empty JSON body remains valid; body-invalid flags do not describe path binding.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {. The production request and Vertrag hook send those exact bytes.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "missing":
  /// No row exists at the ID.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "body_text": "Ready to send.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft, edited",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// The fixture cap is 512 bytes; the transport sends 513 bytes. Binding and draft side effects are never reached.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "body_text": "Ready to send.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft, edited",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "body_text": "Ready to send.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft, edited",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Ready to send.",
  ///     "calendar_events": [],
  ///     "created_at": "2026-10-27T07:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "Drafts",
  ///     "has_attachments": false,
  ///     "headers": [],
  ///     "id": 12,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": true,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "",
  ///     "raw_size": 0,
  ///     "received_at": "2026-10-27T07:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "admin@restmail.test"
  ///     ],
  ///     "references": "",
  ///     "sender": "admin@restmail.test",
  ///     "sender_name": "",
  ///     "size_bytes": 18,
  ///     "subject": "Draft, edited",
  ///     "thread_id": "",
  ///     "updated_at": "2026-10-27T07:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {. The production request and Vertrag hook send those exact bytes.
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
  /// Response 404 (application/json):
  /// **Example** "foreign_owner":
  /// The draft belongs to another account; the signed-in principal has no authority over it.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// No row exists at the ID.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Draft not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The fixture cap is 512 bytes; the transport sends 513 bytes. Binding and draft side effects are never reached.
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
  /// The path ID is invalid. Its empty JSON body remains valid; body-invalid flags do not describe path binding.
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
  ///     "message": "Failed to read draft"
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
  _i5.Future<_i6.TonikResult<_i10.UpdateDraftResponse, _i8.Response>>
  updateDraft({
    required _i11.UpdateDraftBody body,
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _updateDraft(body: body, id: id, cancellation: cancellation);

  /// Send a draft
  /// The draft (mail:write) is sent as sendMessage sends, and deleted once it is; a refused send keeps it. Draft lookup/access dependency failures return 500 and follow request cancellation. Sending from your own mailbox requires mail:send. From another mailbox requires mail:send_as on that mailbox. Set on_behalf to true to require mail:send_on_behalf instead: From stays the represented mailbox and RFC 5322 Sender is the authenticated account's own address. Read access grants neither mode. Both modes audit the real account, credential and represented mailbox.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "held" — Held by a spent send limit until a person releases it:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "sent":
  /// The seeded draft is sent externally, leaving one Sent copy and one queued recipient; generated MIME identifiers, raw length and timestamps are illustrative.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "discarded":
  /// The outbound Sieve policy discards the message. The draft is removed without creating Sent or recipient queue work.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "discarded"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "sent":
  /// The seeded draft is sent externally, leaving one Sent copy and one queued recipient; generated MIME identifiers, raw length and timestamps are illustrative.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Not sent yet.",
  ///     "created_at": "2026-10-27T07:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 200,
  ///     "folder": "Sent",
  ///     "has_attachments": false,
  ///     "id": 13,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<draft-sent@restmail.test>",
  ///     "raw_size": 200,
  ///     "received_at": "2026-10-27T07:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "someone@imap.restmail.test"
  ///     ],
  ///     "references": "",
  ///     "sender": "admin@restmail.test",
  ///     "sender_name": "",
  ///     "size_bytes": 18,
  ///     "subject": "Draft",
  ///     "thread_id": "<draft-sent@restmail.test>",
  ///     "updated_at": "2026-10-27T07:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 202 (application/json):
  /// **Example** "held" — Held by a spent send limit until a person releases it:
  /// ```json
  /// {
  ///   "data": {
  ///     "account_id": 1,
  ///     "attempts": 0,
  ///     "created_at": "2026-10-31T00:10:00Z",
  ///     "from": "chris@example.test",
  ///     "id": 3,
  ///     "last_error": "account:1: messages_per_hour",
  ///     "scheduled_at": "2026-10-31T01:00:00Z",
  ///     "status": "held",
  ///     "subject": "Quarterly report",
  ///     "to": [
  ///       "bob@example.org"
  ///     ],
  ///     "updated_at": "2026-10-31T00:10:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "no_recipients":
  /// The stored draft has an empty recipient list; the refusal preserves it.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Draft has no recipients"
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
  /// Response 404 (application/json):
  /// **Example** "foreign_owner":
  /// The draft belongs to another account; the signed-in principal has no authority over it.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// No row exists at the ID.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Draft not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// The fixture cap is 512 bytes; the transport sends 513 bytes. Binding and draft side effects are never reached.
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
  ///     "message": "Failed to read draft"
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
  _i5.Future<_i6.TonikResult<_i12.SendDraftResponse, _i8.Response>> sendDraft({
    required _i5.int id,
    _i13.ApiV1MessagesDraftIdSendPostBodyBodyOneOfModel? body,
    _i6.TonikCancellation? cancellation,
  }) async => _sendDraft(body: body, id: id, cancellation: cancellation);
}
