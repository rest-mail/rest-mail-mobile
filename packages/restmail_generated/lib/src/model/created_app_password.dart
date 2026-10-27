// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreatedAppPassword extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreatedAppPassword({
    required this.createdAt,
    required this.expiresAt,
    required this.id,
    required this.kind,
    required this.lastUsedAt,
    required this.name,
    required this.password,
    required this.publicId,
  });

  factory CreatedAppPassword.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'created_at',
        r'expires_at',
        r'id',
        r'kind',
        r'last_used_at',
        r'name',
        r'password',
        r'public_id',
      },
      listKeys: {},
      context: r'CreatedAppPassword',
    );
    return CreatedAppPassword(
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'CreatedAppPassword.created_at',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleNullableDateTime(
        context: r'CreatedAppPassword.expires_at',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'CreatedAppPassword.id'),
      kind: _$values[r'kind'].decodeSimpleString(
        context: r'CreatedAppPassword.kind',
      ),
      lastUsedAt: _$values[r'last_used_at'].decodeSimpleNullableDateTime(
        context: r'CreatedAppPassword.last_used_at',
      ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'CreatedAppPassword.name',
      ),
      password: _$values[r'password'].decodeSimpleString(
        context: r'CreatedAppPassword.password',
      ),
      publicId: _$values[r'public_id'].decodeSimpleString(
        context: r'CreatedAppPassword.public_id',
      ),
    );
  }

  factory CreatedAppPassword.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreatedAppPassword');
    return CreatedAppPassword(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'CreatedAppPassword.created_at',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'CreatedAppPassword.expires_at',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'CreatedAppPassword.id'),
      kind: _$map[r'kind'].decodeJsonString(
        context: r'CreatedAppPassword.kind',
      ),
      lastUsedAt: _$map[r'last_used_at'].decodeJsonNullableDateTime(
        context: r'CreatedAppPassword.last_used_at',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'CreatedAppPassword.name',
      ),
      password: _$map[r'password'].decodeJsonString(
        context: r'CreatedAppPassword.password',
      ),
      publicId: _$map[r'public_id'].decodeJsonString(
        context: r'CreatedAppPassword.public_id',
      ),
    );
  }

  factory CreatedAppPassword.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'created_at',
        r'expires_at',
        r'id',
        r'kind',
        r'last_used_at',
        r'name',
        r'password',
        r'public_id',
      },
      listKeys: {},
      context: r'CreatedAppPassword',
    );
    return CreatedAppPassword(
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'CreatedAppPassword.created_at',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormNullableDateTime(
        context: r'CreatedAppPassword.expires_at',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'CreatedAppPassword.id'),
      kind: _$values[r'kind'].decodeFormString(
        context: r'CreatedAppPassword.kind',
      ),
      lastUsedAt: _$values[r'last_used_at'].decodeFormNullableDateTime(
        context: r'CreatedAppPassword.last_used_at',
      ),
      name: _$values[r'name'].decodeFormString(
        context: r'CreatedAppPassword.name',
      ),
      password: _$values[r'password'].decodeFormString(
        context: r'CreatedAppPassword.password',
      ),
      publicId: _$values[r'public_id'].decodeFormString(
        context: r'CreatedAppPassword.public_id',
      ),
    );
  }

  final _i3.DateTime createdAt;

  final _i3.DateTime? expiresAt;

  final _i3.int id;

  final _i3.String kind;

  final _i3.DateTime? lastUsedAt;

  final _i3.String name;

  final _i3.String password;

  final _i3.String publicId;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'id': id,
    r'kind': kind,
    r'last_used_at': lastUsedAt?.toTimeZonedIso8601String(),
    r'name': name,
    r'password': password,
    r'public_id': publicId,
  };

  $$CreatedAppPasswordCopyWith<CreatedAppPassword> get copyWith =>
      _CreatedAppPasswordCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreatedAppPassword &&
        other.createdAt == this.createdAt &&
        other.expiresAt == this.expiresAt &&
        other.id == this.id &&
        other.kind == this.kind &&
        other.lastUsedAt == this.lastUsedAt &&
        other.name == this.name &&
        other.password == this.password &&
        other.publicId == this.publicId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      createdAt,
      expiresAt,
      id,
      kind,
      lastUsedAt,
      name,
      password,
      publicId,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    if (expiresAt != null) {
      _$result[r'expires_at'] = _i1.PropertyValue.scalar(
        expiresAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'kind'] = _i1.PropertyValue.scalar(kind);
    if (lastUsedAt != null) {
      _$result[r'last_used_at'] = _i1.PropertyValue.scalar(
        lastUsedAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'password'] = _i1.PropertyValue.scalar(password);
    _$result[r'public_id'] = _i1.PropertyValue.scalar(publicId);
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
      r'Cannot uriEncode CreatedAppPassword: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreatedAppPasswordCopyWith<$Res> {
  factory $$CreatedAppPasswordCopyWith(CreatedAppPassword value) =
      _CreatedAppPasswordCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i3.DateTime? expiresAt,
    _i3.int? id,
    _i3.String? kind,
    _i3.DateTime? lastUsedAt,
    _i3.String? name,
    _i3.String? password,
    _i3.String? publicId,
  });
  _i3.DateTime get createdAt;
  _i3.DateTime? get expiresAt;
  _i3.int get id;
  _i3.String get kind;
  _i3.DateTime? get lastUsedAt;
  _i3.String get name;
  _i3.String get password;
  _i3.String get publicId;
}

class _CreatedAppPasswordCopyWith<$Res>
    implements $$CreatedAppPasswordCopyWith<$Res> {
  _CreatedAppPasswordCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreatedAppPassword _value;

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
  _i3.String get password => _value.password;

  @_i3.override
  _i3.String get publicId => _value.publicId;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? kind = _sentinel,
    _i3.Object? lastUsedAt = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? publicId = _sentinel,
  }) {
    return (CreatedAppPassword(
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
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String),
      publicId: _i3.identical(publicId, _sentinel)
          ? this.publicId
          : (publicId as _i3.String),
    ) as $Res);
  }
}
