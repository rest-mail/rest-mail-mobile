// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quota_get503_response.dart'
    as _i11;

sealed class GetQuotaResponse {
  const GetQuotaResponse();
}

@_i1.immutable
class GetQuotaResponse200 extends GetQuotaResponse {
  const GetQuotaResponse200({required this.body});

  final _i2.ApiV1AccountsIdQuotaGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse401 extends GetQuotaResponse {
  const GetQuotaResponse401({required this.body});

  final _i4.ApiV1AccountsIdQuotaGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse403 extends GetQuotaResponse {
  const GetQuotaResponse403({required this.body});

  final _i5.ApiV1AccountsIdQuotaGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse404 extends GetQuotaResponse {
  const GetQuotaResponse404({required this.body});

  final _i6.ApiV1AccountsIdQuotaGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse413 extends GetQuotaResponse {
  const GetQuotaResponse413({required this.body});

  final _i7.ApiV1AccountsIdQuotaGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse422 extends GetQuotaResponse {
  const GetQuotaResponse422({required this.body});

  final _i8.ApiV1AccountsIdQuotaGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse429 extends GetQuotaResponse {
  const GetQuotaResponse429({required this.body});

  final _i9.ApiV1AccountsIdQuotaGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse500 extends GetQuotaResponse {
  const GetQuotaResponse500({required this.body});

  final _i10.ApiV1AccountsIdQuotaGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuotaResponse503 extends GetQuotaResponse {
  const GetQuotaResponse503({required this.body});

  final _i11.ApiV1AccountsIdQuotaGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuotaResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
