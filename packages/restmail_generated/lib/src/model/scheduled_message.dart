// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/scheduled_message_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ScheduledMessage extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ScheduledMessage({
    required this.accountId,
    required this.attempts,
    required this.createdAt,
    required this.from,
    required this.id,
    required this.scheduledAt,
    required this.status,
    required this.subject,
    required this.to,
    required this.updatedAt,
    this.lastError,
    this.sentMessageId,
  });

  factory ScheduledMessage.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'account_id',
        r'attempts',
        r'created_at',
        r'from',
        r'id',
        r'last_error',
        r'scheduled_at',
        r'sent_message_id',
        r'status',
        r'subject',
        r'to',
        r'updated_at',
      },
      listKeys: {},
      context: r'ScheduledMessage',
    );
    return ScheduledMessage(
      accountId: _$values[r'account_id'].decodeSimpleInt(
        context: r'ScheduledMessage.account_id',
      ),
      attempts: _$values[r'attempts'].decodeSimpleInt(
        context: r'ScheduledMessage.attempts',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'ScheduledMessage.created_at',
      ),
      from: _$values[r'from'].decodeSimpleString(
        context: r'ScheduledMessage.from',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'ScheduledMessage.id'),
      lastError: _$values[r'last_error'].decodeSimpleNullableString(
        context: r'ScheduledMessage.last_error',
      ),
      scheduledAt: _$values[r'scheduled_at'].decodeSimpleDateTime(
        context: r'ScheduledMessage.scheduled_at',
      ),
      sentMessageId: _$values[r'sent_message_id'].decodeSimpleNullableInt(
        context: r'ScheduledMessage.sent_message_id',
      ),
      status: _i4.ScheduledMessageStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
      subject: _$values[r'subject'].decodeSimpleString(
        context: r'ScheduledMessage.subject',
      ),
      to: _$values[r'to'],
      updatedAt: _$values[r'updated_at'].decodeSimpleDateTime(
        context: r'ScheduledMessage.updated_at',
      ),
    );
  }

  factory ScheduledMessage.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ScheduledMessage');
    return ScheduledMessage(
      accountId: _$map[r'account_id'].decodeJsonInt(
        context: r'ScheduledMessage.account_id',
      ),
      attempts: _$map[r'attempts'].decodeJsonInt(
        context: r'ScheduledMessage.attempts',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'ScheduledMessage.created_at',
      ),
      from: _$map[r'from'].decodeJsonString(context: r'ScheduledMessage.from'),
      id: _$map[r'id'].decodeJsonInt(context: r'ScheduledMessage.id'),
      lastError: _$map[r'last_error'].decodeJsonNullableString(
        context: r'ScheduledMessage.last_error',
      ),
      scheduledAt: _$map[r'scheduled_at'].decodeJsonDateTime(
        context: r'ScheduledMessage.scheduled_at',
      ),
      sentMessageId: _$map[r'sent_message_id'].decodeJsonNullableInt(
        context: r'ScheduledMessage.sent_message_id',
      ),
      status: _i4.ScheduledMessageStatusModel.fromJson(_$map[r'status']),
      subject: _$map[r'subject'].decodeJsonString(
        context: r'ScheduledMessage.subject',
      ),
      to: _$map[r'to'],
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'ScheduledMessage.updated_at',
      ),
    );
  }

  factory ScheduledMessage.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'account_id',
        r'attempts',
        r'created_at',
        r'from',
        r'id',
        r'last_error',
        r'scheduled_at',
        r'sent_message_id',
        r'status',
        r'subject',
        r'to',
        r'updated_at',
      },
      listKeys: {},
      context: r'ScheduledMessage',
    );
    return ScheduledMessage(
      accountId: _$values[r'account_id'].decodeFormInt(
        context: r'ScheduledMessage.account_id',
      ),
      attempts: _$values[r'attempts'].decodeFormInt(
        context: r'ScheduledMessage.attempts',
      ),
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'ScheduledMessage.created_at',
      ),
      from: _$values[r'from'].decodeFormString(
        context: r'ScheduledMessage.from',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'ScheduledMessage.id'),
      lastError: _$values[r'last_error'].decodeFormNullableString(
        context: r'ScheduledMessage.last_error',
      ),
      scheduledAt: _$values[r'scheduled_at'].decodeFormDateTime(
        context: r'ScheduledMessage.scheduled_at',
      ),
      sentMessageId: _$values[r'sent_message_id'].decodeFormNullableInt(
        context: r'ScheduledMessage.sent_message_id',
      ),
      status: _i4.ScheduledMessageStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
      subject: _$values[r'subject'].decodeFormString(
        context: r'ScheduledMessage.subject',
      ),
      to: _$values[r'to'].decodeFormNullableString(
        context: r'ScheduledMessage.to',
      ),
      updatedAt: _$values[r'updated_at'].decodeFormDateTime(
        context: r'ScheduledMessage.updated_at',
      ),
    );
  }

  final _i3.int accountId;

  final _i3.int attempts;

  final _i3.DateTime createdAt;

  final _i3.String from;

  final _i3.int id;

  final _i3.String? lastError;

  final _i3.DateTime scheduledAt;

  final _i3.int? sentMessageId;

  final _i4.ScheduledMessageStatusModel status;

  final _i3.String subject;

  final _i3.Object? to;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'account_id': accountId,
    r'attempts': attempts,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'from': from,
    r'id': id,
    if (lastError != null) r'last_error': lastError,
    r'scheduled_at': scheduledAt.toTimeZonedIso8601String(),
    r'sent_message_id': sentMessageId,
    r'status': status.toJson(),
    r'subject': subject,
    r'to': _i1.encodeUnknownJson(to, context: r'ScheduledMessage.to'),
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$ScheduledMessageCopyWith<ScheduledMessage> get copyWith =>
      _ScheduledMessageCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ScheduledMessage &&
        other.accountId == this.accountId &&
        other.attempts == this.attempts &&
        other.createdAt == this.createdAt &&
        other.from == this.from &&
        other.id == this.id &&
        other.lastError == this.lastError &&
        other.scheduledAt == this.scheduledAt &&
        other.sentMessageId == this.sentMessageId &&
        other.status == this.status &&
        other.subject == this.subject &&
        other.to == this.to &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      accountId,
      attempts,
      createdAt,
      from,
      id,
      lastError,
      scheduledAt,
      sentMessageId,
      status,
      subject,
      to,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'account_id'] = _i1.PropertyValue.scalar(accountId.toString());
    _$result[r'attempts'] = _i1.PropertyValue.scalar(attempts.toString());
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'from'] = _i1.PropertyValue.scalar(from);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    if (lastError != null) {
      _$result[r'last_error'] = _i1.PropertyValue.scalar(lastError!);
    }
    _$result[r'scheduled_at'] = _i1.PropertyValue.scalar(
      scheduledAt.toTimeZonedIso8601String(),
    );
    if (sentMessageId != null) {
      _$result[r'sent_message_id'] = _i1.PropertyValue.scalar(
        sentMessageId!.toString(),
      );
    }
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
    _$result[r'subject'] = _i1.PropertyValue.scalar(subject);
    if (to != null) {
      _$result[r'to'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(to!, context: r'ScheduledMessage.to'),
      );
    }
    _$result[r'updated_at'] = _i1.PropertyValue.scalar(
      updatedAt.toTimeZonedIso8601String(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ScheduledMessage: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ScheduledMessageCopyWith<$Res> {
  factory $$ScheduledMessageCopyWith(ScheduledMessage value) =
      _ScheduledMessageCopyWith<$Res>;

  $Res call({
    _i3.int? accountId,
    _i3.int? attempts,
    _i3.DateTime? createdAt,
    _i3.String? from,
    _i3.int? id,
    _i3.String? lastError,
    _i3.DateTime? scheduledAt,
    _i3.int? sentMessageId,
    _i4.ScheduledMessageStatusModel? status,
    _i3.String? subject,
    _i3.Object? to,
    _i3.DateTime? updatedAt,
  });
  _i3.int get accountId;
  _i3.int get attempts;
  _i3.DateTime get createdAt;
  _i3.String get from;
  _i3.int get id;
  _i3.String? get lastError;
  _i3.DateTime get scheduledAt;
  _i3.int? get sentMessageId;
  _i4.ScheduledMessageStatusModel get status;
  _i3.String get subject;
  _i3.Object? get to;
  _i3.DateTime get updatedAt;
}

class _ScheduledMessageCopyWith<$Res>
    implements $$ScheduledMessageCopyWith<$Res> {
  _ScheduledMessageCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ScheduledMessage _value;

  @_i3.override
  _i3.int get accountId => _value.accountId;

  @_i3.override
  _i3.int get attempts => _value.attempts;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get from => _value.from;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String? get lastError => _value.lastError;

  @_i3.override
  _i3.DateTime get scheduledAt => _value.scheduledAt;

  @_i3.override
  _i3.int? get sentMessageId => _value.sentMessageId;

  @_i3.override
  _i4.ScheduledMessageStatusModel get status => _value.status;

  @_i3.override
  _i3.String get subject => _value.subject;

  @_i3.override
  _i3.Object? get to => _value.to;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? accountId = _sentinel,
    _i3.Object? attempts = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? lastError = _sentinel,
    _i3.Object? scheduledAt = _sentinel,
    _i3.Object? sentMessageId = _sentinel,
    _i3.Object? status = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (ScheduledMessage(
      accountId: _i3.identical(accountId, _sentinel)
          ? this.accountId
          : (accountId as _i3.int),
      attempts: _i3.identical(attempts, _sentinel)
          ? this.attempts
          : (attempts as _i3.int),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      lastError: _i3.identical(lastError, _sentinel)
          ? this.lastError
          : (lastError as _i3.String?),
      scheduledAt: _i3.identical(scheduledAt, _sentinel)
          ? this.scheduledAt
          : (scheduledAt as _i3.DateTime),
      sentMessageId: _i3.identical(sentMessageId, _sentinel)
          ? this.sentMessageId
          : (sentMessageId as _i3.int?),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.ScheduledMessageStatusModel),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String),
      to: _i3.identical(to, _sentinel) ? this.to : to,
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
