// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ScriptResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ScriptResult({required this.logs, this.error, this.result});

  factory ScriptResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'error', r'logs', r'result'},
      listKeys: {r'logs'},
      context: r'ScriptResult',
    );
    return ScriptResult(
      error: _$values[r'error'].decodeSimpleNullableString(
        context: r'ScriptResult.error',
      ),
      logs: _$values[r'logs'].decodeSimpleStringList(
        context: r'ScriptResult.logs',
      ),
      result: _$values[r'result'],
    );
  }

  factory ScriptResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ScriptResult');
    return ScriptResult(
      error: _$map[r'error'].decodeJsonNullableString(
        context: r'ScriptResult.error',
      ),
      logs: _$map[r'logs'].decodeJsonList<_i3.String>(
        context: r'ScriptResult.logs',
      ),
      result: _$map[r'result'],
    );
  }

  factory ScriptResult.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'error', r'logs', r'result'},
      listKeys: {r'logs'},
      context: r'ScriptResult',
    );
    return ScriptResult(
      error: _$values[r'error'].decodeFormNullableString(
        context: r'ScriptResult.error',
      ),
      logs: _$values[r'logs'].decodeFormStringList(
        context: r'ScriptResult.logs',
      ),
      result: _$values[r'result'].decodeFormNullableString(
        context: r'ScriptResult.result',
      ),
    );
  }

  final _i3.String? error;

  final _i3.List<_i3.String> logs;

  final _i3.Object? result;

  @_i3.override
  _i3.Object? toJson() => {
    if (error != null) r'error': error,
    r'logs': logs,
    if (result != null)
      r'result': _i1.encodeUnknownJson(result, context: r'ScriptResult.result'),
  };

  $$ScriptResultCopyWith<ScriptResult> get copyWith =>
      _ScriptResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ScriptResult &&
        other.error == this.error &&
        _$deepEquals.equals(other.logs, this.logs) &&
        other.result == this.result;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([error, deepEquals.hash(logs), result]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (error != null) {
      _$result[r'error'] = _i1.PropertyValue.scalar(error!);
    }
    _$result[r'logs'] = _i1.PropertyValue.array(logs);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ScriptResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ScriptResultCopyWith<$Res> {
  factory $$ScriptResultCopyWith(ScriptResult value) =
      _ScriptResultCopyWith<$Res>;

  $Res call({
    _i3.String? error,
    _i3.List<_i3.String>? logs,
    _i3.Object? result,
  });
  _i3.String? get error;
  _i3.List<_i3.String> get logs;
  _i3.Object? get result;
}

class _ScriptResultCopyWith<$Res> implements $$ScriptResultCopyWith<$Res> {
  _ScriptResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ScriptResult _value;

  @_i3.override
  _i3.String? get error => _value.error;

  @_i3.override
  _i3.List<_i3.String> get logs => _value.logs;

  @_i3.override
  _i3.Object? get result => _value.result;

  @_i3.override
  $Res call({
    _i3.Object? error = _sentinel,
    _i3.Object? logs = _sentinel,
    _i3.Object? result = _sentinel,
  }) {
    return (ScriptResult(
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i3.String?),
      logs: _i3.identical(logs, _sentinel)
          ? this.logs
          : (logs as _i3.List<_i3.String>),
      result: _i3.identical(result, _sentinel) ? this.result : result,
    ) as $Res);
  }
}
