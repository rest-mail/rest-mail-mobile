// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i19;

import 'package:http/http.dart' as _i22;
import 'package:restmail_generated/src/model/api_v1_accounts_id_threads_thread_id_due_post_body_body_model.dart'
    as _i28;
import 'package:restmail_generated/src/model/api_v1_accounts_id_threads_thread_id_snooze_post_body_body_model.dart'
    as _i30;
import 'package:restmail_generated/src/model/deliver_message_body.dart' as _i32;
import 'package:restmail_generated/src/model/forward_body.dart' as _i43;
import 'package:restmail_generated/src/model/import_message_body.dart' as _i25;
import 'package:restmail_generated/src/model/send_message_description.dart'
    as _i37;
import 'package:restmail_generated/src/model/update_message_body.dart' as _i41;
import 'package:restmail_generated/src/operation/cancel_scheduled_message.dart'
    as _i10;
import 'package:restmail_generated/src/operation/delete_message.dart' as _i14;
import 'package:restmail_generated/src/operation/deliver_message.dart' as _i8;
import 'package:restmail_generated/src/operation/forward_message.dart' as _i16;
import 'package:restmail_generated/src/operation/get_message.dart' as _i13;
import 'package:restmail_generated/src/operation/get_raw_message.dart' as _i17;
import 'package:restmail_generated/src/operation/get_thread.dart' as _i5;
import 'package:restmail_generated/src/operation/import_message.dart' as _i4;
import 'package:restmail_generated/src/operation/list_held_messages.dart'
    as _i3;
import 'package:restmail_generated/src/operation/list_messages.dart' as _i2;
import 'package:restmail_generated/src/operation/list_scheduled_messages.dart'
    as _i9;
import 'package:restmail_generated/src/operation/release_held_message.dart'
    as _i11;
import 'package:restmail_generated/src/operation/send_message.dart' as _i12;
import 'package:restmail_generated/src/operation/set_thread_due.dart' as _i6;
import 'package:restmail_generated/src/operation/snooze_thread.dart' as _i7;
import 'package:restmail_generated/src/operation/update_message.dart' as _i15;
import 'package:restmail_generated/src/operation/verify_message_seal.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/cancel_scheduled_message_response.dart'
    as _i34;
import 'package:restmail_generated/src/response_wrapper/delete_message_response.dart'
    as _i39;
import 'package:restmail_generated/src/response_wrapper/deliver_message_response.dart'
    as _i31;
import 'package:restmail_generated/src/response_wrapper/forward_message_response.dart'
    as _i42;
import 'package:restmail_generated/src/response_wrapper/get_message_response.dart'
    as _i38;
import 'package:restmail_generated/src/response_wrapper/get_raw_message_response.dart'
    as _i44;
import 'package:restmail_generated/src/response_wrapper/get_thread_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/import_message_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/list_held_messages_response.dart'
    as _i23;
import 'package:restmail_generated/src/response_wrapper/list_messages_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/list_scheduled_messages_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/release_held_message_response.dart'
    as _i35;
import 'package:restmail_generated/src/response_wrapper/send_message_response.dart'
    as _i36;
import 'package:restmail_generated/src/response_wrapper/set_thread_due_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/snooze_thread_response.dart'
    as _i29;
import 'package:restmail_generated/src/response_wrapper/update_message_response.dart'
    as _i40;
import 'package:restmail_generated/src/response_wrapper/verify_message_seal_response.dart'
    as _i45;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i20;

