// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QuarantinedMessage extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QuarantinedMessage({
    required this.bodyPreview,
    required this.expiresAt,
    required this.id,
    required this.mailboxId,
    required this.quarantineReason,
    required this.receivedAt,
    required this.released,
    required this.sender,
    required this.subject,
    this.spamScore,
  });

  factory QuarantinedMessage.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'body_preview',
        r'expires_at',
        r'id',
        r'mailbox_id',
        r'quarantine_reason',
        r'received_at',
        r'released',
        r'sender',
        r'spam_score',
        r'subject',
      },
      listKeys: {},
      context: r'QuarantinedMessage',
    );
    return QuarantinedMessage(
      bodyPreview: _$values[r'body_preview'].decodeSimpleString(
        context: r'QuarantinedMessage.body_preview',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'QuarantinedMessage.expires_at',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'QuarantinedMessage.id'),
      mailboxId: _$values[r'mailbox_id'].decodeSimpleInt(
        context: r'QuarantinedMessage.mailbox_id',
      ),
      quarantineReason: _$values[r'quarantine_reason'].decodeSimpleString(
        context: r'QuarantinedMessage.quarantine_reason',
      ),
      receivedAt: _$values[r'received_at'].decodeSimpleDateTime(
        context: r'QuarantinedMessage.received_at',
      ),
      released: _$values[r'released'].decodeSimpleBool(
        context: r'QuarantinedMessage.released',
      ),
      sender: _$values[r'sender'].decodeSimpleString(
        context: r'QuarantinedMessage.sender',
      ),
      spamScore: _$values[r'spam_score'].decodeSimpleNullableDouble(
        context: r'QuarantinedMessage.spam_score',
      ),
      subject: _$values[r'subject'].decodeSimpleString(
        context: r'QuarantinedMessage.subject',
      ),
    );
  }

  factory QuarantinedMessage.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QuarantinedMessage');
    return QuarantinedMessage(
      bodyPreview: _$map[r'body_preview'].decodeJsonString(
        context: r'QuarantinedMessage.body_preview',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'QuarantinedMessage.expires_at',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'QuarantinedMessage.id'),
      mailboxId: _$map[r'mailbox_id'].decodeJsonInt(
        context: r'QuarantinedMessage.mailbox_id',
      ),
      quarantineReason: _$map[r'quarantine_reason'].decodeJsonString(
        context: r'QuarantinedMessage.quarantine_reason',
      ),
      receivedAt: _$map[r'received_at'].decodeJsonDateTime(
        context: r'QuarantinedMessage.received_at',
      ),
      released: _$map[r'released'].decodeJsonBool(
        context: r'QuarantinedMessage.released',
      ),
      sender: _$map[r'sender'].decodeJsonString(
        context: r'QuarantinedMessage.sender',
      ),
      spamScore: _$map[r'spam_score'].decodeJsonNullableDouble(
        context: r'QuarantinedMessage.spam_score',
      ),
      subject: _$map[r'subject'].decodeJsonString(
        context: r'QuarantinedMessage.subject',
      ),
    );
  }

  factory QuarantinedMessage.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'body_preview',
        r'expires_at',
        r'id',
        r'mailbox_id',
        r'quarantine_reason',
        r'received_at',
        r'released',
        r'sender',
        r'spam_score',
        r'subject',
      },
      listKeys: {},
      context: r'QuarantinedMessage',
    );
    return QuarantinedMessage(
      bodyPreview: _$values[r'body_preview'].decodeFormString(
        context: r'QuarantinedMessage.body_preview',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'QuarantinedMessage.expires_at',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'QuarantinedMessage.id'),
      mailboxId: _$values[r'mailbox_id'].decodeFormInt(
        context: r'QuarantinedMessage.mailbox_id',
      ),
      quarantineReason: _$values[r'quarantine_reason'].decodeFormString(
        context: r'QuarantinedMessage.quarantine_reason',
      ),
      receivedAt: _$values[r'received_at'].decodeFormDateTime(
        context: r'QuarantinedMessage.received_at',
      ),
      released: _$values[r'released'].decodeFormBool(
        context: r'QuarantinedMessage.released',
      ),
      sender: _$values[r'sender'].decodeFormString(
        context: r'QuarantinedMessage.sender',
      ),
      spamScore: _$values[r'spam_score'].decodeFormNullableDouble(
        context: r'QuarantinedMessage.spam_score',
      ),
      subject: _$values[r'subject'].decodeFormString(
        context: r'QuarantinedMessage.subject',
      ),
    );
  }

  final _i3.String bodyPreview;

  final _i3.DateTime expiresAt;

  final _i3.int id;

  final _i3.int mailboxId;

  final _i3.String quarantineReason;

  final _i3.DateTime receivedAt;

  final _i3.bool released;

  final _i3.String sender;

  final _i3.double? spamScore;

  final _i3.String subject;

  @_i3.override
  _i3.Object? toJson() => {
    r'body_preview': bodyPreview,
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
    r'id': id,
    r'mailbox_id': mailboxId,
    r'quarantine_reason': quarantineReason,
    r'received_at': receivedAt.toTimeZonedIso8601String(),
    r'released': released,
    r'sender': sender,
    r'spam_score': spamScore,
    r'subject': subject,
  };

  $$QuarantinedMessageCopyWith<QuarantinedMessage> get copyWith =>
      _QuarantinedMessageCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is QuarantinedMessage &&
        other.bodyPreview == this.bodyPreview &&
        other.expiresAt == this.expiresAt &&
        other.id == this.id &&
        other.mailboxId == this.mailboxId &&
        other.quarantineReason == this.quarantineReason &&
        other.receivedAt == this.receivedAt &&
        other.released == this.released &&
        other.sender == this.sender &&
        other.spamScore == this.spamScore &&
        other.subject == this.subject;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      bodyPreview,
      expiresAt,
      id,
      mailboxId,
      quarantineReason,
      receivedAt,
      released,
      sender,
      spamScore,
      subject,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'body_preview'] = _i1.PropertyValue.scalar(bodyPreview);
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(mailboxId.toString());
    _$result[r'quarantine_reason'] = _i1.PropertyValue.scalar(quarantineReason);
    _$result[r'received_at'] = _i1.PropertyValue.scalar(
      receivedAt.toTimeZonedIso8601String(),
    );
    _$result[r'released'] = _i1.PropertyValue.scalar(released.toString());
    _$result[r'sender'] = _i1.PropertyValue.scalar(sender);
    if (spamScore != null) {
      _$result[r'spam_score'] = _i1.PropertyValue.scalar(spamScore!.toString());
    }
    _$result[r'subject'] = _i1.PropertyValue.scalar(subject);
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
      r'Cannot uriEncode QuarantinedMessage: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QuarantinedMessageCopyWith<$Res> {
  factory $$QuarantinedMessageCopyWith(QuarantinedMessage value) =
      _QuarantinedMessageCopyWith<$Res>;

  $Res call({
    _i3.String? bodyPreview,
    _i3.DateTime? expiresAt,
    _i3.int? id,
    _i3.int? mailboxId,
    _i3.String? quarantineReason,
    _i3.DateTime? receivedAt,
    _i3.bool? released,
    _i3.String? sender,
    _i3.double? spamScore,
    _i3.String? subject,
  });
  _i3.String get bodyPreview;
  _i3.DateTime get expiresAt;
  _i3.int get id;
  _i3.int get mailboxId;
  _i3.String get quarantineReason;
  _i3.DateTime get receivedAt;
  _i3.bool get released;
  _i3.String get sender;
  _i3.double? get spamScore;
  _i3.String get subject;
}

