// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_get503_response.dart'
    as _i10;

sealed class GetDomainResponse {
  const GetDomainResponse();
}

@_i1.immutable
class GetDomainResponse200 extends GetDomainResponse {
  const GetDomainResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse401 extends GetDomainResponse {
  const GetDomainResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse403 extends GetDomainResponse {
  const GetDomainResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse404 extends GetDomainResponse {
  const GetDomainResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse413 extends GetDomainResponse {
  const GetDomainResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse422 extends GetDomainResponse {
  const GetDomainResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse500 extends GetDomainResponse {
  const GetDomainResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainResponse503 extends GetDomainResponse {
  const GetDomainResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
