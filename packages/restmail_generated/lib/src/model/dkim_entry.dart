// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DkimEntry extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DkimEntry({
    required this.ageSeconds,
    required this.createdAt,
    required this.domain,
    required this.domainId,
    required this.hasKey,
    required this.selector,
  });

  factory DkimEntry.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'age_seconds',
        r'created_at',
        r'domain',
        r'domain_id',
        r'has_key',
        r'selector',
      },
      listKeys: {},
      context: r'DkimEntry',
    );
    return DkimEntry(
      ageSeconds: _$values[r'age_seconds'].decodeSimpleNullableDouble(
        context: r'DkimEntry.age_seconds',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleNullableDateTime(
        context: r'DkimEntry.created_at',
      ),
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'DkimEntry.domain',
      ),
      domainId: _$values[r'domain_id'].decodeSimpleInt(
        context: r'DkimEntry.domain_id',
      ),
      hasKey: _$values[r'has_key'].decodeSimpleBool(
        context: r'DkimEntry.has_key',
      ),
      selector: _$values[r'selector'].decodeSimpleString(
        context: r'DkimEntry.selector',
      ),
    );
  }

  factory DkimEntry.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DkimEntry');
    return DkimEntry(
      ageSeconds: _$map[r'age_seconds'].decodeJsonNullableDouble(
        context: r'DkimEntry.age_seconds',
      ),
      createdAt: _$map[r'created_at'].decodeJsonNullableDateTime(
        context: r'DkimEntry.created_at',
      ),
      domain: _$map[r'domain'].decodeJsonString(context: r'DkimEntry.domain'),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'DkimEntry.domain_id',
      ),
      hasKey: _$map[r'has_key'].decodeJsonBool(context: r'DkimEntry.has_key'),
      selector: _$map[r'selector'].decodeJsonString(
        context: r'DkimEntry.selector',
      ),
    );
  }

  factory DkimEntry.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'age_seconds',
        r'created_at',
        r'domain',
        r'domain_id',
        r'has_key',
        r'selector',
      },
      listKeys: {},
      context: r'DkimEntry',
    );
    return DkimEntry(
      ageSeconds: _$values[r'age_seconds'].decodeFormNullableDouble(
        context: r'DkimEntry.age_seconds',
      ),
      createdAt: _$values[r'created_at'].decodeFormNullableDateTime(
        context: r'DkimEntry.created_at',
      ),
      domain: _$values[r'domain'].decodeFormString(
        context: r'DkimEntry.domain',
      ),
      domainId: _$values[r'domain_id'].decodeFormInt(
        context: r'DkimEntry.domain_id',
      ),
      hasKey: _$values[r'has_key'].decodeFormBool(
        context: r'DkimEntry.has_key',
      ),
      selector: _$values[r'selector'].decodeFormString(
        context: r'DkimEntry.selector',
      ),
    );
  }

  final _i3.double? ageSeconds;

  final _i3.DateTime? createdAt;

  final _i3.String domain;

  final _i3.int domainId;

  final _i3.bool hasKey;

  final _i3.String selector;

  @_i3.override
  _i3.Object? toJson() => {
    r'age_seconds': ageSeconds,
    r'created_at': createdAt?.toTimeZonedIso8601String(),
    r'domain': domain,
    r'domain_id': domainId,
    r'has_key': hasKey,
    r'selector': selector,
  };

  $$DkimEntryCopyWith<DkimEntry> get copyWith => _DkimEntryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DkimEntry &&
        other.ageSeconds == this.ageSeconds &&
        other.createdAt == this.createdAt &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.hasKey == this.hasKey &&
        other.selector == this.selector;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      ageSeconds,
      createdAt,
      domain,
      domainId,
      hasKey,
      selector,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (ageSeconds != null) {
      _$result[r'age_seconds'] = _i1.PropertyValue.scalar(
        ageSeconds!.toString(),
      );
    }
    if (createdAt != null) {
      _$result[r'created_at'] = _i1.PropertyValue.scalar(
        createdAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'domain'] = _i1.PropertyValue.scalar(domain);
    _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId.toString());
    _$result[r'has_key'] = _i1.PropertyValue.scalar(hasKey.toString());
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
      r'Cannot uriEncode DkimEntry: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DkimEntryCopyWith<$Res> {
  factory $$DkimEntryCopyWith(DkimEntry value) = _DkimEntryCopyWith<$Res>;

  $Res call({
    _i3.double? ageSeconds,
    _i3.DateTime? createdAt,
    _i3.String? domain,
    _i3.int? domainId,
    _i3.bool? hasKey,
    _i3.String? selector,
  });
  _i3.double? get ageSeconds;
  _i3.DateTime? get createdAt;
  _i3.String get domain;
  _i3.int get domainId;
  _i3.bool get hasKey;
  _i3.String get selector;
}

class _DkimEntryCopyWith<$Res> implements $$DkimEntryCopyWith<$Res> {
  _DkimEntryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DkimEntry _value;

  @_i3.override
  _i3.double? get ageSeconds => _value.ageSeconds;

  @_i3.override
  _i3.DateTime? get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.bool get hasKey => _value.hasKey;

  @_i3.override
  _i3.String get selector => _value.selector;

  @_i3.override
  $Res call({
    _i3.Object? ageSeconds = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? hasKey = _sentinel,
    _i3.Object? selector = _sentinel,
  }) {
    return (DkimEntry(
      ageSeconds: _i3.identical(ageSeconds, _sentinel)
          ? this.ageSeconds
          : (ageSeconds as _i3.double?),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime?),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      hasKey: _i3.identical(hasKey, _sentinel)
          ? this.hasKey
          : (hasKey as _i3.bool),
      selector: _i3.identical(selector, _sentinel)
          ? this.selector
          : (selector as _i3.String),
    ) as $Res);
  }
}
