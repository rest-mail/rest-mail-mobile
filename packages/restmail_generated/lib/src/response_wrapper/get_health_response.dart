// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_health_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_health_get500_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_health_get503_response.dart'
    as _i5;

sealed class GetHealthResponse {
  const GetHealthResponse();
}

@_i1.immutable
class GetHealthResponse200 extends GetHealthResponse {
  const GetHealthResponse200({required this.body});

  final _i2.ApiHealthGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetHealthResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetHealthResponse500 extends GetHealthResponse {
  const GetHealthResponse500({required this.body});

  final _i4.ApiHealthGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetHealthResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetHealthResponse503 extends GetHealthResponse {
  const GetHealthResponse503({required this.body});

  final _i5.ApiHealthGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetHealthResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
