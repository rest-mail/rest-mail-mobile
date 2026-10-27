// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/well_known_mta_sts_txt_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/well_known_mta_sts_txt_get404_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/well_known_mta_sts_txt_get500_response.dart'
    as _i5;

sealed class MtaStsPolicyFileResponse {
  const MtaStsPolicyFileResponse();
}

@_i1.immutable
class MtaStsPolicyFileResponse200 extends MtaStsPolicyFileResponse {
  const MtaStsPolicyFileResponse200({required this.body});

  final _i2.WellKnownMtaStsTxtGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MtaStsPolicyFileResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MtaStsPolicyFileResponse404 extends MtaStsPolicyFileResponse {
  const MtaStsPolicyFileResponse404({required this.body});

  final _i4.WellKnownMtaStsTxtGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MtaStsPolicyFileResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class MtaStsPolicyFileResponse500 extends MtaStsPolicyFileResponse {
  const MtaStsPolicyFileResponse500({required this.body});

  final _i5.WellKnownMtaStsTxtGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MtaStsPolicyFileResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
