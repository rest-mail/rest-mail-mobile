// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post409_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_accounts_link_post503_response.dart'
    as _i12;

sealed class LinkAccountResponse {
  const LinkAccountResponse();
}

@_i1.immutable
class LinkAccountResponse201 extends LinkAccountResponse {
  const LinkAccountResponse201({required this.body});

  final _i2.ApiV1AccountsLinkPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse400 extends LinkAccountResponse {
  const LinkAccountResponse400({required this.body});

  final _i4.ApiV1AccountsLinkPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse401 extends LinkAccountResponse {
  const LinkAccountResponse401({required this.body});

  final _i5.ApiV1AccountsLinkPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse403 extends LinkAccountResponse {
  const LinkAccountResponse403({required this.body});

  final _i6.ApiV1AccountsLinkPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse409 extends LinkAccountResponse {
  const LinkAccountResponse409({required this.body});

  final _i7.ApiV1AccountsLinkPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse413 extends LinkAccountResponse {
  const LinkAccountResponse413({required this.body});

  final _i8.ApiV1AccountsLinkPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse422 extends LinkAccountResponse {
  const LinkAccountResponse422({required this.body});

  final _i9.ApiV1AccountsLinkPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse429 extends LinkAccountResponse {
  const LinkAccountResponse429({required this.body});

  final _i10.ApiV1AccountsLinkPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse500 extends LinkAccountResponse {
  const LinkAccountResponse500({required this.body});

  final _i11.ApiV1AccountsLinkPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class LinkAccountResponse503 extends LinkAccountResponse {
  const LinkAccountResponse503({required this.body});

  final _i12.ApiV1AccountsLinkPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
