// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i13;

import 'package:http/http.dart' as _i16;
import 'package:restmail_generated/src/model/deliver_message_body.dart' as _i19;
import 'package:restmail_generated/src/model/forward_body.dart' as _i29;
import 'package:restmail_generated/src/model/send_message_request.dart' as _i23;
import 'package:restmail_generated/src/model/update_message_body.dart' as _i27;
import 'package:restmail_generated/src/operation/cancel_scheduled_message.dart'
    as _i6;
import 'package:restmail_generated/src/operation/delete_message.dart' as _i9;
import 'package:restmail_generated/src/operation/deliver_message.dart' as _i4;
import 'package:restmail_generated/src/operation/forward_message.dart' as _i11;
import 'package:restmail_generated/src/operation/get_message.dart' as _i8;
import 'package:restmail_generated/src/operation/get_raw_message.dart' as _i12;
import 'package:restmail_generated/src/operation/get_thread.dart' as _i3;
import 'package:restmail_generated/src/operation/list_messages.dart' as _i2;
import 'package:restmail_generated/src/operation/list_scheduled_messages.dart'
    as _i5;
import 'package:restmail_generated/src/operation/send_message.dart' as _i7;
import 'package:restmail_generated/src/operation/update_message.dart' as _i10;
import 'package:restmail_generated/src/response_wrapper/cancel_scheduled_message_response.dart'
    as _i21;
import 'package:restmail_generated/src/response_wrapper/delete_message_response.dart'
    as _i25;
import 'package:restmail_generated/src/response_wrapper/deliver_message_response.dart'
    as _i18;
import 'package:restmail_generated/src/response_wrapper/forward_message_response.dart'
    as _i28;
import 'package:restmail_generated/src/response_wrapper/get_message_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/get_raw_message_response.dart'
    as _i30;
import 'package:restmail_generated/src/response_wrapper/get_thread_response.dart'
    as _i17;
import 'package:restmail_generated/src/response_wrapper/list_messages_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/list_scheduled_messages_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/send_message_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/update_message_response.dart'
    as _i26;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i14;

class MessagesApi {
  MessagesApi(_i1.Server server)
    : _listMessages = _i2.ListMessages(server.baseUrl, () => server.client),
      _getThread = _i3.GetThread(server.baseUrl, () => server.client),
      _deliverMessage = _i4.DeliverMessage(server.baseUrl, () => server.client),
      _listScheduledMessages = _i5.ListScheduledMessages(
        server.baseUrl,
        () => server.client,
      ),
      _cancelScheduledMessage = _i6.CancelScheduledMessage(
        server.baseUrl,
        () => server.client,
      ),
      _sendMessage = _i7.SendMessage(server.baseUrl, () => server.client),
      _getMessage = _i8.GetMessage(server.baseUrl, () => server.client),
      _deleteMessage = _i9.DeleteMessage(server.baseUrl, () => server.client),
      _updateMessage = _i10.UpdateMessage(server.baseUrl, () => server.client),
      _forwardMessage = _i11.ForwardMessage(
        server.baseUrl,
        () => server.client,
      ),
      _getRawMessage = _i12.GetRawMessage(server.baseUrl, () => server.client);

  final _i2.ListMessages _listMessages;

  final _i3.GetThread _getThread;

  final _i4.DeliverMessage _deliverMessage;

  final _i5.ListScheduledMessages _listScheduledMessages;

  final _i6.CancelScheduledMessage _cancelScheduledMessage;

  final _i7.SendMessage _sendMessage;

  final _i8.GetMessage _getMessage;

  final _i9.DeleteMessage _deleteMessage;

  final _i10.UpdateMessage _updateMessage;

  final _i11.ForwardMessage _forwardMessage;

  final _i12.GetRawMessage _getRawMessage;

