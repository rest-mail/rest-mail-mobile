// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_password_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_password_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_password_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_password_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_password_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_password_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_password_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth_password_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth_password_post503_response.dart'
    as _i11;

sealed class ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse();
}

@_i1.immutable
class ChangeOwnPasswordResponse200 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse200({required this.body});

  final _i2.ApiV1AuthPasswordPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse400 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse400({required this.body});

  final _i4.ApiV1AuthPasswordPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse401 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse401({required this.body});

  final _i5.ApiV1AuthPasswordPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse403 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse403({required this.body});

  final _i6.ApiV1AuthPasswordPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse413 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse413({required this.body});

  final _i7.ApiV1AuthPasswordPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse422 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse422({required this.body});

  final _i8.ApiV1AuthPasswordPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse429 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse429({required this.body});

  final _i9.ApiV1AuthPasswordPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse500 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse500({required this.body});

  final _i10.ApiV1AuthPasswordPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ChangeOwnPasswordResponse503 extends ChangeOwnPasswordResponse {
  const ChangeOwnPasswordResponse503({required this.body});

  final _i11.ApiV1AuthPasswordPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeOwnPasswordResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
