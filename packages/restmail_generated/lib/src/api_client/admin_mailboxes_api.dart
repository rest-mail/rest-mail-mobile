// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i9;

import 'package:http/http.dart' as _i12;
import 'package:restmail_generated/src/model/import_message_body.dart' as _i13;
import 'package:restmail_generated/src/model/update_mailbox_request.dart'
    as _i18;
import 'package:restmail_generated/src/operation/delete_mailbox.dart' as _i5;
import 'package:restmail_generated/src/operation/end_mailbox_sessions.dart'
    as _i8;
import 'package:restmail_generated/src/operation/get_mailbox.dart' as _i4;
import 'package:restmail_generated/src/operation/import_message.dart' as _i2;
import 'package:restmail_generated/src/operation/invite_account.dart' as _i7;
import 'package:restmail_generated/src/operation/list_mailboxes.dart' as _i3;
import 'package:restmail_generated/src/operation/update_mailbox.dart' as _i6;
import 'package:restmail_generated/src/response_wrapper/delete_mailbox_response.dart'
    as _i16;
import 'package:restmail_generated/src/response_wrapper/end_mailbox_sessions_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/get_mailbox_response.dart'
    as _i15;
import 'package:restmail_generated/src/response_wrapper/import_message_response.dart'
    as _i11;
import 'package:restmail_generated/src/response_wrapper/invite_account_response.dart'
    as _i19;
import 'package:restmail_generated/src/response_wrapper/list_mailboxes_response.dart'
    as _i14;
import 'package:restmail_generated/src/response_wrapper/update_mailbox_response.dart'
    as _i17;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i10;

