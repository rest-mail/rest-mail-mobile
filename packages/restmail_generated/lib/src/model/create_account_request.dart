// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateAccountRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateAccountRequest({
    required this.address,
    this.displayName,
    this.password,
    this.passwordHash,
  });

  factory CreateAccountRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'address',
        r'display_name',
        r'password',
        r'password_hash',
      },
      listKeys: {},
      context: r'CreateAccountRequest',
    );
    return CreateAccountRequest(
      address: _$values[r'address'].decodeSimpleString(
        context: r'CreateAccountRequest.address',
      ),
      displayName: _$values[r'display_name'].decodeSimpleNullableString(
        context: r'CreateAccountRequest.display_name',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$values[r'password_hash'].decodeSimpleNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
    );
  }

  factory CreateAccountRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateAccountRequest');
    return CreateAccountRequest(
      address: _$map[r'address'].decodeJsonString(
        context: r'CreateAccountRequest.address',
      ),
      displayName: _$map[r'display_name'].decodeJsonNullableString(
        context: r'CreateAccountRequest.display_name',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$map[r'password_hash'].decodeJsonNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
    );
  }

  factory CreateAccountRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'address',
        r'display_name',
        r'password',
        r'password_hash',
      },
      listKeys: {},
      context: r'CreateAccountRequest',
    );
    return CreateAccountRequest(
      address: _$values[r'address'].decodeFormString(
        context: r'CreateAccountRequest.address',
      ),
      displayName: _$values[r'display_name'].decodeFormNullableString(
        context: r'CreateAccountRequest.display_name',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$values[r'password_hash'].decodeFormNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
    );
  }

  final _i3.String address;

  final _i3.String? displayName;

  final _i3.String? password;

  final _i3.String? passwordHash;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    if (displayName != null) r'display_name': displayName,
    if (password != null) r'password': password,
    if (passwordHash != null) r'password_hash': passwordHash,
  };

  $$CreateAccountRequestCopyWith<CreateAccountRequest> get copyWith =>
      _CreateAccountRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountRequest &&
        other.address == this.address &&
        other.displayName == this.displayName &&
        other.password == this.password &&
        other.passwordHash == this.passwordHash;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([address, displayName, password, passwordHash]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    if (displayName != null) {
      _$result[r'display_name'] = _i1.PropertyValue.scalar(displayName!);
    }
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
    }
    if (passwordHash != null) {
      _$result[r'password_hash'] = _i1.PropertyValue.scalar(passwordHash!);
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
      r'Cannot uriEncode CreateAccountRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateAccountRequestCopyWith<$Res> {
  factory $$CreateAccountRequestCopyWith(CreateAccountRequest value) =
      _CreateAccountRequestCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? displayName,
    _i3.String? password,
    _i3.String? passwordHash,
  });
  _i3.String get address;
  _i3.String? get displayName;
  _i3.String? get password;
  _i3.String? get passwordHash;
}

class _CreateAccountRequestCopyWith<$Res>
    implements $$CreateAccountRequestCopyWith<$Res> {
  _CreateAccountRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateAccountRequest _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.String? get displayName => _value.displayName;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.String? get passwordHash => _value.passwordHash;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? passwordHash = _sentinel,
  }) {
    return (CreateAccountRequest(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      passwordHash: _i3.identical(passwordHash, _sentinel)
          ? this.passwordHash
          : (passwordHash as _i3.String?),
    ) as $Res);
  }
}
