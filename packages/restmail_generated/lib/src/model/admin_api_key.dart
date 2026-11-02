// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/scoped_permission.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AdminApiKey extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AdminApiKey({
    required this.accountAddress,
    required this.accountId,
    required this.createdAt,
    required this.expiresAt,
    required this.id,
    required this.kind,
    required this.lastUsedAt,
    required this.name,
    required this.permissions,
    required this.publicId,
  });

  factory AdminApiKey.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for AdminApiKey: contains complex types',
    );
  }

  factory AdminApiKey.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AdminApiKey');
    return AdminApiKey(
      accountAddress: _$map[r'account_address'].decodeJsonString(
        context: r'AdminApiKey.account_address',
      ),
      accountId: _$map[r'account_id'].decodeJsonInt(
        context: r'AdminApiKey.account_id',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'AdminApiKey.created_at',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'AdminApiKey.expires_at',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'AdminApiKey.id'),
      kind: _$map[r'kind'].decodeJsonString(context: r'AdminApiKey.kind'),
      lastUsedAt: _$map[r'last_used_at'].decodeJsonNullableDateTime(
        context: r'AdminApiKey.last_used_at',
      ),
      name: _$map[r'name'].decodeJsonString(context: r'AdminApiKey.name'),
      permissions: _$map[r'permissions']
          .decodeJsonList<_i3.Object?>(context: r'AdminApiKey.permissions')
          .map(_i4.ScopedPermission.fromJson)
          .toList(),
      publicId: _$map[r'public_id'].decodeJsonString(
        context: r'AdminApiKey.public_id',
      ),
    );
  }

  factory AdminApiKey.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for AdminApiKey: contains complex types',
    );
  }

  final _i3.String accountAddress;

  final _i3.int accountId;

  final _i3.DateTime createdAt;

  final _i3.DateTime? expiresAt;

  final _i3.int id;

  final _i3.String kind;

  final _i3.DateTime? lastUsedAt;

  final _i3.String name;

  final _i3.List<_i4.ScopedPermission> permissions;

  final _i3.String publicId;

  @_i3.override
  _i3.Object? toJson() => {
    r'account_address': accountAddress,
    r'account_id': accountId,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'id': id,
    r'kind': kind,
    r'last_used_at': lastUsedAt?.toTimeZonedIso8601String(),
    r'name': name,
    r'permissions': permissions.map((e) => e.toJson()).toList(),
    r'public_id': publicId,
  };

  $$AdminApiKeyCopyWith<AdminApiKey> get copyWith => _AdminApiKeyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is AdminApiKey &&
        other.accountAddress == this.accountAddress &&
        other.accountId == this.accountId &&
        other.createdAt == this.createdAt &&
        other.expiresAt == this.expiresAt &&
        other.id == this.id &&
        other.kind == this.kind &&
        other.lastUsedAt == this.lastUsedAt &&
        other.name == this.name &&
        _$deepEquals.equals(other.permissions, this.permissions) &&
        other.publicId == this.publicId;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      accountAddress,
      accountId,
      createdAt,
      expiresAt,
      id,
      kind,
      lastUsedAt,
      name,
      deepEquals.hash(permissions),
      publicId,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for AdminApiKey: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode AdminApiKey: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AdminApiKeyCopyWith<$Res> {
  factory $$AdminApiKeyCopyWith(AdminApiKey value) = _AdminApiKeyCopyWith<$Res>;

  $Res call({
    _i3.String? accountAddress,
    _i3.int? accountId,
    _i3.DateTime? createdAt,
    _i3.DateTime? expiresAt,
    _i3.int? id,
    _i3.String? kind,
    _i3.DateTime? lastUsedAt,
    _i3.String? name,
    _i3.List<_i4.ScopedPermission>? permissions,
    _i3.String? publicId,
  });
  _i3.String get accountAddress;
  _i3.int get accountId;
  _i3.DateTime get createdAt;
  _i3.DateTime? get expiresAt;
  _i3.int get id;
  _i3.String get kind;
  _i3.DateTime? get lastUsedAt;
  _i3.String get name;
  _i3.List<_i4.ScopedPermission> get permissions;
  _i3.String get publicId;
}

class _AdminApiKeyCopyWith<$Res> implements $$AdminApiKeyCopyWith<$Res> {
  _AdminApiKeyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AdminApiKey _value;

  @_i3.override
  _i3.String get accountAddress => _value.accountAddress;

  @_i3.override
  _i3.int get accountId => _value.accountId;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get kind => _value.kind;

  @_i3.override
  _i3.DateTime? get lastUsedAt => _value.lastUsedAt;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.List<_i4.ScopedPermission> get permissions => _value.permissions;

  @_i3.override
  _i3.String get publicId => _value.publicId;

  @_i3.override
  $Res call({
    _i3.Object? accountAddress = _sentinel,
    _i3.Object? accountId = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? kind = _sentinel,
    _i3.Object? lastUsedAt = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? permissions = _sentinel,
    _i3.Object? publicId = _sentinel,
  }) {
    return (AdminApiKey(
      accountAddress: _i3.identical(accountAddress, _sentinel)
          ? this.accountAddress
          : (accountAddress as _i3.String),
      accountId: _i3.identical(accountId, _sentinel)
          ? this.accountId
          : (accountId as _i3.int),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      kind: _i3.identical(kind, _sentinel) ? this.kind : (kind as _i3.String),
      lastUsedAt: _i3.identical(lastUsedAt, _sentinel)
          ? this.lastUsedAt
          : (lastUsedAt as _i3.DateTime?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      permissions: _i3.identical(permissions, _sentinel)
          ? this.permissions
          : (permissions as _i3.List<_i4.ScopedPermission>),
      publicId: _i3.identical(publicId, _sentinel)
          ? this.publicId
          : (publicId as _i3.String),
    ) as $Res);
  }
}
