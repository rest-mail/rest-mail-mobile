// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_delete503_response.dart'
    as _i11;

sealed class DeleteContactResponse {
  const DeleteContactResponse();
}

@_i1.immutable
class DeleteContactResponse204 extends DeleteContactResponse {
  const DeleteContactResponse204({required this.body});

  final _i2.ApiV1AccountsIdContactsCidDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse401 extends DeleteContactResponse {
  const DeleteContactResponse401({required this.body});

  final _i4.ApiV1AccountsIdContactsCidDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse403 extends DeleteContactResponse {
  const DeleteContactResponse403({required this.body});

  final _i5.ApiV1AccountsIdContactsCidDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse404 extends DeleteContactResponse {
  const DeleteContactResponse404({required this.body});

  final _i6.ApiV1AccountsIdContactsCidDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse413 extends DeleteContactResponse {
  const DeleteContactResponse413({required this.body});

  final _i7.ApiV1AccountsIdContactsCidDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse422 extends DeleteContactResponse {
  const DeleteContactResponse422({required this.body});

  final _i8.ApiV1AccountsIdContactsCidDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse429 extends DeleteContactResponse {
  const DeleteContactResponse429({required this.body});

  final _i9.ApiV1AccountsIdContactsCidDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse500 extends DeleteContactResponse {
  const DeleteContactResponse500({required this.body});

  final _i10.ApiV1AccountsIdContactsCidDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteContactResponse503 extends DeleteContactResponse {
  const DeleteContactResponse503({required this.body});

  final _i11.ApiV1AccountsIdContactsCidDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteContactResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
