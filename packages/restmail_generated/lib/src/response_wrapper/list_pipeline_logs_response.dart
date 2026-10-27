// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_logs_get503_response.dart'
    as _i9;

sealed class ListPipelineLogsResponse {
  const ListPipelineLogsResponse();
}

@_i1.immutable
class ListPipelineLogsResponse200 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesLogsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse401 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse401({required this.body});

  final _i4.ApiV1AdminPipelinesLogsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse403 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse403({required this.body});

  final _i5.ApiV1AdminPipelinesLogsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse413 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse413({required this.body});

  final _i6.ApiV1AdminPipelinesLogsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse422 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse422({required this.body});

  final _i7.ApiV1AdminPipelinesLogsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse500 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse500({required this.body});

  final _i8.ApiV1AdminPipelinesLogsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelineLogsResponse503 extends ListPipelineLogsResponse {
  const ListPipelineLogsResponse503({required this.body});

  final _i9.ApiV1AdminPipelinesLogsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelineLogsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
