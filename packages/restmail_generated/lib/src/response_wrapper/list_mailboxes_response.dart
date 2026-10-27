// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_get503_response.dart'
    as _i9;

sealed class ListMailboxesResponse {
  const ListMailboxesResponse();
}

@_i1.immutable
class ListMailboxesResponse200 extends ListMailboxesResponse {
  const ListMailboxesResponse200({required this.body});

  final _i2.ApiV1AdminMailboxesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse401 extends ListMailboxesResponse {
  const ListMailboxesResponse401({required this.body});

  final _i4.ApiV1AdminMailboxesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse403 extends ListMailboxesResponse {
  const ListMailboxesResponse403({required this.body});

  final _i5.ApiV1AdminMailboxesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse413 extends ListMailboxesResponse {
  const ListMailboxesResponse413({required this.body});

  final _i6.ApiV1AdminMailboxesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse422 extends ListMailboxesResponse {
  const ListMailboxesResponse422({required this.body});

  final _i7.ApiV1AdminMailboxesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse500 extends ListMailboxesResponse {
  const ListMailboxesResponse500({required this.body});

  final _i8.ApiV1AdminMailboxesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMailboxesResponse503 extends ListMailboxesResponse {
  const ListMailboxesResponse503({required this.body});

  final _i9.ApiV1AdminMailboxesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMailboxesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
