// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/calendar_replied_response_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/calendar_replied_status_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CalendarReplied extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CalendarReplied({required this.response, required this.status});

  factory CalendarReplied.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'response', r'status'},
      listKeys: {},
      context: r'CalendarReplied',
    );
    return CalendarReplied(
      response: _i4.CalendarRepliedResponseModel.fromSimple(
        _$values[r'response'],
        explode: explode,
      ),
      status: _i5.CalendarRepliedStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory CalendarReplied.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CalendarReplied');
    return CalendarReplied(
      response: _i4.CalendarRepliedResponseModel.fromJson(_$map[r'response']),
      status: _i5.CalendarRepliedStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory CalendarReplied.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'response', r'status'},
      listKeys: {},
      context: r'CalendarReplied',
    );
    return CalendarReplied(
      response: _i4.CalendarRepliedResponseModel.fromForm(
        _$values[r'response'],
        explode: explode,
      ),
      status: _i5.CalendarRepliedStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i4.CalendarRepliedResponseModel response;

  final _i5.CalendarRepliedStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {
    r'response': response.toJson(),
    r'status': status.toJson(),
  };

  $$CalendarRepliedCopyWith<CalendarReplied> get copyWith =>
      _CalendarRepliedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CalendarReplied &&
        other.response == this.response &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([response, status]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'response'] = _i1.PropertyValue.scalar(response.toJson());
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CalendarReplied: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CalendarRepliedCopyWith<$Res> {
  factory $$CalendarRepliedCopyWith(CalendarReplied value) =
      _CalendarRepliedCopyWith<$Res>;

  $Res call({
    _i4.CalendarRepliedResponseModel? response,
    _i5.CalendarRepliedStatusModel? status,
  });
  _i4.CalendarRepliedResponseModel get response;
  _i5.CalendarRepliedStatusModel get status;
}

class _CalendarRepliedCopyWith<$Res>
    implements $$CalendarRepliedCopyWith<$Res> {
  _CalendarRepliedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CalendarReplied _value;

  @_i3.override
  _i4.CalendarRepliedResponseModel get response => _value.response;

  @_i3.override
  _i5.CalendarRepliedStatusModel get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? response = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return (CalendarReplied(
      response: _i3.identical(response, _sentinel)
          ? this.response
          : (response as _i4.CalendarRepliedResponseModel),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i5.CalendarRepliedStatusModel),
    ) as $Res);
  }
}
