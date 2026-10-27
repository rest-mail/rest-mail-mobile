// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_analytics_get503_response.dart'
    as _i8;

sealed class GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse();
}

@_i1.immutable
class GetPipelineAnalyticsResponse200 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesAnalyticsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetPipelineAnalyticsResponse401 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse401({required this.body});

  final _i4.ApiV1AdminPipelinesAnalyticsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetPipelineAnalyticsResponse403 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse403({required this.body});

  final _i5.ApiV1AdminPipelinesAnalyticsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetPipelineAnalyticsResponse413 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse413({required this.body});

  final _i6.ApiV1AdminPipelinesAnalyticsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetPipelineAnalyticsResponse500 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse500({required this.body});

  final _i7.ApiV1AdminPipelinesAnalyticsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetPipelineAnalyticsResponse503 extends GetPipelineAnalyticsResponse {
  const GetPipelineAnalyticsResponse503({required this.body});

  final _i8.ApiV1AdminPipelinesAnalyticsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPipelineAnalyticsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
