// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/create_pipeline_request_body_direction_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreatePipelineRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreatePipelineRequestBody({
    this.active,
    this.direction,
    this.domainId,
    this.filters,
  });

  factory CreatePipelineRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'direction', r'domain_id', r'filters'},
      listKeys: {},
      context: r'CreatePipelineRequestBody',
    );
    return CreatePipelineRequestBody(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'CreatePipelineRequestBody.active',
      ),
      direction: _$values[r'direction'] == null
          ? null
          : _i4.CreatePipelineRequestBodyDirectionModel.fromSimple(
              _$values[r'direction'],
              explode: explode,
            ),
      domainId: _$values[r'domain_id'].decodeSimpleNullableInt(
        context: r'CreatePipelineRequestBody.domain_id',
      ),
      filters: _$values[r'filters'],
    );
  }

  factory CreatePipelineRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreatePipelineRequestBody');
    return CreatePipelineRequestBody(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'CreatePipelineRequestBody.active',
      ),
      direction: _$map[r'direction'] == null
          ? null
          : _i4.CreatePipelineRequestBodyDirectionModel.fromJson(
              _$map[r'direction'],
            ),
      domainId: _$map[r'domain_id'].decodeJsonNullableInt(
        context: r'CreatePipelineRequestBody.domain_id',
      ),
      filters: _$map[r'filters'],
    );
  }

  factory CreatePipelineRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'direction', r'domain_id', r'filters'},
      listKeys: {},
      context: r'CreatePipelineRequestBody',
    );
    return CreatePipelineRequestBody(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'CreatePipelineRequestBody.active',
      ),
      direction: _$values[r'direction'] == null
          ? null
          : _i4.CreatePipelineRequestBodyDirectionModel.fromForm(
              _$values[r'direction'],
              explode: explode,
            ),
      domainId: _$values[r'domain_id'].decodeFormNullableInt(
        context: r'CreatePipelineRequestBody.domain_id',
      ),
      filters: _$values[r'filters'].decodeFormNullableString(
        context: r'CreatePipelineRequestBody.filters',
      ),
    );
  }

  final _i3.bool? active;

  final _i4.CreatePipelineRequestBodyDirectionModel? direction;

  final _i3.int? domainId;

  final _i3.Object? filters;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    if (direction != null) r'direction': direction?.toJson(),
    if (domainId != null) r'domain_id': domainId,
    if (filters != null)
      r'filters': _i1.encodeUnknownJson(
        filters,
        context: r'CreatePipelineRequestBody.filters',
      ),
  };

  $$CreatePipelineRequestBodyCopyWith<CreatePipelineRequestBody> get copyWith =>
      _CreatePipelineRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatePipelineRequestBody &&
        other.active == this.active &&
        other.direction == this.direction &&
        other.domainId == this.domainId &&
        other.filters == this.filters;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([active, direction, domainId, filters]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (active != null) {
      _$result[r'active'] = _i1.PropertyValue.scalar(active!.toString());
    }
    if (direction != null) {
      _$result[r'direction'] = _i1.PropertyValue.scalar(direction!.toJson());
    }
    if (domainId != null) {
      _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId!.toString());
    }
    if (filters != null) {
      _$result[r'filters'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          filters!,
          context: r'CreatePipelineRequestBody.filters',
        ),
      );
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
      r'Cannot uriEncode CreatePipelineRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreatePipelineRequestBodyCopyWith<$Res> {
  factory $$CreatePipelineRequestBodyCopyWith(CreatePipelineRequestBody value) =
      _CreatePipelineRequestBodyCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i4.CreatePipelineRequestBodyDirectionModel? direction,
    _i3.int? domainId,
    _i3.Object? filters,
  });
  _i3.bool? get active;
  _i4.CreatePipelineRequestBodyDirectionModel? get direction;
  _i3.int? get domainId;
  _i3.Object? get filters;
}

class _CreatePipelineRequestBodyCopyWith<$Res>
    implements $$CreatePipelineRequestBodyCopyWith<$Res> {
  _CreatePipelineRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreatePipelineRequestBody _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i4.CreatePipelineRequestBodyDirectionModel? get direction =>
      _value.direction;

  @_i3.override
  _i3.int? get domainId => _value.domainId;

  @_i3.override
  _i3.Object? get filters => _value.filters;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? filters = _sentinel,
  }) {
    return (CreatePipelineRequestBody(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i4.CreatePipelineRequestBodyDirectionModel?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int?),
      filters: _i3.identical(filters, _sentinel) ? this.filters : filters,
    ) as $Res);
  }
}
