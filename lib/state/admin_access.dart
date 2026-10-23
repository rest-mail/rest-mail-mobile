import 'package:restmail_api/restmail_api.dart';

/// A part of the server's administration, and the capabilities it takes: one
/// to see it, one to change what is in it, one to delete. This table is the
/// only place the app decides who sees what in Administration, by the
/// server's capability names. The screens ask [AdminAccess]; the
/// capabilities come with the account's session, from the grants it holds.
///
/// Hiding is for comfort: the server checks every request, and the app shows
/// its 403 for what it is.
enum AdminSection {
  queue(
    'Outbound queue',
    'Mail waiting to go to other servers',
    read: Capability.queueRead,
    write: Capability.queueManage,
    delete: Capability.queueManage,
  ),
  domains(
    'Domains',
    'The domains this server holds mail for',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsDelete,
  ),
  mailboxes(
    'Mailboxes',
    'Who has mail here',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),
  aliases(
    'Aliases',
    'Addresses that deliver to another',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),

  bans(
    'Bans',
    'Addresses kept out of SMTP, IMAP and POP3',
    read: Capability.bansRead,
    write: Capability.bansWrite,
    delete: Capability.bansDelete,
  ),

  /// Who holds which role, and where. The server removes a grant with
  /// `users:write`, not `users:delete`, and checks each change against what
  /// the granter holds itself.
  permissions(
    'Permissions',
    'Who holds which role, and where',
    read: Capability.usersRead,
    write: Capability.usersWrite,
    delete: Capability.usersWrite,
  ),

  overview.readOnly(
    'Overview',
    'Mail volume, the queue and TLS at a glance',
    // GET /admin/stats needs domains:read.
    read: Capability.domainsRead,
  ),
  deliveryLog.readOnly(
    'Delivery log',
    'What went out to other servers, and how it went',
    read: Capability.messagesRead,
    group: AdminGroup.logs,
  ),

  /// What went through, from the audit log, so under `audit:read` too.
  activity.readOnly(
    'Activity',
    'What was done on the server, and by whom',
    read: Capability.auditRead,
    group: AdminGroup.logs,
  ),
  trace.readOnly(
    'Message trace',
    'Each filter a message went through',
    read: Capability.observabilityRead,
    group: AdminGroup.logs,
  ),

  /// The log is the pipelines', under `pipelines:read`; its analytics are
  /// observability, as message traces are.
  pipelineLog.readOnly(
    'Pipeline log',
    'Each message the filters handled, and how it ended',
    read: Capability.pipelinesRead,
    group: AdminGroup.logs,
  ),
  pipelineAnalytics.readOnly(
    'Pipeline analytics',
    'What the filters did with a day or a week of mail',
    read: Capability.observabilityRead,
    group: AdminGroup.logs,
  ),
  tlsReports.readOnly(
    'TLS reports',
    'How other servers fare reaching this one over TLS',
    read: Capability.domainsRead,
    group: AdminGroup.logs,
  ),
  audit.readOnly(
    'Audit log',
    'Every sign-in and change, chained so tampering shows',
    read: Capability.auditRead,
    group: AdminGroup.logs,
  ),

  /// The server removes a key with `domains:write`, not `domains:delete`.
  dkim(
    'DKIM keys',
    'The keys mail from each domain is signed with',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.setup,
  ),

  /// As with DKIM keys, a certificate goes with `domains:write`.
  certificates(
    'Certificates',
    'The TLS certificates each domain is served with',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.setup,
  ),
  pipelines(
    'Pipelines',
    'The filters mail goes through, in order',
    read: Capability.pipelinesRead,
    write: Capability.pipelinesWrite,
    delete: Capability.pipelinesDelete,
    group: AdminGroup.setup,
  ),
  customFilters(
    'Custom filters',
    'Filters written for this server',
    read: Capability.pipelinesRead,
    write: Capability.pipelinesWrite,
    delete: Capability.pipelinesDelete,
    group: AdminGroup.setup,
  ),

