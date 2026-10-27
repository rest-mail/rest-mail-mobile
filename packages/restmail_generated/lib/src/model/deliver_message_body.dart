// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DeliverMessageBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DeliverMessageBody({
    this.address,
    this.bodyHtml,
    this.bodyText,
    this.clientIp,
    this.folder,
    this.heloName,
    this.inReplyTo,
    this.isAnswered,
    this.isDraft,
    this.isFlagged,
    this.isRead,
    this.isStarred,
    this.mailboxId,
    this.messageId,
    this.rawMessage,
    this.receivedAt,
    this.receivedTls,
    this.recipientsCc,
    this.recipientsTo,
    this.references,
    this.requireTls,
    this.sender,
    this.senderName,
    this.subject,
    this.tlsCipher,
    this.tlsVersion,
  });

  factory DeliverMessageBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'address',
        r'body_html',
        r'body_text',
        r'client_ip',
        r'folder',
        r'helo_name',
        r'in_reply_to',
        r'is_answered',
        r'is_draft',
        r'is_flagged',
        r'is_read',
        r'is_starred',
        r'mailbox_id',
        r'message_id',
        r'raw_message',
        r'received_at',
        r'received_tls',
        r'recipients_cc',
        r'recipients_to',
        r'references',
        r'require_tls',
        r'sender',
        r'sender_name',
        r'subject',
        r'tls_cipher',
        r'tls_version',
      },
      listKeys: {},
      context: r'DeliverMessageBody',
    );
    return DeliverMessageBody(
      address: _$values[r'address'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.address',
      ),
      bodyHtml: _$values[r'body_html'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.body_text',
      ),
      clientIp: _$values[r'client_ip'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.client_ip',
      ),
      folder: _$values[r'folder'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.folder',
      ),
      heloName: _$values[r'helo_name'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.helo_name',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.in_reply_to',
      ),
      isAnswered: _$values[r'is_answered'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.is_answered',
      ),
      isDraft: _$values[r'is_draft'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.is_draft',
      ),
      isFlagged: _$values[r'is_flagged'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.is_flagged',
      ),
      isRead: _$values[r'is_read'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.is_read',
      ),
      isStarred: _$values[r'is_starred'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.is_starred',
      ),
      mailboxId: _$values[r'mailbox_id'].decodeSimpleNullableInt(
        context: r'DeliverMessageBody.mailbox_id',
      ),
      messageId: _$values[r'message_id'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.message_id',
      ),
      rawMessage: _$values[r'raw_message'] == null
          ? null
          : _i1.TonikFileBytes(
              _$values[r'raw_message'].decodeSimpleBase64(
                context: r'DeliverMessageBody.raw_message',
              ),
            ),
      receivedAt: _$values[r'received_at'].decodeSimpleNullableDateTime(
        context: r'DeliverMessageBody.received_at',
      ),
      receivedTls: _$values[r'received_tls'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.received_tls',
      ),
      recipientsCc: _$values[r'recipients_cc'],
      recipientsTo: _$values[r'recipients_to'],
      references: _$values[r'references'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.references',
      ),
      requireTls: _$values[r'require_tls'].decodeSimpleNullableBool(
        context: r'DeliverMessageBody.require_tls',
      ),
      sender: _$values[r'sender'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.sender',
      ),
      senderName: _$values[r'sender_name'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.sender_name',
      ),
      subject: _$values[r'subject'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.subject',
      ),
      tlsCipher: _$values[r'tls_cipher'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.tls_cipher',
      ),
      tlsVersion: _$values[r'tls_version'].decodeSimpleNullableString(
        context: r'DeliverMessageBody.tls_version',
      ),
    );
  }

  factory DeliverMessageBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DeliverMessageBody');
    return DeliverMessageBody(
      address: _$map[r'address'].decodeJsonNullableString(
        context: r'DeliverMessageBody.address',
      ),
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'DeliverMessageBody.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'DeliverMessageBody.body_text',
      ),
      clientIp: _$map[r'client_ip'].decodeJsonNullableString(
        context: r'DeliverMessageBody.client_ip',
      ),
      folder: _$map[r'folder'].decodeJsonNullableString(
        context: r'DeliverMessageBody.folder',
      ),
      heloName: _$map[r'helo_name'].decodeJsonNullableString(
        context: r'DeliverMessageBody.helo_name',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'DeliverMessageBody.in_reply_to',
      ),
      isAnswered: _$map[r'is_answered'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.is_answered',
      ),
      isDraft: _$map[r'is_draft'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.is_draft',
      ),
      isFlagged: _$map[r'is_flagged'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.is_flagged',
      ),
      isRead: _$map[r'is_read'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.is_read',
      ),
      isStarred: _$map[r'is_starred'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.is_starred',
      ),
      mailboxId: _$map[r'mailbox_id'].decodeJsonNullableInt(
        context: r'DeliverMessageBody.mailbox_id',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableString(
        context: r'DeliverMessageBody.message_id',
      ),
      rawMessage: _$map[r'raw_message'] == null
          ? null
          : _i1.TonikFileBytes(
              _$map[r'raw_message'].decodeJsonBase64(
                context: r'DeliverMessageBody.raw_message',
              ),
            ),
      receivedAt: _$map[r'received_at'].decodeJsonNullableDateTime(
        context: r'DeliverMessageBody.received_at',
      ),
      receivedTls: _$map[r'received_tls'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.received_tls',
      ),
      recipientsCc: _$map[r'recipients_cc'],
      recipientsTo: _$map[r'recipients_to'],
      references: _$map[r'references'].decodeJsonNullableString(
        context: r'DeliverMessageBody.references',
      ),
      requireTls: _$map[r'require_tls'].decodeJsonNullableBool(
        context: r'DeliverMessageBody.require_tls',
      ),
      sender: _$map[r'sender'].decodeJsonNullableString(
        context: r'DeliverMessageBody.sender',
      ),
      senderName: _$map[r'sender_name'].decodeJsonNullableString(
        context: r'DeliverMessageBody.sender_name',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'DeliverMessageBody.subject',
      ),
      tlsCipher: _$map[r'tls_cipher'].decodeJsonNullableString(
        context: r'DeliverMessageBody.tls_cipher',
      ),
      tlsVersion: _$map[r'tls_version'].decodeJsonNullableString(
        context: r'DeliverMessageBody.tls_version',
      ),
    );
  }

  factory DeliverMessageBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'address',
        r'body_html',
        r'body_text',
        r'client_ip',
        r'folder',
        r'helo_name',
        r'in_reply_to',
        r'is_answered',
        r'is_draft',
        r'is_flagged',
        r'is_read',
        r'is_starred',
        r'mailbox_id',
        r'message_id',
        r'raw_message',
        r'received_at',
        r'received_tls',
        r'recipients_cc',
        r'recipients_to',
        r'references',
        r'require_tls',
        r'sender',
        r'sender_name',
        r'subject',
        r'tls_cipher',
        r'tls_version',
      },
      listKeys: {},
      context: r'DeliverMessageBody',
    );
    return DeliverMessageBody(
      address: _$values[r'address'].decodeFormNullableString(
        context: r'DeliverMessageBody.address',
      ),
      bodyHtml: _$values[r'body_html'].decodeFormNullableString(
        context: r'DeliverMessageBody.body_html',
      ),
      bodyText: _$values[r'body_text'].decodeFormNullableString(
        context: r'DeliverMessageBody.body_text',
      ),
      clientIp: _$values[r'client_ip'].decodeFormNullableString(
        context: r'DeliverMessageBody.client_ip',
      ),
      folder: _$values[r'folder'].decodeFormNullableString(
        context: r'DeliverMessageBody.folder',
      ),
      heloName: _$values[r'helo_name'].decodeFormNullableString(
        context: r'DeliverMessageBody.helo_name',
      ),
      inReplyTo: _$values[r'in_reply_to'].decodeFormNullableString(
        context: r'DeliverMessageBody.in_reply_to',
      ),
      isAnswered: _$values[r'is_answered'].decodeFormNullableBool(
        context: r'DeliverMessageBody.is_answered',
      ),
      isDraft: _$values[r'is_draft'].decodeFormNullableBool(
        context: r'DeliverMessageBody.is_draft',
      ),
      isFlagged: _$values[r'is_flagged'].decodeFormNullableBool(
        context: r'DeliverMessageBody.is_flagged',
      ),
      isRead: _$values[r'is_read'].decodeFormNullableBool(
        context: r'DeliverMessageBody.is_read',
      ),
      isStarred: _$values[r'is_starred'].decodeFormNullableBool(
        context: r'DeliverMessageBody.is_starred',
      ),
      mailboxId: _$values[r'mailbox_id'].decodeFormNullableInt(
        context: r'DeliverMessageBody.mailbox_id',
      ),
      messageId: _$values[r'message_id'].decodeFormNullableString(
        context: r'DeliverMessageBody.message_id',
      ),
      rawMessage: _$values[r'raw_message'] == null
          ? null
          : _i1.TonikFileBytes(
              _$values[r'raw_message'].decodeFormBase64(
                context: r'DeliverMessageBody.raw_message',
              ),
            ),
      receivedAt: _$values[r'received_at'].decodeFormNullableDateTime(
        context: r'DeliverMessageBody.received_at',
      ),
      receivedTls: _$values[r'received_tls'].decodeFormNullableBool(
        context: r'DeliverMessageBody.received_tls',
      ),
      recipientsCc: _$values[r'recipients_cc'].decodeFormNullableString(
        context: r'DeliverMessageBody.recipients_cc',
      ),
      recipientsTo: _$values[r'recipients_to'].decodeFormNullableString(
        context: r'DeliverMessageBody.recipients_to',
      ),
      references: _$values[r'references'].decodeFormNullableString(
        context: r'DeliverMessageBody.references',
      ),
      requireTls: _$values[r'require_tls'].decodeFormNullableBool(
        context: r'DeliverMessageBody.require_tls',
      ),
      sender: _$values[r'sender'].decodeFormNullableString(
        context: r'DeliverMessageBody.sender',
      ),
      senderName: _$values[r'sender_name'].decodeFormNullableString(
        context: r'DeliverMessageBody.sender_name',
      ),
      subject: _$values[r'subject'].decodeFormNullableString(
        context: r'DeliverMessageBody.subject',
      ),
      tlsCipher: _$values[r'tls_cipher'].decodeFormNullableString(
        context: r'DeliverMessageBody.tls_cipher',
      ),
      tlsVersion: _$values[r'tls_version'].decodeFormNullableString(
        context: r'DeliverMessageBody.tls_version',
      ),
    );
  }

  final _i3.String? address;

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i3.String? clientIp;

  final _i3.String? folder;

  final _i3.String? heloName;

  final _i3.String? inReplyTo;

  final _i3.bool? isAnswered;

  final _i3.bool? isDraft;

  final _i3.bool? isFlagged;

  final _i3.bool? isRead;

  final _i3.bool? isStarred;

  final _i3.int? mailboxId;

  final _i3.String? messageId;

  final _i1.TonikFile? rawMessage;

  final _i3.DateTime? receivedAt;

  final _i3.bool? receivedTls;

  final _i3.Object? recipientsCc;

  final _i3.Object? recipientsTo;

  final _i3.String? references;

  final _i3.bool? requireTls;

  final _i3.String? sender;

  final _i3.String? senderName;

  final _i3.String? subject;

  final _i3.String? tlsCipher;

  final _i3.String? tlsVersion;

  @_i3.override
  _i3.Object? toJson() => {
    if (address != null) r'address': address,
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (clientIp != null) r'client_ip': clientIp,
    if (folder != null) r'folder': folder,
    if (heloName != null) r'helo_name': heloName,
    if (inReplyTo != null) r'in_reply_to': inReplyTo,
    r'is_answered': isAnswered,
    r'is_draft': isDraft,
    r'is_flagged': isFlagged,
    r'is_read': isRead,
    r'is_starred': isStarred,
    if (mailboxId != null) r'mailbox_id': mailboxId,
    if (messageId != null) r'message_id': messageId,
    if (rawMessage != null)
      r'raw_message': rawMessage?.toBytes().encodeToBase64String(),
    r'received_at': receivedAt?.toTimeZonedIso8601String(),
    r'received_tls': receivedTls,
    if (recipientsCc != null)
      r'recipients_cc': _i1.encodeUnknownJson(
        recipientsCc,
        context: r'DeliverMessageBody.recipients_cc',
      ),
    if (recipientsTo != null)
      r'recipients_to': _i1.encodeUnknownJson(
        recipientsTo,
        context: r'DeliverMessageBody.recipients_to',
      ),
    if (references != null) r'references': references,
    if (requireTls != null) r'require_tls': requireTls,
    if (sender != null) r'sender': sender,
    if (senderName != null) r'sender_name': senderName,
    if (subject != null) r'subject': subject,
    if (tlsCipher != null) r'tls_cipher': tlsCipher,
    if (tlsVersion != null) r'tls_version': tlsVersion,
  };

  $$DeliverMessageBodyCopyWith<DeliverMessageBody> get copyWith =>
      _DeliverMessageBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeliverMessageBody &&
        other.address == this.address &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        other.clientIp == this.clientIp &&
        other.folder == this.folder &&
        other.heloName == this.heloName &&
        other.inReplyTo == this.inReplyTo &&
        other.isAnswered == this.isAnswered &&
        other.isDraft == this.isDraft &&
        other.isFlagged == this.isFlagged &&
        other.isRead == this.isRead &&
        other.isStarred == this.isStarred &&
        other.mailboxId == this.mailboxId &&
        other.messageId == this.messageId &&
        other.rawMessage == this.rawMessage &&
        other.receivedAt == this.receivedAt &&
        other.receivedTls == this.receivedTls &&
        other.recipientsCc == this.recipientsCc &&
        other.recipientsTo == this.recipientsTo &&
        other.references == this.references &&
        other.requireTls == this.requireTls &&
        other.sender == this.sender &&
        other.senderName == this.senderName &&
        other.subject == this.subject &&
        other.tlsCipher == this.tlsCipher &&
        other.tlsVersion == this.tlsVersion;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      address,
      bodyHtml,
      bodyText,
      clientIp,
      folder,
      heloName,
      inReplyTo,
      isAnswered,
      isDraft,
      isFlagged,
      isRead,
      isStarred,
      mailboxId,
      messageId,
      rawMessage,
      receivedAt,
      receivedTls,
      recipientsCc,
      recipientsTo,
      references,
      requireTls,
      sender,
      senderName,
      subject,
      tlsCipher,
      tlsVersion,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (address != null) {
      _$result[r'address'] = _i1.PropertyValue.scalar(address!);
    }
    if (bodyHtml != null) {
      _$result[r'body_html'] = _i1.PropertyValue.scalar(bodyHtml!);
    }
    if (bodyText != null) {
      _$result[r'body_text'] = _i1.PropertyValue.scalar(bodyText!);
    }
    if (clientIp != null) {
      _$result[r'client_ip'] = _i1.PropertyValue.scalar(clientIp!);
    }
    if (folder != null) {
      _$result[r'folder'] = _i1.PropertyValue.scalar(folder!);
    }
    if (heloName != null) {
      _$result[r'helo_name'] = _i1.PropertyValue.scalar(heloName!);
    }
    if (inReplyTo != null) {
      _$result[r'in_reply_to'] = _i1.PropertyValue.scalar(inReplyTo!);
    }
    if (isAnswered != null) {
      _$result[r'is_answered'] = _i1.PropertyValue.scalar(
        isAnswered!.toString(),
      );
    }
    if (isDraft != null) {
      _$result[r'is_draft'] = _i1.PropertyValue.scalar(isDraft!.toString());
    }
    if (isFlagged != null) {
      _$result[r'is_flagged'] = _i1.PropertyValue.scalar(isFlagged!.toString());
    }
    if (isRead != null) {
      _$result[r'is_read'] = _i1.PropertyValue.scalar(isRead!.toString());
    }
    if (isStarred != null) {
      _$result[r'is_starred'] = _i1.PropertyValue.scalar(isStarred!.toString());
    }
    if (mailboxId != null) {
      _$result[r'mailbox_id'] = _i1.PropertyValue.scalar(mailboxId!.toString());
    }
    if (messageId != null) {
      _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId!);
    }
    if (rawMessage != null) {
      _$result[r'raw_message'] = _i1.PropertyValue.scalar(
        rawMessage!.toBase64String(),
      );
    }
    if (receivedAt != null) {
      _$result[r'received_at'] = _i1.PropertyValue.scalar(
        receivedAt!.toTimeZonedIso8601String(),
      );
    }
    if (receivedTls != null) {
      _$result[r'received_tls'] = _i1.PropertyValue.scalar(
        receivedTls!.toString(),
      );
    }
    if (recipientsCc != null) {
      _$result[r'recipients_cc'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          recipientsCc!,
          context: r'DeliverMessageBody.recipients_cc',
        ),
      );
    }
    if (recipientsTo != null) {
      _$result[r'recipients_to'] = _i1.PropertyValue.scalar(
        _i1.encodeUnknownFlatScalar(
          recipientsTo!,
          context: r'DeliverMessageBody.recipients_to',
        ),
      );
    }
    if (references != null) {
      _$result[r'references'] = _i1.PropertyValue.scalar(references!);
    }
    if (requireTls != null) {
      _$result[r'require_tls'] = _i1.PropertyValue.scalar(
        requireTls!.toString(),
      );
    }
    if (sender != null) {
      _$result[r'sender'] = _i1.PropertyValue.scalar(sender!);
    }
    if (senderName != null) {
      _$result[r'sender_name'] = _i1.PropertyValue.scalar(senderName!);
    }
    if (subject != null) {
      _$result[r'subject'] = _i1.PropertyValue.scalar(subject!);
    }
    if (tlsCipher != null) {
      _$result[r'tls_cipher'] = _i1.PropertyValue.scalar(tlsCipher!);
    }
    if (tlsVersion != null) {
      _$result[r'tls_version'] = _i1.PropertyValue.scalar(tlsVersion!);
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
      r'Cannot uriEncode DeliverMessageBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DeliverMessageBodyCopyWith<$Res> {
  factory $$DeliverMessageBodyCopyWith(DeliverMessageBody value) =
      _DeliverMessageBodyCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i3.String? clientIp,
    _i3.String? folder,
    _i3.String? heloName,
    _i3.String? inReplyTo,
    _i3.bool? isAnswered,
    _i3.bool? isDraft,
    _i3.bool? isFlagged,
    _i3.bool? isRead,
    _i3.bool? isStarred,
    _i3.int? mailboxId,
    _i3.String? messageId,
    _i1.TonikFile? rawMessage,
    _i3.DateTime? receivedAt,
    _i3.bool? receivedTls,
    _i3.Object? recipientsCc,
    _i3.Object? recipientsTo,
    _i3.String? references,
    _i3.bool? requireTls,
    _i3.String? sender,
    _i3.String? senderName,
    _i3.String? subject,
    _i3.String? tlsCipher,
    _i3.String? tlsVersion,
  });
  _i3.String? get address;
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i3.String? get clientIp;
  _i3.String? get folder;
  _i3.String? get heloName;
  _i3.String? get inReplyTo;
  _i3.bool? get isAnswered;
  _i3.bool? get isDraft;
  _i3.bool? get isFlagged;
  _i3.bool? get isRead;
  _i3.bool? get isStarred;
  _i3.int? get mailboxId;
  _i3.String? get messageId;
  _i1.TonikFile? get rawMessage;
  _i3.DateTime? get receivedAt;
  _i3.bool? get receivedTls;
  _i3.Object? get recipientsCc;
  _i3.Object? get recipientsTo;
  _i3.String? get references;
  _i3.bool? get requireTls;
  _i3.String? get sender;
  _i3.String? get senderName;
  _i3.String? get subject;
  _i3.String? get tlsCipher;
  _i3.String? get tlsVersion;
}

