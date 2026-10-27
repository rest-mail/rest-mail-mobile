// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/operation/get_dashboard_stats.dart'
    as _i2;
import 'package:restmail_generated/src/response_wrapper/get_dashboard_stats_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class AdminStatsApi {
  AdminStatsApi(_i1.Server server)
    : _getDashboardStats = _i2.GetDashboardStats(
        server.baseUrl,
        () => server.client,
      );

  final _i2.GetDashboardStats _getDashboardStats;

  /// Dashboard statistics
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  /// - HTTP Bearer: A scoped API key (rmk_...) as an Authorization: Bearer header, allowed only where both the key's permissions and its owner's live grants cover the capability at the target. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted read succeeds:
  /// A current, setup-complete session reads the controlled database snapshot through the production registration. Lists are empty; statistics include two delivered queue entries. Push routes are configured for APNs, without sending a notification.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "domainCount": 0,
  ///     "inboundTransportSecurity": {
  ///       "overTLS": 0,
  ///       "plaintext": 0,
  ///       "plaintextAuthFail": 0,
  ///       "plaintextAuthPass": 0,
  ///       "plaintextPercent": 0,
  ///       "tlsPercent": 0,
  ///       "totalInboundMX": 0
  ///     },
  ///     "mailboxCount": 0,
  ///     "messageVolume": [
  ///       {
  ///         "count": 2,
  ///         "date": "Oct 20"
  ///       }
  ///     ],
  ///     "queueStats": {
  ///       "failed": 0,
  ///       "pending": 0,
  ///       "processing": 0
  ///     },
  ///     "recentActivity": null
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The read dependency fails:
  /// Session and permission checks pass, but the database read fails. The production handler and error writer produce this refusal without exposing dependency details.
  ///
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
  _i3.Future<_i4.TonikResult<_i5.GetDashboardStatsResponse, _i6.Response>>
  getDashboardStats({_i4.TonikCancellation? cancellation}) async =>
      _getDashboardStats(cancellation: cancellation);
}
