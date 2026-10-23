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
    this.messageId,
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
    this.bodyType = '',
    this.failureCategory = '',
  });

  factory QueueEntry.fromJson(Map<String, dynamic> json) => QueueEntry(
    id: _int(json['id']),
    messageId: (json['message_id'] as num?)?.toInt(),
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
    bodyType: json['body_type'] as String? ?? '',
    failureCategory: json['failure_category'] as String? ?? '',
  );

  final int id;

  /// The sender's copy of the message, which its trace is kept under; none
  /// for mail that did not start in a mailbox here.
  final int? messageId;
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
  final String bodyType;
  final String failureCategory;
}

/// Queue filters have identical semantics for listing and bulk operations.
class QueueFilter {
  const QueueFilter({this.status, this.domain, this.sender, this.recipient});

  final QueueStatus? status;
  final String? domain;
  final String? sender;
  final String? recipient;

  Map<String, String> toJson() => {
    'status': ?status?.name,
    'domain': ?domain,
    'sender': ?sender,
    'recipient': ?recipient,
  };
}

/// The server's acknowledgement of a single queue retry or bounce.
class QueueActionResult {
  const QueueActionResult({required this.status});

  factory QueueActionResult.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    if (status is! String || status.isEmpty) {
      throw const FormatException('Queue acknowledgement needs a status');
    }
    return QueueActionResult(status: status);
  }

  /// `retrying` for retry and `bounced` for bounce, validated by the client.
  final String status;
}

/// Exactly one selection: IDs, or all entries matching a filter across pages.
class QueueSelection {
  QueueSelection.ids(List<int> ids)
    : ids = List<int>.unmodifiable(ids),
      filter = null {
    if (ids.isEmpty || ids.length > 1000 || ids.any((id) => id < 1)) {
      throw ArgumentError.value(
        ids,
        'ids',
        'Select between 1 and 1000 positive IDs',
      );
    }
  }

  const QueueSelection.filter(QueueFilter this.filter) : ids = null;

  final List<int>? ids;
  final QueueFilter? filter;

  Map<String, Object> toJson() => {'ids': ?ids, 'filter': ?filter?.toJson()};
}

class BulkQueueResult {
  const BulkQueueResult({required this.affected});

  factory BulkQueueResult.fromJson(Map<String, dynamic> json) {
    final affected = json['affected'];
    if (affected is! int || affected < 0) {
      throw const FormatException('Missing bulk queue result');
    }
    return BulkQueueResult(affected: affected);
  }

  final int affected;
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
    this.sendingPolicy = '',
    this.createdAt,
    this.updatedAt,
  });

  factory AdminDomain.fromJson(Map<String, dynamic> json) => AdminDomain(
    id: _int(json['id']),
    name: json['name'] as String,
    serverType: json['server_type'] as String? ?? '',
    active: json['active'] as bool? ?? false,
    defaultQuotaBytes: _int(json['default_quota_bytes'] ?? 0),
    dkimSelector: json['dkim_selector'] as String? ?? '',
    sendingPolicy: json['sending_policy'] as String? ?? '',
    createdAt: _time(json['created_at']),
    updatedAt: _time(json['updated_at']),
  );

  /// The server types a domain can be created with.
  static const serverTypes = ['restmail', 'traditional'];

  /// The sending policies a domain can have; empty means no rule.
  static const sendingPolicies = ['', 'transactional', 'bulk'];

  final int id;
  final String name;

  /// `restmail` when the server keeps the mail itself, `traditional` when it
  /// hands it to Postfix and Dovecot.
  final String serverType;
  final bool active;
  final int defaultQuotaBytes;
  final String dkimSelector;

  /// `transactional`, `bulk`, or empty when the send API applies no rule.
  final String sendingPolicy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// The stored quota breakdown, which may be absent on a fresh mailbox.
class AdminQuotaUsage {
  const AdminQuotaUsage({
    required this.mailboxId,
    required this.subjectBytes,
    required this.bodyBytes,
    required this.attachmentBytes,
    required this.messageCount,
    this.updatedAt,
  });

