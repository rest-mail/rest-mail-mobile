// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/filter_log.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StepResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StepResult({
    required this.action,
    required this.durationMs,
    required this.filterName,
    required this.filterType,
    required this.log,
    this.error,
    this.skipReason,
    this.skipped,
  });

  factory StepResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StepResult: contains complex types',
    );
  }

  factory StepResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'StepResult');
    return StepResult(
      action: _$map[r'action'].decodeJsonString(context: r'StepResult.action'),
      durationMs: _$map[r'duration_ms'].decodeJsonInt(
        context: r'StepResult.duration_ms',
      ),
      error: _$map[r'error'].decodeJsonNullableString(
        context: r'StepResult.error',
      ),
      filterName: _$map[r'filter_name'].decodeJsonString(
        context: r'StepResult.filter_name',
      ),
      filterType: _$map[r'filter_type'].decodeJsonString(
        context: r'StepResult.filter_type',
      ),
      log: _i4.FilterLog.fromJson(_$map[r'log']),
      skipReason: _$map[r'skip_reason'].decodeJsonNullableString(
        context: r'StepResult.skip_reason',
      ),
      skipped: _$map[r'skipped'].decodeJsonNullableBool(
        context: r'StepResult.skipped',
      ),
    );
  }

  factory StepResult.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StepResult: contains complex types',
    );
  }

  final _i3.String action;

  final _i3.int durationMs;

  final _i3.String? error;

  final _i3.String filterName;

  final _i3.String filterType;

  final _i4.FilterLog log;

  final _i3.String? skipReason;

  final _i3.bool? skipped;

  @_i3.override
  _i3.Object? toJson() => {
    r'action': action,
    r'duration_ms': durationMs,
    if (error != null) r'error': error,
    r'filter_name': filterName,
    r'filter_type': filterType,
    r'log': log.toJson(),
    if (skipReason != null) r'skip_reason': skipReason,
    if (skipped != null) r'skipped': skipped,
  };

  $$StepResultCopyWith<StepResult> get copyWith => _StepResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StepResult &&
        other.action == this.action &&
        other.durationMs == this.durationMs &&
        other.error == this.error &&
        other.filterName == this.filterName &&
        other.filterType == this.filterType &&
        other.log == this.log &&
        other.skipReason == this.skipReason &&
        other.skipped == this.skipped;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      action,
      durationMs,
      error,
      filterName,
      filterType,
      log,
      skipReason,
      skipped,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StepResult: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StepResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$StepResultCopyWith<$Res> {
  factory $$StepResultCopyWith(StepResult value) = _StepResultCopyWith<$Res>;

  $Res call({
    _i3.String? action,
    _i3.int? durationMs,
    _i3.String? error,
    _i3.String? filterName,
    _i3.String? filterType,
    _i4.FilterLog? log,
    _i3.String? skipReason,
    _i3.bool? skipped,
  });
  _i3.String get action;
  _i3.int get durationMs;
  _i3.String? get error;
  _i3.String get filterName;
  _i3.String get filterType;
  _i4.FilterLog get log;
  _i3.String? get skipReason;
  _i3.bool? get skipped;
}

class _StepResultCopyWith<$Res> implements $$StepResultCopyWith<$Res> {
  _StepResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final StepResult _value;

  @_i3.override
  _i3.String get action => _value.action;

  @_i3.override
  _i3.int get durationMs => _value.durationMs;

  @_i3.override
  _i3.String? get error => _value.error;

  @_i3.override
  _i3.String get filterName => _value.filterName;

  @_i3.override
  _i3.String get filterType => _value.filterType;

  @_i3.override
  _i4.FilterLog get log => _value.log;

  @_i3.override
  _i3.String? get skipReason => _value.skipReason;

  @_i3.override
  _i3.bool? get skipped => _value.skipped;

  @_i3.override
  $Res call({
    _i3.Object? action = _sentinel,
    _i3.Object? durationMs = _sentinel,
    _i3.Object? error = _sentinel,
    _i3.Object? filterName = _sentinel,
    _i3.Object? filterType = _sentinel,
    _i3.Object? log = _sentinel,
    _i3.Object? skipReason = _sentinel,
    _i3.Object? skipped = _sentinel,
  }) {
    return (StepResult(
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i3.String),
      durationMs: _i3.identical(durationMs, _sentinel)
          ? this.durationMs
          : (durationMs as _i3.int),
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i3.String?),
      filterName: _i3.identical(filterName, _sentinel)
          ? this.filterName
          : (filterName as _i3.String),
      filterType: _i3.identical(filterType, _sentinel)
          ? this.filterType
          : (filterType as _i3.String),
      log: _i3.identical(log, _sentinel) ? this.log : (log as _i4.FilterLog),
      skipReason: _i3.identical(skipReason, _sentinel)
          ? this.skipReason
          : (skipReason as _i3.String?),
      skipped: _i3.identical(skipped, _sentinel)
          ? this.skipped
          : (skipped as _i3.bool?),
    ) as $Res);
  }
}
