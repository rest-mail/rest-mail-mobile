// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_grants_id_delete503_response.dart'
    as _i12;

sealed class DeleteGrantResponse {
  const DeleteGrantResponse();
}

@_i1.immutable
class DeleteGrantResponse204 extends DeleteGrantResponse {
  const DeleteGrantResponse204({required this.body});

  final _i2.ApiV1AdminGrantsIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse401 extends DeleteGrantResponse {
  const DeleteGrantResponse401({required this.body});

  final _i4.ApiV1AdminGrantsIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse403 extends DeleteGrantResponse {
  const DeleteGrantResponse403({required this.body});

  final _i5.ApiV1AdminGrantsIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse404 extends DeleteGrantResponse {
  const DeleteGrantResponse404({required this.body});

  final _i6.ApiV1AdminGrantsIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse409 extends DeleteGrantResponse {
  const DeleteGrantResponse409({required this.body});

  final _i7.ApiV1AdminGrantsIdDelete409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse413 extends DeleteGrantResponse {
  const DeleteGrantResponse413({required this.body});

  final _i8.ApiV1AdminGrantsIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse422 extends DeleteGrantResponse {
  const DeleteGrantResponse422({required this.body});

  final _i9.ApiV1AdminGrantsIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse429 extends DeleteGrantResponse {
  const DeleteGrantResponse429({required this.body});

  final _i10.ApiV1AdminGrantsIdDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse500 extends DeleteGrantResponse {
  const DeleteGrantResponse500({required this.body});

  final _i11.ApiV1AdminGrantsIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteGrantResponse503 extends DeleteGrantResponse {
  const DeleteGrantResponse503({required this.body});

  final _i12.ApiV1AdminGrantsIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteGrantResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
