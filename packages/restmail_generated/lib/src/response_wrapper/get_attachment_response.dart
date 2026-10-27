// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_attachments_id_get503_response.dart'
    as _i11;

sealed class GetAttachmentResponse {
  const GetAttachmentResponse();
}

@_i1.immutable
class GetAttachmentResponse200 extends GetAttachmentResponse {
  const GetAttachmentResponse200({required this.body});

  final _i2.ApiV1AttachmentsIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse401 extends GetAttachmentResponse {
  const GetAttachmentResponse401({required this.body});

  final _i4.ApiV1AttachmentsIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse403 extends GetAttachmentResponse {
  const GetAttachmentResponse403({required this.body});

  final _i5.ApiV1AttachmentsIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse404 extends GetAttachmentResponse {
  const GetAttachmentResponse404({required this.body});

  final _i6.ApiV1AttachmentsIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse413 extends GetAttachmentResponse {
  const GetAttachmentResponse413({required this.body});

  final _i7.ApiV1AttachmentsIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse422 extends GetAttachmentResponse {
  const GetAttachmentResponse422({required this.body});

  final _i8.ApiV1AttachmentsIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse429 extends GetAttachmentResponse {
  const GetAttachmentResponse429({required this.body});

  final _i9.ApiV1AttachmentsIdGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse500 extends GetAttachmentResponse {
  const GetAttachmentResponse500({required this.body});

  final _i10.ApiV1AttachmentsIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAttachmentResponse503 extends GetAttachmentResponse {
  const GetAttachmentResponse503({required this.body});

  final _i11.ApiV1AttachmentsIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAttachmentResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
