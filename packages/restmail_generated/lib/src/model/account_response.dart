// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AccountResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AccountResponse({
    required this.address,
    required this.displayName,
    required this.id,
    required this.isPrimary,
  });

  factory AccountResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'display_name', r'id', r'is_primary'},
      listKeys: {},
      context: r'AccountResponse',
    );
    return AccountResponse(
      address: _$values[r'address'].decodeSimpleString(
        context: r'AccountResponse.address',
      ),
      displayName: _$values[r'display_name'].decodeSimpleString(
        context: r'AccountResponse.display_name',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'AccountResponse.id'),
      isPrimary: _$values[r'is_primary'].decodeSimpleBool(
        context: r'AccountResponse.is_primary',
      ),
    );
  }

  factory AccountResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AccountResponse');
    return AccountResponse(
      address: _$map[r'address'].decodeJsonString(
        context: r'AccountResponse.address',
      ),
      displayName: _$map[r'display_name'].decodeJsonString(
        context: r'AccountResponse.display_name',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'AccountResponse.id'),
      isPrimary: _$map[r'is_primary'].decodeJsonBool(
        context: r'AccountResponse.is_primary',
      ),
    );
  }

  factory AccountResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'display_name', r'id', r'is_primary'},
      listKeys: {},
      context: r'AccountResponse',
    );
    return AccountResponse(
      address: _$values[r'address'].decodeFormString(
        context: r'AccountResponse.address',
      ),
      displayName: _$values[r'display_name'].decodeFormString(
        context: r'AccountResponse.display_name',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'AccountResponse.id'),
      isPrimary: _$values[r'is_primary'].decodeFormBool(
        context: r'AccountResponse.is_primary',
      ),
    );
  }

  final _i3.String address;

  final _i3.String displayName;

  final _i3.int id;

  final _i3.bool isPrimary;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    r'display_name': displayName,
    r'id': id,
    r'is_primary': isPrimary,
  };

  $$AccountResponseCopyWith<AccountResponse> get copyWith =>
      _AccountResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AccountResponse &&
        other.address == this.address &&
        other.displayName == this.displayName &&
        other.id == this.id &&
        other.isPrimary == this.isPrimary;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, displayName, id, isPrimary]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    _$result[r'display_name'] = _i1.PropertyValue.scalar(displayName);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'is_primary'] = _i1.PropertyValue.scalar(isPrimary.toString());
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
      r'Cannot uriEncode AccountResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AccountResponseCopyWith<$Res> {
  factory $$AccountResponseCopyWith(AccountResponse value) =
      _AccountResponseCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? displayName,
    _i3.int? id,
    _i3.bool? isPrimary,
  });
  _i3.String get address;
  _i3.String get displayName;
  _i3.int get id;
  _i3.bool get isPrimary;
}

class _AccountResponseCopyWith<$Res>
    implements $$AccountResponseCopyWith<$Res> {
  _AccountResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AccountResponse _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.String get displayName => _value.displayName;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.bool get isPrimary => _value.isPrimary;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? isPrimary = _sentinel,
  }) {
    return (AccountResponse(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      isPrimary: _i3.identical(isPrimary, _sentinel)
          ? this.isPrimary
          : (isPrimary as _i3.bool),
    ) as $Res);
  }
}
