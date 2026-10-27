// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_delete503_response.dart'
    as _i10;

sealed class RevokeApiKeyResponse {
  const RevokeApiKeyResponse();
}

@_i1.immutable
class RevokeApiKeyResponse204 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse204({required this.body});

  final _i2.ApiV1AccountsIdApiKeysCredentialIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse401 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse401({required this.body});

  final _i4.ApiV1AccountsIdApiKeysCredentialIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse403 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse403({required this.body});

  final _i5.ApiV1AccountsIdApiKeysCredentialIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse404 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse404({required this.body});

  final _i6.ApiV1AccountsIdApiKeysCredentialIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse413 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse413({required this.body});

  final _i7.ApiV1AccountsIdApiKeysCredentialIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse422 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse422({required this.body});

  final _i8.ApiV1AccountsIdApiKeysCredentialIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse500 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse500({required this.body});

  final _i9.ApiV1AccountsIdApiKeysCredentialIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeApiKeyResponse503 extends RevokeApiKeyResponse {
  const RevokeApiKeyResponse503({required this.body});

  final _i10.ApiV1AccountsIdApiKeysCredentialIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeApiKeyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
