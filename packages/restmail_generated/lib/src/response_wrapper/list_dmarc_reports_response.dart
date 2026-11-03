// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_get503_response.dart'
    as _i10;

sealed class ListDmarcReportsResponse {
  const ListDmarcReportsResponse();
}

@_i1.immutable
class ListDmarcReportsResponse200 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse200({required this.body});

  final _i2.ApiV1AdminDmarcReportsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse401 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse401({required this.body});

  final _i4.ApiV1AdminDmarcReportsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse403 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse403({required this.body});

  final _i5.ApiV1AdminDmarcReportsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse413 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse413({required this.body});

  final _i6.ApiV1AdminDmarcReportsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse422 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse422({required this.body});

  final _i7.ApiV1AdminDmarcReportsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse429 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse429({required this.body});

  final _i8.ApiV1AdminDmarcReportsGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse500 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse500({required this.body});

  final _i9.ApiV1AdminDmarcReportsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListDmarcReportsResponse503 extends ListDmarcReportsResponse {
  const ListDmarcReportsResponse503({required this.body});

  final _i10.ApiV1AdminDmarcReportsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListDmarcReportsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
