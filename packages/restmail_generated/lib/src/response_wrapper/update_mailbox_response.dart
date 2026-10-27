// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_patch503_response.dart'
    as _i11;

sealed class UpdateMailboxResponse {
  const UpdateMailboxResponse();
}

@_i1.immutable
class UpdateMailboxResponse200 extends UpdateMailboxResponse {
  const UpdateMailboxResponse200({required this.body});

  final _i2.ApiV1AdminMailboxesIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse400 extends UpdateMailboxResponse {
  const UpdateMailboxResponse400({required this.body});

  final _i4.ApiV1AdminMailboxesIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse401 extends UpdateMailboxResponse {
  const UpdateMailboxResponse401({required this.body});

  final _i5.ApiV1AdminMailboxesIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse403 extends UpdateMailboxResponse {
  const UpdateMailboxResponse403({required this.body});

  final _i6.ApiV1AdminMailboxesIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse404 extends UpdateMailboxResponse {
  const UpdateMailboxResponse404({required this.body});

  final _i7.ApiV1AdminMailboxesIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse413 extends UpdateMailboxResponse {
  const UpdateMailboxResponse413({required this.body});

  final _i8.ApiV1AdminMailboxesIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse422 extends UpdateMailboxResponse {
  const UpdateMailboxResponse422({required this.body});

  final _i9.ApiV1AdminMailboxesIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse500 extends UpdateMailboxResponse {
  const UpdateMailboxResponse500({required this.body});

  final _i10.ApiV1AdminMailboxesIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateMailboxResponse503 extends UpdateMailboxResponse {
  const UpdateMailboxResponse503({required this.body});

  final _i11.ApiV1AdminMailboxesIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateMailboxResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
