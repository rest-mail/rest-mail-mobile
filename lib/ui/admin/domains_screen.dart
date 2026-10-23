import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'aliases_screen.dart';
import 'dns_check_screen.dart';
import 'mailboxes_screen.dart';
import 'mta_sts_screen.dart';
import 'relay_screen.dart';
import 'sender_lists_screen.dart';
import 'suppressions_screen.dart';

/// The `server_type` values a domain may have, with what they mean.
const serverTypes = [
  ('restmail', 'REST Mail'),
  ('traditional', 'Postfix and Dovecot'),
];

/// The `sending_policy` values a domain may have; empty is no rule.
const sendingPolicies = [
  ('', 'None'),
  ('transactional', 'Transactional'),
  ('bulk', 'Bulk'),
];

String _choiceLabel(List<(String, String)> choices, String value) =>
    choices.firstWhere((c) => c.$1 == value, orElse: () => (value, value)).$2;

/// The domains the server holds mail for.
class DomainsScreen extends StatefulWidget {
  const DomainsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<DomainsScreen> createState() => _DomainsScreenState();
}

class _DomainsScreenState extends State<DomainsScreen> {
  late final _list = AdminList<AdminDomain>(
    (offset) => widget.account.client.domains(offset: offset),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.domains)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    AdminDomain? created;
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Add a domain',
        intro:
            'Point its MX record at $_host for mail to arrive. A new domain '
            'starts off; turn it on once it is ready.',
        fields: const [
          AdminField('Domain', hint: 'example.com', email: true),
          AdminField('Mail kept by', initial: 'restmail', choices: serverTypes),
          AdminField('Sending policy', choices: sendingPolicies),
          AdminField(
            'Mailbox size in MB',
            hint: 'The server default',
            number: true,
            optional: true,
          ),
        ],
        action: 'Add domain',
        host: _host,
        submit: (values) async =>
            created = await widget.account.client.createDomain(
              values[0].toLowerCase(),
              serverType: values[1],
              sendingPolicy: values[2],
              defaultQuotaBytes: megabytes(values[3]),
            ),
      ),
    );
    if (!mounted || !added) return;
    if (created case final domain?) {
      await _open(domain);
    } else {
      unawaited(_list.reload());
    }
  }

  Future<void> _open(AdminDomain domain) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => DomainScreen(account: widget.account, domain: domain),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.domains,
    title: 'Domains',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No domains yet.',
      header: [
        if (access.canWrite(AdminSection.domains))
          AdminAddButton(label: 'Add a domain', onTap: () => unawaited(_add())),
      ],
      row: (domain) => RmRow(
        label: domain.name,
        subtitle: domain.active ? 'Receiving mail' : 'Off',
        onTap: () => unawaited(_open(domain)),
      ),
    ),
  );
}

/// One domain: whether it takes mail, and the way to its mailboxes and
/// aliases, its DNS check, sender lists and MTA-STS policy.
class DomainScreen extends StatefulWidget {
  const DomainScreen({super.key, required this.account, required this.domain});

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<DomainScreen> createState() => _DomainScreenState();
}

