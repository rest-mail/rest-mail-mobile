import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_scope.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _storage(AdminMailbox box) => box.quotaBytes > 0
    ? '${sizeLabel(box.quotaUsedBytes)} of ${sizeLabel(box.quotaBytes)}'
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
        title: 'Add a mailbox',
        intro:
            'On a domain this server hosts. Accounts are made in one place, '
            'so this account becomes its owner, and it shows among your '
            'mailboxes. Leave the credential blank for owner-only access. '
            'Choose a password (12 characters or more), or import an existing '
            'bcrypt, SHA256-CRYPT or SHA512-CRYPT hash to keep its password.',
        fields: [
          AdminField(
            'Address',
            hint: 'someone@${domain ?? 'example.com'}',
            email: true,
          ),
          const AdminField('Name', optional: true),
          const AdminField(
            'Credential type',
            initial: 'password',
            choices: [
              ('password', 'Password'),
              ('hash', 'Imported password hash'),
            ],
            clearFieldsOnChange: [3],
          ),
          const AdminField(
            'Password or imported hash',
            obscure: true,
            optional: true,
          ),
        ],
        action: 'Add mailbox',
        host: _host,
        submit: (values) => widget.account.client.createAccount(
          address: values[0].toLowerCase(),
          displayName: values[1].isEmpty ? null : values[1],
          password: values[2] == 'password' && values[3].isNotEmpty
              ? values[3]
              : null,
          passwordHash: values[2] == 'hash' && values[3].isNotEmpty
              ? values[3]
              : null,
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
      title: 'Mailboxes',
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: 'No mailboxes yet.',
        header: [
          if (domain != null) ...[
            Text('On ${domain.name}', style: rmText(13, color: c.ink3)),
            const SizedBox(height: 12),
          ],
          if (access.canWrite(AdminSection.mailboxes))
            AdminAddButton(
              label: 'Add a mailbox',
              onTap: () => unawaited(_add()),
            ),
        ],
        row: (box) => RmRow(
          label: box.address,
          subtitle: [
            if (box.displayName.isNotEmpty) box.displayName,
            if (!box.active) 'Off',
            _storage(box),
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
        title: 'Name',
        fields: [AdminField('Name', initial: _mailbox.displayName)],
        action: 'Save',
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
        title: 'New password',
        intro:
            'Its sessions end, and it signs in again with this one. Twelve '
            'characters or more.',
        fields: const [AdminField('Password', obscure: true)],
        action: 'Set password',
        host: _host,
        submit: (values) async => _mailbox = await _client.updateMailbox(
          _mailbox.id,
          password: values[0],
        ),
      ),
    );
    if (changed && mounted) showToast(context, 'Password changed');
  }

  Future<void> _editQuota() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Mailbox size',
        fields: [
          AdminField(
            'Mailbox size in MB',
            initial: '${_mailbox.quotaBytes ~/ (1024 * 1024)}',
            number: true,
          ),
        ],
        action: 'Save',
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
        title: 'Sign $address out everywhere?',
        message:
            'Every app signed in to it has to sign in again. Its password '
            'and app passwords stay.',
        action: 'End sessions',
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) showToast(context, 'Signed out everywhere');
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final address = _mailbox.address;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => _client.deleteMailbox(_mailbox.id),
      confirm: (
        title: 'Delete $address?',
        message: 'Its mail goes with it, and it cannot be undone.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted $address');
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
                    label: 'Name',
                    value: box.displayName.isEmpty ? '—' : box.displayName,
                    onTap: write && !_busy ? () => unawaited(_rename()) : null,
                  ),
                  RmRow(
                    label: 'Can sign in',
                    value: write ? null : (box.active ? 'Yes' : 'No'),
                    trailing: write
                        ? RmSwitch(
                            value: box.active,
                            label: 'Can sign in',
                            onChanged: (value) {
                              if (!_busy) unawaited(_setActive(value));
                            },
                          )
                        : null,
                  ),
                  RmRow(label: 'Storage', value: _storage(box)),
                  if (box.domain case final domain?)
                    RmRow(label: 'Domain', value: domain.name),
                  if (box.quotaUsage case final usage?) ...[
                    RmRow(
                      label: 'Messages',
                      value: countLabel(usage.messageCount),
                    ),
                    RmRow(
                      label: 'Subjects',
                      value: sizeLabel(usage.subjectBytes),
                    ),
                    RmRow(
                      label: 'Message bodies',
                      value: sizeLabel(usage.bodyBytes),
                    ),
                    RmRow(
                      label: 'Attachments',
                      value: sizeLabel(usage.attachmentBytes),
                    ),
                    if (usage.updatedAt case final at?)
                      RmRow(label: 'Storage counted', value: longDate(at)),
                  ],
                  if (write)
                    RmRow(
                      label: 'Mailbox size',
                      value: box.quotaBytes > 0
                          ? sizeLabel(box.quotaBytes)
                          : 'No limit',
                      onTap: _busy ? null : () => unawaited(_editQuota()),
                    ),
                  if (box.lastLoginAt case final last?)
                    RmRow(label: 'Last signed in', value: longDate(last)),
                  if (box.lastPasswordChange case final at?)
                    RmRow(label: 'Password changed', value: longDate(at)),
                  if (box.passwordChangeRequired)
                    const RmRow(label: 'Password setup', value: 'Required'),
                  if (box.twoFactorRequired)
                    const RmRow(
                      label: 'Two-factor authentication',
                      value: 'Required',
                    ),
                  if (box.createdAt case final at?)
                    RmRow(label: 'Added', value: longDate(at)),
                  if (box.updatedAt case final at?)
                    RmRow(label: 'Changed', value: longDate(at)),
                ],
              ),
              if (write) ...[
                const SizedBox(height: 22),
                RmGroup(
                  children: [
                    RmRow(
                      label: 'Set a new password',
                      onTap: _busy ? null : () => unawaited(_newPassword()),
                    ),
                    RmRow(
                      label: 'End sessions',
                      subtitle: 'Sign it out of every app',
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
                      label: 'Delete mailbox',
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
