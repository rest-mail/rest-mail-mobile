// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/device_response.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeviceListResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeviceListResponse({required this.devices, required this.platforms});

  factory DeviceListResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DeviceListResponse: contains complex types',
    );
  }

  factory DeviceListResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeviceListResponse');
    return DeviceListResponse(
      devices: _$map[r'devices']
          .decodeJsonList<_i3.Object?>(context: r'DeviceListResponse.devices')
          .map(_i4.DeviceResponse.fromJson)
          .toList(),
      platforms: _$map[r'platforms'].decodeJsonList<_i3.String>(
        context: r'DeviceListResponse.platforms',
      ),
    );
  }

  factory DeviceListResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DeviceListResponse: contains complex types',
    );
  }

  final _i3.List<_i4.DeviceResponse> devices;

  final _i3.List<_i3.String> platforms;

  @_i3.override
  _i3.Object? toJson() => {
    r'devices': devices.map((e) => e.toJson()).toList(),
    r'platforms': platforms,
  };

  $$DeviceListResponseCopyWith<DeviceListResponse> get copyWith =>
      _DeviceListResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is DeviceListResponse &&
        _$deepEquals.equals(other.devices, this.devices) &&
        _$deepEquals.equals(other.platforms, this.platforms);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(devices),
      deepEquals.hash(platforms),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DeviceListResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DeviceListResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeviceListResponseCopyWith<$Res> {
  factory $$DeviceListResponseCopyWith(DeviceListResponse value) =
      _DeviceListResponseCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.DeviceResponse>? devices,
    _i3.List<_i3.String>? platforms,
  });
  _i3.List<_i4.DeviceResponse> get devices;
  _i3.List<_i3.String> get platforms;
}

class _DeviceListResponseCopyWith<$Res>
    implements $$DeviceListResponseCopyWith<$Res> {
  _DeviceListResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeviceListResponse _value;

  @_i3.override
  _i3.List<_i4.DeviceResponse> get devices => _value.devices;

  @_i3.override
  _i3.List<_i3.String> get platforms => _value.platforms;

  @_i3.override
  $Res call({
    _i3.Object? devices = _sentinel,
    _i3.Object? platforms = _sentinel,
  }) {
    return (DeviceListResponse(
      devices: _i3.identical(devices, _sentinel)
          ? this.devices
          : (devices as _i3.List<_i4.DeviceResponse>),
      platforms: _i3.identical(platforms, _sentinel)
          ? this.platforms
          : (platforms as _i3.List<_i3.String>),
    ) as $Res);
  }
}
