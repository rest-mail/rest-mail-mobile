// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/restmail_messages_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/restmail_messages_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/restmail_messages_post403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/restmail_messages_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/restmail_messages_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/restmail_messages_post500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/restmail_messages_post503_response.dart'
    as _i9;

sealed class RestmailDeliverResponse {
  const RestmailDeliverResponse();
}

@_i1.immutable
class RestmailDeliverResponse201 extends RestmailDeliverResponse {
  const RestmailDeliverResponse201({required this.body});

  final _i2.RestmailMessagesPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse400 extends RestmailDeliverResponse {
  const RestmailDeliverResponse400({required this.body});

  final _i4.RestmailMessagesPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse403 extends RestmailDeliverResponse {
  const RestmailDeliverResponse403({required this.body});

  final _i5.RestmailMessagesPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse413 extends RestmailDeliverResponse {
  const RestmailDeliverResponse413({required this.body});

  final _i6.RestmailMessagesPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse422 extends RestmailDeliverResponse {
  const RestmailDeliverResponse422({required this.body});

  final _i7.RestmailMessagesPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse500 extends RestmailDeliverResponse {
  const RestmailDeliverResponse500({required this.body});

  final _i8.RestmailMessagesPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDeliverResponse503 extends RestmailDeliverResponse {
  const RestmailDeliverResponse503({required this.body});

  final _i9.RestmailMessagesPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDeliverResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
