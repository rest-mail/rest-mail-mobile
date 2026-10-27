// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_owner_challenge_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_owner_challenge_post409_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_owner_challenge_post429_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_owner_challenge_post500_response.dart'
    as _i6;

sealed class OwnerChallengeOperationResponse {
  const OwnerChallengeOperationResponse();
}

@_i1.immutable
class OwnerChallengeOperationResponse200
    extends OwnerChallengeOperationResponse {
  const OwnerChallengeOperationResponse200({required this.body});

  final _i2.ApiV1AuthOwnerChallengePost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerChallengeOperationResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerChallengeOperationResponse409
    extends OwnerChallengeOperationResponse {
  const OwnerChallengeOperationResponse409({required this.body});

  final _i4.ApiV1AuthOwnerChallengePost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerChallengeOperationResponse409 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerChallengeOperationResponse429
    extends OwnerChallengeOperationResponse {
  const OwnerChallengeOperationResponse429({required this.body});

  final _i5.ApiV1AuthOwnerChallengePost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerChallengeOperationResponse429 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class OwnerChallengeOperationResponse500
    extends OwnerChallengeOperationResponse {
  const OwnerChallengeOperationResponse500({required this.body});

  final _i6.ApiV1AuthOwnerChallengePost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerChallengeOperationResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
