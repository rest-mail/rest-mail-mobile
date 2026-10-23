import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../util/secret_clipboard.dart';
import 'add_account_screen.dart';
import 'admin/admin_widgets.dart' show AdminMessage;
import 'widgets/common.dart';

/// Manages only the account which signed in, never one of its linked mailboxes.
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  late final AppLifecycleListener _lifecycle;
  final _code = TextEditingController();
  TwoFactorStatus? _status;
  TotpEnrollment? _enrollment;
  bool _busy = false;
  bool _hidden = false;
  bool _saved = false;
  bool _disabling = false;
  bool _recovery = false;
  bool _justEnrolled = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () => setState(() => _hidden = true),
      onResume: () => setState(() => _hidden = false),
    );
    unawaited(_load());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _code.dispose();
    _enrollment = null;
    super.dispose();
  }

  String _describe(ApiException e) => switch (e.code) {
    'invalid_totp' =>
      "That authenticator code didn't work. Try a current code.",
    'invalid_recovery_code' =>
      "That recovery code didn't work or has already been used.",
    'two_factor_required' => 'This account must keep two-factor sign-in. The server will not turn it off.',
    'conflict' =>
      'Two-factor sign-in is already on. Go back and reload its status.',
    'forbidden' => e.message,
    _ when e.fields.isNotEmpty => e.fields.values.first,
    _ => describeError(e, host: widget.account.server.host),
  };

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _status = null;
      _error = null;
    });
    try {
      final status = await widget.account.client.twoFactorStatus();
      if (mounted) setState(() => _status = status);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = _describe(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = _describe(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _enroll() => _run(() async {
    final enrollment = await widget.account.client.enrollTwoFactor();
    if (!mounted) return;
    setState(() {
      _enrollment = enrollment;
      _saved = false;
      _code.clear();
    });
  });

  Future<void> _confirm() => _run(() async {
    await widget.account.client.confirmTwoFactor(_code.text.trim());
    if (!mounted) return;
    setState(() {
      _enrollment = null;
      _code.clear();
      _status = const TwoFactorStatus(enabled: true, pending: false);
      _justEnrolled = true;
    });
  });

  Future<void> _disable() async {
    if (_busy || _code.text.trim().isEmpty) return;
    final sure = await confirmAction(
      context,
      title: 'Turn off two-factor sign-in?',
      message:
          'Every sign-in session for ${widget.account.address} ends, '
          'including this phone. Sign in again with your password.',
      action: 'Turn off and sign out',
    );
    if (!sure || !mounted) return;
    await _run(() async {
      await widget.account.client.disableTwoFactor(
        totpCode: _recovery ? null : _code.text.trim(),
        recoveryCode: _recovery ? _code.text.trim() : null,
      );
      // The client token callback ends the app session, clears the saved
      // credential through its write queue and replaces this navigator.
      if (mounted) _code.clear();
    });
  }

  Future<void> _copy(String secret) async {
    final expires = await const SecretClipboard().copy(secret);
    if (!mounted) return;
    showToast(
      context,
      expires
          ? 'Copied to this phone for ${SecretClipboard.lifetime.inMinutes} minutes'
          : 'Copied. Clear the clipboard after saving it.',
    );
  }

  Future<void> _openAuthenticator(TotpEnrollment enrollment) async {
    var opened = false;
    try {
      if (enrollment.otpauthUri.scheme == 'otpauth') {
        opened = await launchUrl(
          enrollment.otpauthUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } on PlatformException {
      opened = false;
    } on MissingPluginException {
      opened = false;
    }
    if (!opened && mounted) {
      showToast(context, 'Open an authenticator app and enter the setup key.');
    }
  }

  Widget _proofField({required bool recovery}) => TextField(
    key: const ValueKey('two-factor-code'),
    controller: _code,
    obscureText: recovery,
    autocorrect: false,
    enableSuggestions: false,
    keyboardType: recovery ? TextInputType.text : TextInputType.number,
    inputFormatters: recovery ? null : [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      hintText: recovery
          ? 'An unused recovery code'
          : 'Code from your authenticator',
    ),
    onChanged: (_) => setState(() => _error = null),
  );

  List<Widget> _enrollmentFields(TotpEnrollment enrollment) {
    final c = context.rm;
    if (_hidden) {
      return [
        Text(
          'Setup details hidden while REST Mail is in the background',
          style: rmText(14, color: c.ink3),
        ),
      ];
    }
    return [
      Text(
        'Add ${widget.account.address} to your authenticator. Save the recovery codes somewhere else before confirming.',
        style: rmText(14, color: c.ink2, height: 1.45),
      ),
      const SizedBox(height: 18),
      RmOutlineButton(
        label: 'Open authenticator app',
        onPressed: () => unawaited(_openAuthenticator(enrollment)),
      ),
      const SizedBox(height: 12),
      const SectionLabel('Setup key'),
      const SizedBox(height: 8),
      Text(enrollment.secret, style: rmText(15, color: c.ink)),
      TextButton(
        onPressed: () => unawaited(_copy(enrollment.secret)),
        child: const Text('Copy setup key'),
      ),
      const SizedBox(height: 18),
      const SectionLabel('Recovery codes'),
      const SizedBox(height: 8),
      Text(
        enrollment.recoveryCodes.join('\n'),
        style: rmText(15, color: c.ink, height: 1.5),
      ),
      TextButton(
        onPressed: () => unawaited(_copy(enrollment.recoveryCodes.join('\n'))),
        child: const Text('Copy recovery codes'),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: _saved,
        onChanged: _busy
            ? null
            : (value) => setState(() => _saved = value ?? false),
        title: const Text("I've saved my recovery codes"),
      ),
      _proofField(recovery: false),
      const SizedBox(height: 18),
      RmPrimaryButton(
        label: 'Confirm authenticator',
        busy: _busy,
        onPressed: !_busy && _saved && _code.text.trim().isNotEmpty
            ? () => unawaited(_confirm())
            : null,
      ),
    ];
  }

  List<Widget> _statusFields(TwoFactorStatus status) {
    final c = context.rm;
    return [
      RmRow(
        label: 'Two-factor sign-in',
        value: status.enabled
            ? 'On'
            : status.pending
            ? 'Not confirmed'
            : 'Off',
      ),
      const SizedBox(height: 18),
      if (!status.enabled) ...[
        Text(
          status.pending
              ? 'An enrollment was started but not confirmed. Restarting creates a new setup key and recovery codes.'
              : 'Use an authenticator code as well as your password when signing in.',
          style: rmText(14, color: c.ink2, height: 1.45),
        ),
        const SizedBox(height: 18),
        RmPrimaryButton(
          label: status.pending ? 'Restart enrollment' : 'Set up authenticator',
          busy: _busy,
          onPressed: _busy ? null : () => unawaited(_enroll()),
        ),
      ] else ...[
        if (_justEnrolled) ...[
          Text(
            'Authenticator enabled. Sign in again with a code to use protected account actions.',
            style: rmText(14, color: c.ink2, height: 1.45),
          ),
          TextButton(
            onPressed: () => unawaited(
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => AddAccountScreen(
                    server: widget.account.server,
                    email: widget.account.address,
                  ),
                ),
              ),
            ),
            child: const Text('Sign in again'),
          ),
          const SizedBox(height: 18),
        ],
        if (!_disabling)
          RmOutlineButton(
            label: 'Turn off two-factor sign-in',
            onPressed: _busy
                ? null
                : () => setState(() {
                    _disabling = true;
                    _code.clear();
                    _error = null;
                  }),
          )
        else ...[
          Wrap(
            spacing: 8,
            children: [
              for (final (value, label) in [
                (false, 'Authenticator'),
                (true, 'Recovery code'),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _recovery == value,
                  onSelected: _busy
                      ? null
                      : (_) => setState(() {
                          _recovery = value;
                          _code.clear();
                          _error = null;
                        }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _proofField(recovery: _recovery),
          const SizedBox(height: 18),
          RmPrimaryButton(
            label: 'Turn off and sign out',
            busy: _busy,
            onPressed: !_busy && _code.text.trim().isNotEmpty
                ? () => unawaited(_disable())
                : null,
          ),
          TextButton(
            onPressed: _busy
                ? null
                : () => setState(() {
                    _disabling = false;
                    _code.clear();
                    _error = null;
                  }),
            child: const Text('Cancel'),
          ),
        ],
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final status = _status, enrollment = _enrollment, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Two-factor sign-in',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: status == null
                  ? error != null
                        ? AdminMessage(error, onRetry: () => unawaited(_load()))
                        : const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _busy || enrollment != null
                          ? () async {}
                          : _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                        children: [
                          Text(
                            widget.account.address,
                            style: rmText(14, color: c.ink3),
                          ),
                          const SizedBox(height: 18),
                          if (enrollment != null)
                            ..._enrollmentFields(enrollment)
                          else
                            ..._statusFields(status),
                          if (error != null) ...[
                            const SizedBox(height: 16),
                            ErrorText(error),
                          ],
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
