// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_bans_id_delete503_response.dart'
    as _i9;

sealed class DeleteBanResponse {
  const DeleteBanResponse();
}

@_i1.immutable
class DeleteBanResponse204 extends DeleteBanResponse {
  const DeleteBanResponse204({required this.body});

  final _i2.ApiV1AdminBansIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse401 extends DeleteBanResponse {
  const DeleteBanResponse401({required this.body});

  final _i4.ApiV1AdminBansIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse403 extends DeleteBanResponse {
  const DeleteBanResponse403({required this.body});

  final _i5.ApiV1AdminBansIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse413 extends DeleteBanResponse {
  const DeleteBanResponse413({required this.body});

  final _i6.ApiV1AdminBansIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse422 extends DeleteBanResponse {
  const DeleteBanResponse422({required this.body});

  final _i7.ApiV1AdminBansIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse500 extends DeleteBanResponse {
  const DeleteBanResponse500({required this.body});

  final _i8.ApiV1AdminBansIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteBanResponse503 extends DeleteBanResponse {
  const DeleteBanResponse503({required this.body});

  final _i9.ApiV1AdminBansIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteBanResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
