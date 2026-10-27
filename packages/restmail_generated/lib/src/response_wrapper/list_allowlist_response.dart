// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_get503_response.dart'
    as _i9;

sealed class ListAllowlistResponse {
  const ListAllowlistResponse();
}

@_i1.immutable
class ListAllowlistResponse200 extends ListAllowlistResponse {
  const ListAllowlistResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdAllowlistGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse401 extends ListAllowlistResponse {
  const ListAllowlistResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdAllowlistGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse403 extends ListAllowlistResponse {
  const ListAllowlistResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdAllowlistGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse413 extends ListAllowlistResponse {
  const ListAllowlistResponse413({required this.body});

  final _i6.ApiV1AdminDomainsIdAllowlistGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse422 extends ListAllowlistResponse {
  const ListAllowlistResponse422({required this.body});

  final _i7.ApiV1AdminDomainsIdAllowlistGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse500 extends ListAllowlistResponse {
  const ListAllowlistResponse500({required this.body});

  final _i8.ApiV1AdminDomainsIdAllowlistGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAllowlistResponse503 extends ListAllowlistResponse {
  const ListAllowlistResponse503({required this.body});

  final _i9.ApiV1AdminDomainsIdAllowlistGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAllowlistResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
