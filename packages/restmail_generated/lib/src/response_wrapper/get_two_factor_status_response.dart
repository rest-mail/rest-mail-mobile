// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth2fa_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth2fa_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth2fa_get413_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth2fa_get500_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth2fa_get503_response.dart'
    as _i7;

sealed class GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse();
}

@_i1.immutable
class GetTwoFactorStatusResponse200 extends GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse200({required this.body});

  final _i2.ApiV1Auth2faGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetTwoFactorStatusResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetTwoFactorStatusResponse401 extends GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse401({required this.body});

  final _i4.ApiV1Auth2faGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetTwoFactorStatusResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetTwoFactorStatusResponse413 extends GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse413({required this.body});

  final _i5.ApiV1Auth2faGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetTwoFactorStatusResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetTwoFactorStatusResponse500 extends GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse500({required this.body});

  final _i6.ApiV1Auth2faGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetTwoFactorStatusResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetTwoFactorStatusResponse503 extends GetTwoFactorStatusResponse {
  const GetTwoFactorStatusResponse503({required this.body});

  final _i7.ApiV1Auth2faGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetTwoFactorStatusResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
