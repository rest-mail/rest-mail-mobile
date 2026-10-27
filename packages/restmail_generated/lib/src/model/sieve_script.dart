// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SieveScript extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SieveScript({
    required this.active,
    required this.mailboxId,
    required this.script,
    this.createdAt,
    this.id,
    this.scriptHash,
    this.updatedAt,
    this.validatedAt,
  });

  factory SieveScript.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'active',
        r'created_at',
        r'id',
        r'mailbox_id',
        r'script',
        r'script_hash',
        r'updated_at',
        r'validated_at',
      },
      listKeys: {},
      context: r'SieveScript',
    );
    return SieveScript(
      active: _$values[r'active'].decodeSimpleBool(
        context: r'SieveScript.active',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleNullableDateTime(
        context: r'SieveScript.created_at',
      ),
      id: _$values[r'id'].decodeSimpleNullableInt(context: r'SieveScript.id'),
      mailboxId: _$values[r'mailbox_id'].decodeSimpleInt(
        context: r'SieveScript.mailbox_id',
      ),
      script: _$values[r'script'].decodeSimpleString(
        context: r'SieveScript.script',
      ),
      scriptHash: _$values[r'script_hash'].decodeSimpleNullableString(
        context: r'SieveScript.script_hash',
      ),
      updatedAt: _$values[r'updated_at'].decodeSimpleNullableDateTime(
        context: r'SieveScript.updated_at',
      ),
      validatedAt: _$values[r'validated_at'].decodeSimpleNullableDateTime(
        context: r'SieveScript.validated_at',
      ),
    );
  }

  factory SieveScript.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SieveScript');
    return SieveScript(
      active: _$map[r'active'].decodeJsonBool(context: r'SieveScript.active'),
      createdAt: _$map[r'created_at'].decodeJsonNullableDateTime(
        context: r'SieveScript.created_at',
      ),
      id: _$map[r'id'].decodeJsonNullableInt(context: r'SieveScript.id'),
      mailboxId: _$map[r'mailbox_id'].decodeJsonInt(
        context: r'SieveScript.mailbox_id',
      ),
      script: _$map[r'script'].decodeJsonString(context: r'SieveScript.script'),
      scriptHash: _$map[r'script_hash'].decodeJsonNullableString(
        context: r'SieveScript.script_hash',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonNullableDateTime(
        context: r'SieveScript.updated_at',
      ),
      validatedAt: _$map[r'validated_at'].decodeJsonNullableDateTime(
        context: r'SieveScript.validated_at',
      ),
    );
  }

  factory SieveScript.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'active',
        r'created_at',
        r'id',
        r'mailbox_id',
        r'script',
        r'script_hash',
        r'updated_at',
        r'validated_at',
      },
      listKeys: {},
      context: r'SieveScript',
    );
    return SieveScript(
      active: _$values[r'active'].decodeFormBool(
        context: r'SieveScript.active',
      ),
      createdAt: _$values[r'created_at'].decodeFormNullableDateTime(
        context: r'SieveScript.created_at',
      ),
      id: _$values[r'id'].decodeFormNullableInt(context: r'SieveScript.id'),
      mailboxId: _$values[r'mailbox_id'].decodeFormInt(
        context: r'SieveScript.mailbox_id',
      ),
      script: _$values[r'script'].decodeFormString(
        context: r'SieveScript.script',
      ),
      scriptHash: _$values[r'script_hash'].decodeFormNullableString(
        context: r'SieveScript.script_hash',
      ),
      updatedAt: _$values[r'updated_at'].decodeFormNullableDateTime(
        context: r'SieveScript.updated_at',
      ),
      validatedAt: _$values[r'validated_at'].decodeFormNullableDateTime(
        context: r'SieveScript.validated_at',
      ),
    );
  }

  final _i3.bool active;

  final _i3.DateTime? createdAt;

  final _i3.int? id;

  final _i3.int mailboxId;

  final _i3.String script;

  final _i3.String? scriptHash;

  final _i3.DateTime? updatedAt;

  final _i3.DateTime? validatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'created_at': createdAt?.toTimeZonedIso8601String(),
    if (id != null) r'id': id,
    r'mailbox_id': mailboxId,
    r'script': script,
    r'script_hash': scriptHash,
    r'updated_at': updatedAt?.toTimeZonedIso8601String(),
    r'validated_at': validatedAt?.toTimeZonedIso8601String(),
  };

  $$SieveScriptCopyWith<SieveScript> get copyWith => _SieveScriptCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SieveScript &&
        other.active == this.active &&
        other.createdAt == this.createdAt &&
        other.id == this.id &&
        other.mailboxId == this.mailboxId &&
        other.script == this.script &&
        other.scriptHash == this.scriptHash &&
        other.updatedAt == this.updatedAt &&
        other.validatedAt == this.validatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      createdAt,
      id,
      mailboxId,
      script,
      scriptHash,
      updatedAt,
      validatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'active'] = _i1.PropertyValue.scalar(active.toString());
    if (createdAt != null) {
      _$result[r'created_at'] = _i1.PropertyValue.scalar(
        createdAt!.toTimeZonedIso8601String(),
      );
    }
    if (id != null) {
      _$result[r'id'] = _i1.PropertyValue.scalar(id!.toString());
    }
    _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(mailboxId.toString());
    _$result[r'script'] = _i1.PropertyValue.scalar(script);
    if (scriptHash != null) {
      _$result[r'script_hash'] = _i1.PropertyValue.scalar(scriptHash!);
    }
    if (updatedAt != null) {
      _$result[r'updated_at'] = _i1.PropertyValue.scalar(
        updatedAt!.toTimeZonedIso8601String(),
      );
    }
    if (validatedAt != null) {
      _$result[r'validated_at'] = _i1.PropertyValue.scalar(
        validatedAt!.toTimeZonedIso8601String(),
      );
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
      r'Cannot uriEncode SieveScript: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SieveScriptCopyWith<$Res> {
  factory $$SieveScriptCopyWith(SieveScript value) = _SieveScriptCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.DateTime? createdAt,
    _i3.int? id,
    _i3.int? mailboxId,
    _i3.String? script,
    _i3.String? scriptHash,
    _i3.DateTime? updatedAt,
    _i3.DateTime? validatedAt,
  });
  _i3.bool get active;
  _i3.DateTime? get createdAt;
  _i3.int? get id;
  _i3.int get mailboxId;
  _i3.String get script;
  _i3.String? get scriptHash;
  _i3.DateTime? get updatedAt;
  _i3.DateTime? get validatedAt;
}

class _SieveScriptCopyWith<$Res> implements $$SieveScriptCopyWith<$Res> {
  _SieveScriptCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SieveScript _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.DateTime? get createdAt => _value.createdAt;

  @_i3.override
  _i3.int? get id => _value.id;

  @_i3.override
  _i3.int get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.String get script => _value.script;

  @_i3.override
  _i3.String? get scriptHash => _value.scriptHash;

  @_i3.override
  _i3.DateTime? get updatedAt => _value.updatedAt;

  @_i3.override
  _i3.DateTime? get validatedAt => _value.validatedAt;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? script = _sentinel,
    _i3.Object? scriptHash = _sentinel,
    _i3.Object? updatedAt = _sentinel,
    _i3.Object? validatedAt = _sentinel,
  }) {
    return (SieveScript(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime?),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int),
      script: _i3.identical(script, _sentinel)
          ? this.script
          : (script as _i3.String),
      scriptHash: _i3.identical(scriptHash, _sentinel)
          ? this.scriptHash
          : (scriptHash as _i3.String?),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime?),
      validatedAt: _i3.identical(validatedAt, _sentinel)
          ? this.validatedAt
          : (validatedAt as _i3.DateTime?),
    ) as $Res);
  }
}
