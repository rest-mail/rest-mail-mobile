// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/analytics_window.dart' as _i6;
import 'package:restmail_generated/src/model/pipeline_analytics_response_live_totals_one_of_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/pipeline_funnel.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PipelineAnalyticsResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PipelineAnalyticsResponse({
    required this.funnel,
    required this.window,
    this.liveTotals,
  });

  factory PipelineAnalyticsResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PipelineAnalyticsResponse: contains complex types',
    );
  }

  factory PipelineAnalyticsResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PipelineAnalyticsResponse');
    return PipelineAnalyticsResponse(
      funnel: _i4.PipelineFunnel.fromJson(_$map[r'funnel']),
      liveTotals: _$map[r'live_totals'] == null
          ? null
          : _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel.fromJson(
              _$map[r'live_totals'],
            ),
      window: _i6.AnalyticsWindow.fromJson(_$map[r'window']),
    );
  }

  factory PipelineAnalyticsResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PipelineAnalyticsResponse: contains complex types',
    );
  }

  final _i4.PipelineFunnel funnel;

  final _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel? liveTotals;

  final _i6.AnalyticsWindow window;

  @_i3.override
  _i3.Object? toJson() => {
    r'funnel': funnel.toJson(),
    if (liveTotals != null) r'live_totals': liveTotals?.toJson(),
    r'window': window.toJson(),
  };

  $$PipelineAnalyticsResponseCopyWith<PipelineAnalyticsResponse> get copyWith =>
      _PipelineAnalyticsResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PipelineAnalyticsResponse &&
        other.funnel == this.funnel &&
        other.liveTotals == this.liveTotals &&
        other.window == this.window;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([funnel, liveTotals, window]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PipelineAnalyticsResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PipelineAnalyticsResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PipelineAnalyticsResponseCopyWith<$Res> {
  factory $$PipelineAnalyticsResponseCopyWith(PipelineAnalyticsResponse value) =
      _PipelineAnalyticsResponseCopyWith<$Res>;

  $Res call({
    _i4.PipelineFunnel? funnel,
    _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel? liveTotals,
    _i6.AnalyticsWindow? window,
  });
  _i4.PipelineFunnel get funnel;
  _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel? get liveTotals;
  _i6.AnalyticsWindow get window;
}

class _PipelineAnalyticsResponseCopyWith<$Res>
    implements $$PipelineAnalyticsResponseCopyWith<$Res> {
  _PipelineAnalyticsResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final PipelineAnalyticsResponse _value;

  @_i3.override
  _i4.PipelineFunnel get funnel => _value.funnel;

  @_i3.override
  _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel? get liveTotals =>
      _value.liveTotals;

  @_i3.override
  _i6.AnalyticsWindow get window => _value.window;

  @_i3.override
  $Res call({
    _i3.Object? funnel = _sentinel,
    _i3.Object? liveTotals = _sentinel,
    _i3.Object? window = _sentinel,
  }) {
    return (PipelineAnalyticsResponse(
      funnel: _i3.identical(funnel, _sentinel)
          ? this.funnel
          : (funnel as _i4.PipelineFunnel),
      liveTotals: _i3.identical(liveTotals, _sentinel)
          ? this.liveTotals
          : (liveTotals as _i5.PipelineAnalyticsResponseLiveTotalsOneOfModel?),
      window: _i3.identical(window, _sentinel)
          ? this.window
          : (window as _i6.AnalyticsWindow),
    ) as $Res);
  }
}
