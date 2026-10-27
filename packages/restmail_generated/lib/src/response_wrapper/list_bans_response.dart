// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_bans_get503_response.dart'
    as _i9;

sealed class ListBansResponse {
  const ListBansResponse();
}

@_i1.immutable
class ListBansResponse200 extends ListBansResponse {
  const ListBansResponse200({required this.body});

  final _i2.ApiV1AdminBansGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse401 extends ListBansResponse {
  const ListBansResponse401({required this.body});

  final _i4.ApiV1AdminBansGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse403 extends ListBansResponse {
  const ListBansResponse403({required this.body});

  final _i5.ApiV1AdminBansGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse413 extends ListBansResponse {
  const ListBansResponse413({required this.body});

  final _i6.ApiV1AdminBansGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse422 extends ListBansResponse {
  const ListBansResponse422({required this.body});

  final _i7.ApiV1AdminBansGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse500 extends ListBansResponse {
  const ListBansResponse500({required this.body});

  final _i8.ApiV1AdminBansGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListBansResponse503 extends ListBansResponse {
  const ListBansResponse503({required this.body});

  final _i9.ApiV1AdminBansGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListBansResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
