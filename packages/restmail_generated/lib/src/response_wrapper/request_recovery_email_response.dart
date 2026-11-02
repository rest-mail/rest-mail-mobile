// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post413_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post422_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post429_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_recover_email_post503_response.dart'
    as _i9;

sealed class RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse();
}

@_i1.immutable
class RequestRecoveryEmailResponse200 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse200({required this.body});

  final _i2.ApiV1AuthRecoverEmailPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse400 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse400({required this.body});

  final _i4.ApiV1AuthRecoverEmailPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse413 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse413({required this.body});

  final _i5.ApiV1AuthRecoverEmailPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse422 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse422({required this.body});

  final _i6.ApiV1AuthRecoverEmailPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse429 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse429({required this.body});

  final _i7.ApiV1AuthRecoverEmailPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse500 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse500({required this.body});

  final _i8.ApiV1AuthRecoverEmailPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RequestRecoveryEmailResponse503 extends RequestRecoveryEmailResponse {
  const RequestRecoveryEmailResponse503({required this.body});

  final _i9.ApiV1AuthRecoverEmailPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestRecoveryEmailResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
