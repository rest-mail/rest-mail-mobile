import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_scope.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _storage(BuildContext context, AdminMailbox box) => box.quotaBytes > 0
    ? trArgs(context, 'ui.valueOfValue2', {
        'value': (sizeLabel(box.quotaUsedBytes)).toString(),
        'value2': (sizeLabel(box.quotaBytes)).toString(),
      })
    : sizeLabel(box.quotaUsedBytes);

/// The mailboxes on the server, or on one [domain].
class MailboxesScreen extends StatefulWidget {
  const MailboxesScreen({super.key, required this.account, this.domain});

  final RestAccount account;
  final AdminDomain? domain;

  @override
  State<MailboxesScreen> createState() => _MailboxesScreenState();
}

class _MailboxesScreenState extends State<MailboxesScreen> {
  late final _list = AdminList<AdminMailbox>(
    (offset) => widget.account.client.mailboxes(
      domainId: widget.domain?.id,
      offset: offset,
    ),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: widget.domain == null
          ? null
          : CapabilityScope.domain(widget.domain!.name),
      collection: true,
    ).canRead(AdminSection.mailboxes)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final domain = widget.domain?.name;
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.mailboxes.addAMailbox'),
        intro: tr(context, 'admin.mailboxes.onADomainThisServerHostsAccounts'),
        fields: [
          AdminField(
            tr(context, 'contacts.address'),
            hint: 'someone@${domain ?? 'example.com'}',
            email: true,
          ),
          AdminField(tr(context, 'folders.name'), optional: true),
          AdminField(
            tr(context, 'signIn.password'),
            obscure: true,
            optional: true,
          ),
        ],
        action: tr(context, 'admin.mailboxes.addMailbox'),
        host: _host,
        submit: (values) => widget.account.client.createAccount(
          address: values[0].toLowerCase(),
          displayName: values[1].isEmpty ? null : values[1],
          password: values[2].isEmpty ? null : values[2],
        ),
      ),
    );
    if (!added || !mounted) return;
    unawaited(_list.reload());
    // The creator owns it: it joins the account's mailboxes at once.
    final app = AppScope.read(context);
    if (identical(app.current, widget.account)) {
      unawaited(app.mailbox?.reloadAccounts());
    }
  }

  Future<void> _open(AdminMailbox mailbox) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AdminMailboxScreen(account: widget.account, mailbox: mailbox),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final domain = widget.domain;
    return AdminPage(
      scope: widget.domain == null
          ? null
          : CapabilityScope.domain(widget.domain!.name),
      collection: true,
      account: widget.account,
      section: AdminSection.mailboxes,
      title: tr(context, 'health.mailboxes'),
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: tr(context, 'admin.mailboxes.noMailboxesYet'),
        header: [
          if (domain != null) ...[
            Text(
              trArgs(context, 'admin.aliases.onName', {
                'name': (domain.name).toString(),
              }),
              style: rmText(13, color: c.ink3),
            ),
            const SizedBox(height: 12),
          ],
          if (access.canWrite(AdminSection.mailboxes))
            AdminAddButton(
              label: tr(context, 'admin.mailboxes.addAMailbox'),
              onTap: () => unawaited(_add()),
            ),
        ],
        row: (box) => RmRow(
          label: box.address,
          subtitle: [
            if (box.displayName.isNotEmpty) box.displayName,
            if (!box.active) tr(context, 'twoFactor.off'),
            _storage(context, box),
          ].join(' · '),
          onTap: () => unawaited(_open(box)),
        ),
      ),
    );
  }
}

/// One mailbox, as an admin sees it: who it is, whether it may sign in, and
/// a new password when its owner has lost theirs.
class AdminMailboxScreen extends StatefulWidget {
  const AdminMailboxScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final AdminMailbox mailbox;

  @override
  State<AdminMailboxScreen> createState() => _AdminMailboxScreenState();
}

