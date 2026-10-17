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

int _int(Object? value) => (value as num).toInt();

/// A timestamp, or null for none. Go writes an unset time as year 1.
DateTime? _time(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null || parsed.year < 1971) return null;
  return parsed.toLocal();
}
