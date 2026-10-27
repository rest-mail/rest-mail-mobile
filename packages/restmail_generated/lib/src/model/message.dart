// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/message_mailbox_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Message extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Message({
    required this.createdAt,
    required this.dateHeader,
    required this.folder,
    required this.hasAttachments,
    required this.id,
    required this.inReplyTo,
    required this.isDeleted,
    required this.isDraft,
    required this.isDsn,
    required this.isFlagged,
    required this.isRead,
    required this.isStarred,
    required this.mailboxId,
    required this.messageId,
    required this.rawSize,
    required this.receivedAt,
    required this.recipientsCc,
    required this.recipientsTo,
    required this.references,
    required this.sender,
    required this.senderName,
    required this.sizeBytes,
    required this.subject,
    required this.threadId,
    required this.updatedAt,
    this.bodyHtml,
    this.bodyText,
    this.calendarEvents,
    this.headers,
    this.isAnswered,
    this.mailbox,
    this.receivedTls,
    this.tlsVersion,
  });

  factory Message.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Message: contains complex types',
    );
  }

  factory Message.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Message');
    return Message(
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'Message.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'Message.body_text',
      ),
      calendarEvents: _$map[r'calendar_events'],
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Message.created_at',
      ),
      dateHeader: _$map[r'date_header'].decodeJsonNullableDateTime(
        context: r'Message.date_header',
      ),
      folder: _$map[r'folder'].decodeJsonString(context: r'Message.folder'),
      hasAttachments: _$map[r'has_attachments'].decodeJsonBool(
        context: r'Message.has_attachments',
      ),
      headers: _$map[r'headers'],
      id: _$map[r'id'].decodeJsonInt(context: r'Message.id'),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonString(
        context: r'Message.in_reply_to',
      ),
      isAnswered: _$map[r'is_answered'].decodeJsonNullableBool(
        context: r'Message.is_answered',
      ),
      isDeleted: _$map[r'is_deleted'].decodeJsonBool(
        context: r'Message.is_deleted',
      ),
      isDraft: _$map[r'is_draft'].decodeJsonBool(context: r'Message.is_draft'),
      isDsn: _$map[r'is_dsn'].decodeJsonBool(context: r'Message.is_dsn'),
      isFlagged: _$map[r'is_flagged'].decodeJsonBool(
        context: r'Message.is_flagged',
      ),
      isRead: _$map[r'is_read'].decodeJsonBool(context: r'Message.is_read'),
      isStarred: _$map[r'is_starred'].decodeJsonBool(
        context: r'Message.is_starred',
      ),
      mailbox: _$map[r'mailbox'] == null
          ? null
          : _i4.MessageMailboxOneOfModel.fromJson(_$map[r'mailbox']),
      mailboxId: _$map[r'mailbox_id'].decodeJsonInt(
        context: r'Message.mailbox_id',
      ),
      messageId: _$map[r'message_id'].decodeJsonString(
        context: r'Message.message_id',
      ),
      rawSize: _$map[r'raw_size'].decodeJsonInt(context: r'Message.raw_size'),
      receivedAt: _$map[r'received_at'].decodeJsonDateTime(
        context: r'Message.received_at',
      ),
      receivedTls: _$map[r'received_tls'].decodeJsonNullableBool(
        context: r'Message.received_tls',
      ),
      recipientsCc: _$map[r'recipients_cc'],
      recipientsTo: _$map[r'recipients_to'],
      references: _$map[r'references'].decodeJsonString(
        context: r'Message.references',
      ),
      sender: _$map[r'sender'].decodeJsonString(context: r'Message.sender'),
      senderName: _$map[r'sender_name'].decodeJsonString(
        context: r'Message.sender_name',
      ),
      sizeBytes: _$map[r'size_bytes'].decodeJsonInt(
        context: r'Message.size_bytes',
      ),
      subject: _$map[r'subject'].decodeJsonString(context: r'Message.subject'),
      threadId: _$map[r'thread_id'].decodeJsonString(
        context: r'Message.thread_id',
      ),
      tlsVersion: _$map[r'tls_version'].decodeJsonNullableString(
        context: r'Message.tls_version',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Message.updated_at',
      ),
    );
  }

  factory Message.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Message: contains complex types',
    );
  }

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i3.Object? calendarEvents;

  final _i3.DateTime createdAt;

  final _i3.DateTime? dateHeader;

  final _i3.String folder;

  final _i3.bool hasAttachments;

  final _i3.Object? headers;

  final _i3.int id;

  final _i3.String inReplyTo;

  final _i3.bool? isAnswered;

  final _i3.bool isDeleted;

  final _i3.bool isDraft;

  final _i3.bool isDsn;

  final _i3.bool isFlagged;

  final _i3.bool isRead;

  final _i3.bool isStarred;

  final _i4.MessageMailboxOneOfModel? mailbox;

  final _i3.int mailboxId;

  final _i3.String messageId;

  final _i3.int rawSize;

  final _i3.DateTime receivedAt;

  final _i3.bool? receivedTls;

  final _i3.Object? recipientsCc;

  final _i3.Object? recipientsTo;

  final _i3.String references;

  final _i3.String sender;

  final _i3.String senderName;

  final _i3.int sizeBytes;

  final _i3.String subject;

  final _i3.String threadId;

  final _i3.String? tlsVersion;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (calendarEvents != null)
      r'calendar_events': _i1.encodeUnknownJson(
        calendarEvents,
        context: r'Message.calendar_events',
      ),
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'date_header': dateHeader?.toTimeZonedIso8601String(),
    r'folder': folder,
    r'has_attachments': hasAttachments,
    if (headers != null)
      r'headers': _i1.encodeUnknownJson(headers, context: r'Message.headers'),
    r'id': id,
    r'in_reply_to': inReplyTo,
    if (isAnswered != null) r'is_answered': isAnswered,
    r'is_deleted': isDeleted,
    r'is_draft': isDraft,
    r'is_dsn': isDsn,
    r'is_flagged': isFlagged,
    r'is_read': isRead,
    r'is_starred': isStarred,
    if (mailbox != null) r'mailbox': mailbox?.toJson(),
    r'mailbox_id': mailboxId,
    r'message_id': messageId,
    r'raw_size': rawSize,
    r'received_at': receivedAt.toTimeZonedIso8601String(),
    r'received_tls': receivedTls,
    r'recipients_cc': _i1.encodeUnknownJson(
      recipientsCc,
      context: r'Message.recipients_cc',
    ),
    r'recipients_to': _i1.encodeUnknownJson(
      recipientsTo,
      context: r'Message.recipients_to',
    ),
    r'references': references,
    r'sender': sender,
    r'sender_name': senderName,
    r'size_bytes': sizeBytes,
    r'subject': subject,
    r'thread_id': threadId,
    if (tlsVersion != null) r'tls_version': tlsVersion,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$MessageCopyWith<Message> get copyWith => _MessageCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Message &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        other.calendarEvents == this.calendarEvents &&
        other.createdAt == this.createdAt &&
        other.dateHeader == this.dateHeader &&
        other.folder == this.folder &&
        other.hasAttachments == this.hasAttachments &&
        other.headers == this.headers &&
        other.id == this.id &&
        other.inReplyTo == this.inReplyTo &&
        other.isAnswered == this.isAnswered &&
        other.isDeleted == this.isDeleted &&
        other.isDraft == this.isDraft &&
        other.isDsn == this.isDsn &&
        other.isFlagged == this.isFlagged &&
        other.isRead == this.isRead &&
        other.isStarred == this.isStarred &&
        other.mailbox == this.mailbox &&
        other.mailboxId == this.mailboxId &&
        other.messageId == this.messageId &&
        other.rawSize == this.rawSize &&
        other.receivedAt == this.receivedAt &&
        other.receivedTls == this.receivedTls &&
        other.recipientsCc == this.recipientsCc &&
        other.recipientsTo == this.recipientsTo &&
        other.references == this.references &&
        other.sender == this.sender &&
        other.senderName == this.senderName &&
        other.sizeBytes == this.sizeBytes &&
        other.subject == this.subject &&
        other.threadId == this.threadId &&
        other.tlsVersion == this.tlsVersion &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      bodyHtml,
      bodyText,
      calendarEvents,
      createdAt,
      dateHeader,
      folder,
      hasAttachments,
      headers,
      id,
      inReplyTo,
      isAnswered,
      isDeleted,
      isDraft,
      isDsn,
      isFlagged,
      isRead,
      isStarred,
      mailbox,
      mailboxId,
      messageId,
      rawSize,
      receivedAt,
      receivedTls,
      recipientsCc,
      recipientsTo,
      references,
      sender,
      senderName,
      sizeBytes,
      subject,
      threadId,
      tlsVersion,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Message: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Message: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MessageCopyWith<$Res> {
  factory $$MessageCopyWith(Message value) = _MessageCopyWith<$Res>;

  $Res call({
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i3.Object? calendarEvents,
    _i3.DateTime? createdAt,
    _i3.DateTime? dateHeader,
    _i3.String? folder,
    _i3.bool? hasAttachments,
    _i3.Object? headers,
    _i3.int? id,
    _i3.String? inReplyTo,
    _i3.bool? isAnswered,
    _i3.bool? isDeleted,
    _i3.bool? isDraft,
    _i3.bool? isDsn,
    _i3.bool? isFlagged,
    _i3.bool? isRead,
    _i3.bool? isStarred,
    _i4.MessageMailboxOneOfModel? mailbox,
    _i3.int? mailboxId,
    _i3.String? messageId,
    _i3.int? rawSize,
    _i3.DateTime? receivedAt,
    _i3.bool? receivedTls,
    _i3.Object? recipientsCc,
    _i3.Object? recipientsTo,
    _i3.String? references,
    _i3.String? sender,
    _i3.String? senderName,
    _i3.int? sizeBytes,
    _i3.String? subject,
    _i3.String? threadId,
    _i3.String? tlsVersion,
    _i3.DateTime? updatedAt,
  });
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i3.Object? get calendarEvents;
  _i3.DateTime get createdAt;
  _i3.DateTime? get dateHeader;
  _i3.String get folder;
  _i3.bool get hasAttachments;
  _i3.Object? get headers;
  _i3.int get id;
  _i3.String get inReplyTo;
  _i3.bool? get isAnswered;
  _i3.bool get isDeleted;
  _i3.bool get isDraft;
  _i3.bool get isDsn;
  _i3.bool get isFlagged;
  _i3.bool get isRead;
  _i3.bool get isStarred;
  _i4.MessageMailboxOneOfModel? get mailbox;
  _i3.int get mailboxId;
  _i3.String get messageId;
  _i3.int get rawSize;
  _i3.DateTime get receivedAt;
  _i3.bool? get receivedTls;
  _i3.Object? get recipientsCc;
  _i3.Object? get recipientsTo;
  _i3.String get references;
  _i3.String get sender;
  _i3.String get senderName;
  _i3.int get sizeBytes;
  _i3.String get subject;
  _i3.String get threadId;
  _i3.String? get tlsVersion;
  _i3.DateTime get updatedAt;
}

