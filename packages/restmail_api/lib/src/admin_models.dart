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

/// Something done on the server, as its activity log has it.
class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.actor,
    required this.action,
    required this.resourceType,
    required this.createdAt,
    this.resourceId,
    this.detail = '',
    this.ip = '',
  });

  factory ActivityEntry.fromJson(Map<String, dynamic> json) => ActivityEntry(
    id: _int(json['id']),
    actor: json['actor'] as String? ?? '',
    action: json['action'] as String? ?? '',
    resourceType: json['resource_type'] as String? ?? '',
    resourceId: (json['resource_id'] as num?)?.toInt(),
    detail: json['detail'] as String? ?? '',
    ip: json['ip'] as String? ?? '',
    createdAt: _time(json['created_at']) ?? DateTime.now(),
  );

  final int id;

  /// Who did it: an admin's username, a mailbox's address, or `system`.
  final String actor;
  final String action;

  /// What it was done to, `domain` or `mailbox` say, and which one.
  final String resourceType;
  final int? resourceId;
  final String detail;
  final String ip;
  final DateTime createdAt;
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

  /// `mailbox`, `admin`, `system` or `anonymous`.
  final String actorKind;
  final int? actorId;

  /// The address or username at the time.
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
  });

  factory DkimKey.fromJson(Map<String, dynamic> json) => DkimKey(
    domainId: _int(json['domain_id']),
    domain: json['domain'] as String? ?? '',
    selector: json['selector'] as String? ?? '',
    hasKey: json['has_key'] as bool? ?? false,
  );

  final int domainId;
  final String domain;

  /// Where the public key is published: `<selector>._domainkey.<domain>`.
  final String selector;
  final bool hasKey;
}

/// A TLS certificate the server holds for one of its domains. The server
/// never shows its private key.
class TlsCertificate {
  const TlsCertificate({
    required this.id,
    required this.domainId,
    required this.issuer,
    required this.notBefore,
    required this.notAfter,
    this.domain = '',
    this.autoRenew = false,
  });

  factory TlsCertificate.fromJson(Map<String, dynamic> json) => TlsCertificate(
    id: _int(json['id']),
    domainId: _int(json['domain_id'] ?? 0),
    domain: switch (json['domain']) {
      {'name': final String name} => name,
      _ => '',
    },
    issuer: json['issuer'] as String? ?? '',
    notBefore: _time(json['not_before']) ?? DateTime.now(),
    notAfter: _time(json['not_after']) ?? DateTime.now(),
    autoRenew: json['auto_renew'] as bool? ?? false,
  );

  final int id;
  final int domainId;

  /// Its domain's name, when the server sent it along.
  final String domain;
  final String issuer;
  final DateTime notBefore;
  final DateTime notAfter;

  /// Whether the server renews it before it runs out.
  final bool autoRenew;
}

/// One filter in a pipeline.
class PipelineFilter {
  const PipelineFilter({
    required this.name,
    required this.type,
    required this.enabled,
    this.unskippable = false,
  });

  factory PipelineFilter.fromJson(Map<String, dynamic> json) => PipelineFilter(
    name: json['name'] as String? ?? '',
    type: json['type'] as String? ?? '',
    enabled: json['enabled'] as bool? ?? false,
    unskippable: json['unskippable'] as bool? ?? false,
  );

  final String name;

  /// `action`, which may stop a message, or `transform`, which changes it.
  final String type;
  final bool enabled;

  /// Runs even when an earlier filter would skip the rest.
  final bool unskippable;
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
  );

  final int id;
  final int domainId;

  /// `inbound` or `outbound`.
  final String direction;
  final bool active;
  final List<PipelineFilter> filters;
  final DateTime? updatedAt;
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
}

int _int(Object? value) => (value as num).toInt();

/// A timestamp, or null for none. Go writes an unset time as year 1.
DateTime? _time(Object? value) {
  if (value is! String || value.isEmpty) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null || parsed.year < 1971) return null;
  return parsed.toLocal();
}
