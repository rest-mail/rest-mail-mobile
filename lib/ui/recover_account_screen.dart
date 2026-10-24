import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// A forgotten password reset on [server] with a code from the account's
/// authenticator and one of its recovery codes, both; then the account is
/// signed in. An account without two-factor sign-in has no way back here:
/// its administrator resets it. REST Mail only.
class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({super.key, required this.server, this.email});

  final Uri server;
  final String? email;

  @override
  State<RecoverAccountScreen> createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  late final _email = TextEditingController(text: widget.email ?? '');
  final _code = TextEditingController();
  final _recovery = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  bool get _ready =>
      !_busy &&
      _email.text.trim().isNotEmpty &&
      _code.text.trim().isNotEmpty &&
      _recovery.text.trim().isNotEmpty &&
      _password.text.isNotEmpty;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _recovery.dispose();
    _password.dispose();
    super.dispose();
  }

  void _changed(String _) => setState(() => _error = null);

  Future<void> _reset() async {
    if (!_ready) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AppScope.read(context).recoverAccount(
        server: widget.server,
        email: _email.text.trim(),
        totpCode: _code.text.trim(),
        recoveryCode: _recovery.text.trim(),
        newPassword: _password.text,
      );
      // Signed in: the app replaces these screens with the mailbox.
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'recovery_failed') => tr(
            context,
            'recover.failed',
          ),
          ApiException(statusCode: 429, :final retryAfter?) => trArgs(
            context,
            'recover.tooMany',
            {'minutes': '${(retryAfter.inSeconds / 60).ceil()}'},
          ),
          ApiException(statusCode: 422)
              when e.fields.containsKey('new_password') =>
            tr(context, 'recover.shortPassword'),
          _ => describeError(context, e, host: widget.server.host),
        };
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
              title: tr(context, 'recover.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    Text(
                      tr(context, 'recover.intro'),
                      style: rmText(15, color: c.ink2, height: 1.45),
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'signIn.email')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      onChanged: _changed,
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                      ),
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'signIn.twoFactorCode')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _code,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      autocorrect: false,
                      onChanged: _changed,
                      style: rmText(16, color: c.ink, tracking: 0.08),
                      decoration: InputDecoration(
                        hintText: tr(context, 'signIn.codeHint'),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'signIn.recoveryCode')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _recovery,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      onChanged: _changed,
                      style: rmText(16, color: c.ink, tracking: 0.08),
                      decoration: InputDecoration(
                        hintText: tr(context, 'signIn.recoveryHint'),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'recover.newPassword')),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.done,
                      onChanged: _changed,
                      onSubmitted: (_) => unawaited(_reset()),
                      style: rmText(16, color: c.ink),
                      decoration: InputDecoration(
                        hintText: tr(context, 'recover.newPassword'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr(context, 'recover.passwordNote'),
                      style: rmText(12.5, color: c.ink3, height: 1.4),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      ErrorText(error),
                    ],
                    const SizedBox(height: 26),
                    RmPrimaryButton(
                      label: tr(context, 'recover.submit'),
                      busy: _busy,
                      onPressed: _ready ? () => unawaited(_reset()) : null,
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
