import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _protocolLabel(String protocol) => switch (protocol) {
  'all' => 'SMTP, IMAP and POP3',
  _ => protocol.toUpperCase(),
};

String _until(Ban ban) => switch (ban.expiresAt) {
  final expires? =>
    expires.isAfter(DateTime.now())
        ? 'until ${longDate(expires)}'
        : 'expired ${longDate(expires)}',
  null => 'for good',
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
    showToast(context, 'Banned ${ban.ip}');
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
    showToast(context, 'Lifted the ban');
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
        title: 'Lift the ban on ${ban.ip}?',
        message: 'It can reach the mail protocols again straight away.',
        action: 'Lift ban',
      ),
    );
    if (!ok || !mounted) return;
    showToast(context, 'Lifted the ban on ${ban.ip}');
    unawaited(_list.reload());
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.bans,
    title: 'Bans',
    body: (access) => AdminListView(
      list: _list,
      host: _host,
      empty: 'No bans match these filters.',
      header: [
        AdminAddButton(
          label: 'Filter bans',
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
                  _protocolLabel(protocol),
                _filter.includeExpired
                    ? 'Current and expired bans'
                    : 'Active bans',
              ].join(' · '),
            ),
          ),
        if (access.canDelete(AdminSection.bans))
          AdminAddButton(
            label: 'Lift a ban by IP',
            onTap: () => unawaited(_liftByIP()),
          ),
        if (access.canWrite(AdminSection.bans))
          AdminAddButton(
            label: 'Ban an address',
            onTap: () => unawaited(_add()),
          ),
      ],
      row: (ban) => RmRow(
        label: ban.ip,
        subtitle: [
          '${_protocolLabel(ban.protocol)}, ${_until(ban)}',
          'Ban ${ban.id} · Added ${longDate(ban.createdAt)}',
          if (ban.reason.isNotEmpty) ban.reason,
          if (ban.createdBy == 'auto')
            'By the server'
          else
            'By ${ban.createdBy}',
        ].join('\n'),
        trailing: access.canDelete(AdminSection.bans)
            ? RmIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Lift the ban on ${ban.ip}',
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
  day('A day', Duration(days: 1)),
  week('A week', Duration(days: 7)),
  ever('For good', null),
  custom('Custom', null);

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
        title: 'Lift the ban on ${_ip.text.trim()}?',
        message: 'It can reach the mail protocols again straight away.',
        action: 'Lift ban',
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
        _error = describeAdminError(e, host: widget.account.server.host);
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
              title: widget.unban ? 'Lift a ban by IP' : 'Ban an address',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    widget.unban
                        ? 'Enter the exact IPv4 or IPv6 address of the ban.'
                        : 'Choose which mail protocols this address cannot use.',
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  const SectionLabel('IP address'),
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
                    const SectionLabel('Protocols'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final protocol in ['all', 'smtp', 'imap', 'pop3'])
                          ChoiceChip(
                            label: Text(
                              protocol == 'all'
                                  ? 'All protocols'
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
                    const SectionLabel('Why'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reason,
                      onChanged: (_) => setState(() => _error = null),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(hintText: 'Optional'),
                    ),
                    const SizedBox(height: 18),
                    const SectionLabel('For'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final lasts in _Lasts.values)
                          ChoiceChip(
                            label: Text(lasts.label),
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
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                          hintText: 'For example 1h30m or 30s',
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
                    label: widget.unban ? 'Lift ban' : 'Ban',
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
          RmTopBar(title: 'Filter bans', onBack: () => Navigator.pop(context)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                TextField(
                  controller: _ip,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Exact IP address',
                    hintText: 'Any address',
                  ),
                ),
                const SizedBox(height: 18),
                const SectionLabel('Protocol'),
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
                              ? 'Any protocol'
                              : protocol == 'all'
                              ? 'All protocols only'
                              : protocol.toUpperCase(),
                        ),
                        selected: _protocol == protocol,
                        onSelected: (_) => setState(() => _protocol = protocol),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'A specific protocol also includes bans that apply to all protocols.',
                ),
                SwitchListTile(
                  title: const Text('Include expired bans'),
                  subtitle: const Text(
                    'Show current and expired bans together',
                  ),
                  value: _includeExpired,
                  onChanged: (value) => setState(() => _includeExpired = value),
                ),
                const SizedBox(height: 18),
                RmPrimaryButton(
                  label: 'Apply filters',
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
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
