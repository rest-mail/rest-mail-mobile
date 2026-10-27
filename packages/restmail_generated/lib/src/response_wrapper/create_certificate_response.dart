// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post401_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post403_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post404_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post413_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post422_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post429_response.dart'
    as _i10;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post500_response.dart'
    as _i11;
import 'package:restmail_generated/src/response/api_v1_admin_certificates_post503_response.dart'
    as _i12;

sealed class CreateCertificateResponse {
  const CreateCertificateResponse();
}

@_i1.immutable
class CreateCertificateResponse201 extends CreateCertificateResponse {
  const CreateCertificateResponse201({required this.body});

  final _i2.ApiV1AdminCertificatesPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse400 extends CreateCertificateResponse {
  const CreateCertificateResponse400({required this.body});

  final _i4.ApiV1AdminCertificatesPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse401 extends CreateCertificateResponse {
  const CreateCertificateResponse401({required this.body});

  final _i5.ApiV1AdminCertificatesPost401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse403 extends CreateCertificateResponse {
  const CreateCertificateResponse403({required this.body});

  final _i6.ApiV1AdminCertificatesPost403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse404 extends CreateCertificateResponse {
  const CreateCertificateResponse404({required this.body});

  final _i7.ApiV1AdminCertificatesPost404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse413 extends CreateCertificateResponse {
  const CreateCertificateResponse413({required this.body});

  final _i8.ApiV1AdminCertificatesPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse422 extends CreateCertificateResponse {
  const CreateCertificateResponse422({required this.body});

  final _i9.ApiV1AdminCertificatesPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse429 extends CreateCertificateResponse {
  const CreateCertificateResponse429({required this.body});

  final _i10.ApiV1AdminCertificatesPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse500 extends CreateCertificateResponse {
  const CreateCertificateResponse500({required this.body});

  final _i11.ApiV1AdminCertificatesPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse503 extends CreateCertificateResponse {
  const CreateCertificateResponse503({required this.body});

  final _i12.ApiV1AdminCertificatesPost503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
