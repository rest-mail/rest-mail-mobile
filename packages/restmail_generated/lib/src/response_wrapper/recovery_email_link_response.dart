// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_link_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_link_get413_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recovery_email_link_get500_response.dart'
    as _i5;

sealed class RecoveryEmailLinkResponse {
  const RecoveryEmailLinkResponse();
}

@_i1.immutable
class RecoveryEmailLinkResponse200 extends RecoveryEmailLinkResponse {
  const RecoveryEmailLinkResponse200({required this.body});

  final _i2.ApiV1AuthRecoveryEmailLinkGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoveryEmailLinkResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoveryEmailLinkResponse413 extends RecoveryEmailLinkResponse {
  const RecoveryEmailLinkResponse413({required this.body});

  final _i4.ApiV1AuthRecoveryEmailLinkGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoveryEmailLinkResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoveryEmailLinkResponse500 extends RecoveryEmailLinkResponse {
  const RecoveryEmailLinkResponse500({required this.body});

  final _i5.ApiV1AuthRecoveryEmailLinkGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoveryEmailLinkResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