  /// List messages in a folder
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
  ///       "body_html": "<p>Hello café</p>",
  ///       "body_text": "Hello café",
  ///       "calendar_events": [
  ///         {
  ///           "uid": "event-1"
  ///         }
  ///       ],
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  /// **Example** "blank_cursor":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "cookie_session":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "default_limit":
  /// An out-of-range limit retains the documented default of 50.
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "domain_grant":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "empty":
  /// ```json
  /// {
  ///   "data": [],
  ///   "pagination": {
  ///     "has_more": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "encoded_folder" — Escaped hierarchy delimiters and UTF-8 reach the real folder lookup:
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
  ///       "folder": "Projects/2026 café",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "folder": "Projects/2026 café",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
  ///       "folder": "Projects/2026 café",
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
  /// **Example** "first_page":
  /// The next cursor carries both date and ID. The older rows have IDs above the newest row, so an ID-only cut would skip them.
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///   ],
  ///   "pagination": {
  ///     "cursor": "eyJyZWNlaXZlZF9hdCI6IjIwMjYtMTAtMjBUMDI6MDA6MDBaIiwiaWQiOjUxfQ==",
  ///     "has_more": true,
  ///     "total": 3
  ///   }
  /// }
  /// ```
  ///
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "invalid_cursor":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "key_domain":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "key_read":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "last_page":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "max_limit":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "next_page":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///     }
  ///   ],
  ///   "pagination": {
  ///     "cursor": "eyJyZWNlaXZlZF9hdCI6IjIwMjYtMTAtMjBUMDE6MDA6MDBaIiwiaWQiOjUzfQ==",
  ///     "has_more": true,
  ///     "total": 3
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "partial_cursor":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  /// **Example** "primary":
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  /// **Example** "unknown_folder":
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
  /// **Example** "key_holder_missing":
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
  /// **Example** "missing":
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
  /// **Example** "content_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list messages"
  ///   }
  /// }
  /// ```
  ///
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
  _i13.Future<_i14.TonikResult<_i15.ListMessagesResponse, _i16.Response>>
  listMessages({
    required _i13.int id,
    required _i13.String folder,
    _i13.int? limit,
    _i13.String? cursor,
    _i14.TonikCancellation? cancellation,
  }) async => _listMessages(
    id: id,
    folder: folder,
    limit: limit,
    cursor: cursor,
    cancellation: cancellation,
  );

  /// Get all messages in a thread
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
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "mailbox_id": 10,
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
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  /// **Example** "empty":
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "found" — A thread is read at its escaped identity in chronological order:
  /// Production routes load real credential/holder ceilings and map fixed message rows. Complete results cover public message fields, JSON recipients/headers/calendar data, TLS true/false/unknown, null dates and body omissions; raw source and unloaded mailbox metadata are omitted. Controlled SQL proves wiring, not PostgreSQL filtering or ordering.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "body_text": "Plain delivery",
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": null,
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
  ///       "mailbox_id": 10,
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
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
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
  ///       "mailbox_id": 10,
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
  /// **Example** "unknown_thread" — An unknown thread on an accessible account is an empty list:
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
  /// **Example** "key_holder_missing":
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
  /// **Example** "missing":
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
  /// **Example** "content_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to retrieve thread"
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
  _i13.Future<_i14.TonikResult<_i17.GetThreadResponse, _i16.Response>>
  getThread({
    required _i13.int id,
    required _i13.String threadId,
    _i14.TonikCancellation? cancellation,
  }) async =>
      _getThread(id: id, threadId: threadId, cancellation: cancellation);

  /// Deliver a message into a mailbox (protocol gateways)
  /// Machine to machine: no user token. The inbound pipeline decides: 201 with the message made, 200 processed when it quarantined or discarded it, 550 rejected, 451 deferred, 422 mailbox_full over quota.
  _i13.Future<_i14.TonikResult<_i18.DeliverMessageResponse, _i16.Response>>
  deliverMessage({
    required _i19.DeliverMessageBody body,
    _i14.TonikCancellation? cancellation,
  }) async => _deliverMessage(body: body, cancellation: cancellation);

  /// List the messages waiting to be sent
  /// The account's waiting sends from the addresses the session may send as (mail:send); the others are left out.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "app_password" — A real app password sees waiting sends only from its own mailbox:
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
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "cookie_session" — A current cookie session sees the same permitted sends:
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
  /// **Example** "empty_scheduled" — An account with no waiting sends has an empty array:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
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
  /// **Example** "key_read" — Read permission cannot substitute for send-as permission:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "key_send" — A real API key may list sends only from its permitted sender mailbox:
  /// ```json
  /// {
  ///   "data": [
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
  /// **Example** "key_send_domain" — A domain send scope still requires the holder to permit each sender:
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
  /// **Example** "key_send_holder_missing" — An API key cannot restore send-as permission absent from its holder:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "key_write_only" — Write permission cannot substitute for send-as permission:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
  /// **Example** "primary_only" — Implicit ownership permits the primary sender without linked grants:
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
  /// **Example** "list_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list scheduled messages"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to list scheduled messages"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sender_unavailable":
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
  _i13.Future<
    _i14.TonikResult<_i20.ListScheduledMessagesResponse, _i16.Response>
  >
  listScheduledMessages({_i14.TonikCancellation? cancellation}) async =>
      _listScheduledMessages(cancellation: cancellation);

