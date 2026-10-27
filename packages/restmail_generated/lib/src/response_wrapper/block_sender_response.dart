// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post201_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post400_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post401_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post403_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_block_post503_response.dart'
    as _i12;

sealed class BlockSenderResponse {
  const BlockSenderResponse();
}

@_i1.immutable
class BlockSenderResponse200 extends BlockSenderResponse {
  const BlockSenderResponse200({required this.body});

  final _i2.ApiV1AccountsIdContactsBlockPost200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse201 extends BlockSenderResponse {
  const BlockSenderResponse201({required this.body});

  final _i4.ApiV1AccountsIdContactsBlockPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse400 extends BlockSenderResponse {
  const BlockSenderResponse400({required this.body});

  final _i5.ApiV1AccountsIdContactsBlockPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse401 extends BlockSenderResponse {
  const BlockSenderResponse401({required this.body});

  final _i6.ApiV1AccountsIdContactsBlockPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse403 extends BlockSenderResponse {
  const BlockSenderResponse403({required this.body});

  final _i7.ApiV1AccountsIdContactsBlockPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse413 extends BlockSenderResponse {
  const BlockSenderResponse413({required this.body});

  final _i8.ApiV1AccountsIdContactsBlockPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse422 extends BlockSenderResponse {
  const BlockSenderResponse422({required this.body});

  final _i9.ApiV1AccountsIdContactsBlockPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse429 extends BlockSenderResponse {
  const BlockSenderResponse429({required this.body});

  final _i10.ApiV1AccountsIdContactsBlockPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse500 extends BlockSenderResponse {
  const BlockSenderResponse500({required this.body});

  final _i11.ApiV1AccountsIdContactsBlockPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class BlockSenderResponse503 extends BlockSenderResponse {
  const BlockSenderResponse503({required this.body});

  final _i12.ApiV1AccountsIdContactsBlockPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is BlockSenderResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
