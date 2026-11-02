// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contact_reply_time_get503_response.dart'
    as _i11;

sealed class GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse();
}

@_i1.immutable
class GetContactReplyTimeSettingResponse200
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactReplyTimeGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse401
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse401({required this.body});

  final _i4.ApiV1AccountsIdContactReplyTimeGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse401 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse403
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse403({required this.body});

  final _i5.ApiV1AccountsIdContactReplyTimeGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse403 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse404
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse404({required this.body});

  final _i6.ApiV1AccountsIdContactReplyTimeGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse404 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse413
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse413({required this.body});

  final _i7.ApiV1AccountsIdContactReplyTimeGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse413 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse422
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse422({required this.body});

  final _i8.ApiV1AccountsIdContactReplyTimeGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse422 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse429
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse429({required this.body});

  final _i9.ApiV1AccountsIdContactReplyTimeGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse429 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse500
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse500({required this.body});

  final _i10.ApiV1AccountsIdContactReplyTimeGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse500 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetContactReplyTimeSettingResponse503
    extends GetContactReplyTimeSettingResponse {
  const GetContactReplyTimeSettingResponse503({required this.body});

  final _i11.ApiV1AccountsIdContactReplyTimeGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetContactReplyTimeSettingResponse503 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
