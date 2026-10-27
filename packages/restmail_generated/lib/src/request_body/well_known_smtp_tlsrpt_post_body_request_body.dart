// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/model/tlsrpt_report.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i4;

@_i1.immutable
sealed class WellKnownSmtpTlsrptPostBodyRequestBody {
  const WellKnownSmtpTlsrptPostBodyRequestBody();
}

@_i1.immutable
class WellKnownSmtpTlsrptPostBodyRequestBodyJson
    extends WellKnownSmtpTlsrptPostBodyRequestBody {
  const WellKnownSmtpTlsrptPostBodyRequestBodyJson(this.value);

  final _i2.TlsrptReport value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is WellKnownSmtpTlsrptPostBodyRequestBodyJson &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => value.hashCode;
}

@_i1.immutable
class WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptGzip
    extends WellKnownSmtpTlsrptPostBodyRequestBody {
  const WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptGzip(this.value);

  final _i4.TonikFile value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptGzip &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => value.hashCode;
}

@_i1.immutable
class WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptJson
    extends WellKnownSmtpTlsrptPostBodyRequestBody {
  const WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptJson(this.value);

  final _i2.TlsrptReport value;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is WellKnownSmtpTlsrptPostBodyRequestBodyTlsrptJson &&
        other.value == this.value;
  }

  @_i3.override
  _i3.int get hashCode => value.hashCode;
}
