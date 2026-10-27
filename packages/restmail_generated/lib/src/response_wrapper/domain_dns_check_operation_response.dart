// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_dns_get503_response.dart'
    as _i10;

sealed class DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse();
}

@_i1.immutable
class DomainDnsCheckOperationResponse200
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdDnsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse401
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdDnsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse401 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse403
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdDnsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse403 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse404
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdDnsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse404 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse413
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdDnsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse413 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse422
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdDnsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse422 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse500
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdDnsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DomainDnsCheckOperationResponse503
    extends DomainDnsCheckOperationResponse {
  const DomainDnsCheckOperationResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdDnsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DomainDnsCheckOperationResponse503 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
