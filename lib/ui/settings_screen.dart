import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../push/push_service.dart';
import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../state/push_state.dart';
import '../theme/packs.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../version.dart';
import 'admin/admin_screen.dart';
import 'app_passwords_screen.dart';
import 'two_factor_screen.dart';
import 'interface_customizer_screen.dart';
import 'my_permissions_screen.dart';
import 'whats_new_screen.dart';
import 'push_offer.dart';
import 'scheduled_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/painters.dart';

void _push(BuildContext context, Widget screen) => unawaited(
  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen)),
);

String _storage(QuotaInfo quota) => quota.quotaBytes > 0
    ? '${sizeLabel(quota.usedBytes)} of ${sizeLabel(quota.quotaBytes)} used'
    : '${sizeLabel(quota.usedBytes)} used';

class MailboxSettingsScreen extends StatefulWidget {
  const MailboxSettingsScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<MailboxSettingsScreen> createState() => _MailboxSettingsScreenState();
}

class _MailboxSettingsScreenState extends State<MailboxSettingsScreen> {
  QuotaInfo? _quota;

  @override
  void initState() {
    super.initState();
    unawaited(_loadQuota());
  }

  Future<void> _loadQuota() async {
    final account = widget.mailbox.account;
    if (account == null) return;
    try {
      final quota = await widget.mailbox.backend.quota(account.id);
      if (mounted) setState(() => _quota = quota);
    } on ApiException {
      // The footer leaves storage out.
    }
  }

  bool _busy = false;

  Future<void> _remove() async {
    final account = widget.mailbox.account;
    if (account == null) return;
    final host = widget.mailbox.backend.host;
    final app = AppScope.read(context);
    if (account.isPrimary) {
      final signedIn = app.current;
      final sure = await confirmAction(
        context,
        title: 'Sign out?',
        message: [
          'The session for ${account.address} ends. The account stays on this '
              'phone, signed out. Your mail stays on $host.',
          if (app.accounts.length > 1) 'Your other accounts stay signed in.',
        ].join(' '),
        action: 'Sign out',
      );
      if (sure && signedIn != null) await app.signOut(signedIn);
      return;
    }
    final sure = await confirmAction(
      context,
      title: 'Unlink ${account.address}?',
      message:
          'This account gives up its access to it. The mailbox and its mail '
          'are untouched. If it has no password of its own, only an '
          'administrator can give access to it back.',
      action: 'Unlink',
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.mailbox.backend.unlinkAccount(account.id);
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Unlinked ${account.address}')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(e, host: host));
    }
  }

