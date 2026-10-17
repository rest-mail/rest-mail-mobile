/// One page of an admin list, which pages by offset rather than by cursor.
class OffsetPage<T> {
  const OffsetPage(this.items, {required this.offset, required this.total});

  final List<T> items;

  /// Where this page starts.
  final int offset;

  /// How many there are in all, every page counted.
  final int total;

  /// Where the next page starts.
  int get next => offset + items.length;

  bool get hasMore => next < total;
}

/// Where a message waiting to go out has got to.
enum QueueStatus {
  pending,
  delivering,
  deferred,
  delivered,
  bounced,
  expired,
  unknown;

  static QueueStatus parse(Object? value) => QueueStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => QueueStatus.unknown,
  );

  /// Whether the server would try it again now: only one still waiting is.
  bool get canRetry => this == pending || this == deferred;
}

/// A message on its way out to another server, one recipient per entry.
class QueueEntry {
  const QueueEntry({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.domain,
    required this.status,
    required this.attempts,
    required this.maxRetries,
    required this.createdAt,
    this.nextAttempt,
    this.lastAttempt,
    this.expiresAt,
    this.lastError = '',
    this.lastErrorCode = 0,
  });

  factory QueueEntry.fromJson(Map<String, dynamic> json) => QueueEntry(
    id: _int(json['id']),
    sender: json['sender'] as String? ?? '',
    recipient: json['recipient'] as String? ?? '',
    domain: json['domain'] as String? ?? '',
    status: QueueStatus.parse(json['status']),
    attempts: _int(json['attempts'] ?? 0),
    maxRetries: _int(json['max_retries'] ?? 0),
    createdAt: _time(json['created_at']) ?? DateTime.now(),
    nextAttempt: _time(json['next_attempt']),
    lastAttempt: _time(json['last_attempt']),
    expiresAt: _time(json['expires_at']),
    lastError: json['last_error'] as String? ?? '',
    lastErrorCode: _int(json['last_error_code'] ?? 0),
  );

  final int id;
  final String sender;
  final String recipient;

  /// The recipient's domain, whose MX it is delivered to.
  final String domain;
  final QueueStatus status;
  final int attempts;
  final int maxRetries;
  final DateTime createdAt;
  final DateTime? nextAttempt;
  final DateTime? lastAttempt;
  final DateTime? expiresAt;

  /// What the receiving server said the last time, if it refused.
  final String lastError;
  final int lastErrorCode;
}

/// How many queue entries are in each state.
class QueueStats {
  const QueueStats(this.counts);

  factory QueueStats.fromJson(Map<String, dynamic> json) => QueueStats({
    for (final MapEntry(:key, :value) in json.entries)
      if (value is num) key: value.toInt(),
  });

  final Map<String, int> counts;

  int of(QueueStatus status) => counts[status.name] ?? 0;

  int get total => counts['total'] ?? 0;
}

/// A domain the server holds mail for.
class AdminDomain {
  const AdminDomain({
    required this.id,
    required this.name,
    required this.serverType,
    required this.active,
    required this.defaultQuotaBytes,
    this.dkimSelector = '',
  });

  factory AdminDomain.fromJson(Map<String, dynamic> json) => AdminDomain(
    id: _int(json['id']),
    name: json['name'] as String,
    serverType: json['server_type'] as String? ?? '',
    active: json['active'] as bool? ?? false,
    defaultQuotaBytes: _int(json['default_quota_bytes'] ?? 0),
    dkimSelector: json['dkim_selector'] as String? ?? '',
  );

  final int id;
  final String name;

  /// `restmail` when the server keeps the mail itself, `traditional` when it
  /// hands it to Postfix and Dovecot.
  final String serverType;
  final bool active;
  final int defaultQuotaBytes;
  final String dkimSelector;
}

/// A mailbox, as an admin sees it.
class AdminMailbox {
  const AdminMailbox({
    required this.id,
    required this.domainId,
    required this.address,
    required this.displayName,
    required this.active,
    required this.quotaBytes,
    required this.quotaUsedBytes,
    this.lastLoginAt,
  });

  factory AdminMailbox.fromJson(Map<String, dynamic> json) => AdminMailbox(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    address: json['address'] as String,
    displayName: json['display_name'] as String? ?? '',
    active: json['active'] as bool? ?? false,
    quotaBytes: _int(json['quota_bytes'] ?? 0),
    quotaUsedBytes: _int(json['quota_used_bytes'] ?? 0),
    lastLoginAt: _time(json['last_login_at']),
  );

  final int id;
  final int domainId;
  final String address;
  final String displayName;
  final bool active;
  final int quotaBytes;
  final int quotaUsedBytes;
  final DateTime? lastLoginAt;
}

/// Mail to [source] goes to [destination].
class AdminAlias {
  const AdminAlias({
    required this.id,
    required this.domainId,
    required this.source,
    required this.destination,
    required this.active,
  });

