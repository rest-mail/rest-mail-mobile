// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_redeem_post500_response.dart'
    as _i9;

sealed class RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse();
}

@_i1.immutable
class RedeemRecoveryEmailResponse200 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse200({required this.body});

  final _i2.ApiV1AuthRecoverEmailRedeemPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse400 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse400({required this.body});

  final _i4.ApiV1AuthRecoverEmailRedeemPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse401 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse401({required this.body});

  final _i5.ApiV1AuthRecoverEmailRedeemPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse413 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse413({required this.body});

  final _i6.ApiV1AuthRecoverEmailRedeemPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse422 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse422({required this.body});

  final _i7.ApiV1AuthRecoverEmailRedeemPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse429 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse429({required this.body});

  final _i8.ApiV1AuthRecoverEmailRedeemPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RedeemRecoveryEmailResponse500 extends RedeemRecoveryEmailResponse {
  const RedeemRecoveryEmailResponse500({required this.body});

  final _i9.ApiV1AuthRecoverEmailRedeemPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
