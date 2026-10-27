// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_grants_mine_get503_response.dart'
    as _i8;

sealed class ListMyGrantsResponse {
  const ListMyGrantsResponse();
}

@_i1.immutable
class ListMyGrantsResponse200 extends ListMyGrantsResponse {
  const ListMyGrantsResponse200({required this.body});

  final _i2.ApiV1AdminGrantsMineGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMyGrantsResponse401 extends ListMyGrantsResponse {
  const ListMyGrantsResponse401({required this.body});

  final _i4.ApiV1AdminGrantsMineGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMyGrantsResponse403 extends ListMyGrantsResponse {
  const ListMyGrantsResponse403({required this.body});

  final _i5.ApiV1AdminGrantsMineGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMyGrantsResponse413 extends ListMyGrantsResponse {
  const ListMyGrantsResponse413({required this.body});

  final _i6.ApiV1AdminGrantsMineGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMyGrantsResponse500 extends ListMyGrantsResponse {
  const ListMyGrantsResponse500({required this.body});

  final _i7.ApiV1AdminGrantsMineGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMyGrantsResponse503 extends ListMyGrantsResponse {
  const ListMyGrantsResponse503({required this.body});

  final _i8.ApiV1AdminGrantsMineGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMyGrantsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
