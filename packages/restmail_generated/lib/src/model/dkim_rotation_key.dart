// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DkimRotationKey extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DkimRotationKey({
    required this.publishedAt,
    required this.recordName,
    required this.recordValue,
    required this.selector,
    this.activatesAt,
    this.retireAfter,
  });

  factory DkimRotationKey.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'activates_at',
        r'published_at',
        r'record_name',
        r'record_value',
        r'retire_after',
        r'selector',
      },
      listKeys: {},
      context: r'DkimRotationKey',
    );
    return DkimRotationKey(
      activatesAt: _$values[r'activates_at'].decodeSimpleNullableDateTime(
        context: r'DkimRotationKey.activates_at',
      ),
      publishedAt: _$values[r'published_at'].decodeSimpleNullableDateTime(
        context: r'DkimRotationKey.published_at',
      ),
      recordName: _$values[r'record_name'].decodeSimpleString(
        context: r'DkimRotationKey.record_name',
      ),
      recordValue: _$values[r'record_value'].decodeSimpleString(
        context: r'DkimRotationKey.record_value',
      ),
      retireAfter: _$values[r'retire_after'].decodeSimpleNullableDateTime(
        context: r'DkimRotationKey.retire_after',
      ),
      selector: _$values[r'selector'].decodeSimpleString(
        context: r'DkimRotationKey.selector',
      ),
    );
  }

  factory DkimRotationKey.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DkimRotationKey');
    return DkimRotationKey(
      activatesAt: _$map[r'activates_at'].decodeJsonNullableDateTime(
        context: r'DkimRotationKey.activates_at',
      ),
      publishedAt: _$map[r'published_at'].decodeJsonNullableDateTime(
        context: r'DkimRotationKey.published_at',
      ),
      recordName: _$map[r'record_name'].decodeJsonString(
        context: r'DkimRotationKey.record_name',
      ),
      recordValue: _$map[r'record_value'].decodeJsonString(
        context: r'DkimRotationKey.record_value',
      ),
      retireAfter: _$map[r'retire_after'].decodeJsonNullableDateTime(
        context: r'DkimRotationKey.retire_after',
      ),
      selector: _$map[r'selector'].decodeJsonString(
        context: r'DkimRotationKey.selector',
      ),
    );
  }

  factory DkimRotationKey.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'activates_at',
        r'published_at',
        r'record_name',
        r'record_value',
        r'retire_after',
        r'selector',
      },
      listKeys: {},
      context: r'DkimRotationKey',
    );
    return DkimRotationKey(
      activatesAt: _$values[r'activates_at'].decodeFormNullableDateTime(
        context: r'DkimRotationKey.activates_at',
      ),
      publishedAt: _$values[r'published_at'].decodeFormNullableDateTime(
        context: r'DkimRotationKey.published_at',
      ),
      recordName: _$values[r'record_name'].decodeFormString(
        context: r'DkimRotationKey.record_name',
      ),
      recordValue: _$values[r'record_value'].decodeFormString(
        context: r'DkimRotationKey.record_value',
      ),
      retireAfter: _$values[r'retire_after'].decodeFormNullableDateTime(
        context: r'DkimRotationKey.retire_after',
      ),
      selector: _$values[r'selector'].decodeFormString(
        context: r'DkimRotationKey.selector',
      ),
    );
  }

  final _i3.DateTime? activatesAt;

  final _i3.DateTime? publishedAt;

  final _i3.String recordName;

  final _i3.String recordValue;

  final _i3.DateTime? retireAfter;

  final _i3.String selector;

  @_i3.override
  _i3.Object? toJson() => {
    r'activates_at': activatesAt?.toTimeZonedIso8601String(),
    r'published_at': publishedAt?.toTimeZonedIso8601String(),
    r'record_name': recordName,
    r'record_value': recordValue,
    r'retire_after': retireAfter?.toTimeZonedIso8601String(),
    r'selector': selector,
  };

  $$DkimRotationKeyCopyWith<DkimRotationKey> get copyWith =>
      _DkimRotationKeyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DkimRotationKey &&
        other.activatesAt == this.activatesAt &&
        other.publishedAt == this.publishedAt &&
        other.recordName == this.recordName &&
        other.recordValue == this.recordValue &&
        other.retireAfter == this.retireAfter &&
        other.selector == this.selector;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      activatesAt,
      publishedAt,
      recordName,
      recordValue,
      retireAfter,
      selector,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (activatesAt != null) {
      _$result[r'activates_at'] = _i1.PropertyValue.scalar(
        activatesAt!.toTimeZonedIso8601String(),
      );
    }
    if (publishedAt != null) {
      _$result[r'published_at'] = _i1.PropertyValue.scalar(
        publishedAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'record_name'] = _i1.PropertyValue.scalar(recordName);
    _$result[r'record_value'] = _i1.PropertyValue.scalar(recordValue);
    if (retireAfter != null) {
      _$result[r'retire_after'] = _i1.PropertyValue.scalar(
        retireAfter!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'selector'] = _i1.PropertyValue.scalar(selector);
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
      r'Cannot uriEncode DkimRotationKey: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DkimRotationKeyCopyWith<$Res> {
  factory $$DkimRotationKeyCopyWith(DkimRotationKey value) =
      _DkimRotationKeyCopyWith<$Res>;

  $Res call({
    _i3.DateTime? activatesAt,
    _i3.DateTime? publishedAt,
    _i3.String? recordName,
    _i3.String? recordValue,
    _i3.DateTime? retireAfter,
    _i3.String? selector,
  });
  _i3.DateTime? get activatesAt;
  _i3.DateTime? get publishedAt;
  _i3.String get recordName;
  _i3.String get recordValue;
  _i3.DateTime? get retireAfter;
  _i3.String get selector;
}

class _DkimRotationKeyCopyWith<$Res>
    implements $$DkimRotationKeyCopyWith<$Res> {
  _DkimRotationKeyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DkimRotationKey _value;

  @_i3.override
  _i3.DateTime? get activatesAt => _value.activatesAt;

  @_i3.override
  _i3.DateTime? get publishedAt => _value.publishedAt;

  @_i3.override
  _i3.String get recordName => _value.recordName;

  @_i3.override
  _i3.String get recordValue => _value.recordValue;

  @_i3.override
  _i3.DateTime? get retireAfter => _value.retireAfter;

  @_i3.override
  _i3.String get selector => _value.selector;

  @_i3.override
  $Res call({
    _i3.Object? activatesAt = _sentinel,
    _i3.Object? publishedAt = _sentinel,
    _i3.Object? recordName = _sentinel,
    _i3.Object? recordValue = _sentinel,
    _i3.Object? retireAfter = _sentinel,
    _i3.Object? selector = _sentinel,
  }) {
    return (DkimRotationKey(
      activatesAt: _i3.identical(activatesAt, _sentinel)
          ? this.activatesAt
          : (activatesAt as _i3.DateTime?),
      publishedAt: _i3.identical(publishedAt, _sentinel)
          ? this.publishedAt
          : (publishedAt as _i3.DateTime?),
      recordName: _i3.identical(recordName, _sentinel)
          ? this.recordName
          : (recordName as _i3.String),
      recordValue: _i3.identical(recordValue, _sentinel)
          ? this.recordValue
          : (recordValue as _i3.String),
      retireAfter: _i3.identical(retireAfter, _sentinel)
          ? this.retireAfter
          : (retireAfter as _i3.DateTime?),
      selector: _i3.identical(selector, _sentinel)
          ? this.selector
          : (selector as _i3.String),
    ) as $Res);
  }
}
