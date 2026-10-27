// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Quota extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Quota({
    required this.messageCount,
    required this.percentUsed,
    required this.quotaBytes,
    required this.quotaUsedBytes,
  });

  factory Quota.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'message_count',
        r'percent_used',
        r'quota_bytes',
        r'quota_used_bytes',
      },
      listKeys: {},
      context: r'Quota',
    );
    return Quota(
      messageCount: _$values[r'message_count'].decodeSimpleInt(
        context: r'Quota.message_count',
      ),
      percentUsed: _$values[r'percent_used'].decodeSimpleDouble(
        context: r'Quota.percent_used',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeSimpleInt(
        context: r'Quota.quota_bytes',
      ),
      quotaUsedBytes: _$values[r'quota_used_bytes'].decodeSimpleInt(
        context: r'Quota.quota_used_bytes',
      ),
    );
  }

  factory Quota.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Quota');
    return Quota(
      messageCount: _$map[r'message_count'].decodeJsonInt(
        context: r'Quota.message_count',
      ),
      percentUsed: _$map[r'percent_used'].decodeJsonDouble(
        context: r'Quota.percent_used',
      ),
      quotaBytes: _$map[r'quota_bytes'].decodeJsonInt(
        context: r'Quota.quota_bytes',
      ),
      quotaUsedBytes: _$map[r'quota_used_bytes'].decodeJsonInt(
        context: r'Quota.quota_used_bytes',
      ),
    );
  }

  factory Quota.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'message_count',
        r'percent_used',
        r'quota_bytes',
        r'quota_used_bytes',
      },
      listKeys: {},
      context: r'Quota',
    );
    return Quota(
      messageCount: _$values[r'message_count'].decodeFormInt(
        context: r'Quota.message_count',
      ),
      percentUsed: _$values[r'percent_used'].decodeFormDouble(
        context: r'Quota.percent_used',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeFormInt(
        context: r'Quota.quota_bytes',
      ),
      quotaUsedBytes: _$values[r'quota_used_bytes'].decodeFormInt(
        context: r'Quota.quota_used_bytes',
      ),
    );
  }

  final _i3.int messageCount;

  final _i3.double percentUsed;

  final _i3.int quotaBytes;

  final _i3.int quotaUsedBytes;

  @_i3.override
  _i3.Object? toJson() => {
    r'message_count': messageCount,
    r'percent_used': percentUsed,
    r'quota_bytes': quotaBytes,
    r'quota_used_bytes': quotaUsedBytes,
  };

  $$QuotaCopyWith<Quota> get copyWith => _QuotaCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Quota &&
        other.messageCount == this.messageCount &&
        other.percentUsed == this.percentUsed &&
        other.quotaBytes == this.quotaBytes &&
        other.quotaUsedBytes == this.quotaUsedBytes;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      messageCount,
      percentUsed,
      quotaBytes,
      quotaUsedBytes,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'message_count'] = _i1.PropertyValue.scalar(
      messageCount.toString(),
    );
    _$result[r'percent_used'] = _i1.PropertyValue.scalar(
      percentUsed.toString(),
    );
    _$result[r'quota_bytes'] = _i1.PropertyValue.scalar(quotaBytes.toString());
    _$result[r'quota_used_bytes'] = _i1.PropertyValue.scalar(
      quotaUsedBytes.toString(),
    );
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
      r'Cannot uriEncode Quota: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuotaCopyWith<$Res> {
  factory $$QuotaCopyWith(Quota value) = _QuotaCopyWith<$Res>;

  $Res call({
    _i3.int? messageCount,
    _i3.double? percentUsed,
    _i3.int? quotaBytes,
    _i3.int? quotaUsedBytes,
  });
  _i3.int get messageCount;
  _i3.double get percentUsed;
  _i3.int get quotaBytes;
  _i3.int get quotaUsedBytes;
}

class _QuotaCopyWith<$Res> implements $$QuotaCopyWith<$Res> {
  _QuotaCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Quota _value;

  @_i3.override
  _i3.int get messageCount => _value.messageCount;

  @_i3.override
  _i3.double get percentUsed => _value.percentUsed;

  @_i3.override
  _i3.int get quotaBytes => _value.quotaBytes;

  @_i3.override
  _i3.int get quotaUsedBytes => _value.quotaUsedBytes;

  @_i3.override
  $Res call({
    _i3.Object? messageCount = _sentinel,
    _i3.Object? percentUsed = _sentinel,
    _i3.Object? quotaBytes = _sentinel,
    _i3.Object? quotaUsedBytes = _sentinel,
  }) {
    return (Quota(
      messageCount: _i3.identical(messageCount, _sentinel)
          ? this.messageCount
          : (messageCount as _i3.int),
      percentUsed: _i3.identical(percentUsed, _sentinel)
          ? this.percentUsed
          : (percentUsed as _i3.double),
      quotaBytes: _i3.identical(quotaBytes, _sentinel)
          ? this.quotaBytes
          : (quotaBytes as _i3.int),
      quotaUsedBytes: _i3.identical(quotaUsedBytes, _sentinel)
          ? this.quotaUsedBytes
          : (quotaUsedBytes as _i3.int),
    ) as $Res);
  }
}
