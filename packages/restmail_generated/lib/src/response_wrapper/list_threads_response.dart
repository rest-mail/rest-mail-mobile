// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_threads_get503_response.dart'
    as _i11;

sealed class ListThreadsResponse {
  const ListThreadsResponse();
}

@_i1.immutable
class ListThreadsResponse200 extends ListThreadsResponse {
  const ListThreadsResponse200({required this.body});

  final _i2.ApiV1AccountsIdThreadsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse401 extends ListThreadsResponse {
  const ListThreadsResponse401({required this.body});

  final _i4.ApiV1AccountsIdThreadsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse403 extends ListThreadsResponse {
  const ListThreadsResponse403({required this.body});

  final _i5.ApiV1AccountsIdThreadsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse404 extends ListThreadsResponse {
  const ListThreadsResponse404({required this.body});

  final _i6.ApiV1AccountsIdThreadsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse413 extends ListThreadsResponse {
  const ListThreadsResponse413({required this.body});

  final _i7.ApiV1AccountsIdThreadsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse422 extends ListThreadsResponse {
  const ListThreadsResponse422({required this.body});

  final _i8.ApiV1AccountsIdThreadsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse429 extends ListThreadsResponse {
  const ListThreadsResponse429({required this.body});

  final _i9.ApiV1AccountsIdThreadsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse500 extends ListThreadsResponse {
  const ListThreadsResponse500({required this.body});

  final _i10.ApiV1AccountsIdThreadsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListThreadsResponse503 extends ListThreadsResponse {
  const ListThreadsResponse503({required this.body});

  final _i11.ApiV1AccountsIdThreadsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListThreadsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
