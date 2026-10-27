// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post400_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post401_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post403_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_bans_post503_response.dart'
    as _i12;

sealed class CreateBanResponse {
  const CreateBanResponse();
}

@_i1.immutable
class CreateBanResponse200 extends CreateBanResponse {
  const CreateBanResponse200({required this.body});

  final _i2.ApiV1AdminBansPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse201 extends CreateBanResponse {
  const CreateBanResponse201({required this.body});

  final _i4.ApiV1AdminBansPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse400 extends CreateBanResponse {
  const CreateBanResponse400({required this.body});

  final _i5.ApiV1AdminBansPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse401 extends CreateBanResponse {
  const CreateBanResponse401({required this.body});

  final _i6.ApiV1AdminBansPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse403 extends CreateBanResponse {
  const CreateBanResponse403({required this.body});

  final _i7.ApiV1AdminBansPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse413 extends CreateBanResponse {
  const CreateBanResponse413({required this.body});

  final _i8.ApiV1AdminBansPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse422 extends CreateBanResponse {
  const CreateBanResponse422({required this.body});

  final _i9.ApiV1AdminBansPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse429 extends CreateBanResponse {
  const CreateBanResponse429({required this.body});

  final _i10.ApiV1AdminBansPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse500 extends CreateBanResponse {
  const CreateBanResponse500({required this.body});

  final _i11.ApiV1AdminBansPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateBanResponse503 extends CreateBanResponse {
  const CreateBanResponse503({required this.body});

  final _i12.ApiV1AdminBansPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateBanResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
