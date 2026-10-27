// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_get503_response.dart'
    as _i10;

sealed class GetCertificateResponse {
  const GetCertificateResponse();
}

@_i1.immutable
class GetCertificateResponse200 extends GetCertificateResponse {
  const GetCertificateResponse200({required this.body});

  final _i2.ApiV1AdminCertificatesIdGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse401 extends GetCertificateResponse {
  const GetCertificateResponse401({required this.body});

  final _i4.ApiV1AdminCertificatesIdGet401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse403 extends GetCertificateResponse {
  const GetCertificateResponse403({required this.body});

  final _i5.ApiV1AdminCertificatesIdGet403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse404 extends GetCertificateResponse {
  const GetCertificateResponse404({required this.body});

  final _i6.ApiV1AdminCertificatesIdGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse413 extends GetCertificateResponse {
  const GetCertificateResponse413({required this.body});

  final _i7.ApiV1AdminCertificatesIdGet413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse422 extends GetCertificateResponse {
  const GetCertificateResponse422({required this.body});

  final _i8.ApiV1AdminCertificatesIdGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse500 extends GetCertificateResponse {
  const GetCertificateResponse500({required this.body});

  final _i9.ApiV1AdminCertificatesIdGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class GetCertificateResponse503 extends GetCertificateResponse {
  const GetCertificateResponse503({required this.body});

  final _i10.ApiV1AdminCertificatesIdGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
