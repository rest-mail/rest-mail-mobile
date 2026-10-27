// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post409_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post413_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post422_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_blocklist_post503_response.dart'
    as _i12;

sealed class AddToBlocklistResponse {
  const AddToBlocklistResponse();
}

@_i1.immutable
class AddToBlocklistResponse201 extends AddToBlocklistResponse {
  const AddToBlocklistResponse201({required this.body});

  final _i2.ApiV1AdminDomainsIdBlocklistPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse400 extends AddToBlocklistResponse {
  const AddToBlocklistResponse400({required this.body});

  final _i4.ApiV1AdminDomainsIdBlocklistPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse401 extends AddToBlocklistResponse {
  const AddToBlocklistResponse401({required this.body});

  final _i5.ApiV1AdminDomainsIdBlocklistPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse403 extends AddToBlocklistResponse {
  const AddToBlocklistResponse403({required this.body});

  final _i6.ApiV1AdminDomainsIdBlocklistPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse404 extends AddToBlocklistResponse {
  const AddToBlocklistResponse404({required this.body});

  final _i7.ApiV1AdminDomainsIdBlocklistPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse409 extends AddToBlocklistResponse {
  const AddToBlocklistResponse409({required this.body});

  final _i8.ApiV1AdminDomainsIdBlocklistPost409Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse409 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse413 extends AddToBlocklistResponse {
  const AddToBlocklistResponse413({required this.body});

  final _i9.ApiV1AdminDomainsIdBlocklistPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse422 extends AddToBlocklistResponse {
  const AddToBlocklistResponse422({required this.body});

  final _i10.ApiV1AdminDomainsIdBlocklistPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse500 extends AddToBlocklistResponse {
  const AddToBlocklistResponse500({required this.body});

  final _i11.ApiV1AdminDomainsIdBlocklistPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class AddToBlocklistResponse503 extends AddToBlocklistResponse {
  const AddToBlocklistResponse503({required this.body});

  final _i12.ApiV1AdminDomainsIdBlocklistPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddToBlocklistResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
