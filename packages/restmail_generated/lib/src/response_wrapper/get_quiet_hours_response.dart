// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quiet_hours_get503_response.dart'
    as _i11;

sealed class GetQuietHoursResponse {
  const GetQuietHoursResponse();
}

@_i1.immutable
class GetQuietHoursResponse200 extends GetQuietHoursResponse {
  const GetQuietHoursResponse200({required this.body});

  final _i2.ApiV1AccountsIdQuietHoursGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse401 extends GetQuietHoursResponse {
  const GetQuietHoursResponse401({required this.body});

  final _i4.ApiV1AccountsIdQuietHoursGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse403 extends GetQuietHoursResponse {
  const GetQuietHoursResponse403({required this.body});

  final _i5.ApiV1AccountsIdQuietHoursGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse404 extends GetQuietHoursResponse {
  const GetQuietHoursResponse404({required this.body});

  final _i6.ApiV1AccountsIdQuietHoursGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse413 extends GetQuietHoursResponse {
  const GetQuietHoursResponse413({required this.body});

  final _i7.ApiV1AccountsIdQuietHoursGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse422 extends GetQuietHoursResponse {
  const GetQuietHoursResponse422({required this.body});

  final _i8.ApiV1AccountsIdQuietHoursGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse429 extends GetQuietHoursResponse {
  const GetQuietHoursResponse429({required this.body});

  final _i9.ApiV1AccountsIdQuietHoursGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse500 extends GetQuietHoursResponse {
  const GetQuietHoursResponse500({required this.body});

  final _i10.ApiV1AccountsIdQuietHoursGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetQuietHoursResponse503 extends GetQuietHoursResponse {
  const GetQuietHoursResponse503({required this.body});

  final _i11.ApiV1AccountsIdQuietHoursGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetQuietHoursResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
