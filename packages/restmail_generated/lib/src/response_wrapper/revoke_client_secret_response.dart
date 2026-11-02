// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_credential_id_delete503_response.dart'
    as _i10;

sealed class RevokeClientSecretResponse {
  const RevokeClientSecretResponse();
}

@_i1.immutable
class RevokeClientSecretResponse204 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse204({required this.body});

  final _i2.ApiV1AccountsIdClientSecretsCredentialIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse401 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse401({required this.body});

  final _i4.ApiV1AccountsIdClientSecretsCredentialIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse403 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse403({required this.body});

  final _i5.ApiV1AccountsIdClientSecretsCredentialIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse404 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse404({required this.body});

  final _i6.ApiV1AccountsIdClientSecretsCredentialIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse413 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse413({required this.body});

  final _i7.ApiV1AccountsIdClientSecretsCredentialIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse422 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse422({required this.body});

  final _i8.ApiV1AccountsIdClientSecretsCredentialIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse500 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse500({required this.body});

  final _i9.ApiV1AccountsIdClientSecretsCredentialIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeClientSecretResponse503 extends RevokeClientSecretResponse {
  const RevokeClientSecretResponse503({required this.body});

  final _i10.ApiV1AccountsIdClientSecretsCredentialIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeClientSecretResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
