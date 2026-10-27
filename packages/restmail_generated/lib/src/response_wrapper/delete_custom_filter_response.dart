// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_id_delete503_response.dart'
    as _i10;

sealed class DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse();
}

@_i1.immutable
class DeleteCustomFilterResponse200 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse200({required this.body});

  final _i2.ApiV1AdminCustomFiltersIdDelete200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse401 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse401({required this.body});

  final _i4.ApiV1AdminCustomFiltersIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse403 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse403({required this.body});

  final _i5.ApiV1AdminCustomFiltersIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse404 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse404({required this.body});

  final _i6.ApiV1AdminCustomFiltersIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse413 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse413({required this.body});

  final _i7.ApiV1AdminCustomFiltersIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse422 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse422({required this.body});

  final _i8.ApiV1AdminCustomFiltersIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse500 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse500({required this.body});

  final _i9.ApiV1AdminCustomFiltersIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCustomFilterResponse503 extends DeleteCustomFilterResponse {
  const DeleteCustomFilterResponse503({required this.body});

  final _i10.ApiV1AdminCustomFiltersIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCustomFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
