// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:http/http.dart' as _i7;
import 'package:restmail_generated/src/model/calendar_reply_body.dart' as _i9;
import 'package:restmail_generated/src/operation/list_calendar_events.dart'
    as _i2;
import 'package:restmail_generated/src/operation/respond_to_calendar.dart'
    as _i3;
import 'package:restmail_generated/src/response_wrapper/list_calendar_events_response.dart'
    as _i6;
import 'package:restmail_generated/src/response_wrapper/respond_to_calendar_response.dart'
    as _i8;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

class CalendarApi {
  CalendarApi(_i1.Server server)
    : _listCalendarEvents = _i2.ListCalendarEvents(
        server.baseUrl,
        () => server.client,
      ),
      _respondToCalendar = _i3.RespondToCalendar(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListCalendarEvents _listCalendarEvents;

  final _i3.RespondToCalendar _respondToCalendar;

  /// List the calendar invitations an account has received
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Response 200 (application/json):
  /// **Example** "found" — Versions are grouped by UID, retaining the latest fields and counting older versions:
  /// The production route loads current grants and maps fixed SQL rows through the real handler. Controlled rows prove wiring and response grouping, not PostgreSQL filtering, ordering or persistence. Existing cancellation aggregation is preserved: an older CANCEL marks the group, a CANCELLED latest status also marks it, and an absent message ID is omitted.
  ///
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "is_cancelled": true,
  ///       "message_id": 77,
  ///       "method": "REQUEST",
  ///       "sequence": 3,
  ///       "status": "CONFIRMED",
  ///       "summary": "Latest café",
  ///       "uid": "event-a",
  ///       "versions": 3
  ///     },
  ///     {
  ///       "is_cancelled": true,
  ///       "method": "REQUEST",
  ///       "sequence": 1,
  ///       "status": "CANCELLED",
  ///       "summary": "Cancelled",
  ///       "uid": "event-b",
  ///       "versions": 1
  ///     },
  ///     {
  ///       "is_cancelled": false,
  ///       "message_id": 88,
  ///       "method": "REQUEST",
  ///       "sequence": 0,
  ///       "status": "TENTATIVE",
  ///       "summary": "Tentative",
  ///       "uid": "event-c",
  ///       "versions": 1
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
  _i4.Future<_i5.TonikResult<_i6.ListCalendarEventsResponse, _i7.Response>>
  listCalendarEvents({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => _listCalendarEvents(id: id, cancellation: cancellation);

  /// Reply to a calendar invitation
  /// The invitation's message is read with mail:read; the reply is sent from an address the session may send as (mail:send).
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "accepted" — The reply is sent to the organizer:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "foreign_sender" — The caller cannot send as that address:
  /// ```json
  /// {
  ///   "from": "someone@other.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "invalid_id" — A zero id is refused before the handler:
  /// The JSON body is valid. The real path binder refuses the zero identifier; a body-invalid marker would not describe path binding.
  ///
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
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
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "from": "admin@restmail.test",
  ///   "response": "ACCEPTED"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "accepted" — The reply is sent to the organizer:
  /// ```json
  /// {
  ///   "data": {
  ///     "response": "ACCEPTED",
  ///     "status": "sent"
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
  _i4.Future<_i5.TonikResult<_i8.RespondToCalendarResponse, _i7.Response>>
  respondToCalendar({
    required _i9.CalendarReplyBody body,
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async =>
      _respondToCalendar(body: body, id: id, cancellation: cancellation);
}
