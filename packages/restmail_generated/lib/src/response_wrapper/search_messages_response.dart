// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_id_search_get503_response.dart'
    as _i11;

sealed class SearchMessagesResponse {
  const SearchMessagesResponse();
}

@_i1.immutable
class SearchMessagesResponse200 extends SearchMessagesResponse {
  const SearchMessagesResponse200({required this.body});

  final _i2.ApiV1AccountsIdSearchGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse401 extends SearchMessagesResponse {
  const SearchMessagesResponse401({required this.body});

  final _i4.ApiV1AccountsIdSearchGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse403 extends SearchMessagesResponse {
  const SearchMessagesResponse403({required this.body});

  final _i5.ApiV1AccountsIdSearchGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse404 extends SearchMessagesResponse {
  const SearchMessagesResponse404({required this.body});

  final _i6.ApiV1AccountsIdSearchGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse413 extends SearchMessagesResponse {
  const SearchMessagesResponse413({required this.body});

  final _i7.ApiV1AccountsIdSearchGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse422 extends SearchMessagesResponse {
  const SearchMessagesResponse422({required this.body});

  final _i8.ApiV1AccountsIdSearchGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse429 extends SearchMessagesResponse {
  const SearchMessagesResponse429({required this.body});

  final _i9.ApiV1AccountsIdSearchGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse500 extends SearchMessagesResponse {
  const SearchMessagesResponse500({required this.body});

  final _i10.ApiV1AccountsIdSearchGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class SearchMessagesResponse503 extends SearchMessagesResponse {
  const SearchMessagesResponse503({required this.body});

  final _i11.ApiV1AccountsIdSearchGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SearchMessagesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
