// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get429_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_get503_response.dart'
    as _i9;

sealed class ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse();
}

@_i1.immutable
class ListScheduledMessagesResponse200 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse200({required this.body});

  final _i2.ApiV1MessagesScheduledGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse401 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse401({required this.body});

  final _i4.ApiV1MessagesScheduledGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse403 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse403({required this.body});

  final _i5.ApiV1MessagesScheduledGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse413 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse413({required this.body});

  final _i6.ApiV1MessagesScheduledGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse429 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse429({required this.body});

  final _i7.ApiV1MessagesScheduledGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse500 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse500({required this.body});

  final _i8.ApiV1MessagesScheduledGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListScheduledMessagesResponse503 extends ListScheduledMessagesResponse {
  const ListScheduledMessagesResponse503({required this.body});

  final _i9.ApiV1MessagesScheduledGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListScheduledMessagesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
