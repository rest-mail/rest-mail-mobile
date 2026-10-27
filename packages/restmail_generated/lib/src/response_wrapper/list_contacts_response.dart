// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_get503_response.dart'
    as _i10;

sealed class ListContactsResponse {
  const ListContactsResponse();
}

@_i1.immutable
class ListContactsResponse200 extends ListContactsResponse {
  const ListContactsResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse401 extends ListContactsResponse {
  const ListContactsResponse401({required this.body});

  final _i4.ApiV1AccountsIdContactsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse403 extends ListContactsResponse {
  const ListContactsResponse403({required this.body});

  final _i5.ApiV1AccountsIdContactsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse413 extends ListContactsResponse {
  const ListContactsResponse413({required this.body});

  final _i6.ApiV1AccountsIdContactsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse422 extends ListContactsResponse {
  const ListContactsResponse422({required this.body});

  final _i7.ApiV1AccountsIdContactsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse429 extends ListContactsResponse {
  const ListContactsResponse429({required this.body});

  final _i8.ApiV1AccountsIdContactsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse500 extends ListContactsResponse {
  const ListContactsResponse500({required this.body});

  final _i9.ApiV1AccountsIdContactsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListContactsResponse503 extends ListContactsResponse {
  const ListContactsResponse503({required this.body});

  final _i10.ApiV1AccountsIdContactsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListContactsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
