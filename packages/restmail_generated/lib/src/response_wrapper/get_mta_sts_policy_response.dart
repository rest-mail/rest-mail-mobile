// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_mta_sts_get503_response.dart'
    as _i10;

sealed class GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse();
}

@_i1.immutable
class GetMtaStsPolicyResponse200 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdMtaStsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse401 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdMtaStsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse403 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdMtaStsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse404 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdMtaStsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse413 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdMtaStsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse422 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdMtaStsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse500 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdMtaStsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMtaStsPolicyResponse503 extends GetMtaStsPolicyResponse {
  const GetMtaStsPolicyResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdMtaStsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMtaStsPolicyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
