// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_docs_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_docs_get500_response.dart'
    as _i4;

sealed class SwaggerUiResponse {
  const SwaggerUiResponse();
}

@_i1.immutable
class SwaggerUiResponse200 extends SwaggerUiResponse {
  const SwaggerUiResponse200({required this.body});

  final _i2.ApiDocsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SwaggerUiResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SwaggerUiResponse500 extends SwaggerUiResponse {
  const SwaggerUiResponse500({required this.body});

  final _i4.ApiDocsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SwaggerUiResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
