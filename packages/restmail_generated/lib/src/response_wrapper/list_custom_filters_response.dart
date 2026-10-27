// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_get503_response.dart'
    as _i9;

sealed class ListCustomFiltersResponse {
  const ListCustomFiltersResponse();
}

@_i1.immutable
class ListCustomFiltersResponse200 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse200({required this.body});

  final _i2.ApiV1AdminCustomFiltersGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse401 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse401({required this.body});

  final _i4.ApiV1AdminCustomFiltersGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse403 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse403({required this.body});

  final _i5.ApiV1AdminCustomFiltersGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse413 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse413({required this.body});

  final _i6.ApiV1AdminCustomFiltersGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse422 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse422({required this.body});

  final _i7.ApiV1AdminCustomFiltersGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse500 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse500({required this.body});

  final _i8.ApiV1AdminCustomFiltersGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCustomFiltersResponse503 extends ListCustomFiltersResponse {
  const ListCustomFiltersResponse503({required this.body});

  final _i9.ApiV1AdminCustomFiltersGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCustomFiltersResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
