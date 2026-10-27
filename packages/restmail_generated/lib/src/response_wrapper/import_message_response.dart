// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_messages_import_post503_response.dart'
    as _i12;

sealed class ImportMessageResponse {
  const ImportMessageResponse();
}

@_i1.immutable
class ImportMessageResponse200 extends ImportMessageResponse {
  const ImportMessageResponse200({required this.body});

  final _i2.ApiV1AccountsIdMessagesImportPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse400 extends ImportMessageResponse {
  const ImportMessageResponse400({required this.body});

  final _i4.ApiV1AccountsIdMessagesImportPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse401 extends ImportMessageResponse {
  const ImportMessageResponse401({required this.body});

  final _i5.ApiV1AccountsIdMessagesImportPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse403 extends ImportMessageResponse {
  const ImportMessageResponse403({required this.body});

  final _i6.ApiV1AccountsIdMessagesImportPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse404 extends ImportMessageResponse {
  const ImportMessageResponse404({required this.body});

  final _i7.ApiV1AccountsIdMessagesImportPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse409 extends ImportMessageResponse {
  const ImportMessageResponse409({required this.body});

  final _i8.ApiV1AccountsIdMessagesImportPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse413 extends ImportMessageResponse {
  const ImportMessageResponse413({required this.body});

  final _i9.ApiV1AccountsIdMessagesImportPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse422 extends ImportMessageResponse {
  const ImportMessageResponse422({required this.body});

  final _i10.ApiV1AccountsIdMessagesImportPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse500 extends ImportMessageResponse {
  const ImportMessageResponse500({required this.body});

  final _i11.ApiV1AccountsIdMessagesImportPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ImportMessageResponse503 extends ImportMessageResponse {
  const ImportMessageResponse503({required this.body});

  final _i12.ApiV1AccountsIdMessagesImportPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportMessageResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