class _DomainScreenState extends State<DomainScreen> {
  late var _domain = widget.domain;
  var _busy = false;
  var _loaded = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(widget.domain.name),
    ).canRead(AdminSection.domains)) {
      unawaited(_reload());
    }
  }

  Future<void> _reload() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _loaded = false;
      _loadError = null;
    });
    try {
      final fresh = await widget.account.client.domain(widget.domain.id);
      if (!mounted) return;
      setState(() {
        _domain = fresh;
        _loaded = true;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String get _host => widget.account.server.host;

  /// The screen for one of [AdminAccess.domainSections].
  Widget? _screenFor(AdminSection section) => switch (section) {
    AdminSection.dnsCheck => DnsCheckScreen(
      account: widget.account,
      domain: _domain,
    ),
    AdminSection.senderLists => SenderListsScreen(
      account: widget.account,
      domain: _domain,
    ),
    AdminSection.mtaSts => MtaStsScreen(
      account: widget.account,
      domain: _domain,
    ),
    AdminSection.relay => RelayScreen(account: widget.account, domain: _domain),
    AdminSection.suppressions => SuppressionsScreen(
      account: widget.account,
      domain: _domain,
    ),
    _ => null,
  };

  Future<void> _setActive(bool active) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async => _domain = await widget.account.client.updateDomain(
        _domain.id,
        active: active,
      ),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _editQuota() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Mailbox size',
        intro: 'The storage each new mailbox on ${_domain.name} gets.',
        fields: [
          AdminField(
            'Mailbox size in MB',
            initial: '${_domain.defaultQuotaBytes ~/ (1024 * 1024)}',
            number: true,
          ),
        ],
        action: 'Save',
        host: _host,
        submit: (values) async => _domain = await widget.account.client
            .updateDomain(_domain.id, defaultQuotaBytes: megabytes(values[0])),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _editPolicy() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Sending policy',
        fields: [
          AdminField(
            'Sending policy',
            initial: _domain.sendingPolicy,
            choices: sendingPolicies,
          ),
        ],
        action: 'Save',
        host: _host,
        submit: (values) async => _domain = await widget.account.client
            .updateDomain(_domain.id, sendingPolicy: values[0]),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final name = _domain.name;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteDomain(_domain.id),
      confirm: (
        title: 'Delete $name?',
        message:
            'The server stops taking mail for it. Its mailboxes and aliases '
            'have to go first.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted $name');
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final domain = _domain;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.domains,
      title: domain.name,
      body: (access) => AdminDetailBody(
        ready: _loaded,
        error: _loadError,
        host: _host,
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            RmGroup(
              children: [
                RmRow(
                  label: 'Receiving mail',
                  value: access.canWrite(AdminSection.domains)
                      ? null
                      : (domain.active ? 'On' : 'Off'),
                  trailing: access.canWrite(AdminSection.domains)
                      ? RmSwitch(
                          value: domain.active,
                          label: 'Receiving mail',
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
                RmRow(
                  label: 'Mail kept by',
                  value: _choiceLabel(serverTypes, domain.serverType),
                ),
                RmRow(
                  label: 'Mailbox size',
                  value: sizeLabel(domain.defaultQuotaBytes),
                  onTap: access.canWrite(AdminSection.domains) && !_busy
                      ? () => unawaited(_editQuota())
                      : null,
                ),
                RmRow(
                  label: 'Sending policy',
                  value: _choiceLabel(sendingPolicies, domain.sendingPolicy),
                  onTap: access.canWrite(AdminSection.domains) && !_busy
                      ? () => unawaited(_editPolicy())
                      : null,
                ),
                if (domain.dkimSelector.isNotEmpty)
                  RmRow(label: 'DKIM selector', value: domain.dkimSelector),
                if (domain.createdAt case final at?)
                  RmRow(label: 'Added', value: longDate(at)),
                if (domain.updatedAt case final at?)
                  RmRow(label: 'Changed', value: longDate(at)),
              ],
            ),
            if (access.canList(AdminSection.mailboxes) ||
                access.canList(AdminSection.aliases)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  if (access.canList(AdminSection.mailboxes))
                    RmRow(
                      label: 'Mailboxes',
                      onTap: () => pushScreen(
                        context,
                        MailboxesScreen(
                          account: widget.account,
                          domain: domain,
                        ),
                      ),
                    ),
                  if (access.canList(AdminSection.aliases))
                    RmRow(
                      label: 'Aliases',
                      onTap: () => pushScreen(
                        context,
                        AliasesScreen(account: widget.account, domain: domain),
                      ),
                    ),
                ],
              ),
            ],
            if (access.domainSections.isNotEmpty) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  for (final section in access.domainSections)
                    if (_screenFor(section) case final screen?)
                      RmRow(
                        label: section.title,
                        subtitle: section.subtitle,
                        onTap: () => pushScreen(context, screen),
                      ),
                ],
              ),
            ],
            if (access.canDelete(AdminSection.domains)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Delete domain',
                    danger: true,
                    onTap: _busy ? null : () => unawaited(_delete()),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
