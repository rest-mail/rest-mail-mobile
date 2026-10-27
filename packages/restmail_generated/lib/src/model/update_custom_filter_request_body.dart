// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/update_custom_filter_request_body_direction_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/update_custom_filter_request_body_filter_type_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateCustomFilterRequestBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateCustomFilterRequestBody({
    this.config,
    this.description,
    this.direction,
    this.domainId,
    this.enabled,
    this.filterType,
    this.name,
  });

  factory UpdateCustomFilterRequestBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'config',
        r'description',
        r'direction',
        r'domain_id',
        r'enabled',
        r'filter_type',
        r'name',
      },
      listKeys: {},
      context: r'UpdateCustomFilterRequestBody',
    );
    return UpdateCustomFilterRequestBody(
      config: _$values[r'config'],
      description: _$values[r'description'].decodeSimpleNullableString(
        context: r'UpdateCustomFilterRequestBody.description',
      ),
      direction: _$values[r'direction'] == null
          ? null
          : _i4.UpdateCustomFilterRequestBodyDirectionModel.fromSimple(
              _$values[r'direction'],
              explode: explode,
            ),
      domainId: _$values[r'domain_id'].decodeSimpleNullableInt(
        context: r'UpdateCustomFilterRequestBody.domain_id',
      ),
      enabled: _$values[r'enabled'].decodeSimpleNullableBool(
        context: r'UpdateCustomFilterRequestBody.enabled',
      ),
      filterType: _$values[r'filter_type'] == null
          ? null
          : _i5.UpdateCustomFilterRequestBodyFilterTypeModel.fromSimple(
              _$values[r'filter_type'],
              explode: explode,
            ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'UpdateCustomFilterRequestBody.name',
      ),
    );
  }

  factory UpdateCustomFilterRequestBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateCustomFilterRequestBody');
    return UpdateCustomFilterRequestBody(
      config: _$map[r'config'],
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'UpdateCustomFilterRequestBody.description',
      ),
      direction: _$map[r'direction'] == null
          ? null
          : _i4.UpdateCustomFilterRequestBodyDirectionModel.fromJson(
              _$map[r'direction'],
            ),
      domainId: _$map[r'domain_id'].decodeJsonNullableInt(
        context: r'UpdateCustomFilterRequestBody.domain_id',
      ),
      enabled: _$map[r'enabled'].decodeJsonNullableBool(
        context: r'UpdateCustomFilterRequestBody.enabled',
      ),
      filterType: _$map[r'filter_type'] == null
          ? null
          : _i5.UpdateCustomFilterRequestBodyFilterTypeModel.fromJson(
              _$map[r'filter_type'],
            ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'UpdateCustomFilterRequestBody.name',
      ),
    );
  }

  factory UpdateCustomFilterRequestBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'config',
        r'description',
        r'direction',
        r'domain_id',
        r'enabled',
        r'filter_type',
        r'name',
      },
      listKeys: {},
      context: r'UpdateCustomFilterRequestBody',
    );
    return UpdateCustomFilterRequestBody(
      config: _$values[r'config'].decodeFormNullableString(
        context: r'UpdateCustomFilterRequestBody.config',
      ),
      description: _$values[r'description'].decodeFormNullableString(
        context: r'UpdateCustomFilterRequestBody.description',
      ),
      direction: _$values[r'direction'] == null
          ? null
          : _i4.UpdateCustomFilterRequestBodyDirectionModel.fromForm(
              _$values[r'direction'],
              explode: explode,
            ),
      domainId: _$values[r'domain_id'].decodeFormNullableInt(
        context: r'UpdateCustomFilterRequestBody.domain_id',
      ),
      enabled: _$values[r'enabled'].decodeFormNullableBool(
        context: r'UpdateCustomFilterRequestBody.enabled',
      ),
      filterType: _$values[r'filter_type'] == null
          ? null
          : _i5.UpdateCustomFilterRequestBodyFilterTypeModel.fromForm(
              _$values[r'filter_type'],
              explode: explode,
            ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'UpdateCustomFilterRequestBody.name',
      ),
    );
  }

  final _i3.Object? config;

  final _i3.String? description;

  final _i4.UpdateCustomFilterRequestBodyDirectionModel? direction;

  final _i3.int? domainId;

  final _i3.bool? enabled;

  final _i5.UpdateCustomFilterRequestBodyFilterTypeModel? filterType;

  final _i3.String? name;

  @_i3.override
  _i3.Object? toJson() => {
    if (config != null)
      r'config': _i1.encodeUnknownJson(
        config,
        context: r'UpdateCustomFilterRequestBody.config',
      ),
    r'description': description,
    r'direction': direction?.toJson(),
    r'domain_id': domainId,
    r'enabled': enabled,
    r'filter_type': filterType?.toJson(),
    r'name': name,
  };

  $$UpdateCustomFilterRequestBodyCopyWith<UpdateCustomFilterRequestBody>
  get copyWith => _UpdateCustomFilterRequestBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateCustomFilterRequestBody &&
        other.config == this.config &&
        other.description == this.description &&
        other.direction == this.direction &&
        other.domainId == this.domainId &&
        other.enabled == this.enabled &&
        other.filterType == this.filterType &&
        other.name == this.name;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      config,
      description,
      direction,
      domainId,
      enabled,
      filterType,
      name,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (config != null) {
      _$result[r'config'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          config!,
          context: r'UpdateCustomFilterRequestBody.config',
        ),
      );
    }
    if (description != null) {
      _$result[r'description'] = _i1.PropertyValue.scalar(description!);
    }
    if (direction != null) {
      _$result[r'direction'] = _i1.PropertyValue.scalar(direction!.toJson());
    }
    if (domainId != null) {
      _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId!.toString());
    }
    if (enabled != null) {
      _$result[r'enabled'] = _i1.PropertyValue.scalar(enabled!.toString());
    }
    if (filterType != null) {
      _$result[r'filter_type'] = _i1.PropertyValue.scalar(filterType!.toJson());
    }
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode UpdateCustomFilterRequestBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateCustomFilterRequestBodyCopyWith<$Res> {
  factory $$UpdateCustomFilterRequestBodyCopyWith(
    UpdateCustomFilterRequestBody value,
  ) = _UpdateCustomFilterRequestBodyCopyWith<$Res>;

  $Res call({
    _i3.Object? config,
    _i3.String? description,
    _i4.UpdateCustomFilterRequestBodyDirectionModel? direction,
    _i3.int? domainId,
    _i3.bool? enabled,
    _i5.UpdateCustomFilterRequestBodyFilterTypeModel? filterType,
    _i3.String? name,
  });
  _i3.Object? get config;
  _i3.String? get description;
  _i4.UpdateCustomFilterRequestBodyDirectionModel? get direction;
  _i3.int? get domainId;
  _i3.bool? get enabled;
  _i5.UpdateCustomFilterRequestBodyFilterTypeModel? get filterType;
  _i3.String? get name;
}

