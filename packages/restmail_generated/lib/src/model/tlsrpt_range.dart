// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsrptRange extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsrptRange({required this.endDatetime, required this.startDatetime});

  factory TlsrptRange.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'end-datetime', r'start-datetime'},
      listKeys: {},
      context: r'TlsrptRange',
    );
    return TlsrptRange(
      endDatetime: _$values[r'end-datetime'].decodeSimpleDateTime(
        context: r'TlsrptRange.end-datetime',
      ),
      startDatetime: _$values[r'start-datetime'].decodeSimpleDateTime(
        context: r'TlsrptRange.start-datetime',
      ),
    );
  }

  factory TlsrptRange.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsrptRange');
    return TlsrptRange(
      endDatetime: _$map[r'end-datetime'].decodeJsonDateTime(
        context: r'TlsrptRange.end-datetime',
      ),
      startDatetime: _$map[r'start-datetime'].decodeJsonDateTime(
        context: r'TlsrptRange.start-datetime',
      ),
    );
  }

  factory TlsrptRange.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'end-datetime', r'start-datetime'},
      listKeys: {},
      context: r'TlsrptRange',
    );
    return TlsrptRange(
      endDatetime: _$values[r'end-datetime'].decodeFormDateTime(
        context: r'TlsrptRange.end-datetime',
      ),
      startDatetime: _$values[r'start-datetime'].decodeFormDateTime(
        context: r'TlsrptRange.start-datetime',
      ),
    );
  }

  final _i3.DateTime endDatetime;

  final _i3.DateTime startDatetime;

  @_i3.override
  _i3.Object? toJson() => {
    r'end-datetime': endDatetime.toTimeZonedIso8601String(),
    r'start-datetime': startDatetime.toTimeZonedIso8601String(),
  };

  $$TlsrptRangeCopyWith<TlsrptRange> get copyWith => _TlsrptRangeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsrptRange &&
        other.endDatetime == this.endDatetime &&
        other.startDatetime == this.startDatetime;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([endDatetime, startDatetime]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'end-datetime'] = _i1.PropertyValue.scalar(
      endDatetime.toTimeZonedIso8601String(),
    );
    _$result[r'start-datetime'] = _i1.PropertyValue.scalar(
      startDatetime.toTimeZonedIso8601String(),
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
      r'Cannot uriEncode TlsrptRange: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsrptRangeCopyWith<$Res> {
  factory $$TlsrptRangeCopyWith(TlsrptRange value) = _TlsrptRangeCopyWith<$Res>;

  $Res call({_i3.DateTime? endDatetime, _i3.DateTime? startDatetime});
  _i3.DateTime get endDatetime;
  _i3.DateTime get startDatetime;
}

class _TlsrptRangeCopyWith<$Res> implements $$TlsrptRangeCopyWith<$Res> {
  _TlsrptRangeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsrptRange _value;

  @_i3.override
  _i3.DateTime get endDatetime => _value.endDatetime;

  @_i3.override
  _i3.DateTime get startDatetime => _value.startDatetime;

  @_i3.override
  $Res call({
    _i3.Object? endDatetime = _sentinel,
    _i3.Object? startDatetime = _sentinel,
  }) {
    return (TlsrptRange(
      endDatetime: _i3.identical(endDatetime, _sentinel)
          ? this.endDatetime
          : (endDatetime as _i3.DateTime),
      startDatetime: _i3.identical(startDatetime, _sentinel)
          ? this.startDatetime
          : (startDatetime as _i3.DateTime),
    ) as $Res);
  }
}
