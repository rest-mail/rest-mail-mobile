// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_server_limits_put503_response.dart'
    as _i11;

sealed class UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse();
}

@_i1.immutable
class UpdateServerLimitsResponse200 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse200({required this.body});

  final _i2.ApiV1AdminServerLimitsPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse400 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse400({required this.body});

  final _i4.ApiV1AdminServerLimitsPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse401 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse401({required this.body});

  final _i5.ApiV1AdminServerLimitsPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse403 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse403({required this.body});

  final _i6.ApiV1AdminServerLimitsPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse413 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse413({required this.body});

  final _i7.ApiV1AdminServerLimitsPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse422 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse422({required this.body});

  final _i8.ApiV1AdminServerLimitsPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse429 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse429({required this.body});

  final _i9.ApiV1AdminServerLimitsPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse500 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse500({required this.body});

  final _i10.ApiV1AdminServerLimitsPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerLimitsResponse503 extends UpdateServerLimitsResponse {
  const UpdateServerLimitsResponse503({required this.body});

  final _i11.ApiV1AdminServerLimitsPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerLimitsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
