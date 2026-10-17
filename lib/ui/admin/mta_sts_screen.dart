import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String _modeLabel(MtaStsMode mode) => switch (mode) {
  MtaStsMode.enforce => 'Enforce',
  MtaStsMode.testing => 'Testing',
  MtaStsMode.none => 'None',
};

String _modeHelp(MtaStsMode mode) => switch (mode) {
  MtaStsMode.enforce =>
    'Other servers deliver only over TLS, to one of these mail servers, '
        "with a valid certificate. If they can't, they don't deliver.",
  MtaStsMode.testing =>
    'Other servers deliver as before, and report what would have failed.',
  MtaStsMode.none => 'Tells other servers the policy is withdrawn.',
};

/// How long other servers keep a policy, in words.
String _ageLabel(Duration age) {
  final days = age.inDays;
  if (age == const Duration(days: 1)) return 'A day';
  if (age == const Duration(days: 7)) return 'A week';
  if (age.inSeconds % Duration.secondsPerDay == 0) {
    return days % 7 == 0 ? '${days ~/ 7} weeks' : '$days days';
  }
  if (age.inSeconds % Duration.secondsPerHour == 0) {
    return age.inHours == 1 ? 'An hour' : '${age.inHours} hours';
  }
  return '${age.inSeconds} seconds';
}

/// A domain's MTA-STS policy (RFC 8461): whether other servers must reach
/// its mail servers over TLS with a valid certificate, or only report when
/// they could not. The server publishes it at
/// `https://mta-sts.<domain>/.well-known/mta-sts.txt`.
class MtaStsScreen extends StatefulWidget {
  const MtaStsScreen({super.key, required this.account, required this.domain});

  final RestAccount account;
  final AdminDomain domain;

  @override
  State<MtaStsScreen> createState() => _MtaStsScreenState();
}

class _MtaStsScreenState extends State<MtaStsScreen> {
  MtaStsPolicy? _policy;
  var _loaded = false;
  ApiException? _error;
  var _busy = false;

