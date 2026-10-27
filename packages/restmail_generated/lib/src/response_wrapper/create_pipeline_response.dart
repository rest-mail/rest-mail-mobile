// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_post503_response.dart'
    as _i11;

sealed class CreatePipelineResponse {
  const CreatePipelineResponse();
}

@_i1.immutable
class CreatePipelineResponse201 extends CreatePipelineResponse {
  const CreatePipelineResponse201({required this.body});

  final _i2.ApiV1AdminPipelinesPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse400 extends CreatePipelineResponse {
  const CreatePipelineResponse400({required this.body});

  final _i4.ApiV1AdminPipelinesPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse401 extends CreatePipelineResponse {
  const CreatePipelineResponse401({required this.body});

  final _i5.ApiV1AdminPipelinesPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse403 extends CreatePipelineResponse {
  const CreatePipelineResponse403({required this.body});

  final _i6.ApiV1AdminPipelinesPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse413 extends CreatePipelineResponse {
  const CreatePipelineResponse413({required this.body});

  final _i7.ApiV1AdminPipelinesPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse422 extends CreatePipelineResponse {
  const CreatePipelineResponse422({required this.body});

  final _i8.ApiV1AdminPipelinesPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse429 extends CreatePipelineResponse {
  const CreatePipelineResponse429({required this.body});

  final _i9.ApiV1AdminPipelinesPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse500 extends CreatePipelineResponse {
  const CreatePipelineResponse500({required this.body});

  final _i10.ApiV1AdminPipelinesPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreatePipelineResponse503 extends CreatePipelineResponse {
  const CreatePipelineResponse503({required this.body});

  final _i11.ApiV1AdminPipelinesPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
