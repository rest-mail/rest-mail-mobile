// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_login_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_login_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_login_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_login_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_login_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_login_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_login_post500_response.dart'
    as _i9;

sealed class LoginResponseWrapper {
  const LoginResponseWrapper();
}

@_i1.immutable
class LoginResponseWrapper200 extends LoginResponseWrapper {
  const LoginResponseWrapper200({required this.body});

  final _i2.ApiV1AuthLoginPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper400 extends LoginResponseWrapper {
  const LoginResponseWrapper400({required this.body});

  final _i4.ApiV1AuthLoginPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper401 extends LoginResponseWrapper {
  const LoginResponseWrapper401({required this.body});

  final _i5.ApiV1AuthLoginPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper413 extends LoginResponseWrapper {
  const LoginResponseWrapper413({required this.body});

  final _i6.ApiV1AuthLoginPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper422 extends LoginResponseWrapper {
  const LoginResponseWrapper422({required this.body});

  final _i7.ApiV1AuthLoginPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper429 extends LoginResponseWrapper {
  const LoginResponseWrapper429({required this.body});

  final _i8.ApiV1AuthLoginPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LoginResponseWrapper500 extends LoginResponseWrapper {
  const LoginResponseWrapper500({required this.body});

  final _i9.ApiV1AuthLoginPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginResponseWrapper500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
