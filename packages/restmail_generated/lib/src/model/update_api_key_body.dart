// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/api_key_permission.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateApiKeyBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateApiKeyBody({required this.password, required this.permissions});

  factory UpdateApiKeyBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for UpdateApiKeyBody: contains complex types',
    );
  }

  factory UpdateApiKeyBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateApiKeyBody');
    return UpdateApiKeyBody(
      password: _$map[r'password'].decodeJsonString(
        context: r'UpdateApiKeyBody.password',
      ),
      permissions: _$map[r'permissions']
          .decodeJsonList<_i3.Object?>(context: r'UpdateApiKeyBody.permissions')
          .map(_i4.ApiKeyPermission.fromJson)
          .toList(),
    );
  }

  factory UpdateApiKeyBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for UpdateApiKeyBody: contains complex types',
    );
  }

  final _i3.String password;

  final _i3.List<_i4.ApiKeyPermission> permissions;

  @_i3.override
  _i3.Object? toJson() => {
    r'password': password,
    r'permissions': permissions.map((e) => e.toJson()).toList(),
  };

  $$UpdateApiKeyBodyCopyWith<UpdateApiKeyBody> get copyWith =>
      _UpdateApiKeyBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is UpdateApiKeyBody &&
        other.password == this.password &&
        _$deepEquals.equals(other.permissions, this.permissions);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([password, deepEquals.hash(permissions)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for UpdateApiKeyBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode UpdateApiKeyBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateApiKeyBodyCopyWith<$Res> {
  factory $$UpdateApiKeyBodyCopyWith(UpdateApiKeyBody value) =
      _UpdateApiKeyBodyCopyWith<$Res>;

  $Res call({
    _i3.String? password,
    _i3.List<_i4.ApiKeyPermission>? permissions,
  });
  _i3.String get password;
  _i3.List<_i4.ApiKeyPermission> get permissions;
}

class _UpdateApiKeyBodyCopyWith<$Res>
    implements $$UpdateApiKeyBodyCopyWith<$Res> {
  _UpdateApiKeyBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateApiKeyBody _value;

  @_i3.override
  _i3.String get password => _value.password;

  @_i3.override
  _i3.List<_i4.ApiKeyPermission> get permissions => _value.permissions;

  @_i3.override
  $Res call({
    _i3.Object? password = _sentinel,
    _i3.Object? permissions = _sentinel,
  }) {
    return (UpdateApiKeyBody(
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String),
      permissions: _i3.identical(permissions, _sentinel)
          ? this.permissions
          : (permissions as _i3.List<_i4.ApiKeyPermission>),
    ) as $Res);
  }
}
