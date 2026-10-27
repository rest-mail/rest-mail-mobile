// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsrptSummary extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsrptSummary({
    this.totalFailureSessionCount,
    this.totalSuccessfulSessionCount,
  });

  factory TlsrptSummary.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'total-failure-session-count',
        r'total-successful-session-count',
      },
      listKeys: {},
      context: r'TlsrptSummary',
    );
    return TlsrptSummary(
      totalFailureSessionCount: _$values[r'total-failure-session-count']
          .decodeSimpleNullableInt(
            context: r'TlsrptSummary.total-failure-session-count',
          ),
      totalSuccessfulSessionCount: _$values[r'total-successful-session-count']
          .decodeSimpleNullableInt(
            context: r'TlsrptSummary.total-successful-session-count',
          ),
    );
  }

  factory TlsrptSummary.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsrptSummary');
    return TlsrptSummary(
      totalFailureSessionCount: _$map[r'total-failure-session-count']
          .decodeJsonNullableInt(
            context: r'TlsrptSummary.total-failure-session-count',
          ),
      totalSuccessfulSessionCount: _$map[r'total-successful-session-count']
          .decodeJsonNullableInt(
            context: r'TlsrptSummary.total-successful-session-count',
          ),
    );
  }

  factory TlsrptSummary.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'total-failure-session-count',
        r'total-successful-session-count',
      },
      listKeys: {},
      context: r'TlsrptSummary',
    );
    return TlsrptSummary(
      totalFailureSessionCount: _$values[r'total-failure-session-count']
          .decodeFormNullableInt(
            context: r'TlsrptSummary.total-failure-session-count',
          ),
      totalSuccessfulSessionCount: _$values[r'total-successful-session-count']
          .decodeFormNullableInt(
            context: r'TlsrptSummary.total-successful-session-count',
          ),
    );
  }

  final _i3.int? totalFailureSessionCount;

  final _i3.int? totalSuccessfulSessionCount;

  @_i3.override
  _i3.Object? toJson() => {
    if (totalFailureSessionCount != null)
      r'total-failure-session-count': totalFailureSessionCount,
    if (totalSuccessfulSessionCount != null)
      r'total-successful-session-count': totalSuccessfulSessionCount,
  };

  $$TlsrptSummaryCopyWith<TlsrptSummary> get copyWith =>
      _TlsrptSummaryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsrptSummary &&
        other.totalFailureSessionCount == this.totalFailureSessionCount &&
        other.totalSuccessfulSessionCount == this.totalSuccessfulSessionCount;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      totalFailureSessionCount,
      totalSuccessfulSessionCount,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (totalFailureSessionCount != null) {
      _$result[r'total-failure-session-count'] = _i1.PropertyValue.scalar(
        totalFailureSessionCount!.toString(),
      );
    }
    if (totalSuccessfulSessionCount != null) {
      _$result[r'total-successful-session-count'] = _i1.PropertyValue.scalar(
        totalSuccessfulSessionCount!.toString(),
      );
    }
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
      r'Cannot uriEncode TlsrptSummary: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsrptSummaryCopyWith<$Res> {
  factory $$TlsrptSummaryCopyWith(TlsrptSummary value) =
      _TlsrptSummaryCopyWith<$Res>;

  $Res call({
    _i3.int? totalFailureSessionCount,
    _i3.int? totalSuccessfulSessionCount,
  });
  _i3.int? get totalFailureSessionCount;
  _i3.int? get totalSuccessfulSessionCount;
}

class _TlsrptSummaryCopyWith<$Res> implements $$TlsrptSummaryCopyWith<$Res> {
  _TlsrptSummaryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsrptSummary _value;

  @_i3.override
  _i3.int? get totalFailureSessionCount => _value.totalFailureSessionCount;

  @_i3.override
  _i3.int? get totalSuccessfulSessionCount =>
      _value.totalSuccessfulSessionCount;

  @_i3.override
  $Res call({
    _i3.Object? totalFailureSessionCount = _sentinel,
    _i3.Object? totalSuccessfulSessionCount = _sentinel,
  }) {
    return (TlsrptSummary(
      totalFailureSessionCount:
          _i3.identical(totalFailureSessionCount, _sentinel)
          ? this.totalFailureSessionCount
          : (totalFailureSessionCount as _i3.int?),
      totalSuccessfulSessionCount:
          _i3.identical(totalSuccessfulSessionCount, _sentinel)
          ? this.totalSuccessfulSessionCount
          : (totalSuccessfulSessionCount as _i3.int?),
    ) as $Res);
  }
}
