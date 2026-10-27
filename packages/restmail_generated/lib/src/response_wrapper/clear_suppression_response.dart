// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete204_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete401_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete403_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete404_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete413_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete422_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete500_response.dart'
    as _i9;
import 'package:restmail_generated/src/response/api_v1_admin_domains_id_suppressions_sid_delete503_response.dart'
    as _i10;

sealed class ClearSuppressionResponse {
  const ClearSuppressionResponse();
}

@_i1.immutable
class ClearSuppressionResponse204 extends ClearSuppressionResponse {
  const ClearSuppressionResponse204({required this.body});

  final _i2.ApiV1AdminDomainsIdSuppressionsSidDelete204Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse204 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse401 extends ClearSuppressionResponse {
  const ClearSuppressionResponse401({required this.body});

  final _i4.ApiV1AdminDomainsIdSuppressionsSidDelete401Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse401 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse403 extends ClearSuppressionResponse {
  const ClearSuppressionResponse403({required this.body});

  final _i5.ApiV1AdminDomainsIdSuppressionsSidDelete403Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse403 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse404 extends ClearSuppressionResponse {
  const ClearSuppressionResponse404({required this.body});

  final _i6.ApiV1AdminDomainsIdSuppressionsSidDelete404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse413 extends ClearSuppressionResponse {
  const ClearSuppressionResponse413({required this.body});

  final _i7.ApiV1AdminDomainsIdSuppressionsSidDelete413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse422 extends ClearSuppressionResponse {
  const ClearSuppressionResponse422({required this.body});

  final _i8.ApiV1AdminDomainsIdSuppressionsSidDelete422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse500 extends ClearSuppressionResponse {
  const ClearSuppressionResponse500({required this.body});

  final _i9.ApiV1AdminDomainsIdSuppressionsSidDelete500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ClearSuppressionResponse503 extends ClearSuppressionResponse {
  const ClearSuppressionResponse503({required this.body});

  final _i10.ApiV1AdminDomainsIdSuppressionsSidDelete503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ClearSuppressionResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
