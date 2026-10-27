// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_logout_post204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_logout_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_logout_post413_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_logout_post422_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_logout_post500_response.dart'
    as _i7;

sealed class LogoutResponse {
  const LogoutResponse();
}

@_i1.immutable
class LogoutResponse204 extends LogoutResponse {
  const LogoutResponse204({required this.body});

  final _i2.ApiV1AuthLogoutPost204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LogoutResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LogoutResponse400 extends LogoutResponse {
  const LogoutResponse400({required this.body});

  final _i4.ApiV1AuthLogoutPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LogoutResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LogoutResponse413 extends LogoutResponse {
  const LogoutResponse413({required this.body});

  final _i5.ApiV1AuthLogoutPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LogoutResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LogoutResponse422 extends LogoutResponse {
  const LogoutResponse422({required this.body});

  final _i6.ApiV1AuthLogoutPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LogoutResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LogoutResponse500 extends LogoutResponse {
  const LogoutResponse500({required this.body});

  final _i7.ApiV1AuthLogoutPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LogoutResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
