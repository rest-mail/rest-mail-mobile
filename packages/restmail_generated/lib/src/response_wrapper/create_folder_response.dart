// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_post503_response.dart'
    as _i12;

sealed class CreateFolderResponse {
  const CreateFolderResponse();
}

@_i1.immutable
class CreateFolderResponse201 extends CreateFolderResponse {
  const CreateFolderResponse201({required this.body});

  final _i2.ApiV1AccountsIdFoldersPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse400 extends CreateFolderResponse {
  const CreateFolderResponse400({required this.body});

  final _i4.ApiV1AccountsIdFoldersPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse401 extends CreateFolderResponse {
  const CreateFolderResponse401({required this.body});

  final _i5.ApiV1AccountsIdFoldersPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse403 extends CreateFolderResponse {
  const CreateFolderResponse403({required this.body});

  final _i6.ApiV1AccountsIdFoldersPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse409 extends CreateFolderResponse {
  const CreateFolderResponse409({required this.body});

  final _i7.ApiV1AccountsIdFoldersPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse413 extends CreateFolderResponse {
  const CreateFolderResponse413({required this.body});

  final _i8.ApiV1AccountsIdFoldersPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse422 extends CreateFolderResponse {
  const CreateFolderResponse422({required this.body});

  final _i9.ApiV1AccountsIdFoldersPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse429 extends CreateFolderResponse {
  const CreateFolderResponse429({required this.body});

  final _i10.ApiV1AccountsIdFoldersPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse500 extends CreateFolderResponse {
  const CreateFolderResponse500({required this.body});

  final _i11.ApiV1AccountsIdFoldersPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateFolderResponse503 extends CreateFolderResponse {
  const CreateFolderResponse503({required this.body});

  final _i12.ApiV1AccountsIdFoldersPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateFolderResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
