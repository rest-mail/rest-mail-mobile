// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_get503_response.dart'
    as _i10;

sealed class ListApiKeysResponse {
  const ListApiKeysResponse();
}

@_i1.immutable
class ListApiKeysResponse200 extends ListApiKeysResponse {
  const ListApiKeysResponse200({required this.body});

  final _i2.ApiV1AccountsIdApiKeysGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse401 extends ListApiKeysResponse {
  const ListApiKeysResponse401({required this.body});

  final _i4.ApiV1AccountsIdApiKeysGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse403 extends ListApiKeysResponse {
  const ListApiKeysResponse403({required this.body});

  final _i5.ApiV1AccountsIdApiKeysGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse404 extends ListApiKeysResponse {
  const ListApiKeysResponse404({required this.body});

  final _i6.ApiV1AccountsIdApiKeysGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse413 extends ListApiKeysResponse {
  const ListApiKeysResponse413({required this.body});

  final _i7.ApiV1AccountsIdApiKeysGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse422 extends ListApiKeysResponse {
  const ListApiKeysResponse422({required this.body});

  final _i8.ApiV1AccountsIdApiKeysGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse500 extends ListApiKeysResponse {
  const ListApiKeysResponse500({required this.body});

  final _i9.ApiV1AccountsIdApiKeysGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListApiKeysResponse503 extends ListApiKeysResponse {
  const ListApiKeysResponse503({required this.body});

  final _i10.ApiV1AccountsIdApiKeysGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListApiKeysResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
