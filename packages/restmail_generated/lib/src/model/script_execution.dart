// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ScriptExecution extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ScriptExecution({required this.logs, required this.result});

  factory ScriptExecution.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'logs', r'result'},
      listKeys: {r'logs'},
      context: r'ScriptExecution',
    );
    return ScriptExecution(
      logs: _$values[r'logs'].decodeSimpleStringList(
        context: r'ScriptExecution.logs',
      ),
      result: _$values[r'result'],
    );
  }

  factory ScriptExecution.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ScriptExecution');
    return ScriptExecution(
      logs: _$map[r'logs'].decodeJsonList<_i3.String>(
        context: r'ScriptExecution.logs',
      ),
      result: _$map[r'result'],
    );
  }

  factory ScriptExecution.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'logs', r'result'},
      listKeys: {r'logs'},
      context: r'ScriptExecution',
    );
    return ScriptExecution(
      logs: _$values[r'logs'].decodeFormStringList(
        context: r'ScriptExecution.logs',
      ),
      result: _$values[r'result'].decodeFormNullableString(
        context: r'ScriptExecution.result',
      ),
    );
  }

  final _i3.List<_i3.String> logs;

  final _i3.Object? result;

  @_i3.override
  _i3.Object? toJson() => {
    r'logs': logs,
    r'result': _i1.encodeUnknownJson(
      result,
      context: r'ScriptExecution.result',
    ),
  };

  $$ScriptExecutionCopyWith<ScriptExecution> get copyWith =>
      _ScriptExecutionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ScriptExecution &&
        _$deepEquals.equals(other.logs, this.logs) &&
        other.result == this.result;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(logs), result]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
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
      r'Cannot uriEncode ScriptExecution: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ScriptExecutionCopyWith<$Res> {
  factory $$ScriptExecutionCopyWith(ScriptExecution value) =
      _ScriptExecutionCopyWith<$Res>;

  $Res call({_i3.List<_i3.String>? logs, _i3.Object? result});
  _i3.List<_i3.String> get logs;
  _i3.Object? get result;
}

class _ScriptExecutionCopyWith<$Res>
    implements $$ScriptExecutionCopyWith<$Res> {
  _ScriptExecutionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ScriptExecution _value;

  @_i3.override
  _i3.List<_i3.String> get logs => _value.logs;

  @_i3.override
  _i3.Object? get result => _value.result;

  @_i3.override
  $Res call({_i3.Object? logs = _sentinel, _i3.Object? result = _sentinel}) {
    return (ScriptExecution(
      logs: _i3.identical(logs, _sentinel)
          ? this.logs
          : (logs as _i3.List<_i3.String>),
      result: _i3.identical(result, _sentinel) ? this.result : result,
    ) as $Res);
  }
}
