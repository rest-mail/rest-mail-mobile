// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_stats_get503_response.dart'
    as _i8;

sealed class GetQueueStatsResponse {
  const GetQueueStatsResponse();
}

@_i1.immutable
class GetQueueStatsResponse200 extends GetQueueStatsResponse {
  const GetQueueStatsResponse200({required this.body});

  final _i2.ApiV1AdminQueueStatsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueStatsResponse401 extends GetQueueStatsResponse {
  const GetQueueStatsResponse401({required this.body});

  final _i4.ApiV1AdminQueueStatsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueStatsResponse403 extends GetQueueStatsResponse {
  const GetQueueStatsResponse403({required this.body});

  final _i5.ApiV1AdminQueueStatsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueStatsResponse413 extends GetQueueStatsResponse {
  const GetQueueStatsResponse413({required this.body});

  final _i6.ApiV1AdminQueueStatsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueStatsResponse500 extends GetQueueStatsResponse {
  const GetQueueStatsResponse500({required this.body});

  final _i7.ApiV1AdminQueueStatsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueStatsResponse503 extends GetQueueStatsResponse {
  const GetQueueStatsResponse503({required this.body});

  final _i8.ApiV1AdminQueueStatsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueStatsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
