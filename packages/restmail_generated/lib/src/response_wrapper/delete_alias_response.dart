// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_delete503_response.dart'
    as _i10;

sealed class DeleteAliasResponse {
  const DeleteAliasResponse();
}

@_i1.immutable
class DeleteAliasResponse204 extends DeleteAliasResponse {
  const DeleteAliasResponse204({required this.body});

  final _i2.ApiV1AdminAliasesIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse401 extends DeleteAliasResponse {
  const DeleteAliasResponse401({required this.body});

  final _i4.ApiV1AdminAliasesIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse403 extends DeleteAliasResponse {
  const DeleteAliasResponse403({required this.body});

  final _i5.ApiV1AdminAliasesIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse404 extends DeleteAliasResponse {
  const DeleteAliasResponse404({required this.body});

  final _i6.ApiV1AdminAliasesIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse413 extends DeleteAliasResponse {
  const DeleteAliasResponse413({required this.body});

  final _i7.ApiV1AdminAliasesIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse422 extends DeleteAliasResponse {
  const DeleteAliasResponse422({required this.body});

  final _i8.ApiV1AdminAliasesIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse500 extends DeleteAliasResponse {
  const DeleteAliasResponse500({required this.body});

  final _i9.ApiV1AdminAliasesIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteAliasResponse503 extends DeleteAliasResponse {
  const DeleteAliasResponse503({required this.body});

  final _i10.ApiV1AdminAliasesIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteAliasResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
