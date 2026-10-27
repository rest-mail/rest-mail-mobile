// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailCapabilities extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailCapabilities({
    required this.features,
    required this.protocol,
    required this.version,
  });

  factory RestmailCapabilities.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'features', r'protocol', r'version'},
      listKeys: {r'features'},
      context: r'RestmailCapabilities',
    );
    return RestmailCapabilities(
      features: _$values[r'features'].decodeSimpleStringList(
        context: r'RestmailCapabilities.features',
      ),
      protocol: _$values[r'protocol'].decodeSimpleString(
        context: r'RestmailCapabilities.protocol',
      ),
      version: _$values[r'version'].decodeSimpleString(
        context: r'RestmailCapabilities.version',
      ),
    );
  }

  factory RestmailCapabilities.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailCapabilities');
    return RestmailCapabilities(
      features: _$map[r'features'].decodeJsonList<_i3.String>(
        context: r'RestmailCapabilities.features',
      ),
      protocol: _$map[r'protocol'].decodeJsonString(
        context: r'RestmailCapabilities.protocol',
      ),
      version: _$map[r'version'].decodeJsonString(
        context: r'RestmailCapabilities.version',
      ),
    );
  }

  factory RestmailCapabilities.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'features', r'protocol', r'version'},
      listKeys: {r'features'},
      context: r'RestmailCapabilities',
    );
    return RestmailCapabilities(
      features: _$values[r'features'].decodeFormStringList(
        context: r'RestmailCapabilities.features',
      ),
      protocol: _$values[r'protocol'].decodeFormString(
        context: r'RestmailCapabilities.protocol',
      ),
      version: _$values[r'version'].decodeFormString(
        context: r'RestmailCapabilities.version',
      ),
    );
  }

  final _i3.List<_i3.String> features;

  final _i3.String protocol;

  final _i3.String version;

  @_i3.override
  _i3.Object? toJson() => {
    r'features': features,
    r'protocol': protocol,
    r'version': version,
  };

  $$RestmailCapabilitiesCopyWith<RestmailCapabilities> get copyWith =>
      _RestmailCapabilitiesCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is RestmailCapabilities &&
        _$deepEquals.equals(other.features, this.features) &&
        other.protocol == this.protocol &&
        other.version == this.version;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(features), protocol, version]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'features'] = _i1.PropertyValue.array(features);
    _$result[r'protocol'] = _i1.PropertyValue.scalar(protocol);
    _$result[r'version'] = _i1.PropertyValue.scalar(version);
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
      r'Cannot uriEncode RestmailCapabilities: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailCapabilitiesCopyWith<$Res> {
  factory $$RestmailCapabilitiesCopyWith(RestmailCapabilities value) =
      _RestmailCapabilitiesCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? features,
    _i3.String? protocol,
    _i3.String? version,
  });
  _i3.List<_i3.String> get features;
  _i3.String get protocol;
  _i3.String get version;
}

class _RestmailCapabilitiesCopyWith<$Res>
    implements $$RestmailCapabilitiesCopyWith<$Res> {
  _RestmailCapabilitiesCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailCapabilities _value;

  @_i3.override
  _i3.List<_i3.String> get features => _value.features;

  @_i3.override
  _i3.String get protocol => _value.protocol;

  @_i3.override
  _i3.String get version => _value.version;

  @_i3.override
  $Res call({
    _i3.Object? features = _sentinel,
    _i3.Object? protocol = _sentinel,
    _i3.Object? version = _sentinel,
  }) {
    return (RestmailCapabilities(
      features: _i3.identical(features, _sentinel)
          ? this.features
          : (features as _i3.List<_i3.String>),
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol as _i3.String),
      version: _i3.identical(version, _sentinel)
          ? this.version
          : (version as _i3.String),
    ) as $Res);
  }
}
