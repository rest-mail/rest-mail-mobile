// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_get503_response.dart'
    as _i10;

sealed class ListCredentialsResponse {
  const ListCredentialsResponse();
}

@_i1.immutable
class ListCredentialsResponse200 extends ListCredentialsResponse {
  const ListCredentialsResponse200({required this.body});

  final _i2.ApiV1AccountsIdCredentialsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse401 extends ListCredentialsResponse {
  const ListCredentialsResponse401({required this.body});

  final _i4.ApiV1AccountsIdCredentialsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse403 extends ListCredentialsResponse {
  const ListCredentialsResponse403({required this.body});

  final _i5.ApiV1AccountsIdCredentialsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse404 extends ListCredentialsResponse {
  const ListCredentialsResponse404({required this.body});

  final _i6.ApiV1AccountsIdCredentialsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse413 extends ListCredentialsResponse {
  const ListCredentialsResponse413({required this.body});

  final _i7.ApiV1AccountsIdCredentialsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse422 extends ListCredentialsResponse {
  const ListCredentialsResponse422({required this.body});

  final _i8.ApiV1AccountsIdCredentialsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse500 extends ListCredentialsResponse {
  const ListCredentialsResponse500({required this.body});

  final _i9.ApiV1AccountsIdCredentialsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCredentialsResponse503 extends ListCredentialsResponse {
  const ListCredentialsResponse503({required this.body});

  final _i10.ApiV1AccountsIdCredentialsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCredentialsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
