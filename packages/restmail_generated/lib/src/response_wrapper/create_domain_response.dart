// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_post503_response.dart'
    as _i12;

sealed class CreateDomainResponse {
  const CreateDomainResponse();
}

@_i1.immutable
class CreateDomainResponse201 extends CreateDomainResponse {
  const CreateDomainResponse201({required this.body});

  final _i2.ApiV1AdminDomainsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse400 extends CreateDomainResponse {
  const CreateDomainResponse400({required this.body});

  final _i4.ApiV1AdminDomainsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse401 extends CreateDomainResponse {
  const CreateDomainResponse401({required this.body});

  final _i5.ApiV1AdminDomainsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse403 extends CreateDomainResponse {
  const CreateDomainResponse403({required this.body});

  final _i6.ApiV1AdminDomainsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse409 extends CreateDomainResponse {
  const CreateDomainResponse409({required this.body});

  final _i7.ApiV1AdminDomainsPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse413 extends CreateDomainResponse {
  const CreateDomainResponse413({required this.body});

  final _i8.ApiV1AdminDomainsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse422 extends CreateDomainResponse {
  const CreateDomainResponse422({required this.body});

  final _i9.ApiV1AdminDomainsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse429 extends CreateDomainResponse {
  const CreateDomainResponse429({required this.body});

  final _i10.ApiV1AdminDomainsPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse500 extends CreateDomainResponse {
  const CreateDomainResponse500({required this.body});

  final _i11.ApiV1AdminDomainsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateDomainResponse503 extends CreateDomainResponse {
  const CreateDomainResponse503({required this.body});

  final _i12.ApiV1AdminDomainsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
