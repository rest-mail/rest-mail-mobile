// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/restmail_mailboxes_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/restmail_mailboxes_get422_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/restmail_mailboxes_get500_response.dart'
    as _i5;

sealed class RestmailCheckMailboxResponse {
  const RestmailCheckMailboxResponse();
}

@_i1.immutable
class RestmailCheckMailboxResponse200 extends RestmailCheckMailboxResponse {
  const RestmailCheckMailboxResponse200({required this.body});

  final _i2.RestmailMailboxesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailCheckMailboxResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailCheckMailboxResponse422 extends RestmailCheckMailboxResponse {
  const RestmailCheckMailboxResponse422({required this.body});

  final _i4.RestmailMailboxesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailCheckMailboxResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailCheckMailboxResponse500 extends RestmailCheckMailboxResponse {
  const RestmailCheckMailboxResponse500({required this.body});

  final _i5.RestmailMailboxesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailCheckMailboxResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
