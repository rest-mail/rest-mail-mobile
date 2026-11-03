// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i25;

import 'package:http/http.dart' as _i28;
import 'package:restmail_generated/src/model/accept_invitation_request.dart'
    as _i35;
import 'package:restmail_generated/src/model/api_v1_auth_logout_post_body_body_one_of_model.dart'
    as _i39;
import 'package:restmail_generated/src/model/api_v1_auth_refresh_post_body_body_one_of_model.dart'
    as _i62;
import 'package:restmail_generated/src/model/change_password_request.dart'
    as _i46;
import 'package:restmail_generated/src/model/confirm_request.dart' as _i30;
import 'package:restmail_generated/src/model/disable_request.dart' as _i32;
import 'package:restmail_generated/src/model/login_request.dart' as _i37;
import 'package:restmail_generated/src/model/owner_status_request.dart' as _i42;
import 'package:restmail_generated/src/model/owner_token_request.dart' as _i44;
import 'package:restmail_generated/src/model/protocol_sign_in_request.dart'
    as _i48;
import 'package:restmail_generated/src/model/recover_request.dart' as _i50;
import 'package:restmail_generated/src/model/recovery_email_token_request.dart'
    as _i60;
import 'package:restmail_generated/src/model/redeem_recovery_email_request.dart'
    as _i54;
import 'package:restmail_generated/src/model/register_recovery_email_request.dart'
    as _i57;
import 'package:restmail_generated/src/model/request_recovery_email_request.dart'
    as _i52;
import 'package:restmail_generated/src/model/reset_request.dart' as _i64;
import 'package:restmail_generated/src/operation/accept_invitation.dart' as _i6;
import 'package:restmail_generated/src/operation/change_own_password.dart'
    as _i12;
import 'package:restmail_generated/src/operation/confirm_two_factor.dart'
    as _i3;
import 'package:restmail_generated/src/operation/describe_server.dart' as _i24;
import 'package:restmail_generated/src/operation/disable_two_factor.dart'
    as _i4;
import 'package:restmail_generated/src/operation/enroll_two_factor.dart' as _i5;
import 'package:restmail_generated/src/operation/get_recovery_email.dart'
    as _i17;
import 'package:restmail_generated/src/operation/get_two_factor_status.dart'
    as _i2;
import 'package:restmail_generated/src/operation/issue_client_credentials_token.dart'
    as _i23;
import 'package:restmail_generated/src/operation/login.dart' as _i7;
import 'package:restmail_generated/src/operation/logout.dart' as _i8;
import 'package:restmail_generated/src/operation/owner_challenge_operation.dart'
    as _i9;
import 'package:restmail_generated/src/operation/owner_status.dart' as _i10;
import 'package:restmail_generated/src/operation/owner_token_operation.dart'
    as _i11;
import 'package:restmail_generated/src/operation/protocol_sign_in.dart' as _i13;
import 'package:restmail_generated/src/operation/recover_account.dart' as _i14;
import 'package:restmail_generated/src/operation/recovery_email_link.dart'
    as _i19;
import 'package:restmail_generated/src/operation/redeem_recovery_email.dart'
    as _i16;
import 'package:restmail_generated/src/operation/refresh_token.dart' as _i21;
import 'package:restmail_generated/src/operation/register_recovery_email.dart'
    as _i18;
import 'package:restmail_generated/src/operation/request_recovery_email.dart'
    as _i15;
import 'package:restmail_generated/src/operation/reset_admin.dart' as _i22;
import 'package:restmail_generated/src/operation/verify_recovery_email.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/accept_invitation_response.dart'
    as _i34;
import 'package:restmail_generated/src/response_wrapper/change_own_password_response.dart'
    as _i45;
import 'package:restmail_generated/src/response_wrapper/confirm_two_factor_response.dart'
    as _i29;
import 'package:restmail_generated/src/response_wrapper/describe_server_response.dart'
    as _i66;
import 'package:restmail_generated/src/response_wrapper/disable_two_factor_response.dart'
    as _i31;
import 'package:restmail_generated/src/response_wrapper/enroll_two_factor_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/get_recovery_email_response.dart'
    as _i55;
import 'package:restmail_generated/src/response_wrapper/get_two_factor_status_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/issue_client_credentials_token_response.dart'
    as _i65;
import 'package:restmail_generated/src/response_wrapper/login_response_wrapper.dart'
    as _i36;
import 'package:restmail_generated/src/response_wrapper/logout_response.dart'
    as _i38;
import 'package:restmail_generated/src/response_wrapper/owner_challenge_operation_response.dart'
    as _i40;
import 'package:restmail_generated/src/response_wrapper/owner_status_response.dart'
    as _i41;
import 'package:restmail_generated/src/response_wrapper/owner_token_operation_response.dart'
    as _i43;
import 'package:restmail_generated/src/response_wrapper/protocol_sign_in_response.dart'
    as _i47;
import 'package:restmail_generated/src/response_wrapper/recover_account_response.dart'
    as _i49;
import 'package:restmail_generated/src/response_wrapper/recovery_email_link_response.dart'
    as _i58;
import 'package:restmail_generated/src/response_wrapper/redeem_recovery_email_response.dart'
    as _i53;
import 'package:restmail_generated/src/response_wrapper/refresh_token_response.dart'
    as _i61;
import 'package:restmail_generated/src/response_wrapper/register_recovery_email_response.dart'
    as _i56;
import 'package:restmail_generated/src/response_wrapper/request_recovery_email_response.dart'
    as _i51;
import 'package:restmail_generated/src/response_wrapper/reset_admin_response.dart'
    as _i63;
import 'package:restmail_generated/src/response_wrapper/verify_recovery_email_response.dart'
    as _i59;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i26;

