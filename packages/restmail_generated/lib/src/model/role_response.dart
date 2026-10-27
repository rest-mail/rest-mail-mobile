// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RoleResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RoleResponse({
    required this.capabilities,
    required this.description,
    required this.id,
    required this.name,
    required this.systemRole,
  });

  factory RoleResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'capabilities',
        r'description',
        r'id',
        r'name',
        r'system_role',
      },
      listKeys: {r'capabilities'},
      context: r'RoleResponse',
    );
    return RoleResponse(
      capabilities: _$values[r'capabilities'].decodeSimpleStringList(
        context: r'RoleResponse.capabilities',
      ),
      description: _$values[r'description'].decodeSimpleString(
        context: r'RoleResponse.description',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'RoleResponse.id'),
      name: _$values[r'name'].decodeSimpleString(context: r'RoleResponse.name'),
      systemRole: _$values[r'system_role'].decodeSimpleBool(
        context: r'RoleResponse.system_role',
      ),
    );
  }

  factory RoleResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RoleResponse');
    return RoleResponse(
      capabilities: _$map[r'capabilities'].decodeJsonList<_i3.String>(
        context: r'RoleResponse.capabilities',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'RoleResponse.description',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'RoleResponse.id'),
      name: _$map[r'name'].decodeJsonString(context: r'RoleResponse.name'),
      systemRole: _$map[r'system_role'].decodeJsonBool(
        context: r'RoleResponse.system_role',
      ),
    );
  }

  factory RoleResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'capabilities',
        r'description',
        r'id',
        r'name',
        r'system_role',
      },
      listKeys: {r'capabilities'},
      context: r'RoleResponse',
    );
    return RoleResponse(
      capabilities: _$values[r'capabilities'].decodeFormStringList(
        context: r'RoleResponse.capabilities',
      ),
      description: _$values[r'description'].decodeFormString(
        context: r'RoleResponse.description',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'RoleResponse.id'),
      name: _$values[r'name'].decodeFormString(context: r'RoleResponse.name'),
      systemRole: _$values[r'system_role'].decodeFormBool(
        context: r'RoleResponse.system_role',
      ),
    );
  }

  final _i3.List<_i3.String> capabilities;

  final _i3.String description;

  final _i3.int id;

  final _i3.String name;

  final _i3.bool systemRole;

  @_i3.override
  _i3.Object? toJson() => {
    r'capabilities': capabilities,
    r'description': description,
    r'id': id,
    r'name': name,
    r'system_role': systemRole,
  };

  $$RoleResponseCopyWith<RoleResponse> get copyWith =>
      _RoleResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is RoleResponse &&
        _$deepEquals.equals(other.capabilities, this.capabilities) &&
        other.description == this.description &&
        other.id == this.id &&
        other.name == this.name &&
        other.systemRole == this.systemRole;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(capabilities),
      description,
      id,
      name,
      systemRole,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'capabilities'] = _i1.PropertyValue.array(capabilities);
    _$result[r'description'] = _i1.PropertyValue.scalar(description);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'system_role'] = _i1.PropertyValue.scalar(systemRole.toString());
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
      r'Cannot uriEncode RoleResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RoleResponseCopyWith<$Res> {
  factory $$RoleResponseCopyWith(RoleResponse value) =
      _RoleResponseCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? capabilities,
    _i3.String? description,
    _i3.int? id,
    _i3.String? name,
    _i3.bool? systemRole,
  });
  _i3.List<_i3.String> get capabilities;
  _i3.String get description;
  _i3.int get id;
  _i3.String get name;
  _i3.bool get systemRole;
}

class _RoleResponseCopyWith<$Res> implements $$RoleResponseCopyWith<$Res> {
  _RoleResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RoleResponse _value;

  @_i3.override
  _i3.List<_i3.String> get capabilities => _value.capabilities;

  @_i3.override
  _i3.String get description => _value.description;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.bool get systemRole => _value.systemRole;

  @_i3.override
  $Res call({
    _i3.Object? capabilities = _sentinel,
    _i3.Object? description = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? systemRole = _sentinel,
  }) {
    return (RoleResponse(
      capabilities: _i3.identical(capabilities, _sentinel)
          ? this.capabilities
          : (capabilities as _i3.List<_i3.String>),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      systemRole: _i3.identical(systemRole, _sentinel)
          ? this.systemRole
          : (systemRole as _i3.bool),
    ) as $Res);
  }
}
