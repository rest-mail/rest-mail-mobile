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
    'admin.section.queue.title',
    'admin.section.queue.subtitle',
    read: Capability.queueRead,
    write: Capability.queueManage,
    delete: Capability.queueManage,
  ),
  domains(
    'health.domains',
    'admin.section.domains.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsDelete,
  ),
  mailboxes(
    'health.mailboxes',
    'admin.section.mailboxes.subtitle',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),
  aliases(
    'admin.section.aliases.title',
    'admin.section.aliases.subtitle',
    read: Capability.mailboxesRead,
    write: Capability.mailboxesWrite,
    delete: Capability.mailboxesDelete,
  ),

  bans(
    'admin.section.bans.title',
    'admin.section.bans.subtitle',
    read: Capability.bansRead,
    write: Capability.bansWrite,
    delete: Capability.bansDelete,
  ),

  /// Who holds which role, and where. The server removes a grant with
  /// `users:write`, not `users:delete`, and checks each change against what
  /// the granter holds itself.
  permissions(
    'admin.section.permissions.title',
    'admin.section.permissions.subtitle',
    read: Capability.usersRead,
    write: Capability.usersWrite,
    delete: Capability.usersWrite,
  ),

  overview.readOnly(
    'admin.section.overview.title',
    'admin.section.overview.subtitle',
    // GET /admin/stats needs domains:read.
    read: Capability.domainsRead,
  ),
  deliveryLog.readOnly(
    'admin.section.deliveryLog.title',
    'admin.section.deliveryLog.subtitle',
    read: Capability.messagesRead,
    group: AdminGroup.logs,
  ),

  /// What went through, from the audit log, so under `audit:read` too.
  activity.readOnly(
    'admin.section.activity.title',
    'admin.section.activity.subtitle',
    read: Capability.auditRead,
    group: AdminGroup.logs,
  ),
  trace.readOnly(
    'admin.section.trace.title',
    'admin.section.trace.subtitle',
    read: Capability.observabilityRead,
    group: AdminGroup.logs,
  ),

  /// The log is the pipelines', under `pipelines:read`; its analytics are
  /// observability, as message traces are.
  pipelineLog.readOnly(
    'admin.section.pipelineLog.title',
    'admin.section.pipelineLog.subtitle',
    read: Capability.pipelinesRead,
    group: AdminGroup.logs,
  ),
  pipelineAnalytics.readOnly(
    'admin.section.pipelineAnalytics.title',
    'admin.section.pipelineAnalytics.subtitle',
    read: Capability.observabilityRead,
    group: AdminGroup.logs,
  ),
  tlsReports.readOnly(
    'admin.section.tlsReports.title',
    'admin.section.tlsReports.subtitle',
    read: Capability.domainsRead,
    group: AdminGroup.logs,
  ),
  audit.readOnly(
    'admin.section.audit.title',
    'admin.section.audit.subtitle',
    read: Capability.auditRead,
    group: AdminGroup.logs,
  ),

  /// The server removes a key with `domains:write`, not `domains:delete`.
  dkim(
    'admin.section.dkim.title',
    'admin.section.dkim.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.setup,
  ),

  /// As with DKIM keys, a certificate goes with `domains:write`.
  certificates(
    'admin.section.certificates.title',
    'admin.section.certificates.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.setup,
  ),
  pipelines(
    'admin.section.pipelines.title',
    'admin.section.pipelines.subtitle',
    read: Capability.pipelinesRead,
    write: Capability.pipelinesWrite,
    delete: Capability.pipelinesDelete,
    group: AdminGroup.setup,
  ),
  customFilters(
    'admin.section.customFilters.title',
    'admin.section.customFilters.subtitle',
    read: Capability.pipelinesRead,
    write: Capability.pipelinesWrite,
    delete: Capability.pipelinesDelete,
    group: AdminGroup.setup,
  ),

  /// The DNS check, sender lists and MTA-STS are each about one domain, so
  /// they are opened from it. The server reads them with `domains:read`,
  /// and removes a sender or a policy with `domains:write`, not
  /// `domains:delete`.
  domainDkim(
    'admin.section.domainDkim.title',
    'admin.section.domainDkim.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  dnsCheck.readOnly(
    'admin.section.dnsCheck.title',
    'admin.section.dnsCheck.subtitle',
    read: Capability.domainsRead,
    group: AdminGroup.domain,
  ),
  senderLists(
    'admin.section.senderLists.title',
    'admin.section.senderLists.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  mtaSts(
    'admin.section.mtaSts.title',
    'admin.section.mtaSts.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  relay(
    'admin.relay.outgoingMail',
    'admin.section.relay.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  ),
  suppressions(
    'admin.suppressions.suppressedRecipients',
    'admin.section.suppressions.subtitle',
    read: Capability.domainsRead,
    write: Capability.domainsWrite,
    delete: Capability.domainsWrite,
    group: AdminGroup.domain,
  );

  const AdminSection(
    this.titleKey,
    this.subtitleKey, {
    required this.read,
    required this.write,
    required this.delete,
    this.group = AdminGroup.manage,
  });

  /// Only to look at: nothing in it changes.
  const AdminSection.readOnly(
    this.titleKey,
    this.subtitleKey, {
    required this.read,
    this.group = AdminGroup.manage,
  }) : write = read,
       delete = read;

  final String titleKey;
  final String subtitleKey;
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
  logs('admin.group.logs'),
  setup('admin.group.setup'),

  /// In a domain's own screen, not in Administration's list.
  domain(null);

  const AdminGroup(this.titleKey);

  /// None for the first, which needs none.
  final String? titleKey;
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
