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

String _modeLabel(BuildContext context, MtaStsMode mode) => switch (mode) {
  MtaStsMode.enforce => tr(context, 'admin.mtasts.enforce'),
  MtaStsMode.testing => tr(context, 'admin.mtasts.testing'),
  MtaStsMode.none => tr(context, 'interface.none'),
};

String _modeHelp(BuildContext context, MtaStsMode mode) => switch (mode) {
  MtaStsMode.enforce => tr(
    context,
    'admin.mtasts.otherServersDeliverOnlyOverTLSTo',
  ),
  MtaStsMode.testing => tr(
    context,
    'admin.mtasts.otherServersDeliverAsBeforeAndReport',
  ),
  MtaStsMode.none => tr(
    context,
    'admin.mtasts.tellsOtherServersThePolicyIsWithdrawn',
  ),
};

/// How long other servers keep a policy, in words.
String _ageLabel(BuildContext context, int seconds) {
  if (seconds == 0) return '0 seconds';
  final days = seconds ~/ Duration.secondsPerDay;
  if (days == 1 && seconds == Duration.secondsPerDay)
    return tr(context, 'admin.bans.aDay');
  if (days == 7 && seconds == 7 * Duration.secondsPerDay)
    return tr(context, 'admin.bans.aWeek');
  if (seconds % Duration.secondsPerDay == 0) {
    return days % 7 == 0 ? '${days ~/ 7} weeks' : '$days days';
  }
  if (seconds % Duration.secondsPerHour == 0) {
    final hours = seconds ~/ Duration.secondsPerHour;
    return hours == 1 ? tr(context, 'admin.mtasts.anHour') : '$hours hours';
  }
  return '$seconds seconds';
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
    if (AdminAccess(
      widget.account.capabilities,
      scope: CapabilityScope.domain(widget.domain.name),
    ).canRead(AdminSection.mtaSts)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _loaded = false;
      _policy = null;
      _error = null;
    });
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
    } finally {
      if (mounted) setState(() => _busy = false);
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
    showToast(
      context,
      trArgs(context, 'admin.mtasts.savedThePolicyForName', {
        'name': (_name).toString(),
      }),
    );
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
        title: trArgs(context, 'admin.mtasts.deleteTheMTASTSPolicyForName', {
          'name': (_name).toString(),
        }),
        message: trArgs(
          context,
          'admin.mtasts.theServerStopsPublishingItOtherServers',
          {
            'value': (_ageLabel(
              context,
              policy.maxAgeSeconds,
            ).toLowerCase()).toString(),
          },
        ),
        action: tr(context, 'message.delete'),
      ),
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) _policy = null;
    });
    if (ok)
      showToast(
        context,
        trArgs(context, 'admin.mtasts.deletedThePolicyForName', {
          'name': (_name).toString(),
        }),
      );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final policy = _policy, error = _error;
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.mtaSts,
      title: 'MTA-STS',
      body: (access) {
        if (error != null) {
          return AdminMessage(
            describeAdminError(context, error, host: _host),
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
          trArgs(context, 'admin.mtasts.otherServersFetchItFromHttpsMta', {
            'name': (_name).toString(),
          }),
          style: rmText(13, color: c.ink3, height: 1.4),
        );
        if (policy == null) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
            children: [
              Text(
                trArgs(context, 'admin.mtasts.nameHasNoMTASTSPolicySo', {
                  'name': (_name).toString(),
                }),
                style: rmText(15, color: c.ink2, height: 1.45),
              ),
              const SizedBox(height: 14),
              where,
              const SizedBox(height: 18),
              RmOutlineButton(
                label: tr(context, 'admin.mtasts.refreshPolicy'),
                onPressed: _busy ? null : () => unawaited(_load()),
              ),
              if (canWrite) ...[
                const SizedBox(height: 26),
                RmPrimaryButton(
                  label: tr(context, 'admin.mtasts.setUpAPolicy'),
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
                  label: tr(context, 'admin.granttext.mode'),
                  subtitle: _modeHelp(context, policy.mode),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 4),
                    child: Text(
                      _modeLabel(context, policy.mode),
                      style: rmText(13.5, color: c.ink3),
                    ),
                  ),
                ),
                RmRow(
                  label: tr(context, 'admin.mtasts.mailServers'),
                  subtitle: policy.mxHosts.isEmpty
                      ? tr(context, 'admin.mtasts.noneListed')
                      : policy.mxHosts.join('\n'),
                ),
                RmRow(
                  label: tr(context, 'admin.mtasts.keptFor'),
                  value: _ageLabel(context, policy.maxAgeSeconds),
                ),
                RmRow(
                  label: tr(context, 'admin.mtasts.published'),
                  value: canWrite
                      ? null
                      : (policy.active
                            ? tr(context, 'twoFactor.on')
                            : tr(context, 'twoFactor.off')),
                  trailing: canWrite
                      ? RmSwitch(
                          value: policy.active,
                          label: tr(context, 'admin.mtasts.published'),
                          onChanged: (value) {
                            if (!_busy) unawaited(_setActive(value));
                          },
                        )
                      : null,
                ),
                if (policy.id != 0)
                  RmRow(
                    label: tr(context, 'admin.mtasts.policyID'),
                    value: '${policy.id}',
                  ),
                RmRow(
                  label: tr(context, 'admin.aliases.domain'),
                  value: policy.domain?.name ?? _name,
                ),
                RmRow(
                  label: tr(context, 'admin.filtereditors.domainID'),
                  value: '${policy.domainId}',
                ),
                if (policy.createdAt case final at?)
                  RmRow(
                    label: tr(context, 'admin.aliases.added'),
                    value: timeLabel(at),
                  ),
                if (policy.updatedAt case final at?)
                  RmRow(
                    label: tr(context, 'admin.domains.changed'),
                    value: timeLabel(at),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            where,
            const SizedBox(height: 18),
            RmOutlineButton(
              label: tr(context, 'admin.mtasts.refreshPolicy'),
              onPressed: _busy ? null : () => unawaited(_load()),
            ),
            if (canWrite) ...[
              const SizedBox(height: 22),
              RmOutlineButton(
                label: tr(context, 'admin.mtasts.changeThePolicy'),
                onPressed: _busy ? null : () => unawaited(_edit()),
              ),
            ],
            if (access.canDelete(AdminSection.mtaSts)) ...[
              const SizedBox(height: 22),
              RmGroup(
                children: [
                  RmRow(
                    label: tr(context, 'admin.mtasts.deletePolicy'),
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
  late var _published = widget.policy?.active ?? true;
  late final _seconds = TextEditingController(
    text: '${widget.policy?.maxAgeSeconds ?? 604800}',
  );
  late final _hosts = TextEditingController(
    text: widget.policy?.mxHosts.join(', ') ?? '',
  );
  var _busy = false;
  String? _error;
  String? _lifetimeError;

  List<String> get _hostList => [
    for (final host in _hosts.text.split(RegExp(r'[,\s]+')))
      if (host.isNotEmpty) host.toLowerCase(),
  ];

  @override
  void dispose() {
    _hosts.dispose();
    _seconds.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final seconds = int.tryParse(_seconds.text.trim());
    if (seconds == null || seconds < 0) {
      setState(
        () => _lifetimeError = tr(
          context,
          'admin.mtasts.enterAWholeNumberOfSeconds0',
        ),
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _lifetimeError = null;
    });
    try {
      final saved = await widget.account.client.setMtaStsPolicy(
        widget.domain.id,
        mode: _mode,
        mxHosts: _hostList,
        maxAgeSeconds: seconds,
        active: _published,
      );
      if (mounted) Navigator.pop(context, saved);
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
    return AdminPage(
      scope: CapabilityScope.domain(widget.domain.name),
      account: widget.account,
      section: AdminSection.mtaSts,
      title: widget.policy == null
          ? tr(context, 'admin.mtasts.setUpMTASTS')
          : 'MTA-STS',
      body: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
        children: [
          Text(
            trArgs(
              context,
              'admin.mtasts.whatOtherServersAreToldAboutSending',
              {'name': (widget.domain.name).toString()},
            ),
            style: rmText(15, color: c.ink2, height: 1.45),
          ),
          const SizedBox(height: 18),
          SectionLabel(tr(context, 'admin.granttext.mode')),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: RmSegmented<MtaStsMode>(
              options: [
                for (final mode in MtaStsMode.values)
                  (mode, _modeLabel(context, mode)),
              ],
              value: _mode,
              onChanged: (mode) {
                if (!_busy) {
                  setState(() {
                    _mode = mode;
                    _error = null;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _modeHelp(context, _mode),
            style: rmText(13, color: c.ink3, height: 1.4),
          ),
          const SizedBox(height: 18),
          SectionLabel(tr(context, 'admin.mtasts.mailServers')),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('mta-sts-hosts'),
            controller: _hosts,
            enabled: !_busy,
            keyboardType: TextInputType.url,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (_) => setState(() => _error = null),
            style: rmText(16, color: c.ink),
            decoration: InputDecoration(
              hintText: 'mx.${widget.domain.name}, *.${widget.domain.name}',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tr(context, 'admin.mtasts.separateNamesWithCommasOrSpacesLeaving'),
            style: rmText(13, color: c.ink3, height: 1.4),
          ),
          const SizedBox(height: 18),
          SectionLabel(tr(context, 'admin.mtasts.otherServersKeepItFor')),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final seconds in [86400, 604800, 2419200])
                ChoiceChip(
                  label: Text(_ageLabel(context, seconds)),
                  selected: _seconds.text == '$seconds',
                  onSelected: _busy
                      ? null
                      : (_) => setState(() {
                          _seconds.text = '$seconds';
                          _error = null;
                          _lifetimeError = null;
                        }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('mta-sts-max-age'),
            controller: _seconds,
            enabled: !_busy,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            onChanged: (_) => setState(() {
              _error = null;
              _lifetimeError = null;
            }),
            style: rmText(16, color: c.ink),
            decoration: InputDecoration(
              labelText: tr(context, 'admin.mtasts.lifetimeInSeconds'),
              helperText: tr(
                context,
                'admin.mtasts.0MeansFetchThePolicyAgainFor',
              ),
              errorText: _lifetimeError,
            ),
          ),
          const SizedBox(height: 18),
          RmRow(
            label: tr(context, 'admin.mtasts.published'),
            trailing: RmSwitch(
              value: _published,
              label: tr(context, 'admin.mtasts.published'),
              onChanged: (value) {
                if (!_busy) {
                  setState(() {
                    _published = value;
                    _error = null;
                  });
                }
              },
            ),
          ),
          if (error != null) ...[const SizedBox(height: 16), ErrorText(error)],
          const SizedBox(height: 26),
          RmPrimaryButton(
            label: tr(context, 'common.save'),
            busy: _busy,
            onPressed: _busy ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
