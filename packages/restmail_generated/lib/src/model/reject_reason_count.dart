// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RejectReasonCount extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RejectReasonCount({required this.count, required this.reasonCode});

  factory RejectReasonCount.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'count', r'reason_code'},
      listKeys: {},
      context: r'RejectReasonCount',
    );
    return RejectReasonCount(
      count: _$values[r'count'].decodeSimpleDouble(
        context: r'RejectReasonCount.count',
      ),
      reasonCode: _$values[r'reason_code'].decodeSimpleString(
        context: r'RejectReasonCount.reason_code',
      ),
    );
  }

  factory RejectReasonCount.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RejectReasonCount');
    return RejectReasonCount(
      count: _$map[r'count'].decodeJsonDouble(
        context: r'RejectReasonCount.count',
      ),
      reasonCode: _$map[r'reason_code'].decodeJsonString(
        context: r'RejectReasonCount.reason_code',
      ),
    );
  }

  factory RejectReasonCount.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'count', r'reason_code'},
      listKeys: {},
      context: r'RejectReasonCount',
    );
    return RejectReasonCount(
      count: _$values[r'count'].decodeFormDouble(
        context: r'RejectReasonCount.count',
      ),
      reasonCode: _$values[r'reason_code'].decodeFormString(
        context: r'RejectReasonCount.reason_code',
      ),
    );
  }

  final _i3.double count;

  final _i3.String reasonCode;

  @_i3.override
  _i3.Object? toJson() => {r'count': count, r'reason_code': reasonCode};

  $$RejectReasonCountCopyWith<RejectReasonCount> get copyWith =>
      _RejectReasonCountCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RejectReasonCount &&
        other.count == this.count &&
        other.reasonCode == this.reasonCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, reasonCode]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'reason_code'] = _i1.PropertyValue.scalar(reasonCode);
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
      r'Cannot uriEncode RejectReasonCount: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RejectReasonCountCopyWith<$Res> {
  factory $$RejectReasonCountCopyWith(RejectReasonCount value) =
      _RejectReasonCountCopyWith<$Res>;

  $Res call({_i3.double? count, _i3.String? reasonCode});
  _i3.double get count;
  _i3.String get reasonCode;
}

class _RejectReasonCountCopyWith<$Res>
    implements $$RejectReasonCountCopyWith<$Res> {
  _RejectReasonCountCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RejectReasonCount _value;

  @_i3.override
  _i3.double get count => _value.count;

  @_i3.override
  _i3.String get reasonCode => _value.reasonCode;

  @_i3.override
  $Res call({
    _i3.Object? count = _sentinel,
    _i3.Object? reasonCode = _sentinel,
  }) {
    return (RejectReasonCount(
      count: _i3.identical(count, _sentinel)
          ? this.count
          : (count as _i3.double),
      reasonCode: _i3.identical(reasonCode, _sentinel)
          ? this.reasonCode
          : (reasonCode as _i3.String),
    ) as $Res);
  }
}