class _DeliverMessageBodyCopyWith<$Res>
    implements $$DeliverMessageBodyCopyWith<$Res> {
  _DeliverMessageBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DeliverMessageBody _value;

  @_i3.override
  _i3.String? get address => _value.address;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i3.String? get clientIp => _value.clientIp;

  @_i3.override
  _i3.String? get folder => _value.folder;

  @_i3.override
  _i3.String? get heloName => _value.heloName;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i3.bool? get isAnswered => _value.isAnswered;

  @_i3.override
  _i3.bool? get isDraft => _value.isDraft;

  @_i3.override
  _i3.bool? get isFlagged => _value.isFlagged;

  @_i3.override
  _i3.bool? get isRead => _value.isRead;

  @_i3.override
  _i3.bool? get isStarred => _value.isStarred;

  @_i3.override
  _i3.int? get mailboxId => _value.mailboxId;

  @_i3.override
  _i3.String? get messageId => _value.messageId;

  @_i3.override
  _i1.TonikFile? get rawMessage => _value.rawMessage;

  @_i3.override
  _i3.DateTime? get receivedAt => _value.receivedAt;

  @_i3.override
  _i3.bool? get receivedTls => _value.receivedTls;

  @_i3.override
  _i3.Object? get recipientsCc => _value.recipientsCc;

  @_i3.override
  _i3.Object? get recipientsTo => _value.recipientsTo;

  @_i3.override
  _i3.String? get references => _value.references;

  @_i3.override
  _i3.bool? get requireTls => _value.requireTls;

  @_i3.override
  _i3.String? get sender => _value.sender;

  @_i3.override
  _i3.String? get senderName => _value.senderName;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  _i3.String? get tlsCipher => _value.tlsCipher;

  @_i3.override
  _i3.String? get tlsVersion => _value.tlsVersion;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? bodyHtml = _sentinel,
    _i3.Object? bodyText = _sentinel,
    _i3.Object? clientIp = _sentinel,
    _i3.Object? folder = _sentinel,
    _i3.Object? heloName = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? isAnswered = _sentinel,
    _i3.Object? isDraft = _sentinel,
    _i3.Object? isFlagged = _sentinel,
    _i3.Object? isRead = _sentinel,
    _i3.Object? isStarred = _sentinel,
    _i3.Object? mailboxId = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? rawMessage = _sentinel,
    _i3.Object? receivedAt = _sentinel,
    _i3.Object? receivedTls = _sentinel,
    _i3.Object? recipientsCc = _sentinel,
    _i3.Object? recipientsTo = _sentinel,
    _i3.Object? references = _sentinel,
    _i3.Object? requireTls = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? senderName = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? tlsCipher = _sentinel,
    _i3.Object? tlsVersion = _sentinel,
  }) {
    return (DeliverMessageBody(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String?),
      bodyHtml: _i3.identical(bodyHtml, _sentinel)
          ? this.bodyHtml
          : (bodyHtml as _i3.String?),
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      clientIp: _i3.identical(clientIp, _sentinel)
          ? this.clientIp
          : (clientIp as _i3.String?),
      folder: _i3.identical(folder, _sentinel)
          ? this.folder
          : (folder as _i3.String?),
      heloName: _i3.identical(heloName, _sentinel)
          ? this.heloName
          : (heloName as _i3.String?),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      isAnswered: _i3.identical(isAnswered, _sentinel)
          ? this.isAnswered
          : (isAnswered as _i3.bool?),
      isDraft: _i3.identical(isDraft, _sentinel)
          ? this.isDraft
          : (isDraft as _i3.bool?),
      isFlagged: _i3.identical(isFlagged, _sentinel)
          ? this.isFlagged
          : (isFlagged as _i3.bool?),
      isRead: _i3.identical(isRead, _sentinel)
          ? this.isRead
          : (isRead as _i3.bool?),
      isStarred: _i3.identical(isStarred, _sentinel)
          ? this.isStarred
          : (isStarred as _i3.bool?),
      mailboxId: _i3.identical(mailboxId, _sentinel)
          ? this.mailboxId
          : (mailboxId as _i3.int?),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String?),
      rawMessage: _i3.identical(rawMessage, _sentinel)
          ? this.rawMessage
          : (rawMessage as _i1.TonikFile?),
      receivedAt: _i3.identical(receivedAt, _sentinel)
          ? this.receivedAt
          : (receivedAt as _i3.DateTime?),
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
          : (references as _i3.String?),
      requireTls: _i3.identical(requireTls, _sentinel)
          ? this.requireTls
          : (requireTls as _i3.bool?),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String?),
      senderName: _i3.identical(senderName, _sentinel)
          ? this.senderName
          : (senderName as _i3.String?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
      tlsCipher: _i3.identical(tlsCipher, _sentinel)
          ? this.tlsCipher
          : (tlsCipher as _i3.String?),
      tlsVersion: _i3.identical(tlsVersion, _sentinel)
          ? this.tlsVersion
          : (tlsVersion as _i3.String?),
    ) as $Res);
  }
}
