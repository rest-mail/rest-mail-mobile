// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_messages_id_patch503_response.dart'
    as _i12;

sealed class UpdateMessageResponse {
  const UpdateMessageResponse();
}

@_i1.immutable
class UpdateMessageResponse200 extends UpdateMessageResponse {
  const UpdateMessageResponse200({required this.body});

  final _i2.ApiV1MessagesIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse400 extends UpdateMessageResponse {
  const UpdateMessageResponse400({required this.body});

  final _i4.ApiV1MessagesIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse401 extends UpdateMessageResponse {
  const UpdateMessageResponse401({required this.body});

  final _i5.ApiV1MessagesIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse403 extends UpdateMessageResponse {
  const UpdateMessageResponse403({required this.body});

  final _i6.ApiV1MessagesIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse404 extends UpdateMessageResponse {
  const UpdateMessageResponse404({required this.body});

  final _i7.ApiV1MessagesIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse413 extends UpdateMessageResponse {
  const UpdateMessageResponse413({required this.body});

  final _i8.ApiV1MessagesIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse422 extends UpdateMessageResponse {
  const UpdateMessageResponse422({required this.body});

  final _i9.ApiV1MessagesIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse429 extends UpdateMessageResponse {
  const UpdateMessageResponse429({required this.body});

  final _i10.ApiV1MessagesIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse500 extends UpdateMessageResponse {
  const UpdateMessageResponse500({required this.body});

  final _i11.ApiV1MessagesIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMessageResponse503 extends UpdateMessageResponse {
  const UpdateMessageResponse503({required this.body});

  final _i12.ApiV1MessagesIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
