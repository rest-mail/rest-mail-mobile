// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_id_put503_response.dart'
    as _i12;

sealed class SetDkimKeyResponse {
  const SetDkimKeyResponse();
}

@_i1.immutable
class SetDkimKeyResponse200 extends SetDkimKeyResponse {
  const SetDkimKeyResponse200({required this.body});

  final _i2.ApiV1AdminDkimIdPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse400 extends SetDkimKeyResponse {
  const SetDkimKeyResponse400({required this.body});

  final _i4.ApiV1AdminDkimIdPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse401 extends SetDkimKeyResponse {
  const SetDkimKeyResponse401({required this.body});

  final _i5.ApiV1AdminDkimIdPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse403 extends SetDkimKeyResponse {
  const SetDkimKeyResponse403({required this.body});

  final _i6.ApiV1AdminDkimIdPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse404 extends SetDkimKeyResponse {
  const SetDkimKeyResponse404({required this.body});

  final _i7.ApiV1AdminDkimIdPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse413 extends SetDkimKeyResponse {
  const SetDkimKeyResponse413({required this.body});

  final _i8.ApiV1AdminDkimIdPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse422 extends SetDkimKeyResponse {
  const SetDkimKeyResponse422({required this.body});

  final _i9.ApiV1AdminDkimIdPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse429 extends SetDkimKeyResponse {
  const SetDkimKeyResponse429({required this.body});

  final _i10.ApiV1AdminDkimIdPut429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse500 extends SetDkimKeyResponse {
  const SetDkimKeyResponse500({required this.body});

  final _i11.ApiV1AdminDkimIdPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDkimKeyResponse503 extends SetDkimKeyResponse {
  const SetDkimKeyResponse503({required this.body});

  final _i12.ApiV1AdminDkimIdPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
