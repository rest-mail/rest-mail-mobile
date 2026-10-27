// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_delete503_response.dart'
    as _i12;

sealed class DeleteDomainResponse {
  const DeleteDomainResponse();
}

@_i1.immutable
class DeleteDomainResponse204 extends DeleteDomainResponse {
  const DeleteDomainResponse204({required this.body});

  final _i2.ApiV1AdminDomainsIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse401 extends DeleteDomainResponse {
  const DeleteDomainResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse403 extends DeleteDomainResponse {
  const DeleteDomainResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse404 extends DeleteDomainResponse {
  const DeleteDomainResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse409 extends DeleteDomainResponse {
  const DeleteDomainResponse409({required this.body});

  final _i7.ApiV1AdminDomainsIdDelete409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse413 extends DeleteDomainResponse {
  const DeleteDomainResponse413({required this.body});

  final _i8.ApiV1AdminDomainsIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse422 extends DeleteDomainResponse {
  const DeleteDomainResponse422({required this.body});

  final _i9.ApiV1AdminDomainsIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse429 extends DeleteDomainResponse {
  const DeleteDomainResponse429({required this.body});

  final _i10.ApiV1AdminDomainsIdDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse500 extends DeleteDomainResponse {
  const DeleteDomainResponse500({required this.body});

  final _i11.ApiV1AdminDomainsIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteDomainResponse503 extends DeleteDomainResponse {
  const DeleteDomainResponse503({required this.body});

  final _i12.ApiV1AdminDomainsIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteDomainResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
