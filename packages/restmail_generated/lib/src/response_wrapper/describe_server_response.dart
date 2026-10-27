// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_server_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_server_get429_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_server_get500_response.dart'
    as _i5;

sealed class DescribeServerResponse {
  const DescribeServerResponse();
}

@_i1.immutable
class DescribeServerResponse200 extends DescribeServerResponse {
  const DescribeServerResponse200({required this.body});

  final _i2.ApiV1ServerGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DescribeServerResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DescribeServerResponse429 extends DescribeServerResponse {
  const DescribeServerResponse429({required this.body});

  final _i4.ApiV1ServerGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DescribeServerResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DescribeServerResponse500 extends DescribeServerResponse {
  const DescribeServerResponse500({required this.body});

  final _i5.ApiV1ServerGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DescribeServerResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
