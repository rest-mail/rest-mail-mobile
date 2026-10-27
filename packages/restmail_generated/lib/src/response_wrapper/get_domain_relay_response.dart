// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_get503_response.dart'
    as _i10;

sealed class GetDomainRelayResponse {
  const GetDomainRelayResponse();
}

@_i1.immutable
class GetDomainRelayResponse200 extends GetDomainRelayResponse {
  const GetDomainRelayResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdRelayGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse401 extends GetDomainRelayResponse {
  const GetDomainRelayResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdRelayGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse403 extends GetDomainRelayResponse {
  const GetDomainRelayResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdRelayGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse404 extends GetDomainRelayResponse {
  const GetDomainRelayResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdRelayGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse413 extends GetDomainRelayResponse {
  const GetDomainRelayResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdRelayGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse422 extends GetDomainRelayResponse {
  const GetDomainRelayResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdRelayGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse500 extends GetDomainRelayResponse {
  const GetDomainRelayResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdRelayGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDomainRelayResponse503 extends GetDomainRelayResponse {
  const GetDomainRelayResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdRelayGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDomainRelayResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
