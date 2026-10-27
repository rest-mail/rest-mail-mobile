// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i18;

import 'package:http/http.dart' as _i21;
import 'package:restmail_generated/src/model/api_v1_auth_logout_post_body_body_one_of_model.dart'
    as _i32;
import 'package:restmail_generated/src/model/api_v1_auth_refresh_post_body_body_one_of_model.dart'
    as _i45;
import 'package:restmail_generated/src/model/change_password_request.dart'
    as _i39;
import 'package:restmail_generated/src/model/confirm_request.dart' as _i23;
import 'package:restmail_generated/src/model/disable_request.dart' as _i25;
import 'package:restmail_generated/src/model/login_request.dart' as _i30;
import 'package:restmail_generated/src/model/owner_status_request.dart' as _i35;
import 'package:restmail_generated/src/model/owner_token_request.dart' as _i37;
import 'package:restmail_generated/src/model/protocol_sign_in_request.dart'
    as _i41;
import 'package:restmail_generated/src/model/recover_request.dart' as _i43;
import 'package:restmail_generated/src/model/reset_request.dart' as _i28;
import 'package:restmail_generated/src/operation/accept_invitation.dart' as _i6;
import 'package:restmail_generated/src/operation/change_own_password.dart'
    as _i12;
import 'package:restmail_generated/src/operation/confirm_two_factor.dart'
    as _i3;
import 'package:restmail_generated/src/operation/describe_server.dart' as _i17;
import 'package:restmail_generated/src/operation/disable_two_factor.dart'
    as _i4;
import 'package:restmail_generated/src/operation/enroll_two_factor.dart' as _i5;
import 'package:restmail_generated/src/operation/get_two_factor_status.dart'
    as _i2;
import 'package:restmail_generated/src/operation/login.dart' as _i7;
import 'package:restmail_generated/src/operation/logout.dart' as _i8;
import 'package:restmail_generated/src/operation/owner_challenge_operation.dart'
    as _i9;
import 'package:restmail_generated/src/operation/owner_status.dart' as _i10;
import 'package:restmail_generated/src/operation/owner_token_operation.dart'
    as _i11;
import 'package:restmail_generated/src/operation/protocol_sign_in.dart' as _i13;
import 'package:restmail_generated/src/operation/recover_account.dart' as _i14;
import 'package:restmail_generated/src/operation/refresh_token.dart' as _i15;
import 'package:restmail_generated/src/operation/reset_admin.dart' as _i16;
import 'package:restmail_generated/src/response_wrapper/accept_invitation_response.dart'
    as _i27;
import 'package:restmail_generated/src/response_wrapper/change_own_password_response.dart'
    as _i38;
import 'package:restmail_generated/src/response_wrapper/confirm_two_factor_response.dart'
    as _i22;
import 'package:restmail_generated/src/response_wrapper/describe_server_response.dart'
    as _i47;
import 'package:restmail_generated/src/response_wrapper/disable_two_factor_response.dart'
    as _i24;
import 'package:restmail_generated/src/response_wrapper/enroll_two_factor_response.dart'
    as _i26;
import 'package:restmail_generated/src/response_wrapper/get_two_factor_status_response.dart'
    as _i20;
import 'package:restmail_generated/src/response_wrapper/login_response_wrapper.dart'
    as _i29;
import 'package:restmail_generated/src/response_wrapper/logout_response.dart'
    as _i31;
import 'package:restmail_generated/src/response_wrapper/owner_challenge_operation_response.dart'
    as _i33;
import 'package:restmail_generated/src/response_wrapper/owner_status_response.dart'
    as _i34;
import 'package:restmail_generated/src/response_wrapper/owner_token_operation_response.dart'
    as _i36;
import 'package:restmail_generated/src/response_wrapper/protocol_sign_in_response.dart'
    as _i40;
import 'package:restmail_generated/src/response_wrapper/recover_account_response.dart'
    as _i42;
import 'package:restmail_generated/src/response_wrapper/refresh_token_response.dart'
    as _i44;
import 'package:restmail_generated/src/response_wrapper/reset_admin_response.dart'
    as _i46;
