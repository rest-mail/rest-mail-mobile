// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth2fa_disable_post503_response.dart'
    as _i11;

sealed class DisableTwoFactorResponse {
  const DisableTwoFactorResponse();
}

@_i1.immutable
class DisableTwoFactorResponse204 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse204({required this.body});

  final _i2.ApiV1Auth2faDisablePost204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse400 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse400({required this.body});

  final _i4.ApiV1Auth2faDisablePost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse401 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse401({required this.body});

  final _i5.ApiV1Auth2faDisablePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse403 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse403({required this.body});

  final _i6.ApiV1Auth2faDisablePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse413 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse413({required this.body});

  final _i7.ApiV1Auth2faDisablePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse422 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse422({required this.body});

  final _i8.ApiV1Auth2faDisablePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse429 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse429({required this.body});

  final _i9.ApiV1Auth2faDisablePost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse500 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse500({required this.body});

  final _i10.ApiV1Auth2faDisablePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableTwoFactorResponse503 extends DisableTwoFactorResponse {
  const DisableTwoFactorResponse503({required this.body});

  final _i11.ApiV1Auth2faDisablePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableTwoFactorResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
