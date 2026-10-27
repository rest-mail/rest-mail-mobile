// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_get503_response.dart'
    as _i9;

sealed class ListSuppressionsResponse {
  const ListSuppressionsResponse();
}

@_i1.immutable
class ListSuppressionsResponse200 extends ListSuppressionsResponse {
  const ListSuppressionsResponse200({required this.body});

  final _i2.ApiV1AdminDomainsIdSuppressionsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse401 extends ListSuppressionsResponse {
  const ListSuppressionsResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdSuppressionsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse403 extends ListSuppressionsResponse {
  const ListSuppressionsResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdSuppressionsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse413 extends ListSuppressionsResponse {
  const ListSuppressionsResponse413({required this.body});

  final _i6.ApiV1AdminDomainsIdSuppressionsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse422 extends ListSuppressionsResponse {
  const ListSuppressionsResponse422({required this.body});

  final _i7.ApiV1AdminDomainsIdSuppressionsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse500 extends ListSuppressionsResponse {
  const ListSuppressionsResponse500({required this.body});

  final _i8.ApiV1AdminDomainsIdSuppressionsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListSuppressionsResponse503 extends ListSuppressionsResponse {
  const ListSuppressionsResponse503({required this.body});

  final _i9.ApiV1AdminDomainsIdSuppressionsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSuppressionsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
