import 'dart:convert';

/// An account the fake hosts, which is a mailbox.
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

  /// An admin may change these. With no [password], nothing signs in to the
  /// account: it is reached only through its owners.
  String displayName;
  String? password;
  bool active = true;

  /// What its sessions may do on the admin API, from the grants it holds.
  Set<String> capabilities = {};

  /// When set, signing in also needs this code or [recoveryCode].
  String? totpCode;
  String? recoveryCode;
  int quotaBytes;

  /// In setup, as a fresh install's bootstrap account is: it must choose its
  /// own password, and enroll an authenticator.
  bool mustChangePassword = false;
  bool owesTwoFactor = false;
  bool totpPending = false;

  /// What the real server reports in `setup_required`, in its order.
  List<String> get setupRequired => [
    if (mustChangePassword) 'password',
    if (owesTwoFactor && totpCode == null) 'two_factor',
  ];

  String get domain => address.substring(address.indexOf('@') + 1);
}

/// A domain the fake serves.
class FakeDomain {
  FakeDomain({required this.id, required this.name, this.active = true});

  final int id;
  final String name;
  bool active;
  String serverType = 'restmail';
  int defaultQuotaBytes = 1073741824;

  /// `transactional`, `bulk`, or empty for no rule.
  String sendingPolicy = '';

  /// Where its DKIM key is published; empty once the key is gone.
  String dkimSelector = 'mail';

  /// What it tells other servers about sending to it over TLS.
  FakeMtaStsPolicy? mtaSts;

  /// The SMTP relay its outgoing mail leaves through; none sends it
  /// straight to each recipient's MX.
  FakeRelay? relay;

  bool get signs => dkimSelector.isNotEmpty;
}

/// A domain's MTA-STS policy.
class FakeMtaStsPolicy {
  FakeMtaStsPolicy({
    required this.id,
    this.mode = 'testing',
    this.mxHosts = '',
    this.maxAge = 604800,
    this.active = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  final int id;

  /// `none`, `testing` or `enforce`.
  String mode;

  /// Comma-separated, as the server keeps them.
  String mxHosts;

  /// In seconds.
  int maxAge;
  bool active;
  final DateTime createdAt;
  DateTime updatedAt;
}

/// The SMTP relay a domain's outgoing mail leaves through. Its password
/// is never answered, only whether there is one.
class FakeRelay {
  FakeRelay({
    required this.host,
    required this.port,
    required this.tlsMode,
    this.username = '',
    this.password = '',
  });

  final String host;
  final int port;

  /// `starttls` or `implicit`.
  final String tlsMode;
  final String username;
  final String password;
}

/// A recipient a domain's mail is no longer sent to, after it hard bounced.
class FakeSuppression {
  FakeSuppression({
    required this.id,
    required this.domain,
    required this.address,
    required this.createdAt,
    required this.expiresAt,
    this.failureCategory = 'bad_mailbox',
    this.lastError = '',
    this.messageId,
  });

  final int id;

  /// The sending domain.
  final String domain;

  /// The recipient that bounced.
  final String address;

  /// `bad_mailbox` or `bad_domain`.
  final String failureCategory;
  final String lastError;
  final int? messageId;
  final DateTime createdAt;

  /// Once past, it no longer suppresses and is not listed.
  final DateTime expiresAt;
}

/// A sender on one of a domain's lists.
class FakeSenderRule {
  FakeSenderRule({
    required this.id,
    required this.domain,
    required this.pattern,
    required this.list,
    required this.createdAt,
    this.reason = '',
    this.createdBy,
  });

  final int id;
  final String domain;

  /// `someone@example.com`, or `@example.com`.
  final String pattern;

  /// `allow` or `block`.
  final String list;
  final String reason;
  final int? createdBy;
  final DateTime createdAt;
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
    this.messageId,
    this.attempts = 0,
    this.lastError = '',
    this.lastErrorCode = 0,
  });

  final int id;

  /// The sender's copy, which the message's trace is kept under.
  final int? messageId;
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

  /// The source the server keeps, for GET /api/v1/messages/{id}/raw. Null
  /// renders one from the fields; empty is a message with none kept.
  String? raw;

  /// [raw], or a plain-text source made from the fields, lines ending CRLF.
  String get source {
    if (raw case final kept?) return kept;
    String names(List<FakeRecipient> people) => [
      for (final r in people)
        r.name == null || r.name!.isEmpty
            ? r.address
            : '${r.name} <${r.address}>',
    ].join(', ');
    return [
      senderName == null || senderName!.isEmpty
          ? 'From: $sender'
          : 'From: $senderName <$sender>',
      if (to.isNotEmpty) 'To: ${names(to)}',
      if (cc.isNotEmpty) 'Cc: ${names(cc)}',
      'Subject: $subject',
      'Date: ${_rfc5322Date(receivedAt)}',
      'Message-ID: $messageId',
      if (inReplyTo case final parent? when parent.isNotEmpty)
        'In-Reply-To: $parent',
      'MIME-Version: 1.0',
      'Content-Type: text/plain; charset=utf-8',
      'Content-Transfer-Encoding: 8bit',
      '',
      ...const LineSplitter().convert(bodyText),
    ].join('\r\n');
  }

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
      // Address strings, as the server sends them: it keeps no names.
      'recipients_to': [for (final r in to) r.address],
      'recipients_cc': [for (final r in cc) r.address],
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

/// An IP address kept out of the mail protocols.
class FakeBan {
  FakeBan({
    required this.id,
    required this.ip,
    required this.createdAt,
    this.protocol = 'all',
    this.reason = '',
    this.createdBy = 'auto',
    this.expiresAt,
  });

