// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StageDecisionCount extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StageDecisionCount({
    required this.action,
    required this.count,
    required this.filter,
  });

  factory StageDecisionCount.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'action', r'count', r'filter'},
      listKeys: {},
      context: r'StageDecisionCount',
    );
    return StageDecisionCount(
      action: _$values[r'action'].decodeSimpleString(
        context: r'StageDecisionCount.action',
      ),
      count: _$values[r'count'].decodeSimpleDouble(
        context: r'StageDecisionCount.count',
      ),
      filter: _$values[r'filter'].decodeSimpleString(
        context: r'StageDecisionCount.filter',
      ),
    );
  }

  factory StageDecisionCount.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'StageDecisionCount');
    return StageDecisionCount(
      action: _$map[r'action'].decodeJsonString(
        context: r'StageDecisionCount.action',
      ),
      count: _$map[r'count'].decodeJsonDouble(
        context: r'StageDecisionCount.count',
      ),
      filter: _$map[r'filter'].decodeJsonString(
        context: r'StageDecisionCount.filter',
      ),
    );
  }

  factory StageDecisionCount.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'action', r'count', r'filter'},
      listKeys: {},
      context: r'StageDecisionCount',
    );
    return StageDecisionCount(
      action: _$values[r'action'].decodeFormString(
        context: r'StageDecisionCount.action',
      ),
      count: _$values[r'count'].decodeFormDouble(
        context: r'StageDecisionCount.count',
      ),
      filter: _$values[r'filter'].decodeFormString(
        context: r'StageDecisionCount.filter',
      ),
    );
  }

  final _i3.String action;

  final _i3.double count;

  final _i3.String filter;

  @_i3.override
  _i3.Object? toJson() => {
    r'action': action,
    r'count': count,
    r'filter': filter,
  };

  $$StageDecisionCountCopyWith<StageDecisionCount> get copyWith =>
      _StageDecisionCountCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StageDecisionCount &&
        other.action == this.action &&
        other.count == this.count &&
        other.filter == this.filter;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([action, count, filter]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'action'] = _i1.PropertyValue.scalar(action);
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'filter'] = _i1.PropertyValue.scalar(filter);
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
      r'Cannot uriEncode StageDecisionCount: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$StageDecisionCountCopyWith<$Res> {
  factory $$StageDecisionCountCopyWith(StageDecisionCount value) =
      _StageDecisionCountCopyWith<$Res>;

  $Res call({_i3.String? action, _i3.double? count, _i3.String? filter});
  _i3.String get action;
  _i3.double get count;
  _i3.String get filter;
}

class _StageDecisionCountCopyWith<$Res>
    implements $$StageDecisionCountCopyWith<$Res> {
  _StageDecisionCountCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final StageDecisionCount _value;

  @_i3.override
  _i3.String get action => _value.action;

  @_i3.override
  _i3.double get count => _value.count;

  @_i3.override
  _i3.String get filter => _value.filter;

  @_i3.override
  $Res call({
    _i3.Object? action = _sentinel,
    _i3.Object? count = _sentinel,
    _i3.Object? filter = _sentinel,
  }) {
    return (StageDecisionCount(
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i3.String),
      count: _i3.identical(count, _sentinel)
          ? this.count
          : (count as _i3.double),
      filter: _i3.identical(filter, _sentinel)
          ? this.filter
          : (filter as _i3.String),
    ) as $Res);
  }
}
