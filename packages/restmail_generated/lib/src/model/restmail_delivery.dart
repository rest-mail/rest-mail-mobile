// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDelivery extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDelivery({required this.delivered, required this.failed});

  factory RestmailDelivery.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'delivered', r'failed'},
      listKeys: {r'delivered', r'failed'},
      context: r'RestmailDelivery',
    );
    return RestmailDelivery(
      delivered: _$values[r'delivered'].decodeSimpleStringList(
        context: r'RestmailDelivery.delivered',
      ),
      failed: _$values[r'failed'].decodeSimpleStringList(
        context: r'RestmailDelivery.failed',
      ),
    );
  }

  factory RestmailDelivery.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDelivery');
    return RestmailDelivery(
      delivered: _$map[r'delivered'].decodeJsonList<_i3.String>(
        context: r'RestmailDelivery.delivered',
      ),
      failed: _$map[r'failed'].decodeJsonList<_i3.String>(
        context: r'RestmailDelivery.failed',
      ),
    );
  }

  factory RestmailDelivery.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'delivered', r'failed'},
      listKeys: {r'delivered', r'failed'},
      context: r'RestmailDelivery',
    );
    return RestmailDelivery(
      delivered: _$values[r'delivered'].decodeFormStringList(
        context: r'RestmailDelivery.delivered',
      ),
      failed: _$values[r'failed'].decodeFormStringList(
        context: r'RestmailDelivery.failed',
      ),
    );
  }

  final _i3.List<_i3.String> delivered;

  final _i3.List<_i3.String> failed;

  @_i3.override
  _i3.Object? toJson() => {r'delivered': delivered, r'failed': failed};

  $$RestmailDeliveryCopyWith<RestmailDelivery> get copyWith =>
      _RestmailDeliveryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is RestmailDelivery &&
        _$deepEquals.equals(other.delivered, this.delivered) &&
        _$deepEquals.equals(other.failed, this.failed);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(delivered),
      deepEquals.hash(failed),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'delivered'] = _i1.PropertyValue.array(delivered);
    _$result[r'failed'] = _i1.PropertyValue.array(failed);
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
      r'Cannot uriEncode RestmailDelivery: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDeliveryCopyWith<$Res> {
  factory $$RestmailDeliveryCopyWith(RestmailDelivery value) =
      _RestmailDeliveryCopyWith<$Res>;

  $Res call({_i3.List<_i3.String>? delivered, _i3.List<_i3.String>? failed});
  _i3.List<_i3.String> get delivered;
  _i3.List<_i3.String> get failed;
}

class _RestmailDeliveryCopyWith<$Res>
    implements $$RestmailDeliveryCopyWith<$Res> {
  _RestmailDeliveryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDelivery _value;

  @_i3.override
  _i3.List<_i3.String> get delivered => _value.delivered;

  @_i3.override
  _i3.List<_i3.String> get failed => _value.failed;

  @_i3.override
  $Res call({
    _i3.Object? delivered = _sentinel,
    _i3.Object? failed = _sentinel,
  }) {
    return (RestmailDelivery(
      delivered: _i3.identical(delivered, _sentinel)
          ? this.delivered
          : (delivered as _i3.List<_i3.String>),
      failed: _i3.identical(failed, _sentinel)
          ? this.failed
          : (failed as _i3.List<_i3.String>),
    ) as $Res);
  }
}
