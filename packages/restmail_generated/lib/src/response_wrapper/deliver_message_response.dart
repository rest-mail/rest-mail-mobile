// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post400_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post451_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_deliver_post550_response.dart'
    as _i11;

sealed class DeliverMessageResponse {
  const DeliverMessageResponse();
}

@_i1.immutable
class DeliverMessageResponse200 extends DeliverMessageResponse {
  const DeliverMessageResponse200({required this.body});

  final _i2.ApiV1MessagesDeliverPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse201 extends DeliverMessageResponse {
  const DeliverMessageResponse201({required this.body});

  final _i4.ApiV1MessagesDeliverPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse400 extends DeliverMessageResponse {
  const DeliverMessageResponse400({required this.body});

  final _i5.ApiV1MessagesDeliverPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse404 extends DeliverMessageResponse {
  const DeliverMessageResponse404({required this.body});

  final _i6.ApiV1MessagesDeliverPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse413 extends DeliverMessageResponse {
  const DeliverMessageResponse413({required this.body});

  final _i7.ApiV1MessagesDeliverPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse422 extends DeliverMessageResponse {
  const DeliverMessageResponse422({required this.body});

  final _i8.ApiV1MessagesDeliverPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse451 extends DeliverMessageResponse {
  const DeliverMessageResponse451({required this.body});

  final _i9.ApiV1MessagesDeliverPost451Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse451 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse500 extends DeliverMessageResponse {
  const DeliverMessageResponse500({required this.body});

  final _i10.ApiV1MessagesDeliverPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeliverMessageResponse550 extends DeliverMessageResponse {
  const DeliverMessageResponse550({required this.body});

  final _i11.ApiV1MessagesDeliverPost550Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageResponse550 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
