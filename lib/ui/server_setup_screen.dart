import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart' show FakeAccounts;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/voice.dart';
import '../sample_mode.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import '../util/sign_in_link.dart';
import 'scan_sign_in_screen.dart';
import 'widgets/common.dart';

/// Where the first-start setup has got to.
enum _Step {
  /// Sign in as the account a fresh install made (`admin@` its domain), with
  /// the password the installer generated and showed.
  signIn,

  /// Enroll an authenticator, keeping the recovery codes.
  authenticator,

  /// Replace the deploy's password with one only the owner knows.
  password,

  /// The server ended every session when the password changed: sign back in,
  /// with a code this time. That session is the one the app keeps.
  signBackIn,
}

/// Takes a freshly installed REST Mail server to the owner reading their own
/// mail. The installer made its first account, `admin@` its domain, with a
/// password it showed once, as text and as a QR code; signing in with it, the
/// owner must replace it with their own and enroll an authenticator before
/// the server will do anything else. That account is a mailbox, and an
/// administrator by the grants it holds: once it is set up, the app keeps its
/// session as any account's, and Administration shows by its capabilities.
///
/// The sessions in setup live only on this screen, and are never stored.
class ServerSetupScreen extends StatefulWidget {
  const ServerSetupScreen({
    super.key,
    required this.server,
    this.address,
    this.password,
  });

  final Uri server;

  /// The sign-in from the installer's QR code, filled in.
  final String? address;
  final String? password;

  /// Opens the camera for the installer's QR code. Tests replace it: there is
  /// no camera there.
  @visibleForTesting
  static Future<SignInLink?> Function(BuildContext) scanSignIn =
      ScanSignInScreen.open;

