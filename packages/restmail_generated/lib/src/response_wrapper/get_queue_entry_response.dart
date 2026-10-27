// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_queue_id_get503_response.dart'
    as _i10;

sealed class GetQueueEntryResponse {
  const GetQueueEntryResponse();
}

@_i1.immutable
class GetQueueEntryResponse200 extends GetQueueEntryResponse {
  const GetQueueEntryResponse200({required this.body});

  final _i2.ApiV1AdminQueueIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse401 extends GetQueueEntryResponse {
  const GetQueueEntryResponse401({required this.body});

  final _i4.ApiV1AdminQueueIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse403 extends GetQueueEntryResponse {
  const GetQueueEntryResponse403({required this.body});

  final _i5.ApiV1AdminQueueIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse404 extends GetQueueEntryResponse {
  const GetQueueEntryResponse404({required this.body});

  final _i6.ApiV1AdminQueueIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse413 extends GetQueueEntryResponse {
  const GetQueueEntryResponse413({required this.body});

  final _i7.ApiV1AdminQueueIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse422 extends GetQueueEntryResponse {
  const GetQueueEntryResponse422({required this.body});

  final _i8.ApiV1AdminQueueIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse500 extends GetQueueEntryResponse {
  const GetQueueEntryResponse500({required this.body});

  final _i9.ApiV1AdminQueueIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQueueEntryResponse503 extends GetQueueEntryResponse {
  const GetQueueEntryResponse503({required this.body});

  final _i10.ApiV1AdminQueueIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQueueEntryResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
