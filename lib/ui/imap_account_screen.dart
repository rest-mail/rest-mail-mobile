import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../imap/discovery.dart';
import '../imap/mail_settings.dart';
import '../imap/oauth.dart';
import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

final _twoStepVerification = Uri.parse(
  'https://myaccount.google.com/signinoptions/twosv',
);

/// Adds Gmail or any other mail account over IMAP and SMTP: the address,
/// the password (an app password, for the providers that want one), and the
/// servers, found from the address or typed in. Outlook.com, and work
/// accounts on Microsoft 365, sign in with Microsoft instead, and Gmail can
/// sign in with Google for personal use, when the build has their clients.
class ImapAccountScreen extends StatefulWidget {
  const ImapAccountScreen({
    super.key,
    this.email = '',
    this.password = '',
    this.initialSettings,
    this.initialDisplayName = '',
  });

  final String email;
  final String password;
  final MailServerSettings? initialSettings;
  final String initialDisplayName;

  @override
  State<ImapAccountScreen> createState() => _ImapAccountScreenState();
}

class _ImapAccountScreenState extends State<ImapAccountScreen> {
  late final _email = TextEditingController(text: widget.email);
  late final _password = TextEditingController(text: widget.password);
  final _name = TextEditingController();
  final _imapHost = TextEditingController();
  final _imapPort = TextEditingController(text: '993');
  final _smtpHost = TextEditingController();
  final _smtpPort = TextEditingController(text: '465');
  final _username = TextEditingController();
  SmtpSecurity _smtpSecurity = SmtpSecurity.tls;

  FoundSettings? _found;
  bool _looking = false;
  bool _manual = false;
  String _searchedDomain = '';
  int _lookups = 0;
  Timer? _debounce;

  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name.text = widget.initialDisplayName;
    if (widget.initialSettings case final settings?) {
      _found = FoundSettings(settings, SettingsSource.saved);
    }
    _email.addListener(_emailChanged);
    if (_found == null && domainOf(widget.email) != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _emailChanged());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [
      _email,
      _password,
      _name,
      _imapHost,
      _imapPort,
      _smtpHost,
      _smtpPort,
      _username,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  MailProvider? get _provider => MailProviders.forAddress(_email.text);

  /// The servers to use: typed in, or found.
  MailServerSettings? get _settings {
    if (!_manual) return _found?.settings;
    final imapPort = int.tryParse(_imapPort.text.trim());
    final smtpPort = int.tryParse(_smtpPort.text.trim());
    final imapHost = _imapHost.text.trim(), smtpHost = _smtpHost.text.trim();
    bool valid(int? port) => port != null && port > 0 && port < 65536;
    if (imapHost.isEmpty || smtpHost.isEmpty) return null;
    if (!valid(imapPort) || !valid(smtpPort)) return null;
    return MailServerSettings(
      imapHost: imapHost,
      imapPort: imapPort!,
      smtpHost: smtpHost,
      smtpPort: smtpPort!,
      smtpSecurity: _smtpSecurity,
      username: _username.text.trim().isEmpty ? null : _username.text.trim(),
      filesSentMail: _found?.settings.filesSentMail ?? false,
    );
  }

  bool get _canContinue =>
      !_busy &&
      domainOf(_email.text) != null &&
      _password.text.isNotEmpty &&
      _settings != null &&
      !(_provider?.needsMicrosoftSignIn ?? false);

  /// Who could sign this address in instead of a password, if the build
  /// has a client for them.
  OAuthKind? get _oauthKind {
    final kind = oauthKindFor(_provider, _found?.settings);
    if (kind == null || AppScope.read(context).oauth[kind] == null) return null;
    return kind;
  }

  bool get _canSignIn =>
      !_busy && domainOf(_email.text) != null && _settings != null;

  void _emailChanged() {
    setState(() => _error = null);
    _debounce?.cancel();
    final domain = domainOf(_email.text);
    if (domain == null) {
      _lookups++;
      setState(() {
        _looking = false;
        _found = null;
        _searchedDomain = '';
      });
      return;
    }
    if (domain == _searchedDomain) return;
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => unawaited(_lookUp(domain)),
    );
  }

