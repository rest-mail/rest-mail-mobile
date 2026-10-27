// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_get503_response.dart'
    as _i10;

sealed class ListAccountsResponse {
  const ListAccountsResponse();
}

@_i1.immutable
class ListAccountsResponse200 extends ListAccountsResponse {
  const ListAccountsResponse200({required this.body});

  final _i2.ApiV1AccountsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse401 extends ListAccountsResponse {
  const ListAccountsResponse401({required this.body});

  final _i4.ApiV1AccountsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse403 extends ListAccountsResponse {
  const ListAccountsResponse403({required this.body});

  final _i5.ApiV1AccountsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse404 extends ListAccountsResponse {
  const ListAccountsResponse404({required this.body});

  final _i6.ApiV1AccountsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse413 extends ListAccountsResponse {
  const ListAccountsResponse413({required this.body});

  final _i7.ApiV1AccountsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse429 extends ListAccountsResponse {
  const ListAccountsResponse429({required this.body});

  final _i8.ApiV1AccountsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse500 extends ListAccountsResponse {
  const ListAccountsResponse500({required this.body});

  final _i9.ApiV1AccountsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAccountsResponse503 extends ListAccountsResponse {
  const ListAccountsResponse503({required this.body});

  final _i10.ApiV1AccountsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAccountsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
