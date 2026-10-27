// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_auth_invitation_post503_response.dart'
    as _i10;

sealed class AcceptInvitationResponse {
  const AcceptInvitationResponse();
}

@_i1.immutable
class AcceptInvitationResponse200 extends AcceptInvitationResponse {
  const AcceptInvitationResponse200({required this.body});

  final _i2.ApiV1AuthInvitationPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse400 extends AcceptInvitationResponse {
  const AcceptInvitationResponse400({required this.body});

  final _i4.ApiV1AuthInvitationPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse401 extends AcceptInvitationResponse {
  const AcceptInvitationResponse401({required this.body});

  final _i5.ApiV1AuthInvitationPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse413 extends AcceptInvitationResponse {
  const AcceptInvitationResponse413({required this.body});

  final _i6.ApiV1AuthInvitationPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse422 extends AcceptInvitationResponse {
  const AcceptInvitationResponse422({required this.body});

  final _i7.ApiV1AuthInvitationPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse429 extends AcceptInvitationResponse {
  const AcceptInvitationResponse429({required this.body});

  final _i8.ApiV1AuthInvitationPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse500 extends AcceptInvitationResponse {
  const AcceptInvitationResponse500({required this.body});

  final _i9.ApiV1AuthInvitationPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AcceptInvitationResponse503 extends AcceptInvitationResponse {
  const AcceptInvitationResponse503({required this.body});

  final _i10.ApiV1AuthInvitationPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AcceptInvitationResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
