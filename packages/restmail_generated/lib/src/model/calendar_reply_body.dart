// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CalendarReplyBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CalendarReplyBody({this.from, this.response});

  factory CalendarReplyBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'from', r'response'},
      listKeys: {},
      context: r'CalendarReplyBody',
    );
    return CalendarReplyBody(
      from: _$values[r'from'].decodeSimpleNullableString(
        context: r'CalendarReplyBody.from',
      ),
      response: _$values[r'response'].decodeSimpleNullableString(
        context: r'CalendarReplyBody.response',
      ),
    );
  }

  factory CalendarReplyBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CalendarReplyBody');
    return CalendarReplyBody(
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'CalendarReplyBody.from',
      ),
      response: _$map[r'response'].decodeJsonNullableString(
        context: r'CalendarReplyBody.response',
      ),
    );
  }

  factory CalendarReplyBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'from', r'response'},
      listKeys: {},
      context: r'CalendarReplyBody',
    );
    return CalendarReplyBody(
      from: _$values[r'from'].decodeFormNullableString(
        context: r'CalendarReplyBody.from',
      ),
      response: _$values[r'response'].decodeFormNullableString(
        context: r'CalendarReplyBody.response',
      ),
    );
  }

  final _i3.String? from;

  final _i3.String? response;

  @_i3.override
  _i3.Object? toJson() => {
    if (from != null) r'from': from,
    if (response != null) r'response': response,
  };

  $$CalendarReplyBodyCopyWith<CalendarReplyBody> get copyWith =>
      _CalendarReplyBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CalendarReplyBody &&
        other.from == this.from &&
        other.response == this.response;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([from, response]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (from != null) {
      _$result[r'from'] = _i1.PropertyValue.scalar(from!);
    }
    if (response != null) {
      _$result[r'response'] = _i1.PropertyValue.scalar(response!);
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
      r'Cannot uriEncode CalendarReplyBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CalendarReplyBodyCopyWith<$Res> {
  factory $$CalendarReplyBodyCopyWith(CalendarReplyBody value) =
      _CalendarReplyBodyCopyWith<$Res>;

  $Res call({_i3.String? from, _i3.String? response});
  _i3.String? get from;
  _i3.String? get response;
}

class _CalendarReplyBodyCopyWith<$Res>
    implements $$CalendarReplyBodyCopyWith<$Res> {
  _CalendarReplyBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CalendarReplyBody _value;

  @_i3.override
  _i3.String? get from => _value.from;

  @_i3.override
  _i3.String? get response => _value.response;

  @_i3.override
  $Res call({_i3.Object? from = _sentinel, _i3.Object? response = _sentinel}) {
    return (CalendarReplyBody(
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String?),
      response: _i3.identical(response, _sentinel)
          ? this.response
          : (response as _i3.String?),
    ) as $Res);
  }
}
