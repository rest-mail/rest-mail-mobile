// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SendLimitValues extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SendLimitValues({
    required this.messagesPerDay,
    required this.messagesPerHour,
    required this.recipientsPerDay,
    required this.recipientsPerHour,
  });

  factory SendLimitValues.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'messages_per_day',
        r'messages_per_hour',
        r'recipients_per_day',
        r'recipients_per_hour',
      },
      listKeys: {},
      context: r'SendLimitValues',
    );
    return SendLimitValues(
      messagesPerDay: _$values[r'messages_per_day'].decodeSimpleInt(
        context: r'SendLimitValues.messages_per_day',
      ),
      messagesPerHour: _$values[r'messages_per_hour'].decodeSimpleInt(
        context: r'SendLimitValues.messages_per_hour',
      ),
      recipientsPerDay: _$values[r'recipients_per_day'].decodeSimpleInt(
        context: r'SendLimitValues.recipients_per_day',
      ),
      recipientsPerHour: _$values[r'recipients_per_hour'].decodeSimpleInt(
        context: r'SendLimitValues.recipients_per_hour',
      ),
    );
  }

  factory SendLimitValues.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SendLimitValues');
    return SendLimitValues(
      messagesPerDay: _$map[r'messages_per_day'].decodeJsonInt(
        context: r'SendLimitValues.messages_per_day',
      ),
      messagesPerHour: _$map[r'messages_per_hour'].decodeJsonInt(
        context: r'SendLimitValues.messages_per_hour',
      ),
      recipientsPerDay: _$map[r'recipients_per_day'].decodeJsonInt(
        context: r'SendLimitValues.recipients_per_day',
      ),
      recipientsPerHour: _$map[r'recipients_per_hour'].decodeJsonInt(
        context: r'SendLimitValues.recipients_per_hour',
      ),
    );
  }

  factory SendLimitValues.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'messages_per_day',
        r'messages_per_hour',
        r'recipients_per_day',
        r'recipients_per_hour',
      },
      listKeys: {},
      context: r'SendLimitValues',
    );
    return SendLimitValues(
      messagesPerDay: _$values[r'messages_per_day'].decodeFormInt(
        context: r'SendLimitValues.messages_per_day',
      ),
      messagesPerHour: _$values[r'messages_per_hour'].decodeFormInt(
        context: r'SendLimitValues.messages_per_hour',
      ),
      recipientsPerDay: _$values[r'recipients_per_day'].decodeFormInt(
        context: r'SendLimitValues.recipients_per_day',
      ),
      recipientsPerHour: _$values[r'recipients_per_hour'].decodeFormInt(
        context: r'SendLimitValues.recipients_per_hour',
      ),
    );
  }

  final _i3.int messagesPerDay;

  final _i3.int messagesPerHour;

  final _i3.int recipientsPerDay;

  final _i3.int recipientsPerHour;

  @_i3.override
  _i3.Object? toJson() => {
    r'messages_per_day': messagesPerDay,
    r'messages_per_hour': messagesPerHour,
    r'recipients_per_day': recipientsPerDay,
    r'recipients_per_hour': recipientsPerHour,
  };

  $$SendLimitValuesCopyWith<SendLimitValues> get copyWith =>
      _SendLimitValuesCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SendLimitValues &&
        other.messagesPerDay == this.messagesPerDay &&
        other.messagesPerHour == this.messagesPerHour &&
        other.recipientsPerDay == this.recipientsPerDay &&
        other.recipientsPerHour == this.recipientsPerHour;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      messagesPerDay,
      messagesPerHour,
      recipientsPerDay,
      recipientsPerHour,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'messages_per_day'] = _i1.PropertyValue.scalar(
      messagesPerDay.toString(),
    );
    _$result[r'messages_per_hour'] = _i1.PropertyValue.scalar(
      messagesPerHour.toString(),
    );
    _$result[r'recipients_per_day'] = _i1.PropertyValue.scalar(
      recipientsPerDay.toString(),
    );
    _$result[r'recipients_per_hour'] = _i1.PropertyValue.scalar(
      recipientsPerHour.toString(),
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
      r'Cannot uriEncode SendLimitValues: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SendLimitValuesCopyWith<$Res> {
  factory $$SendLimitValuesCopyWith(SendLimitValues value) =
      _SendLimitValuesCopyWith<$Res>;

  $Res call({
    _i3.int? messagesPerDay,
    _i3.int? messagesPerHour,
    _i3.int? recipientsPerDay,
    _i3.int? recipientsPerHour,
  });
  _i3.int get messagesPerDay;
  _i3.int get messagesPerHour;
  _i3.int get recipientsPerDay;
  _i3.int get recipientsPerHour;
}

class _SendLimitValuesCopyWith<$Res>
    implements $$SendLimitValuesCopyWith<$Res> {
  _SendLimitValuesCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SendLimitValues _value;

  @_i3.override
  _i3.int get messagesPerDay => _value.messagesPerDay;

  @_i3.override
  _i3.int get messagesPerHour => _value.messagesPerHour;

  @_i3.override
  _i3.int get recipientsPerDay => _value.recipientsPerDay;

  @_i3.override
  _i3.int get recipientsPerHour => _value.recipientsPerHour;

  @_i3.override
  $Res call({
    _i3.Object? messagesPerDay = _sentinel,
    _i3.Object? messagesPerHour = _sentinel,
    _i3.Object? recipientsPerDay = _sentinel,
    _i3.Object? recipientsPerHour = _sentinel,
  }) {
    return (SendLimitValues(
      messagesPerDay: _i3.identical(messagesPerDay, _sentinel)
          ? this.messagesPerDay
          : (messagesPerDay as _i3.int),
      messagesPerHour: _i3.identical(messagesPerHour, _sentinel)
          ? this.messagesPerHour
          : (messagesPerHour as _i3.int),
      recipientsPerDay: _i3.identical(recipientsPerDay, _sentinel)
          ? this.recipientsPerDay
          : (recipientsPerDay as _i3.int),
      recipientsPerHour: _i3.identical(recipientsPerHour, _sentinel)
          ? this.recipientsPerHour
          : (recipientsPerHour as _i3.int),
    ) as $Res);
  }
}
