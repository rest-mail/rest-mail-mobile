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
  /// **Example** "app_password" — An actual HTTP Basic app password reads its own account:
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
  /// **Example** "cookie_session":
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
  /// **Example** "domain_grant" — A domain-scoped mail-read grant reaches this account:
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
  /// **Example** "empty" — An accessible account without rows returns an empty array:
  /// ```json
  /// {
  ///   "data": []
  /// }
  /// ```
  ///
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
  /// **Example** "key_domain":
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
  /// **Example** "key_read" — A real API key and its holder both permit this mailbox read:
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
  /// **Example** "primary":
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
  ///     "message": "Internal server error"
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
  _i4.Future<_i5.TonikResult<_i8.RespondToCalendarResponse, _i7.Response>>
  respondToCalendar({
    required _i9.CalendarReplyBody body,
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async =>
      _respondToCalendar(body: body, id: id, cancellation: cancellation);
}