  final int id;
  final String ip;
  final String protocol;
  final String reason;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? expiresAt;
}

/// A TLS certificate held for a domain.
class FakeCertificate {
  FakeCertificate({
    required this.id,
    required this.domain,
    required this.notBefore,
    required this.notAfter,
    this.issuer = "CN=R11,O=Let's Encrypt,C=US",
    this.autoRenew = true,
    this.certPem = '',
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String domain;
  final String issuer;
  final DateTime notBefore;
  final DateTime notAfter;
  final bool autoRenew;
  final String certPem;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// The filters a domain's mail goes through one way, in order.
class FakePipeline {
  FakePipeline({
    required this.id,
    required this.domain,
    required this.direction,
    required this.filters,
  });

  final int id;
  final String domain;

  /// `inbound` or `outbound`.
  final String direction;

  /// The server's filter configs: `name`, `type`, `enabled`.
  final List<Map<String, Object?>> filters;
  bool active = true;
}

/// A filter an admin wrote.
class FakeCustomFilter {
  FakeCustomFilter({
    required this.id,
    required this.domain,
    required this.name,
    required this.config,
    this.description = '',
    this.filterType = 'action',
    this.direction = 'inbound',
  });

  final int id;
  final String domain;
  String name;
  String description;
  String filterType;
  String direction;
  Map<String, Object?> config;
  bool enabled = true;
}

/// One entry of the audit log, chained to the one before by its hash.
class FakeAuditEntry {
  FakeAuditEntry({
    required this.seq,
    required this.occurredAt,
    required this.actorKind,
    required this.actorName,
    required this.action,
    required this.outcome,
    required this.method,
    required this.route,
    required this.status,
    this.actorId,
    this.ip = '192.0.2.10',
    this.userAgent = 'REST Mail',
  });

  final int seq;
  final DateTime occurredAt;
  final String actorKind;
  final int? actorId;

  /// Changeable, so a test can tamper with the log.
  String actorName;
  final String action;
  final String outcome;
  final String method;
  final String route;
  final int status;
  final String ip;
  final String userAgent;
  String prevHash = '';
  String hash = '';

  /// What the hash covers: everything but the hash.
  String get content => jsonEncode([
    'restmail-audit-v1',
    seq,
    occurredAt.toUtc().toIso8601String(),
    actorKind,
    actorId,
    actorName,
    action,
    outcome,
    method,
    route,
    status,
    ip,
    userAgent,
    prevHash,
  ]);
}

/// One of a mailbox's app passwords, as the fake stores it.
/// A scoped API key (rest-mail-server#618): a credential for automations that
/// may do only what its permissions name, and never more than its account
/// holds at the time of each request.
class FakeAPIKey {
  FakeAPIKey({
    required this.id,
    required this.mailboxId,
    required this.name,
    required this.publicId,
    required this.secret,
    required this.permissions,
    required this.createdAt,
    this.expiresAt,
  });

  final int id;
  final int mailboxId;
  final String name;
  final String publicId;

  /// The whole key. The real server keeps only a hash of its secret; the fake
  /// keeps it to check a use, and never answers with it after making it.
  final String secret;

  /// Capability and scope pairs, scopes in lower case, without duplicates.
  final List<(String, String)> permissions;
  final DateTime createdAt;
  final DateTime? expiresAt;
  DateTime? lastUsedAt;

  /// When it was revoked. A revoked key stays, as the real server keeps the
  /// row for its audit trail, but leaves the list and stops working.
  DateTime? revokedAt;

  bool get isRevoked => revokedAt != null;
}

class FakeAppPassword {
  FakeAppPassword({
    required this.id,
    required this.mailboxId,
    required this.name,
    required this.publicId,
    required this.secret,
    required this.createdAt,
    this.expiresAt,
  });

  final int id;
  final int mailboxId;
  final String name;
  final String publicId;

  /// The whole app password. The real server keeps only a SHA-256 of it; the
  /// fake keeps it to check a use, and never answers with it after making it.
  final String secret;
  final DateTime createdAt;
  final DateTime? expiresAt;
  DateTime? lastUsedAt;

  /// When it was revoked. A revoked one stays, as the real server keeps the
  /// row for its audit trail, but leaves the list and stops working.
  DateTime? revokedAt;

  bool get isRevoked => revokedAt != null;
}

/// A phone a session registered for push, as the fake stores it.
class FakePushDevice {
  FakePushDevice({
    required this.id,
    required this.mailboxId,
    required this.platform,
    required this.token,
    required this.createdAt,
    this.environment,
    this.appId,
  });

  final String id;

  /// The mailbox the session that registered it signed in as.
  final int mailboxId;
  final String platform;
  final String token;
  final String? environment;
  final String? appId;
  final DateTime createdAt;
}

/// A push the fake would have handed to APNs or FCM: who to, and the whole
/// payload, which is all Apple or Google would see.
class FakePush {
  const FakePush({
    required this.device,
    required this.token,
    required this.payload,
  });

  final String device;
  final String token;
  final Map<String, Object?> payload;
}

/// [at] as a message's Date header writes it (RFC 5322 §3.3), in UTC.
String _rfc5322Date(DateTime at) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final t = at.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${days[t.weekday - 1]}, ${t.day} ${months[t.month - 1]} ${t.year} '
      '${two(t.hour)}:${two(t.minute)}:${two(t.second)} +0000';
}
