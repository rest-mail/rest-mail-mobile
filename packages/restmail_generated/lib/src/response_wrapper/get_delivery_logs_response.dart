// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_logs_delivery_get503_response.dart'
    as _i9;

sealed class GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse();
}

@_i1.immutable
class GetDeliveryLogsResponse200 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse200({required this.body});

  final _i2.ApiV1AdminLogsDeliveryGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse401 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse401({required this.body});

  final _i4.ApiV1AdminLogsDeliveryGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse403 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse403({required this.body});

  final _i5.ApiV1AdminLogsDeliveryGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse413 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse413({required this.body});

  final _i6.ApiV1AdminLogsDeliveryGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse422 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse422({required this.body});

  final _i7.ApiV1AdminLogsDeliveryGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse500 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse500({required this.body});

  final _i8.ApiV1AdminLogsDeliveryGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDeliveryLogsResponse503 extends GetDeliveryLogsResponse {
  const GetDeliveryLogsResponse503({required this.body});

  final _i9.ApiV1AdminLogsDeliveryGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDeliveryLogsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
