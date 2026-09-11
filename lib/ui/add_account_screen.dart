import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart' show FakeAccounts;

import '../sample_mode.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'server_screen.dart';
import 'widgets/common.dart';

enum _Discovery { idle, searching, found, notFound }

/// Sign-in: an address, a password, and the second factor if the account
/// has one. The server is found from the address's domain.
class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key, this.server});

  /// A server already chosen by hand, which skips discovery.
  final Uri? server;

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  final _codeFocus = FocusNode();

  Uri? _server;
  late bool _serverChosen = widget.server != null;
  _Discovery _discovery = _Discovery.idle;
  String _searchedDomain = '';
  int _discoveryRun = 0;
  Timer? _debounce;

  bool _needsCode = false;
  bool _useRecovery = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _server = widget.server;
    _email.addListener(_emailChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _email.dispose();
    _password.dispose();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  String? get _domain {
    final text = _email.text.trim();
    final at = text.lastIndexOf('@');
    if (at <= 0 || at == text.length - 1) return null;
    final domain = text.substring(at + 1).toLowerCase();
    return domain.contains('.') && !domain.endsWith('.') ? domain : null;
  }

  bool get _canContinue =>
      !_busy &&
      _server != null &&
      _domain != null &&
      _password.text.isNotEmpty &&
      (!_needsCode || _code.text.trim().isNotEmpty);

  void _emailChanged() {
    setState(() => _error = null);
    if (_serverChosen) return;
    _debounce?.cancel();
    final domain = _domain;
    if (domain == null) {
      _discoveryRun++;
      setState(() {
        _discovery = _Discovery.idle;
        _searchedDomain = '';
        _server = null;
      });
      return;
    }
    if (domain == _searchedDomain) return;
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => unawaited(_discover(domain)),
    );
  }

  Future<void> _discover(String domain) async {
    final run = ++_discoveryRun;
    setState(() {
      _discovery = _Discovery.searching;
      _searchedDomain = domain;
      _server = null;
    });
    final http = AppScope.read(context).httpClientFactory();
    try {
      final found = await discoverServer(_email.text.trim(), httpClient: http);
      if (!mounted || run != _discoveryRun) return;
      setState(() {
        _server = found;
        _discovery = found == null ? _Discovery.notFound : _Discovery.found;
      });
    } finally {
      http.close();
    }
  }

  Future<void> _chooseServer() async {
    final domain = _domain;
    final chosen = await Navigator.push<Uri>(
      context,
      MaterialPageRoute(
        builder: (_) => ServerScreen(
          initial:
              _server ??
              (domain == null ? null : Uri(scheme: 'https', host: domain)),
        ),
      ),
    );
    if (chosen == null || !mounted) return;
    _discoveryRun++;
    setState(() {
      _server = chosen;
      _serverChosen = true;
      _discovery = _Discovery.idle;
    });
  }

  Future<void> _continue() async {
    final server = _server;
    if (server == null || !_canContinue) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final code = _code.text.trim();
    try {
      await AppScope.read(context).signIn(
        server: server,
        email: _email.text.trim(),
        password: _password.text,
        totpCode: _needsCode && !_useRecovery ? code : null,
        recoveryCode: _needsCode && _useRecovery ? code : null,
      );
      TextInput.finishAutofillContext();
      // Signed in: the app replaces this screen with the mailbox on its own.
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
        _error = e.code == 'unauthorized'
            ? (_needsCode
                  ? "That code didn't work."
                  : 'Wrong address or password.')
            : describeError(e, host: server.host);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final serverCard = _serverCard(c);
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Add account',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    Text(
                      "Type your address. We'll find your rest-mail server — nothing to configure.",
                      style: rmText(15, color: c.ink2, height: 1.45),
                    ),
                    if (sampleMode) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Sample mail: ${FakeAccounts.email}, password '
                        '${FakeAccounts.password}'
                        '${sampleScenario == 'twoFactor' ? ', code ${FakeAccounts.totpCode}' : ''}.',
                        style: rmText(
                          13,
                          color: c.accent,
                          weight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    const SectionLabel('Email address'),
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
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                      ),
                    ),
                    if (serverCard != null) ...[
                      const SizedBox(height: 22),
                      serverCard,
                    ],
                    const SizedBox(height: 22),
                    const SectionLabel('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: _needsCode
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) => unawaited(_continue()),
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sent once, over TLS, to sign in. Only the session is kept, in the system keychain.',
                      style: rmText(12.5, color: c.ink3, height: 1.4),
                    ),
                    if (_needsCode) ...[
                      const SizedBox(height: 22),
                      SectionLabel(
                        _useRecovery ? 'Recovery code' : 'Two-factor code',
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _code,
                        focusNode: _codeFocus,
                        keyboardType: _useRecovery
                            ? TextInputType.text
                            : TextInputType.number,
                        autofillHints: _useRecovery
                            ? null
                            : const [AutofillHints.oneTimeCode],
                        autocorrect: false,
                        onChanged: (_) => setState(() => _error = null),
                        onSubmitted: (_) => unawaited(_continue()),
                        style: rmText(16, color: c.ink, tracking: 0.08),
                        decoration: InputDecoration(
                          hintText: _useRecovery
                              ? 'A recovery code'
                              : '6-digit code',
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => setState(() {
                            _useRecovery = !_useRecovery;
                            _code.clear();
                          }),
                          child: Text(
                            _useRecovery
                                ? 'Use an authenticator code'
                                : 'Use a recovery code instead',
                            style: rmText(
                              13.5,
                              color: c.accent,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      ErrorText(error),
                    ],
                    const SizedBox(height: 26),
                    RmPrimaryButton(
                      label: 'Continue',
                      busy: _busy,
                      onPressed: _canContinue
                          ? () => unawaited(_continue())
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => unawaited(_chooseServer()),
                        child: Text(
                          _serverChosen
                              ? 'Change server'
                              : 'Configure manually',
                          style: rmText(
                            14,
                            color: c.accent,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  Widget? _serverCard(RmColors c) {
    final server = _server;
    if (_serverChosen && server != null) {
      return _Card(
        tone: _Tone.good,
        title: 'Using ${server.host}',
        detail: 'Chosen by hand · rest-mail API over HTTPS',
      );
    }
    return switch (_discovery) {
      _Discovery.idle => null,
      _Discovery.searching => _Card(
        tone: _Tone.pending,
        title: 'Looking for $_searchedDomain…',
        detail: 'Asking the domain and mail.$_searchedDomain',
      ),
      _Discovery.found => _Card(
        tone: _Tone.good,
        title: 'Found ${server?.host}',
        detail: 'rest-mail API over HTTPS',
      ),
      _Discovery.notFound => _Card(
        tone: _Tone.missing,
        title: 'No rest-mail server at $_searchedDomain',
        detail: 'Enter its address with Configure manually.',
      ),
    };
  }
}

enum _Tone { good, pending, missing }

class _Card extends StatelessWidget {
  const _Card({required this.tone, required this.title, required this.detail});

  final _Tone tone;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final good = tone == _Tone.good;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: good ? c.accentSoft : c.surface,
        border: Border.all(color: good ? c.accentLine : c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 18,
            child: switch (tone) {
              _Tone.good => Icon(
                Icons.check_circle_outline_rounded,
                size: 18,
                color: c.accent,
              ),
              _Tone.pending => CircularProgressIndicator(
                strokeWidth: 1.8,
                color: c.ink3,
              ),
              _Tone.missing => Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: c.ink3,
              ),
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: rmText(14, color: c.ink, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(detail, style: rmText(13, color: c.ink2, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