  /// The DNS check, sender lists and MTA-STS are each about one domain, so
  /// they are opened from it. The server reads them with `domains:read`,
  /// and removes a sender or a policy with `domains:write`, not
  /// `domains:delete`.
  dnsCheck.readOnly(
    'DNS check',
    'Which records are right, and which are missing',
    read: Capability.domainsRead,
    group: AdminGroup.domain,
  ),
  senderLists(
    'Sender lists',
    'Senders turned away, and senders let in',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  mtaSts(
    'MTA-STS',
    'Whether other servers must send here over TLS',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  relay(
    'Outgoing mail',
    'Sent straight to other servers, or through a relay',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  suppressions(
    'Suppressed recipients',
    'Addresses no longer sent to, after mail to them bounced',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  );

  const AdminSection(
    this.title,
    this.subtitle, {
    required this.read,
    required this.write,
    required this.delete,
    this.group = AdminGroup.manage,
  });

  /// Only to look at: nothing in it changes.
  const AdminSection.readOnly(
    this.title,
    this.subtitle, {
    required this.read,
    this.group = AdminGroup.manage,
  }) : write = read,
       delete = read;

  final String title;
  final String subtitle;
  final AdminGroup group;

  /// To see the section at all.
  final String read;

  /// To add and change what is in it; for the queue, to retry and bounce.
  final String write;

  /// To delete what is in it.
  final String delete;
}

/// Where a section sits in Administration, under its heading.
enum AdminGroup {
  /// Mail, the people who have it, and bans: what a phone is for.
  manage(null),
  logs('Logs and reports'),
  setup('Signing and filtering'),

  /// In a domain's own screen, not in Administration's list.
  domain(null);

  const AdminGroup(this.title);

  /// None for the first, which needs none.
  final String? title;
}

/// What a session's capabilities let it see and do in Administration.
class AdminAccess {
  const AdminAccess(this.capabilities, {this.scope, this.collection = false});

  final Capabilities capabilities;
  final String? scope;
  final bool collection;

  bool canRead(AdminSection section) {
    if (collection || scope == null) return canList(section);
    if (_resourceSection(section)) {
      return capabilities.allows(section.read, scope: scope!);
    }
    return capabilities.allows(section.read);
  }

  /// Lists return only resources at scopes the session holds. A mailbox grant
  /// may list its mailbox, but cannot list domains or aliases of its parent.
  bool canList(AdminSection section) => switch (section) {
    AdminSection.domains ||
    AdminSection.aliases => capabilities.allowsSomewhere(
      section.read,
      within: scope,
      domainsOnly: true,
    ),
    AdminSection.mailboxes => capabilities.allowsSomewhere(
      section.read,
      within: scope,
    ),
    _ =>
      scope != null && section.group == AdminGroup.domain
          ? capabilities.allows(section.read, scope: scope!)
          : capabilities.allows(section.read),
  };

  bool canWrite(AdminSection section) {
    // Relay transport is installation configuration even on a domain URL.
    if (section == AdminSection.relay) {
      return capabilities.allows(section.write);
    }
    if (scope != null && !collection && _resourceSection(section)) {
      return capabilities.allows(section.write, scope: scope!);
    }
    // Adding a mailbox/alias needs a covering domain, not an existing mailbox.
    if (section == AdminSection.mailboxes || section == AdminSection.aliases) {
      if (scope != null) {
        return capabilities.allows(section.write, scope: scope!);
      }
      return capabilities.allowsSomewhere(section.write, domainsOnly: true);
    }
    if (scope != null && section.group == AdminGroup.domain) {
      return capabilities.allows(section.write, scope: scope!);
    }
    return capabilities.allows(section.write);
  }

  bool canDelete(AdminSection section) {
    if (section == AdminSection.relay) {
      return capabilities.allows(section.delete);
    }
    if (scope != null && _resourceSection(section)) {
      return capabilities.allows(section.delete, scope: scope!);
    }
    return capabilities.allows(section.delete);
  }

  static bool _resourceSection(AdminSection section) =>
      section == AdminSection.domains ||
      section == AdminSection.mailboxes ||
      section == AdminSection.aliases ||
      section.group == AdminGroup.domain;

  List<AdminSection> get sections => [
    for (final section in AdminSection.values)
      if (section.group != AdminGroup.domain && canRead(section)) section,
  ];

  List<AdminSection> get domainSections => [
    for (final section in AdminSection.values)
      if (section.group == AdminGroup.domain && canRead(section)) section,
  ];

  bool get any => sections.isNotEmpty;
}
