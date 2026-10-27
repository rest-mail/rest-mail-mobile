// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/well_known_restmail_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/well_known_restmail_get400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/well_known_restmail_get404_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/well_known_restmail_get422_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/well_known_restmail_get500_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/well_known_restmail_get503_response.dart'
    as _i8;

sealed class RestmailDiscoverResponse {
  const RestmailDiscoverResponse();
}

@_i1.immutable
class RestmailDiscoverResponse200 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse200({required this.body});

  final _i2.WellKnownRestmailGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDiscoverResponse400 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse400({required this.body});

  final _i4.WellKnownRestmailGet400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDiscoverResponse404 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse404({required this.body});

  final _i5.WellKnownRestmailGet404Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse404 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDiscoverResponse422 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse422({required this.body});

  final _i6.WellKnownRestmailGet422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDiscoverResponse500 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse500({required this.body});

  final _i7.WellKnownRestmailGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class RestmailDiscoverResponse503 extends RestmailDiscoverResponse {
  const RestmailDiscoverResponse503({required this.body});

  final _i8.WellKnownRestmailGet503Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscoverResponse503 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
