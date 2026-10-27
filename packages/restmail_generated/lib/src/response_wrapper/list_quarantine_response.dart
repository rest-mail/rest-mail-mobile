// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_get503_response.dart'
    as _i10;

sealed class ListQuarantineResponse {
  const ListQuarantineResponse();
}

@_i1.immutable
class ListQuarantineResponse200 extends ListQuarantineResponse {
  const ListQuarantineResponse200({required this.body});

  final _i2.ApiV1AccountsIdQuarantineGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse401 extends ListQuarantineResponse {
  const ListQuarantineResponse401({required this.body});

  final _i4.ApiV1AccountsIdQuarantineGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse403 extends ListQuarantineResponse {
  const ListQuarantineResponse403({required this.body});

  final _i5.ApiV1AccountsIdQuarantineGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse413 extends ListQuarantineResponse {
  const ListQuarantineResponse413({required this.body});

  final _i6.ApiV1AccountsIdQuarantineGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse422 extends ListQuarantineResponse {
  const ListQuarantineResponse422({required this.body});

  final _i7.ApiV1AccountsIdQuarantineGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse429 extends ListQuarantineResponse {
  const ListQuarantineResponse429({required this.body});

  final _i8.ApiV1AccountsIdQuarantineGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse500 extends ListQuarantineResponse {
  const ListQuarantineResponse500({required this.body});

  final _i9.ApiV1AccountsIdQuarantineGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListQuarantineResponse503 extends ListQuarantineResponse {
  const ListQuarantineResponse503({required this.body});

  final _i10.ApiV1AccountsIdQuarantineGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListQuarantineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
