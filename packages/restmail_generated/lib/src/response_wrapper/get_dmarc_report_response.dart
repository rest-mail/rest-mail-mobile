// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get429_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get500_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_dmarc_reports_id_get503_response.dart'
    as _i11;

sealed class GetDmarcReportResponse {
  const GetDmarcReportResponse();
}

@_i1.immutable
class GetDmarcReportResponse200 extends GetDmarcReportResponse {
  const GetDmarcReportResponse200({required this.body});

  final _i2.ApiV1AdminDmarcReportsIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse401 extends GetDmarcReportResponse {
  const GetDmarcReportResponse401({required this.body});

  final _i4.ApiV1AdminDmarcReportsIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse403 extends GetDmarcReportResponse {
  const GetDmarcReportResponse403({required this.body});

  final _i5.ApiV1AdminDmarcReportsIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse404 extends GetDmarcReportResponse {
  const GetDmarcReportResponse404({required this.body});

  final _i6.ApiV1AdminDmarcReportsIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse413 extends GetDmarcReportResponse {
  const GetDmarcReportResponse413({required this.body});

  final _i7.ApiV1AdminDmarcReportsIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse422 extends GetDmarcReportResponse {
  const GetDmarcReportResponse422({required this.body});

  final _i8.ApiV1AdminDmarcReportsIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse429 extends GetDmarcReportResponse {
  const GetDmarcReportResponse429({required this.body});

  final _i9.ApiV1AdminDmarcReportsIdGet429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse500 extends GetDmarcReportResponse {
  const GetDmarcReportResponse500({required this.body});

  final _i10.ApiV1AdminDmarcReportsIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetDmarcReportResponse503 extends GetDmarcReportResponse {
  const GetDmarcReportResponse503({required this.body});

  final _i11.ApiV1AdminDmarcReportsIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDmarcReportResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
