// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_invitation_post503_response.dart'
    as _i11;

sealed class InviteAccountResponse {
  const InviteAccountResponse();
}

@_i1.immutable
class InviteAccountResponse201 extends InviteAccountResponse {
  const InviteAccountResponse201({required this.body});

  final _i2.ApiV1AdminMailboxesIdInvitationPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse401 extends InviteAccountResponse {
  const InviteAccountResponse401({required this.body});

  final _i4.ApiV1AdminMailboxesIdInvitationPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse403 extends InviteAccountResponse {
  const InviteAccountResponse403({required this.body});

  final _i5.ApiV1AdminMailboxesIdInvitationPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse404 extends InviteAccountResponse {
  const InviteAccountResponse404({required this.body});

  final _i6.ApiV1AdminMailboxesIdInvitationPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse409 extends InviteAccountResponse {
  const InviteAccountResponse409({required this.body});

  final _i7.ApiV1AdminMailboxesIdInvitationPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse413 extends InviteAccountResponse {
  const InviteAccountResponse413({required this.body});

  final _i8.ApiV1AdminMailboxesIdInvitationPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse422 extends InviteAccountResponse {
  const InviteAccountResponse422({required this.body});

  final _i9.ApiV1AdminMailboxesIdInvitationPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse500 extends InviteAccountResponse {
  const InviteAccountResponse500({required this.body});

  final _i10.ApiV1AdminMailboxesIdInvitationPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class InviteAccountResponse503 extends InviteAccountResponse {
  const InviteAccountResponse503({required this.body});

  final _i11.ApiV1AdminMailboxesIdInvitationPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InviteAccountResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
