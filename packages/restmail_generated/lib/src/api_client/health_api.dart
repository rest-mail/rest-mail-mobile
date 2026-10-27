// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:http/http.dart' as _i6;
import 'package:restmail_generated/src/operation/get_health.dart' as _i2;
import 'package:restmail_generated/src/response_wrapper/get_health_response.dart'
    as _i5;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

class HealthApi {
  HealthApi(_i1.Server server)
    : _getHealth = _i2.GetHealth(server.baseUrl, () => server.client);

  final _i2.GetHealth _getHealth;

  /// Health check
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — A successful database ping gives public liveness:
  /// ```json
  /// {
  ///   "data": {
  ///     "db": "connected",
  ///     "status": "healthy"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — Unexpected handler errors use the shared sanitized envelope:
  /// Checked through the production endpoint error adapter. The normal liveness probe returns503 for its expected database failures.
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
  /// **Example** "database_connection_unavailable" — The configured database handle cannot provide a connection pool:
  /// Fault precondition: database pool acquisition fails. The public response does not disclose connection configuration.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unhealthy",
  ///     "message": "Database connection unavailable"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "database_ping_failed" — The database pool exists but its probe fails:
  /// Fault precondition: the database ping fails. Exercised through the real health registration with a controlled SQL connector.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unhealthy",
  ///     "message": "Database ping failed"
  ///   }
  /// }
  /// ```
  _i3.Future<_i4.TonikResult<_i5.GetHealthResponse, _i6.Response>> getHealth({
    _i4.TonikCancellation? cancellation,
  }) async => _getHealth(cancellation: cancellation);
}
