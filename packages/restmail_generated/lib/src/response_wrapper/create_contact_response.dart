// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_id_contacts_post503_response.dart'
    as _i12;

sealed class CreateContactResponse {
  const CreateContactResponse();
}

@_i1.immutable
class CreateContactResponse201 extends CreateContactResponse {
  const CreateContactResponse201({required this.body});

  final _i2.ApiV1AccountsIdContactsPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse400 extends CreateContactResponse {
  const CreateContactResponse400({required this.body});

  final _i4.ApiV1AccountsIdContactsPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse401 extends CreateContactResponse {
  const CreateContactResponse401({required this.body});

  final _i5.ApiV1AccountsIdContactsPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse403 extends CreateContactResponse {
  const CreateContactResponse403({required this.body});

  final _i6.ApiV1AccountsIdContactsPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse409 extends CreateContactResponse {
  const CreateContactResponse409({required this.body});

  final _i7.ApiV1AccountsIdContactsPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse413 extends CreateContactResponse {
  const CreateContactResponse413({required this.body});

  final _i8.ApiV1AccountsIdContactsPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse422 extends CreateContactResponse {
  const CreateContactResponse422({required this.body});

  final _i9.ApiV1AccountsIdContactsPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse429 extends CreateContactResponse {
  const CreateContactResponse429({required this.body});

  final _i10.ApiV1AccountsIdContactsPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse500 extends CreateContactResponse {
  const CreateContactResponse500({required this.body});

  final _i11.ApiV1AccountsIdContactsPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateContactResponse503 extends CreateContactResponse {
  const CreateContactResponse503({required this.body});

  final _i12.ApiV1AccountsIdContactsPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateContactResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
