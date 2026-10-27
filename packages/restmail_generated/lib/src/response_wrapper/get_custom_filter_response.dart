// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_get503_response.dart'
    as _i10;

sealed class GetCustomFilterResponse {
  const GetCustomFilterResponse();
}

@_i1.immutable
class GetCustomFilterResponse200 extends GetCustomFilterResponse {
  const GetCustomFilterResponse200({required this.body});

  final _i2.ApiV1AdminCustomFiltersIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse401 extends GetCustomFilterResponse {
  const GetCustomFilterResponse401({required this.body});

  final _i4.ApiV1AdminCustomFiltersIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse403 extends GetCustomFilterResponse {
  const GetCustomFilterResponse403({required this.body});

  final _i5.ApiV1AdminCustomFiltersIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse404 extends GetCustomFilterResponse {
  const GetCustomFilterResponse404({required this.body});

  final _i6.ApiV1AdminCustomFiltersIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse413 extends GetCustomFilterResponse {
  const GetCustomFilterResponse413({required this.body});

  final _i7.ApiV1AdminCustomFiltersIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse422 extends GetCustomFilterResponse {
  const GetCustomFilterResponse422({required this.body});

  final _i8.ApiV1AdminCustomFiltersIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse500 extends GetCustomFilterResponse {
  const GetCustomFilterResponse500({required this.body});

  final _i9.ApiV1AdminCustomFiltersIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCustomFilterResponse503 extends GetCustomFilterResponse {
  const GetCustomFilterResponse503({required this.body});

  final _i10.ApiV1AdminCustomFiltersIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCustomFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
