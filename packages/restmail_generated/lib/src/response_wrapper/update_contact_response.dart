// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_cid_patch503_response.dart'
    as _i12;

sealed class UpdateContactResponse {
  const UpdateContactResponse();
}

@_i1.immutable
class UpdateContactResponse200 extends UpdateContactResponse {
  const UpdateContactResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactsCidPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse400 extends UpdateContactResponse {
  const UpdateContactResponse400({required this.body});

  final _i4.ApiV1AccountsIdContactsCidPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse401 extends UpdateContactResponse {
  const UpdateContactResponse401({required this.body});

  final _i5.ApiV1AccountsIdContactsCidPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse403 extends UpdateContactResponse {
  const UpdateContactResponse403({required this.body});

  final _i6.ApiV1AccountsIdContactsCidPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse404 extends UpdateContactResponse {
  const UpdateContactResponse404({required this.body});

  final _i7.ApiV1AccountsIdContactsCidPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse413 extends UpdateContactResponse {
  const UpdateContactResponse413({required this.body});

  final _i8.ApiV1AccountsIdContactsCidPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse422 extends UpdateContactResponse {
  const UpdateContactResponse422({required this.body});

  final _i9.ApiV1AccountsIdContactsCidPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse429 extends UpdateContactResponse {
  const UpdateContactResponse429({required this.body});

  final _i10.ApiV1AccountsIdContactsCidPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse500 extends UpdateContactResponse {
  const UpdateContactResponse500({required this.body});

  final _i11.ApiV1AccountsIdContactsCidPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateContactResponse503 extends UpdateContactResponse {
  const UpdateContactResponse503({required this.body});

  final _i12.ApiV1AccountsIdContactsCidPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateContactResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
