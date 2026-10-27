// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_get503_response.dart'
    as _i10;

sealed class GetVacationResponse {
  const GetVacationResponse();
}

@_i1.immutable
class GetVacationResponse200 extends GetVacationResponse {
  const GetVacationResponse200({required this.body});

  final _i2.ApiV1AccountsIdVacationGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse401 extends GetVacationResponse {
  const GetVacationResponse401({required this.body});

  final _i4.ApiV1AccountsIdVacationGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse403 extends GetVacationResponse {
  const GetVacationResponse403({required this.body});

  final _i5.ApiV1AccountsIdVacationGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse413 extends GetVacationResponse {
  const GetVacationResponse413({required this.body});

  final _i6.ApiV1AccountsIdVacationGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse422 extends GetVacationResponse {
  const GetVacationResponse422({required this.body});

  final _i7.ApiV1AccountsIdVacationGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse429 extends GetVacationResponse {
  const GetVacationResponse429({required this.body});

  final _i8.ApiV1AccountsIdVacationGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse500 extends GetVacationResponse {
  const GetVacationResponse500({required this.body});

  final _i9.ApiV1AccountsIdVacationGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetVacationResponse503 extends GetVacationResponse {
  const GetVacationResponse503({required this.body});

  final _i10.ApiV1AccountsIdVacationGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVacationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
