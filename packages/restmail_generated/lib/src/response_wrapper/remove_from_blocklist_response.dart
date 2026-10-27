// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_eid_delete503_response.dart'
    as _i10;

sealed class RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse();
}

@_i1.immutable
class RemoveFromBlocklistResponse204 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse204({required this.body});

  final _i2.ApiV1AdminDomainsIdBlocklistEidDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse401 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdBlocklistEidDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse403 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdBlocklistEidDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse404 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdBlocklistEidDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse413 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdBlocklistEidDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse422 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdBlocklistEidDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse500 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdBlocklistEidDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RemoveFromBlocklistResponse503 extends RemoveFromBlocklistResponse {
  const RemoveFromBlocklistResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdBlocklistEidDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFromBlocklistResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
