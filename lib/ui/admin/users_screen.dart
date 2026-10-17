import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

/// The admin users: who signs in to run the server, and the roles that say
/// what each may do.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final _list = AdminList<AdminUser>(
    (offset) => widget.account.client.adminUsers(offset: offset),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.users)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Add an administrator',
        intro:
            'They sign in with this username and password. They can do '
            'nothing until they have a role: give them one once they are '
            'added.',
        fields: const [
          AdminField('Username', email: true),
          AdminField('Password', obscure: true),
        ],
        action: 'Add administrator',
        host: _host,
        submit: (values) => widget.account.client.createAdminUser(
          username: values[0],
          password: values[1],
        ),
      ),
    );
    if (added) unawaited(_list.reload());
  }

  Future<void> _open(AdminUser user) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminUserScreen(account: widget.account, user: user),
      ),
    );
    if (!mounted) return;
    if (done != null) showToast(context, done);
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.users,
    title: 'Administrators',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No administrators.',
      header: [
        if (access.canWrite(AdminSection.users))
          AdminAddButton(
            label: 'Add an administrator',
            onTap: () => unawaited(_add()),
          ),
      ],
      row: (user) => RmRow(
        label: user.username,
        subtitle: [
          if (user.roles.isEmpty)
            'No role'
          else
            user.roles.map((r) => r.name).join(', '),
          if (!user.active) 'Off',
        ].join(' · '),
        onTap: () => unawaited(_open(user)),
      ),
    ),
  );
}

/// One admin user: whether they may sign in, and their roles.
class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key, required this.account, required this.user});

  final RestAccount account;
  final AdminUser user;

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  late var _active = widget.user.active;
  late var _roleIds = {for (final r in widget.user.roles) r.id};
  List<AdminRole>? _roles;
  var _busy = false;

  String get _host => widget.account.server.host;
  RestmailClient get _client => widget.account.client;

  /// This session's own admin user: a change ends it too.
  bool get _isSelf =>
      widget.account.isAdministrator &&
      widget.account.user.email == widget.user.username;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.users)) {
      unawaited(_loadRoles());
    }
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _client.roles();
      if (mounted) setState(() => _roles = roles);
    } on ApiException {
      // The user's own roles are shown instead.
    }
  }

  Future<void> _change(Future<void> Function() change) async {
    setState(() => _busy = true);
    await runAdminChange(context, host: _host, change: change);
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _setActive(bool active) => _change(() async {
    await _client.updateAdminUser(widget.user.id, active: active);
    _active = active;
  });

  Future<void> _toggleRole(AdminRole role) => _change(() async {
    final next = {..._roleIds};
    if (!next.remove(role.id)) next.add(role.id);
    await _client.updateAdminUser(widget.user.id, roleIds: [...next]);
    _roleIds = next;
  });

  Future<void> _newPassword() async {
    final changed = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'New password',
        intro: 'Their sessions end, and they sign in again with this one.',
        fields: const [AdminField('Password', obscure: true)],
        action: 'Set password',
        host: _host,
        submit: (values) =>
            _client.updateAdminUser(widget.user.id, password: values[0]),
      ),
    );
    if (changed && mounted) showToast(context, 'Password changed');
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final username = widget.user.username;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => _client.deleteAdminUser(widget.user.id),
      confirm: (
        title: 'Delete $username?',
        message: 'They can no longer sign in to run this server.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted $username');
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final user = widget.user;
    return AdminPage(
      account: widget.account,
      section: AdminSection.users,
      title: user.username,
      body: (access) {
        final write = access.canWrite(AdminSection.users);
        // Every role to choose from with write; else the ones they have.
        final roles = write && _roles != null ? _roles! : user.roles;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            RmGroup(
              children: [
                RmRow(
                  label: 'Can sign in',
                  value: write ? null : (_active ? 'Yes' : 'No'),
                  trailing: write
                      ? RmSwitch(
                          value: _active,
                          label: 'Can sign in',
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
                if (user.passwordChangeRequired)
                  const RmRow(
                    label: 'Password',
                    value: 'Chooses one at sign-in',
                  ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionLabel('Roles'),
            const SizedBox(height: 9),
            if (roles.isEmpty)
              Text('No role yet.', style: rmText(14, color: c.ink2))
            else
              RmGroup(
                children: [
                  for (final role in roles)
                    RmRow(
                      label: role.name,
                      subtitle: role.description.isEmpty
                          ? null
                          : role.description,
                      trailing: _roleIds.contains(role.id)
                          ? Icon(Icons.check_rounded, size: 20, color: c.accent)
                          : const SizedBox(width: 20),
                      onTap: write && !_busy
                          ? () => unawaited(_toggleRole(role))
                          : null,
                    ),
                ],
              ),
            if (write) ...[
              const SizedBox(height: 8),
              Text(
                _isSelf
                    ? 'This is you: changing your roles, your password or '
                          'turning yourself off signs you out here.'
                    : 'Changing their roles or password, or turning them '
                          'off, ends their sessions.',
                style: rmText(12.5, color: c.ink3, height: 1.4),
              ),
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Set a new password',
                    onTap: _busy ? null : () => unawaited(_newPassword()),
                  ),
                ],
              ),
            ],
            if (access.canDelete(AdminSection.users)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Delete administrator',
                    danger: true,
                    onTap: _busy ? null : () => unawaited(_delete()),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
