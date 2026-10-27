// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get413_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get500_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_get503_response.dart'
    as _i9;

sealed class ListCertificatesResponse {
  const ListCertificatesResponse();
}

@_i1.immutable
class ListCertificatesResponse200 extends ListCertificatesResponse {
  const ListCertificatesResponse200({required this.body});

  final _i2.ApiV1AdminCertificatesGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse401 extends ListCertificatesResponse {
  const ListCertificatesResponse401({required this.body});

  final _i4.ApiV1AdminCertificatesGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse403 extends ListCertificatesResponse {
  const ListCertificatesResponse403({required this.body});

  final _i5.ApiV1AdminCertificatesGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse413 extends ListCertificatesResponse {
  const ListCertificatesResponse413({required this.body});

  final _i6.ApiV1AdminCertificatesGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse422 extends ListCertificatesResponse {
  const ListCertificatesResponse422({required this.body});

  final _i7.ApiV1AdminCertificatesGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse500 extends ListCertificatesResponse {
  const ListCertificatesResponse500({required this.body});

  final _i8.ApiV1AdminCertificatesGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse503 extends ListCertificatesResponse {
  const ListCertificatesResponse503({required this.body});

  final _i9.ApiV1AdminCertificatesGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