  factory AdminQuotaUsage.fromJson(Map<String, dynamic> json) =>
      AdminQuotaUsage(
        mailboxId: _int(json['mailbox_id'] ?? 0),
        subjectBytes: _int(json['subject_bytes'] ?? 0),
        bodyBytes: _int(json['body_bytes'] ?? 0),
        attachmentBytes: _int(json['attachment_bytes'] ?? 0),
        messageCount: _int(json['message_count'] ?? 0),
        updatedAt: _time(json['updated_at']),
      );

  final int mailboxId;
  final int subjectBytes;
  final int bodyBytes;
  final int attachmentBytes;
  final int messageCount;
  final DateTime? updatedAt;
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
    this.localPart = '',
    this.domain,
    this.quotaUsage,
    this.passwordChangeRequired = false,
    this.twoFactorRequired = false,
    this.lastPasswordChange,
    this.createdAt,
    this.updatedAt,
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
    localPart: json['local_part'] as String? ?? '',
    domain: switch (json['domain']) {
      final Map<String, dynamic> domain
          when domain['name'] is String &&
              (domain['name'] as String).isNotEmpty =>
        AdminDomain.fromJson(domain),
      _ => null,
    },
    quotaUsage: switch (json['quota_usage']) {
      final Map<String, dynamic> usage => AdminQuotaUsage.fromJson(usage),
      _ => null,
    },
    passwordChangeRequired: json['password_change_required'] as bool? ?? false,
    twoFactorRequired: json['two_factor_required'] as bool? ?? false,
    lastPasswordChange: _time(json['last_password_change']),
    createdAt: _time(json['created_at']),
    updatedAt: _time(json['updated_at']),
  );

  final int id;
  final int domainId;
  final String address;
  final String displayName;
  final bool active;
  final int quotaBytes;
  final int quotaUsedBytes;
  final DateTime? lastLoginAt;
  final String localPart;
  final AdminDomain? domain;
  final AdminQuotaUsage? quotaUsage;
  final bool passwordChangeRequired;
  final bool twoFactorRequired;
  final DateTime? lastPasswordChange;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// Mail to [source] goes to [destination].
class AdminAlias {
  const AdminAlias({
    required this.id,
    required this.domainId,
    required this.source,
    required this.destination,
    required this.active,
    this.domain,
    this.createdAt,
  });

  factory AdminAlias.fromJson(Map<String, dynamic> json) => AdminAlias(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    source: json['source_address'] as String,
    destination: json['destination_address'] as String,
    active: json['active'] as bool? ?? false,
    domain: switch (json['domain']) {
      final Map<String, dynamic> domain
          when domain['name'] is String &&
              (domain['name'] as String).isNotEmpty =>
        AdminDomain.fromJson(domain),
      _ => null,
    },
    createdAt: _time(json['created_at']),
  );

  final int id;
  final int domainId;
  final String source;
  final String destination;
  final bool active;
  final AdminDomain? domain;
  final DateTime? createdAt;
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

/// One step of a message's way through a pipeline.
class TraceStage {
  const TraceStage({
    required this.filter,
    required this.action,
    this.skipped = false,
    this.skipReason = '',
    this.result = '',
    this.detail = '',
    this.error = '',
  });

