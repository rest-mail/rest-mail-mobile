// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get422_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_events_get503_response.dart'
    as _i8;

sealed class AccountEventsResponse {
  const AccountEventsResponse();
}

@_i1.immutable
class AccountEventsResponse200 extends AccountEventsResponse {
  const AccountEventsResponse200({required this.body});

  final _i2.ApiV1AccountsIdEventsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AccountEventsResponse401 extends AccountEventsResponse {
  const AccountEventsResponse401({required this.body});

  final _i4.ApiV1AccountsIdEventsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AccountEventsResponse403 extends AccountEventsResponse {
  const AccountEventsResponse403({required this.body});

  final _i5.ApiV1AccountsIdEventsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AccountEventsResponse422 extends AccountEventsResponse {
  const AccountEventsResponse422({required this.body});

  final _i6.ApiV1AccountsIdEventsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AccountEventsResponse500 extends AccountEventsResponse {
  const AccountEventsResponse500({required this.body});

  final _i7.ApiV1AccountsIdEventsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AccountEventsResponse503 extends AccountEventsResponse {
  const AccountEventsResponse503({required this.body});

  final _i8.ApiV1AccountsIdEventsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountEventsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
