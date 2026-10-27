// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_validate_post503_response.dart'
    as _i11;

sealed class ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse();
}

@_i1.immutable
class ValidateCustomFilterResponse200 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse200({required this.body});

  final _i2.ApiV1AdminCustomFiltersValidatePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse400 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse400({required this.body});

  final _i4.ApiV1AdminCustomFiltersValidatePost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse401 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse401({required this.body});

  final _i5.ApiV1AdminCustomFiltersValidatePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse403 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse403({required this.body});

  final _i6.ApiV1AdminCustomFiltersValidatePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse413 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse413({required this.body});

  final _i7.ApiV1AdminCustomFiltersValidatePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse422 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse422({required this.body});

  final _i8.ApiV1AdminCustomFiltersValidatePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse429 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse429({required this.body});

  final _i9.ApiV1AdminCustomFiltersValidatePost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse500 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse500({required this.body});

  final _i10.ApiV1AdminCustomFiltersValidatePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ValidateCustomFilterResponse503 extends ValidateCustomFilterResponse {
  const ValidateCustomFilterResponse503({required this.body});

  final _i11.ApiV1AdminCustomFiltersValidatePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ValidateCustomFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
