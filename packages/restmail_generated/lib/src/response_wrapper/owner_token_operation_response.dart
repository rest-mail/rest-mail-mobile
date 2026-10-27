// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post429_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_auth_owner_token_post500_response.dart'
    as _i12;

sealed class OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse();
}

@_i1.immutable
class OwnerTokenOperationResponse200 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse200({required this.body});

  final _i2.ApiV1AuthOwnerTokenPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse400 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse400({required this.body});

  final _i4.ApiV1AuthOwnerTokenPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse401 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse401({required this.body});

  final _i5.ApiV1AuthOwnerTokenPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse403 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse403({required this.body});

  final _i6.ApiV1AuthOwnerTokenPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse404 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse404({required this.body});

  final _i7.ApiV1AuthOwnerTokenPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse409 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse409({required this.body});

  final _i8.ApiV1AuthOwnerTokenPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse413 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse413({required this.body});

  final _i9.ApiV1AuthOwnerTokenPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse422 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse422({required this.body});

  final _i10.ApiV1AuthOwnerTokenPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse429 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse429({required this.body});

  final _i11.ApiV1AuthOwnerTokenPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerTokenOperationResponse500 extends OwnerTokenOperationResponse {
  const OwnerTokenOperationResponse500({required this.body});

  final _i12.ApiV1AuthOwnerTokenPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenOperationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
