// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_import_post503_response.dart'
    as _i11;

sealed class ImportContactsResponse {
  const ImportContactsResponse();
}

@_i1.immutable
class ImportContactsResponse200 extends ImportContactsResponse {
  const ImportContactsResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactsImportPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse400 extends ImportContactsResponse {
  const ImportContactsResponse400({required this.body});

  final _i4.ApiV1AccountsIdContactsImportPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse401 extends ImportContactsResponse {
  const ImportContactsResponse401({required this.body});

  final _i5.ApiV1AccountsIdContactsImportPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse403 extends ImportContactsResponse {
  const ImportContactsResponse403({required this.body});

  final _i6.ApiV1AccountsIdContactsImportPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse413 extends ImportContactsResponse {
  const ImportContactsResponse413({required this.body});

  final _i7.ApiV1AccountsIdContactsImportPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse422 extends ImportContactsResponse {
  const ImportContactsResponse422({required this.body});

  final _i8.ApiV1AccountsIdContactsImportPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse429 extends ImportContactsResponse {
  const ImportContactsResponse429({required this.body});

  final _i9.ApiV1AccountsIdContactsImportPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse500 extends ImportContactsResponse {
  const ImportContactsResponse500({required this.body});

  final _i10.ApiV1AccountsIdContactsImportPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportContactsResponse503 extends ImportContactsResponse {
  const ImportContactsResponse503({required this.body});

  final _i11.ApiV1AccountsIdContactsImportPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportContactsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
