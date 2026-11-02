// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_verify_post500_response.dart'
    as _i9;

sealed class VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse();
}

@_i1.immutable
class VerifyRecoveryEmailResponse200 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse200({required this.body});

  final _i2.ApiV1AuthRecoveryEmailVerifyPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse400 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse400({required this.body});

  final _i4.ApiV1AuthRecoveryEmailVerifyPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse401 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse401({required this.body});

  final _i5.ApiV1AuthRecoveryEmailVerifyPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse413 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse413({required this.body});

  final _i6.ApiV1AuthRecoveryEmailVerifyPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse422 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse422({required this.body});

  final _i7.ApiV1AuthRecoveryEmailVerifyPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse429 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse429({required this.body});

  final _i8.ApiV1AuthRecoveryEmailVerifyPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyRecoveryEmailResponse500 extends VerifyRecoveryEmailResponse {
  const VerifyRecoveryEmailResponse500({required this.body});

  final _i9.ApiV1AuthRecoveryEmailVerifyPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyRecoveryEmailResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
