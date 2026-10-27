// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_delete503_response.dart'
    as _i10;

sealed class DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse();
}

@_i1.immutable
class DeleteSieveScriptResponse200 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse200({required this.body});

  final _i2.ApiV1AccountsIdSieveDelete200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse401 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse401({required this.body});

  final _i4.ApiV1AccountsIdSieveDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse403 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse403({required this.body});

  final _i5.ApiV1AccountsIdSieveDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse413 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse413({required this.body});

  final _i6.ApiV1AccountsIdSieveDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse422 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse422({required this.body});

  final _i7.ApiV1AccountsIdSieveDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse429 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse429({required this.body});

  final _i8.ApiV1AccountsIdSieveDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse500 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse500({required this.body});

  final _i9.ApiV1AccountsIdSieveDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteSieveScriptResponse503 extends DeleteSieveScriptResponse {
  const DeleteSieveScriptResponse503({required this.body});

  final _i10.ApiV1AccountsIdSieveDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteSieveScriptResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
