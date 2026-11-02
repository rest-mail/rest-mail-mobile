// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_send_limits_get503_response.dart'
    as _i10;

sealed class GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse();
}

@_i1.immutable
class GetAccountSendLimitsResponse200 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse200({required this.body});

  final _i2.ApiV1AccountsIdSendLimitsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse401 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse401({required this.body});

  final _i4.ApiV1AccountsIdSendLimitsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse403 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse403({required this.body});

  final _i5.ApiV1AccountsIdSendLimitsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse404 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse404({required this.body});

  final _i6.ApiV1AccountsIdSendLimitsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse413 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse413({required this.body});

  final _i7.ApiV1AccountsIdSendLimitsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse422 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse422({required this.body});

  final _i8.ApiV1AccountsIdSendLimitsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse500 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse500({required this.body});

  final _i9.ApiV1AccountsIdSendLimitsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetAccountSendLimitsResponse503 extends GetAccountSendLimitsResponse {
  const GetAccountSendLimitsResponse503({required this.body});

  final _i10.ApiV1AccountsIdSendLimitsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetAccountSendLimitsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
