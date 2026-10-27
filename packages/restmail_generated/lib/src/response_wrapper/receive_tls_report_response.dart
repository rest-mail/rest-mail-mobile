// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post201_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post400_response.dart'
    as _i4;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post413_response.dart'
    as _i5;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post415_response.dart'
    as _i6;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post422_response.dart'
    as _i7;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post429_response.dart'
    as _i8;
import 'package:restmail_generated/src/response/well_known_smtp_tlsrpt_post500_response.dart'
    as _i9;

sealed class ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse();
}

@_i1.immutable
class ReceiveTlsReportResponse201 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse201({required this.body});

  final _i2.WellKnownSmtpTlsrptPost201Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse400 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse400({required this.body});

  final _i4.WellKnownSmtpTlsrptPost400Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse400 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse413 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse413({required this.body});

  final _i5.WellKnownSmtpTlsrptPost413Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse413 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse415 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse415({required this.body});

  final _i6.WellKnownSmtpTlsrptPost415Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse415 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse422 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse422({required this.body});

  final _i7.WellKnownSmtpTlsrptPost422Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse422 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse429 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse429({required this.body});

  final _i8.WellKnownSmtpTlsrptPost429Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse429 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class ReceiveTlsReportResponse500 extends ReceiveTlsReportResponse {
  const ReceiveTlsReportResponse500({required this.body});

  final _i9.WellKnownSmtpTlsrptPost500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ReceiveTlsReportResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
