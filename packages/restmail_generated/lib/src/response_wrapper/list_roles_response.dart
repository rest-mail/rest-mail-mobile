// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_roles_get503_response.dart'
    as _i8;

sealed class ListRolesResponse {
  const ListRolesResponse();
}

@_i1.immutable
class ListRolesResponse200 extends ListRolesResponse {
  const ListRolesResponse200({required this.body});

  final _i2.ApiV1AdminRolesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListRolesResponse401 extends ListRolesResponse {
  const ListRolesResponse401({required this.body});

  final _i4.ApiV1AdminRolesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListRolesResponse403 extends ListRolesResponse {
  const ListRolesResponse403({required this.body});

  final _i5.ApiV1AdminRolesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListRolesResponse413 extends ListRolesResponse {
  const ListRolesResponse413({required this.body});

  final _i6.ApiV1AdminRolesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListRolesResponse500 extends ListRolesResponse {
  const ListRolesResponse500({required this.body});

  final _i7.ApiV1AdminRolesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListRolesResponse503 extends ListRolesResponse {
  const ListRolesResponse503({required this.body});

  final _i8.ApiV1AdminRolesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListRolesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
