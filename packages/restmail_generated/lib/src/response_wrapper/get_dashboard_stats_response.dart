// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_stats_get503_response.dart'
    as _i8;

sealed class GetDashboardStatsResponse {
  const GetDashboardStatsResponse();
}

@_i1.immutable
class GetDashboardStatsResponse200 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse200({required this.body});

  final _i2.ApiV1AdminStatsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDashboardStatsResponse401 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse401({required this.body});

  final _i4.ApiV1AdminStatsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDashboardStatsResponse403 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse403({required this.body});

  final _i5.ApiV1AdminStatsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDashboardStatsResponse413 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse413({required this.body});

  final _i6.ApiV1AdminStatsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDashboardStatsResponse500 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse500({required this.body});

  final _i7.ApiV1AdminStatsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDashboardStatsResponse503 extends GetDashboardStatsResponse {
  const GetDashboardStatsResponse503({required this.body});

  final _i8.ApiV1AdminStatsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDashboardStatsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