class _MessageCopyWith<$Res> implements $$MessageCopyWith<$Res> {
  _MessageCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Message _value;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i3.Object? get calendarEvents => _value.calendarEvents;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.DateTime? get dateHeader => _value.dateHeader;

  @_i3.override
  _i3.String get folder => _value.folder;

  @_i3.override
  _i3.bool get hasAttachments => _value.hasAttachments;

  @_i3.override
  _i3.Object? get headers => _value.headers;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i3.bool? get isAnswered => _value.isAnswered;

  @_i3.override
  _i3.bool get isDeleted => _value.isDeleted;

  @_i3.override
  _i3.bool get isDraft => _value.isDraft;

  @_i3.override
  _i3.bool get isDsn => _value.isDsn;

  @_i3.override
  _i3.bool get isFlagged => _value.isFlagged;

  @_i3.override
  _i3.bool get isRead => _value.isRead;

  @_i3.override
  _i3.bool get isStarred => _value.isStarred;

  @_i3.override
  _i4.MessageMailboxOneOfModel? get mailbox => _value.mailbox;

  @_i3.override
  _i3.int get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.String get messageId => _value.messageId;

  @_i3.override
  _i3.int get rawSize => _value.rawSize;

  @_i3.override
  _i3.DateTime get receivedAt => _value.receivedAt;

