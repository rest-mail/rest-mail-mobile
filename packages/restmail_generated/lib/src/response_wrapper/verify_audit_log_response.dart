// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_audit_verify_get503_response.dart'
    as _i9;

sealed class VerifyAuditLogResponse {
  const VerifyAuditLogResponse();
}

@_i1.immutable
class VerifyAuditLogResponse200 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse200({required this.body});

  final _i2.ApiV1AdminAuditVerifyGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse401 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse401({required this.body});

  final _i4.ApiV1AdminAuditVerifyGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse403 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse403({required this.body});

  final _i5.ApiV1AdminAuditVerifyGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse413 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse413({required this.body});

  final _i6.ApiV1AdminAuditVerifyGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse422 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse422({required this.body});

  final _i7.ApiV1AdminAuditVerifyGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse500 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse500({required this.body});

  final _i8.ApiV1AdminAuditVerifyGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class VerifyAuditLogResponse503 extends VerifyAuditLogResponse {
  const VerifyAuditLogResponse503({required this.body});

  final _i9.ApiV1AdminAuditVerifyGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VerifyAuditLogResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
