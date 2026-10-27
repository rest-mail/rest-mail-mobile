// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_test_filter_post503_response.dart'
    as _i11;

sealed class TestFilterResponse {
  const TestFilterResponse();
}

@_i1.immutable
class TestFilterResponse200 extends TestFilterResponse {
  const TestFilterResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesTestFilterPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse400 extends TestFilterResponse {
  const TestFilterResponse400({required this.body});

  final _i4.ApiV1AdminPipelinesTestFilterPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse401 extends TestFilterResponse {
  const TestFilterResponse401({required this.body});

  final _i5.ApiV1AdminPipelinesTestFilterPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse403 extends TestFilterResponse {
  const TestFilterResponse403({required this.body});

  final _i6.ApiV1AdminPipelinesTestFilterPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse413 extends TestFilterResponse {
  const TestFilterResponse413({required this.body});

  final _i7.ApiV1AdminPipelinesTestFilterPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse422 extends TestFilterResponse {
  const TestFilterResponse422({required this.body});

  final _i8.ApiV1AdminPipelinesTestFilterPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse429 extends TestFilterResponse {
  const TestFilterResponse429({required this.body});

  final _i9.ApiV1AdminPipelinesTestFilterPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse500 extends TestFilterResponse {
  const TestFilterResponse500({required this.body});

  final _i10.ApiV1AdminPipelinesTestFilterPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class TestFilterResponse503 extends TestFilterResponse {
  const TestFilterResponse503({required this.body});

  final _i11.ApiV1AdminPipelinesTestFilterPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TestFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
