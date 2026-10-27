// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_post503_response.dart'
    as _i12;

sealed class TestPipelineResponse {
  const TestPipelineResponse();
}

@_i1.immutable
class TestPipelineResponse200 extends TestPipelineResponse {
  const TestPipelineResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesTestPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse400 extends TestPipelineResponse {
  const TestPipelineResponse400({required this.body});

  final _i4.ApiV1AdminPipelinesTestPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse401 extends TestPipelineResponse {
  const TestPipelineResponse401({required this.body});

  final _i5.ApiV1AdminPipelinesTestPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse403 extends TestPipelineResponse {
  const TestPipelineResponse403({required this.body});

  final _i6.ApiV1AdminPipelinesTestPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse404 extends TestPipelineResponse {
  const TestPipelineResponse404({required this.body});

  final _i7.ApiV1AdminPipelinesTestPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse413 extends TestPipelineResponse {
  const TestPipelineResponse413({required this.body});

  final _i8.ApiV1AdminPipelinesTestPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse422 extends TestPipelineResponse {
  const TestPipelineResponse422({required this.body});

  final _i9.ApiV1AdminPipelinesTestPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse429 extends TestPipelineResponse {
  const TestPipelineResponse429({required this.body});

  final _i10.ApiV1AdminPipelinesTestPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse500 extends TestPipelineResponse {
  const TestPipelineResponse500({required this.body});

  final _i11.ApiV1AdminPipelinesTestPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestPipelineResponse503 extends TestPipelineResponse {
  const TestPipelineResponse503({required this.body});

  final _i12.ApiV1AdminPipelinesTestPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestPipelineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
