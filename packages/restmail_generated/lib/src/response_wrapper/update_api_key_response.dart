// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_api_keys_credential_id_patch503_response.dart'
    as _i12;

sealed class UpdateApiKeyResponse {
  const UpdateApiKeyResponse();
}

@_i1.immutable
class UpdateApiKeyResponse200 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse200({required this.body});

  final _i2.ApiV1AccountsIdApiKeysCredentialIdPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse400 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse400({required this.body});

  final _i4.ApiV1AccountsIdApiKeysCredentialIdPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse401 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse401({required this.body});

  final _i5.ApiV1AccountsIdApiKeysCredentialIdPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse403 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse403({required this.body});

  final _i6.ApiV1AccountsIdApiKeysCredentialIdPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse404 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse404({required this.body});

  final _i7.ApiV1AccountsIdApiKeysCredentialIdPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse413 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse413({required this.body});

  final _i8.ApiV1AccountsIdApiKeysCredentialIdPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse422 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse422({required this.body});

  final _i9.ApiV1AccountsIdApiKeysCredentialIdPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse429 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse429({required this.body});

  final _i10.ApiV1AccountsIdApiKeysCredentialIdPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse500 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse500({required this.body});

  final _i11.ApiV1AccountsIdApiKeysCredentialIdPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class UpdateApiKeyResponse503 extends UpdateApiKeyResponse {
  const UpdateApiKeyResponse503({required this.body});

  final _i12.ApiV1AccountsIdApiKeysCredentialIdPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateApiKeyResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
