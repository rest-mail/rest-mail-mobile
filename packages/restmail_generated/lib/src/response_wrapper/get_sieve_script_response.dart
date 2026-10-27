// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_get503_response.dart'
    as _i10;

sealed class GetSieveScriptResponse {
  const GetSieveScriptResponse();
}

@_i1.immutable
class GetSieveScriptResponse200 extends GetSieveScriptResponse {
  const GetSieveScriptResponse200({required this.body});

  final _i2.ApiV1AccountsIdSieveGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse401 extends GetSieveScriptResponse {
  const GetSieveScriptResponse401({required this.body});

  final _i4.ApiV1AccountsIdSieveGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse403 extends GetSieveScriptResponse {
  const GetSieveScriptResponse403({required this.body});

  final _i5.ApiV1AccountsIdSieveGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse413 extends GetSieveScriptResponse {
  const GetSieveScriptResponse413({required this.body});

  final _i6.ApiV1AccountsIdSieveGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse422 extends GetSieveScriptResponse {
  const GetSieveScriptResponse422({required this.body});

  final _i7.ApiV1AccountsIdSieveGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse429 extends GetSieveScriptResponse {
  const GetSieveScriptResponse429({required this.body});

  final _i8.ApiV1AccountsIdSieveGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse500 extends GetSieveScriptResponse {
  const GetSieveScriptResponse500({required this.body});

  final _i9.ApiV1AccountsIdSieveGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetSieveScriptResponse503 extends GetSieveScriptResponse {
  const GetSieveScriptResponse503({required this.body});

  final _i10.ApiV1AccountsIdSieveGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetSieveScriptResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
