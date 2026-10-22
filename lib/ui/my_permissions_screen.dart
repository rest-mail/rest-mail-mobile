import 'dart:async';

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

class _MyPermissionsScreenState extends State<MyPermissionsScreen> {
  List<Grant>? _grants;
  ApiException? _error;
  var _loading = true;

  /// What the last step answered: the grant as it now is, and everything
  /// the session holds after it.
  Escalation? _step;
  String? _stepTitle;

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final grants = await widget.account.client.myGrants();
      if (!mounted) return;
      setState(() {
        _grants = grants;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
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
          ? 'Switched on ${grant.role}'
          : 'Switched on ${grant.role} until ${longDate(until)}',
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
    if (step != null) _stepped(step, '${grant.role} is eligible now');
  }

  Future<void> _deactivate(Grant grant) async {
    final sure = await confirmAction(
      context,
      title: 'Switch off ${grant.role}?',
      message:
          'It stops applying at once. Switching it on again takes a reason '
          'and a fresh code.',
      action: 'Switch off',
    );
    if (!sure || !mounted) return;
    try {
      final step = await widget.account.client.deactivateGrant(grant.id);
      _stepped(step, 'Switched off ${grant.role}');
    } on ApiException catch (e) {
      if (mounted) {
        showToast(
          context,
          describeGrantError(e, host: _host, escalating: true),
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
        describeGrantError(error, host: _host, escalating: true),
        onRetry: () => unawaited(_load()),
      );
    } else if (grants == null || grants.isEmpty) {
      content = AdminMessage('You hold no roles on $_host.');
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
              title: 'My permissions',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.accent,
                onRefresh: _load,
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
                      'An active role always applies. An eligible one gives '
                      'nothing until you switch it on for a while, with a '
                      'reason and a fresh code from your authenticator.',
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
    final activation = grant.activation;
    final ended =
        grant.expiresAt != null && grant.expiresAt!.isBefore(DateTime.now());
    return RmGroup(
      children: [
        RmRow(
          label: '${grant.role} · ${scopeLabel(grant.scope)}',
          subtitle: [
            if (ended) 'Ended' else grantState(grant),
            if (activation != null && activation.reason.isNotEmpty)
              'Why: ${activation.reason}',
            grantEnds(grant),
          ].join('\n'),
        ),
        if (!ended && grant.mode == GrantMode.eligible && activation == null)
          RmRow(label: 'Switch on…', onTap: onActivate),
        if (activation != null)
          RmRow(label: 'Switch off', danger: true, onTap: onDeactivate),
        if (!ended && grant.mode == GrantMode.active)
          RmRow(
            label: 'Make eligible…',
            subtitle: 'Hold it only when you switch it on',
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
    return RmGroup(
      children: [
        RmRow(
          label: title,
          subtitle: names.isEmpty
              ? 'This session now holds no admin capabilities.'
              : names.contains(Capabilities.all)
              ? 'This session now holds every capability.'
              : 'This session now holds: ${names.join(', ')}',
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
      if (reason.isEmpty) return 'Say why you are switching it on.';
      if (reason.runes.length > 500) return 'Keep the reason to 500 letters.';
    }
    final code = _code.text.trim();
    if (code.isEmpty) {
      return _kind == _CodeKind.totp
          ? 'Enter the current code from your authenticator.'
          : 'Enter one of your recovery codes.';
    }
    if (_kind == _CodeKind.totp && !RegExp(r'^\d{6}$').hasMatch(code)) {
      return 'An authenticator code is 6 digits.';
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
              title: eligible ? 'Make eligible' : 'Switch on ${grant.role}',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    eligible
                        ? '${grant.role} at ${scopeLabel(grant.scope)} will '
                              'give nothing until you switch it on, with a '
                              'reason and a fresh code each time.'
                        : '${grant.role} at ${scopeLabel(grant.scope)} '
                              'applies until the time is up, or until you '
                              'switch it off. The reason goes in the audit '
                              'log.',
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  if (!eligible) ...[
                    const SizedBox(height: 18),
                    const SectionLabel('Why'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reason,
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => _changed(),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'What you need it for',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SectionLabel('For'),
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
                  const SectionLabel('Code'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RmSegmented<_CodeKind>(
                      options: const [
                        (_CodeKind.totp, 'Authenticator'),
                        (_CodeKind.recovery, 'Recovery code'),
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
                          ? '6-digit code'
                          : 'A recovery code; it is used up',
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: eligible ? 'Make eligible' : 'Switch on',
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
