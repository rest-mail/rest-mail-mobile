// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_recover_post500_response.dart'
    as _i9;

sealed class RecoverAccountResponse {
  const RecoverAccountResponse();
}

@_i1.immutable
class RecoverAccountResponse200 extends RecoverAccountResponse {
  const RecoverAccountResponse200({required this.body});

  final _i2.ApiV1AuthRecoverPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse400 extends RecoverAccountResponse {
  const RecoverAccountResponse400({required this.body});

  final _i4.ApiV1AuthRecoverPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse401 extends RecoverAccountResponse {
  const RecoverAccountResponse401({required this.body});

  final _i5.ApiV1AuthRecoverPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse413 extends RecoverAccountResponse {
  const RecoverAccountResponse413({required this.body});

  final _i6.ApiV1AuthRecoverPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse422 extends RecoverAccountResponse {
  const RecoverAccountResponse422({required this.body});

  final _i7.ApiV1AuthRecoverPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse429 extends RecoverAccountResponse {
  const RecoverAccountResponse429({required this.body});

  final _i8.ApiV1AuthRecoverPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RecoverAccountResponse500 extends RecoverAccountResponse {
  const RecoverAccountResponse500({required this.body});

  final _i9.ApiV1AuthRecoverPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
