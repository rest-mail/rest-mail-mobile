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
  const LoginResult({
    required this.user,
    required this.tokens,
    this.setupRequired = const [],
  });

  final User user;
  final SessionTokens tokens;

  /// What the account must still do before its session reaches anything
  /// else. A fresh install's bootstrap account starts with both steps.
  final List<SetupStep> setupRequired;

  bool get isSetUp => setupRequired.isEmpty;
}

/// The steps an account still owes before the server answers its session
/// anything else. While one is owed the session holds no capabilities.
enum SetupStep {
  /// Replace a password someone else chose: [RestmailClient.changePassword].
  password,

  /// Enroll an authenticator: [RestmailClient.enrollTwoFactor], then
  /// [RestmailClient.confirmTwoFactor].
  twoFactor;

  static List<SetupStep> fromJson(Object? json) => [
    for (final raw in json is List ? json : const [])
      ?switch (raw) {
        'password' => SetupStep.password,
        'two_factor' => SetupStep.twoFactor,
        _ => null,
      },
  ];
}

/// A started authenticator enrollment, to show once and then confirm.
class TotpEnrollment {
  const TotpEnrollment({
    required this.secret,
    required this.otpauthUri,
    required this.recoveryCodes,
  });

  factory TotpEnrollment.fromJson(Map<String, dynamic> json) => TotpEnrollment(
    secret: json['secret'] as String,
    otpauthUri: Uri.parse(json['otpauth_url'] as String),
    recoveryCodes: [
      for (final code in json['recovery_codes'] as List? ?? const [])
        if (code is String) code,
    ],
  );

  /// For typing into an authenticator by hand.
  final String secret;

  /// `otpauth://…`: opening it hands the account to an authenticator app.
  final Uri otpauthUri;

  /// Shown once. The only way back in if the authenticator is lost.
  final List<String> recoveryCodes;
}

/// An account the session reaches: its own, which it signed in with, and
/// every account it holds a mail grant on, the ones it created or linked. An
/// account is a mailbox, and [id] is the mailbox's id everywhere.
class Account {
  const Account({
    required this.id,
    required this.address,
    required this.displayName,
    required this.isPrimary,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: _int(json['id']),
    address: json['address'] as String,
    displayName: json['display_name'] as String? ?? '',
    isPrimary: json['is_primary'] as bool? ?? false,
  );

  final int id;
  final String address;
  final String displayName;
  final bool isPrimary;

  String get label => displayName.isNotEmpty ? displayName : address;
}

/// An app password, as its owner sees it: what a mail client or an
/// automation signs in to the mailbox with instead of the mailbox's own
/// password. The server never hands its secret back after making it.
class AppPassword {
  const AppPassword({
    required this.id,
    required this.name,
    required this.publicId,
    required this.createdAt,
    this.lastUsedAt,
    this.expiresAt,
  });

  factory AppPassword.fromJson(Map<String, dynamic> json) => AppPassword(
    id: _int(json['id']),
    name: json['name'] as String? ?? '',
    publicId: json['public_id'] as String? ?? '',
    createdAt: _time(json['created_at']),
    lastUsedAt: _optionalTime(json['last_used_at']),
    expiresAt: _optionalTime(json['expires_at']),
  );

  final int id;
  final String name;

  /// The part after `rm_` and before the secret, which names it in the
  /// server's audit log.
  final String publicId;
  final DateTime createdAt;

  /// To within a minute; null if it has never been used.
  final DateTime? lastUsedAt;

  /// Null if it never expires.
  final DateTime? expiresAt;

  bool isExpiredAt(DateTime now) => switch (expiresAt) {
    final expires? => !expires.isAfter(now),
    null => false,
  };
}

/// An app password just made, with its secret, which the server shows this
/// once. Show it, then [forget] it.
class NewAppPassword {
  NewAppPassword(this.appPassword, String secret) : _secret = secret;

  factory NewAppPassword.fromJson(Map<String, dynamic> json) {
    final secret = json['password'];
    if (secret is! String || secret.isEmpty) {
      throw const FormatException('The new app password has no secret');
    }
    return NewAppPassword(AppPassword.fromJson(json), secret);
  }

  final AppPassword appPassword;
  String? _secret;

  /// The app password itself, `rm_…`, until [forget].
  String? get secret => _secret;

  /// Lets go of the secret, so nothing that still holds this can reach it.
  void forget() => _secret = null;

  /// Never the secret, so it can't reach a log by accident.
  @override
  String toString() => 'NewAppPassword(${appPassword.publicId})';
}

/// One thing an API key may do: a capability, held only within [scope].
class APIKeyPermission {
  const APIKeyPermission({required this.capability, required this.scope});

  factory APIKeyPermission.fromJson(Map<String, dynamic> json) =>
      APIKeyPermission(
        capability: json['capability'] as String? ?? '',
        scope: json['scope'] as String? ?? '',
      );

  final String capability;
  final String scope;

  Map<String, dynamic> toJson() => {'capability': capability, 'scope': scope};

  @override
  bool operator ==(Object other) =>
      other is APIKeyPermission &&
      other.capability == capability &&
      other.scope == scope;

  @override
  int get hashCode => Object.hash(capability, scope);

