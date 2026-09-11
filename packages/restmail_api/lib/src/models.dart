import 'dart:convert';

import 'session.dart';

/// The person a session belongs to.
class User {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: _int(json['id']),
    email: json['email'] as String,
    displayName: json['display_name'] as String? ?? '',
  );

  final int id;
  final String email;
  final String displayName;

  Map<String, Object> toJson() => {
    'id': id,
    'email': email,
    'display_name': displayName,
  };
}

/// What a successful sign-in hands back.
class LoginResult {
  const LoginResult({required this.user, required this.tokens});

  final User user;
  final SessionTokens tokens;
}

/// A mailbox the signed-in user can read: the one they signed in with, plus
/// any linked to it.
class Account {
  const Account({
    required this.id,
    required this.mailboxId,
    required this.address,
    required this.displayName,
    required this.isPrimary,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: _int(json['id']),
    mailboxId: _int(json['mailbox_id']),
    address: json['address'] as String,
    displayName: json['display_name'] as String? ?? '',
    isPrimary: json['is_primary'] as bool? ?? false,
  );

  final int id;
  final int mailboxId;
  final String address;
  final String displayName;
  final bool isPrimary;

  String get label => displayName.isNotEmpty ? displayName : address;
}

/// The folders rest-mail creates for every mailbox.
abstract final class StandardFolder {
  static const inbox = 'INBOX';
  static const drafts = 'Drafts';
  static const sent = 'Sent';
  static const archive = 'Archive';
  static const spam = 'Spam';
  static const trash = 'Trash';

  /// The order a folder list shows them in, ahead of the user's own.
  static const ordered = [inbox, drafts, sent, archive, spam, trash];
}

class Folder {
  const Folder({required this.name, required this.total, required this.unread});

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
    name: json['name'] as String,
    total: _int(json['total'] ?? 0),
    unread: _int(json['unread'] ?? 0),
  );

  final String name;
  final int total;
  final int unread;
}

/// One address on a message's To or Cc line.
class Recipient {
  const Recipient(this.address, [this.name]);

  final String address;
  final String? name;

  String get displayName => name ?? address;

  /// The schema says an array of `{"address", "name"}` objects. The webmail
  /// also tolerates bare address strings and the array arriving JSON-encoded
  /// inside a string, so this does the same.
  static List<Recipient> listFromJson(Object? raw) {
    var value = raw;
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty) return const [];
      try {
        value = jsonDecode(text);
      } on FormatException {
        return [Recipient(text)];
      }
    }
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is String && item.isNotEmpty)
          Recipient(item)
        else if (item is Map<String, dynamic> && item['address'] is String)
          Recipient(item['address'] as String, _optionalString(item['name'])),
    ];
  }
}

