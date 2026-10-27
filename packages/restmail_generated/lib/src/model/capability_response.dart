// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CapabilityResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CapabilityResponse({
    required this.action,
    required this.description,
    required this.id,
    required this.name,
    required this.resource,
  });

  factory CapabilityResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'action', r'description', r'id', r'name', r'resource'},
      listKeys: {},
      context: r'CapabilityResponse',
    );
    return CapabilityResponse(
      action: _$values[r'action'].decodeSimpleString(
        context: r'CapabilityResponse.action',
      ),
      description: _$values[r'description'].decodeSimpleString(
        context: r'CapabilityResponse.description',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'CapabilityResponse.id'),
      name: _$values[r'name'].decodeSimpleString(
        context: r'CapabilityResponse.name',
      ),
      resource: _$values[r'resource'].decodeSimpleString(
        context: r'CapabilityResponse.resource',
      ),
    );
  }

  factory CapabilityResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CapabilityResponse');
    return CapabilityResponse(
      action: _$map[r'action'].decodeJsonString(
        context: r'CapabilityResponse.action',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'CapabilityResponse.description',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'CapabilityResponse.id'),
      name: _$map[r'name'].decodeJsonString(
        context: r'CapabilityResponse.name',
      ),
      resource: _$map[r'resource'].decodeJsonString(
        context: r'CapabilityResponse.resource',
      ),
    );
  }

  factory CapabilityResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'action', r'description', r'id', r'name', r'resource'},
      listKeys: {},
      context: r'CapabilityResponse',
    );
    return CapabilityResponse(
      action: _$values[r'action'].decodeFormString(
        context: r'CapabilityResponse.action',
      ),
      description: _$values[r'description'].decodeFormString(
        context: r'CapabilityResponse.description',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'CapabilityResponse.id'),
      name: _$values[r'name'].decodeFormString(
        context: r'CapabilityResponse.name',
      ),
      resource: _$values[r'resource'].decodeFormString(
        context: r'CapabilityResponse.resource',
      ),
    );
  }

  final _i3.String action;

  final _i3.String description;

  final _i3.int id;

  final _i3.String name;

  final _i3.String resource;

  @_i3.override
  _i3.Object? toJson() => {
    r'action': action,
    r'description': description,
    r'id': id,
    r'name': name,
    r'resource': resource,
  };

  $$CapabilityResponseCopyWith<CapabilityResponse> get copyWith =>
      _CapabilityResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CapabilityResponse &&
        other.action == this.action &&
        other.description == this.description &&
        other.id == this.id &&
        other.name == this.name &&
        other.resource == this.resource;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([action, description, id, name, resource]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'action'] = _i1.PropertyValue.scalar(action);
    _$result[r'description'] = _i1.PropertyValue.scalar(description);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'resource'] = _i1.PropertyValue.scalar(resource);
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
      r'Cannot uriEncode CapabilityResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CapabilityResponseCopyWith<$Res> {
  factory $$CapabilityResponseCopyWith(CapabilityResponse value) =
      _CapabilityResponseCopyWith<$Res>;

  $Res call({
    _i3.String? action,
    _i3.String? description,
    _i3.int? id,
    _i3.String? name,
    _i3.String? resource,
  });
  _i3.String get action;
  _i3.String get description;
  _i3.int get id;
  _i3.String get name;
  _i3.String get resource;
}

class _CapabilityResponseCopyWith<$Res>
    implements $$CapabilityResponseCopyWith<$Res> {
  _CapabilityResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CapabilityResponse _value;

  @_i3.override
  _i3.String get action => _value.action;

  @_i3.override
  _i3.String get description => _value.description;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.String get resource => _value.resource;

  @_i3.override
  $Res call({
    _i3.Object? action = _sentinel,
    _i3.Object? description = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? resource = _sentinel,
  }) {
    return (CapabilityResponse(
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action as _i3.String),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      resource: _i3.identical(resource, _sentinel)
          ? this.resource
          : (resource as _i3.String),
    ) as $Res);
  }
}
