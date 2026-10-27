// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QueueStats extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QueueStats({
    required this.failed,
    required this.pending,
    required this.processing,
  });

  factory QueueStats.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'failed', r'pending', r'processing'},
      listKeys: {},
      context: r'QueueStats',
    );
    return QueueStats(
      failed: _$values[r'failed'].decodeSimpleInt(
        context: r'QueueStats.failed',
      ),
      pending: _$values[r'pending'].decodeSimpleInt(
        context: r'QueueStats.pending',
      ),
      processing: _$values[r'processing'].decodeSimpleInt(
        context: r'QueueStats.processing',
      ),
    );
  }

  factory QueueStats.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QueueStats');
    return QueueStats(
      failed: _$map[r'failed'].decodeJsonInt(context: r'QueueStats.failed'),
      pending: _$map[r'pending'].decodeJsonInt(context: r'QueueStats.pending'),
      processing: _$map[r'processing'].decodeJsonInt(
        context: r'QueueStats.processing',
      ),
    );
  }

  factory QueueStats.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'failed', r'pending', r'processing'},
      listKeys: {},
      context: r'QueueStats',
    );
    return QueueStats(
      failed: _$values[r'failed'].decodeFormInt(context: r'QueueStats.failed'),
      pending: _$values[r'pending'].decodeFormInt(
        context: r'QueueStats.pending',
      ),
      processing: _$values[r'processing'].decodeFormInt(
        context: r'QueueStats.processing',
      ),
    );
  }

  final _i3.int failed;

  final _i3.int pending;

  final _i3.int processing;

  @_i3.override
  _i3.Object? toJson() => {
    r'failed': failed,
    r'pending': pending,
    r'processing': processing,
  };

  $$QueueStatsCopyWith<QueueStats> get copyWith => _QueueStatsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QueueStats &&
        other.failed == this.failed &&
        other.pending == this.pending &&
        other.processing == this.processing;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([failed, pending, processing]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'failed'] = _i1.PropertyValue.scalar(failed.toString());
    _$result[r'pending'] = _i1.PropertyValue.scalar(pending.toString());
    _$result[r'processing'] = _i1.PropertyValue.scalar(processing.toString());
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
      r'Cannot uriEncode QueueStats: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QueueStatsCopyWith<$Res> {
  factory $$QueueStatsCopyWith(QueueStats value) = _QueueStatsCopyWith<$Res>;

  $Res call({_i3.int? failed, _i3.int? pending, _i3.int? processing});
  _i3.int get failed;
  _i3.int get pending;
  _i3.int get processing;
}

class _QueueStatsCopyWith<$Res> implements $$QueueStatsCopyWith<$Res> {
  _QueueStatsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QueueStats _value;

  @_i3.override
  _i3.int get failed => _value.failed;

  @_i3.override
  _i3.int get pending => _value.pending;

  @_i3.override
  _i3.int get processing => _value.processing;

  @_i3.override
  $Res call({
    _i3.Object? failed = _sentinel,
    _i3.Object? pending = _sentinel,
    _i3.Object? processing = _sentinel,
  }) {
    return (QueueStats(
      failed: _i3.identical(failed, _sentinel)
          ? this.failed
          : (failed as _i3.int),
      pending: _i3.identical(pending, _sentinel)
          ? this.pending
          : (pending as _i3.int),
      processing: _i3.identical(processing, _sentinel)
          ? this.processing
          : (processing as _i3.int),
    ) as $Res);
  }
}
