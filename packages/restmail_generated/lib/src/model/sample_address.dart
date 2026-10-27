// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleAddress extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleAddress({this.address, this.name});

  factory SampleAddress.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'name'},
      listKeys: {},
      context: r'SampleAddress',
    );
    return SampleAddress(
      address: _$values[r'address'].decodeSimpleNullableString(
        context: r'SampleAddress.address',
      ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'SampleAddress.name',
      ),
    );
  }

  factory SampleAddress.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleAddress');
    return SampleAddress(
      address: _$map[r'address'].decodeJsonNullableString(
        context: r'SampleAddress.address',
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'SampleAddress.name',
      ),
    );
  }

  factory SampleAddress.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'name'},
      listKeys: {},
      context: r'SampleAddress',
    );
    return SampleAddress(
      address: _$values[r'address'].decodeFormNullableString(
        context: r'SampleAddress.address',
      ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'SampleAddress.name',
      ),
    );
  }

  final _i3.String? address;

  final _i3.String? name;

  @_i3.override
  _i3.Object? toJson() => {r'address': address, r'name': name};

  $$SampleAddressCopyWith<SampleAddress> get copyWith =>
      _SampleAddressCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SampleAddress &&
        other.address == this.address &&
        other.name == this.name;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, name]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (address != null) {
      _$result[r'address'] = _i1.PropertyValue.scalar(address!);
    }
    if (name != null) {
      _$result[r'name'] = _i1.PropertyValue.scalar(name!);
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
      r'Cannot uriEncode SampleAddress: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleAddressCopyWith<$Res> {
  factory $$SampleAddressCopyWith(SampleAddress value) =
      _SampleAddressCopyWith<$Res>;

  $Res call({_i3.String? address, _i3.String? name});
  _i3.String? get address;
  _i3.String? get name;
}

class _SampleAddressCopyWith<$Res> implements $$SampleAddressCopyWith<$Res> {
  _SampleAddressCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleAddress _value;

  @_i3.override
  _i3.String? get address => _value.address;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  $Res call({_i3.Object? address = _sentinel, _i3.Object? name = _sentinel}) {
    return (SampleAddress(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
    ) as $Res);
  }
}
