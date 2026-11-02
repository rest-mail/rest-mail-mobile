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
    this.owned,
    this.password,
    this.passwordHash,
    this.quotaBytes,
    this.receive,
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
        r'owned',
        r'password',
        r'password_hash',
        r'quota_bytes',
        r'receive',
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
      owned: _$values[r'owned'].decodeSimpleNullableBool(
        context: r'CreateAccountRequest.owned',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$values[r'password_hash'].decodeSimpleNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeSimpleNullableInt(
        context: r'CreateAccountRequest.quota_bytes',
      ),
      receive: _$values[r'receive'].decodeSimpleNullableBool(
        context: r'CreateAccountRequest.receive',
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
      owned: _$map[r'owned'].decodeJsonNullableBool(
        context: r'CreateAccountRequest.owned',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$map[r'password_hash'].decodeJsonNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
      quotaBytes: _$map[r'quota_bytes'].decodeJsonNullableInt(
        context: r'CreateAccountRequest.quota_bytes',
      ),
      receive: _$map[r'receive'].decodeJsonNullableBool(
        context: r'CreateAccountRequest.receive',
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
        r'owned',
        r'password',
        r'password_hash',
        r'quota_bytes',
        r'receive',
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
      owned: _$values[r'owned'].decodeFormNullableBool(
        context: r'CreateAccountRequest.owned',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'CreateAccountRequest.password',
      ),
      passwordHash: _$values[r'password_hash'].decodeFormNullableString(
        context: r'CreateAccountRequest.password_hash',
      ),
      quotaBytes: _$values[r'quota_bytes'].decodeFormNullableInt(
        context: r'CreateAccountRequest.quota_bytes',
      ),
      receive: _$values[r'receive'].decodeFormNullableBool(
        context: r'CreateAccountRequest.receive',
      ),
    );
  }

  final _i3.String address;

  final _i3.String? displayName;

  final _i3.bool? owned;

  final _i3.String? password;

  final _i3.String? passwordHash;

  final _i3.int? quotaBytes;

  final _i3.bool? receive;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    if (displayName != null) r'display_name': displayName,
    if (owned != null) r'owned': owned,
    if (password != null) r'password': password,
    if (passwordHash != null) r'password_hash': passwordHash,
    r'quota_bytes': quotaBytes,
    r'receive': receive,
  };

  $$CreateAccountRequestCopyWith<CreateAccountRequest> get copyWith =>
      _CreateAccountRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateAccountRequest &&
        other.address == this.address &&
        other.displayName == this.displayName &&
        other.owned == this.owned &&
        other.password == this.password &&
        other.passwordHash == this.passwordHash &&
        other.quotaBytes == this.quotaBytes &&
        other.receive == this.receive;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      address,
      displayName,
      owned,
      password,
      passwordHash,
      quotaBytes,
      receive,
    ]);
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
    if (owned != null) {
      _$result[r'owned'] = _i1.PropertyValue.scalar(owned!.toString());
    }
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
    }
    if (passwordHash != null) {
      _$result[r'password_hash'] = _i1.PropertyValue.scalar(passwordHash!);
    }
    if (quotaBytes != null) {
      _$result[r'quota_bytes'] = _i1.PropertyValue.scalar(
        quotaBytes!.toString(),
      );
    }
    if (receive != null) {
      _$result[r'receive'] = _i1.PropertyValue.scalar(receive!.toString());
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
    _i3.bool? owned,
    _i3.String? password,
    _i3.String? passwordHash,
    _i3.int? quotaBytes,
    _i3.bool? receive,
  });
  _i3.String get address;
  _i3.String? get displayName;
  _i3.bool? get owned;
  _i3.String? get password;
  _i3.String? get passwordHash;
  _i3.int? get quotaBytes;
  _i3.bool? get receive;
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
  _i3.bool? get owned => _value.owned;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.String? get passwordHash => _value.passwordHash;

  @_i3.override
  _i3.int? get quotaBytes => _value.quotaBytes;

  @_i3.override
  _i3.bool? get receive => _value.receive;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? owned = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? passwordHash = _sentinel,
    _i3.Object? quotaBytes = _sentinel,
    _i3.Object? receive = _sentinel,
  }) {
    return (CreateAccountRequest(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String?),
      owned: _i3.identical(owned, _sentinel)
          ? this.owned
          : (owned as _i3.bool?),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      passwordHash: _i3.identical(passwordHash, _sentinel)
          ? this.passwordHash
          : (passwordHash as _i3.String?),
      quotaBytes: _i3.identical(quotaBytes, _sentinel)
          ? this.quotaBytes
          : (quotaBytes as _i3.int?),
      receive: _i3.identical(receive, _sentinel)
          ? this.receive
          : (receive as _i3.bool?),
    ) as $Res);
  }
}
