// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get429_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_get503_response.dart'
    as _i9;

sealed class GetServerLimitsResponse {
  const GetServerLimitsResponse();
}

@_i1.immutable
class GetServerLimitsResponse200 extends GetServerLimitsResponse {
  const GetServerLimitsResponse200({required this.body});

  final _i2.ApiV1AdminServerLimitsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse401 extends GetServerLimitsResponse {
  const GetServerLimitsResponse401({required this.body});

  final _i4.ApiV1AdminServerLimitsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse403 extends GetServerLimitsResponse {
  const GetServerLimitsResponse403({required this.body});

  final _i5.ApiV1AdminServerLimitsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse413 extends GetServerLimitsResponse {
  const GetServerLimitsResponse413({required this.body});

  final _i6.ApiV1AdminServerLimitsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse429 extends GetServerLimitsResponse {
  const GetServerLimitsResponse429({required this.body});

  final _i7.ApiV1AdminServerLimitsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse500 extends GetServerLimitsResponse {
  const GetServerLimitsResponse500({required this.body});

  final _i8.ApiV1AdminServerLimitsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerLimitsResponse503 extends GetServerLimitsResponse {
  const GetServerLimitsResponse503({required this.body});

  final _i9.ApiV1AdminServerLimitsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerLimitsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
