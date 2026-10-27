// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_get503_response.dart'
    as _i9;

sealed class ListBlocklistResponse {
  const ListBlocklistResponse();
}

@_i1.immutable
class ListBlocklistResponse200 extends ListBlocklistResponse {
  const ListBlocklistResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdBlocklistGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse401 extends ListBlocklistResponse {
  const ListBlocklistResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdBlocklistGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse403 extends ListBlocklistResponse {
  const ListBlocklistResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdBlocklistGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse413 extends ListBlocklistResponse {
  const ListBlocklistResponse413({required this.body});

  final _i6.ApiV1AdminDomainsIdBlocklistGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse422 extends ListBlocklistResponse {
  const ListBlocklistResponse422({required this.body});

  final _i7.ApiV1AdminDomainsIdBlocklistGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse500 extends ListBlocklistResponse {
  const ListBlocklistResponse500({required this.body});

  final _i8.ApiV1AdminDomainsIdBlocklistGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBlocklistResponse503 extends ListBlocklistResponse {
  const ListBlocklistResponse503({required this.body});

  final _i9.ApiV1AdminDomainsIdBlocklistGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBlocklistResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
