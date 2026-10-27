// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Address extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Address({required this.address, this.name});

  factory Address.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'name'},
      listKeys: {},
      context: r'Address',
    );
    return Address(
      address: _$values[r'address'].decodeSimpleString(
        context: r'Address.address',
      ),
      name: _$values[r'name'].decodeSimpleNullableString(
        context: r'Address.name',
      ),
    );
  }

  factory Address.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Address');
    return Address(
      address: _$map[r'address'].decodeJsonString(context: r'Address.address'),
      name: _$map[r'name'].decodeJsonNullableString(context: r'Address.name'),
    );
  }

  factory Address.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'name'},
      listKeys: {},
      context: r'Address',
    );
    return Address(
      address: _$values[r'address'].decodeFormString(
        context: r'Address.address',
      ),
      name: _$values[r'name'].decodeFormNullableString(
        context: r'Address.name',
      ),
    );
  }

  final _i3.String address;

  final _i3.String? name;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    if (name != null) r'name': name,
  };

  $$AddressCopyWith<Address> get copyWith => _AddressCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Address &&
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
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
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
      r'Cannot uriEncode Address: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AddressCopyWith<$Res> {
  factory $$AddressCopyWith(Address value) = _AddressCopyWith<$Res>;

  $Res call({_i3.String? address, _i3.String? name});
  _i3.String get address;
  _i3.String? get name;
}

class _AddressCopyWith<$Res> implements $$AddressCopyWith<$Res> {
  _AddressCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Address _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.String? get name => _value.name;

  @_i3.override
  $Res call({_i3.Object? address = _sentinel, _i3.Object? name = _sentinel}) {
    return (Address(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
    ) as $Res);
  }
}
