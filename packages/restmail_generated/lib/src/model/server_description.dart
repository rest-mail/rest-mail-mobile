// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/server_description_product_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerDescription extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerDescription({required this.product, required this.version});

  factory ServerDescription.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'product', r'version'},
      listKeys: {},
      context: r'ServerDescription',
    );
    return ServerDescription(
      product: _i4.ServerDescriptionProductModel.fromSimple(
        _$values[r'product'],
        explode: explode,
      ),
      version: _$values[r'version'].decodeSimpleString(
        context: r'ServerDescription.version',
      ),
    );
  }

  factory ServerDescription.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServerDescription');
    return ServerDescription(
      product: _i4.ServerDescriptionProductModel.fromJson(_$map[r'product']),
      version: _$map[r'version'].decodeJsonString(
        context: r'ServerDescription.version',
      ),
    );
  }

  factory ServerDescription.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'product', r'version'},
      listKeys: {},
      context: r'ServerDescription',
    );
    return ServerDescription(
      product: _i4.ServerDescriptionProductModel.fromForm(
        _$values[r'product'],
        explode: explode,
      ),
      version: _$values[r'version'].decodeFormString(
        context: r'ServerDescription.version',
      ),
    );
  }

  final _i4.ServerDescriptionProductModel product;

  final _i3.String version;

  @_i3.override
  _i3.Object? toJson() => {r'product': product.toJson(), r'version': version};

  $$ServerDescriptionCopyWith<ServerDescription> get copyWith =>
      _ServerDescriptionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServerDescription &&
        other.product == this.product &&
        other.version == this.version;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([product, version]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'product'] = _i1.PropertyValue.scalar(product.toJson());
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
      r'Cannot uriEncode ServerDescription: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ServerDescriptionCopyWith<$Res> {
  factory $$ServerDescriptionCopyWith(ServerDescription value) =
      _ServerDescriptionCopyWith<$Res>;

  $Res call({_i4.ServerDescriptionProductModel? product, _i3.String? version});
  _i4.ServerDescriptionProductModel get product;
  _i3.String get version;
}

class _ServerDescriptionCopyWith<$Res>
    implements $$ServerDescriptionCopyWith<$Res> {
  _ServerDescriptionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ServerDescription _value;

  @_i3.override
  _i4.ServerDescriptionProductModel get product => _value.product;

  @_i3.override
  _i3.String get version => _value.version;

  @_i3.override
  $Res call({
    _i3.Object? product = _sentinel,
    _i3.Object? version = _sentinel,
  }) {
    return (ServerDescription(
      product: _i3.identical(product, _sentinel)
          ? this.product
          : (product as _i4.ServerDescriptionProductModel),
      version: _i3.identical(version, _sentinel)
          ? this.version
          : (version as _i3.String),
    ) as $Res);
  }
}
