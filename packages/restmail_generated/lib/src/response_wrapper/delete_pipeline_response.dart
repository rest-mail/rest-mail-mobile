// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_delete503_response.dart'
    as _i10;

sealed class DeletePipelineResponse {
  const DeletePipelineResponse();
}

@_i1.immutable
class DeletePipelineResponse200 extends DeletePipelineResponse {
  const DeletePipelineResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesIdDelete200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse401 extends DeletePipelineResponse {
  const DeletePipelineResponse401({required this.body});

  final _i4.ApiV1AdminPipelinesIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse403 extends DeletePipelineResponse {
  const DeletePipelineResponse403({required this.body});

  final _i5.ApiV1AdminPipelinesIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse404 extends DeletePipelineResponse {
  const DeletePipelineResponse404({required this.body});

  final _i6.ApiV1AdminPipelinesIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse413 extends DeletePipelineResponse {
  const DeletePipelineResponse413({required this.body});

  final _i7.ApiV1AdminPipelinesIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse422 extends DeletePipelineResponse {
  const DeletePipelineResponse422({required this.body});

  final _i8.ApiV1AdminPipelinesIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse500 extends DeletePipelineResponse {
  const DeletePipelineResponse500({required this.body});

  final _i9.ApiV1AdminPipelinesIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeletePipelineResponse503 extends DeletePipelineResponse {
  const DeletePipelineResponse503({required this.body});

  final _i10.ApiV1AdminPipelinesIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeletePipelineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
