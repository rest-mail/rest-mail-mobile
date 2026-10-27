// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/sender_rule_list_type_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SenderRule extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SenderRule({
    required this.createdAt,
    required this.domainId,
    required this.id,
    required this.listType,
    required this.pattern,
    this.createdBy,
    this.reason,
  });

  factory SenderRule.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'created_at',
        r'created_by',
        r'domain_id',
        r'id',
        r'list_type',
        r'pattern',
        r'reason',
      },
      listKeys: {},
      context: r'SenderRule',
    );
    return SenderRule(
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'SenderRule.created_at',
      ),
      createdBy: _$values[r'created_by'].decodeSimpleNullableInt(
        context: r'SenderRule.created_by',
      ),
      domainId: _$values[r'domain_id'].decodeSimpleInt(
        context: r'SenderRule.domain_id',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'SenderRule.id'),
      listType: _i4.SenderRuleListTypeModel.fromSimple(
        _$values[r'list_type'],
        explode: explode,
      ),
      pattern: _$values[r'pattern'].decodeSimpleString(
        context: r'SenderRule.pattern',
      ),
      reason: _$values[r'reason'].decodeSimpleNullableString(
        context: r'SenderRule.reason',
      ),
    );
  }

  factory SenderRule.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SenderRule');
    return SenderRule(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'SenderRule.created_at',
      ),
      createdBy: _$map[r'created_by'].decodeJsonNullableInt(
        context: r'SenderRule.created_by',
      ),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'SenderRule.domain_id',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'SenderRule.id'),
      listType: _i4.SenderRuleListTypeModel.fromJson(_$map[r'list_type']),
      pattern: _$map[r'pattern'].decodeJsonString(
        context: r'SenderRule.pattern',
      ),
      reason: _$map[r'reason'].decodeJsonNullableString(
        context: r'SenderRule.reason',
      ),
    );
  }

  factory SenderRule.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'created_at',
        r'created_by',
        r'domain_id',
        r'id',
        r'list_type',
        r'pattern',
        r'reason',
      },
      listKeys: {},
      context: r'SenderRule',
    );
    return SenderRule(
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'SenderRule.created_at',
      ),
      createdBy: _$values[r'created_by'].decodeFormNullableInt(
        context: r'SenderRule.created_by',
      ),
      domainId: _$values[r'domain_id'].decodeFormInt(
        context: r'SenderRule.domain_id',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'SenderRule.id'),
      listType: _i4.SenderRuleListTypeModel.fromForm(
        _$values[r'list_type'],
        explode: explode,
      ),
      pattern: _$values[r'pattern'].decodeFormString(
        context: r'SenderRule.pattern',
      ),
      reason: _$values[r'reason'].decodeFormNullableString(
        context: r'SenderRule.reason',
      ),
    );
  }

  final _i3.DateTime createdAt;

  final _i3.int? createdBy;

  final _i3.int domainId;

  final _i3.int id;

  final _i4.SenderRuleListTypeModel listType;

  final _i3.String pattern;

  final _i3.String? reason;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'created_by': createdBy,
    r'domain_id': domainId,
    r'id': id,
    r'list_type': listType.toJson(),
    r'pattern': pattern,
    if (reason != null) r'reason': reason,
  };

  $$SenderRuleCopyWith<SenderRule> get copyWith => _SenderRuleCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SenderRule &&
        other.createdAt == this.createdAt &&
        other.createdBy == this.createdBy &&
        other.domainId == this.domainId &&
        other.id == this.id &&
        other.listType == this.listType &&
        other.pattern == this.pattern &&
        other.reason == this.reason;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      createdAt,
      createdBy,
      domainId,
      id,
      listType,
      pattern,
      reason,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    if (createdBy != null) {
      _$result[r'created_by'] = _i1.PropertyValue.scalar(createdBy!.toString());
    }
    _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId.toString());
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'list_type'] = _i1.PropertyValue.scalar(listType.toJson());
    _$result[r'pattern'] = _i1.PropertyValue.scalar(pattern);
    if (reason != null) {
      _$result[r'reason'] = _i1.PropertyValue.scalar(reason!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SenderRule: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SenderRuleCopyWith<$Res> {
  factory $$SenderRuleCopyWith(SenderRule value) = _SenderRuleCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i3.int? createdBy,
    _i3.int? domainId,
    _i3.int? id,
    _i4.SenderRuleListTypeModel? listType,
    _i3.String? pattern,
    _i3.String? reason,
  });
  _i3.DateTime get createdAt;
  _i3.int? get createdBy;
  _i3.int get domainId;
  _i3.int get id;
  _i4.SenderRuleListTypeModel get listType;
  _i3.String get pattern;
  _i3.String? get reason;
}

class _SenderRuleCopyWith<$Res> implements $$SenderRuleCopyWith<$Res> {
  _SenderRuleCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SenderRule _value;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.int? get createdBy => _value.createdBy;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i4.SenderRuleListTypeModel get listType => _value.listType;

  @_i3.override
  _i3.String get pattern => _value.pattern;

  @_i3.override
  _i3.String? get reason => _value.reason;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? createdBy = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? listType = _sentinel,
    _i3.Object? pattern = _sentinel,
    _i3.Object? reason = _sentinel,
  }) {
    return (SenderRule(
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      createdBy: _i3.identical(createdBy, _sentinel)
          ? this.createdBy
          : (createdBy as _i3.int?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      listType: _i3.identical(listType, _sentinel)
          ? this.listType
          : (listType as _i4.SenderRuleListTypeModel),
      pattern: _i3.identical(pattern, _sentinel)
          ? this.pattern
          : (pattern as _i3.String),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String?),
    ) as $Res);
  }
}
