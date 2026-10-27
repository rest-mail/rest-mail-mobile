// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_get503_response.dart'
    as _i10;

sealed class GetMailboxResponse {
  const GetMailboxResponse();
}

@_i1.immutable
class GetMailboxResponse200 extends GetMailboxResponse {
  const GetMailboxResponse200({required this.body});

  final _i2.ApiV1AdminMailboxesIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse401 extends GetMailboxResponse {
  const GetMailboxResponse401({required this.body});

  final _i4.ApiV1AdminMailboxesIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse403 extends GetMailboxResponse {
  const GetMailboxResponse403({required this.body});

  final _i5.ApiV1AdminMailboxesIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse404 extends GetMailboxResponse {
  const GetMailboxResponse404({required this.body});

  final _i6.ApiV1AdminMailboxesIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse413 extends GetMailboxResponse {
  const GetMailboxResponse413({required this.body});

  final _i7.ApiV1AdminMailboxesIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse422 extends GetMailboxResponse {
  const GetMailboxResponse422({required this.body});

  final _i8.ApiV1AdminMailboxesIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse500 extends GetMailboxResponse {
  const GetMailboxResponse500({required this.body});

  final _i9.ApiV1AdminMailboxesIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetMailboxResponse503 extends GetMailboxResponse {
  const GetMailboxResponse503({required this.body});

  final _i10.ApiV1AdminMailboxesIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetMailboxResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
