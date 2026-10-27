// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_get503_response.dart'
    as _i10;

sealed class ListFoldersResponse {
  const ListFoldersResponse();
}

@_i1.immutable
class ListFoldersResponse200 extends ListFoldersResponse {
  const ListFoldersResponse200({required this.body});

  final _i2.ApiV1AccountsIdFoldersGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse401 extends ListFoldersResponse {
  const ListFoldersResponse401({required this.body});

  final _i4.ApiV1AccountsIdFoldersGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse403 extends ListFoldersResponse {
  const ListFoldersResponse403({required this.body});

  final _i5.ApiV1AccountsIdFoldersGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse413 extends ListFoldersResponse {
  const ListFoldersResponse413({required this.body});

  final _i6.ApiV1AccountsIdFoldersGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse422 extends ListFoldersResponse {
  const ListFoldersResponse422({required this.body});

  final _i7.ApiV1AccountsIdFoldersGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse429 extends ListFoldersResponse {
  const ListFoldersResponse429({required this.body});

  final _i8.ApiV1AccountsIdFoldersGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse500 extends ListFoldersResponse {
  const ListFoldersResponse500({required this.body});

  final _i9.ApiV1AccountsIdFoldersGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListFoldersResponse503 extends ListFoldersResponse {
  const ListFoldersResponse503({required this.body});

  final _i10.ApiV1AccountsIdFoldersGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFoldersResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