  factory TraceStage.fromJson(Map<String, dynamic> json) {
    final log = json['log'] as Map<String, dynamic>? ?? const {};
    return TraceStage(
      filter: json['filter_name'] as String? ?? '',
      action: json['action'] as String? ?? '',
      skipped: json['skipped'] as bool? ?? false,
      skipReason: json['skip_reason'] as String? ?? '',
      result: log['result'] as String? ?? '',
      detail: log['detail'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  final String filter;

  /// `continue`, or what the filter did with the message instead.
  final String action;
  final bool skipped;
  final String skipReason;

  /// What the filter found, in its own words.
  final String result;
  final String detail;
  final String error;
}

/// What happened to a message on its way in or out: each filter it passed,
/// and how it ended.
class MessageTrace {
  const MessageTrace({
    required this.id,
    required this.direction,
    required this.outcome,
    required this.finalAction,
    required this.createdAt,
    this.messageId,
    this.rfcMessageId = '',
    this.transport = '',
    this.mailFrom = '',
    this.rcptTo = '',
    this.clientIp = '',
    this.reasonCode = '',
    this.spamScore,
    this.durationMs = 0,
    this.stages = const [],
  });

  factory MessageTrace.fromJson(Map<String, dynamic> json) => MessageTrace(
    id: _int(json['id']),
    messageId: (json['message_id'] as num?)?.toInt(),
    rfcMessageId: json['rfc_message_id'] as String? ?? '',
    direction: json['direction'] as String? ?? '',
    transport: json['transport'] as String? ?? '',
    mailFrom: json['mail_from'] as String? ?? '',
    rcptTo: json['rcpt_to'] as String? ?? '',
    clientIp: json['client_ip'] as String? ?? '',
    finalAction: json['final_action'] as String? ?? '',
    outcome: json['outcome'] as String? ?? '',
    reasonCode: json['reason_code'] as String? ?? '',
    spamScore: (json['spam_score'] as num?)?.toDouble(),
    durationMs: _int(json['duration_ms'] ?? 0),
    stages: [
      for (final stage in json['stages'] as List? ?? const [])
        if (stage is Map<String, dynamic>) TraceStage.fromJson(stage),
    ],
    createdAt: _time(json['created_at']) ?? DateTime.now(),
  );

  final int id;
  final int? messageId;
  final String rfcMessageId;

  /// `inbound` or `outbound`.
  final String direction;

  /// `tls` or `plaintext` for mail another server handed over; empty for
  /// the rest.
  final String transport;
  final String mailFrom;

  /// The first recipient.
  final String rcptTo;
  final String clientIp;
  final String finalAction;

  /// `delivered`, `queued`, `rejected`, `quarantined`, `discarded` or
  /// `deferred`.
  final String outcome;

  /// Why it did not go through, when it did not.
  final String reasonCode;
  final double? spamScore;
  final int durationMs;
  final List<TraceStage> stages;
  final DateTime createdAt;
}

/// A TLS report (RFC 8460) another server sent: how its attempts to reach
/// one of this server's domains over TLS went, over a day or so.
class TlsReport {
  const TlsReport({
    required this.id,
    required this.domainId,
    required this.reportingOrg,
    required this.policyType,
    required this.policyDomain,
    required this.startDate,
    required this.endDate,
    required this.receivedAt,
    this.successful = 0,
    this.failed = 0,
    this.failureDetails,
  });

  factory TlsReport.fromJson(Map<String, dynamic> json) => TlsReport(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    reportingOrg: json['reporting_org'] as String? ?? '',
    policyType: json['policy_type'] as String? ?? '',
    policyDomain: json['policy_domain'] as String? ?? '',
    startDate: _time(json['start_date']) ?? DateTime.now(),
    endDate: _time(json['end_date']) ?? DateTime.now(),
    receivedAt: _time(json['received_at']) ?? DateTime.now(),
    successful: _int(json['total_successful'] ?? 0),
    failed: _int(json['total_failure'] ?? 0),
    failureDetails: json['failure_details'],
  );

  final int id;
  final int domainId;

  /// Who sent it: `Google Inc.` and the like.
  final String reportingOrg;

  /// `sts`, `tlsa` or `no-policy`.
  final String policyType;
  final String policyDomain;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime receivedAt;
  final int successful;
  final int failed;

  /// The report's `failure-details`, as it sent them.
  final Object? failureDetails;
}

/// One entry of the audit log: a request, who made it, and how it ended.
/// Each entry carries the hash of the one before, so a changed or missing
/// entry shows when the chain is checked.
class AuditEntry {
  const AuditEntry({
    required this.seq,
    required this.occurredAt,
    required this.actorKind,
    required this.actorName,
    required this.action,
    required this.outcome,
    this.actorId,
    this.sessionId = '',
    this.errorCode = '',
    this.method = '',
    this.route = '',
    this.status = 0,
    this.target = const {},
    this.ip = '',
    this.userAgent = '',
    this.requestId = '',
    this.prevHash = '',
    this.hash = '',
  });

  factory AuditEntry.fromJson(Map<String, dynamic> json) => AuditEntry(
    seq: _int(json['seq']),
    occurredAt: _time(json['occurred_at']) ?? DateTime.now(),
    actorKind: json['actor_kind'] as String? ?? '',
    actorId: (json['actor_id'] as num?)?.toInt(),
    actorName: json['actor_name'] as String? ?? '',
    sessionId: json['session_id'] as String? ?? '',
    action: json['action'] as String? ?? '',
    outcome: json['outcome'] as String? ?? '',
    errorCode: json['error_code'] as String? ?? '',
    method: json['method'] as String? ?? '',
    route: json['route'] as String? ?? '',
    status: _int(json['status'] ?? 0),
    target: {
      for (final MapEntry(:key, :value)
          in (json['target'] as Map<String, dynamic>? ?? const {}).entries)
        key: '$value',
    },
    ip: json['ip'] as String? ?? '',
    userAgent: json['user_agent'] as String? ?? '',
    requestId: json['request_id'] as String? ?? '',
    prevHash: json['prev_hash'] as String? ?? '',
    hash: json['hash'] as String? ?? '',
  );

  /// 1, 2, 3, … with no gaps.
  final int seq;
  final DateTime occurredAt;

  /// `account`, `system` or `anonymous`.
  final String actorKind;

  /// The account's id, set once the request proved it.
  final int? actorId;

  /// The account's address at the time.
  final String actorName;
  final String sessionId;

  /// `auth.sign_in`, `admin.change` and the like.
  final String action;

  /// `success`, `denied`, `failed` or `error`.
  final String outcome;
  final String errorCode;
  final String method;
  final String route;
  final int status;

  /// What the request acted on: the route's parameters, by name.
  final Map<String, String> target;
  final String ip;
  final String userAgent;
  final String requestId;
  final String prevHash;
  final String hash;
}

/// What checking the audit log's chain found.
class AuditCheck {
  const AuditCheck({
    required this.ok,
    required this.checked,
    required this.firstSeq,
    required this.lastSeq,
    this.lastHash = '',
    this.brokenAtSeq,
    this.reason = '',
    this.note = '',
  });

  factory AuditCheck.fromJson(Map<String, dynamic> json) => AuditCheck(
    ok: json['ok'] as bool? ?? false,
    checked: _int(json['checked'] ?? 0),
    firstSeq: _int(json['first_seq'] ?? 0),
    lastSeq: _int(json['last_seq'] ?? 0),
    lastHash: json['last_hash'] as String? ?? '',
    brokenAtSeq: (json['broken_at_seq'] as num?)?.toInt(),
    reason: json['reason'] as String? ?? '',
    note: json['note'] as String? ?? '',
  );

  /// Whether every entry follows the one before and hashes as it says.
  final bool ok;

  /// How many entries held.
  final int checked;
  final int firstSeq;

  /// The last entry that held, and its hash.
  final int lastSeq;
  final String lastHash;

  /// The first entry that does not hold, and why.
  final int? brokenAtSeq;
  final String reason;

  /// Set when the log does not start at 1.
  final String note;
}

/// The key a domain's outgoing mail is signed with. The server never shows
/// the key itself.
class DkimKey {
  const DkimKey({
    required this.domainId,
    required this.domain,
    required this.selector,
    required this.hasKey,
    this.createdAt,
    this.ageSeconds,
  });

  factory DkimKey.fromJson(Map<String, dynamic> json) => DkimKey(
    domainId: _int(json['domain_id']),
    domain: json['domain'] as String? ?? '',
    selector: json['selector'] as String? ?? '',
    hasKey: json['has_key'] as bool? ?? false,
    createdAt: _time(json['created_at']),
    ageSeconds: (json['age_seconds'] as num?)?.toDouble(),
  );

  final int domainId;
  final String domain;

  /// Where the public key is published: `<selector>._domainkey.<domain>`.
  final String selector;
  final bool hasKey;

  /// When the key was set, or null when the server does not know.
  final DateTime? createdAt;

  /// How old the key is, in seconds, as the server counts it.
  final double? ageSeconds;
}

/// How often a domain's DKIM key is due to be replaced.
class DkimRotation {
  const DkimRotation({required this.domainId, required this.intervalDays});

  factory DkimRotation.fromJson(Map<String, dynamic> json) => DkimRotation(
    domainId: _int(json['domain_id']),
    intervalDays: _int(json['rotation_interval_days']),
  );

  /// The most days the server accepts between rotations.
  static const maxIntervalDays = 3650;

  final int domainId;

  /// Days between rotations; 0 means the key is never rotated.
  final int intervalDays;

  bool get enabled => intervalDays > 0;
}

/// A TLS certificate the server holds for one of its domains. The server
/// never shows its private key; it sends the certificate itself only when
/// asked for the one.
class TlsCertificate {
  const TlsCertificate({
    required this.id,
    required this.domainId,
    required this.issuer,
    required this.notBefore,
    required this.notAfter,
    this.domain = '',
    this.domainDetails,
    this.autoRenew = false,
    this.certPem = '',
    this.createdAt,
    this.updatedAt,
  });

  factory TlsCertificate.fromJson(Map<String, dynamic> json) => TlsCertificate(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    domain: switch (json['domain']) {
      {'name': final String name} => name,
      _ => '',
    },
    domainDetails:
        json['domain'] is Map<String, dynamic> &&
            ((json['domain'] as Map<String, dynamic>)['id'] as num? ?? 0) > 0
        ? AdminDomain.fromJson(json['domain'] as Map<String, dynamic>)
        : null,
    issuer: json['issuer'] as String? ?? '',
    notBefore: _time(json['not_before']) ?? DateTime.now(),
    notAfter: _time(json['not_after']) ?? DateTime.now(),
    autoRenew: json['auto_renew'] as bool? ?? false,
    certPem: json['cert_pem'] as String? ?? '',
    createdAt: _time(json['created_at']),
    updatedAt: _time(json['updated_at']),
  );

  final int id;
  final int domainId;

  /// Its domain's name, when the server sent it along.
  final String domain;
  final AdminDomain? domainDetails;
  final String issuer;
  final DateTime notBefore;
  final DateTime notAfter;

  /// Whether the server renews it before it runs out.
  final bool autoRenew;

  /// The certificate as PEM; empty in a list, which leaves it out.
  final String certPem;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// One filter in a pipeline.
class PipelineFilter {
  const PipelineFilter({
    required this.name,
    required this.type,
    required this.enabled,
    this.unskippable = false,
    this.config,
  });

  factory PipelineFilter.fromJson(Map<String, dynamic> json) => PipelineFilter(
    name: json['name'] as String? ?? '',
    type: json['type'] as String? ?? '',
    enabled: json['enabled'] as bool? ?? false,
    unskippable: json['unskippable'] as bool? ?? false,
    config: json['config'] as Map<String, dynamic>?,
  );

  final String name;

  /// `action`, which may stop a message, or `transform`, which changes it.
  final String type;
  final bool enabled;

  /// Runs even when an earlier filter would skip the rest.
  final bool unskippable;
  final Map<String, dynamic>? config;

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'enabled': enabled,
    'unskippable': unskippable,
    'config': ?config,
  };
}

/// The filters a domain's mail goes through, in order, one way.
class Pipeline {
  const Pipeline({
    required this.id,
    required this.domainId,
    required this.direction,
    required this.active,
    required this.filters,
    this.updatedAt,
    this.createdAt,
    this.domain = '',
  });

  factory Pipeline.fromJson(Map<String, dynamic> json) => Pipeline(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    direction: json['direction'] as String? ?? '',
    active: json['active'] as bool? ?? false,
    filters: [
      for (final filter in json['filters'] as List? ?? const [])
        if (filter is Map<String, dynamic>) PipelineFilter.fromJson(filter),
    ],
    updatedAt: _time(json['updated_at']),
    createdAt: _time(json['created_at']),
    domain: (json['domain'] as Map<String, dynamic>?)?['name'] as String? ?? '',
  );

  final int id;
  final int domainId;

  /// `inbound` or `outbound`.
  final String direction;
  final bool active;
  final List<PipelineFilter> filters;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String domain;
}

/// A filter an admin wrote, which pipelines can use like the built-in ones.
class CustomFilter {
  const CustomFilter({
    required this.id,
    required this.domainId,
    required this.name,
    required this.filterType,
    required this.direction,
    required this.enabled,
    this.description = '',
    this.config,
    this.updatedAt,
    this.createdAt,
    this.domain = '',
  });

  factory CustomFilter.fromJson(Map<String, dynamic> json) => CustomFilter(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    filterType: json['filter_type'] as String? ?? '',
    direction: json['direction'] as String? ?? '',
    enabled: json['enabled'] as bool? ?? false,
    config: json['config'],
    updatedAt: _time(json['updated_at']),
    createdAt: _time(json['created_at']),
    domain: (json['domain'] as Map<String, dynamic>?)?['name'] as String? ?? '',
  );

  final int id;
  final int domainId;
  final String name;
  final String description;

  /// `action` or `transform`.
  final String filterType;

  /// `inbound`, `outbound` or `both`.
  final String direction;
  final bool enabled;

  /// What it does, as JSON.
  final Object? config;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String domain;
}

/// What the filters did with the mail over a window of time: how it
/// arrived, how senders fared on SPF, DKIM and DMARC, what each filter
/// decided, how each message ended, and why mail was turned away.
class PipelineAnalytics {
  const PipelineAnalytics({
    required this.since,
    required this.until,
    this.received = const [],
    this.senderChecks = const [],
    this.decisions = const [],
    this.outcomes = const [],
    this.rejectReasons = const [],
  });

  factory PipelineAnalytics.fromJson(Map<String, dynamic> json) {
    final window = json['window'] as Map<String, dynamic>? ?? const {};
    final funnel = json['funnel'] as Map<String, dynamic>? ?? const {};
    // Go writes an empty list as null.
    List<Map<String, dynamic>> rows(String key) => [
      for (final row in funnel[key] as List? ?? const [])
        if (row is Map<String, dynamic>) row,
    ];
    int count(Map<String, dynamic> row) => (row['count'] as num? ?? 0).round();
    String text(Map<String, dynamic> row, String key) =>
        row[key] as String? ?? '';
    return PipelineAnalytics(
      since: _time(window['since']) ?? DateTime.now(),
      until: _time(window['until']) ?? DateTime.now(),
      received: [
        for (final row in rows('received'))
          (transport: text(row, 'transport'), count: count(row)),
      ],
      senderChecks: [
        for (final row in rows('auth_verdicts'))
          (
            mechanism: text(row, 'mechanism'),
            result: text(row, 'result'),
            count: count(row),
          ),
      ],
      decisions: [
        for (final row in rows('stage_decisions'))
          (
            filter: text(row, 'filter'),
            action: text(row, 'action'),
            count: count(row),
          ),
      ],
      outcomes: [
        for (final row in rows('terminal_outcomes'))
          (
            direction: text(row, 'direction'),
            outcome: text(row, 'outcome'),
            count: count(row),
          ),
      ],
      rejectReasons: [
        for (final row in rows('top_reject_reasons'))
          (reason: text(row, 'reason_code'), count: count(row)),
      ],
    );
  }

  final DateTime since;
  final DateTime until;

  /// Mail other servers handed over, by `tls` or `plaintext`.
  final List<({String transport, int count})> received;

  /// `spf`, `dkim` or `dmarc`, and how the check came out.
  final List<({String mechanism, String result, int count})> senderChecks;

  /// What each filter did: `continue`, `reject` and so on.
  final List<({String filter, String action, int count})> decisions;

  /// How messages ended, each way.
  final List<({String direction, String outcome, int count})> outcomes;

  /// Why mail was turned away, most often first.
  final List<({String reason, int count})> rejectReasons;

  bool get isEmpty =>
      received.isEmpty &&
      senderChecks.isEmpty &&
      decisions.isEmpty &&
      outcomes.isEmpty &&
      rejectReasons.isEmpty;
}

/// A domain's two lists of senders: the one let past the spam checks, and
/// the one turned away.
enum SenderList {
  allow('allowlist'),
  block('blocklist');

  const SenderList(this.path);

  /// Its name in the server's routes.
  final String path;
}

/// A sender on one of a domain's lists: an address, or `@` and a domain
/// for everyone there.
class SenderRule {
  const SenderRule({
    required this.id,
    required this.domainId,
    required this.pattern,
    required this.list,
    this.reason = '',
    this.createdAt,
  });

  factory SenderRule.fromJson(Map<String, dynamic> json) => SenderRule(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    pattern: json['pattern'] as String? ?? '',
    list: json['list_type'] == 'allow' ? SenderList.allow : SenderList.block,
    reason: json['reason'] as String? ?? '',
    createdAt: _time(json['created_at']),
  );

  final int id;
  final int domainId;

  /// `someone@example.com`, or `@example.com`.
  final String pattern;
  final SenderList list;
  final String reason;
  final DateTime? createdAt;
}

/// How strictly other servers are told to use TLS when they send to a
/// domain (RFC 8461).
enum MtaStsMode {
  /// They must, to a host on the list with a valid certificate, or not
  /// deliver at all.
  enforce,

  /// They deliver anyway, and report what failed.
  testing,

  /// The policy is withdrawn.
  none;

  static MtaStsMode parse(Object? value) => switch (value) {
    'enforce' => enforce,
    'none' => none,
    _ => testing,
  };
}

/// A domain's MTA-STS policy, as the server publishes it at
/// `https://mta-sts.<domain>/.well-known/mta-sts.txt`.
class MtaStsPolicy {
  const MtaStsPolicy({
    required this.domainId,
    required this.mode,
    required this.mxHosts,
    required this.maxAge,
    required this.active,
    this.updatedAt,
  });

  factory MtaStsPolicy.fromJson(Map<String, dynamic> json) => MtaStsPolicy(
    domainId: _int(json['domain_id'] ?? 0),
    mode: MtaStsMode.parse(json['mode']),
    mxHosts: [
      for (final host in (json['mx_hosts'] as String? ?? '').split(','))
        if (host.trim().isNotEmpty) host.trim(),
    ],
    maxAge: Duration(seconds: _int(json['max_age'] ?? 0)),
    active: json['active'] as bool? ?? false,
    updatedAt: _time(json['updated_at']),
  );

  final int domainId;
  final MtaStsMode mode;

  /// The hosts mail may be handed to; `*.example.com` covers a level.
  final List<String> mxHosts;

  /// How long other servers may keep the policy before fetching it again.
  final Duration maxAge;

  /// Whether the server publishes it. One that is not is as good as none.
  final bool active;
  final DateTime? updatedAt;
}

/// One DNS record the server looked up for a domain, and whether it is
/// there.
class DnsRecordCheck {
  const DnsRecordCheck({
    required this.type,
    required this.name,
    required this.status,
    this.value = '',
    this.message = '',
  });

  factory DnsRecordCheck.fromJson(Map<String, dynamic> json) => DnsRecordCheck(
    type: json['type'] as String? ?? '',
    name: json['name'] as String? ?? '',
    status: json['status'] as String? ?? '',
    value: json['value'] as String? ?? '',
    message: json['message'] as String? ?? '',
  );

  /// `MX`, `SPF`, `DMARC`, `DKIM`, `MTA-STS` or `TLS-RPT`.
  final String type;

  /// Where it was looked up.
  final String name;

  /// `ok`, `missing` or `error`.
  final String status;

  /// What was found, when it was.
  final String value;

  /// What was wrong, when something was.
  final String message;

  bool get ok => status == 'ok';
}

/// What looking up a domain's DNS records found.
class DnsCheck {
  const DnsCheck({
    required this.domain,
    required this.records,
    this.summary = '',
  });

  factory DnsCheck.fromJson(Map<String, dynamic> json) => DnsCheck(
    domain: json['domain'] as String? ?? '',
    summary: json['summary'] as String? ?? '',
    records: [
      for (final record in json['records'] as List? ?? const [])
        if (record is Map<String, dynamic>) DnsRecordCheck.fromJson(record),
    ],
  );

  final String domain;

  /// The server's own line: `4/6 records verified`.
  final String summary;
  final List<DnsRecordCheck> records;
}

int _int(Object? value) => (value as num).toInt();

/// A timestamp, or null for none. Go writes an unset time as year 1.
DateTime? _time(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null || parsed.year < 1971) return null;
  return parsed.toLocal();
}

/// How a domain's outgoing mail leaves the server.
enum OutboundTransport {
  /// Straight to each recipient's mail servers, found by MX lookup.
  direct('direct'),

  /// Handed to an SMTP relay, which delivers it.
  relay('relay');

  const OutboundTransport(this.value);

  /// Its name in the API.
  final String value;

  static OutboundTransport parse(Object? value) =>
      value == 'relay' ? relay : direct;
}

/// How the server secures its connection to a relay.
enum RelayTlsMode {
  /// A plain connection, upgraded with STARTTLS (usually port 587).
  starttls('starttls'),

  /// TLS from the start (usually port 465).
  implicit('implicit');

  const RelayTlsMode(this.value);

  /// Its name in the API.
  final String value;

  static RelayTlsMode? parse(Object? value) => switch (value) {
    'starttls' => starttls,
    'implicit' => implicit,
    _ => null,
  };
}

/// A domain's outbound transport. The server never sends the relay
/// password back, only whether one is stored.
class DomainRelay {
  const DomainRelay({
    required this.domainId,
    required this.transport,
    this.host = '',
    this.port,
    this.tlsMode,
    this.username = '',
    this.passwordSet = false,
  });

  factory DomainRelay.fromJson(Map<String, dynamic> json) => DomainRelay(
    domainId: _int(json['domain_id'] ?? 0),
    transport: OutboundTransport.parse(json['transport']),
    host: json['host'] as String? ?? '',
    port: switch (json['port']) {
      final num port when port > 0 => port.toInt(),
      _ => null,
    },
    tlsMode: RelayTlsMode.parse(json['tls_mode']),
    username: json['username'] as String? ?? '',
    passwordSet: json['password_set'] == true,
  );

  final int domainId;
  final OutboundTransport transport;

  /// The relay's host name or IP address; empty for direct.
  final String host;
  final int? port;
  final RelayTlsMode? tlsMode;

  /// Empty when the relay takes mail without signing in.
  final String username;

  /// Whether the server holds a password for [username].
  final bool passwordSet;
}

/// A recipient the server no longer sends a domain's mail to, because
/// mail to them bounced for good. It lapses at [expiresAt].
class Suppression {
  const Suppression({
    required this.id,
    required this.domainId,
    required this.address,
    this.reason = '',
    this.failureCategory = '',
    this.lastError = '',
    this.messageId,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
  });

  factory Suppression.fromJson(Map<String, dynamic> json) => Suppression(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    address: json['address'] as String? ?? '',
    reason: json['reason'] as String? ?? '',
    failureCategory: json['failure_category'] as String? ?? '',
    lastError: json['last_error'] as String? ?? '',
    messageId: switch (json['message_id']) {
      final num id => id.toInt(),
      _ => null,
    },
    createdAt: _time(json['created_at']),
    updatedAt: _time(json['updated_at']),
    expiresAt: _time(json['expires_at']),
  );

  final int id;
  final int domainId;

  /// The recipient, lower-cased.
  final String address;

  /// Why: `hard_bounce`.
  final String reason;

  /// What the bounce said was wrong: `bad_mailbox` or `bad_domain`.
  final String failureCategory;

  /// The remote server's reply.
  final String lastError;

  /// The sent message whose bounce suppressed the address, when known.
  final int? messageId;
  final DateTime? createdAt;

  /// When it last bounced.
  final DateTime? updatedAt;
  final DateTime? expiresAt;
}
