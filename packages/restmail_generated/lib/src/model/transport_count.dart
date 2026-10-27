// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TransportCount extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TransportCount({required this.count, required this.transport});

  factory TransportCount.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'count', r'transport'},
      listKeys: {},
      context: r'TransportCount',
    );
    return TransportCount(
      count: _$values[r'count'].decodeSimpleDouble(
        context: r'TransportCount.count',
      ),
      transport: _$values[r'transport'].decodeSimpleString(
        context: r'TransportCount.transport',
      ),
    );
  }

  factory TransportCount.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TransportCount');
    return TransportCount(
      count: _$map[r'count'].decodeJsonDouble(context: r'TransportCount.count'),
      transport: _$map[r'transport'].decodeJsonString(
        context: r'TransportCount.transport',
      ),
    );
  }

  factory TransportCount.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'count', r'transport'},
      listKeys: {},
      context: r'TransportCount',
    );
    return TransportCount(
      count: _$values[r'count'].decodeFormDouble(
        context: r'TransportCount.count',
      ),
      transport: _$values[r'transport'].decodeFormString(
        context: r'TransportCount.transport',
      ),
    );
  }

  final _i3.double count;

  final _i3.String transport;

  @_i3.override
  _i3.Object? toJson() => {r'count': count, r'transport': transport};

  $$TransportCountCopyWith<TransportCount> get copyWith =>
      _TransportCountCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TransportCount &&
        other.count == this.count &&
        other.transport == this.transport;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, transport]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'transport'] = _i1.PropertyValue.scalar(transport);
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
      r'Cannot uriEncode TransportCount: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TransportCountCopyWith<$Res> {
  factory $$TransportCountCopyWith(TransportCount value) =
      _TransportCountCopyWith<$Res>;

  $Res call({_i3.double? count, _i3.String? transport});
  _i3.double get count;
  _i3.String get transport;
}

class _TransportCountCopyWith<$Res> implements $$TransportCountCopyWith<$Res> {
  _TransportCountCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TransportCount _value;

  @_i3.override
  _i3.double get count => _value.count;

  @_i3.override
  _i3.String get transport => _value.transport;

  @_i3.override
  $Res call({
    _i3.Object? count = _sentinel,
    _i3.Object? transport = _sentinel,
  }) {
    return (TransportCount(
      count: _i3.identical(count, _sentinel)
          ? this.count
          : (count as _i3.double),
      transport: _i3.identical(transport, _sentinel)
          ? this.transport
          : (transport as _i3.String),
    ) as $Res);
  }
}
