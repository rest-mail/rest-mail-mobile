// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dkim_get503_response.dart'
    as _i8;

sealed class ListDkimKeysResponse {
  const ListDkimKeysResponse();
}

@_i1.immutable
class ListDkimKeysResponse200 extends ListDkimKeysResponse {
  const ListDkimKeysResponse200({required this.body});

  final _i2.ApiV1AdminDkimGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDkimKeysResponse401 extends ListDkimKeysResponse {
  const ListDkimKeysResponse401({required this.body});

  final _i4.ApiV1AdminDkimGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDkimKeysResponse403 extends ListDkimKeysResponse {
  const ListDkimKeysResponse403({required this.body});

  final _i5.ApiV1AdminDkimGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDkimKeysResponse413 extends ListDkimKeysResponse {
  const ListDkimKeysResponse413({required this.body});

  final _i6.ApiV1AdminDkimGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDkimKeysResponse500 extends ListDkimKeysResponse {
  const ListDkimKeysResponse500({required this.body});

  final _i7.ApiV1AdminDkimGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDkimKeysResponse503 extends ListDkimKeysResponse {
  const ListDkimKeysResponse503({required this.body});

  final _i8.ApiV1AdminDkimGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDkimKeysResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
