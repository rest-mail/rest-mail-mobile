// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_patch503_response.dart'
    as _i12;

sealed class UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse();
}

@_i1.immutable
class UpdateCustomFilterResponse200 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse200({required this.body});

  final _i2.ApiV1AdminCustomFiltersIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse400 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse400({required this.body});

  final _i4.ApiV1AdminCustomFiltersIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse401 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse401({required this.body});

  final _i5.ApiV1AdminCustomFiltersIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse403 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse403({required this.body});

  final _i6.ApiV1AdminCustomFiltersIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse404 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse404({required this.body});

  final _i7.ApiV1AdminCustomFiltersIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse413 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse413({required this.body});

  final _i8.ApiV1AdminCustomFiltersIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse422 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse422({required this.body});

  final _i9.ApiV1AdminCustomFiltersIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse429 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse429({required this.body});

  final _i10.ApiV1AdminCustomFiltersIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse500 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse500({required this.body});

  final _i11.ApiV1AdminCustomFiltersIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateCustomFilterResponse503 extends UpdateCustomFilterResponse {
  const UpdateCustomFilterResponse503({required this.body});

  final _i12.ApiV1AdminCustomFiltersIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
