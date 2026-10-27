// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetVacationBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetVacationBody({
    required this.enabled,
    this.body,
    this.endDate,
    this.startDate,
    this.subject,
  });

  factory SetVacationBody.fromSimple(
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
      context: r'SetVacationBody',
    );
    return SetVacationBody(
      body: _$values[r'body'].decodeSimpleNullableString(
        context: r'SetVacationBody.body',
      ),
      enabled: _$values[r'enabled'].decodeSimpleNullableBool(
        context: r'SetVacationBody.enabled',
      ),
      endDate: _$values[r'end_date'].decodeSimpleNullableDateTime(
        context: r'SetVacationBody.end_date',
      ),
      startDate: _$values[r'start_date'].decodeSimpleNullableDateTime(
        context: r'SetVacationBody.start_date',
      ),
      subject: _$values[r'subject'].decodeSimpleNullableString(
        context: r'SetVacationBody.subject',
      ),
    );
  }

  factory SetVacationBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetVacationBody');
    return SetVacationBody(
      body: _$map[r'body'].decodeJsonNullableString(
        context: r'SetVacationBody.body',
      ),
      enabled: _$map[r'enabled'].decodeJsonNullableBool(
        context: r'SetVacationBody.enabled',
      ),
      endDate: _$map[r'end_date'].decodeJsonNullableDateTime(
        context: r'SetVacationBody.end_date',
      ),
      startDate: _$map[r'start_date'].decodeJsonNullableDateTime(
        context: r'SetVacationBody.start_date',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'SetVacationBody.subject',
      ),
    );
  }

  factory SetVacationBody.fromForm(
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
      context: r'SetVacationBody',
    );
    return SetVacationBody(
      body: _$values[r'body'].decodeFormNullableString(
        context: r'SetVacationBody.body',
      ),
      enabled: _$values[r'enabled'].decodeFormNullableBool(
        context: r'SetVacationBody.enabled',
      ),
      endDate: _$values[r'end_date'].decodeFormNullableDateTime(
        context: r'SetVacationBody.end_date',
      ),
      startDate: _$values[r'start_date'].decodeFormNullableDateTime(
        context: r'SetVacationBody.start_date',
      ),
      subject: _$values[r'subject'].decodeFormNullableString(
        context: r'SetVacationBody.subject',
      ),
    );
  }

  final _i3.String? body;

  final _i3.bool? enabled;

  final _i3.DateTime? endDate;

  final _i3.DateTime? startDate;

  final _i3.String? subject;

  @_i3.override
  _i3.Object? toJson() => {
    if (body != null) r'body': body,
    r'enabled': enabled,
    r'end_date': endDate?.toTimeZonedIso8601String(),
    r'start_date': startDate?.toTimeZonedIso8601String(),
    if (subject != null) r'subject': subject,
  };

  $$SetVacationBodyCopyWith<SetVacationBody> get copyWith =>
      _SetVacationBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetVacationBody &&
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
    if (body != null) {
      _$result[r'body'] = _i1.PropertyValue.scalar(body!);
    }
    if (enabled != null) {
      _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled!.toString());
    }
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
    if (subject != null) {
      _$result[r'subject'] = _i1.PropertyValue.scalar(subject!);
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
      r'Cannot uriEncode SetVacationBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetVacationBodyCopyWith<$Res> {
  factory $$SetVacationBodyCopyWith(SetVacationBody value) =
      _SetVacationBodyCopyWith<$Res>;

  $Res call({
    _i3.String? body,
    _i3.bool? enabled,
    _i3.DateTime? endDate,
    _i3.DateTime? startDate,
    _i3.String? subject,
  });
  _i3.String? get body;
  _i3.bool? get enabled;
  _i3.DateTime? get endDate;
  _i3.DateTime? get startDate;
  _i3.String? get subject;
}

class _SetVacationBodyCopyWith<$Res>
    implements $$SetVacationBodyCopyWith<$Res> {
  _SetVacationBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetVacationBody _value;

  @_i3.override
  _i3.String? get body => _value.body;

  @_i3.override
  _i3.bool? get enabled => _value.enabled;

  @_i3.override
  _i3.DateTime? get endDate => _value.endDate;

  @_i3.override
  _i3.DateTime? get startDate => _value.startDate;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  $Res call({
    _i3.Object? body = _sentinel,
    _i3.Object? enabled = _sentinel,
    _i3.Object? endDate = _sentinel,
    _i3.Object? startDate = _sentinel,
    _i3.Object? subject = _sentinel,
  }) {
    return (SetVacationBody(
      body: _i3.identical(body, _sentinel) ? this.body : (body as _i3.String?),
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool?),
      endDate: _i3.identical(endDate, _sentinel)
          ? this.endDate
          : (endDate as _i3.DateTime?),
      startDate: _i3.identical(startDate, _sentinel)
          ? this.startDate
          : (startDate as _i3.DateTime?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
    ) as $Res);
  }
}