  Future<void> _lookUp(String domain) async {
    final lookup = ++_lookups;
    setState(() {
      _looking = true;
      _searchedDomain = domain;
      _found = null;
    });
    final http = AppScope.read(context).httpClientFactory();
    try {
      final found = await discoverMailSettings(
        _email.text.trim(),
        httpClient: http,
      );
      if (!mounted || lookup != _lookups) return;
      setState(() {
        _looking = false;
        _found = found;
        if (found == null) {
          _fillManual(null);
          _manual = true;
        } else if (!_manual) {
          _fillManual(found.settings);
        }
      });
    } finally {
      http.close();
    }
  }

  void _fillManual(MailServerSettings? s) {
    final domain = domainOf(_email.text) ?? '';
    _imapHost.text = s?.imapHost ?? 'imap.$domain';
    _imapPort.text = '${s?.imapPort ?? 993}';
    _smtpHost.text = s?.smtpHost ?? 'smtp.$domain';
    _smtpPort.text = '${s?.smtpPort ?? 465}';
    _smtpSecurity = s?.smtpSecurity ?? SmtpSecurity.tls;
    _username.text = s?.username ?? '';
  }

  Future<void> _continue() async {
    final settings = _settings;
    if (settings == null || !_canContinue) return;
    final provider = _provider;
    // Google shows an app password in groups of four; the spaces aren't
    // part of it.
    final password = provider?.isGmail ?? false
        ? _password.text.replaceAll(RegExp(r'\s'), '')
        : _password.text;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AppScope.read(context).addImapAccount(
        address: _email.text.trim(),
        password: password,
        displayName: _name.text,
        settings: settings,
        provider: provider,
      );
      TextInput.finishAutofillContext();
      // Added: the app replaces this screen with the new account's mail.
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = _describe(e, provider);
      });
    }
  }

  /// Signs in with Microsoft or Google in the system browser, then checks
  /// the servers as [_continue] does.
  Future<void> _signIn(OAuthKind kind) async {
    final settings = _settings;
    if (settings == null || !_canSignIn) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AppScope.read(context).addOAuthAccount(
        kind: kind,
        address: _email.text.trim(),
        displayName: _name.text,
        settings: settings,
        provider: _provider,
      );
      // Added: the app replaces this screen with the new account's mail.
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e.code) {
          // Closing the sign-in page is an answer, not a failure.
          'cancelled' => null,
          'unauthorized' ||
          'app_password_required' ||
          'web_login_required' => trArgs(context, 'imap.turnedAway', {
            'provider': kind.label,
            'host': settings.imapHost,
            'reason': e.message,
          }),
          _ => describeError(context, e),
        };
      });
    }
  }

  String _describe(ApiException e, MailProvider? provider) {
    final gmail = provider?.isGmail ?? false;
    return switch (e.code) {
      'app_password_required' => tr(context, 'imap.gmailAppPassword'),
      'web_login_required' when gmail => tr(context, 'imap.gmailWebLogin'),
      'unauthorized' when gmail => tr(context, 'imap.gmailRefused'),
      'unauthorized' when provider?.usesAppPassword ?? false => trArgs(
        context,
        'imap.needsAppPassword',
        {'provider': provider!.name},
      ),
      'unauthorized' ||
      'web_login_required' => tr(context, 'signIn.badPassword'),
      _ => describeError(context, e),
    };
  }

  Future<void> _open(Uri url) async {
    var opened = false;
    try {
      opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }
    if (!opened && mounted) showToast(context, tr(context, 'imap.linkFailed'));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final provider = _provider;
    final error = _error;
    final appPassword = provider?.usesAppPassword ?? false;
    final oauth = _oauthKind;
    final microsoft = oauth == OAuthKind.microsoft;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: provider?.name ?? tr(context, 'imap.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AutofillGroup(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                  children: [
                    Text(
                      tr(context, 'imap.intro'),
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
                      style: rmText(16, color: c.ink),
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                      ),
                    ),
                    if (microsoft) ...[
                      const SizedBox(height: 22),
                      _Guide(
                        title: trArgs(context, 'imap.microsoftTitle', {
                          'provider':
                              provider?.name ?? tr(context, 'imap.thisAccount'),
                        }),
                        lines: [tr(context, 'imap.microsoftNote')],
                      ),
                      const SizedBox(height: 22),
                      _nameField(c),
                      const SizedBox(height: 22),
                      _servers(c),
                    ] else if (provider?.needsMicrosoftSignIn ?? false) ...[
                      const SizedBox(height: 22),
                      _Guide(
                        title: trArgs(context, 'imap.needsMicrosoft', {
                          'provider': provider!.name,
                        }),
                        lines: [
                          tr(context, 'imap.microsoftOff'),
                          tr(context, 'imap.microsoftComing'),
                        ],
                      ),
                    ] else ...[
                      if (provider?.isGmail ?? false) ...[
                        const SizedBox(height: 22),
                        _Guide(
                          title: tr(context, 'imap.gmailTitle'),
                          lines: [
                            tr(context, 'imap.gmailStep1'),
                            tr(context, 'imap.gmailStep2'),
                          ],
                          actions: [
                            (
                              tr(context, 'imap.turnOnTwoStep'),
                              _twoStepVerification,
                            ),
                            (
                              tr(context, 'imap.makeAppPassword'),
                              provider!.appPasswordUrl!,
                            ),
                          ],
                          onOpen: _open,
                        ),
                      ] else if (appPassword) ...[
                        const SizedBox(height: 22),
                        _Guide(
                          title: trArgs(context, 'imap.appPasswordTitle', {
                            'provider': provider!.name,
                          }),
                          lines: [
                            trArgs(context, 'imap.appPasswordNote', {
                              'provider': provider.name,
                            }),
                          ],
                          actions: [
                            (
                              tr(context, 'imap.howToMake'),
                              provider.appPasswordUrl!,
                            ),
                          ],
                          onOpen: _open,
                        ),
                      ],
                      const SizedBox(height: 22),
                      SectionLabel(
                        tr(
                          context,
                          appPassword ? 'imap.appPassword' : 'signIn.password',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.password],
                        onChanged: (_) => setState(() => _error = null),
                        onSubmitted: (_) => unawaited(_continue()),
                        style: rmText(16, color: c.ink),
                        decoration: InputDecoration(
                          hintText: tr(
                            context,
                            appPassword
                                ? 'imap.appPassword'
                                : 'signIn.password',
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _nameField(c),
                      const SizedBox(height: 22),
                      _servers(c),
                      const SizedBox(height: 10),
                      Text(
                        tr(context, 'imap.keychainNote'),
                        style: rmText(12.5, color: c.ink3, height: 1.4),
                      ),
                    ],
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      ErrorText(error),
                    ],
                    const SizedBox(height: 26),
                    if (microsoft)
                      RmPrimaryButton(
                        label: tr(context, 'imap.signInMicrosoft'),
                        busy: _busy,
                        onPressed: _canSignIn
                            ? () => unawaited(_signIn(OAuthKind.microsoft))
                            : null,
                      )
                    else
                      RmPrimaryButton(
                        label: tr(context, 'signIn.title'),
                        busy: _busy,
                        onPressed: _canContinue
                            ? () => unawaited(_continue())
                            : null,
                      ),
                    // An app password stays the way into Gmail: REST Mail's
                    // Google client is unverified, so it is for the owner
                    // and family, at most 100 people (#37).
                    if (oauth == OAuthKind.google) ...[
                      const SizedBox(height: 12),
                      RmOutlineButton(
                        label: tr(context, 'imap.signInGoogle'),
                        onPressed: _canSignIn
                            ? () => unawaited(_signIn(OAuthKind.google))
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr(context, 'imap.googleNote'),
                        style: rmText(12.5, color: c.ink3, height: 1.4),
                      ),
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

  Widget _nameField(RmColors c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionLabel(tr(context, 'imap.name')),
      const SizedBox(height: 8),
      TextField(
        controller: _name,
        textCapitalization: TextCapitalization.words,
        autofillHints: const [AutofillHints.name],
        style: rmText(16, color: c.ink),
        decoration: InputDecoration(hintText: tr(context, 'imap.nameHint')),
      ),
    ],
  );

  Widget _servers(RmColors c) {
    final found = _found;
    if (_looking) {
      return _Card(
        title: trArgs(context, 'imap.lookingUp', {'domain': _searchedDomain}),
        detail: tr(context, 'imap.finding'),
        busy: true,
      );
    }
    if (!_manual) {
      if (found == null) return const SizedBox.shrink();
      final s = found.settings;
      return _Card(
        title: '${s.imapHost} · ${s.smtpHost}',
        detail: trArgs(
          context,
          s.smtpSecurity == SmtpSecurity.tls
              ? 'imap.foundTls'
              : 'imap.foundStarttls',
          {'source': tr(context, 'imap.source.${found.source.name}')},
        ),
        action: TextButton(
          onPressed: () => setState(() => _manual = true),
          child: Text(
            tr(context, 'imap.change'),
            style: rmText(13.5, color: c.accent, weight: FontWeight.w600),
          ),
        ),
      );
    }
    TextField field(
      TextEditingController controller,
      String hint, {
      bool number = false,
    }) => TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.url,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: (_) => setState(() => _error = null),
      style: rmText(15, color: c.ink),
      decoration: InputDecoration(hintText: hint),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (found == null && _searchedDomain.isNotEmpty) ...[
          Text(
            trArgs(context, 'imap.notFound', {'domain': _searchedDomain}),
            style: rmText(13.5, color: c.ink2, height: 1.4),
          ),
          const SizedBox(height: 14),
        ],
        SectionLabel(tr(context, 'imap.imapServer')),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 3, child: field(_imapHost, 'imap.example.com')),
            const SizedBox(width: 10),
            Expanded(child: field(_imapPort, '993', number: true)),
          ],
        ),
        const SizedBox(height: 16),
        SectionLabel(tr(context, 'imap.smtpServer')),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 3, child: field(_smtpHost, 'smtp.example.com')),
            const SizedBox(width: 10),
            Expanded(child: field(_smtpPort, '465', number: true)),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: RmSegmented<SmtpSecurity>(
            options: const [
              (SmtpSecurity.tls, 'TLS'),
              (SmtpSecurity.starttls, 'STARTTLS'),
            ],
            value: _smtpSecurity,
            onChanged: (security) => setState(() {
              _smtpSecurity = security;
              final port = _smtpPort.text.trim();
              if (port == '465' || port == '587' || port.isEmpty) {
                _smtpPort.text = security == SmtpSecurity.tls ? '465' : '587';
              }
            }),
          ),
        ),
        const SizedBox(height: 16),
        SectionLabel(tr(context, 'imap.username')),
        const SizedBox(height: 8),
        field(_username, tr(context, 'imap.usernameHint')),
      ],
    );
  }
}

/// What a provider needs before it will let the app in, with links to where
/// it's done.
class _Guide extends StatelessWidget {
  const _Guide({
    required this.title,
    required this.lines,
    this.actions = const [],
    this.onOpen,
  });

  final String title;
  final List<String> lines;
  final List<(String, Uri)> actions;
  final void Function(Uri url)? onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.accentSoft,
        border: Border.all(color: c.accentLine),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: rmText(14, color: c.ink, weight: FontWeight.w700),
          ),
          for (final line in lines) ...[
            const SizedBox(height: 6),
            Text(line, style: rmText(13.5, color: c.ink2, height: 1.4)),
          ],
          for (final (label, url) in actions)
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () => onOpen?.call(url),
              child: Text(
                label,
                style: rmText(13.5, color: c.accent, weight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.detail,
    this.busy = false,
    this.action,
  });

  final String title;
  final String detail;
  final bool busy;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: busy ? c.surface : c.accentSoft,
        border: Border.all(color: busy ? c.line : c.accentLine),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: busy
                ? CircularProgressIndicator(strokeWidth: 1.8, color: c.ink3)
                : Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: c.accent,
                  ),
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
          ?action,
        ],
      ),
    );
  }
}