class AuthApi {
  AuthApi(_i1.Server server)
    : _getTwoFactorStatus = _i2.GetTwoFactorStatus(
        server.baseUrl,
        () => server.client,
      ),
      _confirmTwoFactor = _i3.ConfirmTwoFactor(
        server.baseUrl,
        () => server.client,
      ),
      _disableTwoFactor = _i4.DisableTwoFactor(
        server.baseUrl,
        () => server.client,
      ),
      _enrollTwoFactor = _i5.EnrollTwoFactor(
        server.baseUrl,
        () => server.client,
      ),
      _acceptInvitation = _i6.AcceptInvitation(
        server.baseUrl,
        () => server.client,
      ),
      _login = _i7.Login(server.baseUrl, () => server.client),
      _logout = _i8.Logout(server.baseUrl, () => server.client),
      _ownerChallengeOperation = _i9.OwnerChallengeOperation(
        server.baseUrl,
        () => server.client,
      ),
      _ownerStatus = _i10.OwnerStatus(server.baseUrl, () => server.client),
      _ownerTokenOperation = _i11.OwnerTokenOperation(
        server.baseUrl,
        () => server.client,
      ),
      _changeOwnPassword = _i12.ChangeOwnPassword(
        server.baseUrl,
        () => server.client,
      ),
      _protocolSignIn = _i13.ProtocolSignIn(
        server.baseUrl,
        () => server.client,
      ),
      _recoverAccount = _i14.RecoverAccount(
        server.baseUrl,
        () => server.client,
      ),
      _requestRecoveryEmail = _i15.RequestRecoveryEmail(
        server.baseUrl,
        () => server.client,
      ),
      _redeemRecoveryEmail = _i16.RedeemRecoveryEmail(
        server.baseUrl,
        () => server.client,
      ),
      _getRecoveryEmail = _i17.GetRecoveryEmail(
        server.baseUrl,
        () => server.client,
      ),
      _registerRecoveryEmail = _i18.RegisterRecoveryEmail(
        server.baseUrl,
        () => server.client,
      ),
      _recoveryEmailLink = _i19.RecoveryEmailLink(
        server.baseUrl,
        () => server.client,
      ),
      _verifyRecoveryEmail = _i20.VerifyRecoveryEmail(
        server.baseUrl,
        () => server.client,
      ),
      _refreshToken = _i21.RefreshToken(server.baseUrl, () => server.client),
      _resetAdmin = _i22.ResetAdmin(server.baseUrl, () => server.client),
      _issueClientCredentialsToken = _i23.IssueClientCredentialsToken(
        server.baseUrl,
        () => server.client,
      ),
      _describeServer = _i24.DescribeServer(
        server.baseUrl,
        () => server.client,
      );

  final _i2.GetTwoFactorStatus _getTwoFactorStatus;

  final _i3.ConfirmTwoFactor _confirmTwoFactor;

  final _i4.DisableTwoFactor _disableTwoFactor;

  final _i5.EnrollTwoFactor _enrollTwoFactor;

  final _i6.AcceptInvitation _acceptInvitation;

  final _i7.Login _login;

  final _i8.Logout _logout;

  final _i9.OwnerChallengeOperation _ownerChallengeOperation;

  final _i10.OwnerStatus _ownerStatus;

  final _i11.OwnerTokenOperation _ownerTokenOperation;

  final _i12.ChangeOwnPassword _changeOwnPassword;

  final _i13.ProtocolSignIn _protocolSignIn;

  final _i14.RecoverAccount _recoverAccount;

  final _i15.RequestRecoveryEmail _requestRecoveryEmail;

  final _i16.RedeemRecoveryEmail _redeemRecoveryEmail;

  final _i17.GetRecoveryEmail _getRecoveryEmail;

  final _i18.RegisterRecoveryEmail _registerRecoveryEmail;

  final _i19.RecoveryEmailLink _recoveryEmailLink;

  final _i20.VerifyRecoveryEmail _verifyRecoveryEmail;

  final _i21.RefreshToken _refreshToken;

  final _i22.ResetAdmin _resetAdmin;

  final _i23.IssueClientCredentialsToken _issueClientCredentialsToken;

  final _i24.DescribeServer _describeServer;

