// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_mailboxes_id_sessions_delete503_response.dart'
    as _i11;

sealed class EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse();
}

@_i1.immutable
class EndMailboxSessionsResponse204 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse204({required this.body});

  final _i2.ApiV1AdminMailboxesIdSessionsDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse401 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse401({required this.body});

  final _i4.ApiV1AdminMailboxesIdSessionsDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse403 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse403({required this.body});

  final _i5.ApiV1AdminMailboxesIdSessionsDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse404 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse404({required this.body});

  final _i6.ApiV1AdminMailboxesIdSessionsDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse413 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse413({required this.body});

  final _i7.ApiV1AdminMailboxesIdSessionsDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse422 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse422({required this.body});

  final _i8.ApiV1AdminMailboxesIdSessionsDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse429 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse429({required this.body});

  final _i9.ApiV1AdminMailboxesIdSessionsDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse500 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse500({required this.body});

  final _i10.ApiV1AdminMailboxesIdSessionsDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class EndMailboxSessionsResponse503 extends EndMailboxSessionsResponse {
  const EndMailboxSessionsResponse503({required this.body});

  final _i11.ApiV1AdminMailboxesIdSessionsDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EndMailboxSessionsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
