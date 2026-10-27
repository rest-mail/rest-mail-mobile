// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_id_attachments_get503_response.dart'
    as _i11;

sealed class ListAttachmentsResponse {
  const ListAttachmentsResponse();
}

@_i1.immutable
class ListAttachmentsResponse200 extends ListAttachmentsResponse {
  const ListAttachmentsResponse200({required this.body});

  final _i2.ApiV1MessagesIdAttachmentsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse401 extends ListAttachmentsResponse {
  const ListAttachmentsResponse401({required this.body});

  final _i4.ApiV1MessagesIdAttachmentsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse403 extends ListAttachmentsResponse {
  const ListAttachmentsResponse403({required this.body});

  final _i5.ApiV1MessagesIdAttachmentsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse404 extends ListAttachmentsResponse {
  const ListAttachmentsResponse404({required this.body});

  final _i6.ApiV1MessagesIdAttachmentsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse413 extends ListAttachmentsResponse {
  const ListAttachmentsResponse413({required this.body});

  final _i7.ApiV1MessagesIdAttachmentsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse422 extends ListAttachmentsResponse {
  const ListAttachmentsResponse422({required this.body});

  final _i8.ApiV1MessagesIdAttachmentsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse429 extends ListAttachmentsResponse {
  const ListAttachmentsResponse429({required this.body});

  final _i9.ApiV1MessagesIdAttachmentsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse500 extends ListAttachmentsResponse {
  const ListAttachmentsResponse500({required this.body});

  final _i10.ApiV1MessagesIdAttachmentsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAttachmentsResponse503 extends ListAttachmentsResponse {
  const ListAttachmentsResponse503({required this.body});

  final _i11.ApiV1MessagesIdAttachmentsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAttachmentsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
