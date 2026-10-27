// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_quarantine_mid_delete503_response.dart'
    as _i11;

sealed class DeleteQuarantineResponse {
  const DeleteQuarantineResponse();
}

@_i1.immutable
class DeleteQuarantineResponse200 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse200({required this.body});

  final _i2.ApiV1AccountsIdQuarantineMidDelete200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse401 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse401({required this.body});

  final _i4.ApiV1AccountsIdQuarantineMidDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse403 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse403({required this.body});

  final _i5.ApiV1AccountsIdQuarantineMidDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse404 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse404({required this.body});

  final _i6.ApiV1AccountsIdQuarantineMidDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse413 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse413({required this.body});

  final _i7.ApiV1AccountsIdQuarantineMidDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse422 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse422({required this.body});

  final _i8.ApiV1AccountsIdQuarantineMidDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse429 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse429({required this.body});

  final _i9.ApiV1AccountsIdQuarantineMidDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse500 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse500({required this.body});

  final _i10.ApiV1AccountsIdQuarantineMidDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteQuarantineResponse503 extends DeleteQuarantineResponse {
  const DeleteQuarantineResponse503({required this.body});

  final _i11.ApiV1AccountsIdQuarantineMidDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteQuarantineResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
