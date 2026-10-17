import 'dart:convert';

/// A mailbox the fake hosts.
class FakeMailbox {
  FakeMailbox({
    required this.id,
    required this.address,
    required this.displayName,
    required this.password,
    this.totpCode,
    this.recoveryCode,
    this.quotaBytes = 5 * 1024 * 1024 * 1024,
  });

  final int id;
  final String address;

  /// An admin may change these.
  String displayName;
  String password;
  bool active = true;

  /// What its sessions may do on the admin API. None, as on today's server,
  /// where only admin users hold capabilities; rest-mail-server#347 has
  /// mailboxes hold grants instead.
  Set<String> capabilities = {};

  /// When set, signing in also needs this code or [recoveryCode].
  final String? totpCode;
  final String? recoveryCode;
  final int quotaBytes;

  String get domain => address.substring(address.indexOf('@') + 1);
}

/// A domain the fake serves.
class FakeDomain {
  FakeDomain({required this.id, required this.name, this.active = true});

  final int id;
  final String name;
  bool active;
}

/// Mail to [source] goes to [destination].
class FakeAlias {
  FakeAlias({
    required this.id,
    required this.source,
    required this.destination,
  });

  final int id;
  final String source;
  String destination;
  bool active = true;

  String get domain => source.substring(source.indexOf('@') + 1);
}

/// A message waiting in the outbound queue for another server to take it.
class FakeQueueEntry {
  FakeQueueEntry({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.status,
    required this.createdAt,
    this.attempts = 0,
    this.lastError = '',
    this.lastErrorCode = 0,
  });

  final int id;
  final String sender;
  final String recipient;

  /// `pending`, `deferred`, `delivered`, `bounced` or `expired`.
  String status;
  int attempts;
  String lastError;
  int lastErrorCode;
  final DateTime createdAt;

  String get domain => recipient.substring(recipient.indexOf('@') + 1);
}

class FakeRecipient {
  const FakeRecipient(this.address, [this.name]);

  final String address;
  final String? name;

  Map<String, Object> toJson() => {'address': address, 'name': name ?? ''};
}

class FakeAttachment {
  FakeAttachment({
    required this.filename,
    required this.contentType,
    required this.bytes,
  });

  /// Given by the fake when the message is stored.
  late final int id;
  late final int messageId;
  final String filename;
  final String contentType;
  final List<int> bytes;
}

/// One message as the fake stores it: changeable in place, as a server's row
/// is.
class FakeMessage {
  FakeMessage({
    required this.folder,
    required this.sender,
    required this.receivedAt,
    this.senderName,
    this.to = const [],
    this.cc = const [],
    this.subject = '',
    this.bodyText = '',
    this.bodyHtml,
    this.isRead = false,
    this.isFlagged = false,
    this.isDraft = false,
    this.inReplyTo,
    this.attachments = const [],
  });

  /// Given by the fake when the message is stored.
  late final int id;
  late final int mailboxId;
  String folder;
  String sender;
  String? senderName;
  List<FakeRecipient> to;
  List<FakeRecipient> cc;
  String subject;
  String bodyText;
  String? bodyHtml;
  DateTime receivedAt;
  bool isRead;
  bool isFlagged;
  bool isStarred = false;
  bool isDraft;
  String? inReplyTo;
  final List<FakeAttachment> attachments;

  String get messageId => '<$id@fake.restmail.test>';

  int get sizeBytes =>
      utf8.encode(bodyText).length +
      utf8.encode(bodyHtml ?? '').length +
      attachments.fold(0, (sum, a) => sum + a.bytes.length);

  /// The shape `GET /api/v1/messages/{id}` returns.
  Map<String, Object?> toJson() {
    final stamp = receivedAt.toUtc().toIso8601String();
    return {
      'id': id,
      'mailbox_id': mailboxId,
      'folder': folder,
      'message_id': messageId,
      'in_reply_to': inReplyTo ?? '',
      'references': '',
      'thread_id': '',
      'sender': sender,
      'sender_name': senderName ?? '',
      'recipients_to': [for (final r in to) r.toJson()],
      'recipients_cc': [for (final r in cc) r.toJson()],
      'subject': subject,
      'body_text': bodyText,
      'body_html': bodyHtml ?? '',
      'size_bytes': sizeBytes,
      'raw_size': 0,
      'has_attachments': attachments.isNotEmpty,
      'is_read': isRead,
      'is_flagged': isFlagged,
      'is_starred': isStarred,
      'is_draft': isDraft,
      'is_deleted': false,
      'received_at': stamp,
      'date_header': null,
      'created_at': stamp,
      'updated_at': stamp,
    };
  }
}
