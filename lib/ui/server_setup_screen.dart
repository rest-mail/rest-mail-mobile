import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart' show FakeAccounts;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sample_mode.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import '../util/sign_in_link.dart';
import 'scan_sign_in_screen.dart';
import 'widgets/common.dart';

/// Where the first-start setup has got to.
enum _Step {
  /// Sign in as the admin a fresh install made, with the password the
  /// installer generated and showed.
  signIn,

  /// Enroll an authenticator, keeping the recovery codes.
  authenticator,

  /// Replace the deploy's password with one only the owner knows.
  password,

  /// The server ended every session when the password changed: sign back in,
  /// with a code this time.
  signBackIn,

  /// Make the domain and the owner's own mailbox, then sign in to it.
  mailbox,
}

/// Takes a freshly installed rest-mail server to the owner reading their own
/// mail. The installer made its first admin with a password it showed once,
/// as text and as a QR code; signing in with it, the owner must replace it
/// with their own and enroll an authenticator before the server will do
/// anything else, and a server with no mailbox has nothing to read.
///
/// The admin session lives only on this screen. It is never stored: the app
/// signs in to the mailbox made at the end, as any account is signed in.
class ServerSetupScreen extends StatefulWidget {
  const ServerSetupScreen({
    super.key,
    required this.server,
    this.username,
    this.password,
  });

  final Uri server;

