// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_messages_draft_id_put503_response.dart'
    as _i12;

sealed class UpdateDraftResponse {
  const UpdateDraftResponse();
}

@_i1.immutable
class UpdateDraftResponse200 extends UpdateDraftResponse {
  const UpdateDraftResponse200({required this.body});

  final _i2.ApiV1MessagesDraftIdPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse400 extends UpdateDraftResponse {
  const UpdateDraftResponse400({required this.body});

  final _i4.ApiV1MessagesDraftIdPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse401 extends UpdateDraftResponse {
  const UpdateDraftResponse401({required this.body});

  final _i5.ApiV1MessagesDraftIdPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse403 extends UpdateDraftResponse {
  const UpdateDraftResponse403({required this.body});

  final _i6.ApiV1MessagesDraftIdPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse404 extends UpdateDraftResponse {
  const UpdateDraftResponse404({required this.body});

  final _i7.ApiV1MessagesDraftIdPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse413 extends UpdateDraftResponse {
  const UpdateDraftResponse413({required this.body});

  final _i8.ApiV1MessagesDraftIdPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse422 extends UpdateDraftResponse {
  const UpdateDraftResponse422({required this.body});

  final _i9.ApiV1MessagesDraftIdPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse429 extends UpdateDraftResponse {
  const UpdateDraftResponse429({required this.body});

  final _i10.ApiV1MessagesDraftIdPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse500 extends UpdateDraftResponse {
  const UpdateDraftResponse500({required this.body});

  final _i11.ApiV1MessagesDraftIdPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDraftResponse503 extends UpdateDraftResponse {
  const UpdateDraftResponse503({required this.body});

  final _i12.ApiV1MessagesDraftIdPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDraftResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
