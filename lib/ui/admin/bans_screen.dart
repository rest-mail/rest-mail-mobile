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

String _protocolLabel(BuildContext context, String protocol) =>
    switch (protocol) {
      'all' => tr(context, 'admin.bans.smtpIMAPAndPOP3'),
      _ => protocol.toUpperCase(),
    };

String _until(BuildContext context, Ban ban) => switch (ban.expiresAt) {
  final expires? =>
    expires.isAfter(DateTime.now())
        ? 'until ${longDate(expires)}'
        : 'expired ${longDate(expires)}',
  null => tr(context, 'admin.bans.forGood'),
};

/// Addresses kept out of the server's mail protocols, by an admin or by the
/// server itself after too many failed sign-ins.
class BansScreen extends StatefulWidget {
  const BansScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<BansScreen> createState() => _BansScreenState();
}

class _BansScreenState extends State<BansScreen> {
  var _filter = const _BanFilter();
  late final _list = AdminList<Ban>(
    (offset) => widget.account.client.bans(
      offset: offset,
      ip: _filter.ip,
      protocol: _filter.protocol,
      active: _filter.includeExpired ? false : null,
    ),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.bans)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final ban = await Navigator.push<Ban>(
      context,
      MaterialPageRoute(builder: (_) => _BanForm(account: widget.account)),
    );
    if (!mounted || ban == null) return;
    showToast(
      context,
      trArgs(context, 'admin.bans.bannedIp', {'ip': (ban.ip).toString()}),
    );
    unawaited(_list.reload());
  }

  Future<void> _liftByIP() async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => _BanForm(account: widget.account, unban: true),
      ),
    );
    if (!mounted || removed != true) return;
    showToast(context, tr(context, 'admin.bans.liftedTheBan'));
    unawaited(_list.reload());
  }

  Future<void> _filterBans() async {
    final filter = await Navigator.push<_BanFilter>(
      context,
      MaterialPageRoute(builder: (_) => _BanFiltersScreen(filter: _filter)),
    );
    if (!mounted || filter == null) return;
    setState(() => _filter = filter);
    await _list.reload();
  }

  Future<void> _lift(Ban ban) async {
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteBan(ban.id),
      confirm: (
        title: trArgs(context, 'admin.bans.liftTheBanOnIp', {
          'ip': (ban.ip).toString(),
        }),
        message: tr(context, 'admin.bans.itCanReachTheMailProtocolsAgain'),
        action: tr(context, 'admin.bans.liftBan'),
      ),
    );
    if (!ok || !mounted) return;
    showToast(
      context,
      trArgs(context, 'admin.bans.liftedTheBanOnIp', {
        'ip': (ban.ip).toString(),
      }),
    );
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.bans,
    title: tr(context, 'admin.section.bans.title'),
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: tr(context, 'admin.bans.noBansMatchTheseFilters'),
      header: [
        AdminAddButton(
          label: tr(context, 'admin.bans.filterBans'),
          onTap: () => unawaited(_filterBans()),
        ),
        if (_filter.ip != null ||
            _filter.protocol != null ||
            _filter.includeExpired)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              [
                ?_filter.ip,
                if (_filter.protocol case final protocol?)
                  _protocolLabel(context, protocol),
                _filter.includeExpired
                    ? tr(context, 'admin.bans.currentAndExpiredBans')
                    : tr(context, 'admin.bans.activeBans'),
              ].join(' · '),
            ),
          ),
        if (access.canDelete(AdminSection.bans))
          AdminAddButton(
            label: tr(context, 'admin.bans.liftABanByIP'),
            onTap: () => unawaited(_liftByIP()),
          ),
        if (access.canWrite(AdminSection.bans))
          AdminAddButton(
            label: tr(context, 'admin.bans.banAnAddress'),
            onTap: () => unawaited(_add()),
          ),
      ],
      row: (ban) => RmRow(
        label: ban.ip,
        subtitle: [
          '${_protocolLabel(context, ban.protocol)}, ${_until(context, ban)}',
          trArgs(context, 'admin.bans.banIdAddedValue', {
            'id': (ban.id).toString(),
            'value': (longDate(ban.createdAt)).toString(),
          }),
          if (ban.reason.isNotEmpty) ban.reason,
          if (ban.createdBy == 'auto')
            tr(context, 'admin.bans.byTheServer')
          else
            trArgs(context, 'admin.bans.byCreatedBy', {
              'createdBy': (ban.createdBy).toString(),
            }),
        ].join('\n'),
        trailing: access.canDelete(AdminSection.bans)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: trArgs(context, 'admin.bans.liftTheBanOnIp2', {
                  'ip': (ban.ip).toString(),
                }),
                color: context.rm.ink3,
                onPressed: () => unawaited(_lift(ban)),
              )
            : null,
      ),
    ),
  );
}