  @override
  String toString() => 'APIKeyPermission($capability, $scope)';
}

/// An API key, as its owner sees it: never its token, which the server
/// shows once, when it makes it.
class APIKey {
  const APIKey({
    required this.id,
    required this.name,
    required this.kind,
    required this.publicId,
    required this.createdAt,
    this.lastUsedAt,
    this.expiresAt,
    required this.permissions,
  });

  factory APIKey.fromJson(Map<String, dynamic> json) => APIKey(
    id: _int(json['id']),
    name: json['name'] as String? ?? '',
    kind: json['kind'] as String? ?? '',
    publicId: json['public_id'] as String? ?? '',
    createdAt: _time(json['created_at']),
    lastUsedAt: _optionalTime(json['last_used_at']),
    expiresAt: _optionalTime(json['expires_at']),
    permissions: [
      for (final permission in json['permissions'] as List? ?? const [])
        APIKeyPermission.fromJson(permission as Map<String, dynamic>),
    ],
  );

  final int id;
  final String name;

  /// `api_key`.
  final String kind;

  /// Names the key in the server's audit log.
  final String publicId;
  final DateTime createdAt;

  /// Null if it has never been used.
  final DateTime? lastUsedAt;

  /// Null if it never expires.
  final DateTime? expiresAt;
  final List<APIKeyPermission> permissions;

  bool isExpiredAt(DateTime now) => switch (expiresAt) {
    final expires? => !expires.isAfter(now),
    null => false,
  };
}

/// An API key just made, with its token, which the server shows this once.
class CreatedAPIKey {
  const CreatedAPIKey({required this.key, required this.token});

  factory CreatedAPIKey.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('The new API key has no token');
    }
    return CreatedAPIKey(key: APIKey.fromJson(json), token: token);
  }

  final APIKey key;
  final String token;

  /// Never the token, so it can't reach a log by accident.
  @override
  String toString() => 'CreatedAPIKey(${key.publicId})';
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
  const Folder({
    required this.name,
    required this.total,
    required this.unread,
    this.isLabel = false,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
    name: json['name'] as String,
    total: _int(json['total'] ?? 0),
    unread: _int(json['unread'] ?? 0),
  );

  final String name;
  final int total;
  final int unread;

  /// A Gmail label rather than a folder: a message can carry several, and
  /// [Message.labels] names them. rest-mail's folders never are.
  final bool isLabel;
}

/// One address on a message's To or Cc line.
class Recipient {
  const Recipient(this.address, [this.name]);

  final String address;
  final String? name;

  String get displayName => name ?? address;

  /// The schema says an array of address strings: the server keeps no
  /// names for a message's recipients.
  static List<Recipient> listFromJson(Object? raw) => [
    if (raw is List)
      for (final item in raw)
        if (item is String && item.isNotEmpty) Recipient(item),
  ];
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
    this.labels = const [],
    this.headers = const {},
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
    headers: _headerMap(json['headers']),
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

  /// The labels it carries, by folder name, where messages have labels
  /// rather than one folder each (Gmail). Empty on rest-mail.
  final List<String> labels;

  /// The header fields as the message arrived, each name with its values.
  /// Empty for mail sent from here, and for drafts. Feeds the sender trust
  /// badge: the server writes Authentication-Results from its filter
  /// verdicts at delivery.
  final Map<String, String> headers;

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
    List<String>? labels,
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
    labels: labels ?? this.labels,
    headers: headers,
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

/// A message the server is holding to send at [scheduledAt].
class ScheduledSend {
  const ScheduledSend({
    required this.id,
    required this.from,
    required this.to,
    required this.subject,
    required this.scheduledAt,
    required this.status,
  });

  factory ScheduledSend.fromJson(Map<String, dynamic> json) => ScheduledSend(
    id: json['id'] as int,
    from: json['from'] as String? ?? '',
    to: [for (final value in json['to'] as List? ?? const []) '$value'],
    subject: json['subject'] as String? ?? '',
    scheduledAt: DateTime.parse(json['scheduled_at'] as String).toLocal(),
    status: json['status'] as String? ?? 'pending',
  );

  final int id;
  final String from;
  final List<String> to;
  final String subject;
  final DateTime scheduledAt;

  /// pending, sending, sent, failed or cancelled.
  final String status;
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
    this.raw,
  });

  final String? text;
  final String? folder;
  final String? from;
  final DateTime? after;
  final DateTime? before;
  final bool hasAttachment;

  /// The search as typed, for a server with a search syntax of its own
  /// (Gmail's `X-GM-RAW`). rest-mail reads the fields above instead.
  final String? raw;

  Map<String, String> toQueryParameters() => {
    if (text?.trim() case final trimmed? when trimmed.isNotEmpty) 'q': trimmed,
    'folder': ?folder,
    'from': ?from,
    if (after case final after?) 'after': after.toUtc().toIso8601String(),
    if (before case final before?) 'before': before.toUtc().toIso8601String(),
    if (hasAttachment) 'has_attachment': 'true',
  };
}

int _int(Object? value) => (value as num).toInt();

/// The schema writes a header name to its values; a single string is what a
/// hand-written fixture offers.
Map<String, String> _headerMap(Object? value) {
  if (value is! Map) return const {};
  final headers = <String, String>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is! String) continue;
    final item = entry.value;
    if (item is String) {
      headers[key] = item;
    } else if (item is List) {
      final values = item.whereType<String>();
      if (values.isNotEmpty) headers[key] = values.join('\n');
    }
  }
  return headers;
}

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
