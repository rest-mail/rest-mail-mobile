// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_tls_reports_get503_response.dart'
    as _i9;

sealed class ListTlsReportsResponse {
  const ListTlsReportsResponse();
}

@_i1.immutable
class ListTlsReportsResponse200 extends ListTlsReportsResponse {
  const ListTlsReportsResponse200({required this.body});

  final _i2.ApiV1AdminTlsReportsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse401 extends ListTlsReportsResponse {
  const ListTlsReportsResponse401({required this.body});

  final _i4.ApiV1AdminTlsReportsGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse403 extends ListTlsReportsResponse {
  const ListTlsReportsResponse403({required this.body});

  final _i5.ApiV1AdminTlsReportsGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse413 extends ListTlsReportsResponse {
  const ListTlsReportsResponse413({required this.body});

  final _i6.ApiV1AdminTlsReportsGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse422 extends ListTlsReportsResponse {
  const ListTlsReportsResponse422({required this.body});

  final _i7.ApiV1AdminTlsReportsGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse500 extends ListTlsReportsResponse {
  const ListTlsReportsResponse500({required this.body});

  final _i8.ApiV1AdminTlsReportsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListTlsReportsResponse503 extends ListTlsReportsResponse {
  const ListTlsReportsResponse503({required this.body});

  final _i9.ApiV1AdminTlsReportsGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListTlsReportsResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
