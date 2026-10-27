// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_aliases_id_patch503_response.dart'
    as _i12;

sealed class UpdateAliasResponse {
  const UpdateAliasResponse();
}

@_i1.immutable
class UpdateAliasResponse200 extends UpdateAliasResponse {
  const UpdateAliasResponse200({required this.body});

  final _i2.ApiV1AdminAliasesIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse400 extends UpdateAliasResponse {
  const UpdateAliasResponse400({required this.body});

  final _i4.ApiV1AdminAliasesIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse401 extends UpdateAliasResponse {
  const UpdateAliasResponse401({required this.body});

  final _i5.ApiV1AdminAliasesIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse403 extends UpdateAliasResponse {
  const UpdateAliasResponse403({required this.body});

  final _i6.ApiV1AdminAliasesIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse404 extends UpdateAliasResponse {
  const UpdateAliasResponse404({required this.body});

  final _i7.ApiV1AdminAliasesIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse413 extends UpdateAliasResponse {
  const UpdateAliasResponse413({required this.body});

  final _i8.ApiV1AdminAliasesIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse422 extends UpdateAliasResponse {
  const UpdateAliasResponse422({required this.body});

  final _i9.ApiV1AdminAliasesIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse429 extends UpdateAliasResponse {
  const UpdateAliasResponse429({required this.body});

  final _i10.ApiV1AdminAliasesIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse500 extends UpdateAliasResponse {
  const UpdateAliasResponse500({required this.body});

  final _i11.ApiV1AdminAliasesIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateAliasResponse503 extends UpdateAliasResponse {
  const UpdateAliasResponse503({required this.body});

  final _i12.ApiV1AdminAliasesIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateAliasResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
