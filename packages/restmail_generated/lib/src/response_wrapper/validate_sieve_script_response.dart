// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_sieve_validate_post503_response.dart'
    as _i11;

sealed class ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse();
}

@_i1.immutable
class ValidateSieveScriptResponse200 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse200({required this.body});

  final _i2.ApiV1AccountsIdSieveValidatePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse400 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse400({required this.body});

  final _i4.ApiV1AccountsIdSieveValidatePost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse401 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse401({required this.body});

  final _i5.ApiV1AccountsIdSieveValidatePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse403 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse403({required this.body});

  final _i6.ApiV1AccountsIdSieveValidatePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse413 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse413({required this.body});

  final _i7.ApiV1AccountsIdSieveValidatePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse422 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse422({required this.body});

  final _i8.ApiV1AccountsIdSieveValidatePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse429 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse429({required this.body});

  final _i9.ApiV1AccountsIdSieveValidatePost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse500 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse500({required this.body});

  final _i10.ApiV1AccountsIdSieveValidatePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateSieveScriptResponse503 extends ValidateSieveScriptResponse {
  const ValidateSieveScriptResponse503({required this.body});

  final _i11.ApiV1AccountsIdSieveValidatePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateSieveScriptResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
