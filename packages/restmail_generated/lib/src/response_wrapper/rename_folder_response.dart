// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch429_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch500_response.dart'
    as _i12;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_patch503_response.dart'
    as _i13;

sealed class RenameFolderResponse {
  const RenameFolderResponse();
}

@_i1.immutable
class RenameFolderResponse200 extends RenameFolderResponse {
  const RenameFolderResponse200({required this.body});

  final _i2.ApiV1AccountsIdFoldersFolderPatch200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse400 extends RenameFolderResponse {
  const RenameFolderResponse400({required this.body});

  final _i4.ApiV1AccountsIdFoldersFolderPatch400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse401 extends RenameFolderResponse {
  const RenameFolderResponse401({required this.body});

  final _i5.ApiV1AccountsIdFoldersFolderPatch401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse403 extends RenameFolderResponse {
  const RenameFolderResponse403({required this.body});

  final _i6.ApiV1AccountsIdFoldersFolderPatch403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse404 extends RenameFolderResponse {
  const RenameFolderResponse404({required this.body});

  final _i7.ApiV1AccountsIdFoldersFolderPatch404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse409 extends RenameFolderResponse {
  const RenameFolderResponse409({required this.body});

  final _i8.ApiV1AccountsIdFoldersFolderPatch409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse413 extends RenameFolderResponse {
  const RenameFolderResponse413({required this.body});

  final _i9.ApiV1AccountsIdFoldersFolderPatch413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse422 extends RenameFolderResponse {
  const RenameFolderResponse422({required this.body});

  final _i10.ApiV1AccountsIdFoldersFolderPatch422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse429 extends RenameFolderResponse {
  const RenameFolderResponse429({required this.body});

  final _i11.ApiV1AccountsIdFoldersFolderPatch429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse500 extends RenameFolderResponse {
  const RenameFolderResponse500({required this.body});

  final _i12.ApiV1AccountsIdFoldersFolderPatch500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RenameFolderResponse503 extends RenameFolderResponse {
  const RenameFolderResponse503({required this.body});

  final _i13.ApiV1AccountsIdFoldersFolderPatch503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RenameFolderResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
