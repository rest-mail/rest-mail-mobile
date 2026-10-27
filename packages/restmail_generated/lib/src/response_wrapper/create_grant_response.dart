// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_grants_post503_response.dart'
    as _i11;

sealed class CreateGrantResponse {
  const CreateGrantResponse();
}

@_i1.immutable
class CreateGrantResponse201 extends CreateGrantResponse {
  const CreateGrantResponse201({required this.body});

  final _i2.ApiV1AdminGrantsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse400 extends CreateGrantResponse {
  const CreateGrantResponse400({required this.body});

  final _i4.ApiV1AdminGrantsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse401 extends CreateGrantResponse {
  const CreateGrantResponse401({required this.body});

  final _i5.ApiV1AdminGrantsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse403 extends CreateGrantResponse {
  const CreateGrantResponse403({required this.body});

  final _i6.ApiV1AdminGrantsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse409 extends CreateGrantResponse {
  const CreateGrantResponse409({required this.body});

  final _i7.ApiV1AdminGrantsPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse413 extends CreateGrantResponse {
  const CreateGrantResponse413({required this.body});

  final _i8.ApiV1AdminGrantsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse422 extends CreateGrantResponse {
  const CreateGrantResponse422({required this.body});

  final _i9.ApiV1AdminGrantsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse500 extends CreateGrantResponse {
  const CreateGrantResponse500({required this.body});

  final _i10.ApiV1AdminGrantsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateGrantResponse503 extends CreateGrantResponse {
  const CreateGrantResponse503({required this.body});

  final _i11.ApiV1AdminGrantsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
