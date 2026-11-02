// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_client_secrets_get503_response.dart'
    as _i10;

sealed class ListClientSecretsResponse {
  const ListClientSecretsResponse();
}

@_i1.immutable
class ListClientSecretsResponse200 extends ListClientSecretsResponse {
  const ListClientSecretsResponse200({required this.body});

  final _i2.ApiV1AccountsIdClientSecretsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse401 extends ListClientSecretsResponse {
  const ListClientSecretsResponse401({required this.body});

  final _i4.ApiV1AccountsIdClientSecretsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse403 extends ListClientSecretsResponse {
  const ListClientSecretsResponse403({required this.body});

  final _i5.ApiV1AccountsIdClientSecretsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse404 extends ListClientSecretsResponse {
  const ListClientSecretsResponse404({required this.body});

  final _i6.ApiV1AccountsIdClientSecretsGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse413 extends ListClientSecretsResponse {
  const ListClientSecretsResponse413({required this.body});

  final _i7.ApiV1AccountsIdClientSecretsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse422 extends ListClientSecretsResponse {
  const ListClientSecretsResponse422({required this.body});

  final _i8.ApiV1AccountsIdClientSecretsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse500 extends ListClientSecretsResponse {
  const ListClientSecretsResponse500({required this.body});

  final _i9.ApiV1AccountsIdClientSecretsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListClientSecretsResponse503 extends ListClientSecretsResponse {
  const ListClientSecretsResponse503({required this.body});

  final _i10.ApiV1AccountsIdClientSecretsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListClientSecretsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