class _AdminMailboxScreenState extends State<AdminMailboxScreen> {
  late var _mailbox = widget.mailbox;
  var _busy = false;
  var _loaded = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.mailbox(widget.mailbox.address),
    ).canRead(AdminSection.mailboxes)) {
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
      final fresh = await widget.account.client.adminMailbox(widget.mailbox.id);
      if (!mounted) return;
      setState(() {
        _mailbox = fresh;
        _loaded = true;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String get _host => widget.account.server.host;
  RestmailClient get _client => widget.account.client;

  Future<void> _setActive(bool active) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async =>
          _mailbox = await _client.updateMailbox(_mailbox.id, active: active),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _rename() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'folders.name'),
        fields: [
          AdminField(
            tr(context, 'folders.name'),
            initial: _mailbox.displayName,
          ),
        ],
        action: tr(context, 'common.save'),
        host: _host,
        submit: (values) async => _mailbox = await _client.updateMailbox(
          _mailbox.id,
          displayName: values[0],
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _newPassword() async {
    final changed = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'setup.newPassword'),
        intro: tr(context, 'admin.mailboxes.itsSessionsEndAndItSignsIn'),
        fields: [AdminField(tr(context, 'signIn.password'), obscure: true)],
        action: tr(context, 'admin.mailboxes.setPassword'),
        host: _host,
        submit: (values) async => _mailbox = await _client.updateMailbox(
          _mailbox.id,
          password: values[0],
        ),
      ),
    );
    if (changed && mounted) {
      showToast(context, tr(context, 'admin.mailboxes.passwordChanged'));
    }
  }

  Future<void> _editQuota() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.domains.mailboxSize'),
        fields: [
          AdminField(
            tr(context, 'admin.domains.mailboxSizeInMB'),
            initial: '${_mailbox.quotaBytes ~/ (1024 * 1024)}',
            number: true,
          ),
        ],
        action: tr(context, 'common.save'),
        host: _host,
        submit: (values) async => _mailbox = await _client.updateMailbox(
          _mailbox.id,
          quotaBytes: megabytes(values[0]),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _endSessions() async {
    setState(() => _busy = true);
    final address = _mailbox.address;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => _client.endMailboxSessions(_mailbox.id),
      confirm: (
        title: trArgs(context, 'admin.mailboxes.signAddressOutEverywhere', {
          'address': (address).toString(),
        }),
        message: tr(context, 'admin.mailboxes.everyAppSignedInToItHas'),
        action: tr(context, 'admin.mailboxes.endSessions'),
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      showToast(context, tr(context, 'admin.mailboxes.signedOutEverywhere'));
    }
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final address = _mailbox.address;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => _client.deleteMailbox(_mailbox.id),
      confirm: (
        title: trArgs(context, 'admin.mailboxes.deleteAddress', {
          'address': (address).toString(),
        }),
        message: tr(context, 'admin.mailboxes.itsMailGoesWithItAndIt'),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(
        context,
        trArgs(context, 'admin.mailboxes.deletedAddress', {
          'address': (address).toString(),
        }),
      );
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = _mailbox;
    return AdminPage(
      scope: CapabilityScope.mailbox(widget.mailbox.address),
      account: widget.account,
      section: AdminSection.mailboxes,
      title: box.address,
      body: (access) {
        final write = access.canWrite(AdminSection.mailboxes);
        return AdminDetailBody(
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
                    label: tr(context, 'folders.name'),
                    value: box.displayName.isEmpty ? '—' : box.displayName,
                    onTap: write && !_busy ? () => unawaited(_rename()) : null,
                  ),
                  RmRow(
                    label: tr(context, 'admin.mailboxes.canSignIn'),
                    value: write
                        ? null
                        : (box.active
                              ? tr(context, 'admin.keys.yes')
                              : tr(context, 'admin.keys.no')),
                    trailing: write
                        ? RmSwitch(
                            value: box.active,
                            label: tr(context, 'admin.mailboxes.canSignIn'),
                            onChanged: (value) {
                              if (!_busy) unawaited(_setActive(value));
                            },
                          )
                        : null,
                  ),
                  RmRow(
                    label: tr(context, 'mailboxes.storage'),
                    value: _storage(context, box),
                  ),
                  if (box.domain case final domain?)
                    RmRow(
                      label: tr(context, 'admin.aliases.domain'),
                      value: domain.name,
                    ),
                  if (box.quotaUsage case final usage?) ...[
                    RmRow(
                      label: tr(context, 'mailboxes.messages'),
                      value: countLabel(usage.messageCount),
                    ),
                    RmRow(
                      label: tr(context, 'admin.mailboxes.subjects'),
                      value: sizeLabel(usage.subjectBytes),
                    ),
                    RmRow(
                      label: tr(context, 'admin.mailboxes.messageBodies'),
                      value: sizeLabel(usage.bodyBytes),
                    ),
                    RmRow(
                      label: tr(context, 'attachments.title'),
                      value: sizeLabel(usage.attachmentBytes),
                    ),
                    if (usage.updatedAt case final at?)
                      RmRow(
                        label: tr(context, 'admin.mailboxes.storageCounted'),
                        value: longDate(at),
                      ),
                  ],
                  if (write)
                    RmRow(
                      label: tr(context, 'admin.domains.mailboxSize'),
                      value: box.quotaBytes > 0
                          ? sizeLabel(box.quotaBytes)
                          : tr(context, 'admin.mailboxes.noLimit'),
                      onTap: _busy ? null : () => unawaited(_editQuota()),
                    ),
                  if (box.lastLoginAt case final last?)
                    RmRow(
                      label: tr(context, 'admin.mailboxes.lastSignedIn'),
                      value: longDate(last),
                    ),
                  if (box.lastPasswordChange case final at?)
                    RmRow(
                      label: tr(context, 'admin.mailboxes.passwordChanged'),
                      value: longDate(at),
                    ),
                  if (box.passwordChangeRequired)
                    RmRow(
                      label: tr(context, 'admin.mailboxes.passwordSetup'),
                      value: tr(context, 'admin.mailboxes.required'),
                    ),
                  if (box.twoFactorRequired)
                    RmRow(
                      label: tr(
                        context,
                        'admin.mailboxes.twoFactorAuthentication',
                      ),
                      value: tr(context, 'admin.mailboxes.required'),
                    ),
                  if (box.createdAt case final at?)
                    RmRow(
                      label: tr(context, 'admin.aliases.added'),
                      value: longDate(at),
                    ),
                  if (box.updatedAt case final at?)
                    RmRow(
                      label: tr(context, 'admin.domains.changed'),
                      value: longDate(at),
                    ),
                ],
              ),
              if (write) ...[
                const SizedBox(height: 22),
                RmGroup(
                  children: [
                    RmRow(
                      label: tr(context, 'admin.mailboxes.setANewPassword'),
                      onTap: _busy ? null : () => unawaited(_newPassword()),
                    ),
                    RmRow(
                      label: tr(context, 'admin.mailboxes.endSessions'),
                      subtitle: tr(
                        context,
                        'admin.mailboxes.signItOutOfEveryApp',
                      ),
                      onTap: _busy ? null : () => unawaited(_endSessions()),
                    ),
                  ],
                ),
              ],
              if (access.canDelete(AdminSection.mailboxes)) ...[
                const SizedBox(height: 22),
                RmGroup(
                  children: [
                    RmRow(
                      label: tr(context, 'admin.mailboxes.deleteMailbox'),
                      danger: true,
                      onTap: _busy ? null : () => unawaited(_delete()),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