/// How long a new ban lasts.
enum _Lasts {
  day('admin.bans.aDay', Duration(days: 1)),
  week('admin.bans.aWeek', Duration(days: 7)),
  ever('admin.bans.forGood2', null),
  custom('admin.bans.custom', null);

  const _Lasts(this.label, this.duration);

  final String label;
  final Duration? duration;
}

class _BanForm extends StatefulWidget {
  const _BanForm({required this.account, this.unban = false});

  final RestAccount account;
  final bool unban;

  @override
  State<_BanForm> createState() => _BanFormState();
}

class _BanFormState extends State<_BanForm> {
  final _ip = TextEditingController();
  final _reason = TextEditingController();
  final _duration = TextEditingController();
  var _protocol = 'all';
  var _lasts = _Lasts.day;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _ip.dispose();
    _reason.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    // Asked first: nothing is under way while the question is open.
    if (widget.unban) {
      final sure = await confirmAction(
        context,
        title: trArgs(context, 'admin.bans.liftTheBanOnValue', {
          'value': (_ip.text.trim()).toString(),
        }),
        message: tr(context, 'admin.bans.itCanReachTheMailProtocolsAgain'),
        action: tr(context, 'admin.bans.liftBan'),
      );
      if (!mounted || !sure) return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (widget.unban) {
        await widget.account.client.unbanIP(_ip.text.trim());
        if (mounted) Navigator.pop(context, true);
      } else {
        final ban = await widget.account.client.createBan(
          ip: _ip.text.trim(),
          reason: _reason.text.trim(),
          protocol: _protocol,
          duration: _lasts == _Lasts.custom ? null : _lasts.duration,
          durationText: _lasts == _Lasts.custom ? _duration.text.trim() : null,
          createdBy: widget.account.user.email,
        );
        if (mounted) Navigator.pop(context, ban);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = describeAdminError(
          context,
          e,
          host: widget.account.server.host,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: widget.unban
                  ? tr(context, 'admin.bans.liftABanByIP')
                  : tr(context, 'admin.bans.banAnAddress'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    widget.unban
                        ? tr(
                            context,
                            'admin.bans.enterTheExactIPv4OrIPv6Address',
                          )
                        : tr(
                            context,
                            'admin.bans.chooseWhichMailProtocolsThisAddressCannot',
                          ),
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  SectionLabel(tr(context, 'admin.bans.ipAddress')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ip,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: const InputDecoration(hintText: '203.0.113.7'),
                  ),
                  if (!widget.unban) ...[
                    const SizedBox(height: 18),
                    SectionLabel(tr(context, 'admin.bans.protocols')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final protocol in ['all', 'smtp', 'imap', 'pop3'])
                          ChoiceChip(
                            label: Text(
                              protocol == 'all'
                                  ? tr(context, 'admin.bans.allProtocols')
                                  : protocol.toUpperCase(),
                            ),
                            selected: _protocol == protocol,
                            onSelected: _busy
                                ? null
                                : (_) => setState(() => _protocol = protocol),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SectionLabel(tr(context, 'quarantine.why')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reason,
                      onChanged: (_) => setState(() => _error = null),
                      style: rmText(16, color: c.ink),
                      decoration: InputDecoration(
                        hintText: tr(context, 'contacts.nameHint'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SectionLabel(tr(context, 'admin.bans.for')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final lasts in _Lasts.values)
                          ChoiceChip(
                            label: Text(tr(context, lasts.label)),
                            selected: _lasts == lasts,
                            onSelected: _busy
                                ? null
                                : (_) => setState(() => _lasts = lasts),
                          ),
                      ],
                    ),
                    if (_lasts == _Lasts.custom)
                      TextField(
                        controller: _duration,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: tr(context, 'admin.bans.duration'),
                          hintText: tr(
                            context,
                            'admin.bans.forExample1h30mOr30s',
                          ),
                        ),
                        onChanged: (_) => setState(() => _error = null),
                      ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: widget.unban
                        ? tr(context, 'admin.bans.liftBan')
                        : tr(context, 'admin.bans.ban'),
                    busy: _busy,
                    onPressed:
                        !_busy &&
                            _ip.text.trim().isNotEmpty &&
                            (widget.unban ||
                                _lasts != _Lasts.custom ||
                                _duration.text.trim().isNotEmpty)
                        ? () => unawaited(_send())
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BanFilter {
  const _BanFilter({this.ip, this.protocol, this.includeExpired = false});
  final String? ip;
  final String? protocol;
  final bool includeExpired;
}

class _BanFiltersScreen extends StatefulWidget {
  const _BanFiltersScreen({required this.filter});
  final _BanFilter filter;
  @override
  State<_BanFiltersScreen> createState() => _BanFiltersScreenState();
}

class _BanFiltersScreenState extends State<_BanFiltersScreen> {
  late final _ip = TextEditingController(text: widget.filter.ip ?? '');
  late var _protocol = widget.filter.protocol;
  late var _includeExpired = widget.filter.includeExpired;
  @override
  void dispose() {
    _ip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          RmTopBar(
            title: tr(context, 'admin.bans.filterBans'),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                TextField(
                  controller: _ip,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: tr(context, 'admin.bans.exactIPAddress'),
                    hintText: tr(context, 'admin.bans.anyAddress'),
                  ),
                ),
                const SizedBox(height: 18),
                SectionLabel(tr(context, 'server.protocol')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final protocol in <String?>[
                      null,
                      'smtp',
                      'imap',
                      'pop3',
                      'all',
                    ])
                      ChoiceChip(
                        label: Text(
                          protocol == null
                              ? tr(context, 'admin.bans.anyProtocol')
                              : protocol == 'all'
                              ? tr(context, 'admin.bans.allProtocolsOnly')
                              : protocol.toUpperCase(),
                        ),
                        selected: _protocol == protocol,
                        onSelected: (_) => setState(() => _protocol = protocol),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tr(
                    context,
                    'admin.bans.aSpecificProtocolAlsoIncludesBansThat',
                  ),
                ),
                SwitchListTile(
                  title: Text(tr(context, 'admin.bans.includeExpiredBans')),
                  subtitle: Text(
                    tr(context, 'admin.bans.showCurrentAndExpiredBansTogether'),
                  ),
                  value: _includeExpired,
                  onChanged: (value) => setState(() => _includeExpired = value),
                ),
                const SizedBox(height: 18),
                RmPrimaryButton(
                  label: tr(context, 'admin.bans.applyFilters'),
                  onPressed: () => Navigator.pop(
                    context,
                    _BanFilter(
                      ip: _ip.text.trim().isEmpty ? null : _ip.text.trim(),
                      protocol: _protocol,
                      includeExpired: _includeExpired,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, const _BanFilter()),
                  child: Text(tr(context, 'admin.bans.clearFilters')),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