  String get _host => widget.account.server.host;
  String get _name => widget.domain.name;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.mtaSts)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    try {
      final policy = await widget.account.client.mtaStsPolicy(widget.domain.id);
      if (mounted) {
        setState(() {
          _policy = policy;
          _loaded = true;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<MtaStsPolicy>(
      context,
      MaterialPageRoute(
        builder: (_) => _MtaStsForm(
          account: widget.account,
          domain: widget.domain,
          policy: _policy,
        ),
      ),
    );
    if (saved == null || !mounted) return;
    setState(() => _policy = saved);
    showToast(context, 'Saved the policy for $_name');
  }

  Future<void> _setActive(bool active) async {
    setState(() => _busy = true);
    await runAdminChange(
      context,
      host: _host,
      change: () async => _policy = await widget.account.client.setMtaStsPolicy(
        widget.domain.id,
        active: active,
      ),
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _delete(MtaStsPolicy policy) async {
    setState(() => _busy = true);
    final ok = await runAdminChange(
      context,
      host: _host,
      change: () => widget.account.client.deleteMtaStsPolicy(widget.domain.id),
      confirm: (
        title: 'Delete the MTA-STS policy for $_name?',
        message:
            'The server stops publishing it. Other servers keep the copy they '
            'have for up to ${_ageLabel(policy.maxAge).toLowerCase()}.',
        action: 'Delete',
      ),
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) _policy = null;
    });
    if (ok) showToast(context, 'Deleted the policy for $_name');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final policy = _policy, error = _error;
    return AdminPage(
      account: widget.account,
      section: AdminSection.mtaSts,
      title: 'MTA-STS',
      body: (access) {
        if (error != null) {
          return AdminMessage(
            describeAdminError(error, host: _host),
            onRetry: () => unawaited(_load()),
          );
        }
        if (!_loaded) {
          return const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final canWrite = access.canWrite(AdminSection.mtaSts);
        final where = Text(
          'Other servers fetch it from https://mta-sts.$_name/.well-known/'
          'mta-sts.txt, once a TXT record at _mta-sts.$_name says there is '
          'one. The DNS check shows whether that record is there.',
          style: rmText(13, color: c.ink3, height: 1.4),
        );
        if (policy == null) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
            children: [
              Text(
                '$_name has no MTA-STS policy, so other servers may send to '
                'it without TLS, or to a server pretending to be it.',
                style: rmText(15, color: c.ink2, height: 1.45),
              ),
              const SizedBox(height: 14),
              where,
              if (canWrite) ...[
                const SizedBox(height: 26),
                RmPrimaryButton(
                  label: 'Set up a policy',
                  onPressed: () => unawaited(_edit()),
                ),
              ],
            ],
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            RmGroup(
              children: [
                RmRow(
                  label: 'Mode',
                  subtitle: _modeHelp(policy.mode),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 4),
                    child: Text(
                      _modeLabel(policy.mode),
                      style: rmText(13.5, color: c.ink3),
                    ),
                  ),
                ),
                RmRow(
                  label: 'Mail servers',
                  subtitle: policy.mxHosts.isEmpty
                      ? 'None listed'
                      : policy.mxHosts.join('\n'),
                ),
                RmRow(label: 'Kept for', value: _ageLabel(policy.maxAge)),
                RmRow(
                  label: 'Published',
                  value: canWrite ? null : (policy.active ? 'On' : 'Off'),
                  trailing: canWrite
                      ? RmSwitch(
                          value: policy.active,
                          label: 'Published',
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            where,
            if (canWrite) ...[
              const SizedBox(height: 22),
              RmOutlineButton(
                label: 'Change the policy',
                onPressed: _busy ? null : () => unawaited(_edit()),
              ),
            ],
            if (access.canDelete(AdminSection.mtaSts)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Delete policy',
                    danger: true,
                    onTap: _busy ? null : () => unawaited(_delete(policy)),
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

/// Sets a domain's policy, or makes one. Pops with the policy saved.
class _MtaStsForm extends StatefulWidget {
  const _MtaStsForm({
    required this.account,
    required this.domain,
    required this.policy,
  });

  final RestAccount account;
  final AdminDomain domain;

  /// The policy as it is; none to make one.
  final MtaStsPolicy? policy;

  @override
  State<_MtaStsForm> createState() => _MtaStsFormState();
}

class _MtaStsFormState extends State<_MtaStsForm> {
  late var _mode = widget.policy?.mode ?? MtaStsMode.testing;
  late var _maxAge = widget.policy?.maxAge ?? const Duration(days: 7);
  late final _hosts = TextEditingController(
    text: widget.policy?.mxHosts.join(', ') ?? '',
  );
  var _busy = false;
  String? _error;

  /// What other servers may keep it for: a day while trying it out, then
  /// longer; and what it is now, if that is none of these.
  late final _ages = [
    const Duration(days: 1),
    const Duration(days: 7),
    const Duration(days: 28),
    if (!const [
      Duration(days: 1),
      Duration(days: 7),
      Duration(days: 28),
    ].contains(_maxAge))
      _maxAge,
  ];

  List<String> get _hostList => [
    for (final host in _hosts.text.split(RegExp(r'[,\s]+')))
      if (host.isNotEmpty) host.toLowerCase(),
  ];

  @override
  void dispose() {
    _hosts.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await widget.account.client.setMtaStsPolicy(
        widget.domain.id,
        mode: _mode,
        mxHosts: _hostList,
        maxAge: _maxAge,
      );
      if (mounted) Navigator.pop(context, saved);
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
    return AdminPage(
      account: widget.account,
      section: AdminSection.mtaSts,
      title: widget.policy == null ? 'Set up MTA-STS' : 'MTA-STS',
      body: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
        children: [
          Text(
            'What other servers are told about sending to '
            '${widget.domain.name} over TLS.',
            style: rmText(15, color: c.ink2, height: 1.45),
          ),
          const SizedBox(height: 18),
          const SectionLabel('Mode'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: RmSegmented<MtaStsMode>(
              options: [
                for (final mode in MtaStsMode.values) (mode, _modeLabel(mode)),
              ],
              value: _mode,
              onChanged: (mode) => setState(() => _mode = mode),
            ),
          ),
          const SizedBox(height: 8),
          Text(_modeHelp(_mode), style: rmText(13, color: c.ink3, height: 1.4)),
          const SizedBox(height: 18),
          const SectionLabel('Mail servers'),
          const SizedBox(height: 8),
          TextField(
            controller: _hosts,
            keyboardType: TextInputType.url,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (_) => setState(() => _error = null),
            style: rmText(16, color: c.ink),
            decoration: InputDecoration(
              hintText: 'mx.${widget.domain.name}, *.${widget.domain.name}',
            ),
          ),
          const SizedBox(height: 18),
          const SectionLabel('Other servers keep it for'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: RmSegmented<Duration>(
              options: [for (final age in _ages) (age, _ageLabel(age))],
              value: _maxAge,
              onChanged: (age) => setState(() => _maxAge = age),
            ),
          ),
          if (error != null) ...[const SizedBox(height: 16), ErrorText(error)],
          const SizedBox(height: 26),
          RmPrimaryButton(
            label: 'Save',
            busy: _busy,
            onPressed: !_busy && _hostList.isNotEmpty
                ? () => unawaited(_save())
                : null,
          ),
        ],
      ),
    );
  }
}
