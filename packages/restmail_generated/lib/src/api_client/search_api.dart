// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/model/api_v1_accounts_id_search_parameters_model.dart'
    as _i7;
import 'package:restmail_generated/src/operation/search_messages.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/search_messages_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class SearchApi {
  SearchApi(_i1.Server server)
    : _searchMessages = _i2.SearchMessages(server.baseUrl, () => server.client);

  final _i2.SearchMessages _searchMessages;

  /// Search messages
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — Messages matching the query:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "calendar_events": [],
  ///       "created_at": "2026-10-20T00:00:00Z",
  ///       "date_header": "2026-10-20T00:00:00Z",
  ///       "downgraded_size": 137,
  ///       "folder": "INBOX",
  ///       "has_attachments": false,
  ///       "headers": {
  ///         "Subject": [
  ///           "Subject"
  ///         ]
  ///       },
  ///       "id": 1,
  ///       "in_reply_to": "",
  ///       "is_deleted": false,
  ///       "is_draft": false,
  ///       "is_dsn": false,
  ///       "is_flagged": false,
  ///       "is_read": false,
  ///       "is_starred": false,
  ///       "mailbox_id": 1,
  ///       "message_id": "<message@example.net>",
  ///       "raw_size": 137,
  ///       "received_at": "2026-10-20T00:00:00Z",
  ///       "recipients_cc": [],
  ///       "recipients_to": [
  ///         "recipient@example.com"
  ///       ],
  ///       "references": "",
  ///       "sender": "sender@example.net",
  ///       "sender_name": "Sender",
  ///       "size_bytes": 80,
  ///       "subject": "Subject",
  ///       "thread_id": "",
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
  /// **Example** "missing" — The account does not exist or is out of reach:
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
  _i3.Future<_i4.TonikResult<_i5.SearchMessagesResponse, _i6.Response>>
  searchMessages({
    required _i3.int id,
    _i3.String? q,
    _i3.String? folder,
    _i3.String? from,
    _i3.DateTime? after,
    _i3.DateTime? before,
    _i7.ApiV1AccountsIdSearchParametersModel? hasAttachment,
    _i3.int? limit,
    _i4.TonikCancellation? cancellation,
  }) async => _searchMessages(
    id: id,
    q: q,
    folder: folder,
    from: from,
    after: after,
    before: before,
    hasAttachment: hasAttachment,
    limit: limit,
    cancellation: cancellation,
  );
}
