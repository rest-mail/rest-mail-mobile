// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/pipeline_domain_dmarc_policy_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/pipeline_domain_sending_policy_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/pipeline_domain_server_type_model.dart'
    as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PipelineDomain extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PipelineDomain({
    required this.active,
    required this.createdAt,
    required this.defaultQuotaBytes,
    required this.dkimSelector,
    required this.dmarcPolicy,
    required this.id,
    required this.name,
    required this.sendingPolicy,
    required this.serverType,
    required this.updatedAt,
  });

  factory PipelineDomain.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'active',
        r'created_at',
        r'default_quota_bytes',
        r'dkim_selector',
        r'dmarc_policy',
        r'id',
        r'name',
        r'sending_policy',
        r'server_type',
        r'updated_at',
      },
      listKeys: {},
      context: r'PipelineDomain',
    );
    return PipelineDomain(
      active: _$values[r'active'].decodeSimpleBool(
        context: r'PipelineDomain.active',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'PipelineDomain.created_at',
      ),
      defaultQuotaBytes: _$values[r'default_quota_bytes'].decodeSimpleInt(
        context: r'PipelineDomain.default_quota_bytes',
      ),
      dkimSelector: _$values[r'dkim_selector'].decodeSimpleString(
        context: r'PipelineDomain.dkim_selector',
      ),
      dmarcPolicy: _i4.PipelineDomainDmarcPolicyModel.fromSimple(
        _$values[r'dmarc_policy'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'PipelineDomain.id'),
      name: _$values[r'name'].decodeSimpleString(
        context: r'PipelineDomain.name',
      ),
      sendingPolicy: _i5.PipelineDomainSendingPolicyModel.fromSimple(
        _$values[r'sending_policy'],
        explode: explode,
      ),
      serverType: _i6.PipelineDomainServerTypeModel.fromSimple(
        _$values[r'server_type'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeSimpleDateTime(
        context: r'PipelineDomain.updated_at',
      ),
    );
  }

  factory PipelineDomain.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PipelineDomain');
    return PipelineDomain(
      active: _$map[r'active'].decodeJsonBool(
        context: r'PipelineDomain.active',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'PipelineDomain.created_at',
      ),
      defaultQuotaBytes: _$map[r'default_quota_bytes'].decodeJsonInt(
        context: r'PipelineDomain.default_quota_bytes',
      ),
      dkimSelector: _$map[r'dkim_selector'].decodeJsonString(
        context: r'PipelineDomain.dkim_selector',
      ),
      dmarcPolicy: _i4.PipelineDomainDmarcPolicyModel.fromJson(
        _$map[r'dmarc_policy'],
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'PipelineDomain.id'),
      name: _$map[r'name'].decodeJsonString(context: r'PipelineDomain.name'),
      sendingPolicy: _i5.PipelineDomainSendingPolicyModel.fromJson(
        _$map[r'sending_policy'],
      ),
      serverType: _i6.PipelineDomainServerTypeModel.fromJson(
        _$map[r'server_type'],
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'PipelineDomain.updated_at',
      ),
    );
  }

  factory PipelineDomain.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'active',
        r'created_at',
        r'default_quota_bytes',
        r'dkim_selector',
        r'dmarc_policy',
        r'id',
        r'name',
        r'sending_policy',
        r'server_type',
        r'updated_at',
      },
      listKeys: {},
      context: r'PipelineDomain',
    );
    return PipelineDomain(
      active: _$values[r'active'].decodeFormBool(
        context: r'PipelineDomain.active',
      ),
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'PipelineDomain.created_at',
      ),
      defaultQuotaBytes: _$values[r'default_quota_bytes'].decodeFormInt(
        context: r'PipelineDomain.default_quota_bytes',
      ),
      dkimSelector: _$values[r'dkim_selector'].decodeFormString(
        context: r'PipelineDomain.dkim_selector',
      ),
      dmarcPolicy: _i4.PipelineDomainDmarcPolicyModel.fromForm(
        _$values[r'dmarc_policy'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeFormInt(context: r'PipelineDomain.id'),
      name: _$values[r'name'].decodeFormString(context: r'PipelineDomain.name'),
      sendingPolicy: _i5.PipelineDomainSendingPolicyModel.fromForm(
        _$values[r'sending_policy'],
        explode: explode,
      ),
      serverType: _i6.PipelineDomainServerTypeModel.fromForm(
        _$values[r'server_type'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeFormDateTime(
        context: r'PipelineDomain.updated_at',
      ),
    );
  }

  final _i3.bool active;

  final _i3.DateTime createdAt;

  final _i3.int defaultQuotaBytes;

  final _i3.String dkimSelector;

  final _i4.PipelineDomainDmarcPolicyModel dmarcPolicy;

  final _i3.int id;

  final _i3.String name;

  final _i5.PipelineDomainSendingPolicyModel sendingPolicy;

  final _i6.PipelineDomainServerTypeModel serverType;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'default_quota_bytes': defaultQuotaBytes,
    r'dkim_selector': dkimSelector,
    r'dmarc_policy': dmarcPolicy.toJson(),
    r'id': id,
    r'name': name,
    r'sending_policy': sendingPolicy.toJson(),
    r'server_type': serverType.toJson(),
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$PipelineDomainCopyWith<PipelineDomain> get copyWith =>
      _PipelineDomainCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PipelineDomain &&
        other.active == this.active &&
        other.createdAt == this.createdAt &&
        other.defaultQuotaBytes == this.defaultQuotaBytes &&
        other.dkimSelector == this.dkimSelector &&
        other.dmarcPolicy == this.dmarcPolicy &&
        other.id == this.id &&
        other.name == this.name &&
        other.sendingPolicy == this.sendingPolicy &&
        other.serverType == this.serverType &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      createdAt,
      defaultQuotaBytes,
      dkimSelector,
      dmarcPolicy,
      id,
      name,
      sendingPolicy,
      serverType,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'active'] = _i1.PropertyValue.scalar(active.toString());
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'default_quota_bytes'] = _i1.PropertyValue.scalar(
      defaultQuotaBytes.toString(),
    );
    _$result[r'dkim_selector'] = _i1.PropertyValue.scalar(dkimSelector);
    _$result[r'dmarc_policy'] = _i1.PropertyValue.scalar(dmarcPolicy.toJson());
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'sending_policy'] = _i1.PropertyValue.scalar(
      sendingPolicy.toJson(),
    );
    _$result[r'server_type'] = _i1.PropertyValue.scalar(serverType.toJson());
    _$result[r'updated_at'] = _i1.PropertyValue.scalar(
      updatedAt.toTimeZonedIso8601String(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PipelineDomain: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PipelineDomainCopyWith<$Res> {
  factory $$PipelineDomainCopyWith(PipelineDomain value) =
      _PipelineDomainCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.DateTime? createdAt,
    _i3.int? defaultQuotaBytes,
    _i3.String? dkimSelector,
    _i4.PipelineDomainDmarcPolicyModel? dmarcPolicy,
    _i3.int? id,
    _i3.String? name,
    _i5.PipelineDomainSendingPolicyModel? sendingPolicy,
    _i6.PipelineDomainServerTypeModel? serverType,
    _i3.DateTime? updatedAt,
  });
  _i3.bool get active;
  _i3.DateTime get createdAt;
  _i3.int get defaultQuotaBytes;
  _i3.String get dkimSelector;
  _i4.PipelineDomainDmarcPolicyModel get dmarcPolicy;
  _i3.int get id;
  _i3.String get name;
  _i5.PipelineDomainSendingPolicyModel get sendingPolicy;
  _i6.PipelineDomainServerTypeModel get serverType;
  _i3.DateTime get updatedAt;
}

