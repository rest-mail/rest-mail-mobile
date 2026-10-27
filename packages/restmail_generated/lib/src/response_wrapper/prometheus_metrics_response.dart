// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/response/metrics_get200_response.dart'
    as _i2;
import 'package:restmail_generated/src/response/metrics_get500_response.dart'
    as _i4;

sealed class PrometheusMetricsResponse {
  const PrometheusMetricsResponse();
}

@_i1.immutable
class PrometheusMetricsResponse200 extends PrometheusMetricsResponse {
  const PrometheusMetricsResponse200({required this.body});

  final _i2.MetricsGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrometheusMetricsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}

@_i1.immutable
class PrometheusMetricsResponse500 extends PrometheusMetricsResponse {
  const PrometheusMetricsResponse500({required this.body});

  final _i4.MetricsGet500Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrometheusMetricsResponse500 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => body.hashCode;
}
