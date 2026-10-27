// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_thread_id_get503_response.dart'
    as _i10;

sealed class GetThreadResponse {
  const GetThreadResponse();
}

@_i1.immutable
class GetThreadResponse200 extends GetThreadResponse {
  const GetThreadResponse200({required this.body});

  final _i2.ApiV1AccountsIdThreadsThreadIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse401 extends GetThreadResponse {
  const GetThreadResponse401({required this.body});

  final _i4.ApiV1AccountsIdThreadsThreadIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse403 extends GetThreadResponse {
  const GetThreadResponse403({required this.body});

  final _i5.ApiV1AccountsIdThreadsThreadIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse413 extends GetThreadResponse {
  const GetThreadResponse413({required this.body});

  final _i6.ApiV1AccountsIdThreadsThreadIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse422 extends GetThreadResponse {
  const GetThreadResponse422({required this.body});

  final _i7.ApiV1AccountsIdThreadsThreadIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse429 extends GetThreadResponse {
  const GetThreadResponse429({required this.body});

  final _i8.ApiV1AccountsIdThreadsThreadIdGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse500 extends GetThreadResponse {
  const GetThreadResponse500({required this.body});

  final _i9.ApiV1AccountsIdThreadsThreadIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetThreadResponse503 extends GetThreadResponse {
  const GetThreadResponse503({required this.body});

  final _i10.ApiV1AccountsIdThreadsThreadIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetThreadResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
