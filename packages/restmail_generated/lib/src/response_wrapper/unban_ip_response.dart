// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_bans_ip_ip_delete503_response.dart'
    as _i9;

sealed class UnbanIpResponse {
  const UnbanIpResponse();
}

@_i1.immutable
class UnbanIpResponse204 extends UnbanIpResponse {
  const UnbanIpResponse204({required this.body});

  final _i2.ApiV1AdminBansIpIpDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse401 extends UnbanIpResponse {
  const UnbanIpResponse401({required this.body});

  final _i4.ApiV1AdminBansIpIpDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse403 extends UnbanIpResponse {
  const UnbanIpResponse403({required this.body});

  final _i5.ApiV1AdminBansIpIpDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse404 extends UnbanIpResponse {
  const UnbanIpResponse404({required this.body});

  final _i6.ApiV1AdminBansIpIpDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse413 extends UnbanIpResponse {
  const UnbanIpResponse413({required this.body});

  final _i7.ApiV1AdminBansIpIpDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse500 extends UnbanIpResponse {
  const UnbanIpResponse500({required this.body});

  final _i8.ApiV1AdminBansIpIpDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnbanIpResponse503 extends UnbanIpResponse {
  const UnbanIpResponse503({required this.body});

  final _i9.ApiV1AdminBansIpIpDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnbanIpResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
