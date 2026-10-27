// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TerminalCount extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TerminalCount({
    required this.count,
    required this.direction,
    required this.outcome,
  });

  factory TerminalCount.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'count', r'direction', r'outcome'},
      listKeys: {},
      context: r'TerminalCount',
    );
    return TerminalCount(
      count: _$values[r'count'].decodeSimpleDouble(
        context: r'TerminalCount.count',
      ),
      direction: _$values[r'direction'].decodeSimpleString(
        context: r'TerminalCount.direction',
      ),
      outcome: _$values[r'outcome'].decodeSimpleString(
        context: r'TerminalCount.outcome',
      ),
    );
  }

  factory TerminalCount.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TerminalCount');
    return TerminalCount(
      count: _$map[r'count'].decodeJsonDouble(context: r'TerminalCount.count'),
      direction: _$map[r'direction'].decodeJsonString(
        context: r'TerminalCount.direction',
      ),
      outcome: _$map[r'outcome'].decodeJsonString(
        context: r'TerminalCount.outcome',
      ),
    );
  }

  factory TerminalCount.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'count', r'direction', r'outcome'},
      listKeys: {},
      context: r'TerminalCount',
    );
    return TerminalCount(
      count: _$values[r'count'].decodeFormDouble(
        context: r'TerminalCount.count',
      ),
      direction: _$values[r'direction'].decodeFormString(
        context: r'TerminalCount.direction',
      ),
      outcome: _$values[r'outcome'].decodeFormString(
        context: r'TerminalCount.outcome',
      ),
    );
  }

  final _i3.double count;

  final _i3.String direction;

  final _i3.String outcome;

  @_i3.override
  _i3.Object? toJson() => {
    r'count': count,
    r'direction': direction,
    r'outcome': outcome,
  };

  $$TerminalCountCopyWith<TerminalCount> get copyWith =>
      _TerminalCountCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TerminalCount &&
        other.count == this.count &&
        other.direction == this.direction &&
        other.outcome == this.outcome;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, direction, outcome]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'direction'] = _i1.PropertyValue.scalar(direction);
    _$result[r'outcome'] = _i1.PropertyValue.scalar(outcome);
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
      r'Cannot uriEncode TerminalCount: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TerminalCountCopyWith<$Res> {
  factory $$TerminalCountCopyWith(TerminalCount value) =
      _TerminalCountCopyWith<$Res>;

  $Res call({_i3.double? count, _i3.String? direction, _i3.String? outcome});
  _i3.double get count;
  _i3.String get direction;
  _i3.String get outcome;
}

class _TerminalCountCopyWith<$Res> implements $$TerminalCountCopyWith<$Res> {
  _TerminalCountCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TerminalCount _value;

  @_i3.override
  _i3.double get count => _value.count;

  @_i3.override
  _i3.String get direction => _value.direction;

  @_i3.override
  _i3.String get outcome => _value.outcome;

  @_i3.override
  $Res call({
    _i3.Object? count = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? outcome = _sentinel,
  }) {
    return (TerminalCount(
      count: _i3.identical(count, _sentinel)
          ? this.count
          : (count as _i3.double),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i3.String),
      outcome: _i3.identical(outcome, _sentinel)
          ? this.outcome
          : (outcome as _i3.String),
    ) as $Res);
  }
}
