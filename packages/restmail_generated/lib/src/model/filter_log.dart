// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FilterLog extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FilterLog({
    required this.filter,
    required this.result,
    this.detail,
    this.durationMs,
  });

  factory FilterLog.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'detail', r'duration_ms', r'filter', r'result'},
      listKeys: {},
      context: r'FilterLog',
    );
    return FilterLog(
      detail: _$values[r'detail'].decodeSimpleNullableString(
        context: r'FilterLog.detail',
      ),
      durationMs: _$values[r'duration_ms'].decodeSimpleNullableInt(
        context: r'FilterLog.duration_ms',
      ),
      filter: _$values[r'filter'].decodeSimpleString(
        context: r'FilterLog.filter',
      ),
      result: _$values[r'result'].decodeSimpleString(
        context: r'FilterLog.result',
      ),
    );
  }

  factory FilterLog.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FilterLog');
    return FilterLog(
      detail: _$map[r'detail'].decodeJsonNullableString(
        context: r'FilterLog.detail',
      ),
      durationMs: _$map[r'duration_ms'].decodeJsonNullableInt(
        context: r'FilterLog.duration_ms',
      ),
      filter: _$map[r'filter'].decodeJsonString(context: r'FilterLog.filter'),
      result: _$map[r'result'].decodeJsonString(context: r'FilterLog.result'),
    );
  }

  factory FilterLog.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'detail', r'duration_ms', r'filter', r'result'},
      listKeys: {},
      context: r'FilterLog',
    );
    return FilterLog(
      detail: _$values[r'detail'].decodeFormNullableString(
        context: r'FilterLog.detail',
      ),
      durationMs: _$values[r'duration_ms'].decodeFormNullableInt(
        context: r'FilterLog.duration_ms',
      ),
      filter: _$values[r'filter'].decodeFormString(
        context: r'FilterLog.filter',
      ),
      result: _$values[r'result'].decodeFormString(
        context: r'FilterLog.result',
      ),
    );
  }

  final _i3.String? detail;

  final _i3.int? durationMs;

  final _i3.String filter;

  final _i3.String result;

  @_i3.override
  _i3.Object? toJson() => {
    if (detail != null) r'detail': detail,
    if (durationMs != null) r'duration_ms': durationMs,
    r'filter': filter,
    r'result': result,
  };

  $$FilterLogCopyWith<FilterLog> get copyWith => _FilterLogCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FilterLog &&
        other.detail == this.detail &&
        other.durationMs == this.durationMs &&
        other.filter == this.filter &&
        other.result == this.result;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([detail, durationMs, filter, result]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (detail != null) {
      _$result[r'detail'] = _i1.PropertyValue.scalar(detail!);
    }
    if (durationMs != null) {
      _$result[r'duration_ms'] = _i1.PropertyValue.scalar(
        durationMs!.toString(),
      );
    }
    _$result[r'filter'] = _i1.PropertyValue.scalar(filter);
    _$result[r'result'] = _i1.PropertyValue.scalar(result);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FilterLog: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$FilterLogCopyWith<$Res> {
  factory $$FilterLogCopyWith(FilterLog value) = _FilterLogCopyWith<$Res>;

  $Res call({
    _i3.String? detail,
    _i3.int? durationMs,
    _i3.String? filter,
    _i3.String? result,
  });
  _i3.String? get detail;
  _i3.int? get durationMs;
  _i3.String get filter;
  _i3.String get result;
}

class _FilterLogCopyWith<$Res> implements $$FilterLogCopyWith<$Res> {
  _FilterLogCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final FilterLog _value;

  @_i3.override
  _i3.String? get detail => _value.detail;

  @_i3.override
  _i3.int? get durationMs => _value.durationMs;

  @_i3.override
  _i3.String get filter => _value.filter;

  @_i3.override
  _i3.String get result => _value.result;

  @_i3.override
  $Res call({
    _i3.Object? detail = _sentinel,
    _i3.Object? durationMs = _sentinel,
    _i3.Object? filter = _sentinel,
    _i3.Object? result = _sentinel,
  }) {
    return (FilterLog(
      detail: _i3.identical(detail, _sentinel)
          ? this.detail
          : (detail as _i3.String?),
      durationMs: _i3.identical(durationMs, _sentinel)
          ? this.durationMs
          : (durationMs as _i3.int?),
      filter: _i3.identical(filter, _sentinel)
          ? this.filter
          : (filter as _i3.String),
      result: _i3.identical(result, _sentinel)
          ? this.result
          : (result as _i3.String),
    ) as $Res);
  }
}
