// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get429_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_get503_response.dart'
    as _i9;

sealed class GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse();
}

@_i1.immutable
class GetServerCapabilitiesResponse200 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse200({required this.body});

  final _i2.ApiV1AdminServerCapabilitiesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse401 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse401({required this.body});

  final _i4.ApiV1AdminServerCapabilitiesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse403 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse403({required this.body});

  final _i5.ApiV1AdminServerCapabilitiesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse413 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse413({required this.body});

  final _i6.ApiV1AdminServerCapabilitiesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse429 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse429({required this.body});

  final _i7.ApiV1AdminServerCapabilitiesGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse500 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse500({required this.body});

  final _i8.ApiV1AdminServerCapabilitiesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetServerCapabilitiesResponse503 extends GetServerCapabilitiesResponse {
  const GetServerCapabilitiesResponse503({required this.body});

  final _i9.ApiV1AdminServerCapabilitiesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerCapabilitiesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