class MessagesApi {
  MessagesApi(_i1.Server server)
    : _listMessages = _i2.ListMessages(server.baseUrl, () => server.client),
      _listHeldMessages = _i3.ListHeldMessages(
        server.baseUrl,
        () => server.client,
      ),
      _importMessage = _i4.ImportMessage(server.baseUrl, () => server.client),
      _getThread = _i5.GetThread(server.baseUrl, () => server.client),
      _setThreadDue = _i6.SetThreadDue(server.baseUrl, () => server.client),
      _snoozeThread = _i7.SnoozeThread(server.baseUrl, () => server.client),
      _deliverMessage = _i8.DeliverMessage(server.baseUrl, () => server.client),
      _listScheduledMessages = _i9.ListScheduledMessages(
        server.baseUrl,
        () => server.client,
      ),
      _cancelScheduledMessage = _i10.CancelScheduledMessage(
        server.baseUrl,
        () => server.client,
      ),
      _releaseHeldMessage = _i11.ReleaseHeldMessage(
        server.baseUrl,
        () => server.client,
      ),
      _sendMessage = _i12.SendMessage(server.baseUrl, () => server.client),
      _getMessage = _i13.GetMessage(server.baseUrl, () => server.client),
      _deleteMessage = _i14.DeleteMessage(server.baseUrl, () => server.client),
      _updateMessage = _i15.UpdateMessage(server.baseUrl, () => server.client),
      _forwardMessage = _i16.ForwardMessage(
        server.baseUrl,
        () => server.client,
      ),
      _getRawMessage = _i17.GetRawMessage(server.baseUrl, () => server.client),
      _verifyMessageSeal = _i18.VerifyMessageSeal(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListMessages _listMessages;

  final _i3.ListHeldMessages _listHeldMessages;

  final _i4.ImportMessage _importMessage;

  final _i5.GetThread _getThread;

  final _i6.SetThreadDue _setThreadDue;

  final _i7.SnoozeThread _snoozeThread;

  final _i8.DeliverMessage _deliverMessage;

  final _i9.ListScheduledMessages _listScheduledMessages;

  final _i10.CancelScheduledMessage _cancelScheduledMessage;

  final _i11.ReleaseHeldMessage _releaseHeldMessage;

  final _i12.SendMessage _sendMessage;

  final _i13.GetMessage _getMessage;

  final _i14.DeleteMessage _deleteMessage;

  final _i15.UpdateMessage _updateMessage;

  final _i16.ForwardMessage _forwardMessage;

  final _i17.GetRawMessage _getRawMessage;

  final _i18.VerifyMessageSeal _verifyMessageSeal;

  /// List messages in a folder
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — A folder page is newest first, with the ID breaking equal-date ties:
  /// Production routes load real credential/holder ceilings and map fixed message rows. Complete results cover public message fields, JSON recipients/headers/calendar data, TLS true/false/unknown, null dates and body omissions; raw source and unloaded mailbox metadata are omitted. Controlled SQL proves wiring, not PostgreSQL filtering or ordering.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_html": "<p>Hello café</p>",
  ///       "body_text": "Hello café",
  ///       "calendar_events": [
  ///         {
  ///           "uid": "event-1"
  ///         }
  ///       ],
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": true,
  ///       "headers": {
  ///         "Subject": [
  ///           "Hello café"
  ///         ],
  ///         "X-Trace": [
  ///           "a",
  ///           "b"
  ///         ]
  ///       },
  ///       "id": 51,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": false,
  ///       "is_flagged": true,
  ///       "is_read": false,
  ///       "is_starred": true,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-51@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T02:00:00Z",
  ///       "received_tls": true,
  ///       "recipients_cc": [
  ///         "copy@example.net"
  ///       ],
  ///       "recipients_to": [
  ///         "recipient@example.net"
  ///       ],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "tls_version": "TLS1.3",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": false,
  ///       "id": 53,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": false,
  ///       "is_flagged": false,
  ///       "is_read": false,
  ///       "is_starred": false,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-53@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T01:00:00Z",
  ///       "recipients_cc": [],
  ///       "recipients_to": [],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": false,
  ///       "id": 52,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": true,
  ///       "is_flagged": false,
  ///       "is_read": true,
  ///       "is_starred": false,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-52@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T01:00:00Z",
  ///       "received_tls": false,
  ///       "recipients_cc": [],
  ///       "recipients_to": [],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "has_more": false,
  ///     "total": 3
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
  /// **Example** "key_wrong_scope":
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
  /// **Example** "count_unavailable" — A failed total-count query is not a successful page:
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
  _i19.Future<_i20.TonikResult<_i21.ListMessagesResponse, _i22.Response>>
  listMessages({
    required _i19.int id,
    required _i19.String folder,
    _i19.int? limit,
    _i19.String? cursor,
    _i19.bool? includeImapDeleted,
    _i20.TonikCancellation? cancellation,
  }) async => _listMessages(
    id: id,
    folder: folder,
    limit: limit,
    cursor: cursor,
    includeImapDeleted: includeImapDeleted,
    cancellation: cancellation,
  );

  /// List an account's retained send-limit holds
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "none_held" — An account with nothing held:
  /// ```json
  /// {
  ///   "data": []
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
  /// No account exists at the ID; an account the caller cannot read answers the same.
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
  _i19.Future<_i20.TonikResult<_i23.ListHeldMessagesResponse, _i22.Response>>
  listHeldMessages({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _listHeldMessages(id: id, cancellation: cancellation);

  /// Store a message the account already has
  /// Stores original message octets, folder, supported system flags and required internal_date without delivery rules or push notifications. Requires mail:import on the destination, which every account holds on its own mailbox. A message whose Message-ID and exact octets are already in that account and folder is skipped without changing its flags or date; the same Message-ID with different octets is stored as another message. Messages without Message-ID use a deterministic SHA-256 import identity; the raw source remains unchanged. Every attempt is audited; successful imports and skips also receive a transactional messages.import audit entry. The decoded message is bounded by SMTP_MAX_MESSAGE_SIZE (10 MiB by default); the general API body limit may be stricter. Deleted state and up to 100 case-insensitive keywords of 1–255 ASCII bytes are preserved. Keywords must be RFC 3501 atoms without backslash. Deleted messages use IMAP deletion state, not API tombstones; EXPUNGE removes them.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "api_key_ceiling":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "audit_failure":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "created":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "deleted":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Deleted"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "invalid_keyword":
  /// ```json
  /// {
  ///   "flags": [
  ///     "bad]keyword"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "keyword_too_long":
  /// ```json
  /// {
  ///   "flags": [
  ///     "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "keywords":
  /// ```json
  /// {
  ///   "flags": [
  ///     "$Custom"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "mailbox_full":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
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
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — Refused API keys exhaust the per-IP budget:
  /// Repeated refused API keys from one address spend the refusal budget of the API-key authentication middleware, which answers 429 with a positive Retry-After before the handler runs.
  ///
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "too_many_keywords":
  /// ```json
  /// {
  ///   "flags": [
  ///     "$keyword0",
  ///     "$keyword1",
  ///     "$keyword2",
  ///     "$keyword3",
  ///     "$keyword4",
  ///     "$keyword5",
  ///     "$keyword6",
  ///     "$keyword7",
  ///     "$keyword8",
  ///     "$keyword9",
  ///     "$keyword10",
  ///     "$keyword11",
  ///     "$keyword12",
  ///     "$keyword13",
  ///     "$keyword14",
  ///     "$keyword15",
  ///     "$keyword16",
  ///     "$keyword17",
  ///     "$keyword18",
  ///     "$keyword19",
  ///     "$keyword20",
  ///     "$keyword21",
  ///     "$keyword22",
  ///     "$keyword23",
  ///     "$keyword24",
  ///     "$keyword25",
  ///     "$keyword26",
  ///     "$keyword27",
  ///     "$keyword28",
  ///     "$keyword29",
  ///     "$keyword30",
  ///     "$keyword31",
  ///     "$keyword32",
  ///     "$keyword33",
  ///     "$keyword34",
  ///     "$keyword35",
  ///     "$keyword36",
  ///     "$keyword37",
  ///     "$keyword38",
  ///     "$keyword39",
  ///     "$keyword40",
  ///     "$keyword41",
  ///     "$keyword42",
  ///     "$keyword43",
  ///     "$keyword44",
  ///     "$keyword45",
  ///     "$keyword46",
  ///     "$keyword47",
  ///     "$keyword48",
  ///     "$keyword49",
  ///     "$keyword50",
  ///     "$keyword51",
  ///     "$keyword52",
  ///     "$keyword53",
  ///     "$keyword54",
  ///     "$keyword55",
  ///     "$keyword56",
  ///     "$keyword57",
  ///     "$keyword58",
  ///     "$keyword59",
  ///     "$keyword60",
  ///     "$keyword61",
  ///     "$keyword62",
  ///     "$keyword63",
  ///     "$keyword64",
  ///     "$keyword65",
  ///     "$keyword66",
  ///     "$keyword67",
  ///     "$keyword68",
  ///     "$keyword69",
  ///     "$keyword70",
  ///     "$keyword71",
  ///     "$keyword72",
  ///     "$keyword73",
  ///     "$keyword74",
  ///     "$keyword75",
  ///     "$keyword76",
  ///     "$keyword77",
  ///     "$keyword78",
  ///     "$keyword79",
  ///     "$keyword80",
  ///     "$keyword81",
  ///     "$keyword82",
  ///     "$keyword83",
  ///     "$keyword84",
  ///     "$keyword85",
  ///     "$keyword86",
  ///     "$keyword87",
  ///     "$keyword88",
  ///     "$keyword89",
  ///     "$keyword90",
  ///     "$keyword91",
  ///     "$keyword92",
  ///     "$keyword93",
  ///     "$keyword94",
  ///     "$keyword95",
  ///     "$keyword96",
  ///     "$keyword97",
  ///     "$keyword98",
  ///     "$keyword99",
  ///     "$keyword100"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "unavailable":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<history@example.test>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "deleted":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<history@example.test>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "keywords":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<history@example.test>"
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
  /// **Example** "api_key_ceiling":
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
  ///     "code": "mailbox_not_found",
  ///     "message": "Destination account not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "mailbox_full":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "mailbox_full",
  ///     "message": "The destination account has insufficient quota"
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_keyword":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "flags": "invalid keyword: expected an RFC 3501 atom without backslash"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "keyword_too_long":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "flags": "keyword must contain 1 to 255 ASCII bytes"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "too_many_keywords":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "flags": "at most 100 keywords per message"
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
  /// **Example** "audit_failure":
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
  /// **Example** "unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i19.Future<_i20.TonikResult<_i24.ImportMessageResponse, _i22.Response>>
  importMessage({
    required _i25.ImportMessageBody body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _importMessage(body: body, id: id, cancellation: cancellation);

  /// Get all messages in a thread
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — A thread is read at its escaped identity in chronological order:
  /// Production routes load real credential/holder ceilings and map fixed message rows. Complete results cover public message fields, JSON recipients/headers/calendar data, TLS true/false/unknown, null dates and body omissions; raw source and unloaded mailbox metadata are omitted. Controlled SQL proves wiring, not PostgreSQL filtering or ordering.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": false,
  ///       "id": 52,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": true,
  ///       "is_flagged": false,
  ///       "is_read": true,
  ///       "is_starred": false,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-52@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T01:00:00Z",
  ///       "received_tls": false,
  ///       "recipients_cc": [],
  ///       "recipients_to": [],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": false,
  ///       "id": 53,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": false,
  ///       "is_flagged": false,
  ///       "is_read": false,
  ///       "is_starred": false,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-53@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T01:00:00Z",
  ///       "recipients_cc": [],
  ///       "recipients_to": [],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "body_html": "<p>Hello café</p>",
  ///       "body_text": "Hello café",
  ///       "calendar_events": [
  ///         {
  ///           "uid": "event-1"
  ///         }
  ///       ],
  ///       "class": "person",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
  ///       "downgraded_size": 0,
  ///       "folder": "INBOX",
  ///       "has_attachments": true,
  ///       "headers": {
  ///         "Subject": [
  ///           "Hello café"
  ///         ],
  ///         "X-Trace": [
  ///           "a",
  ///           "b"
  ///         ]
  ///       },
  ///       "id": 51,
  ///       "in_reply_to": "<parent@example.net>",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": false,
  ///       "is_flagged": true,
  ///       "is_read": false,
  ///       "is_starred": true,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message-51@example.net>",
  ///       "raw_size": 128,
  ///       "received_at": "2026-10-20T02:00:00Z",
  ///       "received_tls": true,
  ///       "recipients_cc": [
  ///         "copy@example.net"
  ///       ],
  ///       "recipients_to": [
  ///         "recipient@example.net"
  ///       ],
  ///       "references": "<parent@example.net>",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender café",
  ///       "size_bytes": 80,
  ///       "subject": "Subject café",
  ///       "thread_id": "thread/2026@example.net",
  ///       "tls_version": "TLS1.3",
  ///       "updated_at": "2026-10-20T00:00:00Z"
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
  /// **Example** "key_wrong_scope":
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
  _i19.Future<_i20.TonikResult<_i26.GetThreadResponse, _i22.Response>>
  getThread({
    required _i19.int id,
    required _i19.String threadId,
    _i20.TonikCancellation? cancellation,
  }) async =>
      _getThread(id: id, threadId: threadId, cancellation: cancellation);

  /// Set or clear a thread's due date
  /// Stores an account-scoped user-set due date without changing message order or folders. Send an RFC 3339 due date-time, or null to clear both due and due_source. due_source must be user; rule and parsed are reserved for future work. Unknown threads and threads outside this account are 404.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "clear":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": null,
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "malformed_date":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": "tomorrow",
  ///   "due_source": "user"
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
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "set":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "source_parsed":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "parsed"
  /// }
  /// ```
  ///
  /// **Example** "source_rule":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "rule"
  /// }
  /// ```
  ///
  /// **Example** "thread_missing":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "due": null,
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "due": "2026-12-01T10:00:00Z",
  ///   "due_source": "user"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "clear":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "due": null,
  ///     "due_source": null,
  ///     "thread_id": "<due/2026@example.net>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "set":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "due": "2026-12-01T10:00:00Z",
  ///     "due_source": "user",
  ///     "thread_id": "<due/2026@example.net>"
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
  /// **Example** "thread_missing":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Thread not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
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
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
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
  /// **Example** "malformed_date":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "due": "must be a valid date-time"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "source_parsed":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "due_source": "must be one of \"user\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "source_rule":
  /// Production routes enforce live account access and mail:write, validate the user source and persist account/thread state. Separate PostgreSQL tests prove durability, isolation, unchanged order and folders.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "due_source": "must be one of \"user\""
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
  _i19.Future<_i20.TonikResult<_i27.SetThreadDueResponse, _i22.Response>>
  setThreadDue({
    required _i28.ApiV1AccountsIdThreadsThreadIdDuePostBodyBodyModel body,
    required _i19.int id,
    required _i19.String threadId,
    _i20.TonikCancellation? cancellation,
  }) async => _setThreadDue(
    body: body,
    id: id,
    threadId: threadId,
    cancellation: cancellation,
  );

  /// Snooze a thread or cancel its snooze
  /// Hides every message in this account's thread from folder listings without changing messages or search results. A future snoozed_until sets or replaces the durable deadline; null cancels it. The existing background worker returns due threads at startup and within 30 seconds of their deadline, publishing folder_update to the account's event streams.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "cancelled":
  /// ```json
  /// {
  ///   "snoozed_until": null
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
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
  /// **Example** "malformed_time":
  /// ```json
  /// {
  ///   "snoozed_until": "tomorrow"
  /// }
  /// ```
  ///
  /// **Example** "no_grants":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "past":
  /// ```json
  /// {
  ///   "snoozed_until": "2000-01-01T00:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
  ///
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "snoozed":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "snoozed_until_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "snoozed_until_wrong_type":
  /// ```json
  /// {
  ///   "snoozed_until": 12345
  /// }
  /// ```
  ///
  /// **Example** "thread_missing":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "snoozed_until": "2099-01-01T10:00:00Z"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "cancelled":
  /// ```json
  /// {
  ///   "data": {
  ///     "snoozed_until": null,
  ///     "thread_id": "<thread/2026@example.net>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "snoozed":
  /// ```json
  /// {
  ///   "data": {
  ///     "snoozed_until": "2099-01-01T10:00:00Z",
  ///     "thread_id": "<thread/2026@example.net>"
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
  /// **Example** "thread_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Thread not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "request_too_large":
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
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
  /// Real transport and path binding are exercised. The JSON body is valid; invalid-body flags do not describe path validation. The test cap is512 bytes; oversize hook sends513 bytes.
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
  /// **Example** "malformed_time":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "snoozed_until": "must be a date-time"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "past":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "snoozed_until": "must be in the future"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "snoozed_until_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "snoozed_until": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "snoozed_until_wrong_type":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "snoozed_until": "must be a date-time"
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
  _i19.Future<_i20.TonikResult<_i29.SnoozeThreadResponse, _i22.Response>>
  snoozeThread({
    required _i30.ApiV1AccountsIdThreadsThreadIdSnoozePostBodyBodyModel body,
    required _i19.int id,
    required _i19.String threadId,
    _i20.TonikCancellation? cancellation,
  }) async => _snoozeThread(
    body: body,
    id: id,
    threadId: threadId,
    cancellation: cancellation,
  );

  /// Deliver a message into a mailbox (protocol gateways)
  /// Machine to machine: no user token. The inbound pipeline decides: 201 with the message made, 200 processed when it quarantined or discarded it, 550 rejected, 451 deferred, 422 mailbox_full over quota. A missing mailbox is 404; a failed mailbox lookup is 500, never a missing recipient.
  ///
  /// Request body (application/json):
  /// **Example** "address_empty" — The address is empty:
  /// An empty address names no mailbox, so the body names none.
  ///
  /// ```json
  /// {
  ///   "address": ""
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "deferred" — The pipeline defers the message:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// **Example** "delivered" — Delivered into the mailbox:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Subject"
  /// }
  /// ```
  ///
  /// **Example** "folder_invalid" — The folder name is refused:
  /// A name the folder rule refuses is 422 on folder, behind the gateway's own check.
  ///
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "folder": " Archive",
  ///   "sender": "sender@example.net",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Subject"
  /// }
  /// ```
  ///
  /// **Example** "mailbox_id_zero" — The mailbox id is zero:
  /// Zero names no mailbox, so the body names none.
  ///
  /// ```json
  /// {
  ///   "mailbox_id": 0
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — The body is not JSON:
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "no_mailbox" — No mailbox has that address:
  /// ```json
  /// {
  ///   "address": "nobody@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// **Example** "no_mailbox_by_id" — No mailbox has that id:
  /// A well-formed id that names nothing is 404, as an address that names nothing is.
  ///
  /// ```json
  /// {
  ///   "mailbox_id": 2147483647
  /// }
  /// ```
  ///
  /// **Example** "processed" — The inbound pipeline quarantines or discards it:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// **Example** "recipient_missing" — The body names no mailbox:
  /// Neither mailbox_id nor address is there.
  ///
  /// ```json
  /// {
  ///   "body_text": "Hello",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// **Example** "rejected" — The pipeline rejects the message:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "body_text": "Hello",
  ///   "sender": "sender@example.net",
  ///   "subject": "Hello"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "processed" — The inbound pipeline quarantines or discards it:
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "processed"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "delivered" — Delivered into the mailbox:
  /// ```json
  /// {
  ///   "data": {
  ///     "class": "person",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": "2026-10-20T00:00:00Z",
  ///     "downgraded_size": 137,
  ///     "folder": "INBOX",
  ///     "has_attachments": false,
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender",
  ///     "size_bytes": 80,
  ///     "subject": "Subject",
  ///     "thread_id": "",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — The body is not JSON:
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
  /// Response 404 (application/json):
  /// **Example** "no_mailbox" — No mailbox has that address:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "mailbox_not_found",
  ///     "message": "Mailbox not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "no_mailbox_by_id" — No mailbox has that id:
  /// A well-formed id that names nothing is 404, as an address that names nothing is.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "mailbox_not_found",
  ///     "message": "Mailbox not found"
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
  /// **Example** "address_empty" — The address is empty:
  /// An empty address names no mailbox, so the body names none.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "mailbox_id or address required"
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
  /// **Example** "folder_invalid" — The folder name is refused:
  /// A name the folder rule refuses is 422 on folder, behind the gateway's own check.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "folder": "must not begin or end with a space"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_id_zero" — The mailbox id is zero:
  /// Zero names no mailbox, so the body names none.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "mailbox_id or address required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "recipient_missing" — The body names no mailbox:
  /// Neither mailbox_id nor address is there.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "address": "mailbox_id or address required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 451 (application/json):
  /// **Example** "deferred" — The pipeline defers the message:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "deferred",
  ///     "message": "Try again later"
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
  ///     "message": "Failed to look up mailbox"
  ///   }
  /// }
  /// ```
  ///
  /// Response 550 (application/json):
  /// **Example** "rejected" — The pipeline rejects the message:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "rejected",
  ///     "message": "Message rejected by policy"
  ///   }
  /// }
  /// ```
  _i19.Future<_i20.TonikResult<_i31.DeliverMessageResponse, _i22.Response>>
  deliverMessage({
    required _i32.DeliverMessageBody body,
    _i20.TonikCancellation? cancellation,
  }) async => _deliverMessage(body: body, cancellation: cancellation);

  /// List the messages waiting to be sent
  /// The account's waiting sends that the session may send using their stored mode (mail:send, mail:send_as or mail:send_on_behalf); the others are left out.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — Waiting sends are filtered by current send-as permission, retaining soonest-first order:
  /// The real query restricts the owner and pending/sending states. A fourth row from an unpermitted sender is hidden. The complete public mapping retains attempts and optional last error, normalizes absent recipients to [], and excludes the private replay request. Fixed SQL rows prove wiring, not PostgreSQL filtering/ordering, scheduler delivery or persistence.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "account_id": 10,
  ///       "attempts": 0,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "from": "user@example.com",
  ///       "id": 51,
  ///       "scheduled_at": "2026-10-27T00:00:00Z",
  ///       "status": "pending",
  ///       "subject": "Send café",
  ///       "to": [
  ///         "recipient@example.net"
  ///       ],
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "account_id": 10,
  ///       "attempts": 2,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "from": "linked@example.com",
  ///       "id": 52,
  ///       "last_error": "Delivery deferred",
  ///       "scheduled_at": "2026-10-27T01:00:00Z",
  ///       "status": "sending",
  ///       "subject": "Send café",
  ///       "to": [
  ///         "recipient@example.net"
  ///       ],
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     {
  ///       "account_id": 10,
  ///       "attempts": 0,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "from": "linked@example.com",
  ///       "id": 53,
  ///       "scheduled_at": "2026-10-27T02:00:00Z",
  ///       "status": "pending",
  ///       "subject": "Send café",
  ///       "to": [],
  ///       "updated_at": "2026-10-20T00:00:00Z"
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
  /// **Example** "grant_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list scheduled messages"
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
  _i19.Future<
    _i20.TonikResult<_i33.ListScheduledMessagesResponse, _i22.Response>
  >
  listScheduledMessages({_i20.TonikCancellation? cancellation}) async =>
      _listScheduledMessages(cancellation: cancellation);

  /// Cancel a scheduled message
  /// A waiting send the session may not send using its stored mode is not found, as the list leaves it out. Lookup, authorization and cancellation update follow request cancellation.
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
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
  ///     "message": "Failed to cancel the scheduled message"
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
  _i19.Future<
    _i20.TonikResult<_i34.CancelScheduledMessageResponse, _i22.Response>
  >
  cancelScheduledMessage({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _cancelScheduledMessage(id: id, cancellation: cancellation);

  /// Release held mail with a two-factor session
  /// Requires a two-factor person session, mailbox:manage on the submitting account and mail:send on the sender. Releases one retained message, bypassing account budgets for this deliberate send while still charging them. Domain/server budgets, live sender permissions and outbound policies remain enforced. Returns the retained record: 200 after release, or 202 if budgets or policies defer and keep the same hold. Concurrent releases cannot send twice. The real releasing actor/session and original submitting account are audited.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "released" — A person with a second factor sends the held message:
  /// ```json
  /// {
  ///   "data": {
  ///     "account_id": 1,
  ///     "attempts": 0,
  ///     "created_at": "2026-10-31T00:10:00Z",
  ///     "from": "chris@example.test",
  ///     "id": 3,
  ///     "scheduled_at": "2026-10-31T01:00:00Z",
  ///     "sent_message_id": 9,
  ///     "status": "sent",
  ///     "subject": "Quarterly report",
  ///     "to": [
  ///       "bob@example.org"
  ///     ],
  ///     "updated_at": "2026-10-31T00:10:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 202 (application/json):
  /// **Example** "still_held" — The domain's budget is spent too, so the message stays held:
  /// ```json
  /// {
  ///   "data": {
  ///     "account_id": 1,
  ///     "attempts": 0,
  ///     "created_at": "2026-10-31T00:10:00Z",
  ///     "from": "chris@example.test",
  ///     "id": 3,
  ///     "last_error": "domain:1: messages_per_hour",
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
  /// **Example** "without_two_factor" — A session without a second factor cannot release held mail:
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
  /// Nothing is retained at the ID; mail of an account the caller cannot manage answers the same.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "not_held" — The scheduled message is not held by a send limit:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_held",
  ///     "message": "The message is not held"
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
  _i19.Future<_i20.TonikResult<_i35.ReleaseHeldMessageResponse, _i22.Response>>
  releaseHeldMessage({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _releaseHeldMessage(id: id, cancellation: cancellation);

  /// Send a message
  /// Sent at once (201), or with scheduled_at stored and sent then (202); the outbound pipeline may discard it (200). Sending from your own mailbox requires mail:send. From another mailbox requires mail:send_as on that mailbox. Set on_behalf to true to require mail:send_on_behalf instead: From stays the represented mailbox and RFC 5322 Sender is the authenticated account's own address. Read access grants neither mode. Both modes audit the real account, credential and represented mailbox.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "discarded" — The outbound pipeline discards it:
  /// ```json
  /// {
  ///   "body_text": "Hello",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "foreign_sender" — The caller cannot send as that address:
  /// ```json
  /// {
  ///   "body_text": "Hello",
  ///   "from": "someone@other.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "from_missing":
  /// The description requires from, as the handler does after authentication and before sender lookup. Its existing validation order and field error are unchanged.
  ///
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
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
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "read_only_send_as" — Delegated read only send as:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "shared@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "read_only_send_on_behalf" — Delegated read only send on behalf:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "shared@restmail.test",
  ///   "on_behalf": true,
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "scheduled" — Held to send at scheduled_at:
  /// ```json
  /// {
  ///   "body_text": "Hello",
  ///   "from": "admin@restmail.test",
  ///   "scheduled_at": "2026-10-27T00:00:00Z",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "send_as" — Delegated send as:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "shared@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "send_on_behalf" — Delegated send on behalf:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "shared@restmail.test",
  ///   "on_behalf": true,
  ///   "subject": "Hello",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unsubscribe_not_allowed":
  /// A schema-valid request from admin@restmail.test, whose domain has transactional sending policy, is refused by that stored policy. This is not schema invalidity.
  ///
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "list_unsubscribe": {
  ///     "mailto": "unsubscribe@restmail.test"
  ///   },
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "body_text": "Sent through the REST API.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Hello",
  ///   "to": [
  ///     "admin@restmail.test",
  ///     "someone@imap.restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "discarded" — The outbound pipeline discards it:
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "discarded"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "send_as" — Delegated send as:
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Sent through the REST API.",
  ///     "class": "person",
  ///     "created_at": "2026-10-21T12:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 297,
  ///     "folder": "Sent",
  ///     "has_attachments": false,
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 2,
  ///     "message_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "raw_size": 297,
  ///     "received_at": "2026-10-21T12:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.net"
  ///     ],
  ///     "references": "",
  ///     "sealed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "sender": "shared@restmail.test",
  ///     "sender_name": "",
  ///     "size_bytes": 31,
  ///     "subject": "Hello",
  ///     "thread_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "updated_at": "2026-10-21T12:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "send_on_behalf" — Delegated send on behalf:
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Sent through the REST API.",
  ///     "class": "person",
  ///     "created_at": "2026-10-21T12:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 297,
  ///     "folder": "Sent",
  ///     "has_attachments": false,
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 2,
  ///     "message_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "raw_size": 297,
  ///     "received_at": "2026-10-21T12:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.net"
  ///     ],
  ///     "references": "",
  ///     "sealed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "sender": "shared@restmail.test",
  ///     "sender_name": "",
  ///     "size_bytes": 31,
  ///     "subject": "Hello",
  ///     "thread_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "updated_at": "2026-10-21T12:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Sent through the REST API.",
  ///     "class": "person",
  ///     "created_at": "2026-10-21T12:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 297,
  ///     "folder": "Sent",
  ///     "has_attachments": false,
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "raw_size": 297,
  ///     "received_at": "2026-10-21T12:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "admin@restmail.test",
  ///       "someone@imap.restmail.test"
  ///     ],
  ///     "references": "",
  ///     "sealed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "sender": "admin@restmail.test",
  ///     "sender_name": "",
  ///     "size_bytes": 31,
  ///     "subject": "Hello",
  ///     "thread_id": "<00000000-0000-4000-8000-000000000001@restmail.test>",
  ///     "updated_at": "2026-10-21T12:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 202 (application/json):
  /// **Example** "scheduled" — Held to send at scheduled_at:
  /// ```json
  /// {
  ///   "data": {
  ///     "account_id": 1,
  ///     "attempts": 0,
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "from": "admin@restmail.test",
  ///     "id": 51,
  ///     "scheduled_at": "2026-10-27T00:00:00Z",
  ///     "status": "pending",
  ///     "subject": "Hello",
  ///     "to": [
  ///       "recipient@example.net"
  ///     ],
  ///     "updated_at": "2026-10-20T00:00:00Z"
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
  /// **Example** "foreign_sender" — The caller cannot send as that address:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "You are not authorized to send from this address"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only_send_as" — Delegated read only send as:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "You are not authorized to send from this address"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_only_send_on_behalf" — Delegated read only send on behalf:
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
  /// **Example** "from_missing":
  /// The description requires from, as the handler does after authentication and before sender lookup. Its existing validation order and field error are unchanged.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "from": "from is required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unsubscribe_not_allowed":
  /// A schema-valid request from admin@restmail.test, whose domain has transactional sending policy, is refused by that stored policy. This is not schema invalidity.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "list_unsubscribe_not_allowed",
  ///     "message": "The sender domain sends transactional mail, which carries no List-Unsubscribe field: omit list_unsubscribe"
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
  _i19.Future<_i20.TonikResult<_i36.SendMessageResponse, _i22.Response>>
  sendMessage({
    required _i37.SendMessageDescription body,
    _i20.TonikCancellation? cancellation,
  }) async => _sendMessage(body: body, cancellation: cancellation);

  /// Get a message by ID
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "classification_newsletter":
  /// Classification is derived on read from the stored headers and any class a Sieve rule recorded at delivery. Only newsletter is list-shaped; person is never hidden. Without a rule, receipts are not told apart: they use newsletter when list-shaped, notification when automated, otherwise person.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "class": "newsletter",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "List-Id": [
  ///         "<news.example.test>"
  ///       ]
  ///     },
  ///     "id": 101,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "received_tls": true,
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender café",
  ///     "size_bytes": 80,
  ///     "subject": "Subject café",
  ///     "thread_id": "",
  ///     "tls_version": "TLS1.3",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "classification_notification":
  /// Classification is derived on read from the stored headers and any class a Sieve rule recorded at delivery. Only newsletter is list-shaped; person is never hidden. Without a rule, receipts are not told apart: they use newsletter when list-shaped, notification when automated, otherwise person.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "class": "notification",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "Auto-Submitted": [
  ///         "auto-generated"
  ///       ]
  ///     },
  ///     "id": 102,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "received_tls": true,
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender café",
  ///     "size_bytes": 80,
  ///     "subject": "Subject café",
  ///     "thread_id": "",
  ///     "tls_version": "TLS1.3",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "classification_receipt_rule":
  /// A Sieve rule added the $receipt keyword at delivery, and that wins over the list header. No header says a message is a receipt, so this is the only way mail gets this class. A receipt never collapses.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "class": "receipt",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "List-Id": [
  ///         "<shop.example.test>"
  ///       ]
  ///     },
  ///     "id": 103,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "received_tls": true,
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender café",
  ///     "size_bytes": 80,
  ///     "subject": "Subject café",
  ///     "thread_id": "",
  ///     "tls_version": "TLS1.3",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "classification_source_headers":
  /// Delivery stored the source and no decoded headers, so the class comes from the source header section, unfolded, without reading the body.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "class": "newsletter",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "id": 104,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 78,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "received_tls": true,
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender café",
  ///     "size_bytes": 80,
  ///     "subject": "Subject café",
  ///     "thread_id": "",
  ///     "tls_version": "TLS1.3",
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// The production message lookup, credential verification and current holder ceilings are used. Controlled SQL proves wiring, not PostgreSQL semantics or audit persistence. JSON omits raw source and unloaded mailboxes; the source route preserves every octet, repeated headers, CRLF, UTF-8 and a leading dot.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "class": "person",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "downgraded_size": 0,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "received_tls": true,
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender café",
  ///     "size_bytes": 80,
  ///     "subject": "Subject café",
  ///     "thread_id": "",
  ///     "tls_version": "TLS1.3",
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
  /// **Example** "key_wrong_scope":
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
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
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
  _i19.Future<_i20.TonikResult<_i38.GetMessageResponse, _i22.Response>>
  getMessage({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _getMessage(id: id, cancellation: cancellation);

  /// Delete a message
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
  /// **Example** "key_wrong_scope":
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
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
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
  _i19.Future<_i20.TonikResult<_i39.DeleteMessageResponse, _i22.Response>>
  deleteMessage({
    required _i19.int id,
    _i19.String? permanent,
    _i20.TonikCancellation? cancellation,
  }) async =>
      _deleteMessage(id: id, permanent: permanent, cancellation: cancellation);

  /// Update message flags or move to a folder
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "flags_set" — The message is marked read and flagged:
  /// The answer is the message as stored, read back in the change's own transaction; flags left out of the body keep their value.
  ///
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "is_read": true
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
  /// **Example** "missing" — No such message:
  /// ```json
  /// {
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "read_only" — The caller does not reach the message's mailbox:
  /// ```json
  /// {
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "flags_set" — The message is marked read and flagged:
  /// The answer is the message as stored, read back in the change's own transaction; flags left out of the body keep their value.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "calendar_events": [],
  ///     "class": "person",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": "2026-10-20T00:00:00Z",
  ///     "downgraded_size": 137,
  ///     "folder": "INBOX",
  ///     "has_attachments": false,
  ///     "headers": {
  ///       "Subject": [
  ///         "Subject"
  ///       ]
  ///     },
  ///     "id": 1,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": true,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 137,
  ///     "received_at": "2026-10-20T00:00:00Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "recipient@example.com"
  ///     ],
  ///     "references": "",
  ///     "sealed_hash": "00ced91ef87007eb619fe4d649ec941257846db0f6aa30fcea744c76902a3eea",
  ///     "sender": "sender@example.net",
  ///     "sender_name": "Sender",
  ///     "size_bytes": 80,
  ///     "subject": "Subject",
  ///     "thread_id": "",
  ///     "updated_at": "2026-10-21T09:30:00Z"
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
  /// **Example** "read_only" — The caller does not reach the message's mailbox:
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
  /// **Example** "missing" — No such message:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
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
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
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
  _i19.Future<_i20.TonikResult<_i40.UpdateMessageResponse, _i22.Response>>
  updateMessage({
    required _i41.UpdateMessageBody body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _updateMessage(body: body, id: id, cancellation: cancellation);

  /// Forward a message
  /// The message (mail:read) is forwarded through the normal sender authorization, rate limit and outbound policy, with Fwd: and the note above its original header. Stored attachments, including empty and inline parts, are re-attached; the Sent copy owns independent attachment objects. The final signed MIME message is bounded by SMTP_MAX_MESSAGE_SIZE, and sender quota includes the copied parts. Sent, attachment references, quota and recipient work commit together. Unavailable or changed source objects fail the forward instead of dropping parts. Sending from your own mailbox requires mail:send. From another mailbox requires mail:send_as on that mailbox. Set on_behalf to true to require mail:send_on_behalf instead: From stays the represented mailbox and RFC 5322 Sender is the authenticated account's own address. Read access grants neither mode. Both modes audit the real account, credential and represented mailbox.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "attachment_write_failed":
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "capability_removed":
  /// Message 12 belongs to the signed-in account 1 (admin@restmail.test). It is a draft for draft operations. The server capability ceiling permits mailbox:session but not mail:write or mail:read. The account can know its own mailbox exists, so refusal is 403, not a foreign-resource 404.
  ///
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "discarded" — The outbound pipeline discards it:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "body_text": "See below.",
  ///   "from": "admin@restmail.test",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "held" — Held by a spent send limit until a person releases it:
  /// ```json
  /// {
  ///   "body_text": "See below.",
  ///   "from": "chris@example.test",
  ///   "to": [
  ///     "bob@example.org"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "mailbox_full":
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
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
  /// **Example** "mime_too_large":
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "missing" — No such message:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "to": [
  ///     "recipient@example.net"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "not_authorized":
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated":
  /// ```json
  /// {
  ///   "body_text": "please review",
  ///   "from": "sender@example.test",
  ///   "to": [
  ///     "target@remote.test"
  ///   ]
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "discarded" — The outbound pipeline discards it:
  /// ```json
  /// {
  ///   "data": {
  ///     "status": "discarded"
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
  ///     "subject": "Fwd: Quarterly report",
  ///     "to": [
  ///       "bob@example.org"
  ///     ],
  ///     "updated_at": "2026-10-31T00:10:00Z"
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
  /// **Example** "capability_removed":
  /// Message 12 belongs to the signed-in account 1 (admin@restmail.test). It is a draft for draft operations. The server capability ceiling permits mailbox:session but not mail:write or mail:read. The account can know its own mailbox exists, so refusal is 403, not a foreign-resource 404.
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
  /// **Example** "missing" — No such message:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "not_authorized":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 413 (application/json):
  /// **Example** "mime_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_too_large",
  ///     "message": "The forwarded message exceeds the message size limit"
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
  /// **Example** "mailbox_full":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "mailbox_full",
  ///     "message": "The sender account has insufficient quota"
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
  /// **Example** "attachment_write_failed":
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
  _i19.Future<_i20.TonikResult<_i42.ForwardMessageResponse, _i22.Response>>
  forwardMessage({
    required _i43.ForwardBody body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _forwardMessage(body: body, id: id, cancellation: cancellation);

  /// Get the raw RFC 2822 message source
  /// The message as it arrived, headers and all. 404 not_found when no source was kept.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (message/rfc822):
  /// **Example** "found":
  /// The production message lookup, credential verification and current holder ceilings are used. Controlled SQL proves wiring, not PostgreSQL semantics or audit persistence. JSON omits raw source and unloaded mailboxes; the source route preserves every octet, repeated headers, CRLF, UTF-8 and a leading dot.
  ///
  /// ```
  /// From: sender@example.net
  /// To: recipient@example.com
  /// Subject: café
  /// X-Trace: one
  /// X-Trace: two
  ///
  /// Hello café
  /// .No dot unstuffing here
  ///
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
  /// **Example** "key_wrong_scope":
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
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
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
  _i19.Future<_i20.TonikResult<_i44.GetRawMessageResponse, _i22.Response>>
  getRawMessage({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _getRawMessage(id: id, cancellation: cancellation);

  /// Verify a message's receipt seal
  /// Compares the stored receipt seal with the current source, headers and bodies, without changing the seal. intact means unchanged since this server accepted it, not who wrote it or whether it is safe. not_sealed is distinct from mismatch; historical messages are never backfilled. Uses the same mail:read authorization as reading the message. See docs/message-seals.md for the streaming restmail-seal-v1 algorithm and byte framing.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "intact":
  /// Receipt integrity is independent of sender authentication and does not establish safety. Source and stored display fields are checked; no historical backfill.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "algorithm": "restmail-seal-v1",
  ///     "computed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "sealed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "state": "intact"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mismatch":
  /// Receipt integrity is independent of sender authentication and does not establish safety. Source and stored display fields are checked; no historical backfill.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "algorithm": "restmail-seal-v1",
  ///     "computed_hash": "6f04bba035151f7cb8ee4cf1102126d259979e7822f364143192e2339ab31259",
  ///     "sealed_hash": "c8df0e809a88268049a3d046bf4c17819b16cbf2e5d3845e15368a251710bfb2",
  ///     "state": "mismatch"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "not_sealed":
  /// Receipt integrity is independent of sender authentication and does not establish safety. Source and stored display fields are checked; no historical backfill.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "algorithm": "restmail-seal-v1",
  ///     "state": "not_sealed"
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
  /// Response 404 (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_not_found",
  ///     "message": "Message not found"
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
  _i19.Future<_i20.TonikResult<_i45.VerifyMessageSealResponse, _i22.Response>>
  verifyMessageSeal({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => _verifyMessageSeal(id: id, cancellation: cancellation);
}
