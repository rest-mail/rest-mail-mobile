// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quiet_hours_body_enabled_model2.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuietHoursBodyModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuietHoursBodyModel2({
    required this.end,
    required this.start,
    required this.timeZone,
    this.enabled,
  });

  factory QuietHoursBodyModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for QuietHoursBodyModel2: contains complex types',
    );
  }

  factory QuietHoursBodyModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuietHoursBodyModel2');
    return QuietHoursBodyModel2(
      enabled: _$map[r'enabled'] == null
          ? null
          : _i4.QuietHoursBodyEnabledModel2.fromJson(_$map[r'enabled']),
      end: _$map[r'end'],
      start: _$map[r'start'],
      timeZone: _$map[r'time_zone'],
    );
  }

  factory QuietHoursBodyModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for QuietHoursBodyModel2: contains complex types',
    );
  }

  final _i4.QuietHoursBodyEnabledModel2? enabled;

  final _i3.Object? end;

  final _i3.Object? start;

  final _i3.Object? timeZone;

  @_i3.override
  _i3.Object? toJson() => {
    if (enabled != null) r'enabled': enabled?.toJson(),
    r'end': _i1.encodeUnknownJson(end, context: r'QuietHoursBodyModel2.end'),
    r'start': _i1.encodeUnknownJson(
      start,
      context: r'QuietHoursBodyModel2.start',
    ),
    r'time_zone': _i1.encodeUnknownJson(
      timeZone,
      context: r'QuietHoursBodyModel2.time_zone',
    ),
  };

  $$QuietHoursBodyModel2CopyWith<QuietHoursBodyModel2> get copyWith =>
      _QuietHoursBodyModel2CopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuietHoursBodyModel2 &&
        other.enabled == this.enabled &&
        other.end == this.end &&
        other.start == this.start &&
        other.timeZone == this.timeZone;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([enabled, end, start, timeZone]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for QuietHoursBodyModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode QuietHoursBodyModel2: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuietHoursBodyModel2CopyWith<$Res> {
  factory $$QuietHoursBodyModel2CopyWith(QuietHoursBodyModel2 value) =
      _QuietHoursBodyModel2CopyWith<$Res>;

  $Res call({
    _i4.QuietHoursBodyEnabledModel2? enabled,
    _i3.Object? end,
    _i3.Object? start,
    _i3.Object? timeZone,
  });
  _i4.QuietHoursBodyEnabledModel2? get enabled;
  _i3.Object? get end;
  _i3.Object? get start;
  _i3.Object? get timeZone;
}

class _QuietHoursBodyModel2CopyWith<$Res>
    implements $$QuietHoursBodyModel2CopyWith<$Res> {
  _QuietHoursBodyModel2CopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuietHoursBodyModel2 _value;

  @_i3.override
  _i4.QuietHoursBodyEnabledModel2? get enabled => _value.enabled;

  @_i3.override
  _i3.Object? get end => _value.end;

  @_i3.override
  _i3.Object? get start => _value.start;

  @_i3.override
  _i3.Object? get timeZone => _value.timeZone;

  @_i3.override
  $Res call({
    _i3.Object? enabled = _sentinel,
    _i3.Object? end = _sentinel,
    _i3.Object? start = _sentinel,
    _i3.Object? timeZone = _sentinel,
  }) {
    return (QuietHoursBodyModel2(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i4.QuietHoursBodyEnabledModel2?),
      end: _i3.identical(end, _sentinel) ? this.end : end,
      start: _i3.identical(start, _sentinel) ? this.start : start,
      timeZone: _i3.identical(timeZone, _sentinel) ? this.timeZone : timeZone,
    ) as $Res);
  }
}