class Message {
  const Message({
    required this.id,
    required this.mailboxId,
    required this.folder,
    required this.sender,
    required this.subject,
    required this.receivedAt,
    this.messageId,
    this.inReplyTo,
    this.references,
    this.threadId,
    this.senderName,
    this.to = const [],
    this.cc = const [],
    this.bodyText,
    this.bodyHtml,
    this.sizeBytes = 0,
    this.hasAttachments = false,
    this.isRead = false,
    this.isFlagged = false,
    this.isStarred = false,
    this.isDraft = false,
    this.dateHeader,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: _int(json['id']),
    mailboxId: _int(json['mailbox_id']),
    folder: json['folder'] as String,
    messageId: _optionalString(json['message_id']),
    inReplyTo: _optionalString(json['in_reply_to']),
    references: _optionalString(json['references']),
    threadId: _optionalString(json['thread_id']),
    sender: json['sender'] as String? ?? '',
    senderName: _optionalString(json['sender_name']),
    to: Recipient.listFromJson(json['recipients_to']),
    cc: Recipient.listFromJson(json['recipients_cc']),
    subject: json['subject'] as String? ?? '',
    bodyText: _optionalString(json['body_text']),
    bodyHtml: _optionalString(json['body_html']),
    sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
    hasAttachments: json['has_attachments'] as bool? ?? false,
    isRead: json['is_read'] as bool? ?? false,
    isFlagged: json['is_flagged'] as bool? ?? false,
    isStarred: json['is_starred'] as bool? ?? false,
    isDraft: json['is_draft'] as bool? ?? false,
    receivedAt: _time(json['received_at']),
    dateHeader: _optionalTime(json['date_header']),
  );

  final int id;
  final int mailboxId;
  final String folder;

  /// The RFC 5322 Message-ID, which a reply names in In-Reply-To.
  final String? messageId;
  final String? inReplyTo;
  final String? references;
  final String? threadId;
  final String sender;
  final String? senderName;
  final List<Recipient> to;
  final List<Recipient> cc;
  final String subject;
  final String? bodyText;
  final String? bodyHtml;
  final int sizeBytes;
  final bool hasAttachments;
  final bool isRead;
  final bool isFlagged;
  final bool isStarred;
  final bool isDraft;
  final DateTime receivedAt;
  final DateTime? dateHeader;

  /// When the message says it was written, else when it arrived.
  DateTime get date => dateHeader ?? receivedAt;

  String get senderLabel => senderName ?? sender;

  /// The start of the plain-text body on one line, for a list row.
  String get preview {
    final text = (bodyText ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length <= _previewLength
        ? text
        : text.substring(0, _previewLength);
  }

  static const _previewLength = 160;

  Message copyWith({
    bool? isRead,
    bool? isFlagged,
    bool? isStarred,
    String? folder,
  }) => Message(
    id: id,
    mailboxId: mailboxId,
    folder: folder ?? this.folder,
    messageId: messageId,
    inReplyTo: inReplyTo,
    references: references,
    threadId: threadId,
    sender: sender,
    senderName: senderName,
    to: to,
    cc: cc,
    subject: subject,
    bodyText: bodyText,
    bodyHtml: bodyHtml,
    sizeBytes: sizeBytes,
    hasAttachments: hasAttachments,
    isRead: isRead ?? this.isRead,
    isFlagged: isFlagged ?? this.isFlagged,
    isStarred: isStarred ?? this.isStarred,
    isDraft: isDraft,
    receivedAt: receivedAt,
    dateHeader: dateHeader,
  );
}

class Attachment {
  const Attachment({
    required this.id,
    required this.messageId,
    required this.filename,
    required this.contentType,
    required this.sizeBytes,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: _int(json['id']),
    messageId: _int(json['message_id']),
    filename: json['filename'] as String? ?? 'attachment',
    contentType: json['content_type'] as String? ?? 'application/octet-stream',
    sizeBytes: (json['size_bytes'] as num?)?.toInt() ?? 0,
  );

  final int id;
  final int messageId;
  final String filename;
  final String contentType;
  final int sizeBytes;
}

class QuotaInfo {
  const QuotaInfo({
    required this.quotaBytes,
    required this.usedBytes,
    required this.messageCount,
    required this.percentUsed,
  });

  factory QuotaInfo.fromJson(Map<String, dynamic> json) => QuotaInfo(
    quotaBytes: _int(json['quota_bytes']),
    usedBytes: _int(json['quota_used_bytes']),
    messageCount: _int(json['message_count']),
    percentUsed: (json['percent_used'] as num).toDouble(),
  );

  final int quotaBytes;
  final int usedBytes;
  final int messageCount;
  final double percentUsed;
}

/// One page of a cursor-paginated list.
class Paged<T> {
  const Paged(this.items, {this.cursor, this.hasMore = false, this.total});

  final List<T> items;

  /// Hand this back to fetch the next page.
  final String? cursor;
  final bool hasMore;
  final int? total;
}

/// A message to send, or to keep as a draft.
class OutgoingMessage {
  const OutgoingMessage({
    required this.from,
    this.to = const [],
    this.cc = const [],
    this.bcc = const [],
    this.subject = '',
    this.bodyText = '',
    this.bodyHtml,
    this.inReplyTo,
    this.references,
  });

  final String from;
  final List<String> to;
  final List<String> cc;

  /// Not kept on drafts: the draft endpoints have no Bcc field.
  final List<String> bcc;
  final String subject;
  final String bodyText;
  final String? bodyHtml;
  final String? inReplyTo;

  /// Kept on drafts only: the send endpoint takes In-Reply-To alone.
  final String? references;

  bool get isEmpty =>
      to.isEmpty &&
      cc.isEmpty &&
      bcc.isEmpty &&
      subject.trim().isEmpty &&
      bodyText.trim().isEmpty;

  Map<String, Object> toSendJson() => {
    'from': from,
    'to': to,
    if (cc.isNotEmpty) 'cc': cc,
    if (bcc.isNotEmpty) 'bcc': bcc,
    'subject': subject,
    'body_text': bodyText,
    'body_html': ?bodyHtml,
    'in_reply_to': ?inReplyTo,
  };

  Map<String, Object> toDraftJson() => {
    'from': from,
    'to': to,
    'cc': cc,
    'subject': subject,
    'body_text': bodyText,
    'body_html': ?bodyHtml,
    'in_reply_to': ?inReplyTo,
    'references': ?references,
  };
}

/// Filters for a mailbox search. Every field is optional; the server ANDs
/// whichever are given.
class SearchQuery {
  const SearchQuery({
    this.text,
    this.folder,
    this.from,
    this.after,
    this.before,
    this.hasAttachment = false,
  });

  final String? text;
  final String? folder;
  final String? from;
  final DateTime? after;
  final DateTime? before;
  final bool hasAttachment;

  Map<String, String> toQueryParameters() => {
    if (text?.trim() case final trimmed? when trimmed.isNotEmpty) 'q': trimmed,
    'folder': ?folder,
    'from': ?from,
    if (after case final after?) 'after': after.toUtc().toIso8601String(),
    if (before case final before?) 'before': before.toUtc().toIso8601String(),
    if (hasAttachment) 'has:attachment': 'true',
  };
}

int _int(Object? value) => (value as num).toInt();

String? _optionalString(Object? value) =>
    value is String && value.isNotEmpty ? value : null;

DateTime _time(Object? value) {
  if (value is String) {
    if (DateTime.tryParse(value) case final parsed?) return parsed.toLocal();
  }
  throw FormatException('Expected an RFC 3339 timestamp, got $value');
}

DateTime? _optionalTime(Object? value) => value is String && value.isNotEmpty
    ? DateTime.tryParse(value)?.toLocal()
    : null;
