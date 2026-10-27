// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_vacation_put503_response.dart'
    as _i11;

sealed class SetVacationResponse {
  const SetVacationResponse();
}

@_i1.immutable
class SetVacationResponse200 extends SetVacationResponse {
  const SetVacationResponse200({required this.body});

  final _i2.ApiV1AccountsIdVacationPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse400 extends SetVacationResponse {
  const SetVacationResponse400({required this.body});

  final _i4.ApiV1AccountsIdVacationPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse401 extends SetVacationResponse {
  const SetVacationResponse401({required this.body});

  final _i5.ApiV1AccountsIdVacationPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse403 extends SetVacationResponse {
  const SetVacationResponse403({required this.body});

  final _i6.ApiV1AccountsIdVacationPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse413 extends SetVacationResponse {
  const SetVacationResponse413({required this.body});

  final _i7.ApiV1AccountsIdVacationPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse422 extends SetVacationResponse {
  const SetVacationResponse422({required this.body});

  final _i8.ApiV1AccountsIdVacationPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse429 extends SetVacationResponse {
  const SetVacationResponse429({required this.body});

  final _i9.ApiV1AccountsIdVacationPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse500 extends SetVacationResponse {
  const SetVacationResponse500({required this.body});

  final _i10.ApiV1AccountsIdVacationPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetVacationResponse503 extends SetVacationResponse {
  const SetVacationResponse503({required this.body});

  final _i11.ApiV1AccountsIdVacationPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
