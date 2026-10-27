// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_post500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_post503_response.dart'
    as _i11;

sealed class CreateAccountResponse {
  const CreateAccountResponse();
}

@_i1.immutable
class CreateAccountResponse201 extends CreateAccountResponse {
  const CreateAccountResponse201({required this.body});

  final _i2.ApiV1AccountsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse400 extends CreateAccountResponse {
  const CreateAccountResponse400({required this.body});

  final _i4.ApiV1AccountsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse401 extends CreateAccountResponse {
  const CreateAccountResponse401({required this.body});

  final _i5.ApiV1AccountsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse403 extends CreateAccountResponse {
  const CreateAccountResponse403({required this.body});

  final _i6.ApiV1AccountsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse409 extends CreateAccountResponse {
  const CreateAccountResponse409({required this.body});

  final _i7.ApiV1AccountsPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse413 extends CreateAccountResponse {
  const CreateAccountResponse413({required this.body});

  final _i8.ApiV1AccountsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse422 extends CreateAccountResponse {
  const CreateAccountResponse422({required this.body});

  final _i9.ApiV1AccountsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse500 extends CreateAccountResponse {
  const CreateAccountResponse500({required this.body});

  final _i10.ApiV1AccountsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAccountResponse503 extends CreateAccountResponse {
  const CreateAccountResponse503({required this.body});

  final _i11.ApiV1AccountsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
