// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_devices_device_id_delete503_response.dart'
    as _i9;

sealed class RemovePushDeviceResponse {
  const RemovePushDeviceResponse();
}

@_i1.immutable
class RemovePushDeviceResponse204 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse204({required this.body});

  final _i2.ApiV1DevicesDeviceIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse401 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse401({required this.body});

  final _i4.ApiV1DevicesDeviceIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse403 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse403({required this.body});

  final _i5.ApiV1DevicesDeviceIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse404 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse404({required this.body});

  final _i6.ApiV1DevicesDeviceIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse413 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse413({required this.body});

  final _i7.ApiV1DevicesDeviceIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse500 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse500({required this.body});

  final _i8.ApiV1DevicesDeviceIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemovePushDeviceResponse503 extends RemovePushDeviceResponse {
  const RemovePushDeviceResponse503({required this.body});

  final _i9.ApiV1DevicesDeviceIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemovePushDeviceResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