  @override
  State<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends State<ServerSetupScreen> {
  /// Made on first use: leaving before any call must not look up the app
  /// scope from dispose(), where the tree is already being torn down.
  RestmailClient? _client;
  RestmailClient get _admin =>
      _client ??= AppScope.read(context).probe(widget.server);

  var _step = _Step.signIn;
  var _busy = false;
  String? _error;

  // Sign-in, kept for the steps that need them again.
  late final _address = TextEditingController(
    text: widget.address ?? 'admin@${_defaultDomain()}',
  );
  late final _password = TextEditingController(text: widget.password);
  final _code = TextEditingController();
  var _needsCode = false;
  var _owed = <SetupStep>[];

  // Authenticator.
  TotpEnrollment? _enrollment;
  var _savedCodes = false;

  // New password.
  final _newPassword = TextEditingController();
  final _repeatPassword = TextEditingController();

  @override
  void dispose() {
    _client?.close();
    for (final c in [
      _address,
      _password,
      _code,
      _newPassword,
      _repeatPassword,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// `mail.example.com` serves `example.com`: the app finds a server at
  /// `mail.<domain>` from an address at `<domain>`, and an install's first
  /// account is `admin@<domain>`.
  String _defaultDomain() {
    final host = widget.server.host;
    return host.startsWith('mail.') ? host.substring(5) : host;
  }

  /// Runs [action] with the spinner up, showing what the server objected to.
  Future<void> _run(Future<void> Function() action) async {
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

  String _describe(ApiException e) {
    if (e.fields.isNotEmpty) return e.fields.values.first;
    return switch (e.code) {
      'unauthorized' when _step == _Step.signIn => tr(
        context,
        _needsCode ? 'signIn.badCode' : 'signIn.badPassword',
      ),
      // A wrong code or password once signed in is 403, and the session
      // stays: say which, and let them try again.
      'invalid_totp' => tr(context, 'signIn.badCode'),
      'invalid_password' => tr(context, 'setup.notCurrentPassword'),
      _ => describeError(context, e, host: widget.server.host),
    };
  }

  // ── Steps ──────────────────────────────────────────────────────────────

  Future<void> _scan() async {
    final scan = await ServerSetupScreen.scanSignIn(context);
    if (scan == null || !mounted) return;
    final server = scan.server;
    if (server != null && server.host != widget.server.host) {
      setState(
        () => _error = trArgs(context, 'setup.otherServer', {
          'code': server.host,
          'server': widget.server.host,
        }),
      );
      return;
    }
    setState(() {
      if (scan.address case final address?) _address.text = address;
      _password.text = scan.password;
      _error = null;
    });
  }

  Future<void> _signIn() => _run(() async {
    try {
      final result = await _admin.login(
        email: _address.text.trim(),
        password: _password.text,
        totpCode: _needsCode ? _code.text.trim() : null,
      );
      _code.clear();
      _owed = result.setupRequired;
      await _advance(result);
    } on TotpRequiredException {
      // Already has an authenticator: a setup started before, or a server set
      // up already, where all that is left is to sign in.
      setState(() => _needsCode = true);
    }
  });

  /// Moves to the next thing the account owes. A session that owes nothing
  /// is kept as the account's, and the app opens its mail.
  Future<void> _advance(LoginResult? signedIn) async {
    if (signedIn != null && signedIn.isSetUp) {
      await AppScope.read(context)
          .keep(widget.server, signedIn.user, _admin.tokens!);
      TextInput.finishAutofillContext();
      // Signed in: the app replaces this screen with the mailbox on its own.
      return;
    }
    setState(() {
      if (_owed.contains(SetupStep.twoFactor)) {
        _step = _Step.authenticator;
      } else if (_owed.contains(SetupStep.password)) {
        _step = _Step.password;
      } else {
        // Setup just finished; this session was minted while it was owed.
        _step = _Step.signBackIn;
      }
    });
  }

  Future<void> _startEnrollment() => _run(() async {
    final enrollment = await _admin.enrollTwoFactor();
    setState(() => _enrollment = enrollment);
  });

  Future<void> _confirmAuthenticator() => _run(() async {
    await _admin.confirmTwoFactor(_code.text.trim());
    _code.clear();
    _owed = [..._owed]..remove(SetupStep.twoFactor);
    await _advance(null);
  });

  Future<void> _changePassword() => _run(() async {
    final next = _newPassword.text;
    if (next != _repeatPassword.text) {
      setState(() => _error = tr(context, 'setup.mismatch'));
      return;
    }
    await _admin.changePassword(current: _password.text, next: next);
    // The server ended every session: the new password is the one now.
    _password.text = next;
    _owed = [..._owed]..remove(SetupStep.password);
    await _advance(null);
  });

  Future<void> _signBackIn() => _run(() async {
    final result = await _admin.login(
      email: _address.text.trim(),
      password: _password.text,
      totpCode: _code.text.trim(),
    );
    _code.clear();
    _owed = result.setupRequired;
    await _advance(result);
  });

  // ── Layout ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    final (title, intro, fields, action) = switch (_step) {
      _Step.signIn => _signInStep(c),
      _Step.authenticator => _authenticatorStep(c),
      _Step.password => _passwordStep(c),
      _Step.signBackIn => _signBackInStep(c),
    };
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: title, onBack: () => Navigator.pop(context)),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    _Progress(step: _step),
                    const SizedBox(height: 18),
                    Text(intro, style: rmText(15, color: c.ink2, height: 1.45)),
                    ...fields,
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      ErrorText(error),
                    ],
                    const SizedBox(height: 26),
                    action,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StepView _signInStep(RmColors c) => (
    trArgs(context, 'setup.title', {'host': widget.server.host}),
    tr(context, 'setup.signInIntro'),
    [
      if (sampleMode) ...[
        const SizedBox(height: 14),
        _SampleHint(
          trArgs(
            context,
            'serversetup.sampleServerAdminEmailPasswordBootstrapPasswordCodesTotpCode',
            {
              'adminEmail': (FakeAccounts.adminEmail).toString(),
              'bootstrapPassword': (FakeAccounts.bootstrapPassword).toString(),
              'totpCode': (FakeAccounts.totpCode).toString(),
            },
          ),
        ),
      ],
      const SizedBox(height: 18),
      RmOutlineButton(
        label: tr(context, 'setup.scan'),
        onPressed: _busy ? null : () => unawaited(_scan()),
      ),
      const SizedBox(height: 22),
      SectionLabel(tr(context, 'signIn.email')),
      const SizedBox(height: 8),
      _field(
        _address,
        autocorrect: false,
        email: true,
        autofill: const [AutofillHints.email],
      ),
      const SizedBox(height: 22),
      SectionLabel(tr(context, 'signIn.password')),
      const SizedBox(height: 8),
      _field(
        _password,
        obscure: true,
        hint: tr(context, 'setup.fromInstaller'),
        autofill: const [AutofillHints.password],
        onSubmitted: _signIn,
      ),
      if (_needsCode) ...[
        const SizedBox(height: 22),
        SectionLabel(tr(context, 'signIn.twoFactorCode')),
        const SizedBox(height: 8),
        _codeField(onSubmitted: _signIn),
      ],
    ],
    _primary(
      tr(context, 'signIn.continue'),
      _signIn,
      ready: _address.text.contains('@') && _password.text.isNotEmpty,
    ),
  );

  _StepView _authenticatorStep(RmColors c) {
    final enrollment = _enrollment;
    if (enrollment == null) {
      return (
        tr(context, 'twoFactor.title'),
        tr(context, 'setup.needsAuthenticator'),
        const [],
        _primary(tr(context, 'twoFactor.setUp'), _startEnrollment),
      );
    }
    return (
      tr(context, 'twoFactor.title'),
      tr(context, 'setup.addToAuthenticator'),
      [
        const SizedBox(height: 18),
        RmOutlineButton(
          label: tr(context, 'twoFactor.openApp'),
          onPressed: () => unawaited(
            launchUrl(
              enrollment.otpauthUri,
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              unawaited(
                Clipboard.setData(ClipboardData(text: enrollment.secret)),
              );
              showToast(context, tr(context, 'setup.keyCopied'));
            },
            child: Text(
              tr(context, 'setup.copyKey'),
              style: rmText(13.5, color: c.accent, weight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionLabel(tr(context, 'twoFactor.recoveryCodes')),
        const SizedBox(height: 8),
        Text(
          tr(context, 'setup.recoveryNote'),
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 10),
        SelectableText(
          enrollment.recoveryCodes.join('\n'),
          style: rmText(15, color: c.ink, tracking: 0.08, height: 1.5),
        ),
        const SizedBox(height: 10),
        RmOutlineButton(
          label: tr(context, 'setup.saveCodes'),
          onPressed: () => unawaited(
            SharePlus.instance.share(
              ShareParams(
                text:
                    '${trArgs(context, 'setup.codesFor', {'address': _address.text.trim(), 'host': widget.server.host})}\n'
                    '${enrollment.recoveryCodes.join('\n')}',
              ),
            ),
          ),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _savedCodes,
          onChanged: (v) => setState(() => _savedCodes = v ?? false),
          title: Text(
            tr(context, 'twoFactor.saved'),
            style: rmText(14.5, color: c.ink),
          ),
        ),
        const SizedBox(height: 12),
        SectionLabel(tr(context, 'twoFactor.codeHint')),
        const SizedBox(height: 8),
        _codeField(onSubmitted: _confirmAuthenticator),
      ],
      _primary(
        tr(context, 'setup.confirm'),
        _confirmAuthenticator,
        ready: _savedCodes && _code.text.trim().length >= 6,
      ),
    );
  }

  _StepView _passwordStep(RmColors c) => (
    tr(context, 'setup.passwordTitle'),
    tr(context, 'setup.passwordIntro'),
    [
      const SizedBox(height: 22),
      SectionLabel(tr(context, 'setup.newPassword')),
      const SizedBox(height: 8),
      _field(
        _newPassword,
        obscure: true,
        autofill: const [AutofillHints.newPassword],
      ),
      const SizedBox(height: 22),
      SectionLabel(tr(context, 'setup.repeatPassword')),
      const SizedBox(height: 8),
      _field(_repeatPassword, obscure: true, onSubmitted: _changePassword),
    ],
    _primary(
      tr(context, 'setup.changePassword'),
      _changePassword,
      ready: _newPassword.text.length >= 12,
    ),
  );

  _StepView _signBackInStep(RmColors c) => (
    tr(context, 'setup.signBackIn'),
    tr(context, 'setup.signBackInIntro'),
    [
      const SizedBox(height: 22),
      SectionLabel(tr(context, 'signIn.twoFactorCode')),
      const SizedBox(height: 8),
      _codeField(onSubmitted: _signBackIn),
    ],
    _primary(
      tr(context, 'signIn.continue'),
      _signBackIn,
      ready: _code.text.trim().length >= 6,
    ),
  );

  // ── Pieces ─────────────────────────────────────────────────────────────

  Widget _field(
    TextEditingController controller, {
    bool obscure = false,
    bool autocorrect = true,
    bool email = false,
    String? hint,
    List<String>? autofill,
    Future<void> Function()? onSubmitted,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    autocorrect: autocorrect && !obscure,
    enableSuggestions: !obscure && autocorrect,
    autofillHints: autofill,
    keyboardType: email ? TextInputType.emailAddress : null,
    onChanged: (_) => setState(() => _error = null),
    onSubmitted: onSubmitted == null ? null : (_) => unawaited(onSubmitted()),
    style: rmText(16, color: context.rm.ink),
    decoration: InputDecoration(hintText: hint),
  );

  Widget _codeField({required Future<void> Function() onSubmitted}) =>
      TextField(
        controller: _code,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        autocorrect: false,
        onChanged: (_) => setState(() => _error = null),
        onSubmitted: (_) => unawaited(onSubmitted()),
        style: rmText(16, color: context.rm.ink, tracking: 0.08),
        decoration: InputDecoration(hintText: tr(context, 'signIn.codeHint')),
      );

  Widget _primary(
    String label,
    Future<void> Function() onPressed, {
    bool ready = true,
  }) => RmPrimaryButton(
    label: label,
    busy: _busy,
    onPressed: ready ? () => unawaited(onPressed()) : null,
  );
}

/// A step: its title, what it asks, its fields, and the button that takes it.
typedef _StepView = (String, String, List<Widget>, Widget);

/// Where the owner is in the three things a fresh server needs.
class _Progress extends StatelessWidget {
  const _Progress({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final index = switch (step) {
      _Step.signIn => 0,
      _Step.authenticator => 1,
      _Step.password || _Step.signBackIn => 2,
    };
    return Text(
      trArgs(context, 'setup.step', {'step': '${index + 1}', 'of': '3'}),
      style: rmText(12.5, color: c.ink3, weight: FontWeight.w600),
    );
  }
}

class _SampleHint extends StatelessWidget {
  const _SampleHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: rmText(
      13,
      color: context.rm.accent,
      weight: FontWeight.w600,
      height: 1.4,
    ),
  );
}
