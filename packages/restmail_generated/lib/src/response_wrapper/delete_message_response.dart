// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_delete503_response.dart'
    as _i11;

sealed class DeleteMessageResponse {
  const DeleteMessageResponse();
}

@_i1.immutable
class DeleteMessageResponse204 extends DeleteMessageResponse {
  const DeleteMessageResponse204({required this.body});

  final _i2.ApiV1MessagesIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse401 extends DeleteMessageResponse {
  const DeleteMessageResponse401({required this.body});

  final _i4.ApiV1MessagesIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse403 extends DeleteMessageResponse {
  const DeleteMessageResponse403({required this.body});

  final _i5.ApiV1MessagesIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse404 extends DeleteMessageResponse {
  const DeleteMessageResponse404({required this.body});

  final _i6.ApiV1MessagesIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse413 extends DeleteMessageResponse {
  const DeleteMessageResponse413({required this.body});

  final _i7.ApiV1MessagesIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse422 extends DeleteMessageResponse {
  const DeleteMessageResponse422({required this.body});

  final _i8.ApiV1MessagesIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse429 extends DeleteMessageResponse {
  const DeleteMessageResponse429({required this.body});

  final _i9.ApiV1MessagesIdDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse500 extends DeleteMessageResponse {
  const DeleteMessageResponse500({required this.body});

  final _i10.ApiV1MessagesIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMessageResponse503 extends DeleteMessageResponse {
  const DeleteMessageResponse503({required this.body});

  final _i11.ApiV1MessagesIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
