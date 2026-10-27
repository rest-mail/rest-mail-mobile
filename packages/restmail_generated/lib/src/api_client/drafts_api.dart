// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:http/http.dart' as _i8;
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
  /// **Example** "with_sender":
  /// ```json
  /// {
  ///   "body_text": "Not sent yet.",
  ///   "from": "admin@restmail.test",
  ///   "subject": "Draft",
  ///   "to": [
  ///     "admin@restmail.test"
  ///   ]
  /// }
  /// ```
  _i5.Future<_i6.TonikResult<_i7.SaveDraftResponse, _i8.Response>> saveDraft({
    required _i9.SaveDraftBody body,
    _i6.TonikCancellation? cancellation,
  }) async => _saveDraft(body: body, cancellation: cancellation);

  /// Update an existing draft
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
  _i5.Future<_i6.TonikResult<_i10.UpdateDraftResponse, _i8.Response>>
  updateDraft({
    required _i11.UpdateDraftBody body,
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _updateDraft(body: body, id: id, cancellation: cancellation);

  /// Send a draft
  /// The draft (mail:write) is sent as sendMessage sends, and deleted once it is; a refused send keeps it.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  _i5.Future<_i6.TonikResult<_i12.SendDraftResponse, _i8.Response>> sendDraft({
    required _i5.int id,
    _i6.TonikCancellation? cancellation,
  }) async => _sendDraft(id: id, cancellation: cancellation);
}
