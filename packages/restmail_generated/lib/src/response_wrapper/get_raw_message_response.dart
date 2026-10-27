// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_raw_get503_response.dart'
    as _i11;

sealed class GetRawMessageResponse {
  const GetRawMessageResponse();
}

@_i1.immutable
class GetRawMessageResponse200 extends GetRawMessageResponse {
  const GetRawMessageResponse200({required this.body});

  final _i2.ApiV1MessagesIdRawGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse401 extends GetRawMessageResponse {
  const GetRawMessageResponse401({required this.body});

  final _i4.ApiV1MessagesIdRawGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse403 extends GetRawMessageResponse {
  const GetRawMessageResponse403({required this.body});

  final _i5.ApiV1MessagesIdRawGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse404 extends GetRawMessageResponse {
  const GetRawMessageResponse404({required this.body});

  final _i6.ApiV1MessagesIdRawGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse413 extends GetRawMessageResponse {
  const GetRawMessageResponse413({required this.body});

  final _i7.ApiV1MessagesIdRawGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse422 extends GetRawMessageResponse {
  const GetRawMessageResponse422({required this.body});

  final _i8.ApiV1MessagesIdRawGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse429 extends GetRawMessageResponse {
  const GetRawMessageResponse429({required this.body});

  final _i9.ApiV1MessagesIdRawGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse500 extends GetRawMessageResponse {
  const GetRawMessageResponse500({required this.body});

  final _i10.ApiV1MessagesIdRawGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetRawMessageResponse503 extends GetRawMessageResponse {
  const GetRawMessageResponse503({required this.body});

  final _i11.ApiV1MessagesIdRawGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetRawMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
