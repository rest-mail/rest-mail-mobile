// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_rotation_put503_response.dart'
    as _i12;

sealed class SetDkimRotationResponse {
  const SetDkimRotationResponse();
}

@_i1.immutable
class SetDkimRotationResponse200 extends SetDkimRotationResponse {
  const SetDkimRotationResponse200({required this.body});

  final _i2.ApiV1AdminDkimIdRotationPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse400 extends SetDkimRotationResponse {
  const SetDkimRotationResponse400({required this.body});

  final _i4.ApiV1AdminDkimIdRotationPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse401 extends SetDkimRotationResponse {
  const SetDkimRotationResponse401({required this.body});

  final _i5.ApiV1AdminDkimIdRotationPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse403 extends SetDkimRotationResponse {
  const SetDkimRotationResponse403({required this.body});

  final _i6.ApiV1AdminDkimIdRotationPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse404 extends SetDkimRotationResponse {
  const SetDkimRotationResponse404({required this.body});

  final _i7.ApiV1AdminDkimIdRotationPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse413 extends SetDkimRotationResponse {
  const SetDkimRotationResponse413({required this.body});

  final _i8.ApiV1AdminDkimIdRotationPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse422 extends SetDkimRotationResponse {
  const SetDkimRotationResponse422({required this.body});

  final _i9.ApiV1AdminDkimIdRotationPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse429 extends SetDkimRotationResponse {
  const SetDkimRotationResponse429({required this.body});

  final _i10.ApiV1AdminDkimIdRotationPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse500 extends SetDkimRotationResponse {
  const SetDkimRotationResponse500({required this.body});

  final _i11.ApiV1AdminDkimIdRotationPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimRotationResponse503 extends SetDkimRotationResponse {
  const SetDkimRotationResponse503({required this.body});

  final _i12.ApiV1AdminDkimIdRotationPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimRotationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
