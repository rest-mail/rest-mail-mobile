// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_get503_response.dart'
    as _i9;

sealed class ListDomainsResponse {
  const ListDomainsResponse();
}

@_i1.immutable
class ListDomainsResponse200 extends ListDomainsResponse {
  const ListDomainsResponse200({required this.body});

  final _i2.ApiV1AdminDomainsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse401 extends ListDomainsResponse {
  const ListDomainsResponse401({required this.body});

  final _i4.ApiV1AdminDomainsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse403 extends ListDomainsResponse {
  const ListDomainsResponse403({required this.body});

  final _i5.ApiV1AdminDomainsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse413 extends ListDomainsResponse {
  const ListDomainsResponse413({required this.body});

  final _i6.ApiV1AdminDomainsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse422 extends ListDomainsResponse {
  const ListDomainsResponse422({required this.body});

  final _i7.ApiV1AdminDomainsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse500 extends ListDomainsResponse {
  const ListDomainsResponse500({required this.body});

  final _i8.ApiV1AdminDomainsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDomainsResponse503 extends ListDomainsResponse {
  const ListDomainsResponse503({required this.body});

  final _i9.ApiV1AdminDomainsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDomainsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
