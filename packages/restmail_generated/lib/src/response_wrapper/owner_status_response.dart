// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth_owner_status_post500_response.dart'
    as _i11;

sealed class OwnerStatusResponse {
  const OwnerStatusResponse();
}

@_i1.immutable
class OwnerStatusResponse200 extends OwnerStatusResponse {
  const OwnerStatusResponse200({required this.body});

  final _i2.ApiV1AuthOwnerStatusPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse400 extends OwnerStatusResponse {
  const OwnerStatusResponse400({required this.body});

  final _i4.ApiV1AuthOwnerStatusPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse401 extends OwnerStatusResponse {
  const OwnerStatusResponse401({required this.body});

  final _i5.ApiV1AuthOwnerStatusPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse403 extends OwnerStatusResponse {
  const OwnerStatusResponse403({required this.body});

  final _i6.ApiV1AuthOwnerStatusPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse409 extends OwnerStatusResponse {
  const OwnerStatusResponse409({required this.body});

  final _i7.ApiV1AuthOwnerStatusPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse413 extends OwnerStatusResponse {
  const OwnerStatusResponse413({required this.body});

  final _i8.ApiV1AuthOwnerStatusPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse422 extends OwnerStatusResponse {
  const OwnerStatusResponse422({required this.body});

  final _i9.ApiV1AuthOwnerStatusPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse429 extends OwnerStatusResponse {
  const OwnerStatusResponse429({required this.body});

  final _i10.ApiV1AuthOwnerStatusPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerStatusResponse500 extends OwnerStatusResponse {
  const OwnerStatusResponse500({required this.body});

  final _i11.ApiV1AuthOwnerStatusPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
