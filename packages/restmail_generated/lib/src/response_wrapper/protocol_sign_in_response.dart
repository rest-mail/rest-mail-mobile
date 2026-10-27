// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth_protocol_sign_in_post503_response.dart'
    as _i11;

sealed class ProtocolSignInResponse {
  const ProtocolSignInResponse();
}

@_i1.immutable
class ProtocolSignInResponse200 extends ProtocolSignInResponse {
  const ProtocolSignInResponse200({required this.body});

  final _i2.ApiV1AuthProtocolSignInPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse400 extends ProtocolSignInResponse {
  const ProtocolSignInResponse400({required this.body});

  final _i4.ApiV1AuthProtocolSignInPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse401 extends ProtocolSignInResponse {
  const ProtocolSignInResponse401({required this.body});

  final _i5.ApiV1AuthProtocolSignInPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse403 extends ProtocolSignInResponse {
  const ProtocolSignInResponse403({required this.body});

  final _i6.ApiV1AuthProtocolSignInPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse413 extends ProtocolSignInResponse {
  const ProtocolSignInResponse413({required this.body});

  final _i7.ApiV1AuthProtocolSignInPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse422 extends ProtocolSignInResponse {
  const ProtocolSignInResponse422({required this.body});

  final _i8.ApiV1AuthProtocolSignInPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse429 extends ProtocolSignInResponse {
  const ProtocolSignInResponse429({required this.body});

  final _i9.ApiV1AuthProtocolSignInPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse500 extends ProtocolSignInResponse {
  const ProtocolSignInResponse500({required this.body});

  final _i10.ApiV1AuthProtocolSignInPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ProtocolSignInResponse503 extends ProtocolSignInResponse {
  const ProtocolSignInResponse503({required this.body});

  final _i11.ApiV1AuthProtocolSignInPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ProtocolSignInResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
