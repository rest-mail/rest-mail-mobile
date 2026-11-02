// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_post503_response.dart'
    as _i12;

sealed class CreateClientSecretResponse {
  const CreateClientSecretResponse();
}

@_i1.immutable
class CreateClientSecretResponse201 extends CreateClientSecretResponse {
  const CreateClientSecretResponse201({required this.body});

  final _i2.ApiV1AccountsIdClientSecretsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse400 extends CreateClientSecretResponse {
  const CreateClientSecretResponse400({required this.body});

  final _i4.ApiV1AccountsIdClientSecretsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse401 extends CreateClientSecretResponse {
  const CreateClientSecretResponse401({required this.body});

  final _i5.ApiV1AccountsIdClientSecretsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse403 extends CreateClientSecretResponse {
  const CreateClientSecretResponse403({required this.body});

  final _i6.ApiV1AccountsIdClientSecretsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse404 extends CreateClientSecretResponse {
  const CreateClientSecretResponse404({required this.body});

  final _i7.ApiV1AccountsIdClientSecretsPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse413 extends CreateClientSecretResponse {
  const CreateClientSecretResponse413({required this.body});

  final _i8.ApiV1AccountsIdClientSecretsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse422 extends CreateClientSecretResponse {
  const CreateClientSecretResponse422({required this.body});

  final _i9.ApiV1AccountsIdClientSecretsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse429 extends CreateClientSecretResponse {
  const CreateClientSecretResponse429({required this.body});

  final _i10.ApiV1AccountsIdClientSecretsPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse500 extends CreateClientSecretResponse {
  const CreateClientSecretResponse500({required this.body});

  final _i11.ApiV1AccountsIdClientSecretsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateClientSecretResponse503 extends CreateClientSecretResponse {
  const CreateClientSecretResponse503({required this.body});

  final _i12.ApiV1AccountsIdClientSecretsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateClientSecretResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
