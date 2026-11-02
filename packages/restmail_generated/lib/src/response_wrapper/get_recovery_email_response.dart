// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_get503_response.dart'
    as _i8;

sealed class GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse();
}

@_i1.immutable
class GetRecoveryEmailResponse200 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse200({required this.body});

  final _i2.ApiV1AuthRecoveryEmailGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRecoveryEmailResponse401 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse401({required this.body});

  final _i4.ApiV1AuthRecoveryEmailGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRecoveryEmailResponse403 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse403({required this.body});

  final _i5.ApiV1AuthRecoveryEmailGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRecoveryEmailResponse413 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse413({required this.body});

  final _i6.ApiV1AuthRecoveryEmailGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRecoveryEmailResponse500 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse500({required this.body});

  final _i7.ApiV1AuthRecoveryEmailGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRecoveryEmailResponse503 extends GetRecoveryEmailResponse {
  const GetRecoveryEmailResponse503({required this.body});

  final _i8.ApiV1AuthRecoveryEmailGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRecoveryEmailResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
