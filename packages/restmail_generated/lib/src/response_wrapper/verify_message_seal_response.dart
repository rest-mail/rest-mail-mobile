// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_seal_get503_response.dart'
    as _i11;

sealed class VerifyMessageSealResponse {
  const VerifyMessageSealResponse();
}

@_i1.immutable
class VerifyMessageSealResponse200 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse200({required this.body});

  final _i2.ApiV1MessagesIdSealGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse401 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse401({required this.body});

  final _i4.ApiV1MessagesIdSealGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse403 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse403({required this.body});

  final _i5.ApiV1MessagesIdSealGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse404 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse404({required this.body});

  final _i6.ApiV1MessagesIdSealGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse413 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse413({required this.body});

  final _i7.ApiV1MessagesIdSealGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse422 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse422({required this.body});

  final _i8.ApiV1MessagesIdSealGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse429 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse429({required this.body});

  final _i9.ApiV1MessagesIdSealGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse500 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse500({required this.body});

  final _i10.ApiV1MessagesIdSealGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyMessageSealResponse503 extends VerifyMessageSealResponse {
  const VerifyMessageSealResponse503({required this.body});

  final _i11.ApiV1MessagesIdSealGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyMessageSealResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
