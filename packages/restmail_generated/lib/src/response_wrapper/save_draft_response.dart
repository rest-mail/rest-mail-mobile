// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_draft_post503_response.dart'
    as _i11;

sealed class SaveDraftResponse {
  const SaveDraftResponse();
}

@_i1.immutable
class SaveDraftResponse201 extends SaveDraftResponse {
  const SaveDraftResponse201({required this.body});

  final _i2.ApiV1MessagesDraftPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse400 extends SaveDraftResponse {
  const SaveDraftResponse400({required this.body});

  final _i4.ApiV1MessagesDraftPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse401 extends SaveDraftResponse {
  const SaveDraftResponse401({required this.body});

  final _i5.ApiV1MessagesDraftPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse403 extends SaveDraftResponse {
  const SaveDraftResponse403({required this.body});

  final _i6.ApiV1MessagesDraftPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse413 extends SaveDraftResponse {
  const SaveDraftResponse413({required this.body});

  final _i7.ApiV1MessagesDraftPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse422 extends SaveDraftResponse {
  const SaveDraftResponse422({required this.body});

  final _i8.ApiV1MessagesDraftPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse429 extends SaveDraftResponse {
  const SaveDraftResponse429({required this.body});

  final _i9.ApiV1MessagesDraftPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse500 extends SaveDraftResponse {
  const SaveDraftResponse500({required this.body});

  final _i10.ApiV1MessagesDraftPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SaveDraftResponse503 extends SaveDraftResponse {
  const SaveDraftResponse503({required this.body});

  final _i11.ApiV1MessagesDraftPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SaveDraftResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
