// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_put503_response.dart'
    as _i12;

sealed class SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse();
}

@_i1.immutable
class SetAccountSendLimitsResponse200 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse200({required this.body});

  final _i2.ApiV1AccountsIdSendLimitsPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse400 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse400({required this.body});

  final _i4.ApiV1AccountsIdSendLimitsPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse401 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse401({required this.body});

  final _i5.ApiV1AccountsIdSendLimitsPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse403 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse403({required this.body});

  final _i6.ApiV1AccountsIdSendLimitsPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse404 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse404({required this.body});

  final _i7.ApiV1AccountsIdSendLimitsPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse409 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse409({required this.body});

  final _i8.ApiV1AccountsIdSendLimitsPut409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse413 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse413({required this.body});

  final _i9.ApiV1AccountsIdSendLimitsPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse422 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse422({required this.body});

  final _i10.ApiV1AccountsIdSendLimitsPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse500 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse500({required this.body});

  final _i11.ApiV1AccountsIdSendLimitsPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetAccountSendLimitsResponse503 extends SetAccountSendLimitsResponse {
  const SetAccountSendLimitsResponse503({required this.body});

  final _i12.ApiV1AccountsIdSendLimitsPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetAccountSendLimitsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
