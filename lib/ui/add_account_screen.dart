import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart' show FakeAccounts;

import '../imap/mail_settings.dart';
import '../l10n/voice.dart';
import '../sample_mode.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'imap_account_screen.dart';
import 'server_screen.dart';
import 'server_setup_screen.dart';
import 'widgets/common.dart';

enum _Discovery { idle, searching, found, notFound }

/// Sign-in: an address, a password, and the second factor if the account
/// has one. The server is found from the address's domain. An address at a
/// provider the app knows (Gmail, iCloud, …) goes on to [ImapAccountScreen],
/// as does Other mail (IMAP).
class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key, this.server, this.email});

  /// A server already chosen by hand, which skips discovery.
  final Uri? server;

  /// An address to start from, for signing an account in again.
  final String? email;

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  // Sample mode fills in the sample account, so trying the app is one tap.
  late final _email = TextEditingController(
    text: widget.email ?? (sampleMode ? FakeAccounts.email : null),
  );
  final _password = TextEditingController(
    text: sampleMode ? FakeAccounts.password : null,
  );
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
    // A filled-in address still needs its server found.
    if (sampleMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _emailChanged());
    }
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

  /// A provider the address belongs to, which is added over IMAP rather
  /// than looked for as a REST Mail server.
  MailProvider? get _provider =>
      _serverChosen ? null : MailProviders.forAddress(_email.text);

  bool get _canContinue =>
      _provider != null && !_busy ||
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
    if (domain == null || _provider != null) {
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

  void _otherMail() => unawaited(
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ImapAccountScreen(
          email: _email.text.trim(),
          password: _password.text,
        ),
      ),
    ),
  );

  /// An account still in setup, a fresh install's first one, finishes it
  /// there: a new password and an authenticator, then its mail.
  Future<void> _finishSetup(Uri server) => Navigator.pushReplacement(
    context,
    MaterialPageRoute<void>(
      builder: (_) => ServerSetupScreen(
        server: server,
        address: _email.text.trim(),
        password: _password.text,
      ),
    ),
  );

  Future<void> _continue() async {
    if (_provider != null) return _otherMail();
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
      if (e.code == 'setup_required') return _finishSetup(server);
      setState(() {
        _busy = false;
        _error = e.code == 'unauthorized'
            ? tr(context, _needsCode ? 'signIn.badCode' : 'signIn.badPassword')
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
              title: tr(context, 'signIn.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    Text(
                      tr(context, 'signIn.intro'),
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
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                      ),
                    ),
                    if (serverCard != null) ...[
                      const SizedBox(height: 22),
                      serverCard,
                    ],
                    if (_provider == null) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'signIn.password')),
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
                        decoration: InputDecoration(
                          hintText: tr(context, 'signIn.password'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(context, 'signIn.passwordNote'),
                        style: rmText(12.5, color: c.ink3, height: 1.4),
                      ),
                    ],
                    if (_needsCode) ...[
                      const SizedBox(height: 22),
                      SectionLabel(
                        tr(
                          context,
                          _useRecovery
                              ? 'signIn.recoveryCode'
                              : 'signIn.twoFactorCode',
                        ),
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
                          hintText: tr(
                            context,
                            _useRecovery
                                ? 'signIn.recoveryHint'
                                : 'signIn.codeHint',
                          ),
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
                            tr(
                              context,
                              _useRecovery
                                  ? 'signIn.useAuthenticator'
                                  : 'signIn.useRecovery',
                            ),
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
                      label: tr(context, 'signIn.continue'),
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
                          tr(
                            context,
                            _serverChosen
                                ? 'signIn.changeServer'
                                : 'signIn.configure',
                          ),
                          style: rmText(
                            14,
                            color: c.accent,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _otherMail,
                        child: Text(
                          tr(context, 'signIn.otherMail'),
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
    final provider = _provider;
    if (provider != null) {
      final microsoft = AppScope.read(context).oauth.microsoft != null;
      final blocked = provider.needsMicrosoftSignIn && !microsoft;
      return _Card(
        tone: blocked ? _Tone.missing : _Tone.good,
        title: provider.name,
        detail: tr(
          context,
          blocked
              ? 'signIn.needsMicrosoft'
              : provider.needsMicrosoftSignIn
              ? 'signIn.viaMicrosoft'
              : provider.usesAppPassword
              ? 'signIn.viaAppPassword'
              : 'signIn.viaImap',
        ),
      );
    }
    final server = _server;
    if (_serverChosen && server != null) {
      return _Card(
        tone: _Tone.good,
        title: trArgs(context, 'signIn.using', {'host': server.host}),
        detail: tr(context, 'signIn.chosenByHand'),
      );
    }
    return switch (_discovery) {
      _Discovery.idle => null,
      _Discovery.searching => _Card(
        tone: _Tone.pending,
        title: trArgs(context, 'signIn.looking', {
          'domain': '$_searchedDomain',
        }),
        detail: trArgs(context, 'signIn.asking', {
          'domain': '$_searchedDomain',
        }),
      ),
      _Discovery.found => _Card(
        tone: _Tone.good,
        title: trArgs(context, 'signIn.found', {'host': '${server?.host}'}),
        detail: tr(context, 'signIn.api'),
      ),
      _Discovery.notFound => _Card(
        tone: _Tone.missing,
        title: trArgs(context, 'signIn.notFound', {
          'domain': '$_searchedDomain',
        }),
        detail: tr(context, 'signIn.notFoundHint'),
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
