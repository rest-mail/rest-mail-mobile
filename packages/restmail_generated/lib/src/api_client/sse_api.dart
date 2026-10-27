// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/operation/account_events.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/account_events_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class SseApi {
  SseApi(_i1.Server server)
    : _accountEvents = _i2.AccountEvents(server.baseUrl, () => server.client);

  final _i2.AccountEvents _accountEvents;

  /// Server-Sent Events stream for real-time updates
  /// A stream of the account's events, new_message, message_updated, message_deleted, message_sent or folder_update, each an id, the event's name and its JSON data. A Last-Event-ID header asks for the events after it that the server still holds. The session is checked when the stream opens, and again before every event and keepalive: once the account's sessions end, the stream ends without sending anything more.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i3.Future<_i4.TonikResult<_i5.AccountEventsResponse, _i6.Response>>
  accountEvents({
    required _i3.int id,
    _i4.TonikCancellation? cancellation,
  }) async => _accountEvents(id: id, cancellation: cancellation);
}