class _UpdateCustomFilterRequestBodyCopyWith<$Res>
    implements $$UpdateCustomFilterRequestBodyCopyWith<$Res> {
  _UpdateCustomFilterRequestBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateCustomFilterRequestBody _value;

  @_i3.override
  _i3.Object? get config => _value.config;

  @_i3.override
  _i3.String? get description => _value.description;

  @_i3.override
  _i4.UpdateCustomFilterRequestBodyDirectionModel? get direction =>
      _value.direction;

  @_i3.override
  _i3.int? get domainId => _value.domainId;

  @_i3.override
  _i3.bool? get enabled => _value.enabled;

  @_i3.override
  _i5.UpdateCustomFilterRequestBodyFilterTypeModel? get filterType =>
      _value.filterType;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  $Res call({
    _i3.Object? config = _sentinel,
    _i3.Object? description = _sentinel,
    _i3.Object? direction = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? enabled = _sentinel,
    _i3.Object? filterType = _sentinel,
    _i3.Object? name = _sentinel,
  }) {
    return (UpdateCustomFilterRequestBody(
      config: _i3.identical(config, _sentinel) ? this.config : config,
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      direction: _i3.identical(direction, _sentinel)
          ? this.direction
          : (direction as _i4.UpdateCustomFilterRequestBodyDirectionModel?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int?),
      enabled: _i3.identical(enabled, _sentinel)
          ? this.enabled
          : (enabled as _i3.bool?),
      filterType: _i3.identical(filterType, _sentinel)
          ? this.filterType
          : (filterType as _i5.UpdateCustomFilterRequestBodyFilterTypeModel?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
    ) as $Res);
  }
}