  factory AdminAlias.fromJson(Map<String, dynamic> json) => AdminAlias(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    source: json['source_address'] as String,
    destination: json['destination_address'] as String,
    active: json['active'] as bool? ?? false,
  );

  final int id;
  final int domainId;
  final String source;
  final String destination;
  final bool active;
}

/// A role: a named set of capabilities an admin user is given.
class AdminRole {
  const AdminRole({
    required this.id,
    required this.name,
    this.description = '',
    this.systemRole = false,
  });

  factory AdminRole.fromJson(Map<String, dynamic> json) => AdminRole(
    id: _int(json['id']),
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    systemRole: json['system_role'] as bool? ?? false,
  );

  final int id;
  final String name;
  final String description;

  /// One the server made, which cannot be changed.
  final bool systemRole;
}

/// An admin user: someone who signs in to run the server, with a username
/// rather than a mailbox, and the roles that say what they may do.
class AdminUser {
  const AdminUser({
    required this.id,
    required this.username,
    required this.active,
    required this.passwordChangeRequired,
    this.email,
    this.roles = const [],
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: _int(json['id']),
    username: json['username'] as String,
    email: switch (json['email']) {
      final String email when email.isNotEmpty => email,
      _ => null,
    },
    active: json['active'] as bool? ?? false,
    passwordChangeRequired: json['password_change_required'] as bool? ?? false,
    roles: [
      for (final role in json['roles'] as List? ?? const [])
        AdminRole.fromJson(role as Map<String, dynamic>),
    ],
  );

  final int id;
  final String username;
  final String? email;
  final bool active;

  /// Has to choose a password of its own at its next sign-in.
  final bool passwordChangeRequired;
  final List<AdminRole> roles;
}

/// An IP address kept out of the server's mail protocols.
class Ban {
  const Ban({
    required this.id,
    required this.ip,
    required this.protocol,
    required this.createdAt,
    this.reason = '',
    this.createdBy = '',
    this.expiresAt,
  });

  factory Ban.fromJson(Map<String, dynamic> json) => Ban(
    id: _int(json['id']),
    ip: json['ip'] as String,
    protocol: json['protocol'] as String? ?? 'all',
    reason: json['reason'] as String? ?? '',
    createdBy: json['created_by'] as String? ?? '',
    createdAt: _time(json['created_at']) ?? DateTime.now(),
    expiresAt: _time(json['expires_at']),
  );

  final int id;
  final String ip;

  /// `smtp`, `imap`, `pop3`, or `all` of them.
  final String protocol;
  final String reason;

  /// The admin who made it, or `auto` for one the server made itself.
  final String createdBy;
  final DateTime createdAt;

  /// When it lifts; never if null.
  final DateTime? expiresAt;
}

/// The server at a glance, as its admin dashboard shows it.
class ServerStats {
  const ServerStats({
    required this.domains,
    required this.mailboxes,
    required this.queuePending,
    required this.queueFailed,
    required this.volume,
    required this.recent,
    required this.inboundMx,
    required this.inboundOverTls,
  });

  factory ServerStats.fromJson(Map<String, dynamic> json) {
    final queue = json['queueStats'] as Map<String, dynamic>? ?? const {};
    final tls =
        json['inboundTransportSecurity'] as Map<String, dynamic>? ?? const {};
    return ServerStats(
      domains: _int(json['domainCount'] ?? 0),
      mailboxes: _int(json['mailboxCount'] ?? 0),
      queuePending: _int(queue['pending'] ?? 0),
      queueFailed: _int(queue['failed'] ?? 0),
      volume: [
        for (final day in json['messageVolume'] as List? ?? const [])
          if (day case {'date': final String date, 'count': final num count})
            (date: date, count: count.toInt()),
      ],
      recent: [
        for (final item in json['recentActivity'] as List? ?? const [])
          if (item case {
            'description': final String description,
            'timestamp': final String timestamp,
          })
            (description: description, at: _time(timestamp)),
      ],
      inboundMx: _int(tls['totalInboundMX'] ?? 0),
      inboundOverTls: _int(tls['overTLS'] ?? 0),
    );
  }

  final int domains;
  final int mailboxes;

  /// Waiting to go out, and given up on.
  final int queuePending;
  final int queueFailed;

  /// Messages a day, oldest first, labelled as the server labels them.
  final List<({String date, int count})> volume;
  final List<({String description, DateTime? at})> recent;

  /// Mail other servers handed over, and how much of it came over TLS.
  final int inboundMx;
  final int inboundOverTls;
}

int _int(Object? value) => (value as num).toInt();

/// A timestamp, or null for none. Go writes an unset time as year 1.
DateTime? _time(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null || parsed.year < 1971) return null;
  return parsed.toLocal();
}
