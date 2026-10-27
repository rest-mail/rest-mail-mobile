// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_get503_response.dart'
    as _i9;

sealed class ListAliasesResponse {
  const ListAliasesResponse();
}

@_i1.immutable
class ListAliasesResponse200 extends ListAliasesResponse {
  const ListAliasesResponse200({required this.body});

  final _i2.ApiV1AdminAliasesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse401 extends ListAliasesResponse {
  const ListAliasesResponse401({required this.body});

  final _i4.ApiV1AdminAliasesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse403 extends ListAliasesResponse {
  const ListAliasesResponse403({required this.body});

  final _i5.ApiV1AdminAliasesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse413 extends ListAliasesResponse {
  const ListAliasesResponse413({required this.body});

  final _i6.ApiV1AdminAliasesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse422 extends ListAliasesResponse {
  const ListAliasesResponse422({required this.body});

  final _i7.ApiV1AdminAliasesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse500 extends ListAliasesResponse {
  const ListAliasesResponse500({required this.body});

  final _i8.ApiV1AdminAliasesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAliasesResponse503 extends ListAliasesResponse {
  const ListAliasesResponse503({required this.body});

  final _i9.ApiV1AdminAliasesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAliasesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
