// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_credentials_post503_response.dart'
    as _i12;

sealed class CreateAppPasswordResponse {
  const CreateAppPasswordResponse();
}

@_i1.immutable
class CreateAppPasswordResponse201 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse201({required this.body});

  final _i2.ApiV1AccountsIdCredentialsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse400 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse400({required this.body});

  final _i4.ApiV1AccountsIdCredentialsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse401 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse401({required this.body});

  final _i5.ApiV1AccountsIdCredentialsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse403 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse403({required this.body});

  final _i6.ApiV1AccountsIdCredentialsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse404 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse404({required this.body});

  final _i7.ApiV1AccountsIdCredentialsPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse413 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse413({required this.body});

  final _i8.ApiV1AccountsIdCredentialsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse422 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse422({required this.body});

  final _i9.ApiV1AccountsIdCredentialsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse429 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse429({required this.body});

  final _i10.ApiV1AccountsIdCredentialsPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse500 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse500({required this.body});

  final _i11.ApiV1AccountsIdCredentialsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateAppPasswordResponse503 extends CreateAppPasswordResponse {
  const CreateAppPasswordResponse503({required this.body});

  final _i12.ApiV1AccountsIdCredentialsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAppPasswordResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
