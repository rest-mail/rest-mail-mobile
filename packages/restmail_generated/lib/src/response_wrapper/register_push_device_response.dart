// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_devices_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_devices_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_devices_post400_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_devices_post401_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_devices_post403_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_devices_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_devices_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_devices_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_devices_post503_response.dart'
    as _i11;

sealed class RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse();
}

@_i1.immutable
class RegisterPushDeviceResponse200 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse200({required this.body});

  final _i2.ApiV1DevicesPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse201 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse201({required this.body});

  final _i4.ApiV1DevicesPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse400 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse400({required this.body});

  final _i5.ApiV1DevicesPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse401 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse401({required this.body});

  final _i6.ApiV1DevicesPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse403 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse403({required this.body});

  final _i7.ApiV1DevicesPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse413 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse413({required this.body});

  final _i8.ApiV1DevicesPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse422 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse422({required this.body});

  final _i9.ApiV1DevicesPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse500 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse500({required this.body});

  final _i10.ApiV1DevicesPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RegisterPushDeviceResponse503 extends RegisterPushDeviceResponse {
  const RegisterPushDeviceResponse503({required this.body});

  final _i11.ApiV1DevicesPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterPushDeviceResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
