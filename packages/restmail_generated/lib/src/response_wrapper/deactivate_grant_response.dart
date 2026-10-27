// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_deactivate_post503_response.dart'
    as _i11;

sealed class DeactivateGrantResponse {
  const DeactivateGrantResponse();
}

@_i1.immutable
class DeactivateGrantResponse200 extends DeactivateGrantResponse {
  const DeactivateGrantResponse200({required this.body});

  final _i2.ApiV1AdminGrantsIdDeactivatePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse401 extends DeactivateGrantResponse {
  const DeactivateGrantResponse401({required this.body});

  final _i4.ApiV1AdminGrantsIdDeactivatePost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse403 extends DeactivateGrantResponse {
  const DeactivateGrantResponse403({required this.body});

  final _i5.ApiV1AdminGrantsIdDeactivatePost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse404 extends DeactivateGrantResponse {
  const DeactivateGrantResponse404({required this.body});

  final _i6.ApiV1AdminGrantsIdDeactivatePost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse409 extends DeactivateGrantResponse {
  const DeactivateGrantResponse409({required this.body});

  final _i7.ApiV1AdminGrantsIdDeactivatePost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse413 extends DeactivateGrantResponse {
  const DeactivateGrantResponse413({required this.body});

  final _i8.ApiV1AdminGrantsIdDeactivatePost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse422 extends DeactivateGrantResponse {
  const DeactivateGrantResponse422({required this.body});

  final _i9.ApiV1AdminGrantsIdDeactivatePost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse500 extends DeactivateGrantResponse {
  const DeactivateGrantResponse500({required this.body});

  final _i10.ApiV1AdminGrantsIdDeactivatePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeactivateGrantResponse503 extends DeactivateGrantResponse {
  const DeactivateGrantResponse503({required this.body});

  final _i11.ApiV1AdminGrantsIdDeactivatePost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeactivateGrantResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
