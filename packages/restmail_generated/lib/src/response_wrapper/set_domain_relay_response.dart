// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_relay_put503_response.dart'
    as _i12;

sealed class SetDomainRelayResponse {
  const SetDomainRelayResponse();
}

@_i1.immutable
class SetDomainRelayResponse200 extends SetDomainRelayResponse {
  const SetDomainRelayResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdRelayPut200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse400 extends SetDomainRelayResponse {
  const SetDomainRelayResponse400({required this.body});

  final _i4.ApiV1AdminDomainsIdRelayPut400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse401 extends SetDomainRelayResponse {
  const SetDomainRelayResponse401({required this.body});

  final _i5.ApiV1AdminDomainsIdRelayPut401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse403 extends SetDomainRelayResponse {
  const SetDomainRelayResponse403({required this.body});

  final _i6.ApiV1AdminDomainsIdRelayPut403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse404 extends SetDomainRelayResponse {
  const SetDomainRelayResponse404({required this.body});

  final _i7.ApiV1AdminDomainsIdRelayPut404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse409 extends SetDomainRelayResponse {
  const SetDomainRelayResponse409({required this.body});

  final _i8.ApiV1AdminDomainsIdRelayPut409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse413 extends SetDomainRelayResponse {
  const SetDomainRelayResponse413({required this.body});

  final _i9.ApiV1AdminDomainsIdRelayPut413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse422 extends SetDomainRelayResponse {
  const SetDomainRelayResponse422({required this.body});

  final _i10.ApiV1AdminDomainsIdRelayPut422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse500 extends SetDomainRelayResponse {
  const SetDomainRelayResponse500({required this.body});

  final _i11.ApiV1AdminDomainsIdRelayPut500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SetDomainRelayResponse503 extends SetDomainRelayResponse {
  const SetDomainRelayResponse503({required this.body});

  final _i12.ApiV1AdminDomainsIdRelayPut503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDomainRelayResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
