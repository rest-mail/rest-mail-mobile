// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_allowlist_eid_delete503_response.dart'
    as _i10;

sealed class RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse();
}

@_i1.immutable
class RemoveFromAllowlistResponse204 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse204({required this.body});

  final _i2.ApiV1AdminDomainsIdAllowlistEidDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse401 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdAllowlistEidDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse403 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdAllowlistEidDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse404 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdAllowlistEidDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse413 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdAllowlistEidDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse422 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdAllowlistEidDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse500 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdAllowlistEidDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromAllowlistResponse503 extends RemoveFromAllowlistResponse {
  const RemoveFromAllowlistResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdAllowlistEidDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromAllowlistResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
