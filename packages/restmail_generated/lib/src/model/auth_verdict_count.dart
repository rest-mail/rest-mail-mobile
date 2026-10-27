// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AuthVerdictCount extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AuthVerdictCount({
    required this.count,
    required this.mechanism,
    required this.result,
  });

  factory AuthVerdictCount.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'count', r'mechanism', r'result'},
      listKeys: {},
      context: r'AuthVerdictCount',
    );
    return AuthVerdictCount(
      count: _$values[r'count'].decodeSimpleDouble(
        context: r'AuthVerdictCount.count',
      ),
      mechanism: _$values[r'mechanism'].decodeSimpleString(
        context: r'AuthVerdictCount.mechanism',
      ),
      result: _$values[r'result'].decodeSimpleString(
        context: r'AuthVerdictCount.result',
      ),
    );
  }

  factory AuthVerdictCount.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AuthVerdictCount');
    return AuthVerdictCount(
      count: _$map[r'count'].decodeJsonDouble(
        context: r'AuthVerdictCount.count',
      ),
      mechanism: _$map[r'mechanism'].decodeJsonString(
        context: r'AuthVerdictCount.mechanism',
      ),
      result: _$map[r'result'].decodeJsonString(
        context: r'AuthVerdictCount.result',
      ),
    );
  }

  factory AuthVerdictCount.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'count', r'mechanism', r'result'},
      listKeys: {},
      context: r'AuthVerdictCount',
    );
    return AuthVerdictCount(
      count: _$values[r'count'].decodeFormDouble(
        context: r'AuthVerdictCount.count',
      ),
      mechanism: _$values[r'mechanism'].decodeFormString(
        context: r'AuthVerdictCount.mechanism',
      ),
      result: _$values[r'result'].decodeFormString(
        context: r'AuthVerdictCount.result',
      ),
    );
  }

  final _i3.double count;

  final _i3.String mechanism;

  final _i3.String result;

  @_i3.override
  _i3.Object? toJson() => {
    r'count': count,
    r'mechanism': mechanism,
    r'result': result,
  };

  $$AuthVerdictCountCopyWith<AuthVerdictCount> get copyWith =>
      _AuthVerdictCountCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AuthVerdictCount &&
        other.count == this.count &&
        other.mechanism == this.mechanism &&
        other.result == this.result;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, mechanism, result]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'mechanism'] = _i1.PropertyValue.scalar(mechanism);
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
      r'Cannot uriEncode AuthVerdictCount: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AuthVerdictCountCopyWith<$Res> {
  factory $$AuthVerdictCountCopyWith(AuthVerdictCount value) =
      _AuthVerdictCountCopyWith<$Res>;

  $Res call({_i3.double? count, _i3.String? mechanism, _i3.String? result});
  _i3.double get count;
  _i3.String get mechanism;
  _i3.String get result;
}

class _AuthVerdictCountCopyWith<$Res>
    implements $$AuthVerdictCountCopyWith<$Res> {
  _AuthVerdictCountCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AuthVerdictCount _value;

  @_i3.override
  _i3.double get count => _value.count;

  @_i3.override
  _i3.String get mechanism => _value.mechanism;

  @_i3.override
  _i3.String get result => _value.result;

  @_i3.override
  $Res call({
    _i3.Object? count = _sentinel,
    _i3.Object? mechanism = _sentinel,
    _i3.Object? result = _sentinel,
  }) {
    return (AuthVerdictCount(
      count: _i3.identical(count, _sentinel)
          ? this.count
          : (count as _i3.double),
      mechanism: _i3.identical(mechanism, _sentinel)
          ? this.mechanism
          : (mechanism as _i3.String),
      result: _i3.identical(result, _sentinel)
          ? this.result
          : (result as _i3.String),
    ) as $Res);
  }
}
