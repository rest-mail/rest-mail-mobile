// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_send_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_send_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_send_post202_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_send_post400_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_send_post401_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_send_post403_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_send_post413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_send_post422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_send_post429_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_messages_send_post500_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_messages_send_post503_response.dart'
    as _i13;

sealed class SendMessageResponse {
  const SendMessageResponse();
}

@_i1.immutable
class SendMessageResponse200 extends SendMessageResponse {
  const SendMessageResponse200({required this.body});

  final _i2.ApiV1MessagesSendPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse201 extends SendMessageResponse {
  const SendMessageResponse201({required this.body});

  final _i4.ApiV1MessagesSendPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse202 extends SendMessageResponse {
  const SendMessageResponse202({required this.body});

  final _i5.ApiV1MessagesSendPost202Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse202 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse400 extends SendMessageResponse {
  const SendMessageResponse400({required this.body});

  final _i6.ApiV1MessagesSendPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse401 extends SendMessageResponse {
  const SendMessageResponse401({required this.body});

  final _i7.ApiV1MessagesSendPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse403 extends SendMessageResponse {
  const SendMessageResponse403({required this.body});

  final _i8.ApiV1MessagesSendPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse413 extends SendMessageResponse {
  const SendMessageResponse413({required this.body});

  final _i9.ApiV1MessagesSendPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse422 extends SendMessageResponse {
  const SendMessageResponse422({required this.body});

  final _i10.ApiV1MessagesSendPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse429 extends SendMessageResponse {
  const SendMessageResponse429({required this.body});

  final _i11.ApiV1MessagesSendPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse500 extends SendMessageResponse {
  const SendMessageResponse500({required this.body});

  final _i12.ApiV1MessagesSendPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendMessageResponse503 extends SendMessageResponse {
  const SendMessageResponse503({required this.body});

  final _i13.ApiV1MessagesSendPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
