import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart' show FakeAccounts;

import '../sample_mode.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// Sign-in as an administrator of a REST Mail server: a username, its
/// password and the code from its authenticator. An administrator has no
/// mailbox; the account is kept beside the mail accounts and opens on
/// Administration, showing what its capabilities allow.
class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({super.key, this.server});

  /// The server to fill in, if one is known already.
  final Uri? server;

  @override
  State<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  late final _server = TextEditingController(
    text: widget.server?.host ?? (sampleMode ? FakeAccounts.host : null),
  );
  final _username = TextEditingController(
    text: sampleMode ? FakeAccounts.adminUsername : null,
  );
  final _password = TextEditingController(
    text: sampleMode ? FakeAccounts.adminPassword : null,
  );
  final _code = TextEditingController();
  final _codeFocus = FocusNode();

  var _needsCode = false;
  var _busy = false;
  String? _error;

  bool get _ready =>
      !_busy &&
      _server.text.trim().isNotEmpty &&
      _username.text.trim().isNotEmpty &&
      _password.text.isNotEmpty &&
      (!_needsCode || _code.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final c in [_server, _username, _password, _code]) {
      c.dispose();
    }
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_ready) return;
    final Uri server;
    try {
      server = parseServerUrl(_server.text);
    } on FormatException catch (e) {
      setState(() => _error = e.message);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AppScope.read(context).signInAdmin(
        server: server,
        username: _username.text.trim(),
        password: _password.text,
        totpCode: _needsCode ? _code.text.trim() : null,
      );
      TextInput.finishAutofillContext();
      // Signed in: the app replaces this screen with Administration.
    } on TotpRequiredException {
      if (!mounted) return;
      setState(() {
        _needsCode = true;
        _busy = false;
      });
      _codeFocus.requestFocus();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e.code) {
          'unauthorized' =>
            _needsCode
                ? "That code didn't work."
                : 'Wrong username or password.',
          'setup_required' =>
            '${e.message} On a server just installed, that is Set up a new '
                'server.',
          _ => describeError(e, host: server.host),
        };
      });
    }
  }

  Widget _field(
    TextEditingController controller, {
    String? hint,
    bool obscure = false,
    bool address = false,
    List<String>? autofill,
    TextInputType? keyboard,
    FocusNode? focus,
    bool last = false,
  }) => TextField(
    controller: controller,
    focusNode: focus,
    obscureText: obscure,
    autocorrect: false,
    enableSuggestions: false,
    keyboardType: keyboard ?? (address ? TextInputType.url : null),
    autofillHints: autofill,
    textInputAction: last ? TextInputAction.done : TextInputAction.next,
    onChanged: (_) => setState(() => _error = null),
    onSubmitted: last ? (_) => unawaited(_continue()) : null,
    style: rmText(16, color: context.rm.ink),
    decoration: InputDecoration(hintText: hint),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Administrator',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    Text(
                      'Sign in as an administrator of a REST Mail server. It '
                      'has no mail of its own: it opens on Administration, '
                      'beside your mail accounts.',
                      style: rmText(15, color: c.ink2, height: 1.45),
                    ),
                    if (sampleMode) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Sample server: ${FakeAccounts.adminUsername} may do '
                        'everything, ${FakeAccounts.queueWatcher} may only '
                        'look at the queue. Password '
                        '${FakeAccounts.adminPassword}, code '
                        '${FakeAccounts.totpCode}.',
                        style: rmText(
                          13,
                          color: c.accent,
                          weight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    const SectionLabel('Server'),
                    const SizedBox(height: 8),
                    _field(_server, hint: 'mail.example.com', address: true),
                    const SizedBox(height: 22),
                    const SectionLabel('Username'),
                    const SizedBox(height: 8),
                    _field(_username, autofill: const [AutofillHints.username]),
                    const SizedBox(height: 22),
                    const SectionLabel('Password'),
                    const SizedBox(height: 8),
                    _field(
                      _password,
                      obscure: true,
                      autofill: const [AutofillHints.password],
                      last: !_needsCode,
                    ),
                    if (_needsCode) ...[
                      const SizedBox(height: 22),
                      const SectionLabel('Two-factor code'),
                      const SizedBox(height: 8),
                      _field(
                        _code,
                        hint: '6-digit code',
                        keyboard: TextInputType.number,
                        autofill: const [AutofillHints.oneTimeCode],
                        focus: _codeFocus,
                        last: true,
                      ),
                    ],
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      ErrorText(error),
                    ],
                    const SizedBox(height: 26),
                    RmPrimaryButton(
                      label: 'Sign in',
                      busy: _busy,
                      onPressed: _ready ? () => unawaited(_continue()) : null,
                    ),
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
