// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_devices_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_devices_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_devices_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_devices_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_devices_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_devices_get503_response.dart'
    as _i8;

sealed class ListPushDevicesResponse {
  const ListPushDevicesResponse();
}

@_i1.immutable
class ListPushDevicesResponse200 extends ListPushDevicesResponse {
  const ListPushDevicesResponse200({required this.body});

  final _i2.ApiV1DevicesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPushDevicesResponse401 extends ListPushDevicesResponse {
  const ListPushDevicesResponse401({required this.body});

  final _i4.ApiV1DevicesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPushDevicesResponse403 extends ListPushDevicesResponse {
  const ListPushDevicesResponse403({required this.body});

  final _i5.ApiV1DevicesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPushDevicesResponse413 extends ListPushDevicesResponse {
  const ListPushDevicesResponse413({required this.body});

  final _i6.ApiV1DevicesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPushDevicesResponse500 extends ListPushDevicesResponse {
  const ListPushDevicesResponse500({required this.body});

  final _i7.ApiV1DevicesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListPushDevicesResponse503 extends ListPushDevicesResponse {
  const ListPushDevicesResponse503({required this.body});

  final _i8.ApiV1DevicesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPushDevicesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
