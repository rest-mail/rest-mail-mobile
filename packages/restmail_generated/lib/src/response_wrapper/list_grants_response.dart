// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_grants_get503_response.dart'
    as _i9;

sealed class ListGrantsResponse {
  const ListGrantsResponse();
}

@_i1.immutable
class ListGrantsResponse200 extends ListGrantsResponse {
  const ListGrantsResponse200({required this.body});

  final _i2.ApiV1AdminGrantsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse401 extends ListGrantsResponse {
  const ListGrantsResponse401({required this.body});

  final _i4.ApiV1AdminGrantsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse403 extends ListGrantsResponse {
  const ListGrantsResponse403({required this.body});

  final _i5.ApiV1AdminGrantsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse413 extends ListGrantsResponse {
  const ListGrantsResponse413({required this.body});

  final _i6.ApiV1AdminGrantsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse422 extends ListGrantsResponse {
  const ListGrantsResponse422({required this.body});

  final _i7.ApiV1AdminGrantsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse500 extends ListGrantsResponse {
  const ListGrantsResponse500({required this.body});

  final _i8.ApiV1AdminGrantsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListGrantsResponse503 extends ListGrantsResponse {
  const ListGrantsResponse503({required this.body});

  final _i9.ApiV1AdminGrantsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListGrantsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
