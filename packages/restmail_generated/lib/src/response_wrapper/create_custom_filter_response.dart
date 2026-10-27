// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_custom_filters_post503_response.dart'
    as _i11;

sealed class CreateCustomFilterResponse {
  const CreateCustomFilterResponse();
}

@_i1.immutable
class CreateCustomFilterResponse201 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse201({required this.body});

  final _i2.ApiV1AdminCustomFiltersPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse400 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse400({required this.body});

  final _i4.ApiV1AdminCustomFiltersPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse401 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse401({required this.body});

  final _i5.ApiV1AdminCustomFiltersPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse403 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse403({required this.body});

  final _i6.ApiV1AdminCustomFiltersPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse413 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse413({required this.body});

  final _i7.ApiV1AdminCustomFiltersPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse422 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse422({required this.body});

  final _i8.ApiV1AdminCustomFiltersPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse429 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse429({required this.body});

  final _i9.ApiV1AdminCustomFiltersPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse500 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse500({required this.body});

  final _i10.ApiV1AdminCustomFiltersPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCustomFilterResponse503 extends CreateCustomFilterResponse {
  const CreateCustomFilterResponse503({required this.body});

  final _i11.ApiV1AdminCustomFiltersPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCustomFilterResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