  /// Read your authenticator status
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "data": {
  ///     "enabled": false,
  ///     "pending": false
  ///   }
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "unauthenticated" — No session credential was sent:
  /// No Authorization header or access cookie. The real production router proves this refusal.
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
  /// Response 413 (application/json):
  /// **Example** "request_too_large" — The request exceeds the configured transport body cap:
  /// Precondition: a current session sends Content-Length above APIMaxBodyBytes, even on this GET. The registered-route test sets the transport size directly; there is no typed request body.
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
  /// **Example** "internal_error" — The authenticator store fails after session verification:
  /// Fault precondition: the session is current but the two-factor store read fails. The real registration and error adapter sanitize dependency details.
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
  /// Fault precondition: the database-backed current-session check fails. The real production router with a failing database proves this response.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i27.GetTwoFactorStatusResponse, _i28.Response>>
  getTwoFactorStatus({_i26.TonikCancellation? cancellation}) async =>
      _getTwoFactorStatus(cancellation: cancellation);

  /// Switch on a pending authenticator with its first code
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "already_enabled" — The account has an authenticator already:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "code_missing" — No code is sent:
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "confirmed" — The pending authenticator is confirmed:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "invalid_code" — The code does not match the pending authenticator:
  /// ```json
  /// {
  ///   "totp_code": "000000"
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
  /// **Example** "no_pending" — No enrollment is waiting to be confirmed:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
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
  /// **Example** "no_pending" — No enrollment is waiting to be confirmed:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "No pending 2FA enrollment to confirm"
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
  /// **Example** "invalid_code" — The code does not match the pending authenticator:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_totp",
  ///     "message": "Invalid two-factor authentication code"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "already_enabled" — The account has an authenticator already:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "conflict",
  ///     "message": "Two-factor authentication is already enabled"
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
  /// **Example** "code_missing" — No code is sent:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "totp_code": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  _i25.Future<_i26.TonikResult<_i29.ConfirmTwoFactorResponse, _i28.Response>>
  confirmTwoFactor({
    required _i30.ConfirmRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _confirmTwoFactor(body: body, cancellation: cancellation);

  /// Turn two-factor authentication off
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "code_missing" — Neither code is sent:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "disabled" — Two-factor authentication is turned off:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "totp_code": "123456"
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
  /// **Example** "not_enabled" — The account has no authenticator to turn off:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "wrong_recovery_code" — The recovery code is wrong or used:
  /// ```json
  /// {
  ///   "recovery_code": "AAAA-BBBB-CCCC"
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
  /// **Example** "not_enabled" — The account has no authenticator to turn off:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Two-factor authentication is not enabled"
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
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recent_two_factor_required",
  ///     "message": "Sign in again with two-factor authentication: a recent second factor is required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_recovery_code" — The recovery code is wrong or used:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_recovery_code",
  ///     "message": "Invalid or already used recovery code"
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
  /// **Example** "code_missing" — Neither code is sent:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "totp_code": "required unless recovery_code is sent"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  _i25.Future<_i26.TonikResult<_i31.DisableTwoFactorResponse, _i28.Response>>
  disableTwoFactor({
    required _i32.DisableRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _disableTwoFactor(body: body, cancellation: cancellation);

  /// Start an authenticator enrollment
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "example" — The operation's example:
  /// ```json
  /// {
  ///   "data": {
  ///     "otpauth_url": "otpauth://totp/REST%20Mail:user%40restmail.test?secret=JBSWY3DPEHPK3PXP&issuer=REST%20Mail",
  ///     "recovery_codes": [
  ///       "0123456789abcdef"
  ///     ],
  ///     "secret": "JBSWY3DPEHPK3PXP"
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
  /// **Example** "disabled" — The server has two-factor authentication off:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "forbidden",
  ///     "message": "Two-factor authentication is disabled on this server"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "already_enabled" — The account has an authenticator already:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "conflict",
  ///     "message": "Two-factor authentication is already enabled; disable it first"
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
  _i25.Future<_i26.TonikResult<_i33.EnrollTwoFactorResponse, _i28.Response>>
  enrollTwoFactor({_i26.TonikCancellation? cancellation}) async =>
      _enrollTwoFactor(cancellation: cancellation);

  /// Choose your first password with an invitation
  /// Redeems an invitation once, chooses a password of 12–72 bytes and signs in. The session can only finish authenticator enrollment until it is confirmed. Owner reset tokens cannot be used here. Native clients send client: native; browsers receive httpOnly session cookies.
  ///
  /// Request body (application/json):
  /// **Example** "accepted":
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": 3
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
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
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "unavailable":
  /// ```json
  /// {
  ///   "password": "the recipient chooses this password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "accepted":
  /// ```json
  /// {
  ///   "data": {
  ///     "expires_in": 900,
  ///     "setup_required": [
  ///       "two_factor"
  ///     ],
  ///     "user": {
  ///       "display_name": "",
  ///       "email": "invited@example.test",
  ///       "id": 12
  ///     }
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
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_token",
  ///     "message": "the token is not valid: unknown, already used, or expired"
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "token": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to redeem the token"
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
  _i25.Future<_i26.TonikResult<_i34.AcceptInvitationResponse, _i28.Response>>
  acceptInvitation({
    required _i35.AcceptInvitationRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _acceptInvitation(body: body, cancellation: cancellation);

  /// Sign an account in with its address and password
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "client_invalid":
  /// ```json
  /// {
  ///   "client": "desktop",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
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
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "sessions_restricted" — The server's capabilities leave the account no session:
  /// Precondition: the server ceiling holds neither mailbox:session nor admin:session for this account. The password is right, but no session may be issued.
  ///
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "contract-admin-password"
  /// }
  /// ```
  ///
  /// **Example** "signed_in":
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "wrong_password":
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "password": "contract-wrong-password"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "signed_in":
  /// ```json
  /// {
  ///   "data": {
  ///     "access_token": "example-access-token",
  ///     "expires_in": 900,
  ///     "refresh_expires_in": 604800,
  ///     "refresh_token": "example-refresh-token",
  ///     "user": {
  ///       "display_name": "Admin",
  ///       "email": "admin@restmail.test",
  ///       "id": 1
  ///     }
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
  /// **Example** "wrong_password":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid email or password"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "sessions_restricted" — The server's capabilities leave the account no session:
  /// Precondition: the server ceiling holds neither mailbox:session nor admin:session for this account. The password is right, but no session may be issued.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "access_restricted",
  ///     "message": "This server is not accepting sign-ins for this account right now"
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
  /// **Example** "client_invalid":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "client": "must be \"native\" or omitted"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  ///     "message": "Failed to verify the password"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i36.LoginResponseWrapper, _i28.Response>>
  login({
    required _i37.LoginRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _login(body: body, cancellation: cancellation);

  /// Log out — revoke the session and clear the auth cookies
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// The harness signs a current refresh token before making its database store fail.
  ///
  /// ```json
  /// {
  ///   "refresh_token": "fixture-refresh-token"
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
  /// **Example** "signed_out" — The session is revoked and its cookies cleared:
  /// A missing or unknown refresh token still clears the client's state.
  ///
  /// ```json
  /// {
  ///   "refresh_token": "contract-invalid-token"
  /// }
  /// ```
  ///
  /// **Example** "token_not_string" — The refresh token is not a string:
  /// ```json
  /// {
  ///   "refresh_token": 7
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
  /// **Example** "token_not_string" — The refresh token is not a string:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "refresh_token": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// Response 500 (application/json):
  /// **Example** "internal_error" — A database fault is not a client error:
  /// The harness signs a current refresh token before making its database store fail.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i38.LogoutResponse, _i28.Response>> logout({
    _i39.ApiV1AuthLogoutPostBodyBodyOneOfModel? body,
    _i26.TonikCancellation? cancellation,
  }) async => _logout(body: body, cancellation: cancellation);

  /// A challenge for an owner key to sign
  /// The first half of proving ownership with a key in the owner registry (restmail reset-admin), or of reading the status with a key in RESTMAIL_STATUS_KEYS (restmail status --key). Stateless, valid two minutes, answered once. 409 no_owner_keys when the server lists neither.
  ///
  /// Response 200 (application/json):
  /// **Example** "issued" — A challenge to sign:
  /// ```json
  /// {
  ///   "data": {
  ///     "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///     "expires_at": "2026-10-20T00:05:00Z"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "no_keys" — The server has no owner or status keys:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "no_owner_keys",
  ///     "message": "this server lists no status keys (RESTMAIL_STATUS_KEYS) and no owner keys (RESTMAIL_OWNER_KEYS)"
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
  ///     "message": "Failed to read owner key registry"
  ///   }
  /// }
  /// ```
  _i25.Future<
    _i26.TonikResult<_i40.OwnerChallengeOperationResponse, _i28.Response>
  >
  ownerChallengeOperation({_i26.TonikCancellation? cancellation}) async =>
      _ownerChallengeOperation(cancellation: cancellation);

  /// Trade a signed challenge for what the server runs
  /// How a deploy is confirmed from outside (restmail status --key): the owner scheme with the purpose status and no address, by a key in RESTMAIL_STATUS_KEYS or the owner registry. The challenge is spent.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — The body is not JSON:
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "no_keys" — The server has no status or owner keys:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "not_status_key" — The key is not listed:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOther other@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "signature_not_base64" — The signature is not base64:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "not base64!"
  /// }
  /// ```
  ///
  /// **Example** "status" — The running version, for a status key:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — An invalid ownership challenge cannot authenticate the caller:
  /// ```json
  /// {
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample status@example",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "status" — The running version, for a status key:
  /// ```json
  /// {
  ///   "data": {
  ///     "built_at": "2026-10-20T00:00:00Z",
  ///     "commit": "3350b002",
  ///     "started_at": "2026-10-20T00:00:00Z",
  ///     "version": "0.24.0"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — The body is not JSON:
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
  /// **Example** "unauthenticated" — An invalid ownership challenge cannot authenticate the caller:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_challenge",
  ///     "message": "the challenge is not valid: unknown, expired, or already answered"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "not_status_key" — The key is not listed:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_status_key",
  ///     "message": "that key is not one of this server's status or owner keys, or the signature does not match"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "no_keys" — The server has no status or owner keys:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "no_status_keys",
  ///     "message": "this server lists no status keys (RESTMAIL_STATUS_KEYS) and no owner keys (RESTMAIL_OWNER_KEYS)"
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
  /// **Example** "signature_not_base64" — The signature is not base64:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "signature": "must be base64"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  ///     "message": "Failed to read owner key registry"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i41.OwnerStatusResponse, _i28.Response>>
  ownerStatus({
    required _i42.OwnerStatusRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _ownerStatus(body: body, cancellation: cancellation);

  /// Trade a signed challenge for a reset-admin token
  /// signature is the SSH wire-format signature (base64), by the private half of public_key, over "restmail-owner-v1\n" + purpose + "\n" + address + "\n" + challenge. The key must be in the owner registry; a status key is refused. The token is redeemed at /api/v1/auth/reset.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — The body is not JSON:
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "minted" — A reset token for an owner key:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "no_account" — The address is no account:
  /// ```json
  /// {
  ///   "address": "nobody@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "no_keys" — The server has no owner keys:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "not_owner" — The key is not an owner key:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOther other@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "purpose_invalid" — The purpose is not reset-admin:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "other",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — An invalid ownership challenge cannot authenticate the caller:
  /// ```json
  /// {
  ///   "address": "admin@restmail.test",
  ///   "challenge": "c2lnbiB0aGlzIGNoYWxsZW5nZQ",
  ///   "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample owner@example",
  ///   "purpose": "reset-admin",
  ///   "signature": "c2lnbmF0dXJl"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "minted" — A reset token for an owner key:
  /// ```json
  /// {
  ///   "data": {
  ///     "expires_at": "2026-10-20T00:15:00Z",
  ///     "purpose": "reset-admin",
  ///     "token": "example-reset-token"
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — The body is not JSON:
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
  /// **Example** "unauthenticated" — An invalid ownership challenge cannot authenticate the caller:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_challenge",
  ///     "message": "the challenge is not valid: unknown, expired, or already answered"
  ///   }
  /// }
  /// ```
  ///
  /// Response 403 (application/json):
  /// **Example** "not_owner" — The key is not an owner key:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "not_owner",
  ///     "message": "that key is not one of this server's owner keys, or the signature does not match"
  ///   }
  /// }
  /// ```
  ///
  /// Response 404 (application/json):
  /// **Example** "no_account" — The address is no account:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "no_such_account",
  ///     "message": "no such account"
  ///   }
  /// }
  /// ```
  ///
  /// Response 409 (application/json):
  /// **Example** "no_keys" — The server has no owner keys:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "no_owner_keys",
  ///     "message": "this server has no registered owner keys"
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
  /// **Example** "purpose_invalid" — The purpose is not reset-admin:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "purpose": "must be \"reset-admin\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  ///     "message": "Failed to read owner key registry"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i43.OwnerTokenOperationResponse, _i28.Response>>
  ownerTokenOperation({
    required _i44.OwnerTokenRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _ownerTokenOperation(body: body, cancellation: cancellation);

  /// Replace your own password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "changed" — The password is changed; sessions end:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — The body is not JSON:
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "same_password" — The new password is the current one:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "the current password"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "current_password": "the current password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// **Example** "wrong_current" — The current password is wrong:
  /// ```json
  /// {
  ///   "current_password": "not the password",
  ///   "new_password": "a new password of my own"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "changed" — The password is changed; sessions end:
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Password changed. Sign in again with the new password."
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — The body is not JSON:
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
  /// **Example** "recent_two_factor_required" — A stale second-factor sign-in must authenticate again:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recent_two_factor_required",
  ///     "message": "Sign in again with two-factor authentication: a recent second factor is required"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "two_factor_required" — A password-only session cannot perform this sensitive action:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "two_factor_required",
  ///     "message": "This action needs a session signed in with two-factor authentication: sign in again with your code"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "wrong_current" — The current password is wrong:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_password",
  ///     "message": "Current password is incorrect"
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
  /// **Example** "same_password" — The new password is the current one:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "new_password": "must differ from the current password"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  _i25.Future<_i26.TonikResult<_i45.ChangeOwnPasswordResponse, _i28.Response>>
  changeOwnPassword({
    required _i46.ChangePasswordRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _changeOwnPassword(body: body, cancellation: cancellation);

  /// Sign a mail client in (protocol gateways)
  ///
  /// Security:
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "csrf_mismatch" — A cookie session sends no CSRF header:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database failure prevents HTTP Basic credential verification:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "malformed_json":
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "protocol_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "sessions_restricted" — The server's capabilities leave the mailbox no session:
  /// Precondition: the server ceiling no longer holds mailbox:session. Being an administrator does not stand in for it.
  ///
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "signed_in":
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "storage_unavailable":
  /// HTTP Basic authentication succeeds for admin@restmail.test with fixture-password; the subsequent protocol account read fails. A credential-verification fault would instead answer 503.
  ///
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — No credential is sent:
  /// ```json
  /// {
  ///   "protocol": "imap"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "signed_in":
  /// ```json
  /// {
  ///   "data": {
  ///     "credential_id": 1,
  ///     "credential_kind": "app_password",
  ///     "user": {
  ///       "display_name": "Contract Ordinary",
  ///       "email": "contract-ordinary@restmail.test",
  ///       "id": 1
  ///     }
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
  /// **Example** "csrf_mismatch" — A cookie session sends no CSRF header:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "csrf_failed",
  ///     "message": "Missing or invalid CSRF token"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "sessions_restricted" — The server's capabilities leave the mailbox no session:
  /// Precondition: the server ceiling no longer holds mailbox:session. Being an administrator does not stand in for it.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "access_restricted",
  ///     "message": "This server is not accepting sign-ins for this account right now"
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
  /// **Example** "invalid_body":
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
  /// **Example** "protocol_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "protocol": "must be \"imap\", \"pop3\" or \"smtp\""
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "storage_unavailable":
  /// HTTP Basic authentication succeeds for admin@restmail.test with fixture-password; the subsequent protocol account read fails. A credential-verification fault would instead answer 503.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to load the account"
  ///   }
  /// }
  /// ```
  ///
  /// Response 503 (application/json):
  /// **Example** "internal_error" — A database failure prevents HTTP Basic credential verification:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the credential"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "session_unavailable" — The current-session lookup fails:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Could not verify the session"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i47.ProtocolSignInResponse, _i28.Response>>
  protocolSignIn({
    required _i48.ProtocolSignInRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _protocolSignIn(body: body, cancellation: cancellation);

  /// Reset a forgotten password with the authenticator and a recovery code
  /// Each address may be refused 5 times, then once per 15 minutes: 429 rate_limited with Retry-After.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "client_invalid" — The client is not native:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "client": "desktop",
  ///   "email": "admin@restmail.test",
  ///   "new_password": "a new password of my own",
  ///   "recovery_code": "AAAA-BBBB-CCCC",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "new_password": "a new password of my own",
  ///   "recovery_code": "AAAA-BBBB-CCCC",
  ///   "totp_code": "123456"
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
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "new_password": "a new password of my own",
  ///   "recovery_code": "AAAA-BBBB-CCCC"
  /// }
  /// ```
  ///
  /// **Example** "recovered" — A recovery code sets a new password and signs in:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "new_password": "a new password of my own",
  ///   "recovery_code": "AAAA-BBBB-CCCC",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — Unknown account credentials are refused without a session:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test",
  ///   "new_password": "a new password of my own",
  ///   "recovery_code": "AAAA-BBBB-CCCC",
  ///   "totp_code": "123456"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "recovered" — A recovery code sets a new password and signs in:
  /// ```json
  /// {
  ///   "data": {
  ///     "access_token": "example-access-token",
  ///     "expires_in": 900,
  ///     "refresh_expires_in": 604800,
  ///     "refresh_token": "example-refresh-token",
  ///     "scoped_capabilities": [
  ///       {
  ///         "capability": "mail:read",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mail:send",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mail:send_as",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mail:send_on_behalf",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mail:write",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mailbox:manage",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       },
  ///       {
  ///         "capability": "mailbox:session",
  ///         "scope": "mailbox:admin@restmail.test"
  ///       }
  ///     ],
  ///     "user": {
  ///       "display_name": "Admin",
  ///       "email": "admin@restmail.test",
  ///       "id": 1
  ///     }
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
  /// **Example** "unauthenticated" — Unknown account credentials are refused without a session:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "recovery_failed",
  ///     "message": "Invalid address, authenticator code or recovery code"
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
  /// **Example** "client_invalid" — The client is not native:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "client": "must be \"native\" or omitted"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  ///     "message": "Failed to read the account"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i49.RecoverAccountResponse, _i28.Response>>
  recoverAccount({
    required _i50.RecoverRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _recoverAccount(body: body, cancellation: cancellation);

  /// Request a password recovery link
  /// Supply the account address. The response is identical for unknown, disabled and unverified accounts. Every request uses the same per-address budget (five, then one per 15 minutes), in addition to the shared per-IP authentication throttle. Links expire after 15 minutes; requesting another invalidates the previous link.
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "database_unavailable":
  /// ```json
  /// {
  ///   "email": "person@example.test"
  /// }
  /// ```
  ///
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "email": 3
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "email": "person@example.test"
  /// }
  /// ```
  ///
  /// **Example** "recovery_unconfigured" — Email recovery is not configured:
  /// Precondition: the server has no HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL, so it cannot send a recovery link.
  ///
  /// ```json
  /// {
  ///   "email": "person@example.test"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "email": "person@example.test"
  /// }
  /// ```
  ///
  /// **Example** "success":
  /// ```json
  /// {
  ///   "email": "person@example.test"
  /// }
  /// ```
  ///
  /// **Example** "unknown_account":
  /// ```json
  /// {
  ///   "email": "unknown@example.test"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "database_unavailable":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "If this account has a verified recovery email, a recovery link will be sent."
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "success":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "If this account has a verified recovery email, a recovery link will be sent."
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "unknown_account":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "If this account has a verified recovery email, a recovery link will be sent."
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// Response 503 (application/json):
  /// **Example** "recovery_unconfigured" — Email recovery is not configured:
  /// Precondition: the server has no HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL, so it cannot send a recovery link.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Email recovery requires an HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL"
  ///   }
  /// }
  /// ```
  _i25.Future<
    _i26.TonikResult<_i51.RequestRecoveryEmailResponse, _i28.Response>
  >
  requestRecoveryEmail({
    required _i52.RequestRecoveryEmailRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _requestRecoveryEmail(body: body, cancellation: cancellation);

  /// Choose a new password with a recovery email link
  /// Redeems a verified recovery email token once. Changes the password and ends every session and app password atomically. The authenticator and recovery codes remain; sign in normally with the new password and any required second factor. Does not sign in or enroll new authentication methods.
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": 3
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "success":
  /// ```json
  /// {
  ///   "new_password": "newly chosen password",
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "success":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Password changed. Sign in again with the new password and your existing second factor."
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
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_token",
  ///     "message": "the token is not valid: unknown, already used, or expired"
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "token": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i53.RedeemRecoveryEmailResponse, _i28.Response>>
  redeemRecoveryEmail({
    required _i54.RedeemRecoveryEmailRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _redeemRecoveryEmail(body: body, cancellation: cancellation);

  /// Read your registered recovery email
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Response 200 (application/json):
  /// **Example** "unregistered":
  /// ```json
  /// {
  ///   "data": {
  ///     "email": "",
  ///     "verified": false
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "verified":
  /// ```json
  /// {
  ///   "data": {
  ///     "email": "backup@external.test",
  ///     "verified": true
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
  _i25.Future<_i26.TonikResult<_i55.GetRecoveryEmailResponse, _i28.Response>>
  getRecoveryEmail({_i26.TonikCancellation? cancellation}) async =>
      _getRecoveryEmail(cancellation: cancellation);

  /// Register an external recovery email before lockout
  /// Requires a signed-in session and the current password. Replacing the address clears verification and invalidates previous email tokens. Verification lasts 15 minutes. Recovery address changes freeze for three days after email recovery.
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": 3
  /// }
  /// ```
  ///
  /// **Example** "invalid_password":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// **Example** "recovery_unconfigured" — Email recovery is not configured:
  /// Precondition: the server has no HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL, so it cannot send a recovery link.
  ///
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// **Example** "success":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// **Example** "unauthorized":
  /// ```json
  /// {
  ///   "current_password": "original password chosen",
  ///   "email": "backup@external.test"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "success":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Verification link sent. The address cannot recover your account until verified."
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
  /// **Example** "unauthorized":
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
  /// **Example** "invalid_password":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_password",
  ///     "message": "Current password is incorrect"
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "recovery_unconfigured" — Email recovery is not configured:
  /// Precondition: the server has no HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL, so it cannot send a recovery link.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unavailable",
  ///     "message": "Email recovery requires an HTTPS RESTMAIL_RECOVERY_EMAIL_BASE_URL"
  ///   }
  /// }
  /// ```
  _i25.Future<
    _i26.TonikResult<_i56.RegisterRecoveryEmailResponse, _i28.Response>
  >
  registerRecoveryEmail({
    required _i57.RegisterRecoveryEmailRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _registerRecoveryEmail(body: body, cancellation: cancellation);

  /// Open a private recovery email link
  ///
  /// Response 200 (text/html):
  /// **Example** "page":
  /// ```
  /// <!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>REST Mail account recovery</title><main><h1>Account recovery</h1><p id="message" role="status">Confirm the action below to use your private link.</p><form id="recovery"><label>New password <input id="password" type="password" autocomplete="new-password" minlength="12" maxlength="72"></label><button id="submit" type="submit">Continue</button></form><p>After changing your password, sign in through your usual mail app. Your existing second factor still applies.</p></main><script>
  /// let token = location.hash.slice(1);
  /// const mode = new URLSearchParams(location.search).get('mode');
  /// history.replaceState(null, '', location.pathname);
  /// const form = document.getElementById('recovery');
  /// const message = document.getElementById('message');
  /// const password = document.getElementById('password');
  /// const button = document.getElementById('submit');
  /// if (!token || !['verify','recover'].includes(mode)) {
  ///  message.textContent = 'Invalid link. Request another link.'; form.hidden = true;
  /// } else {
  ///  password.parentElement.hidden = mode !== 'recover';
  ///  password.required = mode === 'recover';
  ///  button.textContent = mode === 'verify' ? 'Verify recovery email' : 'Change password';
  ///  form.addEventListener('submit', async event => {
  ///   event.preventDefault(); button.disabled = true;
  ///   const body = { token };
  ///   if (mode === 'recover') body.new_password = password.value;
  ///   try {
  ///    const response = await fetch(mode === 'verify' ? '/api/v1/auth/recovery-email/verify' : '/api/v1/auth/recover/email/redeem', {
  ///     method: 'POST', credentials: 'omit', headers: {'Content-Type':'application/json'}, body: JSON.stringify(body)
  ///    });
  ///    const result = await response.json();
  ///    message.textContent = response.ok ? result.data.message : result.error.message;
  ///    if (response.ok) { form.hidden = true; password.value = ''; token = ''; } else { button.disabled = false; }
  ///   } catch (_) { message.textContent = 'Request failed. Please try again.'; button.disabled = false; }
  ///  });
  /// }
  /// </script></html>
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
  /// Response 500 (application/json):
  /// **Example** "internal_error" — The shared error adapter sanitizes an unexpected failure:
  /// The endpoint layer advertises a fallback 500. This pair proves its shared response adapter directly; it does not claim that this operation queries a database.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i58.RecoveryEmailLinkResponse, _i28.Response>>
  recoveryEmailLink({_i26.TonikCancellation? cancellation}) async =>
      _recoveryEmailLink(cancellation: cancellation);

  /// Verify a recovery email with its single-use link
  ///
  /// Request body (application/json):
  /// **Example** "body_array":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "token": 3
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
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
  /// **Example** "rate_limited":
  /// ```json
  /// {
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large":
  /// ```json
  /// {
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// **Example** "success":
  /// ```json
  /// {
  ///   "token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "success":
  /// ```json
  /// {
  ///   "data": {
  ///     "message": "Recovery email verified."
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
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_token",
  ///     "message": "the token is not valid: unknown, already used, or expired"
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
  /// **Example** "body_array":
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
  /// **Example** "invalid_field":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "token": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// **Example** "internal_error":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i59.VerifyRecoveryEmailResponse, _i28.Response>>
  verifyRecoveryEmail({
    required _i60.RecoveryEmailTokenRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _verifyRecoveryEmail(body: body, cancellation: cancellation);

  /// Refresh the session (cookie, or body token for native clients)
  /// The refresh token rotates: the one presented stops working, and a reused one ends the session.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// The harness signs a current refresh token before making its database store fail.
  ///
  /// ```json
  /// {
  ///   "refresh_token": "fixture-refresh-token"
  /// }
  /// ```
  ///
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "refresh_token": "contract-invalid-token"
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
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "refresh_token": "contract-invalid-token"
  /// }
  /// ```
  ///
  /// **Example** "refreshed":
  /// ```json
  /// {
  ///   "refresh_token": "fixture-refresh-token"
  /// }
  /// ```
  ///
  /// **Example** "request_too_large" — The request exceeds the transport body cap:
  /// ```json
  /// {
  ///   "refresh_token": "contract-invalid-token"
  /// }
  /// ```
  ///
  /// **Example** "token_not_string" — The refresh token is not a string:
  /// ```json
  /// {
  ///   "refresh_token": 7
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "refreshed":
  /// ```json
  /// {
  ///   "data": {
  ///     "access_token": "example-access-token",
  ///     "expires_in": 900,
  ///     "refresh_expires_in": 604800,
  ///     "refresh_token": "example-refresh-token",
  ///     "user": {
  ///       "display_name": "Admin",
  ///       "email": "admin@restmail.test",
  ///       "id": 1
  ///     }
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
  /// **Example** "invalid_token":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "Invalid or expired refresh token"
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
  /// **Example** "token_not_string" — The refresh token is not a string:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "refresh_token": "must be a string"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  /// The harness signs a current refresh token before making its database store fail.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Failed to verify the session"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i61.RefreshTokenResponse, _i28.Response>>
  refreshToken({
    _i62.ApiV1AuthRefreshPostBodyBodyOneOfModel? body,
    _i26.TonikCancellation? cancellation,
  }) async => _refreshToken(body: body, cancellation: cancellation);

  /// Let an account back in with a reset token; also hands a server over
  /// Redeems a single-use reset_admin token (restmail reset-admin, or an owner key's). The account it names gets the password the redeemer chose, loses its authenticator and must enroll a new one, and its app passwords and every token it was issued are dead at once. A password under 12 bytes is 422 and does not spend the token.
  ///
  /// Request body (application/json):
  /// **Example** "body_array" — The body is not a JSON object:
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "client_invalid" — The client is not native:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "client": "desktop",
  ///   "password": "a new password of my own",
  ///   "token": "example-reset-token"
  /// }
  /// ```
  ///
  /// **Example** "internal_error" — A database fault is not a client error:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "password": "a new password of my own",
  ///   "token": "example-reset-token"
  /// }
  /// ```
  ///
  /// **Example** "malformed_json" — The body is not JSON:
  /// The wire body is the raw truncated JSON byte {, with application/json content type: it is refused before anything else is read.
  ///
  /// ```
  /// {
  /// ```
  ///
  /// **Example** "rate_limited" — The limit is already spent:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "password": "a new password of my own",
  ///   "token": "example-reset-token"
  /// }
  /// ```
  ///
  /// **Example** "reset" — A minted reset token sets the password and signs in:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "password": "a new password of my own",
  ///   "token": "example-reset-token"
  /// }
  /// ```
  ///
  /// **Example** "unauthenticated" — An invalid reset token cannot authenticate the caller:
  /// ```json
  /// {
  ///   "client": "native",
  ///   "password": "a new password of my own",
  ///   "token": "example-reset-token"
  /// }
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "reset" — A minted reset token sets the password and signs in:
  /// ```json
  /// {
  ///   "data": {
  ///     "access_token": "example-access-token",
  ///     "expires_in": 900,
  ///     "refresh_expires_in": 604800,
  ///     "refresh_token": "example-refresh-token",
  ///     "setup_required": [
  ///       "two_factor"
  ///     ],
  ///     "user": {
  ///       "display_name": "Admin",
  ///       "email": "admin@restmail.test",
  ///       "id": 1
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "malformed_json" — The body is not JSON:
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
  /// **Example** "unauthenticated" — An invalid reset token cannot authenticate the caller:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "invalid_token",
  ///     "message": "the token is not valid: unknown, already used, or expired"
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
  /// **Example** "client_invalid" — The client is not native:
  /// The handler refuses it by a rule the request type does not state, so the request is not marked invalid.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "client": "must be \"native\" or omitted"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
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
  ///     "message": "Failed to redeem the token"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i63.ResetAdminResponse, _i28.Response>>
  resetAdmin({
    required _i64.ResetRequest body,
    _i26.TonikCancellation? cancellation,
  }) async => _resetAdmin(body: body, cancellation: cancellation);

  /// Exchange a client secret for a five-minute access token
  /// RFC 6749 client_credentials grant. Send grant_type=client_credentials and authenticate with the credential's public client_id and client_secret, either in this form or with HTTP Basic (never both). Returns a 300-second bearer access token, without a refresh token or human two-factor authentication. Permissions are selected at credential creation; a scope request is refused. Every use reloads the credential and live account grants, so revocation, expiry, account disablement and removed grants take effect on the next request. Shares the sign-in throttle. Successful issue is audited as oauth.token_issue with the actor and credential id. Responses are Cache-Control: no-store and Pragma: no-cache.
  ///
  /// Request body (application/x-www-form-urlencoded):
  /// **Example** "duplicate_parameter":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&client_id=other
  /// ```
  ///
  /// **Example** "issued":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  /// ```
  ///
  /// **Example** "rate_limited":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  /// ```
  ///
  /// **Example** "revoked":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  /// ```
  ///
  /// **Example** "scope_refused":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&scope=mail:read
  /// ```
  ///
  /// **Example** "storage_unavailable":
  /// The client-secret lookup fails. The OAuth error retains Cache-Control: no-store and Pragma: no-cache.
  ///
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  /// ```
  ///
  /// **Example** "unsupported_grant":
  /// ```
  /// grant_type=password&client_id=9Hm3yU1cNp5Q&client_secret=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  /// ```
  ///
  /// **Example** "wrong_secret":
  /// ```
  /// grant_type=client_credentials&client_id=9Hm3yU1cNp5Q&client_secret=wrong-secret
  /// ```
  ///
  /// Response 200 (application/json):
  /// **Example** "issued":
  /// ```json
  /// {
  ///   "access_token": "eyJhbGciOiJIUzI1NiJ9.example.signature",
  ///   "expires_in": 300,
  ///   "token_type": "Bearer"
  /// }
  /// ```
  ///
  /// Response 400 (application/json):
  /// **Example** "duplicate_parameter":
  /// ```json
  /// {
  ///   "error": "invalid_request",
  ///   "error_description": "Repeated parameter"
  /// }
  /// ```
  ///
  /// **Example** "scope_refused":
  /// ```json
  /// {
  ///   "error": "invalid_scope",
  ///   "error_description": "Permissions are selected when creating the credential"
  /// }
  /// ```
  ///
  /// **Example** "unsupported_grant":
  /// ```json
  /// {
  ///   "error": "unsupported_grant_type",
  ///   "error_description": "Use client_credentials"
  /// }
  /// ```
  ///
  /// Response 401 (application/json):
  /// **Example** "revoked":
  /// ```json
  /// {
  ///   "error": "invalid_client",
  ///   "error_description": "Invalid client credentials"
  /// }
  /// ```
  ///
  /// **Example** "wrong_secret":
  /// ```json
  /// {
  ///   "error": "invalid_client",
  ///   "error_description": "Invalid client credentials"
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
  /// **Example** "storage_unavailable":
  /// The client-secret lookup fails. The OAuth error retains Cache-Control: no-store and Pragma: no-cache.
  ///
  /// ```json
  /// {
  ///   "error": "server_error",
  ///   "error_description": "Could not verify client credentials"
  /// }
  /// ```
  _i25.Future<
    _i26.TonikResult<_i65.IssueClientCredentialsTokenResponse, _i28.Response>
  >
  issueClientCredentialsToken({
    required _i25.String body,
    _i26.TonikCancellation? cancellation,
  }) async =>
      _issueClientCredentialsToken(body: body, cancellation: cancellation);

  /// What this server is
  ///
  /// Response 200 (application/json):
  /// **Example** "available" — Public discovery answers without credentials:
  /// Build and version fields reflect the running binary. Their example values do not pin the release being tested.
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "product": "rest-mail",
  ///     "version": "0.27.4"
  ///   }
  /// }
  /// ```
  ///
  /// Response 429 (application/json):
  /// **Example** "rate_limited" — Discovery respects the shared per-IP owner-endpoint throttle:
  /// Precondition: authentication throttling is enabled and this client has exhausted the shared owner-endpoint bucket. The registered-router test proves the first success, subsequent429 and Retry-After header.
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
  /// **Example** "internal_error" — The shared error adapter sanitizes an unexpected failure:
  /// The endpoint layer advertises a fallback 500. This pair proves its shared response adapter directly; it does not claim that this operation queries a database.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i25.Future<_i26.TonikResult<_i66.DescribeServerResponse, _i28.Response>>
  describeServer({_i26.TonikCancellation? cancellation}) async =>
      _describeServer(cancellation: cancellation);
}
