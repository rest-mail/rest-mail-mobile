// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_get503_response.dart'
    as _i10;

sealed class GetDkimRotationResponse {
  const GetDkimRotationResponse();
}

@_i1.immutable
class GetDkimRotationResponse200 extends GetDkimRotationResponse {
  const GetDkimRotationResponse200({required this.body});

  final _i2.ApiV1AdminDkimIdRotationGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse401 extends GetDkimRotationResponse {
  const GetDkimRotationResponse401({required this.body});

  final _i4.ApiV1AdminDkimIdRotationGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse403 extends GetDkimRotationResponse {
  const GetDkimRotationResponse403({required this.body});

  final _i5.ApiV1AdminDkimIdRotationGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse404 extends GetDkimRotationResponse {
  const GetDkimRotationResponse404({required this.body});

  final _i6.ApiV1AdminDkimIdRotationGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse413 extends GetDkimRotationResponse {
  const GetDkimRotationResponse413({required this.body});

  final _i7.ApiV1AdminDkimIdRotationGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse422 extends GetDkimRotationResponse {
  const GetDkimRotationResponse422({required this.body});

  final _i8.ApiV1AdminDkimIdRotationGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse500 extends GetDkimRotationResponse {
  const GetDkimRotationResponse500({required this.body});

  final _i9.ApiV1AdminDkimIdRotationGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDkimRotationResponse503 extends GetDkimRotationResponse {
  const GetDkimRotationResponse503({required this.body});

  final _i10.ApiV1AdminDkimIdRotationGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDkimRotationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
