// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_get503_response.dart'
    as _i11;

sealed class GetAccountResponse {
  const GetAccountResponse();
}

@_i1.immutable
class GetAccountResponse200 extends GetAccountResponse {
  const GetAccountResponse200({required this.body});

  final _i2.ApiV1AccountsIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse401 extends GetAccountResponse {
  const GetAccountResponse401({required this.body});

  final _i4.ApiV1AccountsIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse403 extends GetAccountResponse {
  const GetAccountResponse403({required this.body});

  final _i5.ApiV1AccountsIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse404 extends GetAccountResponse {
  const GetAccountResponse404({required this.body});

  final _i6.ApiV1AccountsIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse413 extends GetAccountResponse {
  const GetAccountResponse413({required this.body});

  final _i7.ApiV1AccountsIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse422 extends GetAccountResponse {
  const GetAccountResponse422({required this.body});

  final _i8.ApiV1AccountsIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse429 extends GetAccountResponse {
  const GetAccountResponse429({required this.body});

  final _i9.ApiV1AccountsIdGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse500 extends GetAccountResponse {
  const GetAccountResponse500({required this.body});

  final _i10.ApiV1AccountsIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountResponse503 extends GetAccountResponse {
  const GetAccountResponse503({required this.body});

  final _i11.ApiV1AccountsIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
