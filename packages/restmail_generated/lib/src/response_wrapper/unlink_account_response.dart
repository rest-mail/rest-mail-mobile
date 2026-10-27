// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_delete503_response.dart'
    as _i11;

sealed class UnlinkAccountResponse {
  const UnlinkAccountResponse();
}

@_i1.immutable
class UnlinkAccountResponse204 extends UnlinkAccountResponse {
  const UnlinkAccountResponse204({required this.body});

  final _i2.ApiV1AccountsIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse401 extends UnlinkAccountResponse {
  const UnlinkAccountResponse401({required this.body});

  final _i4.ApiV1AccountsIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse403 extends UnlinkAccountResponse {
  const UnlinkAccountResponse403({required this.body});

  final _i5.ApiV1AccountsIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse404 extends UnlinkAccountResponse {
  const UnlinkAccountResponse404({required this.body});

  final _i6.ApiV1AccountsIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse409 extends UnlinkAccountResponse {
  const UnlinkAccountResponse409({required this.body});

  final _i7.ApiV1AccountsIdDelete409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse413 extends UnlinkAccountResponse {
  const UnlinkAccountResponse413({required this.body});

  final _i8.ApiV1AccountsIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse422 extends UnlinkAccountResponse {
  const UnlinkAccountResponse422({required this.body});

  final _i9.ApiV1AccountsIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse500 extends UnlinkAccountResponse {
  const UnlinkAccountResponse500({required this.body});

  final _i10.ApiV1AccountsIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UnlinkAccountResponse503 extends UnlinkAccountResponse {
  const UnlinkAccountResponse503({required this.body});

  final _i11.ApiV1AccountsIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnlinkAccountResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
