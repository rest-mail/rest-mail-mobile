// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDiscovery extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDiscovery({required this.endpoint});

  factory RestmailDiscovery.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'endpoint'},
      listKeys: {},
      context: r'RestmailDiscovery',
    );
    return RestmailDiscovery(
      endpoint: _$values[r'endpoint'].decodeSimpleUri(
        context: r'RestmailDiscovery.endpoint',
      ),
    );
  }

  factory RestmailDiscovery.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDiscovery');
    return RestmailDiscovery(
      endpoint: _$map[r'endpoint'].decodeJsonUri(
        context: r'RestmailDiscovery.endpoint',
      ),
    );
  }

  factory RestmailDiscovery.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'endpoint'},
      listKeys: {},
      context: r'RestmailDiscovery',
    );
    return RestmailDiscovery(
      endpoint: _$values[r'endpoint'].decodeFormUri(
        context: r'RestmailDiscovery.endpoint',
      ),
    );
  }

  final _i3.Uri endpoint;

  @_i3.override
  _i3.Object? toJson() => {r'endpoint': endpoint.toString()};

  $$RestmailDiscoveryCopyWith<RestmailDiscovery> get copyWith =>
      _RestmailDiscoveryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RestmailDiscovery && other.endpoint == this.endpoint;
  }

  @_i3.override
  _i3.int get hashCode => endpoint.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'endpoint'] = _i1.PropertyValue.scalar(endpoint.toString());
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
      r'Cannot uriEncode RestmailDiscovery: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDiscoveryCopyWith<$Res> {
  factory $$RestmailDiscoveryCopyWith(RestmailDiscovery value) =
      _RestmailDiscoveryCopyWith<$Res>;

  $Res call({_i3.Uri? endpoint});
  _i3.Uri get endpoint;
}

class _RestmailDiscoveryCopyWith<$Res>
    implements $$RestmailDiscoveryCopyWith<$Res> {
  _RestmailDiscoveryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDiscovery _value;

  @_i3.override
  _i3.Uri get endpoint => _value.endpoint;

  @_i3.override
  $Res call({_i3.Object? endpoint = _sentinel}) {
    return (RestmailDiscovery(
      endpoint: _i3.identical(endpoint, _sentinel)
          ? this.endpoint
          : (endpoint as _i3.Uri),
    ) as $Res);
  }
}
