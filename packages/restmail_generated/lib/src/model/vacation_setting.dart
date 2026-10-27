// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VacationSetting extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VacationSetting({
    required this.body,
    required this.enabled,
    required this.subject,
    this.endDate,
    this.startDate,
  });

  factory VacationSetting.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'body',
        r'enabled',
        r'end_date',
        r'start_date',
        r'subject',
      },
      listKeys: {},
      context: r'VacationSetting',
    );
    return VacationSetting(
      body: _$values[r'body'].decodeSimpleString(
        context: r'VacationSetting.body',
      ),
      enabled: _$values[r'enabled'].decodeSimpleBool(
        context: r'VacationSetting.enabled',
      ),
      endDate: _$values[r'end_date'].decodeSimpleNullableDateTime(
        context: r'VacationSetting.end_date',
      ),
      startDate: _$values[r'start_date'].decodeSimpleNullableDateTime(
        context: r'VacationSetting.start_date',
      ),
      subject: _$values[r'subject'].decodeSimpleString(
        context: r'VacationSetting.subject',
      ),
    );
  }

  factory VacationSetting.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'VacationSetting');
    return VacationSetting(
      body: _$map[r'body'].decodeJsonString(context: r'VacationSetting.body'),
      enabled: _$map[r'enabled'].decodeJsonBool(
        context: r'VacationSetting.enabled',
      ),
      endDate: _$map[r'end_date'].decodeJsonNullableDateTime(
        context: r'VacationSetting.end_date',
      ),
      startDate: _$map[r'start_date'].decodeJsonNullableDateTime(
        context: r'VacationSetting.start_date',
      ),
      subject: _$map[r'subject'].decodeJsonString(
        context: r'VacationSetting.subject',
      ),
    );
  }

  factory VacationSetting.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'body',
        r'enabled',
        r'end_date',
        r'start_date',
        r'subject',
      },
      listKeys: {},
      context: r'VacationSetting',
    );
    return VacationSetting(
      body: _$values[r'body'].decodeFormString(
        context: r'VacationSetting.body',
      ),
      enabled: _$values[r'enabled'].decodeFormBool(
        context: r'VacationSetting.enabled',
      ),
      endDate: _$values[r'end_date'].decodeFormNullableDateTime(
        context: r'VacationSetting.end_date',
      ),
      startDate: _$values[r'start_date'].decodeFormNullableDateTime(
        context: r'VacationSetting.start_date',
      ),
      subject: _$values[r'subject'].decodeFormString(
        context: r'VacationSetting.subject',
      ),
    );
  }

  final _i3.String body;

  final _i3.bool enabled;

  final _i3.DateTime? endDate;

  final _i3.DateTime? startDate;

  final _i3.String subject;

  @_i3.override
  _i3.Object? toJson() => {
    r'body': body,
    r'enabled': enabled,
    r'end_date': endDate?.toTimeZonedIso8601String(),
    r'start_date': startDate?.toTimeZonedIso8601String(),
    r'subject': subject,
  };

  $$VacationSettingCopyWith<VacationSetting> get copyWith =>
      _VacationSettingCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is VacationSetting &&
        other.body == this.body &&
        other.enabled == this.enabled &&
        other.endDate == this.endDate &&
        other.startDate == this.startDate &&
        other.subject == this.subject;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([body, enabled, endDate, startDate, subject]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'body'] = _i1.PropertyValue.scalar(body);
    _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled.toString());
    if (endDate != null) {
      _$result[r'end_date'] = _i1.PropertyValue.scalar(
        endDate!.toTimeZonedIso8601String(),
      );
    }
    if (startDate != null) {
      _$result[r'start_date'] = _i1.PropertyValue.scalar(
        startDate!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'subject'] = _i1.PropertyValue.scalar(subject);
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
      r'Cannot uriEncode VacationSetting: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$VacationSettingCopyWith<$Res> {
  factory $$VacationSettingCopyWith(VacationSetting value) =
      _VacationSettingCopyWith<$Res>;

  $Res call({
    _i3.String? body,
    _i3.bool? enabled,
    _i3.DateTime? endDate,
    _i3.DateTime? startDate,
    _i3.String? subject,
  });
  _i3.String get body;
  _i3.bool get enabled;
  _i3.DateTime? get endDate;
  _i3.DateTime? get startDate;
  _i3.String get subject;
}

class _VacationSettingCopyWith<$Res>
    implements $$VacationSettingCopyWith<$Res> {
  _VacationSettingCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final VacationSetting _value;

  @_i3.override
  _i3.String get body => _value.body;

  @_i3.override
  _i3.bool get enabled => _value.enabled;

  @_i3.override
  _i3.DateTime? get endDate => _value.endDate;

  @_i3.override
  _i3.DateTime? get startDate => _value.startDate;

  @_i3.override
  _i3.String get subject => _value.subject;

  @_i3.override
  $Res call({
    _i3.Object? body = _sentinel,
    _i3.Object? enabled = _sentinel,
    _i3.Object? endDate = _sentinel,
    _i3.Object? startDate = _sentinel,
    _i3.Object? subject = _sentinel,
  }) {
    return (VacationSetting(
      body: _i3.identical(body, _sentinel) ? this.body : (body as _i3.String),
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool),
      endDate: _i3.identical(endDate, _sentinel)
          ? this.endDate
          : (endDate as _i3.DateTime?),
      startDate: _i3.identical(startDate, _sentinel)
          ? this.startDate
          : (startDate as _i3.DateTime?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String),
    ) as $Res);
  }
}
