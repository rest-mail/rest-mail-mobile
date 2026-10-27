// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_scheduled_id_delete503_response.dart'
    as _i11;

sealed class CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse();
}

@_i1.immutable
class CancelScheduledMessageResponse204 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse204({required this.body});

  final _i2.ApiV1MessagesScheduledIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse204 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse401 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse401({required this.body});

  final _i4.ApiV1MessagesScheduledIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse401 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse403 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse403({required this.body});

  final _i5.ApiV1MessagesScheduledIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse403 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse404 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse404({required this.body});

  final _i6.ApiV1MessagesScheduledIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse404 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse413 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse413({required this.body});

  final _i7.ApiV1MessagesScheduledIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse413 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse422 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse422({required this.body});

  final _i8.ApiV1MessagesScheduledIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse422 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse429 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse429({required this.body});

  final _i9.ApiV1MessagesScheduledIdDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse429 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse500 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse500({required this.body});

  final _i10.ApiV1MessagesScheduledIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CancelScheduledMessageResponse503 extends CancelScheduledMessageResponse {
  const CancelScheduledMessageResponse503({required this.body});

  final _i11.ApiV1MessagesScheduledIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CancelScheduledMessageResponse503 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
