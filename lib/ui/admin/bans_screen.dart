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
  final expires? => 'until ${longDate(expires)}',
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
  late final _list = AdminList<Ban>(
    (offset) => widget.account.client.bans(offset: offset),
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
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => _BanForm(account: widget.account)),
    );
    if (added ?? false) unawaited(_list.reload());
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
      empty: 'No one is banned.',
      header: [
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
  ever('For good', null);

  const _Lasts(this.label, this.duration);

  final String label;
  final Duration? duration;
}

class _BanForm extends StatefulWidget {
  const _BanForm({required this.account});

  final RestAccount account;

  @override
  State<_BanForm> createState() => _BanFormState();
}

class _BanFormState extends State<_BanForm> {
  final _ip = TextEditingController();
  final _reason = TextEditingController();
  var _lasts = _Lasts.day;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _ip.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.account.client.createBan(
        ip: _ip.text.trim(),
        reason: _reason.text.trim(),
        duration: _lasts.duration,
        createdBy: widget.account.user.email,
      );
      if (mounted) Navigator.pop(context, true);
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
              title: 'Ban an address',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    'It is kept out of SMTP, IMAP and POP3.',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RmSegmented<_Lasts>(
                      options: [for (final l in _Lasts.values) (l, l.label)],
                      value: _lasts,
                      onChanged: (lasts) => setState(() => _lasts = lasts),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Ban',
                    busy: _busy,
                    onPressed: !_busy && _ip.text.trim().isNotEmpty
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
