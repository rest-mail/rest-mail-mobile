import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
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
    if (AdminAccess(
      widget.account.capabilities,
      scope: widget.domain == null
          ? null
          : CapabilityScope.domain(widget.domain!.name),
      collection: true,
    ).canRead(AdminSection.aliases)) {
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
    AdminAlias? created;
    final added = await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.aliases.addAnAlias'),
        intro: tr(context, 'admin.aliases.mailToTheAliasOnADomain'),
        fields: [
          AdminField(
            tr(context, 'admin.aliases.alias'),
            hint: 'sales@$domain',
            email: true,
          ),
          AdminField(
            tr(context, 'admin.aliases.deliversTo'),
            hint: 'someone@$domain',
            email: true,
          ),
        ],
        action: tr(context, 'admin.aliases.addAlias'),
        host: _host,
        submit: (values) async =>
            created = await widget.account.client.createAlias(
              source: values[0].toLowerCase(),
              destination: values[1],
            ),
      ),
    );
    if (!mounted || !added) return;
    if (created case final alias?) {
      await _open(alias);
    } else {
      unawaited(_list.reload());
    }
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
      scope: widget.domain == null
          ? null
          : CapabilityScope.domain(widget.domain!.name),
      collection: true,
      account: widget.account,
      section: AdminSection.aliases,
      title: tr(context, 'admin.section.aliases.title'),
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: tr(context, 'admin.aliases.noAliasesYet'),
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
          if (access.canWrite(AdminSection.aliases))
            AdminAddButton(
              label: tr(context, 'admin.aliases.addAnAlias'),
              onTap: () => unawaited(_add()),
            ),
        ],
        row: (alias) => RmRow(
          label: alias.source,
          subtitle: [
            '→ ${alias.destination}',
            if (!alias.active) tr(context, 'twoFactor.off'),
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
  var _loaded = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(
        widget.alias.source.substring(widget.alias.source.lastIndexOf('@') + 1),
      ),
    ).canRead(AdminSection.aliases)) {
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
      final fresh = await widget.account.client.alias(widget.alias.id);
      if (!mounted) return;
      setState(() {
        _alias = fresh;
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
          _alias = await _client.updateAlias(_alias.id, active: active),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _redirect() async {
    await AdminFormScreen.open(
      context,
      AdminFormScreen(
        title: tr(context, 'admin.aliases.deliversTo'),
        fields: [
          AdminField(
            tr(context, 'admin.aliases.deliversTo'),
            initial: _alias.destination,
            email: true,
          ),
        ],
        action: tr(context, 'common.save'),
        host: _host,
        submit: (values) async => _alias = await _client.updateAlias(
          _alias.id,
          destination: values[0],
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
        title: trArgs(context, 'admin.aliases.deleteSource', {
          'source': (source).toString(),
        }),
        message: tr(context, 'admin.aliases.mailToItIsNoLongerDelivered'),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(
        context,
        trArgs(context, 'admin.aliases.deletedSource', {
          'source': (source).toString(),
        }),
      );
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alias = _alias;
    return AdminPage(
      scope: CapabilityScope.domain(
        widget.alias.source.substring(widget.alias.source.lastIndexOf('@') + 1),
      ),
      account: widget.account,
      section: AdminSection.aliases,
      title: alias.source,
      body: (access) {
        final write = access.canWrite(AdminSection.aliases);
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
                    label: tr(context, 'admin.aliases.deliversTo'),
                    value: alias.destination,
                    onTap: write && !_busy
                        ? () => unawaited(_redirect())
                        : null,
                  ),
                  if (alias.domain case final domain?)
                    RmRow(
                      label: tr(context, 'admin.aliases.domain'),
                      value: domain.name,
                    ),
                  if (alias.createdAt case final at?)
                    RmRow(
                      label: tr(context, 'admin.aliases.added'),
                      value: longDate(at),
                    ),
                  RmRow(
                    label: tr(context, 'admin.aliases.delivering'),
                    value: write
                        ? null
                        : (alias.active
                              ? tr(context, 'twoFactor.on')
                              : tr(context, 'twoFactor.off')),
                    trailing: write
                        ? RmSwitch(
                            value: alias.active,
                            label: tr(context, 'admin.aliases.delivering'),
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
                      label: tr(context, 'admin.aliases.deleteAlias'),
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
