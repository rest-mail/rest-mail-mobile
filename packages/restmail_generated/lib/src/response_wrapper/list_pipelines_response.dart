// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_pipelines_get503_response.dart'
    as _i9;

sealed class ListPipelinesResponse {
  const ListPipelinesResponse();
}

@_i1.immutable
class ListPipelinesResponse200 extends ListPipelinesResponse {
  const ListPipelinesResponse200({required this.body});

  final _i2.ApiV1AdminPipelinesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse401 extends ListPipelinesResponse {
  const ListPipelinesResponse401({required this.body});

  final _i4.ApiV1AdminPipelinesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse403 extends ListPipelinesResponse {
  const ListPipelinesResponse403({required this.body});

  final _i5.ApiV1AdminPipelinesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse413 extends ListPipelinesResponse {
  const ListPipelinesResponse413({required this.body});

  final _i6.ApiV1AdminPipelinesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse422 extends ListPipelinesResponse {
  const ListPipelinesResponse422({required this.body});

  final _i7.ApiV1AdminPipelinesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse500 extends ListPipelinesResponse {
  const ListPipelinesResponse500({required this.body});

  final _i8.ApiV1AdminPipelinesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPipelinesResponse503 extends ListPipelinesResponse {
  const ListPipelinesResponse503({required this.body});

  final _i9.ApiV1AdminPipelinesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPipelinesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
