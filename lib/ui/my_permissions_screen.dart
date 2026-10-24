import 'dart:async';

import '../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'admin/admin_widgets.dart';
import 'admin/grant_text.dart';
import 'widgets/common.dart';

/// The roles this account holds, and switching its eligible ones on for a
/// while. Every REST session reaches it, from Settings: an account whose
/// roles are all eligible, or narrower than Administration lists, holds
/// nothing there until it switches one on here. Seeing and switching its
/// own grants needs no capability; the server answers 404 for anyone
/// else's.
class MyPermissionsScreen extends StatefulWidget {
  const MyPermissionsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<MyPermissionsScreen> createState() => _MyPermissionsScreenState();
}

class _MyPermissionsScreenState extends State<MyPermissionsScreen>
    with WidgetsBindingObserver {
  List<Grant>? _grants;
  ApiException? _error;
  var _loading = true;
  Timer? _expiryTimer;
  var _loadEpoch = 0;

  /// What the last step answered: the grant as it now is, and everything
  /// the session holds after it.
  Escalation? _step;
  String? _stepTitle;

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load(reconcile: true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _expiryTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_load(reconcile: true));
    }
  }

  /// Keep one timer for the next known grant or activation deadline. The
  /// server remains authoritative: refresh returns its current capability
  /// snapshot, then Mine returns the grants and remaining activations.
  void _scheduleExpiry(List<Grant> grants) {
    _expiryTimer?.cancel();
    final now = DateTime.now();
    DateTime? next;
    for (final grant in grants) {
      for (final deadline in [grant.expiresAt, grant.activation?.expiresAt]) {
        if (deadline != null &&
            deadline.isAfter(now) &&
            (next == null || deadline.isBefore(next))) {
          next = deadline;
        }
      }
    }
    if (next != null) {
      _expiryTimer = Timer(next.difference(now), () {
        unawaited(_load(reconcile: true));
      });
    }
  }

  Future<void> _load({bool reconcile = false}) async {
    if (!mounted) return;
    final epoch = ++_loadEpoch;
    _expiryTimer?.cancel();
    setState(() {
      _loading = true;
      _error = null;
      // An older response cannot keep actions visible during a refused or
      // pending reload, or overwrite a more recent reload's result.
      _grants = null;
      if (reconcile) {
        _step = null;
        _stepTitle = null;
      }
    });
    try {
      if (reconcile) await widget.account.client.refresh();
      final grants = await widget.account.client.myGrants();
      if (!mounted || epoch != _loadEpoch) return;
      setState(() {
        _grants = grants;
        _loading = false;
      });
      _scheduleExpiry(grants);
    } on ApiException catch (e) {
      if (!mounted || epoch != _loadEpoch) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _stepped(Escalation step, String title) {
    if (!mounted) return;
    setState(() {
      _step = step;
      _stepTitle = title;
      // The grant as the server now has it, until the reload brings all.
      _grants = [
        for (final g in _grants ?? const <Grant>[])
          g.id == step.grant.id ? step.grant : g,
      ];
    });
    showToast(context, title);
    unawaited(_load());
  }

  Future<void> _activate(Grant grant) async {
    final step = await Navigator.push<Escalation>(
      context,
      MaterialPageRoute(
        builder: (_) => _StepForm(account: widget.account, grant: grant),
      ),
    );
    if (step == null) return;
    final until = step.grant.activation?.expiresAt;
    _stepped(
      step,
      until == null
          ? trArgs(context, 'mypermissions.switchedOnRole', {
              'role': (grant.role).toString(),
            })
          : trArgs(context, 'mypermissions.switchedOnRoleUntilValue', {
              'role': (grant.role).toString(),
              'value': (longDate(until)).toString(),
            }),
    );
  }

  Future<void> _makeEligible(Grant grant) async {
    final step = await Navigator.push<Escalation>(
      context,
      MaterialPageRoute(
        builder: (_) => _StepForm(
          account: widget.account,
          grant: grant,
          makeEligible: true,
        ),
      ),
    );
    if (step != null)
      _stepped(
        step,
        trArgs(context, 'mypermissions.roleIsEligibleNow', {
          'role': (grant.role).toString(),
        }),
      );
  }

  Future<void> _deactivate(Grant grant) async {
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'mypermissions.switchOffRole', {
        'role': (grant.role).toString(),
      }),
      message: tr(context, 'mypermissions.itStopsApplyingAtOnceSwitchingIt'),
      action: tr(context, 'mypermissions.switchOff'),
    );
    if (!sure || !mounted) return;
    try {
      final step = await widget.account.client.deactivateGrant(grant.id);
      _stepped(
        step,
        trArgs(context, 'mypermissions.switchedOffRole', {
          'role': (grant.role).toString(),
        }),
      );
    } on ApiException catch (e) {
      if (mounted) {
        showToast(
          context,
          describeGrantError(context, e, host: _host, escalating: true),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final grants = _grants, error = _error, step = _step;
    final Widget content;
    if (_loading && grants == null) {
      content = const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    } else if (error != null && grants == null) {
      content = AdminMessage(
        describeGrantError(context, error, host: _host, escalating: true),
        onRetry: () => unawaited(_load(reconcile: true)),
      );
    } else if (grants == null || grants.isEmpty) {
      content = AdminMessage(
        trArgs(context, 'mypermissions.youHoldNoRolesOnHost', {
          'host': (_host).toString(),
        }),
      );
    } else {
      content = Column(
        children: [
          for (final grant in grants) ...[
            _GrantCard(
              grant: grant,
              onActivate: () => unawaited(_activate(grant)),
              onDeactivate: () => unawaited(_deactivate(grant)),
              onMakeEligible: () => unawaited(_makeEligible(grant)),
            ),
            const SizedBox(height: 14),
          ],
        ],
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.myPermissions'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.accent,
                onRefresh: () => _load(reconcile: true),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                  children: [
                    Text(
                      '${widget.account.address} · $_host',
                      style: rmText(13, color: c.ink3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr(
                        context,
                        'mypermissions.anActiveRoleAlwaysAppliesAnEligible',
                      ),
                      style: rmText(14, color: c.ink2, height: 1.45),
                    ),
                    const SizedBox(height: 16),
                    if (step != null) ...[
                      _StepSummary(title: _stepTitle ?? '', step: step),
                      const SizedBox(height: 16),
                    ],
                    content,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One grant, what it gives now, and the steps it allows.
class _GrantCard extends StatelessWidget {
  const _GrantCard({
    required this.grant,
    required this.onActivate,
    required this.onDeactivate,
    required this.onMakeEligible,
  });

  final Grant grant;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onMakeEligible;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final ended = grant.isExpiredAt(now);
    final activation = grant.activation;
    final switchedOn =
        grant.mode == GrantMode.eligible && grant.isInForceAt(now);
    return RmGroup(
      children: [
        RmRow(
          label: '${grant.role} · ${scopeLabel(context, grant.scope)}',
          subtitle: [
            if (ended)
              tr(context, 'admin.granttext.ended')
            else
              grantState(context, grant),
            if (activation != null && activation.reason.isNotEmpty)
              trArgs(context, 'mypermissions.whyReason', {
                'reason': (activation.reason).toString(),
              }),
            grantEnds(context, grant),
          ].join('\n'),
        ),
        if (!ended && grant.mode == GrantMode.eligible && !switchedOn)
          RmRow(
            label: tr(context, 'mypermissions.switchOn'),
            onTap: onActivate,
          ),
        if (switchedOn)
          RmRow(
            label: tr(context, 'mypermissions.switchOff'),
            danger: true,
            onTap: onDeactivate,
          ),
        if (!ended && grant.mode == GrantMode.active)
          RmRow(
            label: tr(context, 'mypermissions.makeEligible'),
            subtitle: tr(context, 'mypermissions.holdItOnlyWhenYouSwitchIt'),
            onTap: onMakeEligible,
          ),
      ],
    );
  }
}

/// What the last step left the session holding.
class _StepSummary extends StatelessWidget {
  const _StepSummary({required this.title, required this.step});

  final String title;
  final Escalation step;

  @override
  Widget build(BuildContext context) {
    final names = step.capabilities.toJson();
    final scoped = <String, List<String>>{};
    for (final entry in step.capabilities.scopedToJson()) {
      (scoped[entry['scope']!] ??= []).add(entry['capability']!);
    }
    return RmGroup(
      children: [
        RmRow(
          label: title,
          subtitle: names.isEmpty
              ? scoped.isEmpty
                    ? tr(
                        context,
                        'mypermissions.thisSessionNowHoldsNoCapabilities',
                      )
                    : tr(
                        context,
                        'mypermissions.thisSessionNowHoldsCapabilitiesAtThe',
                      )
              : names.contains(Capabilities.all)
              ? tr(context, 'mypermissions.thisSessionNowHoldsEveryCapability')
              : trArgs(context, 'mypermissions.thisSessionNowHoldsValue', {
                  'value': (names.join(', ')).toString(),
                }),
        ),
        for (final entry in scoped.entries)
          RmRow(
            label: scopeLabel(context, entry.key),
            subtitle: entry.value.join(', '),
          ),
      ],
    );
  }
}

/// How the fresh second factor is given.
enum _CodeKind { totp, recovery }

/// Switching a grant on (a reason, how long, a fresh code), or making one
/// eligible (a fresh code). Pops with the server's answer.
class _StepForm extends StatefulWidget {
  const _StepForm({
    required this.account,
    required this.grant,
    this.makeEligible = false,
  });

  final RestAccount account;
  final Grant grant;
  final bool makeEligible;

  @override
  State<_StepForm> createState() => _StepFormState();
}

class _StepFormState extends State<_StepForm> {
  static const _lengths = [15, 30, 60, 120, 240];

  final _reason = TextEditingController();
  final _code = TextEditingController();
  var _minutes = 60;
  var _kind = _CodeKind.totp;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    _code.dispose();
    super.dispose();
  }

  String? get _problem {
    if (!widget.makeEligible) {
      final reason = _reason.text.trim();
      if (reason.isEmpty)
        return tr(context, 'mypermissions.sayWhyYouAreSwitchingItOn');
      if (reason.runes.length > 500)
        return tr(context, 'mypermissions.keepTheReasonTo500Letters');
    }
    final code = _code.text.trim();
    if (code.isEmpty) {
      return _kind == _CodeKind.totp
          ? tr(
              context,
              'mypermissions.enterTheCurrentCodeFromYourAuthenticator',
            )
          : tr(context, 'mypermissions.enterOneOfYourRecoveryCodes');
    }
    if (_kind == _CodeKind.totp && !RegExp(r'^\d{6}$').hasMatch(code)) {
      return tr(context, 'mypermissions.anAuthenticatorCodeIs6Digits');
    }
    return null;
  }

  Future<void> _send() async {
    final problem = _problem;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = widget.account.client;
    final code = _code.text.trim();
    final totp = _kind == _CodeKind.totp ? code : null;
    final recovery = _kind == _CodeKind.recovery ? code : null;
    try {
      final step = widget.makeEligible
          ? await client.makeGrantEligible(
              widget.grant.id,
              totpCode: totp,
              recoveryCode: recovery,
            )
          : await client.activateGrant(
              widget.grant.id,
              reason: _reason.text.trim(),
              minutes: _minutes,
              totpCode: totp,
              recoveryCode: recovery,
            );
      if (mounted) Navigator.pop(context, step);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _code.clear();
        _error = describeGrantError(
          context,
          e,
          host: widget.account.server.host,
          escalating: true,
        );
      });
    }
  }

  void _changed() => setState(() => _error = null);

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error, grant = widget.grant;
    final eligible = widget.makeEligible;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: eligible
                  ? tr(context, 'mypermissions.makeEligible2')
                  : trArgs(context, 'mypermissions.switchOnRole', {
                      'role': (grant.role).toString(),
                    }),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    eligible
                        ? trArgs(
                            context,
                            'mypermissions.roleAtValueWillGiveNothingUntil',
                            {
                              'role': (grant.role).toString(),
                              'value': (scopeLabel(
                                context,
                                grant.scope,
                              )).toString(),
                            },
                          )
                        : trArgs(
                            context,
                            'mypermissions.roleAtValueAppliesUntilTheTime',
                            {
                              'role': (grant.role).toString(),
                              'value': (scopeLabel(
                                context,
                                grant.scope,
                              )).toString(),
                            },
                          ),
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  if (!eligible) ...[
                    const SizedBox(height: 18),
                    SectionLabel(tr(context, 'quarantine.why')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reason,
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => _changed(),
                      style: rmText(16, color: c.ink),
                      decoration: InputDecoration(
                        hintText: tr(context, 'mypermissions.whatYouNeedItFor'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SectionLabel(tr(context, 'admin.bans.for')),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final m in _lengths)
                          ChoiceChip(
                            label: Text(m < 60 ? '$m min' : '${m ~/ 60} h'),
                            selected: _minutes == m,
                            onSelected: (_) => setState(() => _minutes = m),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),
                  SectionLabel(tr(context, 'mypermissions.code')),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RmSegmented<_CodeKind>(
                      options: [
                        (
                          _CodeKind.totp,
                          tr(context, 'twoFactor.authenticator'),
                        ),
                        (
                          _CodeKind.recovery,
                          tr(context, 'twoFactor.recoveryCode'),
                        ),
                      ],
                      value: _kind,
                      onChanged: (kind) => setState(() {
                        _kind = kind;
                        _code.clear();
                        _error = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _code,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: _kind == _CodeKind.totp
                        ? TextInputType.number
                        : TextInputType.visiblePassword,
                    autofillHints: _kind == _CodeKind.totp
                        ? const [AutofillHints.oneTimeCode]
                        : null,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => _changed(),
                    onSubmitted: (_) => unawaited(_send()),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: _kind == _CodeKind.totp
                          ? tr(context, 'signIn.codeHint')
                          : tr(
                              context,
                              'mypermissions.aRecoveryCodeItIsUsedUp',
                            ),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: eligible
                        ? tr(context, 'mypermissions.makeEligible2')
                        : tr(context, 'mypermissions.switchOn2'),
                    busy: _busy,
                    onPressed: _busy ? null : () => unawaited(_send()),
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