  /// The sign-in from the installer's QR code, filled in.
  final String? username;
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
  late final _username = TextEditingController(
    text: widget.username ?? 'admin',
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

  // Mailbox.
  late final _domain = TextEditingController(text: _defaultDomain());
  final _localPart = TextEditingController();
  final _displayName = TextEditingController();
  final _mailboxPassword = TextEditingController();

  @override
  void dispose() {
    _client?.close();
    for (final c in [
      _username,
      _password,
      _code,
      _newPassword,
      _repeatPassword,
      _domain,
      _localPart,
      _displayName,
      _mailboxPassword,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// `mail.example.com` serves `example.com`: the app finds a server at
  /// `mail.<domain>` from an address at `<domain>`.
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
      'unauthorized' => switch (_step) {
        _Step.signIn =>
          _needsCode ? "That code didn't work." : 'Wrong username or password.',
        _Step.password => e.message,
        _ => "That code didn't work.",
      },
      _ => describeError(e, host: widget.server.host),
    };
  }

  // ── Steps ──────────────────────────────────────────────────────────────

  Future<void> _scan() async {
    final scan = await ServerSetupScreen.scanSignIn(context);
    if (scan == null || !mounted) return;
    final server = scan.server;
    if (server != null && server.host != widget.server.host) {
      setState(
        () => _error =
            'That code is for ${server.host}, not ${widget.server.host}.',
      );
      return;
    }
    setState(() {
      _username.text = scan.username;
      _password.text = scan.password;
      _error = null;
    });
  }

  Future<void> _signIn() => _run(() async {
    try {
      final admin = await _admin.signInAdmin(
        username: _username.text.trim(),
        password: _password.text,
        totpCode: _needsCode ? _code.text.trim() : null,
      );
      _code.clear();
      _owed = admin.setupRequired;
      _advance();
    } on TotpRequiredException {
      // Already has an authenticator: a setup started before, or a server set
      // up already, where all that is left is the mailbox.
      setState(() => _needsCode = true);
    }
  });

  /// Moves to the next thing the account owes, or past setup when it owes
  /// nothing.
  void _advance() => setState(() {
    if (_owed.contains(SetupStep.twoFactor)) {
      _step = _Step.authenticator;
    } else if (_owed.contains(SetupStep.password)) {
      _step = _Step.password;
    } else if (_step == _Step.signIn || _step == _Step.signBackIn) {
      _step = _Step.mailbox;
    } else {
      // Setup just finished; this session was minted while it was owed.
      _step = _Step.signBackIn;
    }
  });

  Future<void> _startEnrollment() => _run(() async {
    final enrollment = await _admin.enrollTwoFactor();
    setState(() => _enrollment = enrollment);
  });

  Future<void> _confirmAuthenticator() => _run(() async {
    await _admin.confirmTwoFactor(_code.text.trim());
    _code.clear();
    _owed = [..._owed]..remove(SetupStep.twoFactor);
    _advance();
  });

  Future<void> _changePassword() => _run(() async {
    final next = _newPassword.text;
    if (next != _repeatPassword.text) {
      setState(() => _error = "The passwords don't match.");
      return;
    }
    await _admin.changePassword(current: _password.text, next: next);
    // The server ended every session: the new password is the one now.
    _password.text = next;
    _owed = [..._owed]..remove(SetupStep.password);
    _advance();
  });

  Future<void> _signBackIn() => _run(() async {
    final admin = await _admin.signInAdmin(
      username: _username.text.trim(),
      password: _password.text,
      totpCode: _code.text.trim(),
    );
    _code.clear();
    _owed = admin.setupRequired;
    _advance();
  });

  Future<void> _createMailbox() => _run(() async {
    final domain = _domain.text.trim().toLowerCase();
    final address = '${_localPart.text.trim().toLowerCase()}@$domain';
    final name = _displayName.text.trim();
    try {
      await _admin.createDomain(domain);
    } on ApiException catch (e) {
      // Already served here: that is the domain wanted.
      if (e.code != 'already_exists') rethrow;
    }
    await _admin.createMailbox(
      address: address,
      password: _mailboxPassword.text,
      displayName: name.isEmpty ? null : name,
    );
    if (!mounted) return;
    // The admin session ends here; the owner's mailbox is the account kept.
    await _admin.logout();
    if (!mounted) return;
    await AppScope.read(context).signIn(
      server: widget.server,
      email: address,
      password: _mailboxPassword.text,
    );
    TextInput.finishAutofillContext();
    // Signed in: the app replaces this screen with the mailbox on its own.
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
      _Step.mailbox => _mailboxStep(c),
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
    'Set up ${widget.server.host}',
    'Sign in as the admin your install created, with the password the '
        'installer showed you: scan its QR code, or type it. You will replace '
        'it in a moment.',
    [
      if (sampleMode) ...[
        const SizedBox(height: 14),
        _SampleHint(
          'Sample server: ${FakeAccounts.adminUsername}, password '
          '${FakeAccounts.bootstrapPassword}, codes ${FakeAccounts.totpCode}.',
        ),
      ],
      const SizedBox(height: 18),
      RmOutlineButton(
        label: 'Scan the QR code',
        onPressed: _busy ? null : () => unawaited(_scan()),
      ),
      const SizedBox(height: 22),
      const SectionLabel('Admin username'),
      const SizedBox(height: 8),
      _field(_username, autofill: const [AutofillHints.username]),
      const SizedBox(height: 22),
      const SectionLabel('Password'),
      const SizedBox(height: 8),
      _field(
        _password,
        obscure: true,
        hint: 'From the installer',
        autofill: const [AutofillHints.password],
        onSubmitted: _signIn,
      ),
      if (_needsCode) ...[
        const SizedBox(height: 22),
        const SectionLabel('Two-factor code'),
        const SizedBox(height: 8),
        _codeField(onSubmitted: _signIn),
      ],
    ],
    _primary('Continue', _signIn, ready: _password.text.isNotEmpty),
  );

  _StepView _authenticatorStep(RmColors c) {
    final enrollment = _enrollment;
    if (enrollment == null) {
      return (
        'Two-factor sign-in',
        'This account needs an authenticator app: from now on, signing in as '
            'admin takes a code from it as well as the password.',
        const [],
        _primary('Set up authenticator', _startEnrollment),
      );
    }
    return (
      'Two-factor sign-in',
      'Add this account to your authenticator, then type the code it shows.',
      [
        const SizedBox(height: 18),
        RmOutlineButton(
          label: 'Open authenticator app',
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
              showToast(context, 'Setup key copied');
            },
            child: Text(
              'Or copy the setup key',
              style: rmText(13.5, color: c.accent, weight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionLabel('Recovery codes'),
        const SizedBox(height: 8),
        Text(
          'The only way back in if you lose this phone. Keep them somewhere '
          'else; they are not shown again.',
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 10),
        SelectableText(
          enrollment.recoveryCodes.join('\n'),
          style: rmText(15, color: c.ink, tracking: 0.08, height: 1.5),
        ),
        const SizedBox(height: 10),
        RmOutlineButton(
          label: 'Save recovery codes',
          onPressed: () => unawaited(
            SharePlus.instance.share(
              ShareParams(
                text:
                    'rest-mail recovery codes for '
                    '${_username.text.trim()}@${widget.server.host}:\n'
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
            "I've saved my recovery codes",
            style: rmText(14.5, color: c.ink),
          ),
        ),
        const SizedBox(height: 12),
        const SectionLabel('Code from your authenticator'),
        const SizedBox(height: 8),
        _codeField(onSubmitted: _confirmAuthenticator),
      ],
      _primary(
        'Confirm',
        _confirmAuthenticator,
        ready: _savedCodes && _code.text.trim().length >= 6,
      ),
    );
  }

  _StepView _passwordStep(RmColors c) => (
    'Your own password',
    'The password you signed in with came from the deploy. Choose one only '
        'you know: 12 characters or more. Then sign in again with it.',
    [
      const SizedBox(height: 22),
      const SectionLabel('New password'),
      const SizedBox(height: 8),
      _field(
        _newPassword,
        obscure: true,
        autofill: const [AutofillHints.newPassword],
      ),
      const SizedBox(height: 22),
      const SectionLabel('Repeat it'),
      const SizedBox(height: 8),
      _field(_repeatPassword, obscure: true, onSubmitted: _changePassword),
    ],
    _primary(
      'Change password',
      _changePassword,
      ready: _newPassword.text.length >= 12,
    ),
  );

  _StepView _signBackInStep(RmColors c) => (
    'Sign back in',
    'The admin account is set up. Sign in again with a fresh code from your '
        'authenticator to carry on.',
    [
      const SizedBox(height: 22),
      const SectionLabel('Two-factor code'),
      const SizedBox(height: 8),
      _codeField(onSubmitted: _signBackIn),
    ],
    _primary('Continue', _signBackIn, ready: _code.text.trim().length >= 6),
  );

  _StepView _mailboxStep(RmColors c) => (
    'Your mailbox',
    'The server is yours now. Make the mailbox you will read here.',
    [
      const SizedBox(height: 22),
      const SectionLabel('Address'),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: _field(_localPart, hint: 'you', autocorrect: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('@', style: rmText(17, color: c.ink2)),
          ),
          Expanded(
            flex: 2,
            child: _field(_domain, hint: 'example.com', autocorrect: false),
          ),
        ],
      ),
      const SizedBox(height: 22),
      const SectionLabel('Your name'),
      const SizedBox(height: 8),
      _field(_displayName, autofill: const [AutofillHints.name]),
      const SizedBox(height: 22),
      const SectionLabel('Mailbox password'),
      const SizedBox(height: 8),
      _field(
        _mailboxPassword,
        obscure: true,
        autofill: const [AutofillHints.newPassword],
        onSubmitted: _createMailbox,
      ),
      const SizedBox(height: 8),
      Text(
        'What you sign in to your mail with. Separate from the admin password.',
        style: rmText(12.5, color: c.ink3, height: 1.4),
      ),
    ],
    _primary(
      'Create mailbox and sign in',
      _createMailbox,
      ready:
          _localPart.text.trim().isNotEmpty &&
          _domain.text.trim().isNotEmpty &&
          _mailboxPassword.text.isNotEmpty,
    ),
  );

  // ── Pieces ─────────────────────────────────────────────────────────────

  Widget _field(
    TextEditingController controller, {
    bool obscure = false,
    bool autocorrect = true,
    String? hint,
    List<String>? autofill,
    Future<void> Function()? onSubmitted,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    autocorrect: autocorrect && !obscure,
    enableSuggestions: !obscure && autocorrect,
    autofillHints: autofill,
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
        decoration: const InputDecoration(hintText: '6-digit code'),
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

/// Where the owner is in the four things a fresh server needs.
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
      _Step.mailbox => 3,
    };
    return Text(
      'Step ${index + 1} of 4',
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
