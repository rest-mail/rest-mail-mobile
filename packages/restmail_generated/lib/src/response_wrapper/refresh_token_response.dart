// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_refresh_post500_response.dart'
    as _i9;

sealed class RefreshTokenResponse {
  const RefreshTokenResponse();
}

@_i1.immutable
class RefreshTokenResponse200 extends RefreshTokenResponse {
  const RefreshTokenResponse200({required this.body});

  final _i2.ApiV1AuthRefreshPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse400 extends RefreshTokenResponse {
  const RefreshTokenResponse400({required this.body});

  final _i4.ApiV1AuthRefreshPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse401 extends RefreshTokenResponse {
  const RefreshTokenResponse401({required this.body});

  final _i5.ApiV1AuthRefreshPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse413 extends RefreshTokenResponse {
  const RefreshTokenResponse413({required this.body});

  final _i6.ApiV1AuthRefreshPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse422 extends RefreshTokenResponse {
  const RefreshTokenResponse422({required this.body});

  final _i7.ApiV1AuthRefreshPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse429 extends RefreshTokenResponse {
  const RefreshTokenResponse429({required this.body});

  final _i8.ApiV1AuthRefreshPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RefreshTokenResponse500 extends RefreshTokenResponse {
  const RefreshTokenResponse500({required this.body});

  final _i9.ApiV1AuthRefreshPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RefreshTokenResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
