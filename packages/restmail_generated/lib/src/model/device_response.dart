// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeviceResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeviceResponse({
    required this.createdAt,
    required this.environment,
    required this.id,
    required this.platform,
  });

  factory DeviceResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'created_at', r'environment', r'id', r'platform'},
      listKeys: {},
      context: r'DeviceResponse',
    );
    return DeviceResponse(
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'DeviceResponse.created_at',
      ),
      environment: _$values[r'environment'].decodeSimpleString(
        context: r'DeviceResponse.environment',
      ),
      id: _$values[r'id'].decodeSimpleString(context: r'DeviceResponse.id'),
      platform: _$values[r'platform'].decodeSimpleString(
        context: r'DeviceResponse.platform',
      ),
    );
  }

  factory DeviceResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeviceResponse');
    return DeviceResponse(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'DeviceResponse.created_at',
      ),
      environment: _$map[r'environment'].decodeJsonString(
        context: r'DeviceResponse.environment',
      ),
      id: _$map[r'id'].decodeJsonString(context: r'DeviceResponse.id'),
      platform: _$map[r'platform'].decodeJsonString(
        context: r'DeviceResponse.platform',
      ),
    );
  }

  factory DeviceResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'created_at', r'environment', r'id', r'platform'},
      listKeys: {},
      context: r'DeviceResponse',
    );
    return DeviceResponse(
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'DeviceResponse.created_at',
      ),
      environment: _$values[r'environment'].decodeFormString(
        context: r'DeviceResponse.environment',
      ),
      id: _$values[r'id'].decodeFormString(context: r'DeviceResponse.id'),
      platform: _$values[r'platform'].decodeFormString(
        context: r'DeviceResponse.platform',
      ),
    );
  }

  final _i3.DateTime createdAt;

  final _i3.String environment;

  final _i3.String id;

  final _i3.String platform;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'environment': environment,
    r'id': id,
    r'platform': platform,
  };

  $$DeviceResponseCopyWith<DeviceResponse> get copyWith =>
      _DeviceResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeviceResponse &&
        other.createdAt == this.createdAt &&
        other.environment == this.environment &&
        other.id == this.id &&
        other.platform == this.platform;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([createdAt, environment, id, platform]);
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
    _$result[r'environment'] = _i1.PropertyValue.scalar(environment);
    _$result[r'id'] = _i1.PropertyValue.scalar(id);
    _$result[r'platform'] = _i1.PropertyValue.scalar(platform);
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
      r'Cannot uriEncode DeviceResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeviceResponseCopyWith<$Res> {
  factory $$DeviceResponseCopyWith(DeviceResponse value) =
      _DeviceResponseCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i3.String? environment,
    _i3.String? id,
    _i3.String? platform,
  });
  _i3.DateTime get createdAt;
  _i3.String get environment;
  _i3.String get id;
  _i3.String get platform;
}

class _DeviceResponseCopyWith<$Res> implements $$DeviceResponseCopyWith<$Res> {
  _DeviceResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeviceResponse _value;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get environment => _value.environment;

  @_i3.override
  _i3.String get id => _value.id;

  @_i3.override
  _i3.String get platform => _value.platform;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? environment = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? platform = _sentinel,
  }) {
    return (DeviceResponse(
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      environment: _i3.identical(environment, _sentinel)
          ? this.environment
          : (environment as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.String),
      platform: _i3.identical(platform, _sentinel)
          ? this.platform
          : (platform as _i3.String),
    ) as $Res);
  }
}
