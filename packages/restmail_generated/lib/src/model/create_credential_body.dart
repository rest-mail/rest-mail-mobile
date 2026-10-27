// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateCredentialBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateCredentialBody({
    required this.name,
    this.expiresAt,
    this.password,
  });

  factory CreateCredentialBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'expires_at', r'name', r'password'},
      listKeys: {},
      context: r'CreateCredentialBody',
    );
    return CreateCredentialBody(
      expiresAt: _$values[r'expires_at'].decodeSimpleNullableDateTime(
        context: r'CreateCredentialBody.expires_at',
      ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'CreateCredentialBody.name',
      ),
      password: _$values[r'password'].decodeSimpleNullableString(
        context: r'CreateCredentialBody.password',
      ),
    );
  }

  factory CreateCredentialBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateCredentialBody');
    return CreateCredentialBody(
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'CreateCredentialBody.expires_at',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'CreateCredentialBody.name',
      ),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'CreateCredentialBody.password',
      ),
    );
  }

  factory CreateCredentialBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'expires_at', r'name', r'password'},
      listKeys: {},
      context: r'CreateCredentialBody',
    );
    return CreateCredentialBody(
      expiresAt: _$values[r'expires_at'].decodeFormNullableDateTime(
        context: r'CreateCredentialBody.expires_at',
      ),
      name: _$values[r'name'].decodeFormString(
        context: r'CreateCredentialBody.name',
      ),
      password: _$values[r'password'].decodeFormNullableString(
        context: r'CreateCredentialBody.password',
      ),
    );
  }

  final _i3.DateTime? expiresAt;

  final _i3.String name;

  final _i3.String? password;

  @_i3.override
  _i3.Object? toJson() => {
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'name': name,
    if (password != null) r'password': password,
  };

  $$CreateCredentialBodyCopyWith<CreateCredentialBody> get copyWith =>
      _CreateCredentialBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCredentialBody &&
        other.expiresAt == this.expiresAt &&
        other.name == this.name &&
        other.password == this.password;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([expiresAt, name, password]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (expiresAt != null) {
      _$result[r'expires_at'] = _i1.PropertyValue.scalar(
        expiresAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    if (password != null) {
      _$result[r'password'] = _i1.PropertyValue.scalar(password!);
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
      r'Cannot uriEncode CreateCredentialBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateCredentialBodyCopyWith<$Res> {
  factory $$CreateCredentialBodyCopyWith(CreateCredentialBody value) =
      _CreateCredentialBodyCopyWith<$Res>;

  $Res call({_i3.DateTime? expiresAt, _i3.String? name, _i3.String? password});
  _i3.DateTime? get expiresAt;
  _i3.String get name;
  _i3.String? get password;
}

class _CreateCredentialBodyCopyWith<$Res>
    implements $$CreateCredentialBodyCopyWith<$Res> {
  _CreateCredentialBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateCredentialBody _value;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  $Res call({
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? password = _sentinel,
  }) {
    return (CreateCredentialBody(
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
    ) as $Res);
  }
}