class _QuarantinedMessageCopyWith<$Res>
    implements $$QuarantinedMessageCopyWith<$Res> {
  _QuarantinedMessageCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QuarantinedMessage _value;

  @_i3.override
  _i3.String get bodyPreview => _value.bodyPreview;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.int get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.String get quarantineReason => _value.quarantineReason;

  @_i3.override
  _i3.DateTime get receivedAt => _value.receivedAt;

  @_i3.override
  _i3.bool get released => _value.released;

  @_i3.override
  _i3.String get sender => _value.sender;

  @_i3.override
  _i3.double? get spamScore => _value.spamScore;

  @_i3.override
  _i3.String get subject => _value.subject;

  @_i3.override
  $Res call({
    _i3.Object? bodyPreview = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? quarantineReason = _sentinel,
    _i3.Object? receivedAt = _sentinel,
    _i3.Object? released = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? spamScore = _sentinel,
    _i3.Object? subject = _sentinel,
  }) {
    return (QuarantinedMessage(
      bodyPreview: _i3.identical(bodyPreview, _sentinel)
          ? this.bodyPreview
          : (bodyPreview as _i3.String),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int),
      quarantineReason: _i3.identical(quarantineReason, _sentinel)
          ? this.quarantineReason
          : (quarantineReason as _i3.String),
      receivedAt: _i3.identical(receivedAt, _sentinel)
          ? this.receivedAt
          : (receivedAt as _i3.DateTime),
      released: _i3.identical(released, _sentinel)
          ? this.released
          : (released as _i3.bool),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String),
      spamScore: _i3.identical(spamScore, _sentinel)
          ? this.spamScore
          : (spamScore as _i3.double?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String),
    ) as $Res);
  }
}
