// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_suggest_get503_response.dart'
    as _i10;

sealed class SuggestContactsResponse {
  const SuggestContactsResponse();
}

@_i1.immutable
class SuggestContactsResponse200 extends SuggestContactsResponse {
  const SuggestContactsResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactsSuggestGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse401 extends SuggestContactsResponse {
  const SuggestContactsResponse401({required this.body});

  final _i4.ApiV1AccountsIdContactsSuggestGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse403 extends SuggestContactsResponse {
  const SuggestContactsResponse403({required this.body});

  final _i5.ApiV1AccountsIdContactsSuggestGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse413 extends SuggestContactsResponse {
  const SuggestContactsResponse413({required this.body});

  final _i6.ApiV1AccountsIdContactsSuggestGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse422 extends SuggestContactsResponse {
  const SuggestContactsResponse422({required this.body});

  final _i7.ApiV1AccountsIdContactsSuggestGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse429 extends SuggestContactsResponse {
  const SuggestContactsResponse429({required this.body});

  final _i8.ApiV1AccountsIdContactsSuggestGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse500 extends SuggestContactsResponse {
  const SuggestContactsResponse500({required this.body});

  final _i9.ApiV1AccountsIdContactsSuggestGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SuggestContactsResponse503 extends SuggestContactsResponse {
  const SuggestContactsResponse503({required this.body});

  final _i10.ApiV1AccountsIdContactsSuggestGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SuggestContactsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
