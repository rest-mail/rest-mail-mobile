// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_id_delete503_response.dart'
    as _i10;

sealed class DeleteCertificateResponse {
  const DeleteCertificateResponse();
}

@_i1.immutable
class DeleteCertificateResponse204 extends DeleteCertificateResponse {
  const DeleteCertificateResponse204({required this.body});

  final _i2.ApiV1AdminCertificatesIdDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse401 extends DeleteCertificateResponse {
  const DeleteCertificateResponse401({required this.body});

  final _i4.ApiV1AdminCertificatesIdDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse403 extends DeleteCertificateResponse {
  const DeleteCertificateResponse403({required this.body});

  final _i5.ApiV1AdminCertificatesIdDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse404 extends DeleteCertificateResponse {
  const DeleteCertificateResponse404({required this.body});

  final _i6.ApiV1AdminCertificatesIdDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse413 extends DeleteCertificateResponse {
  const DeleteCertificateResponse413({required this.body});

  final _i7.ApiV1AdminCertificatesIdDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse422 extends DeleteCertificateResponse {
  const DeleteCertificateResponse422({required this.body});

  final _i8.ApiV1AdminCertificatesIdDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse500 extends DeleteCertificateResponse {
  const DeleteCertificateResponse500({required this.body});

  final _i9.ApiV1AdminCertificatesIdDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse503 extends DeleteCertificateResponse {
  const DeleteCertificateResponse503({required this.body});

  final _i10.ApiV1AdminCertificatesIdDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteCertificateResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
