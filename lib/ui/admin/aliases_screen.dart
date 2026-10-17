import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

/// Addresses that deliver to another, on the server or on one [domain].
class AliasesScreen extends StatefulWidget {
  const AliasesScreen({super.key, required this.account, this.domain});

  final RestAccount account;
  final AdminDomain? domain;

  @override
  State<AliasesScreen> createState() => _AliasesScreenState();
}

class _AliasesScreenState extends State<AliasesScreen> {
  late final _list = AdminList<AdminAlias>(
    (offset) => widget.account.client.aliases(
      domainId: widget.domain?.id,
      offset: offset,
    ),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.aliases)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final domain = widget.domain?.name ?? 'example.com';
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Add an alias',
        intro:
            'Mail to the alias, on a domain this server has, goes to the '
            'address it points to.',
        fields: [
          AdminField('Alias', hint: 'sales@$domain', email: true),
          AdminField('Delivers to', hint: 'someone@$domain', email: true),
        ],
        action: 'Add alias',
        host: _host,
        submit: (values) => widget.account.client.createAlias(
          source: values[0].toLowerCase(),
          destination: values[1].toLowerCase(),
        ),
      ),
    );
    if (added) unawaited(_list.reload());
  }

  Future<void> _open(AdminAlias alias) async {
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => AliasScreen(account: widget.account, alias: alias),
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
      account: widget.account,
      section: AdminSection.aliases,
      title: 'Aliases',
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: 'No aliases yet.',
        header: [
          if (domain != null) ...[
            Text('On ${domain.name}', style: rmText(13, color: c.ink3)),
            const SizedBox(height: 12),
          ],
          if (access.canWrite(AdminSection.aliases))
            AdminAddButton(
              label: 'Add an alias',
              onTap: () => unawaited(_add()),
            ),
        ],
        row: (alias) => RmRow(
          label: alias.source,
          subtitle: [
            '→ ${alias.destination}',
            if (!alias.active) 'Off',
          ].join(' · '),
          onTap: () => unawaited(_open(alias)),
        ),
      ),
    );
  }
}

/// One alias: where it delivers, and whether it does.
class AliasScreen extends StatefulWidget {
  const AliasScreen({super.key, required this.account, required this.alias});

  final RestAccount account;
  final AdminAlias alias;

  @override
  State<AliasScreen> createState() => _AliasScreenState();
}

class _AliasScreenState extends State<AliasScreen> {
  late var _alias = widget.alias;
  var _busy = false;

  String get _host => widget.account.server.host;
  RestmailClient get _client => widget.account.client;

  Future<void> _setActive(bool active) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async =>
          _alias = await _client.updateAlias(_alias.id, active: active),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _redirect() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: 'Delivers to',
        fields: [
          AdminField('Delivers to', initial: _alias.destination, email: true),
        ],
        action: 'Save',
        host: _host,
        submit: (values) async => _alias = await _client.updateAlias(
          _alias.id,
          destination: values[0].toLowerCase(),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    final source = _alias.source;
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => _client.deleteAlias(_alias.id),
      confirm: (
        title: 'Delete $source?',
        message: 'Mail to it is no longer delivered.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'Deleted $source');
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alias = _alias;
    return AdminPage(
      account: widget.account,
      section: AdminSection.aliases,
      title: alias.source,
      body: (access) {
        final write = access.canWrite(AdminSection.aliases);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            RmGroup(
              children: [
                RmRow(
                  label: 'Delivers to',
                  value: alias.destination,
                  onTap: write ? () => unawaited(_redirect()) : null,
                ),
                RmRow(
                  label: 'Delivering',
                  value: write ? null : (alias.active ? 'On' : 'Off'),
                  trailing: write
                      ? RmSwitch(
                          value: alias.active,
                          label: 'Delivering',
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
              ],
            ),
            if (access.canDelete(AdminSection.aliases)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Delete alias',
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
