// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Setting extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Setting({
    required this.enabled,
    required this.end,
    required this.start,
    required this.timeZone,
  });

  factory Setting.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'enabled', r'end', r'start', r'time_zone'},
      listKeys: {},
      context: r'Setting',
    );
    return Setting(
      enabled: _$values[r'enabled'].decodeSimpleBool(
        context: r'Setting.enabled',
      ),
      end: _$values[r'end'].decodeSimpleString(context: r'Setting.end'),
      start: _$values[r'start'].decodeSimpleString(context: r'Setting.start'),
      timeZone: _$values[r'time_zone'].decodeSimpleString(
        context: r'Setting.time_zone',
      ),
    );
  }

  factory Setting.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Setting');
    return Setting(
      enabled: _$map[r'enabled'].decodeJsonBool(context: r'Setting.enabled'),
      end: _$map[r'end'].decodeJsonString(context: r'Setting.end'),
      start: _$map[r'start'].decodeJsonString(context: r'Setting.start'),
      timeZone: _$map[r'time_zone'].decodeJsonString(
        context: r'Setting.time_zone',
      ),
    );
  }

  factory Setting.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'enabled', r'end', r'start', r'time_zone'},
      listKeys: {},
      context: r'Setting',
    );
    return Setting(
      enabled: _$values[r'enabled'].decodeFormBool(context: r'Setting.enabled'),
      end: _$values[r'end'].decodeFormString(context: r'Setting.end'),
      start: _$values[r'start'].decodeFormString(context: r'Setting.start'),
      timeZone: _$values[r'time_zone'].decodeFormString(
        context: r'Setting.time_zone',
      ),
    );
  }

  final _i3.bool enabled;

  /// **Example**:
  /// ```
  /// 08:00
  /// ```
  final _i3.String end;

  /// **Example**:
  /// ```
  /// 22:00
  /// ```
  final _i3.String start;

  /// **Example**:
  /// ```
  /// Europe/Berlin
  /// ```
  final _i3.String timeZone;

  @_i3.override
  _i3.Object? toJson() => {
    r'enabled': enabled,
    r'end': end,
    r'start': start,
    r'time_zone': timeZone,
  };

  $$SettingCopyWith<Setting> get copyWith => _SettingCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Setting &&
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
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled.toString());
    _$result[r'end'] = _i1.PropertyValue.scalar(end);
    _$result[r'start'] = _i1.PropertyValue.scalar(start);
    _$result[r'time_zone'] = _i1.PropertyValue.scalar(timeZone);
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
      r'Cannot uriEncode Setting: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SettingCopyWith<$Res> {
  factory $$SettingCopyWith(Setting value) = _SettingCopyWith<$Res>;

  $Res call({
    _i3.bool? enabled,
    _i3.String? end,
    _i3.String? start,
    _i3.String? timeZone,
  });
  _i3.bool get enabled;
  _i3.String get end;
  _i3.String get start;
  _i3.String get timeZone;
}

class _SettingCopyWith<$Res> implements $$SettingCopyWith<$Res> {
  _SettingCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Setting _value;

  @_i3.override
  _i3.bool get enabled => _value.enabled;

  @_i3.override
  _i3.String get end => _value.end;

  @_i3.override
  _i3.String get start => _value.start;

  @_i3.override
  _i3.String get timeZone => _value.timeZone;

  @_i3.override
  $Res call({
    _i3.Object? enabled = _sentinel,
    _i3.Object? end = _sentinel,
    _i3.Object? start = _sentinel,
    _i3.Object? timeZone = _sentinel,
  }) {
    return (Setting(
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool),
      end: _i3.identical(end, _sentinel) ? this.end : (end as _i3.String),
      start: _i3.identical(start, _sentinel)
          ? this.start
          : (start as _i3.String),
      timeZone: _i3.identical(timeZone, _sentinel)
          ? this.timeZone
          : (timeZone as _i3.String),
    ) as $Res);
  }
}