import 'package:restmail_generated/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i19;

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
      _refreshToken = _i15.RefreshToken(server.baseUrl, () => server.client),
      _resetAdmin = _i16.ResetAdmin(server.baseUrl, () => server.client),
      _describeServer = _i17.DescribeServer(
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

  final _i15.RefreshToken _refreshToken;

  final _i16.ResetAdmin _resetAdmin;

  final _i17.DescribeServer _describeServer;

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
  _i18.Future<_i19.TonikResult<_i20.GetTwoFactorStatusResponse, _i21.Response>>
  getTwoFactorStatus({_i19.TonikCancellation? cancellation}) async =>
      _getTwoFactorStatus(cancellation: cancellation);

  /// Switch on a pending authenticator with its first code
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i18.Future<_i19.TonikResult<_i22.ConfirmTwoFactorResponse, _i21.Response>>
  confirmTwoFactor({
    required _i23.ConfirmRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _confirmTwoFactor(body: body, cancellation: cancellation);

  /// Turn two-factor authentication off
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i18.Future<_i19.TonikResult<_i24.DisableTwoFactorResponse, _i21.Response>>
  disableTwoFactor({
    required _i25.DisableRequest body,
    _i19.TonikCancellation? cancellation,
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
  _i18.Future<_i19.TonikResult<_i26.EnrollTwoFactorResponse, _i21.Response>>
  enrollTwoFactor({_i19.TonikCancellation? cancellation}) async =>
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
  /// **Example** "wrong_purpose":
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
  /// **Example** "wrong_purpose":
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
  _i18.Future<_i19.TonikResult<_i27.AcceptInvitationResponse, _i21.Response>>
  acceptInvitation({
    required _i28.ResetRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _acceptInvitation(body: body, cancellation: cancellation);

  /// Sign an account in with its address and password
  ///
  /// Request body (application/json):
  /// **Example** "client_invalid":
  /// ```json
  /// {
  ///   "client": "desktop",
  ///   "email": "admin@restmail.test",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "client": "native",
  ///   "password": "fixture-password"
  /// }
  /// ```
  ///
  /// **Example** "password_missing":
  /// ```json
  /// {
  ///   "client": "native",
  ///   "email": "admin@restmail.test"
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
  /// Response 422 (application/json):
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
  /// **Example** "email_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "email": "required: the account's address"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  ///
  /// **Example** "password_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "validation_failed",
  ///     "details": {
  ///       "fields": {
  ///         "password": "required"
  ///       }
  ///     },
  ///     "message": "Request body failed validation"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i29.LoginResponseWrapper, _i21.Response>>
  login({
    required _i30.LoginRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _login(body: body, cancellation: cancellation);

  /// Log out — revoke the session and clear the auth cookies
  _i18.Future<_i19.TonikResult<_i31.LogoutResponse, _i21.Response>> logout({
    _i32.ApiV1AuthLogoutPostBodyBodyOneOfModel? body,
    _i19.TonikCancellation? cancellation,
  }) async => _logout(body: body, cancellation: cancellation);

  /// A challenge for an owner key to sign
  /// The first half of proving ownership with a key in the owner registry (restmail reset-admin), or of reading the status with a key in RESTMAIL_STATUS_KEYS (restmail status --key). Stateless, valid two minutes, answered once. 409 no_owner_keys when the server lists neither.
  _i18.Future<
    _i19.TonikResult<_i33.OwnerChallengeOperationResponse, _i21.Response>
  >
  ownerChallengeOperation({_i19.TonikCancellation? cancellation}) async =>
      _ownerChallengeOperation(cancellation: cancellation);

  /// Trade a signed challenge for what the server runs
  /// How a deploy is confirmed from outside (restmail status --key): the owner scheme with the purpose status and no address, by a key in RESTMAIL_STATUS_KEYS or the owner registry. The challenge is spent.
  _i18.Future<_i19.TonikResult<_i34.OwnerStatusResponse, _i21.Response>>
  ownerStatus({
    required _i35.OwnerStatusRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _ownerStatus(body: body, cancellation: cancellation);

  /// Trade a signed challenge for a reset-admin token
  /// signature is the SSH wire-format signature (base64), by the private half of public_key, over "restmail-owner-v1\n" + purpose + "\n" + address + "\n" + challenge. The key must be in the owner registry; a status key is refused. The token is redeemed at /api/v1/auth/reset.
  _i18.Future<_i19.TonikResult<_i36.OwnerTokenOperationResponse, _i21.Response>>
  ownerTokenOperation({
    required _i37.OwnerTokenRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _ownerTokenOperation(body: body, cancellation: cancellation);

  /// Replace your own password
  ///
  /// Security:
  /// - API Key (cookie): httpOnly session cookie set by POST /api/v1/auth/login and /api/v1/auth/refresh. State-changing requests (POST/PUT/PATCH/DELETE) additionally require the double-submit CSRF header.
  /// - HTTP Bearer: JWT access token as an Authorization: Bearer header. Exempt from the CSRF check.
  _i18.Future<_i19.TonikResult<_i38.ChangeOwnPasswordResponse, _i21.Response>>
  changeOwnPassword({
    required _i39.ChangePasswordRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _changeOwnPassword(body: body, cancellation: cancellation);

  /// Sign a mail client in (protocol gateways)
  ///
  /// Security:
  /// - HTTP Basic: A mailbox's address and one of its app passwords, as HTTP Basic. Accepted only by the operations that list it.
  ///
  /// Request body (application/json):
  /// **Example** "invalid_body":
  /// ```json
  /// []
  /// ```
  ///
  /// **Example** "protocol_missing":
  /// ```json
  /// {}
  /// ```
  ///
  /// **Example** "signed_in":
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
  /// **Example** "invalid_body":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "bad_request",
  ///     "message": "Invalid request body"
  ///   }
  /// }
  /// ```
  ///
  /// Response 422 (application/json):
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
  _i18.Future<_i19.TonikResult<_i40.ProtocolSignInResponse, _i21.Response>>
  protocolSignIn({
    required _i41.ProtocolSignInRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _protocolSignIn(body: body, cancellation: cancellation);

  /// Reset a forgotten password with the authenticator and a recovery code
  /// Each address may be refused 5 times, then once per 15 minutes: 429 rate_limited with Retry-After.
  _i18.Future<_i19.TonikResult<_i42.RecoverAccountResponse, _i21.Response>>
  recoverAccount({
    required _i43.RecoverRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _recoverAccount(body: body, cancellation: cancellation);

  /// Refresh the session (cookie, or body token for native clients)
  /// The refresh token rotates: the one presented stops working, and a reused one ends the session.
  ///
  /// Request body (application/json):
  /// **Example** "invalid_token":
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
  /// **Example** "token_missing":
  /// ```json
  /// {}
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
  /// **Example** "token_missing":
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "No refresh token"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i44.RefreshTokenResponse, _i21.Response>>
  refreshToken({
    _i45.ApiV1AuthRefreshPostBodyBodyOneOfModel? body,
    _i19.TonikCancellation? cancellation,
  }) async => _refreshToken(body: body, cancellation: cancellation);

  /// Let an account back in with a reset token; also hands a server over
  /// Redeems a single-use reset_admin token (restmail reset-admin, or an owner key's). The account it names gets the password the redeemer chose, loses its authenticator and must enroll a new one, and its app passwords and every token it was issued are dead at once. A password under 12 bytes is 422 and does not spend the token.
  _i18.Future<_i19.TonikResult<_i46.ResetAdminResponse, _i21.Response>>
  resetAdmin({
    required _i28.ResetRequest body,
    _i19.TonikCancellation? cancellation,
  }) async => _resetAdmin(body: body, cancellation: cancellation);

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
  /// **Example** "internal_error" — An unexpected handler failure uses the shared error envelope:
  /// Checked through the production endpoint error adapter; a healthy discovery GET cannot deliberately provoke this fault.
  ///
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "internal_error",
  ///     "message": "Internal server error"
  ///   }
  /// }
  /// ```
  _i18.Future<_i19.TonikResult<_i47.DescribeServerResponse, _i21.Response>>
  describeServer({_i19.TonikCancellation? cancellation}) async =>
      _describeServer(cancellation: cancellation);
}
