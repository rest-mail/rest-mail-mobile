// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ScriptFailure extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ScriptFailure({required this.error});

  factory ScriptFailure.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'error'},
      listKeys: {},
      context: r'ScriptFailure',
    );
    return ScriptFailure(
      error: _$values[r'error'].decodeSimpleString(
        context: r'ScriptFailure.error',
      ),
    );
  }

  factory ScriptFailure.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ScriptFailure');
    return ScriptFailure(
      error: _$map[r'error'].decodeJsonString(context: r'ScriptFailure.error'),
    );
  }

  factory ScriptFailure.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'error'},
      listKeys: {},
      context: r'ScriptFailure',
    );
    return ScriptFailure(
      error: _$values[r'error'].decodeFormString(
        context: r'ScriptFailure.error',
      ),
    );
  }

  final _i3.String error;

  @_i3.override
  _i3.Object? toJson() => {r'error': error};

  $$ScriptFailureCopyWith<ScriptFailure> get copyWith =>
      _ScriptFailureCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ScriptFailure && other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'error'] = _i1.PropertyValue.scalar(error);
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
      r'Cannot uriEncode ScriptFailure: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ScriptFailureCopyWith<$Res> {
  factory $$ScriptFailureCopyWith(ScriptFailure value) =
      _ScriptFailureCopyWith<$Res>;

  $Res call({_i3.String? error});
  _i3.String get error;
}

class _ScriptFailureCopyWith<$Res> implements $$ScriptFailureCopyWith<$Res> {
  _ScriptFailureCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ScriptFailure _value;

  @_i3.override
  _i3.String get error => _value.error;

  @_i3.override
  $Res call({_i3.Object? error = _sentinel}) {
    return (ScriptFailure(
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i3.String),
    ) as $Res);
  }
}
