// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_auth2fa_confirm_post503_response.dart'
    as _i12;

sealed class ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse();
}

@_i1.immutable
class ConfirmTwoFactorResponse204 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse204({required this.body});

  final _i2.ApiV1Auth2faConfirmPost204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse400 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse400({required this.body});

  final _i4.ApiV1Auth2faConfirmPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse401 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse401({required this.body});

  final _i5.ApiV1Auth2faConfirmPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse403 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse403({required this.body});

  final _i6.ApiV1Auth2faConfirmPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse409 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse409({required this.body});

  final _i7.ApiV1Auth2faConfirmPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse413 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse413({required this.body});

  final _i8.ApiV1Auth2faConfirmPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse422 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse422({required this.body});

  final _i9.ApiV1Auth2faConfirmPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse429 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse429({required this.body});

  final _i10.ApiV1Auth2faConfirmPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse500 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse500({required this.body});

  final _i11.ApiV1Auth2faConfirmPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ConfirmTwoFactorResponse503 extends ConfirmTwoFactorResponse {
  const ConfirmTwoFactorResponse503({required this.body});

  final _i12.ApiV1Auth2faConfirmPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ConfirmTwoFactorResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
