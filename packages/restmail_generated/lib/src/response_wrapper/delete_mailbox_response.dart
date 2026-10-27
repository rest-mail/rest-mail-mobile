// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_delete503_response.dart'
    as _i12;

sealed class DeleteMailboxResponse {
  const DeleteMailboxResponse();
}

@_i1.immutable
class DeleteMailboxResponse204 extends DeleteMailboxResponse {
  const DeleteMailboxResponse204({required this.body});

  final _i2.ApiV1AdminMailboxesIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse401 extends DeleteMailboxResponse {
  const DeleteMailboxResponse401({required this.body});

  final _i4.ApiV1AdminMailboxesIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse403 extends DeleteMailboxResponse {
  const DeleteMailboxResponse403({required this.body});

  final _i5.ApiV1AdminMailboxesIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse404 extends DeleteMailboxResponse {
  const DeleteMailboxResponse404({required this.body});

  final _i6.ApiV1AdminMailboxesIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse409 extends DeleteMailboxResponse {
  const DeleteMailboxResponse409({required this.body});

  final _i7.ApiV1AdminMailboxesIdDelete409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse413 extends DeleteMailboxResponse {
  const DeleteMailboxResponse413({required this.body});

  final _i8.ApiV1AdminMailboxesIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse422 extends DeleteMailboxResponse {
  const DeleteMailboxResponse422({required this.body});

  final _i9.ApiV1AdminMailboxesIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse429 extends DeleteMailboxResponse {
  const DeleteMailboxResponse429({required this.body});

  final _i10.ApiV1AdminMailboxesIdDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse500 extends DeleteMailboxResponse {
  const DeleteMailboxResponse500({required this.body});

  final _i11.ApiV1AdminMailboxesIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMailboxResponse503 extends DeleteMailboxResponse {
  const DeleteMailboxResponse503({required this.body});

  final _i12.ApiV1AdminMailboxesIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMailboxResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
