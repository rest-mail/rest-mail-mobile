// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_folders_folder_messages_get503_response.dart'
    as _i10;

sealed class ListMessagesResponse {
  const ListMessagesResponse();
}

@_i1.immutable
class ListMessagesResponse200 extends ListMessagesResponse {
  const ListMessagesResponse200({required this.body});

  final _i2.ApiV1AccountsIdFoldersFolderMessagesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse401 extends ListMessagesResponse {
  const ListMessagesResponse401({required this.body});

  final _i4.ApiV1AccountsIdFoldersFolderMessagesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse403 extends ListMessagesResponse {
  const ListMessagesResponse403({required this.body});

  final _i5.ApiV1AccountsIdFoldersFolderMessagesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse413 extends ListMessagesResponse {
  const ListMessagesResponse413({required this.body});

  final _i6.ApiV1AccountsIdFoldersFolderMessagesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse422 extends ListMessagesResponse {
  const ListMessagesResponse422({required this.body});

  final _i7.ApiV1AccountsIdFoldersFolderMessagesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse429 extends ListMessagesResponse {
  const ListMessagesResponse429({required this.body});

  final _i8.ApiV1AccountsIdFoldersFolderMessagesGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse500 extends ListMessagesResponse {
  const ListMessagesResponse500({required this.body});

  final _i9.ApiV1AccountsIdFoldersFolderMessagesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListMessagesResponse503 extends ListMessagesResponse {
  const ListMessagesResponse503({required this.body});

  final _i10.ApiV1AccountsIdFoldersFolderMessagesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListMessagesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
