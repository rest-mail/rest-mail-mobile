// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_held_messages_get503_response.dart'
    as _i10;

sealed class ListHeldMessagesResponse {
  const ListHeldMessagesResponse();
}

@_i1.immutable
class ListHeldMessagesResponse200 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse200({required this.body});

  final _i2.ApiV1AccountsIdHeldMessagesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse401 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse401({required this.body});

  final _i4.ApiV1AccountsIdHeldMessagesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse403 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse403({required this.body});

  final _i5.ApiV1AccountsIdHeldMessagesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse404 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse404({required this.body});

  final _i6.ApiV1AccountsIdHeldMessagesGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse413 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse413({required this.body});

  final _i7.ApiV1AccountsIdHeldMessagesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse422 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse422({required this.body});

  final _i8.ApiV1AccountsIdHeldMessagesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse500 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse500({required this.body});

  final _i9.ApiV1AccountsIdHeldMessagesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListHeldMessagesResponse503 extends ListHeldMessagesResponse {
  const ListHeldMessagesResponse503({required this.body});

  final _i10.ApiV1AccountsIdHeldMessagesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListHeldMessagesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
