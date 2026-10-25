import 'dart:async';

import '../../l10n/voice.dart';

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
import 'keys_screen.dart';
import 'mta_sts_screen.dart';
import 'relay_screen.dart';
import 'sender_lists_screen.dart';
import 'suppressions_screen.dart';

/// The `server_type` values a domain may have, with what they mean.
const serverTypes = [
  ('restmail', 'REST Mail'),
  ('traditional', 'admin.domains.postfixAndDovecot'),
];

/// The `sending_policy` values a domain may have; empty is no rule.
const sendingPolicies = [
  ('', 'interface.none'),
  ('transactional', 'admin.domains.transactional'),
  ('bulk', 'admin.domains.bulk'),
];

/// The `dmarc_policy` values a domain's DMARC record may ask for, mildest
/// first.
const dmarcPolicies = [
  ('none', 'admin.domains.noneReportsOnly'),
  ('quarantine', 'mailboxes.quarantine'),
  ('reject', 'admin.domains.reject'),
];

String _choiceLabel(
  BuildContext context,
  List<(String, String)> choices,
  String value,
) {
  final choice = choices.where((choice) => choice.$1 == value).firstOrNull;
  return choice == null ? value : tr(context, choice.$2);
}

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
        title: tr(context, 'admin.domains.addADomain'),
        intro: trArgs(context, 'admin.domains.pointItsMXRecordAtHostFor', {
          'host': (_host).toString(),
        }),
        fields: [
          AdminField(
            tr(context, 'admin.aliases.domain'),
            hint: 'example.com',
            email: true,
          ),
          AdminField(
            tr(context, 'admin.domains.mailKeptBy'),
            initial: 'restmail',
            choices: [
              for (final (value, key) in serverTypes) (value, tr(context, key)),
            ],
          ),
          AdminField(
            tr(context, 'admin.domains.sendingPolicy'),
            choices: [
              for (final (value, key) in sendingPolicies)
                (value, tr(context, key)),
            ],
          ),
          AdminField(
            tr(context, 'admin.domains.mailboxSizeInMB'),
            hint: tr(context, 'admin.domains.theServerDefault'),
            number: true,
            optional: true,
          ),
        ],
        action: tr(context, 'admin.domains.addDomain'),
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
    title: tr(context, 'health.domains'),
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: tr(context, 'admin.domains.noDomainsYet'),
      header: [
        if (access.canWrite(AdminSection.domains))
          AdminAddButton(
            label: tr(context, 'admin.domains.addADomain'),
            onTap: () => unawaited(_add()),
          ),
      ],
      row: (domain) => RmRow(
        label: domain.name,
        subtitle: domain.active
            ? tr(context, 'admin.domains.receivingMail')
            : tr(context, 'twoFactor.off'),
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
    AdminSection.domainDkim => DkimScreen(
      account: widget.account,
      domain: _domain,
    ),
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
        title: tr(context, 'admin.domains.mailboxSize'),
        intro: trArgs(context, 'admin.domains.theStorageEachNewMailboxOnName', {
          'name': (_domain.name).toString(),
        }),
        fields: [
          AdminField(
            tr(context, 'admin.domains.mailboxSizeInMB'),
            initial: '${_domain.defaultQuotaBytes ~/ (1024 * 1024)}',
            number: true,
          ),
        ],
        action: tr(context, 'common.save'),
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
        title: tr(context, 'admin.domains.sendingPolicy'),
        fields: [
          AdminField(
            tr(context, 'admin.domains.sendingPolicy'),
            initial: _domain.sendingPolicy,
            choices: [
              for (final (value, key) in sendingPolicies)
                (value, tr(context, key)),
            ],
          ),
        ],
        action: tr(context, 'common.save'),
        host: _host,
        submit: (values) async => _domain = await widget.account.client
            .updateDomain(_domain.id, sendingPolicy: values[0]),
      ),
    );
    if (mounted) setState(() {});
  }

  /// Picks the policy, then sends it: reject, for a domain whose mail is not
  /// only transactional, once the RFC 9989 §7.4 warning is accepted.
  Future<void> _editDMARC() async {
    String? chosen;
    final picked = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.domains.dmarcPolicy'),
        intro: trArgs(context, 'admin.domains.whatNameSDMARCRecordAsksOther', {
          'name': (_domain.name).toString(),
        }),
        fields: [
          AdminField(
            tr(context, 'admin.domains.dmarcPolicy'),
            initial: _domain.dmarcPolicy,
            choices: [
              for (final (value, key) in dmarcPolicies)
                (value, tr(context, key)),
            ],
          ),
        ],
        action: tr(context, 'common.save'),
        host: _host,
        submit: (values) async => chosen = values[0],
      ),
    );
    final policy = chosen;
    if (!mounted || !picked || policy == null) return;
    if (policy == _domain.dmarcPolicy) return;
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      confirm: policy == 'reject' && _domain.sendingPolicy != 'transactional'
          ? (
              title: tr(context, 'admin.domains.rejectFailingMail'),
              message: trArgs(
                context,
                'admin.domains.peopleWhoWriteOrdinaryMailFromName',
                {'name': (_domain.name).toString()},
              ),
              action: tr(context, 'admin.domains.reject'),
            )
          : null,
      change: () async => _domain = await widget.account.client.updateDomain(
        _domain.id,
        dmarcPolicy: policy,
      ),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final name = _domain.name;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteDomain(_domain.id),
      confirm: (
        title: trArgs(context, 'folders.deleteTitle', {
          'name': (name).toString(),
        }),
        message: tr(context, 'admin.domains.theServerStopsTakingMailForIt'),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(
        context,
        trArgs(context, 'admin.domains.deletedName', {
          'name': (name).toString(),
        }),
      );
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
                  label: tr(context, 'admin.domains.receivingMail'),
                  value: access.canWrite(AdminSection.domains)
                      ? null
                      : (domain.active
                            ? tr(context, 'twoFactor.on')
                            : tr(context, 'twoFactor.off')),
                  trailing: access.canWrite(AdminSection.domains)
                      ? RmSwitch(
                          value: domain.active,
                          label: tr(context, 'admin.domains.receivingMail'),
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
                RmRow(
                  label: tr(context, 'admin.domains.mailKeptBy'),
                  value: _choiceLabel(context, serverTypes, domain.serverType),
                ),
                RmRow(
                  label: tr(context, 'admin.domains.mailboxSize'),
                  value: sizeLabel(domain.defaultQuotaBytes),
                  onTap: access.canWrite(AdminSection.domains) && !_busy
                      ? () => unawaited(_editQuota())
                      : null,
                ),
                RmRow(
                  label: tr(context, 'admin.domains.sendingPolicy'),
                  value: _choiceLabel(
                    context,
                    sendingPolicies,
                    domain.sendingPolicy,
                  ),
                  onTap: access.canWrite(AdminSection.domains) && !_busy
                      ? () => unawaited(_editPolicy())
                      : null,
                ),
                RmRow(
                  label: tr(context, 'admin.domains.dmarcPolicy'),
                  value: _choiceLabel(
                    context,
                    dmarcPolicies,
                    domain.dmarcPolicy,
                  ),
                  onTap: access.canWrite(AdminSection.domains) && !_busy
                      ? () => unawaited(_editDMARC())
                      : null,
                ),
                if (domain.dkimSelector.isNotEmpty)
                  RmRow(
                    label: tr(context, 'admin.domains.dkimSelector'),
                    value: domain.dkimSelector,
                  ),
                if (domain.createdAt case final at?)
                  RmRow(
                    label: tr(context, 'admin.aliases.added'),
                    value: longDate(at),
                  ),
                if (domain.updatedAt case final at?)
                  RmRow(
                    label: tr(context, 'admin.domains.changed'),
                    value: longDate(at),
                  ),
              ],
            ),
            if (access.canList(AdminSection.mailboxes) ||
                access.canList(AdminSection.aliases)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  if (access.canList(AdminSection.mailboxes))
                    RmRow(
                      label: tr(context, 'health.mailboxes'),
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
                      label: tr(context, 'admin.section.aliases.title'),
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
                        label: tr(context, section.titleKey),
                        subtitle: tr(context, section.subtitleKey),
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
                    label: tr(context, 'admin.domains.deleteDomain'),
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
