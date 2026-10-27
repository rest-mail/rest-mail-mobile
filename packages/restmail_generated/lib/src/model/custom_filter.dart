// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/custom_filter_direction_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/custom_filter_filter_type_model.dart'
    as _i6;
import 'package:restmail_generated/src/model/pipeline_domain.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CustomFilter extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CustomFilter({
    required this.config,
    required this.createdAt,
    required this.description,
    required this.direction,
    required this.domainId,
    required this.enabled,
    required this.filterType,
    required this.id,
    required this.name,
    required this.updatedAt,
    this.domain,
  });

  factory CustomFilter.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CustomFilter: contains complex types',
    );
  }

  factory CustomFilter.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CustomFilter');
    return CustomFilter(
      config: _$map[r'config'],
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'CustomFilter.created_at',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'CustomFilter.description',
      ),
      direction: _i4.CustomFilterDirectionModel.fromJson(_$map[r'direction']),
      domain: _$map[r'domain'] == null
          ? null
          : _i5.PipelineDomain.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'CustomFilter.domain_id',
      ),
      enabled: _$map[r'enabled'].decodeJsonBool(
        context: r'CustomFilter.enabled',
      ),
      filterType: _i6.CustomFilterFilterTypeModel.fromJson(
        _$map[r'filter_type'],
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'CustomFilter.id'),
      name: _$map[r'name'].decodeJsonString(context: r'CustomFilter.name'),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'CustomFilter.updated_at',
      ),
    );
  }

  factory CustomFilter.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CustomFilter: contains complex types',
    );
  }

  final _i3.Object? config;

  final _i3.DateTime createdAt;

  final _i3.String description;

  final _i4.CustomFilterDirectionModel direction;

  final _i5.PipelineDomain? domain;

  final _i3.int domainId;

  final _i3.bool enabled;

  final _i6.CustomFilterFilterTypeModel filterType;

  final _i3.int id;

  final _i3.String name;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'config': _i1.encodeUnknownJson(config, context: r'CustomFilter.config'),
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'description': description,
    r'direction': direction.toJson(),
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'enabled': enabled,
    r'filter_type': filterType.toJson(),
    r'id': id,
    r'name': name,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$CustomFilterCopyWith<CustomFilter> get copyWith =>
      _CustomFilterCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CustomFilter &&
        other.config == this.config &&
        other.createdAt == this.createdAt &&
        other.description == this.description &&
        other.direction == this.direction &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.enabled == this.enabled &&
        other.filterType == this.filterType &&
        other.id == this.id &&
        other.name == this.name &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      config,
      createdAt,
      description,
      direction,
      domain,
      domainId,
      enabled,
      filterType,
      id,
      name,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CustomFilter: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CustomFilter: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CustomFilterCopyWith<$Res> {
  factory $$CustomFilterCopyWith(CustomFilter value) =
      _CustomFilterCopyWith<$Res>;

  $Res call({
    _i3.Object? config,
    _i3.DateTime? createdAt,
    _i3.String? description,
    _i4.CustomFilterDirectionModel? direction,
    _i5.PipelineDomain? domain,
    _i3.int? domainId,
    _i3.bool? enabled,
    _i6.CustomFilterFilterTypeModel? filterType,
    _i3.int? id,
    _i3.String? name,
    _i3.DateTime? updatedAt,
  });
  _i3.Object? get config;
  _i3.DateTime get createdAt;
  _i3.String get description;
  _i4.CustomFilterDirectionModel get direction;
  _i5.PipelineDomain? get domain;
  _i3.int get domainId;
  _i3.bool get enabled;
  _i6.CustomFilterFilterTypeModel get filterType;
  _i3.int get id;
  _i3.String get name;
  _i3.DateTime get updatedAt;
}

class _CustomFilterCopyWith<$Res> implements $$CustomFilterCopyWith<$Res> {
  _CustomFilterCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CustomFilter _value;

  @_i3.override
  _i3.Object? get config => _value.config;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get description => _value.description;

  @_i3.override
  _i4.CustomFilterDirectionModel get direction => _value.direction;

  @_i3.override
  _i5.PipelineDomain? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.bool get enabled => _value.enabled;

  @_i3.override
  _i6.CustomFilterFilterTypeModel get filterType => _value.filterType;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? config = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? description = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? enabled = _sentinel,
    _i3.Object? filterType = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (CustomFilter(
      config: _i3.identical(config, _sentinel) ? this.config : config,
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i4.CustomFilterDirectionModel),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i5.PipelineDomain?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool),
      filterType: _i3.identical(filterType, _sentinel)
          ? this.filterType
          : (filterType as _i6.CustomFilterFilterTypeModel),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
