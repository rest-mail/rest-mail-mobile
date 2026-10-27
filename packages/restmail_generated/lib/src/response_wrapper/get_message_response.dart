// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_get503_response.dart'
    as _i11;

sealed class GetMessageResponse {
  const GetMessageResponse();
}

@_i1.immutable
class GetMessageResponse200 extends GetMessageResponse {
  const GetMessageResponse200({required this.body});

  final _i2.ApiV1MessagesIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse401 extends GetMessageResponse {
  const GetMessageResponse401({required this.body});

  final _i4.ApiV1MessagesIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse403 extends GetMessageResponse {
  const GetMessageResponse403({required this.body});

  final _i5.ApiV1MessagesIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse404 extends GetMessageResponse {
  const GetMessageResponse404({required this.body});

  final _i6.ApiV1MessagesIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse413 extends GetMessageResponse {
  const GetMessageResponse413({required this.body});

  final _i7.ApiV1MessagesIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse422 extends GetMessageResponse {
  const GetMessageResponse422({required this.body});

  final _i8.ApiV1MessagesIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse429 extends GetMessageResponse {
  const GetMessageResponse429({required this.body});

  final _i9.ApiV1MessagesIdGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse500 extends GetMessageResponse {
  const GetMessageResponse500({required this.body});

  final _i10.ApiV1MessagesIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageResponse503 extends GetMessageResponse {
  const GetMessageResponse503({required this.body});

  final _i11.ApiV1MessagesIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
