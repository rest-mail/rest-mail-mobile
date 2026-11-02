// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_server_capabilities_put503_response.dart'
    as _i12;

sealed class UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse();
}

@_i1.immutable
class UpdateServerCapabilitiesResponse200
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse200({required this.body});

  final _i2.ApiV1AdminServerCapabilitiesPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse400
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse400({required this.body});

  final _i4.ApiV1AdminServerCapabilitiesPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse400 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse401
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse401({required this.body});

  final _i5.ApiV1AdminServerCapabilitiesPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse401 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse403
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse403({required this.body});

  final _i6.ApiV1AdminServerCapabilitiesPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse403 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse409
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse409({required this.body});

  final _i7.ApiV1AdminServerCapabilitiesPut409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse409 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse413
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse413({required this.body});

  final _i8.ApiV1AdminServerCapabilitiesPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse413 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse422
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse422({required this.body});

  final _i9.ApiV1AdminServerCapabilitiesPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse422 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse429
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse429({required this.body});

  final _i10.ApiV1AdminServerCapabilitiesPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse429 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse500
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse500({required this.body});

  final _i11.ApiV1AdminServerCapabilitiesPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateServerCapabilitiesResponse503
    extends UpdateServerCapabilitiesResponse {
  const UpdateServerCapabilitiesResponse503({required this.body});

  final _i12.ApiV1AdminServerCapabilitiesPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerCapabilitiesResponse503 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
