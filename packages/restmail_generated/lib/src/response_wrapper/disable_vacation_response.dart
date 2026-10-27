// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_delete503_response.dart'
    as _i10;

sealed class DisableVacationResponse {
  const DisableVacationResponse();
}

@_i1.immutable
class DisableVacationResponse204 extends DisableVacationResponse {
  const DisableVacationResponse204({required this.body});

  final _i2.ApiV1AccountsIdVacationDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse401 extends DisableVacationResponse {
  const DisableVacationResponse401({required this.body});

  final _i4.ApiV1AccountsIdVacationDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse403 extends DisableVacationResponse {
  const DisableVacationResponse403({required this.body});

  final _i5.ApiV1AccountsIdVacationDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse413 extends DisableVacationResponse {
  const DisableVacationResponse413({required this.body});

  final _i6.ApiV1AccountsIdVacationDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse422 extends DisableVacationResponse {
  const DisableVacationResponse422({required this.body});

  final _i7.ApiV1AccountsIdVacationDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse429 extends DisableVacationResponse {
  const DisableVacationResponse429({required this.body});

  final _i8.ApiV1AccountsIdVacationDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse500 extends DisableVacationResponse {
  const DisableVacationResponse500({required this.body});

  final _i9.ApiV1AccountsIdVacationDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DisableVacationResponse503 extends DisableVacationResponse {
  const DisableVacationResponse503({required this.body});

  final _i10.ApiV1AccountsIdVacationDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableVacationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