  Future<void> _removeFromPhone() async {
    final app = AppScope.read(context);
    final signedIn = app.current;
    if (signedIn == null) return;
    final sure = await confirmAction(
      context,
      title: 'Remove ${signedIn.address}?',
      message:
          'The account and its settings are removed from this phone. '
          'Your mail stays on ${signedIn.host}.',
      action: 'Remove',
    );
    if (sure) await app.removeAccount(signedIn);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final m = widget.mailbox;
    final host = m.backend.host;
    final quota = _quota;
    final current = app.current;
    final session = switch (app.current) {
      final RestAccount rest when identical(rest.backend, m.backend) => rest,
      _ => null,
    };
    final administers =
        current is RestAccount &&
        current.signedOut == null &&
        AdminAccess(current.capabilities).any;
    // Creating takes mailboxes:write; the server checks it covers the
    // domain asked for.
    final creates =
        current is RestAccount &&
        identical(current.backend, m.backend) &&
        current.capabilities.allows(Capability.mailboxesWrite);
    return ListenableBuilder(
      listenable: m,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              RmTopBar(
                title: tr(context, 'settings.mailboxTitle'),
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                  children: [
                    Text(
                      '${tr(context, 'settings.storedOn')} $host',
                      style: rmText(12, color: c.ink3, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    SectionLabel(tr(context, 'settings.thisMailbox')),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        if (current case final out? when out.signedOut != null)
                          _AccountRow(
                            label: out.label,
                            address: out.address,
                            subtitle: 'Signed out · ${out.host}',
                            primary: true,
                            onTap: () => Navigator.pop(context),
                          )
                        else if (m.account case final account?) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                            child: Row(
                              children: [
                                RmAvatar(
                                  name: account.label,
                                  seed: account.address,
                                  size: 40,
                                  color: account.isPrimary ? c.accent : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        account.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: rmText(
                                          15,
                                          color: c.ink,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        account.isPrimary
                                            ? '${tr(context, 'settings.primaryMailbox')} · $host'
                                            : '${tr(context, 'settings.mailboxOfAccount')} · $host',
                                        style: rmText(12, color: c.ink3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RmRow(
                            label: 'Display name',
                            value: account.displayName.isEmpty
                                ? '—'
                                : account.displayName,
                          ),
                          RmRow(label: 'Server', value: host),
                          if (quota != null)
                            RmRow(label: 'Storage', value: _storage(quota)),
                          RmRow(
                            label: 'Updates',
                            value: m.backend.canLinkMailboxes
                                ? 'Pushed live by the server'
                                : 'Live while the app is open',
                          ),
                          if (session != null &&
                              session.signedOut == null &&
                              account.isPrimary)
                            RmRow(
                              label: 'Two-factor sign-in',
                              subtitle: 'Authenticator and recovery codes',
                              onTap: () => _push(
                                context,
                                TwoFactorScreen(account: session),
                              ),
                            ),
                          if (session != null)
                            RmRow(
                              label: 'App passwords',
                              subtitle: 'For mail apps and automations',
                              onTap: () => _push(
                                context,
                                AppPasswordsScreen(
                                  account: session,
                                  mailbox: account,
                                ),
                              ),
                            ),
                          if (current is RestAccount &&
                              current.signedOut == null) ...[
                            if (creates)
                              _AddRow(
                                label: tr(context, 'settings.createMailbox'),
                                onTap: () => _push(
                                  context,
                                  CreateMailboxScreen(
                                    account: current,
                                    mailbox: m,
                                  ),
                                ),
                              ),
                            if (m.backend.canLinkMailboxes)
                              _AddRow(
                                label: tr(context, 'settings.linkMailbox'),
                                onTap: () => _push(
                                  context,
                                  LinkAccountScreen(mailbox: m),
                                ),
                              ),
                          ],
                          RmRow(
                            label: account.isPrimary
                                ? 'Sign out'
                                : 'Unlink from this account',
                            danger: true,
                            onTap: _busy ? null : () => unawaited(_remove()),
                          ),
                          if (account.isPrimary)
                            RmRow(
                              label: 'Remove from this phone',
                              danger: true,
                              onTap: _busy
                                  ? null
                                  : () => unawaited(_removeFromPhone()),
                            ),
                        ],
                      ],
                    ),
                    // Every signed-in REST session reaches its own grants:
                    // one whose roles are all eligible holds nothing that
                    // shows Administration until it switches one on there.
                    if (current is RestAccount &&
                        current.signedOut == null) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'settings.server')),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          if (administers)
                            RmRow(
                              label: tr(context, 'settings.administration'),
                              subtitle: 'What this session may run on $host',
                              onTap: () => _push(
                                context,
                                AdministrationScreen(account: current),
                              ),
                            ),
                          RmRow(
                            label: tr(context, 'settings.myPermissions'),
                            subtitle: tr(
                              context,
                              'settings.myPermissionsSubtitle',
                            ),
                            onTap: () => _push(
                              context,
                              MyPermissionsScreen(account: current),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (m.backend.canScheduleSend) ...[
                      const SizedBox(height: 22),
                      SectionLabel(tr(context, 'settings.sending')),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          RmRow(
                            label: tr(context, 'settings.scheduled'),
                            subtitle: tr(context, 'settings.scheduledSubtitle'),
                            onTap: () =>
                                _push(context, ScheduledScreen(mailbox: m)),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    Text(
                      [
                        host,
                        if (quota != null)
                          '${countLabel(quota.messageCount)} messages · ${_storage(quota)}',
                      ].join('\n'),
                      textAlign: TextAlign.center,
                      style: rmText(11.5, color: c.ink3, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// What belongs to this phone rather than a mailbox: language, theme, the
/// interface, notifications and the signature.
class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final settings = app.settings;
    final signature = settings.signature.trim();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.appTitle'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  SectionLabel(tr(context, 'settings.thisPhone')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.language'),
                        value: languageLabel(settings.languageCode),
                        onTap: () => _push(context, const LanguageScreen()),
                      ),
                      RmRow(
                        label: tr(context, 'settings.signature'),
                        value: signature.isEmpty
                            ? 'None'
                            : signature.split('\n').first,
                        onTap: () => _push(context, const SignatureScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _NotificationsSection(app: app),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'settings.interface')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.customizeScreens'),
                        subtitle: tr(context, 'settings.customizeSubtitle'),
                        onTap: () =>
                            _push(context, const InterfaceCustomizerScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'settings.appearance')),
                  const SizedBox(height: 9),
                  RmGroup(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tr(context, 'settings.brightness'),
                                style: rmText(
                                  14.5,
                                  color: c.ink,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (ThemePack.byId(settings.packId).followsSystem)
                              RmSegmented<ThemeMode>(
                                options: [
                                  (
                                    ThemeMode.system,
                                    tr(context, 'settings.system'),
                                  ),
                                  (
                                    ThemeMode.light,
                                    tr(context, 'settings.light'),
                                  ),
                                  (
                                    ThemeMode.dark,
                                    tr(context, 'settings.dark'),
                                  ),
                                ],
                                value: settings.themeMode,
                                onChanged: (mode) => unawaited(
                                  app.updateSettings(
                                    settings.copyWith(themeMode: mode),
                                  ),
                                ),
                              )
                            else
                              Text(
                                'Sets its own',
                                style: rmText(12, color: c.ink3),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        child: Column(
                          children: [
                            for (final pack in ThemePack.all)
                              _PackTile(
                                pack: pack,
                                selected: pack.id == settings.packId,
                                onTap: () => unawaited(
                                  app.updateSettings(
                                    settings.copyWith(packId: pack.id),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  RmGroup(
                    children: [
                      RmRow(
                        label: tr(context, 'settings.whatsNew'),
                        subtitle: tr(context, 'settings.whatsNewSubtitle'),
                        onTap: () => _push(context, const WhatsNewScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'rest-mail for mobile $appVersion',
                    textAlign: TextAlign.center,
                    style: rmText(11.5, color: c.ink3, height: 1.5),
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

/// The language the app speaks.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final selected = app.settings.languageCode;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'settings.language'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: [
                  RmGroup(
                    children: [
                      for (final entry in languageNames.entries)
                        RmRow(
                          label: entry.value,
                          trailing: entry.key == selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: c.accent,
                                )
                              : const SizedBox(width: 20),
                          onTap: () {
                            unawaited(
                              app.updateSettings(
                                app.settings.copyWith(languageCode: entry.key),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                    ],
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

/// New mail notifications, once this phone can have them and a server can
/// send them; until then, not a word.
class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: app.push,
    builder: (context, _) {
      final c = context.rm;
      final push = app.push;
      if (!push.available) return const SizedBox.shrink();
      final notes = [
        for (final account in app.accounts)
          if (account is RestAccount &&
              push.statusOf(account) == PushStatus.unsupported)
            "${account.address}: its server doesn't send notifications yet.",
        if (app.accounts.any((a) => a is ImapAccount)) notificationsImapNote,
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(tr(context, 'settings.notifications')),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              RmRow(
                label: 'New mail',
                subtitle: push.permission == NotificationPermission.denied
                    ? "Turned off for REST Mail in the iPhone's Settings, "
                          'under Notifications.'
                    : 'Only a signal goes through Apple. The app fetches '
                          'the mail from your server itself.',
                trailing: RmSwitch(
                  key: const Key('notifications-switch'),
                  label: 'New mail notifications',
                  value: push.enabled,
                  onChanged: (on) =>
                      unawaited(on ? push.enable() : push.disable()),
                ),
              ),
            ],
          ),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Text(note, style: rmText(12, color: c.ink3, height: 1.4)),
            ),
          const SizedBox(height: 22),
        ],
      );
    },
  );
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.label,
    required this.address,
    required this.subtitle,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final String address;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            RmAvatar(
              name: label,
              seed: address,
              size: 32,
              color: primary ? c.accent : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                  ),
                  Text(subtitle, style: rmText(12, color: c.ink3)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            DashedCircle(
              color: c.ink3,
              size: 32,
              child: Icon(Icons.add_rounded, size: 16, color: c.accent),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: rmText(14.5, color: c.accent, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late final TextEditingController _text;
  late bool _signReplies;

  @override
  void initState() {
    super.initState();
    final settings = AppScope.read(context).settings;
    _text = TextEditingController(text: settings.signature);
    _signReplies = settings.signReplies;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final app = AppScope.read(context);
    await app.updateSettings(
      app.settings.copyWith(
        signature: _text.text.trimRight(),
        signReplies: _signReplies,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final preview = _text.text.trim();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Signature',
              onBack: () => Navigator.pop(context),
              trailingText: 'Save',
              onTrailing: () => unawaited(_save()),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                children: [
                  TextField(
                    controller: _text,
                    minLines: 6,
                    maxLines: 12,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    style: rmText(15, color: c.ink, height: 1.55),
                    decoration: const InputDecoration(
                      hintText: 'Your name\nWhat you do',
                      hintMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SectionLabel('Preview'),
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.line),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '…thanks for the quick turnaround.',
                          style: rmText(15, color: c.ink2, height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        DashedLine(color: c.line),
                        const SizedBox(height: 12),
                        Text(
                          preview.isEmpty ? 'No signature' : preview,
                          style: rmText(
                            14,
                            color: preview.isEmpty ? c.ink3 : c.ink,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  RmGroup(
                    children: [
                      RmRow(
                        label: 'Append on replies',
                        subtitle: 'New messages always get it',
                        trailing: RmSwitch(
                          value: _signReplies,
                          label: 'Append on replies',
                          onChanged: (value) =>
                              setState(() => _signReplies = value),
                        ),
                      ),
                    ],
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

/// Links another account on the same server to this one, proving its
/// password, and its code when it has two-factor authentication.
class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  final _codeFocus = FocusNode();
  bool _needsCode = false;
  bool _busy = false;
  String? _error;

  bool get _ready =>
      !_busy &&
      _email.text.contains('@') &&
      _password.text.isNotEmpty &&
      (!_needsCode || _code.text.trim().isNotEmpty);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _link() async {
    final host = widget.mailbox.backend.host;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final linked = await widget.mailbox.backend.linkAccount(
        address: _email.text.trim(),
        password: _password.text,
        totpCode: _needsCode ? _code.text.trim() : null,
      );
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Linked ${linked.address}')),
      );
    } on TotpRequiredException {
      if (!mounted) return;
      setState(() {
        _needsCode = true;
        _busy = false;
      });
      _codeFocus.requestFocus();
    } on ApiException catch (e) {
      if (!mounted) return;
      // A refused link is 403 with its reason; this session is still good.
      if (e.code == 'invalid_totp') {
        _code.clear();
        _codeFocus.requestFocus();
      }
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'invalid_credentials') =>
            'Wrong address or password.',
          ApiException(code: 'invalid_totp') => "That code didn't work.",
          ApiException(code: 'setup_required') =>
            'That account has to sign in and choose its own password first.',
          ApiException(statusCode: 409) =>
            'That mailbox is already linked, or is this account.',
          _ => describeError(e, host: host),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final host = widget.mailbox.backend.host;
    final error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Link a mailbox',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    'Add another mailbox on $host to this account, with its '
                    'own password. Switch between them from the menu.',
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Email address'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(hintText: 'someone@$host'),
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Password'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) {
                      if (_ready) unawaited(_link());
                    },
                    style: rmText(16, color: c.ink),
                    decoration: const InputDecoration(hintText: 'Its password'),
                  ),
                  if (_needsCode) ...[
                    const SizedBox(height: 22),
                    const SectionLabel('Two-factor code'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _code,
                      focusNode: _codeFocus,
                      keyboardType: TextInputType.number,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      autocorrect: false,
                      onChanged: (_) => setState(() => _error = null),
                      onSubmitted: (_) {
                        if (_ready) unawaited(_link());
                      },
                      style: rmText(16, color: c.ink, tracking: 0.08),
                      decoration: const InputDecoration(
                        hintText: 'From its authenticator',
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Link mailbox',
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_link()) : null,
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

/// Creates a mailbox owned by this account, with no password of its own: it
/// is reached by signing in as this account, which can read it, send as it
/// and make its app passwords. Shown to a session holding `mailboxes:write`.
class CreateMailboxScreen extends StatefulWidget {
  const CreateMailboxScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final MailboxState mailbox;

  @override
  State<CreateMailboxScreen> createState() => _CreateMailboxScreenState();
}

class _CreateMailboxScreenState extends State<CreateMailboxScreen> {
  final _localPart = TextEditingController();
  final _displayName = TextEditingController();

  /// The account's own domain first, then any other the session may read
  /// (`domains:read`); the server says which it may create on.
  late List<String> _domains = [_ownDomain];
  late String _domain = _ownDomain;
  bool _busy = false;
  String? _error;

  String get _ownDomain {
    final address = widget.account.address;
    return address.substring(address.indexOf('@') + 1).toLowerCase();
  }

  String get _address => '${_localPart.text.trim().toLowerCase()}@$_domain';

  bool get _ready =>
      !_busy &&
      _localPart.text.trim().isNotEmpty &&
      !_localPart.text.contains('@');

  @override
  void initState() {
    super.initState();
    if (widget.account.capabilities.allows(Capability.domainsRead)) {
      unawaited(_loadDomains());
    }
  }

  @override
  void dispose() {
    _localPart.dispose();
    _displayName.dispose();
    super.dispose();
  }

  Future<void> _loadDomains() async {
    try {
      final page = await widget.account.client.domains();
      if (!mounted) return;
      setState(
        () => _domains = [
          _ownDomain,
          for (final d in page.items)
            if (d.name.toLowerCase() != _ownDomain) d.name.toLowerCase(),
        ],
      );
    } on ApiException {
      // The account's own domain is still there to choose.
    }
  }

  Future<void> _create() async {
    final host = widget.account.host;
    final address = _address;
    final name = _displayName.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await widget.account.client.createAccount(
        address: address,
        displayName: name.isEmpty ? null : name,
      );
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Created ${created.address}')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(statusCode: 403) =>
            "${widget.account.address} can't create mailboxes on $_domain.",
          ApiException(statusCode: 409) => '$address already exists.',
          ApiException(statusCode: 422, :final fields, :final message) =>
            fields.values.firstOrNull ?? message,
          ApiException(statusCode: 404) =>
            "$host can't create mailboxes: its REST Mail is older than "
                'this app.',
          _ => describeError(e, host: host),
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
              title: 'Create a mailbox',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                children: [
                  Text(
                    'A new mailbox owned by ${widget.account.address}. It has '
                    'no password of its own: you read it and send as it from '
                    'this account. Switch to it from the menu.',
                    style: rmText(15, color: c.ink2, height: 1.45),
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Address'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _localPart,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() => _error = null),
                    style: rmText(16, color: c.ink),
                    decoration: InputDecoration(
                      hintText: 'name',
                      suffixText: _domains.length > 1 ? null : '@$_domain',
                    ),
                  ),
                  if (_domains.length > 1) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _domain,
                      items: [
                        for (final domain in _domains)
                          DropdownMenuItem(
                            value: domain,
                            child: Text(
                              '@$domain',
                              style: rmText(16, color: c.ink),
                            ),
                          ),
                      ],
                      onChanged: (domain) => setState(() {
                        _domain = domain ?? _domain;
                        _error = null;
                      }),
                    ),
                  ],
                  const SizedBox(height: 22),
                  const SectionLabel('Display name'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _displayName,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) {
                      if (_ready) unawaited(_create());
                    },
                    style: rmText(16, color: c.ink),
                    decoration: const InputDecoration(hintText: 'Optional'),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ErrorText(error),
                  ],
                  const SizedBox(height: 26),
                  RmPrimaryButton(
                    label: 'Create mailbox',
                    busy: _busy,
                    onPressed: _ready ? () => unawaited(_create()) : null,
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

/// One theme pack in the picker: its two loudest colours, its name, what it
/// is for, and a tick when it is the one in force.
class _PackTile extends StatelessWidget {
  const _PackTile({
    required this.pack,
    required this.selected,
    required this.onTap,
  });

  final ThemePack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.line),
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: Row(
                    children: [
                      Container(width: 13, height: 26, color: pack.colors.bg),
                      Container(width: 13, height: 26, color: pack.colors.mark),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pack.name,
                    style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    pack.tagline,
                    style: rmText(12, color: c.ink3, height: 1.35),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_rounded, size: 18, color: c.accent),
          ],
        ),
      ),
    );
  }
}
