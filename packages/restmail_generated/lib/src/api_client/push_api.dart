// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:http/http.dart' as _i8;
import 'package:restmail_generated/src/model/register_device_request.dart'
    as _i10;
import 'package:restmail_generated/src/operation/list_push_devices.dart' as _i2;
import 'package:restmail_generated/src/operation/register_push_device.dart'
    as _i3;
import 'package:restmail_generated/src/operation/remove_push_device.dart'
    as _i4;
import 'package:restmail_generated/src/response_wrapper/list_push_devices_response.dart'
    as _i7;
import 'package:restmail_generated/src/response_wrapper/register_push_device_response.dart'
    as _i9;
import 'package:restmail_generated/src/response_wrapper/remove_push_device_response.dart'
    as _i11;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i6;

class PushApi {
  PushApi(_i1.Server server)
    : _listPushDevices = _i2.ListPushDevices(
        server.baseUrl,
        () => server.client,
      ),
      _registerPushDevice = _i3.RegisterPushDevice(
        server.baseUrl,
        () => server.client,
      ),
      _removePushDevice = _i4.RemovePushDevice(
        server.baseUrl,
        () => server.client,
      );

  final _i2.ListPushDevices _listPushDevices;

  final _i3.RegisterPushDevice _registerPushDevice;

  final _i4.RemovePushDevice _removePushDevice;

  /// List push services and this session's devices
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — The permitted read succeeds:
  /// A current, setup-complete session reads the controlled database snapshot through the production registration. Lists are empty; statistics include two delivered queue entries. Push routes are configured for APNs, without sending a notification.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "devices": [],
  ///     "platforms": [
  ///       "apns"
  ///     ]
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
  ///     "message": "Failed to list devices"
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
  _i5.Future<_i6.TonikResult<_i7.ListPushDevicesResponse, _i8.Response>>
  listPushDevices({_i6.TonikCancellation? cancellation}) async =>
      _listPushDevices(cancellation: cancellation);

  /// Register a push device for this session
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "app_id_mismatch":
  /// ```json
  /// {
  ///   "app_id": "com.example.other",
  ///   "environment": "production",
  ///   "platform": "apns",
  ///   "token": "5c1d7e0f3a9b2c4d6e8f0a1b3c5d7e9f1a2b4c6d8e0f2a3b5c7d9e1f3a4b6c8d"
  /// }
  /// ```
  ///
  /// **Example** "environment_invalid":
  /// ```json
  /// {
  ///   "app_id": "com.antimatterstudios.restmail",
  ///   "environment": "staging",
  ///   "platform": "apns",
  ///   "token": "5c1d7e0f3a9b2c4d6e8f0a1b3c5d7e9f1a2b4c6d8e0f2a3b5c7d9e1f3a4b6c8d"
  /// }
  /// ```
  ///
  /// **Example** "platform_unsupported":
  /// ```json
  /// {
  ///   "app_id": "com.antimatterstudios.restmail",
  ///   "environment": "production",
  ///   "platform": "fcm",
  ///   "token": "5c1d7e0f3a9b2c4d6e8f0a1b3c5d7e9f1a2b4c6d8e0f2a3b5c7d9e1f3a4b6c8d"
  /// }
  /// ```
  ///
  /// **Example** "registered":
  /// ```json
  /// {
  ///   "app_id": "com.antimatterstudios.restmail",
  ///   "environment": "production",
  ///   "platform": "apns",
  ///   "token": "5c1d7e0f3a9b2c4d6e8f0a1b3c5d7e9f1a2b4c6d8e0f2a3b5c7d9e1f3a4b6c8d"
  /// }
  /// ```
  ///
  /// **Example** "token_invalid":
  /// ```json
  /// {
  ///   "app_id": "com.antimatterstudios.restmail",
  ///   "environment": "production",
  ///   "platform": "apns",
  ///   "token": "not-an-apns-token"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "already_registered":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "environment": "production",
  ///     "id": "12",
  ///     "platform": "apns"
  ///   }
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "registered":
  /// ```json
  /// {
  ///   "data": {
  ///     "created_at": "2026-01-01T00:00:00Z",
  ///     "environment": "production",
  ///     "id": "12",
  ///     "platform": "apns"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
  /// **Example** "app_id_mismatch":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "app_id": "this server pushes to com.antimatterstudios.restmail only"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "environment_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "environment": "must be \"production\" or \"sandbox\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "platform_unsupported":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "platform": "not configured on this server"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "token_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "token": "not an APNs device token: 64 or more lowercase hex digits"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i5.Future<_i6.TonikResult<_i9.RegisterPushDeviceResponse, _i8.Response>>
  registerPushDevice({
    required _i10.RegisterDeviceRequest body,
    _i6.TonikCancellation? cancellation,
  }) async => _registerPushDevice(body: body, cancellation: cancellation);

  /// Remove a push device registered by this session
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 401 (application/json):
  /// **Example** "api_key":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "app_password":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid authorization header format"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired token"
  ///   }
  /// }
  /// ```
  ///
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
  /// **Example** "foreign_session":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "invalid_id":
  /// Device IDs remain string parameters with handler-level 404 for unparseable IDs; this is not a schema-validation 422. Zero, negative and uint32-overflow strings preserve the same refusal.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "negative_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_account":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "other_session":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "overflow_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "zero_id":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_found",
  ///     "message": "Device not found"
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
  /// Response 500 (application/json):
  /// **Example** "write_unavailable":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to remove the device"
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
  _i5.Future<_i6.TonikResult<_i11.RemovePushDeviceResponse, _i8.Response>>
  removePushDevice({
    required _i5.String deviceId,
    _i6.TonikCancellation? cancellation,
  }) async => _removePushDevice(deviceId: deviceId, cancellation: cancellation);
}
