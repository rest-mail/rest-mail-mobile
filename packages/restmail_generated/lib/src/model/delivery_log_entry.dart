// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/delivery_log_entry_failure_category_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/delivery_log_entry_status_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliveryLogEntry extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeliveryLogEntry({
    required this.attempts,
    required this.bodyType,
    required this.createdAt,
    required this.domain,
    required this.expiresAt,
    required this.failureCategory,
    required this.id,
    required this.lastAttempt,
    required this.lastError,
    required this.lastErrorCode,
    required this.maxRetries,
    required this.messageId,
    required this.nextAttempt,
    required this.recipient,
    required this.sender,
    required this.status,
  });

  factory DeliveryLogEntry.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'attempts',
        r'body_type',
        r'created_at',
        r'domain',
        r'expires_at',
        r'failure_category',
        r'id',
        r'last_attempt',
        r'last_error',
        r'last_error_code',
        r'max_retries',
        r'message_id',
        r'next_attempt',
        r'recipient',
        r'sender',
        r'status',
      },
      listKeys: {},
      context: r'DeliveryLogEntry',
    );
    return DeliveryLogEntry(
      attempts: _$values[r'attempts'].decodeSimpleInt(
        context: r'DeliveryLogEntry.attempts',
      ),
      bodyType: _$values[r'body_type'].decodeSimpleString(
        context: r'DeliveryLogEntry.body_type',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'DeliveryLogEntry.created_at',
      ),
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'DeliveryLogEntry.domain',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'DeliveryLogEntry.expires_at',
      ),
      failureCategory: _i4.DeliveryLogEntryFailureCategoryModel.fromSimple(
        _$values[r'failure_category'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'DeliveryLogEntry.id'),
      lastAttempt: _$values[r'last_attempt'].decodeSimpleNullableDateTime(
        context: r'DeliveryLogEntry.last_attempt',
      ),
      lastError: _$values[r'last_error'].decodeSimpleString(
        context: r'DeliveryLogEntry.last_error',
      ),
      lastErrorCode: _$values[r'last_error_code'].decodeSimpleInt(
        context: r'DeliveryLogEntry.last_error_code',
      ),
      maxRetries: _$values[r'max_retries'].decodeSimpleInt(
        context: r'DeliveryLogEntry.max_retries',
      ),
      messageId: _$values[r'message_id'].decodeSimpleNullableInt(
        context: r'DeliveryLogEntry.message_id',
      ),
      nextAttempt: _$values[r'next_attempt'].decodeSimpleDateTime(
        context: r'DeliveryLogEntry.next_attempt',
      ),
      recipient: _$values[r'recipient'].decodeSimpleString(
        context: r'DeliveryLogEntry.recipient',
      ),
      sender: _$values[r'sender'].decodeSimpleString(
        context: r'DeliveryLogEntry.sender',
      ),
      status: _i5.DeliveryLogEntryStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory DeliveryLogEntry.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeliveryLogEntry');
    return DeliveryLogEntry(
      attempts: _$map[r'attempts'].decodeJsonInt(
        context: r'DeliveryLogEntry.attempts',
      ),
      bodyType: _$map[r'body_type'].decodeJsonString(
        context: r'DeliveryLogEntry.body_type',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'DeliveryLogEntry.created_at',
      ),
      domain: _$map[r'domain'].decodeJsonString(
        context: r'DeliveryLogEntry.domain',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'DeliveryLogEntry.expires_at',
      ),
      failureCategory: _i4.DeliveryLogEntryFailureCategoryModel.fromJson(
        _$map[r'failure_category'],
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'DeliveryLogEntry.id'),
      lastAttempt: _$map[r'last_attempt'].decodeJsonNullableDateTime(
        context: r'DeliveryLogEntry.last_attempt',
      ),
      lastError: _$map[r'last_error'].decodeJsonString(
        context: r'DeliveryLogEntry.last_error',
      ),
      lastErrorCode: _$map[r'last_error_code'].decodeJsonInt(
        context: r'DeliveryLogEntry.last_error_code',
      ),
      maxRetries: _$map[r'max_retries'].decodeJsonInt(
        context: r'DeliveryLogEntry.max_retries',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableInt(
        context: r'DeliveryLogEntry.message_id',
      ),
      nextAttempt: _$map[r'next_attempt'].decodeJsonDateTime(
        context: r'DeliveryLogEntry.next_attempt',
      ),
      recipient: _$map[r'recipient'].decodeJsonString(
        context: r'DeliveryLogEntry.recipient',
      ),
      sender: _$map[r'sender'].decodeJsonString(
        context: r'DeliveryLogEntry.sender',
      ),
      status: _i5.DeliveryLogEntryStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory DeliveryLogEntry.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'attempts',
        r'body_type',
        r'created_at',
        r'domain',
        r'expires_at',
        r'failure_category',
        r'id',
        r'last_attempt',
        r'last_error',
        r'last_error_code',
        r'max_retries',
        r'message_id',
        r'next_attempt',
        r'recipient',
        r'sender',
        r'status',
      },
      listKeys: {},
      context: r'DeliveryLogEntry',
    );
    return DeliveryLogEntry(
      attempts: _$values[r'attempts'].decodeFormInt(
        context: r'DeliveryLogEntry.attempts',
      ),
      bodyType: _$values[r'body_type'].decodeFormString(
        context: r'DeliveryLogEntry.body_type',
      ),
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'DeliveryLogEntry.created_at',
      ),
      domain: _$values[r'domain'].decodeFormString(
        context: r'DeliveryLogEntry.domain',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'DeliveryLogEntry.expires_at',
      ),
      failureCategory: _i4.DeliveryLogEntryFailureCategoryModel.fromForm(
        _$values[r'failure_category'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeFormInt(context: r'DeliveryLogEntry.id'),
      lastAttempt: _$values[r'last_attempt'].decodeFormNullableDateTime(
        context: r'DeliveryLogEntry.last_attempt',
      ),
      lastError: _$values[r'last_error'].decodeFormString(
        context: r'DeliveryLogEntry.last_error',
      ),
      lastErrorCode: _$values[r'last_error_code'].decodeFormInt(
        context: r'DeliveryLogEntry.last_error_code',
      ),
      maxRetries: _$values[r'max_retries'].decodeFormInt(
        context: r'DeliveryLogEntry.max_retries',
      ),
      messageId: _$values[r'message_id'].decodeFormNullableInt(
        context: r'DeliveryLogEntry.message_id',
      ),
      nextAttempt: _$values[r'next_attempt'].decodeFormDateTime(
        context: r'DeliveryLogEntry.next_attempt',
      ),
      recipient: _$values[r'recipient'].decodeFormString(
        context: r'DeliveryLogEntry.recipient',
      ),
      sender: _$values[r'sender'].decodeFormString(
        context: r'DeliveryLogEntry.sender',
      ),
      status: _i5.DeliveryLogEntryStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i3.int attempts;

  final _i3.String bodyType;

  final _i3.DateTime createdAt;

  final _i3.String domain;

  final _i3.DateTime expiresAt;

  final _i4.DeliveryLogEntryFailureCategoryModel failureCategory;

  final _i3.int id;

  final _i3.DateTime? lastAttempt;

  final _i3.String lastError;

  final _i3.int lastErrorCode;

  final _i3.int maxRetries;

  final _i3.int? messageId;

  final _i3.DateTime nextAttempt;

  final _i3.String recipient;

  final _i3.String sender;

  final _i5.DeliveryLogEntryStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {
    r'attempts': attempts,
    r'body_type': bodyType,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'domain': domain,
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
    r'failure_category': failureCategory.toJson(),
    r'id': id,
    r'last_attempt': lastAttempt?.toTimeZonedIso8601String(),
    r'last_error': lastError,
    r'last_error_code': lastErrorCode,
    r'max_retries': maxRetries,
    r'message_id': messageId,
    r'next_attempt': nextAttempt.toTimeZonedIso8601String(),
    r'recipient': recipient,
    r'sender': sender,
    r'status': status.toJson(),
  };

  $$DeliveryLogEntryCopyWith<DeliveryLogEntry> get copyWith =>
      _DeliveryLogEntryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliveryLogEntry &&
        other.attempts == this.attempts &&
        other.bodyType == this.bodyType &&
        other.createdAt == this.createdAt &&
        other.domain == this.domain &&
        other.expiresAt == this.expiresAt &&
        other.failureCategory == this.failureCategory &&
        other.id == this.id &&
        other.lastAttempt == this.lastAttempt &&
        other.lastError == this.lastError &&
        other.lastErrorCode == this.lastErrorCode &&
        other.maxRetries == this.maxRetries &&
        other.messageId == this.messageId &&
        other.nextAttempt == this.nextAttempt &&
        other.recipient == this.recipient &&
        other.sender == this.sender &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      attempts,
      bodyType,
      createdAt,
      domain,
      expiresAt,
      failureCategory,
      id,
      lastAttempt,
      lastError,
      lastErrorCode,
      maxRetries,
      messageId,
      nextAttempt,
      recipient,
      sender,
      status,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'attempts'] = _i1.PropertyValue.scalar(attempts.toString());
    _$result[r'body_type'] = _i1.PropertyValue.scalar(bodyType);
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'domain'] = _i1.PropertyValue.scalar(domain);
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
    _$result[r'failure_category'] = _i1.PropertyValue.scalar(
      failureCategory.toJson(),
    );
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    if (lastAttempt != null) {
      _$result[r'last_attempt'] = _i1.PropertyValue.scalar(
        lastAttempt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'last_error'] = _i1.PropertyValue.scalar(lastError);
    _$result[r'last_error_code'] = _i1.PropertyValue.scalar(
      lastErrorCode.toString(),
    );
    _$result[r'max_retries'] = _i1.PropertyValue.scalar(maxRetries.toString());
    if (messageId != null) {
      _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId!.toString());
    }
    _$result[r'next_attempt'] = _i1.PropertyValue.scalar(
      nextAttempt.toTimeZonedIso8601String(),
    );
    _$result[r'recipient'] = _i1.PropertyValue.scalar(recipient);
    _$result[r'sender'] = _i1.PropertyValue.scalar(sender);
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
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
      r'Cannot uriEncode DeliveryLogEntry: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeliveryLogEntryCopyWith<$Res> {
  factory $$DeliveryLogEntryCopyWith(DeliveryLogEntry value) =
      _DeliveryLogEntryCopyWith<$Res>;

  $Res call({
    _i3.int? attempts,
    _i3.String? bodyType,
    _i3.DateTime? createdAt,
    _i3.String? domain,
    _i3.DateTime? expiresAt,
    _i4.DeliveryLogEntryFailureCategoryModel? failureCategory,
    _i3.int? id,
    _i3.DateTime? lastAttempt,
    _i3.String? lastError,
    _i3.int? lastErrorCode,
    _i3.int? maxRetries,
    _i3.int? messageId,
    _i3.DateTime? nextAttempt,
    _i3.String? recipient,
    _i3.String? sender,
    _i5.DeliveryLogEntryStatusModel? status,
  });
  _i3.int get attempts;
  _i3.String get bodyType;
  _i3.DateTime get createdAt;
  _i3.String get domain;
  _i3.DateTime get expiresAt;
  _i4.DeliveryLogEntryFailureCategoryModel get failureCategory;
  _i3.int get id;
  _i3.DateTime? get lastAttempt;
  _i3.String get lastError;
  _i3.int get lastErrorCode;
  _i3.int get maxRetries;
  _i3.int? get messageId;
  _i3.DateTime get nextAttempt;
  _i3.String get recipient;
  _i3.String get sender;
  _i5.DeliveryLogEntryStatusModel get status;
}

