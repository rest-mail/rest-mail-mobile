// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_credential_id_delete503_response.dart'
    as _i10;

sealed class RevokeCredentialResponse {
  const RevokeCredentialResponse();
}

@_i1.immutable
class RevokeCredentialResponse204 extends RevokeCredentialResponse {
  const RevokeCredentialResponse204({required this.body});

  final _i2.ApiV1AccountsIdCredentialsCredentialIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse401 extends RevokeCredentialResponse {
  const RevokeCredentialResponse401({required this.body});

  final _i4.ApiV1AccountsIdCredentialsCredentialIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse403 extends RevokeCredentialResponse {
  const RevokeCredentialResponse403({required this.body});

  final _i5.ApiV1AccountsIdCredentialsCredentialIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse404 extends RevokeCredentialResponse {
  const RevokeCredentialResponse404({required this.body});

  final _i6.ApiV1AccountsIdCredentialsCredentialIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse413 extends RevokeCredentialResponse {
  const RevokeCredentialResponse413({required this.body});

  final _i7.ApiV1AccountsIdCredentialsCredentialIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse422 extends RevokeCredentialResponse {
  const RevokeCredentialResponse422({required this.body});

  final _i8.ApiV1AccountsIdCredentialsCredentialIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse500 extends RevokeCredentialResponse {
  const RevokeCredentialResponse500({required this.body});

  final _i9.ApiV1AccountsIdCredentialsCredentialIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RevokeCredentialResponse503 extends RevokeCredentialResponse {
  const RevokeCredentialResponse503({required this.body});

  final _i10.ApiV1AccountsIdCredentialsCredentialIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RevokeCredentialResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
