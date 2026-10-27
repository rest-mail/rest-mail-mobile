// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_id_patch503_response.dart'
    as _i12;

sealed class UpdatePipelineResponse {
  const UpdatePipelineResponse();
}

@_i1.immutable
class UpdatePipelineResponse200 extends UpdatePipelineResponse {
  const UpdatePipelineResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse400 extends UpdatePipelineResponse {
  const UpdatePipelineResponse400({required this.body});

  final _i4.ApiV1AdminPipelinesIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse401 extends UpdatePipelineResponse {
  const UpdatePipelineResponse401({required this.body});

  final _i5.ApiV1AdminPipelinesIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse403 extends UpdatePipelineResponse {
  const UpdatePipelineResponse403({required this.body});

  final _i6.ApiV1AdminPipelinesIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse404 extends UpdatePipelineResponse {
  const UpdatePipelineResponse404({required this.body});

  final _i7.ApiV1AdminPipelinesIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse413 extends UpdatePipelineResponse {
  const UpdatePipelineResponse413({required this.body});

  final _i8.ApiV1AdminPipelinesIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse422 extends UpdatePipelineResponse {
  const UpdatePipelineResponse422({required this.body});

  final _i9.ApiV1AdminPipelinesIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse429 extends UpdatePipelineResponse {
  const UpdatePipelineResponse429({required this.body});

  final _i10.ApiV1AdminPipelinesIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse500 extends UpdatePipelineResponse {
  const UpdatePipelineResponse500({required this.body});

  final _i11.ApiV1AdminPipelinesIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdatePipelineResponse503 extends UpdatePipelineResponse {
  const UpdatePipelineResponse503({required this.body});

  final _i12.ApiV1AdminPipelinesIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
