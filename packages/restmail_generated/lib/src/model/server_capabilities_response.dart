// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/server_capabilities_response_source_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerCapabilitiesResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerCapabilitiesResponse({
    required this.capabilities,
    required this.source,
  });

  factory ServerCapabilitiesResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'capabilities', r'source'},
      listKeys: {r'capabilities'},
      context: r'ServerCapabilitiesResponse',
    );
    return ServerCapabilitiesResponse(
      capabilities: _$values[r'capabilities'].decodeSimpleStringList(
        context: r'ServerCapabilitiesResponse.capabilities',
      ),
      source: _i4.ServerCapabilitiesResponseSourceModel.fromSimple(
        _$values[r'source'],
        explode: explode,
      ),
    );
  }

  factory ServerCapabilitiesResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServerCapabilitiesResponse');
    return ServerCapabilitiesResponse(
      capabilities: _$map[r'capabilities'].decodeJsonList<_i3.String>(
        context: r'ServerCapabilitiesResponse.capabilities',
      ),
      source: _i4.ServerCapabilitiesResponseSourceModel.fromJson(
        _$map[r'source'],
      ),
    );
  }

  factory ServerCapabilitiesResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'capabilities', r'source'},
      listKeys: {r'capabilities'},
      context: r'ServerCapabilitiesResponse',
    );
    return ServerCapabilitiesResponse(
      capabilities: _$values[r'capabilities'].decodeFormStringList(
        context: r'ServerCapabilitiesResponse.capabilities',
      ),
      source: _i4.ServerCapabilitiesResponseSourceModel.fromForm(
        _$values[r'source'],
        explode: explode,
      ),
    );
  }

  /// **Example**:
  /// ```
  /// mail:read,mail:send
  /// ```
  final _i3.List<_i3.String> capabilities;

  final _i4.ServerCapabilitiesResponseSourceModel source;

  @_i3.override
  _i3.Object? toJson() => {
    r'capabilities': capabilities,
    r'source': source.toJson(),
  };

  $$ServerCapabilitiesResponseCopyWith<ServerCapabilitiesResponse>
  get copyWith => _ServerCapabilitiesResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ServerCapabilitiesResponse &&
        _$deepEquals.equals(other.capabilities, this.capabilities) &&
        other.source == this.source;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(capabilities), source]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'capabilities'] = _i1.PropertyValue.array(capabilities);
    _$result[r'source'] = _i1.PropertyValue.scalar(source.toJson());
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
      r'Cannot uriEncode ServerCapabilitiesResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ServerCapabilitiesResponseCopyWith<$Res> {
  factory $$ServerCapabilitiesResponseCopyWith(
    ServerCapabilitiesResponse value,
  ) = _ServerCapabilitiesResponseCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? capabilities,
    _i4.ServerCapabilitiesResponseSourceModel? source,
  });
  _i3.List<_i3.String> get capabilities;
  _i4.ServerCapabilitiesResponseSourceModel get source;
}

class _ServerCapabilitiesResponseCopyWith<$Res>
    implements $$ServerCapabilitiesResponseCopyWith<$Res> {
  _ServerCapabilitiesResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ServerCapabilitiesResponse _value;

  @_i3.override
  _i3.List<_i3.String> get capabilities => _value.capabilities;

  @_i3.override
  _i4.ServerCapabilitiesResponseSourceModel get source => _value.source;

  @_i3.override
  $Res call({
    _i3.Object? capabilities = _sentinel,
    _i3.Object? source = _sentinel,
  }) {
    return (ServerCapabilitiesResponse(
      capabilities: _i3.identical(capabilities, _sentinel)
          ? this.capabilities
          : (capabilities as _i3.List<_i3.String>),
      source: _i3.identical(source, _sentinel)
          ? this.source
          : (source as _i4.ServerCapabilitiesResponseSourceModel),
    ) as $Res);
  }
}
