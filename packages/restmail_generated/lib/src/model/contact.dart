// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/contact_source_model.dart' as _i4;
import 'package:restmail_generated/src/model/contact_trust_level_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Contact extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Contact({
    required this.createdAt,
    required this.email,
    required this.id,
    required this.mailboxId,
    required this.name,
    required this.source,
    required this.trustLevel,
    required this.updatedAt,
  });

  factory Contact.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'created_at',
        r'email',
        r'id',
        r'mailbox_id',
        r'name',
        r'source',
        r'trust_level',
        r'updated_at',
      },
      listKeys: {},
      context: r'Contact',
    );
    return Contact(
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'Contact.created_at',
      ),
      email: _$values[r'email'].decodeSimpleString(context: r'Contact.email'),
      id: _$values[r'id'].decodeSimpleInt(context: r'Contact.id'),
      mailboxId: _$values[r'mailbox_id'].decodeSimpleInt(
        context: r'Contact.mailbox_id',
      ),
      name: _$values[r'name'].decodeSimpleString(context: r'Contact.name'),
      source: _i4.ContactSourceModel.fromSimple(
        _$values[r'source'],
        explode: explode,
      ),
      trustLevel: _i5.ContactTrustLevelModel.fromSimple(
        _$values[r'trust_level'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeSimpleDateTime(
        context: r'Contact.updated_at',
      ),
    );
  }

  factory Contact.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Contact');
    return Contact(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Contact.created_at',
      ),
      email: _$map[r'email'].decodeJsonString(context: r'Contact.email'),
      id: _$map[r'id'].decodeJsonInt(context: r'Contact.id'),
      mailboxId: _$map[r'mailbox_id'].decodeJsonInt(
        context: r'Contact.mailbox_id',
      ),
      name: _$map[r'name'].decodeJsonString(context: r'Contact.name'),
      source: _i4.ContactSourceModel.fromJson(_$map[r'source']),
      trustLevel: _i5.ContactTrustLevelModel.fromJson(_$map[r'trust_level']),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Contact.updated_at',
      ),
    );
  }

  factory Contact.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'created_at',
        r'email',
        r'id',
        r'mailbox_id',
        r'name',
        r'source',
        r'trust_level',
        r'updated_at',
      },
      listKeys: {},
      context: r'Contact',
    );
    return Contact(
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'Contact.created_at',
      ),
      email: _$values[r'email'].decodeFormString(context: r'Contact.email'),
      id: _$values[r'id'].decodeFormInt(context: r'Contact.id'),
      mailboxId: _$values[r'mailbox_id'].decodeFormInt(
        context: r'Contact.mailbox_id',
      ),
      name: _$values[r'name'].decodeFormString(context: r'Contact.name'),
      source: _i4.ContactSourceModel.fromForm(
        _$values[r'source'],
        explode: explode,
      ),
      trustLevel: _i5.ContactTrustLevelModel.fromForm(
        _$values[r'trust_level'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeFormDateTime(
        context: r'Contact.updated_at',
      ),
    );
  }

  final _i3.DateTime createdAt;

  final _i3.String email;

  final _i3.int id;

  final _i3.int mailboxId;

  final _i3.String name;

  final _i4.ContactSourceModel source;

  final _i5.ContactTrustLevelModel trustLevel;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'email': email,
    r'id': id,
    r'mailbox_id': mailboxId,
    r'name': name,
    r'source': source.toJson(),
    r'trust_level': trustLevel.toJson(),
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$ContactCopyWith<Contact> get copyWith => _ContactCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Contact &&
        other.createdAt == this.createdAt &&
        other.email == this.email &&
        other.id == this.id &&
        other.mailboxId == this.mailboxId &&
        other.name == this.name &&
        other.source == this.source &&
        other.trustLevel == this.trustLevel &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      createdAt,
      email,
      id,
      mailboxId,
      name,
      source,
      trustLevel,
      updatedAt,
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
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(mailboxId.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'source'] = _i1.PropertyValue.scalar(source.toJson());
    _$result[r'trust_level'] = _i1.PropertyValue.scalar(trustLevel.toJson());
    _$result[r'updated_at'] = _i1.PropertyValue.scalar(
      updatedAt.toTimeZonedIso8601String(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Contact: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ContactCopyWith<$Res> {
  factory $$ContactCopyWith(Contact value) = _ContactCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i3.String? email,
    _i3.int? id,
    _i3.int? mailboxId,
    _i3.String? name,
    _i4.ContactSourceModel? source,
    _i5.ContactTrustLevelModel? trustLevel,
    _i3.DateTime? updatedAt,
  });
  _i3.DateTime get createdAt;
  _i3.String get email;
  _i3.int get id;
  _i3.int get mailboxId;
  _i3.String get name;
  _i4.ContactSourceModel get source;
  _i5.ContactTrustLevelModel get trustLevel;
  _i3.DateTime get updatedAt;
}

class _ContactCopyWith<$Res> implements $$ContactCopyWith<$Res> {
  _ContactCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Contact _value;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.int get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i4.ContactSourceModel get source => _value.source;

  @_i3.override
  _i5.ContactTrustLevelModel get trustLevel => _value.trustLevel;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? email = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? source = _sentinel,
    _i3.Object? trustLevel = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Contact(
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      source: _i3.identical(source, _sentinel)
          ? this.source
          : (source as _i4.ContactSourceModel),
      trustLevel: _i3.identical(trustLevel, _sentinel)
          ? this.trustLevel
          : (trustLevel as _i5.ContactTrustLevelModel),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
