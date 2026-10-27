// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_delete503_response.dart'
    as _i12;

sealed class DeleteFolderResponse {
  const DeleteFolderResponse();
}

@_i1.immutable
class DeleteFolderResponse204 extends DeleteFolderResponse {
  const DeleteFolderResponse204({required this.body});

  final _i2.ApiV1AccountsIdFoldersFolderDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse400 extends DeleteFolderResponse {
  const DeleteFolderResponse400({required this.body});

  final _i4.ApiV1AccountsIdFoldersFolderDelete400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse401 extends DeleteFolderResponse {
  const DeleteFolderResponse401({required this.body});

  final _i5.ApiV1AccountsIdFoldersFolderDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse403 extends DeleteFolderResponse {
  const DeleteFolderResponse403({required this.body});

  final _i6.ApiV1AccountsIdFoldersFolderDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse404 extends DeleteFolderResponse {
  const DeleteFolderResponse404({required this.body});

  final _i7.ApiV1AccountsIdFoldersFolderDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse413 extends DeleteFolderResponse {
  const DeleteFolderResponse413({required this.body});

  final _i8.ApiV1AccountsIdFoldersFolderDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse422 extends DeleteFolderResponse {
  const DeleteFolderResponse422({required this.body});

  final _i9.ApiV1AccountsIdFoldersFolderDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse429 extends DeleteFolderResponse {
  const DeleteFolderResponse429({required this.body});

  final _i10.ApiV1AccountsIdFoldersFolderDelete429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse500 extends DeleteFolderResponse {
  const DeleteFolderResponse500({required this.body});

  final _i11.ApiV1AccountsIdFoldersFolderDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteFolderResponse503 extends DeleteFolderResponse {
  const DeleteFolderResponse503({required this.body});

  final _i12.ApiV1AccountsIdFoldersFolderDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteFolderResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
