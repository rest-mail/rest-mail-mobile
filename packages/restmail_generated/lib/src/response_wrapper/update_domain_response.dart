// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch429_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch500_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_patch503_response.dart'
    as _i13;

sealed class UpdateDomainResponse {
  const UpdateDomainResponse();
}

@_i1.immutable
class UpdateDomainResponse200 extends UpdateDomainResponse {
  const UpdateDomainResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse400 extends UpdateDomainResponse {
  const UpdateDomainResponse400({required this.body});

  final _i4.ApiV1AdminDomainsIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse401 extends UpdateDomainResponse {
  const UpdateDomainResponse401({required this.body});

  final _i5.ApiV1AdminDomainsIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse403 extends UpdateDomainResponse {
  const UpdateDomainResponse403({required this.body});

  final _i6.ApiV1AdminDomainsIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse404 extends UpdateDomainResponse {
  const UpdateDomainResponse404({required this.body});

  final _i7.ApiV1AdminDomainsIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse409 extends UpdateDomainResponse {
  const UpdateDomainResponse409({required this.body});

  final _i8.ApiV1AdminDomainsIdPatch409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse413 extends UpdateDomainResponse {
  const UpdateDomainResponse413({required this.body});

  final _i9.ApiV1AdminDomainsIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse422 extends UpdateDomainResponse {
  const UpdateDomainResponse422({required this.body});

  final _i10.ApiV1AdminDomainsIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse429 extends UpdateDomainResponse {
  const UpdateDomainResponse429({required this.body});

  final _i11.ApiV1AdminDomainsIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse500 extends UpdateDomainResponse {
  const UpdateDomainResponse500({required this.body});

  final _i12.ApiV1AdminDomainsIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateDomainResponse503 extends UpdateDomainResponse {
  const UpdateDomainResponse503({required this.body});

  final _i13.ApiV1AdminDomainsIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