class AdminMailboxesApi {
  AdminMailboxesApi(_i1.Server server)
    : _importMessage = _i2.ImportMessage(server.baseUrl, () => server.client),
      _listMailboxes = _i3.ListMailboxes(server.baseUrl, () => server.client),
      _getMailbox = _i4.GetMailbox(server.baseUrl, () => server.client),
      _deleteMailbox = _i5.DeleteMailbox(server.baseUrl, () => server.client),
      _updateMailbox = _i6.UpdateMailbox(server.baseUrl, () => server.client),
      _inviteAccount = _i7.InviteAccount(server.baseUrl, () => server.client),
      _endMailboxSessions = _i8.EndMailboxSessions(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ImportMessage _importMessage;

  final _i3.ListMailboxes _listMailboxes;

  final _i4.GetMailbox _getMailbox;

  final _i5.DeleteMailbox _deleteMailbox;

  final _i6.UpdateMailbox _updateMailbox;

  final _i7.InviteAccount _inviteAccount;

  final _i8.EndMailboxSessions _endMailboxSessions;

  /// Import one historical message
  /// Stores original message octets, folder, supported system flags and required internal_date without delivery rules or notifications. Requires mailboxes:write on the destination. A Message-ID already present in that account and folder is skipped without changing its flags or date. Messages without Message-ID use a deterministic SHA-256 import identity; the raw source remains unchanged. Every attempt is audited; successful imports and skips also receive a transactional messages.import audit entry. The decoded message is bounded by SMTP_MAX_MESSAGE_SIZE (10 MiB by default); the general API body limit may be stricter. Deleted-state and keyword flags are unsupported and refused rather than hidden or discarded.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "api_key":
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
  /// **Example** "api_key_holder_revoked":
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
  /// **Example** "binary_source":
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
  ///   "raw_message": "TWVzc2FnZS1JRDogPGJpbmFyeUBleGFtcGxlLnRlc3Q+DQpGcm9tOiBvbGRAZXhhbXBsZS50ZXN0DQoNCmhpc3Rvcnn/AA0K"
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
  /// **Example** "csrf":
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
  /// **Example** "decoded_too_large":
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
  ///   "raw_message": "eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHg="
  /// }
  /// ```
  ///
  /// **Example** "default_folder":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "internal_date": "2020-01-02T03:04:05Z",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "duplicate":
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
  /// **Example** "insert_failure":
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
  /// **Example** "insufficient_permissions":
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
  /// **Example** "invalid_base64":
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
  ///   "raw_message": "!not-base64!"
  /// }
  /// ```
  ///
  /// **Example** "invalid_folder":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "bad\u0000folder",
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
  /// **Example** "missing_date":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "raw_message": "TWVzc2FnZS1JRDogPGhpc3RvcnlAZXhhbXBsZS50ZXN0Pg0KRnJvbTogT3JpZ2luYWwgPG9sZEBleGFtcGxlLnRlc3Q+DQpTdWJqZWN0OiBvcmlnaW5hbA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "missing_message_id":
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
  ///   "raw_message": "RnJvbTogb2xkQGV4YW1wbGUudGVzdA0KDQpoaXN0b3J5DQo="
  /// }
  /// ```
  ///
  /// **Example** "missing_raw":
  /// ```json
  /// {
  ///   "flags": [
  ///     "\\Seen",
  ///     "\\Answered",
  ///     "\\Flagged",
  ///     "\\Draft"
  ///   ],
  ///   "folder": "Archive",
  ///   "internal_date": "2020-01-02T03:04:05Z"
  /// }
  /// ```
  ///
  /// **Example** "missing_scoped_target":
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
  /// **Example** "quota_failure":
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
  /// **Example** "read_failure":
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
  /// **Example** "setup_pending":
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
  /// **Example** "unresolved_scoped_id":
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
  /// **Example** "unsupported_deleted":
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
  /// **Example** "unsupported_keyword":
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
  /// Response 200 (application/json):
  /// **Example** "api_key":
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
  /// **Example** "binary_source":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<binary@example.test>"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "default_folder":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "INBOX",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<history@example.test>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "duplicate":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": false,
  ///     "message_id": "<history@example.test>"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_message_id":
  /// ```json
  /// {
  ///   "data": {
  ///     "folder": "Archive",
  ///     "id": 41,
  ///     "imported": true,
  ///     "message_id": "<import.9b98f1924d1d2ce37341bb414c6b3a53b345718aee0e7760eb94724f9b8de94e@rest-mail.invalid>"
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
  /// **Example** "api_key_holder_revoked":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "csrf":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "insufficient_permissions":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_scoped_target":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "setup_pending":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "setup_required",
  ///     "message": "Finish setting up this account first: a new password and two-factor authentication"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unresolved_scoped_id":
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
  /// **Example** "decoded_too_large":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "message_too_large",
  ///     "message": "The decoded message exceeds the import size limit"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "invalid_base64":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "raw_message": "must be a base64 string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_folder":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "folder": "must not contain a control character"
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
  /// **Example** "missing_date":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "internal_date": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing_raw":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "raw_message": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unsupported_deleted":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "flags": "unsupported flag: \\Deleted"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unsupported_keyword":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "flags": "unsupported flag: $Custom"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "insert_failure":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_failure":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "read_failure":
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
  _i9.Future<_i10.TonikResult<_i11.ImportMessageResponse, _i12.Response>>
  importMessage({
    required _i13.ImportMessageBody body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _importMessage(body: body, id: id, cancellation: cancellation);

  /// List mailboxes, optionally filtered by domain
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
  ///     "message": "Failed to list mailboxes"
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
  _i9.Future<_i10.TonikResult<_i14.ListMailboxesResponse, _i12.Response>>
  listMailboxes({
    _i9.int? domainId,
    _i9.int? limit,
    _i9.int? offset,
    _i10.TonikCancellation? cancellation,
  }) async => _listMailboxes(
    domainId: domainId,
    limit: limit,
    offset: offset,
    cancellation: cancellation,
  );

  /// Get an account by ID
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "domain_redacted":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "user@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "user",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "domain_scope":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "user@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "user",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "found":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "user@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "user",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "inactive":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": false,
  ///     "address": "disabled@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 2,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "disabled",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "mailbox_scope":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "user@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 1,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "user",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
  ///     "updated_at": "2026-10-20T00:00:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_present":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "user@example.com",
  ///     "created_at": "2026-10-20T00:00:00Z",
  ///     "display_name": "Mailbox café",
  ///     "domain": {
  ///       "active": true,
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "default_quota_bytes": 1073741824,
  ///       "dkim_selector": "restmail",
  ///       "dmarc_policy": "none",
  ///       "id": 1,
  ///       "name": "example.com",
  ///       "sending_policy": "",
  ///       "server_type": "traditional",
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "domain_id": 1,
  ///     "id": 6,
  ///     "last_login_at": "2026-10-20T00:00:00Z",
  ///     "last_password_change": "2026-10-20T00:00:00Z",
  ///     "local_part": "user",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1048576,
  ///     "quota_usage": {
  ///       "attachment_bytes": 275,
  ///       "body_bytes": 34,
  ///       "mailbox_id": 6,
  ///       "message_count": 3,
  ///       "subject_bytes": 12,
  ///       "updated_at": "2026-10-20T00:00:00Z"
  ///     },
  ///     "quota_used_bytes": 321,
  ///     "two_factor_required": true,
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
  /// **Example** "outside_scope":
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
  ///     "message": "Mailbox not found"
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
  /// Response 500 (application/json):
  /// **Example** "domain_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get mailbox"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get mailbox"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "quota_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to get mailbox"
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
  _i9.Future<_i10.TonikResult<_i15.GetMailboxResponse, _i12.Response>>
  getMailbox({
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _getMailbox(id: id, cancellation: cancellation);

  /// Delete an account
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
  /// **Example** "grant_exceeds_held":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "grant_exceeds_held",
  ///     "message": "you can only grant or remove a role whose capabilities you hold, at a scope within your own"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
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
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "Changing grants needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
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
  ///     "message": "Mailbox not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "last_superadmin":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "last_superadmin",
  ///     "message": "Refused: this is the last grant of every capability at \"*\" held by an active account that can use it; nobody could grant anything after it"
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
  /// **Example** "cancelled_after_lookup":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "credentials_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "delete_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "held_by_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "held_on_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "lock_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
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
  /// **Example** "refresh_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to change grants"
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
  /// **Example** "scope_lookup_unavailable":
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
  _i9.Future<_i10.TonikResult<_i16.DeleteMailboxResponse, _i12.Response>>
  deleteMailbox({
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _deleteMailbox(id: id, cancellation: cancellation);

  /// Update an account
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "active": true,
  ///   "display_name": "Contract Test",
  ///   "quota_bytes": 1073741824
  /// }
  /// ```
  ///
  /// **Example** "password_short":
  /// ```json
  /// {
  ///   "display_name": "Contract Test",
  ///   "password": "short"
  /// }
  /// ```
  ///
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "active": true,
  ///   "display_name": "Contract Test",
  ///   "quota_bytes": 1073741824
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "updated":
  /// ```json
  /// {
  ///   "data": {
  ///     "active": true,
  ///     "address": "new-account@restmail.test",
  ///     "created_at": "2026-10-21T12:00:00Z",
  ///     "display_name": "Contract Test",
  ///     "domain_id": 1,
  ///     "id": 2,
  ///     "last_login_at": null,
  ///     "last_password_change": null,
  ///     "local_part": "new-account",
  ///     "password_change_required": false,
  ///     "quota_bytes": 1073741824,
  ///     "quota_used_bytes": 0,
  ///     "two_factor_required": false,
  ///     "updated_at": "2026-10-21T12:00:00Z"
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
  ///     "message": "Mailbox not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "password_short":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "password": "must be at least 12 characters"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i9.Future<_i10.TonikResult<_i17.UpdateMailboxResponse, _i12.Response>>
  updateMailbox({
    required _i18.UpdateMailboxRequest body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _updateMailbox(body: body, id: id, cancellation: cancellation);

  /// Invite an account to choose its first password
  /// For an active account created without credentials. The invitation lasts 15 minutes; issuing another invalidates the previous one. Only a hash is stored. Authenticator enrollment and server encryption must be enabled before invitations can be issued.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 201 (application/json):
  /// **Example** "created":
  /// ```json
  /// {
  ///   "data": {
  ///     "expires_at": "2030-01-01T00:15:00Z",
  ///     "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
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
  /// **Example** "insufficient_permissions":
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
  ///     "message": "Mailbox not found"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "existing_credentials":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "account_not_invitable",
  ///     "message": "only an active account that has never held credentials can be invited"
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
  /// **Example** "unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Invitations require authenticator enrollment and server encryption to be enabled"
  ///   }
  /// }
  /// ```
  _i9.Future<_i10.TonikResult<_i19.InviteAccountResponse, _i12.Response>>
  inviteAccount({
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _inviteAccount(id: id, cancellation: cancellation);

  /// Sign an account out everywhere
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
  /// **Example** "key_holder_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_read":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "key_wrong_domain":
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
  /// **Example** "scoped_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Insufficient permissions"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_domain":
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
  ///     "message": "Mailbox not found"
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
  /// **Example** "epoch_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to end the sessions"
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
  /// **Example** "refresh_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to end the sessions"
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
  /// **Example** "scope_lookup_unavailable":
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
  _i9.Future<_i10.TonikResult<_i20.EndMailboxSessionsResponse, _i12.Response>>
  endMailboxSessions({
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => _endMailboxSessions(id: id, cancellation: cancellation);
}