  /// Cancel a scheduled message
  /// A waiting send from an address the session may not send as (mail:send) is not found, as the list leaves it out.
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
  /// **Example** "app_password_other":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cancelled":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "concurrent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "foreign_owner":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inaccessible":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_send_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_send_wrong_scope":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_write_only":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "sending":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sent":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "No scheduled message with that ID is waiting"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_only":
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
  ///     "message": "Failed to cancel the scheduled message"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "ownership_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to cancel the scheduled message"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sender_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to cancel the scheduled message"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "write_unavailable":
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
  _i13.Future<
    _i14.TonikResult<_i21.CancelScheduledMessageResponse, _i16.Response>
  >
  cancelScheduledMessage({
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => _cancelScheduledMessage(id: id, cancellation: cancellation);

  /// Send a message
  /// Sent at once (201), or with scheduled_at stored and sent then (202); the outbound pipeline may discard it (200). The sender is an address the session may send as (mail:send).
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "from_missing":
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
  /// **Example** "unsubscribe_not_allowed":
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
  /// Response 201 (application/json):
  /// **Example** "valid":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_text": "Sent through the REST API.",
  ///     "created_at": "2026-10-21T12:00:00Z",
  ///     "date_header": null,
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
  /// Response 400 (application/json):
  /// **Example** "from_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "from is required"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "unsubscribe_not_allowed":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "list_unsubscribe_not_allowed",
  ///     "message": "The sender domain sends transactional mail, which carries no List-Unsubscribe field: omit list_unsubscribe"
  ///   }
  /// }
  /// ```
  _i13.Future<_i14.TonikResult<_i22.SendMessageResponse, _i16.Response>>
  sendMessage({
    required _i23.SendMessageRequest body,
    _i14.TonikCancellation? cancellation,
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
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 10,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 10,
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
  /// **Example** "cookie_session":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
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
  /// **Example** "deleted_message":
  /// A message already marked deleted remains retrievable by ID for existing Trash and protocol flows; collection filtering is separate.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 7,
  ///     "in_reply_to": "",
  ///     "is_deleted": true,
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
  /// **Example** "domain_grant":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
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
  /// **Example** "found":
  /// The production message lookup, credential verification and current holder ceilings are used. Controlled SQL proves wiring, not PostgreSQL semantics or audit persistence. JSON omits raw source and unloaded mailboxes; the source route preserves every octet, repeated headers, CRLF, UTF-8 and a leading dot.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
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
  /// **Example** "key_domain":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
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
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
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
  /// **Example** "minimal_source":
  /// A retained CRLF-only source is returned exactly; only an empty stored source is unavailable.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 6,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 2,
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
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 10,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 10,
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
  /// **Example** "source_missing":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>Hello café</p>",
  ///     "body_text": "Hello café",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "date_header": null,
  ///     "folder": "INBOX",
  ///     "has_attachments": true,
  ///     "headers": {
  ///       "X-Trace": [
  ///         "one",
  ///         "two"
  ///       ]
  ///     },
  ///     "id": 2,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": false,
  ///     "is_starred": false,
  ///     "mailbox_id": 2,
  ///     "message_id": "<message@example.net>",
  ///     "raw_size": 0,
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
  /// **Example** "key_holder_missing":
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
  /// **Example** "mailbox_unavailable":
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
  _i13.Future<_i14.TonikResult<_i24.GetMessageResponse, _i16.Response>>
  getMessage({
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
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
  /// **Example** "attachment_sum_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "delete_failed",
  ///     "message": "Failed to delete message"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "attachments_delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "delete_failed",
  ///     "message": "Failed to delete message"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "cancelled":
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
  /// **Example** "mailbox_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "message_delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "delete_failed",
  ///     "message": "Failed to delete message"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "move_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "delete_failed",
  ///     "message": "Failed to delete message"
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
  /// **Example** "quota_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "delete_failed",
  ///     "message": "Failed to delete message"
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
  _i13.Future<_i14.TonikResult<_i25.DeleteMessageResponse, _i16.Response>>
  deleteMessage({
    required _i13.int id,
    _i13.String? permanent,
    _i14.TonikCancellation? cancellation,
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
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "is_flagged": true,
  ///   "is_read": true
  /// }
  /// ```
  _i13.Future<_i14.TonikResult<_i26.UpdateMessageResponse, _i16.Response>>
  updateMessage({
    required _i27.UpdateMessageBody body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => _updateMessage(body: body, id: id, cancellation: cancellation);

  /// Forward a message
  /// The message (mail:read) is forwarded through the normal sender authorization, rate limit and outbound policy, with Fwd: and the note above its original header. Stored attachments, including empty and inline parts, are re-attached; the Sent copy owns independent attachment objects. The final signed MIME message is bounded by SMTP_MAX_MESSAGE_SIZE, and sender quota includes the copied parts. Sent, attachment references, quota and recipient work commit together. Unavailable or changed source objects fail the forward instead of dropping parts.
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
  /// **Example** "checksum_mismatch":
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
  /// **Example** "missing_object":
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
  /// **Example** "queue_write_failed":
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
  /// **Example** "quota_write_failed":
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
  /// **Example** "source_unavailable":
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
  /// **Example** "with_attachments":
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
  /// Response 201 (application/json):
  /// **Example** "with_attachments":
  /// ```json
  /// {
  ///   "data": {
  ///     "body_html": "<p>please review</p>\n<p>---------- Forwarded message ----------<br>\nFrom: old@example.test<br>\nSubject: receipt</p>\n<p>original<img src=\"cid:original-image\"></p>",
  ///     "body_text": "please review\n\n---------- Forwarded message ----------\nFrom: old@example.test\nSubject: receipt\n\noriginal receipt",
  ///     "created_at": "2030-01-02T03:04:05Z",
  ///     "date_header": null,
  ///     "folder": "Sent",
  ///     "has_attachments": true,
  ///     "id": 41,
  ///     "in_reply_to": "",
  ///     "is_deleted": false,
  ///     "is_draft": false,
  ///     "is_dsn": false,
  ///     "is_flagged": false,
  ///     "is_read": true,
  ///     "is_starred": false,
  ///     "mailbox_id": 1,
  ///     "message_id": "<00000000-0000-4000-8000-000000000001@example.test>",
  ///     "raw_size": 1714,
  ///     "received_at": "2030-01-02T03:04:05Z",
  ///     "recipients_cc": [],
  ///     "recipients_to": [
  ///       "target@remote.test"
  ///     ],
  ///     "references": "",
  ///     "sender": "sender@example.test",
  ///     "sender_name": "",
  ///     "size_bytes": 285,
  ///     "subject": "Fwd: receipt",
  ///     "thread_id": "<00000000-0000-4000-8000-000000000001@example.test>",
  ///     "updated_at": "2030-01-02T03:04:05Z"
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
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "not_authorized":
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
  /// **Example** "checksum_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "attachment_unavailable",
  ///     "message": "Could not read an original attachment"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_object":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "attachment_unavailable",
  ///     "message": "Could not read an original attachment"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "queue_write_failed":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_write_failed":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "source_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "attachment_unavailable",
  ///     "message": "Could not read an original attachment"
  ///   }
  /// }
  /// ```
  _i13.Future<_i14.TonikResult<_i28.ForwardMessageResponse, _i16.Response>>
  forwardMessage({
    required _i29.ForwardBody body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
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
  /// **Example** "app_password":
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
  /// **Example** "cookie_session":
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
  /// **Example** "deleted_message":
  /// A message already marked deleted remains retrievable by ID for existing Trash and protocol flows; collection filtering is separate.
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
  /// **Example** "domain_grant":
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
  /// **Example** "key_domain":
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
  /// **Example** "key_read":
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
  /// **Example** "minimal_source":
  /// A retained CRLF-only source is returned exactly; only an empty stored source is unavailable.
  ///
  /// ```
  ///
  ///
  /// ```
  ///
  /// **Example** "primary":
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
  /// **Example** "key_holder_missing":
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
  /// **Example** "source_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Raw message not available"
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
  /// **Example** "mailbox_unavailable":
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
  _i13.Future<_i14.TonikResult<_i30.GetRawMessageResponse, _i16.Response>>
  getRawMessage({
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => _getRawMessage(id: id, cancellation: cancellation);
}
