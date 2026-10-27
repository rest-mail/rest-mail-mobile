// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdatePipelineRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdatePipelineRequestBody({
    this.active,
    this.direction,
    this.domainId,
    this.filters,
  });

  factory UpdatePipelineRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'active', r'direction', r'domain_id', r'filters'},
      listKeys: {},
      context: r'UpdatePipelineRequestBody',
    );
    return UpdatePipelineRequestBody(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'UpdatePipelineRequestBody.active',
      ),
      direction: _$values[r'direction'].decodeSimpleNullableString(
        context: r'UpdatePipelineRequestBody.direction',
      ),
      domainId: _$values[r'domain_id'].decodeSimpleNullableInt(
        context: r'UpdatePipelineRequestBody.domain_id',
      ),
      filters: _$values[r'filters'],
    );
  }

  factory UpdatePipelineRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdatePipelineRequestBody');
    return UpdatePipelineRequestBody(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'UpdatePipelineRequestBody.active',
      ),
      direction: _$map[r'direction'].decodeJsonNullableString(
        context: r'UpdatePipelineRequestBody.direction',
      ),
      domainId: _$map[r'domain_id'].decodeJsonNullableInt(
        context: r'UpdatePipelineRequestBody.domain_id',
      ),
      filters: _$map[r'filters'],
    );
  }

  factory UpdatePipelineRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'active', r'direction', r'domain_id', r'filters'},
      listKeys: {},
      context: r'UpdatePipelineRequestBody',
    );
    return UpdatePipelineRequestBody(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'UpdatePipelineRequestBody.active',
      ),
      direction: _$values[r'direction'].decodeFormNullableString(
        context: r'UpdatePipelineRequestBody.direction',
      ),
      domainId: _$values[r'domain_id'].decodeFormNullableInt(
        context: r'UpdatePipelineRequestBody.domain_id',
      ),
      filters: _$values[r'filters'].decodeFormNullableString(
        context: r'UpdatePipelineRequestBody.filters',
      ),
    );
  }

  final _i3.bool? active;

  final _i3.String? direction;

  final _i3.int? domainId;

  final _i3.Object? filters;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'direction': direction,
    r'domain_id': domainId,
    if (filters != null)
      r'filters': _i1.encodeUnknownJson(
        filters,
        context: r'UpdatePipelineRequestBody.filters',
      ),
  };

  $$UpdatePipelineRequestBodyCopyWith<UpdatePipelineRequestBody> get copyWith =>
      _UpdatePipelineRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePipelineRequestBody &&
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
      _$result[r'direction'] = _i1.PropertyValue.scalar(direction!);
    }
    if (domainId != null) {
      _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId!.toString());
    }
    if (filters != null) {
      _$result[r'filters'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          filters!,
          context: r'UpdatePipelineRequestBody.filters',
        ),
      );
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
      r'Cannot uriEncode UpdatePipelineRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdatePipelineRequestBodyCopyWith<$Res> {
  factory $$UpdatePipelineRequestBodyCopyWith(UpdatePipelineRequestBody value) =
      _UpdatePipelineRequestBodyCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.String? direction,
    _i3.int? domainId,
    _i3.Object? filters,
  });
  _i3.bool? get active;
  _i3.String? get direction;
  _i3.int? get domainId;
  _i3.Object? get filters;
}

class _UpdatePipelineRequestBodyCopyWith<$Res>
    implements $$UpdatePipelineRequestBodyCopyWith<$Res> {
  _UpdatePipelineRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdatePipelineRequestBody _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.String? get direction => _value.direction;

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
    return (UpdatePipelineRequestBody(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i3.String?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int?),
      filters: _i3.identical(filters, _sentinel) ? this.filters : filters,
    ) as $Res);
  }
}
