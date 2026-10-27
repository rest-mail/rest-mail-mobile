// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_reset_post500_response.dart'
    as _i9;

sealed class ResetAdminResponse {
  const ResetAdminResponse();
}

@_i1.immutable
class ResetAdminResponse200 extends ResetAdminResponse {
  const ResetAdminResponse200({required this.body});

  final _i2.ApiV1AuthResetPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse400 extends ResetAdminResponse {
  const ResetAdminResponse400({required this.body});

  final _i4.ApiV1AuthResetPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse401 extends ResetAdminResponse {
  const ResetAdminResponse401({required this.body});

  final _i5.ApiV1AuthResetPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse413 extends ResetAdminResponse {
  const ResetAdminResponse413({required this.body});

  final _i6.ApiV1AuthResetPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse422 extends ResetAdminResponse {
  const ResetAdminResponse422({required this.body});

  final _i7.ApiV1AuthResetPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse429 extends ResetAdminResponse {
  const ResetAdminResponse429({required this.body});

  final _i8.ApiV1AuthResetPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ResetAdminResponse500 extends ResetAdminResponse {
  const ResetAdminResponse500({required this.body});

  final _i9.ApiV1AuthResetPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetAdminResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
