// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_delete503_response.dart'
    as _i10;

sealed class DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse();
}

@_i1.immutable
class DeleteMtaStsPolicyResponse204 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse204({required this.body});

  final _i2.ApiV1AdminDomainsIdMtaStsDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse401 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdMtaStsDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse403 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdMtaStsDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse404 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdMtaStsDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse413 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdMtaStsDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse422 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdMtaStsDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse500 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdMtaStsDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteMtaStsPolicyResponse503 extends DeleteMtaStsPolicyResponse {
  const DeleteMtaStsPolicyResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdMtaStsDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteMtaStsPolicyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
