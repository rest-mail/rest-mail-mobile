// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QueueStatistics extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QueueStatistics({
    required this.bounced,
    required this.$deferred,
    required this.delivered,
    required this.pending,
    required this.total,
    this.delivering,
    this.expired,
  });

  factory QueueStatistics.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'bounced',
        r'deferred',
        r'delivered',
        r'delivering',
        r'expired',
        r'pending',
        r'total',
      },
      listKeys: {},
      context: r'QueueStatistics',
    );
    return QueueStatistics(
      bounced: _$values[r'bounced'].decodeSimpleInt(
        context: r'QueueStatistics.bounced',
      ),
      $deferred: _$values[r'deferred'].decodeSimpleInt(
        context: r'QueueStatistics.deferred',
      ),
      delivered: _$values[r'delivered'].decodeSimpleInt(
        context: r'QueueStatistics.delivered',
      ),
      delivering: _$values[r'delivering'].decodeSimpleNullableInt(
        context: r'QueueStatistics.delivering',
      ),
      expired: _$values[r'expired'].decodeSimpleNullableInt(
        context: r'QueueStatistics.expired',
      ),
      pending: _$values[r'pending'].decodeSimpleInt(
        context: r'QueueStatistics.pending',
      ),
      total: _$values[r'total'].decodeSimpleInt(
        context: r'QueueStatistics.total',
      ),
    );
  }

  factory QueueStatistics.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QueueStatistics');
    return QueueStatistics(
      bounced: _$map[r'bounced'].decodeJsonInt(
        context: r'QueueStatistics.bounced',
      ),
      $deferred: _$map[r'deferred'].decodeJsonInt(
        context: r'QueueStatistics.deferred',
      ),
      delivered: _$map[r'delivered'].decodeJsonInt(
        context: r'QueueStatistics.delivered',
      ),
      delivering: _$map[r'delivering'].decodeJsonNullableInt(
        context: r'QueueStatistics.delivering',
      ),
      expired: _$map[r'expired'].decodeJsonNullableInt(
        context: r'QueueStatistics.expired',
      ),
      pending: _$map[r'pending'].decodeJsonInt(
        context: r'QueueStatistics.pending',
      ),
      total: _$map[r'total'].decodeJsonInt(context: r'QueueStatistics.total'),
    );
  }

  factory QueueStatistics.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'bounced',
        r'deferred',
        r'delivered',
        r'delivering',
        r'expired',
        r'pending',
        r'total',
      },
      listKeys: {},
      context: r'QueueStatistics',
    );
    return QueueStatistics(
      bounced: _$values[r'bounced'].decodeFormInt(
        context: r'QueueStatistics.bounced',
      ),
      $deferred: _$values[r'deferred'].decodeFormInt(
        context: r'QueueStatistics.deferred',
      ),
      delivered: _$values[r'delivered'].decodeFormInt(
        context: r'QueueStatistics.delivered',
      ),
      delivering: _$values[r'delivering'].decodeFormNullableInt(
        context: r'QueueStatistics.delivering',
      ),
      expired: _$values[r'expired'].decodeFormNullableInt(
        context: r'QueueStatistics.expired',
      ),
      pending: _$values[r'pending'].decodeFormInt(
        context: r'QueueStatistics.pending',
      ),
      total: _$values[r'total'].decodeFormInt(
        context: r'QueueStatistics.total',
      ),
    );
  }

  final _i3.int bounced;

  final _i3.int $deferred;

  final _i3.int delivered;

  final _i3.int? delivering;

  final _i3.int? expired;

  final _i3.int pending;

  final _i3.int total;

  @_i3.override
  _i3.Object? toJson() => {
    r'bounced': bounced,
    r'deferred': $deferred,
    r'delivered': delivered,
    if (delivering != null) r'delivering': delivering,
    if (expired != null) r'expired': expired,
    r'pending': pending,
    r'total': total,
  };

  $$QueueStatisticsCopyWith<QueueStatistics> get copyWith =>
      _QueueStatisticsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QueueStatistics &&
        other.bounced == this.bounced &&
        other.$deferred == this.$deferred &&
        other.delivered == this.delivered &&
        other.delivering == this.delivering &&
        other.expired == this.expired &&
        other.pending == this.pending &&
        other.total == this.total;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      bounced,
      $deferred,
      delivered,
      delivering,
      expired,
      pending,
      total,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'bounced'] = _i1.PropertyValue.scalar(bounced.toString());
    _$result[r'deferred'] = _i1.PropertyValue.scalar($deferred.toString());
    _$result[r'delivered'] = _i1.PropertyValue.scalar(delivered.toString());
    if (delivering != null) {
      _$result[r'delivering'] = _i1.PropertyValue.scalar(
        delivering!.toString(),
      );
    }
    if (expired != null) {
      _$result[r'expired'] = _i1.PropertyValue.scalar(expired!.toString());
    }
    _$result[r'pending'] = _i1.PropertyValue.scalar(pending.toString());
    _$result[r'total'] = _i1.PropertyValue.scalar(total.toString());
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
      r'Cannot uriEncode QueueStatistics: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QueueStatisticsCopyWith<$Res> {
  factory $$QueueStatisticsCopyWith(QueueStatistics value) =
      _QueueStatisticsCopyWith<$Res>;

  $Res call({
    _i3.int? bounced,
    _i3.int? $deferred,
    _i3.int? delivered,
    _i3.int? delivering,
    _i3.int? expired,
    _i3.int? pending,
    _i3.int? total,
  });
  _i3.int get bounced;
  _i3.int get $deferred;
  _i3.int get delivered;
  _i3.int? get delivering;
  _i3.int? get expired;
  _i3.int get pending;
  _i3.int get total;
}

class _QueueStatisticsCopyWith<$Res>
    implements $$QueueStatisticsCopyWith<$Res> {
  _QueueStatisticsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QueueStatistics _value;

  @_i3.override
  _i3.int get bounced => _value.bounced;

  @_i3.override
  _i3.int get $deferred => _value.$deferred;

  @_i3.override
  _i3.int get delivered => _value.delivered;

  @_i3.override
  _i3.int? get delivering => _value.delivering;

  @_i3.override
  _i3.int? get expired => _value.expired;

  @_i3.override
  _i3.int get pending => _value.pending;

  @_i3.override
  _i3.int get total => _value.total;

  @_i3.override
  $Res call({
    _i3.Object? bounced = _sentinel,
    _i3.Object? $deferred = _sentinel,
    _i3.Object? delivered = _sentinel,
    _i3.Object? delivering = _sentinel,
    _i3.Object? expired = _sentinel,
    _i3.Object? pending = _sentinel,
    _i3.Object? total = _sentinel,
  }) {
    return (QueueStatistics(
      bounced: _i3.identical(bounced, _sentinel)
          ? this.bounced
          : (bounced as _i3.int),
      $deferred: _i3.identical($deferred, _sentinel)
          ? this.$deferred
          : ($deferred as _i3.int),
      delivered: _i3.identical(delivered, _sentinel)
          ? this.delivered
          : (delivered as _i3.int),
      delivering: _i3.identical(delivering, _sentinel)
          ? this.delivering
          : (delivering as _i3.int?),
      expired: _i3.identical(expired, _sentinel)
          ? this.expired
          : (expired as _i3.int?),
      pending: _i3.identical(pending, _sentinel)
          ? this.pending
          : (pending as _i3.int),
      total: _i3.identical(total, _sentinel) ? this.total : (total as _i3.int),
    ) as $Res);
  }
}