class _PipelineDomainCopyWith<$Res> implements $$PipelineDomainCopyWith<$Res> {
  _PipelineDomainCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final PipelineDomain _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.int get defaultQuotaBytes => _value.defaultQuotaBytes;

  @_i3.override
  _i3.String get dkimSelector => _value.dkimSelector;

  @_i3.override
  _i4.PipelineDomainDmarcPolicyModel get dmarcPolicy => _value.dmarcPolicy;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i5.PipelineDomainSendingPolicyModel get sendingPolicy =>
      _value.sendingPolicy;

  @_i3.override
  _i6.PipelineDomainServerTypeModel get serverType => _value.serverType;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? defaultQuotaBytes = _sentinel,
    _i3.Object? dkimSelector = _sentinel,
    _i3.Object? dmarcPolicy = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? sendingPolicy = _sentinel,
    _i3.Object? serverType = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (PipelineDomain(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      defaultQuotaBytes: _i3.identical(defaultQuotaBytes, _sentinel)
          ? this.defaultQuotaBytes
          : (defaultQuotaBytes as _i3.int),
      dkimSelector: _i3.identical(dkimSelector, _sentinel)
          ? this.dkimSelector
          : (dkimSelector as _i3.String),
      dmarcPolicy: _i3.identical(dmarcPolicy, _sentinel)
          ? this.dmarcPolicy
          : (dmarcPolicy as _i4.PipelineDomainDmarcPolicyModel),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      sendingPolicy: _i3.identical(sendingPolicy, _sentinel)
          ? this.sendingPolicy
          : (sendingPolicy as _i5.PipelineDomainSendingPolicyModel),
      serverType: _i3.identical(serverType, _sentinel)
          ? this.serverType
          : (serverType as _i6.PipelineDomainServerTypeModel),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
