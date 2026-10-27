// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_get503_response.dart'
    as _i10;

sealed class GetAliasResponse {
  const GetAliasResponse();
}

@_i1.immutable
class GetAliasResponse200 extends GetAliasResponse {
  const GetAliasResponse200({required this.body});

  final _i2.ApiV1AdminAliasesIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse401 extends GetAliasResponse {
  const GetAliasResponse401({required this.body});

  final _i4.ApiV1AdminAliasesIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse403 extends GetAliasResponse {
  const GetAliasResponse403({required this.body});

  final _i5.ApiV1AdminAliasesIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse404 extends GetAliasResponse {
  const GetAliasResponse404({required this.body});

  final _i6.ApiV1AdminAliasesIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse413 extends GetAliasResponse {
  const GetAliasResponse413({required this.body});

  final _i7.ApiV1AdminAliasesIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse422 extends GetAliasResponse {
  const GetAliasResponse422({required this.body});

  final _i8.ApiV1AdminAliasesIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse500 extends GetAliasResponse {
  const GetAliasResponse500({required this.body});

  final _i9.ApiV1AdminAliasesIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAliasResponse503 extends GetAliasResponse {
  const GetAliasResponse503({required this.body});

  final _i10.ApiV1AdminAliasesIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAliasResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
