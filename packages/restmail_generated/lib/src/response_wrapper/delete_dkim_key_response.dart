// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_delete503_response.dart'
    as _i10;

sealed class DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse();
}

@_i1.immutable
class DeleteDkimKeyResponse204 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse204({required this.body});

  final _i2.ApiV1AdminDkimIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse401 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse401({required this.body});

  final _i4.ApiV1AdminDkimIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse403 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse403({required this.body});

  final _i5.ApiV1AdminDkimIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse404 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse404({required this.body});

  final _i6.ApiV1AdminDkimIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse413 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse413({required this.body});

  final _i7.ApiV1AdminDkimIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse422 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse422({required this.body});

  final _i8.ApiV1AdminDkimIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse500 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse500({required this.body});

  final _i9.ApiV1AdminDkimIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDkimKeyResponse503 extends DeleteDkimKeyResponse {
  const DeleteDkimKeyResponse503({required this.body});

  final _i10.ApiV1AdminDkimIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDkimKeyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
