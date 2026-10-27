// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post409_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth2fa_enroll_post503_response.dart'
    as _i10;

sealed class EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse();
}

@_i1.immutable
class EnrollTwoFactorResponse200 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse200({required this.body});

  final _i2.ApiV1Auth2faEnrollPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse401 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse401({required this.body});

  final _i4.ApiV1Auth2faEnrollPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse403 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse403({required this.body});

  final _i5.ApiV1Auth2faEnrollPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse409 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse409({required this.body});

  final _i6.ApiV1Auth2faEnrollPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse413 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse413({required this.body});

  final _i7.ApiV1Auth2faEnrollPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse429 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse429({required this.body});

  final _i8.ApiV1Auth2faEnrollPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse500 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse500({required this.body});

  final _i9.ApiV1Auth2faEnrollPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EnrollTwoFactorResponse503 extends EnrollTwoFactorResponse {
  const EnrollTwoFactorResponse503({required this.body});

  final _i10.ApiV1Auth2faEnrollPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnrollTwoFactorResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
