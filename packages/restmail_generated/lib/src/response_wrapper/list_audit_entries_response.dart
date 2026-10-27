// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_audit_get503_response.dart'
    as _i9;

sealed class ListAuditEntriesResponse {
  const ListAuditEntriesResponse();
}

@_i1.immutable
class ListAuditEntriesResponse200 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse200({required this.body});

  final _i2.ApiV1AdminAuditGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse401 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse401({required this.body});

  final _i4.ApiV1AdminAuditGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse403 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse403({required this.body});

  final _i5.ApiV1AdminAuditGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse413 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse413({required this.body});

  final _i6.ApiV1AdminAuditGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse422 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse422({required this.body});

  final _i7.ApiV1AdminAuditGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse500 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse500({required this.body});

  final _i8.ApiV1AdminAuditGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListAuditEntriesResponse503 extends ListAuditEntriesResponse {
  const ListAuditEntriesResponse503({required this.body});

  final _i9.ApiV1AdminAuditGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListAuditEntriesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
