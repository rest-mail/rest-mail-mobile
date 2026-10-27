// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/api_key_permission.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateApiKeyBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateApiKeyBody({
    required this.name,
    this.expiresAt,
    this.password,
    this.permissions,
  });

  factory CreateApiKeyBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CreateApiKeyBody: contains complex types',
    );
  }

  factory CreateApiKeyBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateApiKeyBody');
    return CreateApiKeyBody(
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'CreateApiKeyBody.expires_at',
      ),
      name: _$map[r'name'].decodeJsonString(context: r'CreateApiKeyBody.name'),
      password: _$map[r'password'].decodeJsonNullableString(
        context: r'CreateApiKeyBody.password',
      ),
      permissions: _$map[r'permissions']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'CreateApiKeyBody.permissions',
          )
          ?.map(_i4.ApiKeyPermission.fromJson)
          .toList(),
    );
  }

  factory CreateApiKeyBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CreateApiKeyBody: contains complex types',
    );
  }

  final _i3.DateTime? expiresAt;

  final _i3.String name;

  final _i3.String? password;

  final _i3.List<_i4.ApiKeyPermission>? permissions;

  @_i3.override
  _i3.Object? toJson() => {
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'name': name,
    if (password != null) r'password': password,
    if (permissions != null)
      r'permissions': permissions?.map((e) => e.toJson()).toList(),
  };

  $$CreateApiKeyBodyCopyWith<CreateApiKeyBody> get copyWith =>
      _CreateApiKeyBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is CreateApiKeyBody &&
        other.expiresAt == this.expiresAt &&
        other.name == this.name &&
        other.password == this.password &&
        _$deepEquals.equals(other.permissions, this.permissions);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      expiresAt,
      name,
      password,
      deepEquals.hash(permissions),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CreateApiKeyBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CreateApiKeyBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateApiKeyBodyCopyWith<$Res> {
  factory $$CreateApiKeyBodyCopyWith(CreateApiKeyBody value) =
      _CreateApiKeyBodyCopyWith<$Res>;

  $Res call({
    _i3.DateTime? expiresAt,
    _i3.String? name,
    _i3.String? password,
    _i3.List<_i4.ApiKeyPermission>? permissions,
  });
  _i3.DateTime? get expiresAt;
  _i3.String get name;
  _i3.String? get password;
  _i3.List<_i4.ApiKeyPermission>? get permissions;
}

class _CreateApiKeyBodyCopyWith<$Res>
    implements $$CreateApiKeyBodyCopyWith<$Res> {
  _CreateApiKeyBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateApiKeyBody _value;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.String? get password => _value.password;

  @_i3.override
  _i3.List<_i4.ApiKeyPermission>? get permissions => _value.permissions;

  @_i3.override
  $Res call({
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? permissions = _sentinel,
  }) {
    return (CreateApiKeyBody(
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String?),
      permissions: _i3.identical(permissions, _sentinel)
          ? this.permissions
          : (permissions as _i3.List<_i4.ApiKeyPermission>?),
    ) as $Res);
  }
}