class _DeliveryLogEntryCopyWith<$Res>
    implements $$DeliveryLogEntryCopyWith<$Res> {
  _DeliveryLogEntryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliveryLogEntry _value;

  @_i3.override
  _i3.int get attempts => _value.attempts;

  @_i3.override
  _i3.String get bodyType => _value.bodyType;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  _i4.DeliveryLogEntryFailureCategoryModel get failureCategory =>
      _value.failureCategory;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.DateTime? get lastAttempt => _value.lastAttempt;

  @_i3.override
  _i3.String get lastError => _value.lastError;

  @_i3.override
  _i3.int get lastErrorCode => _value.lastErrorCode;

  @_i3.override
  _i3.int get maxRetries => _value.maxRetries;

  @_i3.override
  _i3.int? get messageId => _value.messageId;

  @_i3.override
  _i3.DateTime get nextAttempt => _value.nextAttempt;

  @_i3.override
  _i3.String get recipient => _value.recipient;

  @_i3.override
  _i3.String get sender => _value.sender;

  @_i3.override
  _i5.DeliveryLogEntryStatusModel get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? attempts = _sentinel,
    _i3.Object? bodyType = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? failureCategory = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? lastAttempt = _sentinel,
    _i3.Object? lastError = _sentinel,
    _i3.Object? lastErrorCode = _sentinel,
    _i3.Object? maxRetries = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? nextAttempt = _sentinel,
    _i3.Object? recipient = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return (DeliveryLogEntry(
      attempts: _i3.identical(attempts, _sentinel)
          ? this.attempts
          : (attempts as _i3.int),
      bodyType: _i3.identical(bodyType, _sentinel)
          ? this.bodyType
          : (bodyType as _i3.String),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
      failureCategory: _i3.identical(failureCategory, _sentinel)
          ? this.failureCategory
          : (failureCategory as _i4.DeliveryLogEntryFailureCategoryModel),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      lastAttempt: _i3.identical(lastAttempt, _sentinel)
          ? this.lastAttempt
          : (lastAttempt as _i3.DateTime?),
      lastError: _i3.identical(lastError, _sentinel)
          ? this.lastError
          : (lastError as _i3.String),
      lastErrorCode: _i3.identical(lastErrorCode, _sentinel)
          ? this.lastErrorCode
          : (lastErrorCode as _i3.int),
      maxRetries: _i3.identical(maxRetries, _sentinel)
          ? this.maxRetries
          : (maxRetries as _i3.int),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.int?),
      nextAttempt: _i3.identical(nextAttempt, _sentinel)
          ? this.nextAttempt
          : (nextAttempt as _i3.DateTime),
      recipient: _i3.identical(recipient, _sentinel)
          ? this.recipient
          : (recipient as _i3.String),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i5.DeliveryLogEntryStatusModel),
    ) as $Res);
  }
}
