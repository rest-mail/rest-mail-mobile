// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class MessageVolumeData extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const MessageVolumeData({required this.count, required this.date});

  factory MessageVolumeData.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'count', r'date'},
      listKeys: {},
      context: r'MessageVolumeData',
    );
    return MessageVolumeData(
      count: _$values[r'count'].decodeSimpleInt(
        context: r'MessageVolumeData.count',
      ),
      date: _$values[r'date'].decodeSimpleString(
        context: r'MessageVolumeData.date',
      ),
    );
  }

  factory MessageVolumeData.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'MessageVolumeData');
    return MessageVolumeData(
      count: _$map[r'count'].decodeJsonInt(context: r'MessageVolumeData.count'),
      date: _$map[r'date'].decodeJsonString(context: r'MessageVolumeData.date'),
    );
  }

  factory MessageVolumeData.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'count', r'date'},
      listKeys: {},
      context: r'MessageVolumeData',
    );
    return MessageVolumeData(
      count: _$values[r'count'].decodeFormInt(
        context: r'MessageVolumeData.count',
      ),
      date: _$values[r'date'].decodeFormString(
        context: r'MessageVolumeData.date',
      ),
    );
  }

  final _i3.int count;

  final _i3.String date;

  @_i3.override
  _i3.Object? toJson() => {r'count': count, r'date': date};

  $$MessageVolumeDataCopyWith<MessageVolumeData> get copyWith =>
      _MessageVolumeDataCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MessageVolumeData &&
        other.count == this.count &&
        other.date == this.date;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([count, date]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'count'] = _i1.PropertyValue.scalar(count.toString());
    _$result[r'date'] = _i1.PropertyValue.scalar(date);
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
      r'Cannot uriEncode MessageVolumeData: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MessageVolumeDataCopyWith<$Res> {
  factory $$MessageVolumeDataCopyWith(MessageVolumeData value) =
      _MessageVolumeDataCopyWith<$Res>;

  $Res call({_i3.int? count, _i3.String? date});
  _i3.int get count;
  _i3.String get date;
}

class _MessageVolumeDataCopyWith<$Res>
    implements $$MessageVolumeDataCopyWith<$Res> {
  _MessageVolumeDataCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final MessageVolumeData _value;

  @_i3.override
  _i3.int get count => _value.count;

  @_i3.override
  _i3.String get date => _value.date;

  @_i3.override
  $Res call({_i3.Object? count = _sentinel, _i3.Object? date = _sentinel}) {
    return (MessageVolumeData(
      count: _i3.identical(count, _sentinel) ? this.count : (count as _i3.int),
      date: _i3.identical(date, _sentinel) ? this.date : (date as _i3.String),
    ) as $Res);
  }
}
