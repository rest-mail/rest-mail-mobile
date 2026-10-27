// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_capabilities_get503_response.dart'
    as _i8;

sealed class ListCapabilitiesResponse {
  const ListCapabilitiesResponse();
}

@_i1.immutable
class ListCapabilitiesResponse200 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse200({required this.body});

  final _i2.ApiV1AdminCapabilitiesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCapabilitiesResponse401 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse401({required this.body});

  final _i4.ApiV1AdminCapabilitiesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCapabilitiesResponse403 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse403({required this.body});

  final _i5.ApiV1AdminCapabilitiesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCapabilitiesResponse413 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse413({required this.body});

  final _i6.ApiV1AdminCapabilitiesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCapabilitiesResponse500 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse500({required this.body});

  final _i7.ApiV1AdminCapabilitiesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCapabilitiesResponse503 extends ListCapabilitiesResponse {
  const ListCapabilitiesResponse503({required this.body});

  final _i8.ApiV1AdminCapabilitiesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCapabilitiesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
