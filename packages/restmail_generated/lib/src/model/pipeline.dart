// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/pipeline_direction_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/pipeline_domain.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Pipeline extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const Pipeline({
    required this.active,
    required this.createdAt,
    required this.direction,
    required this.domainId,
    required this.filters,
    required this.id,
    required this.updatedAt,
    this.domain,
  });

  factory Pipeline.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Pipeline: contains complex types',
    );
  }

  factory Pipeline.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Pipeline');
    return Pipeline(
      active: _$map[r'active'].decodeJsonBool(context: r'Pipeline.active'),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Pipeline.created_at',
      ),
      direction: _i4.PipelineDirectionModel.fromJson(_$map[r'direction']),
      domain: _$map[r'domain'] == null
          ? null
          : _i5.PipelineDomain.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'Pipeline.domain_id',
      ),
      filters: _$map[r'filters'],
      id: _$map[r'id'].decodeJsonInt(context: r'Pipeline.id'),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Pipeline.updated_at',
      ),
    );
  }

  factory Pipeline.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Pipeline: contains complex types',
    );
  }

  final _i3.bool active;

  final _i3.DateTime createdAt;

  final _i4.PipelineDirectionModel direction;

  final _i5.PipelineDomain? domain;

  final _i3.int domainId;

  final _i3.Object? filters;

  final _i3.int id;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'direction': direction.toJson(),
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'filters': _i1.encodeUnknownJson(filters, context: r'Pipeline.filters'),
    r'id': id,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$PipelineCopyWith<Pipeline> get copyWith => _PipelineCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Pipeline &&
        other.active == this.active &&
        other.createdAt == this.createdAt &&
        other.direction == this.direction &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.filters == this.filters &&
        other.id == this.id &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      createdAt,
      direction,
      domain,
      domainId,
      filters,
      id,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Pipeline: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Pipeline: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PipelineCopyWith<$Res> {
  factory $$PipelineCopyWith(Pipeline value) = _PipelineCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.DateTime? createdAt,
    _i4.PipelineDirectionModel? direction,
    _i5.PipelineDomain? domain,
    _i3.int? domainId,
    _i3.Object? filters,
    _i3.int? id,
    _i3.DateTime? updatedAt,
  });
  _i3.bool get active;
  _i3.DateTime get createdAt;
  _i4.PipelineDirectionModel get direction;
  _i5.PipelineDomain? get domain;
  _i3.int get domainId;
  _i3.Object? get filters;
  _i3.int get id;
  _i3.DateTime get updatedAt;
}

class _PipelineCopyWith<$Res> implements $$PipelineCopyWith<$Res> {
  _PipelineCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Pipeline _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i4.PipelineDirectionModel get direction => _value.direction;

  @_i3.override
  _i5.PipelineDomain? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.Object? get filters => _value.filters;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? filters = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Pipeline(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i4.PipelineDirectionModel),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i5.PipelineDomain?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      filters: _i3.identical(filters, _sentinel) ? this.filters : filters,
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
