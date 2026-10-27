// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post400_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post401_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post403_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post404_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post429_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post500_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_send_post503_response.dart'
    as _i13;

sealed class SendDraftResponse {
  const SendDraftResponse();
}

@_i1.immutable
class SendDraftResponse200 extends SendDraftResponse {
  const SendDraftResponse200({required this.body});

  final _i2.ApiV1MessagesDraftIdSendPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse201 extends SendDraftResponse {
  const SendDraftResponse201({required this.body});

  final _i4.ApiV1MessagesDraftIdSendPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse400 extends SendDraftResponse {
  const SendDraftResponse400({required this.body});

  final _i5.ApiV1MessagesDraftIdSendPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse401 extends SendDraftResponse {
  const SendDraftResponse401({required this.body});

  final _i6.ApiV1MessagesDraftIdSendPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse403 extends SendDraftResponse {
  const SendDraftResponse403({required this.body});

  final _i7.ApiV1MessagesDraftIdSendPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse404 extends SendDraftResponse {
  const SendDraftResponse404({required this.body});

  final _i8.ApiV1MessagesDraftIdSendPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse413 extends SendDraftResponse {
  const SendDraftResponse413({required this.body});

  final _i9.ApiV1MessagesDraftIdSendPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse422 extends SendDraftResponse {
  const SendDraftResponse422({required this.body});

  final _i10.ApiV1MessagesDraftIdSendPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse429 extends SendDraftResponse {
  const SendDraftResponse429({required this.body});

  final _i11.ApiV1MessagesDraftIdSendPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse500 extends SendDraftResponse {
  const SendDraftResponse500({required this.body});

  final _i12.ApiV1MessagesDraftIdSendPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SendDraftResponse503 extends SendDraftResponse {
  const SendDraftResponse503({required this.body});

  final _i13.ApiV1MessagesDraftIdSendPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendDraftResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
