// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_messages_id_trace_get503_response.dart'
    as _i10;

sealed class GetMessageTraceResponse {
  const GetMessageTraceResponse();
}

@_i1.immutable
class GetMessageTraceResponse200 extends GetMessageTraceResponse {
  const GetMessageTraceResponse200({required this.body});

  final _i2.ApiV1AdminMessagesIdTraceGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse401 extends GetMessageTraceResponse {
  const GetMessageTraceResponse401({required this.body});

  final _i4.ApiV1AdminMessagesIdTraceGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse403 extends GetMessageTraceResponse {
  const GetMessageTraceResponse403({required this.body});

  final _i5.ApiV1AdminMessagesIdTraceGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse404 extends GetMessageTraceResponse {
  const GetMessageTraceResponse404({required this.body});

  final _i6.ApiV1AdminMessagesIdTraceGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse413 extends GetMessageTraceResponse {
  const GetMessageTraceResponse413({required this.body});

  final _i7.ApiV1AdminMessagesIdTraceGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse422 extends GetMessageTraceResponse {
  const GetMessageTraceResponse422({required this.body});

  final _i8.ApiV1AdminMessagesIdTraceGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse500 extends GetMessageTraceResponse {
  const GetMessageTraceResponse500({required this.body});

  final _i9.ApiV1AdminMessagesIdTraceGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMessageTraceResponse503 extends GetMessageTraceResponse {
  const GetMessageTraceResponse503({required this.body});

  final _i10.ApiV1AdminMessagesIdTraceGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMessageTraceResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