  @_i3.override
  _i3.bool? get receivedTls => _value.receivedTls;

  @_i3.override
  _i3.Object? get recipientsCc => _value.recipientsCc;

  @_i3.override
  _i3.Object? get recipientsTo => _value.recipientsTo;

  @_i3.override
  _i3.String get references => _value.references;

  @_i3.override
  _i3.String get sender => _value.sender;

  @_i3.override
  _i3.String get senderName => _value.senderName;

  @_i3.override
  _i3.int get sizeBytes => _value.sizeBytes;

  @_i3.override
  _i3.String get subject => _value.subject;

  @_i3.override
  _i3.String get threadId => _value.threadId;

  @_i3.override
  _i3.String? get tlsVersion => _value.tlsVersion;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? bodyHtml = _sentinel,
    _i3.Object? bodyText = _sentinel,
    _i3.Object? calendarEvents = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? dateHeader = _sentinel,
    _i3.Object? folder = _sentinel,
    _i3.Object? hasAttachments = _sentinel,
    _i3.Object? headers = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? isAnswered = _sentinel,
    _i3.Object? isDeleted = _sentinel,
    _i3.Object? isDraft = _sentinel,
    _i3.Object? isDsn = _sentinel,
    _i3.Object? isFlagged = _sentinel,
    _i3.Object? isRead = _sentinel,
    _i3.Object? isStarred = _sentinel,
    _i3.Object? mailbox = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? rawSize = _sentinel,
    _i3.Object? receivedAt = _sentinel,
    _i3.Object? receivedTls = _sentinel,
    _i3.Object? recipientsCc = _sentinel,
    _i3.Object? recipientsTo = _sentinel,
    _i3.Object? references = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? senderName = _sentinel,
    _i3.Object? sizeBytes = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? threadId = _sentinel,
    _i3.Object? tlsVersion = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Message(
      bodyHtml: _i3.identical(bodyHtml, _sentinel)
          ? this.bodyHtml
          : (bodyHtml as _i3.String?),
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      calendarEvents: _i3.identical(calendarEvents, _sentinel)
          ? this.calendarEvents
          : calendarEvents,
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      dateHeader: _i3.identical(dateHeader, _sentinel)
          ? this.dateHeader
          : (dateHeader as _i3.DateTime?),
      folder: _i3.identical(folder, _sentinel)
          ? this.folder
          : (folder as _i3.String),
      hasAttachments: _i3.identical(hasAttachments, _sentinel)
          ? this.hasAttachments
          : (hasAttachments as _i3.bool),
      headers: _i3.identical(headers, _sentinel) ? this.headers : headers,
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String),
      isAnswered: _i3.identical(isAnswered, _sentinel)
          ? this.isAnswered
          : (isAnswered as _i3.bool?),
      isDeleted: _i3.identical(isDeleted, _sentinel)
          ? this.isDeleted
          : (isDeleted as _i3.bool),
      isDraft: _i3.identical(isDraft, _sentinel)
          ? this.isDraft
          : (isDraft as _i3.bool),
      isDsn: _i3.identical(isDsn, _sentinel) ? this.isDsn : (isDsn as _i3.bool),
      isFlagged: _i3.identical(isFlagged, _sentinel)
          ? this.isFlagged
          : (isFlagged as _i3.bool),
      isRead: _i3.identical(isRead, _sentinel)
          ? this.isRead
          : (isRead as _i3.bool),
      isStarred: _i3.identical(isStarred, _sentinel)
          ? this.isStarred
          : (isStarred as _i3.bool),
      mailbox: _i3.identical(mailbox, _sentinel)
          ? this.mailbox
          : (mailbox as _i4.MessageMailboxOneOfModel?),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String),
      rawSize: _i3.identical(rawSize, _sentinel)
          ? this.rawSize
          : (rawSize as _i3.int),
      receivedAt: _i3.identical(receivedAt, _sentinel)
          ? this.receivedAt
          : (receivedAt as _i3.DateTime),
      receivedTls: _i3.identical(receivedTls, _sentinel)
          ? this.receivedTls
          : (receivedTls as _i3.bool?),
      recipientsCc: _i3.identical(recipientsCc, _sentinel)
          ? this.recipientsCc
          : recipientsCc,
      recipientsTo: _i3.identical(recipientsTo, _sentinel)
          ? this.recipientsTo
          : recipientsTo,
      references: _i3.identical(references, _sentinel)
          ? this.references
          : (references as _i3.String),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String),
      senderName: _i3.identical(senderName, _sentinel)
          ? this.senderName
          : (senderName as _i3.String),
      sizeBytes: _i3.identical(sizeBytes, _sentinel)
          ? this.sizeBytes
          : (sizeBytes as _i3.int),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String),
      threadId: _i3.identical(threadId, _sentinel)
          ? this.threadId
          : (threadId as _i3.String),
      tlsVersion: _i3.identical(tlsVersion, _sentinel)
          ? this.tlsVersion
          : (tlsVersion as _i3.String?),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
