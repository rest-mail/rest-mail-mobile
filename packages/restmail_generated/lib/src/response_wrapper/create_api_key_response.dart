// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_post503_response.dart'
    as _i12;

sealed class CreateApiKeyResponse {
  const CreateApiKeyResponse();
}

@_i1.immutable
class CreateApiKeyResponse201 extends CreateApiKeyResponse {
  const CreateApiKeyResponse201({required this.body});

  final _i2.ApiV1AccountsIdApiKeysPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse400 extends CreateApiKeyResponse {
  const CreateApiKeyResponse400({required this.body});

  final _i4.ApiV1AccountsIdApiKeysPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse401 extends CreateApiKeyResponse {
  const CreateApiKeyResponse401({required this.body});

  final _i5.ApiV1AccountsIdApiKeysPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse403 extends CreateApiKeyResponse {
  const CreateApiKeyResponse403({required this.body});

  final _i6.ApiV1AccountsIdApiKeysPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse404 extends CreateApiKeyResponse {
  const CreateApiKeyResponse404({required this.body});

  final _i7.ApiV1AccountsIdApiKeysPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse413 extends CreateApiKeyResponse {
  const CreateApiKeyResponse413({required this.body});

  final _i8.ApiV1AccountsIdApiKeysPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse422 extends CreateApiKeyResponse {
  const CreateApiKeyResponse422({required this.body});

  final _i9.ApiV1AccountsIdApiKeysPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse429 extends CreateApiKeyResponse {
  const CreateApiKeyResponse429({required this.body});

  final _i10.ApiV1AccountsIdApiKeysPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse500 extends CreateApiKeyResponse {
  const CreateApiKeyResponse500({required this.body});

  final _i11.ApiV1AccountsIdApiKeysPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateApiKeyResponse503 extends CreateApiKeyResponse {
  const CreateApiKeyResponse503({required this.body});

  final _i12.ApiV1AccountsIdApiKeysPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateApiKeyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
