import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

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
import 'add_account_screen.dart';
import 'admin/admin_screen.dart';
import 'app_passwords_screen.dart';
import 'interface_settings.dart';
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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final app = AppScope.of(context);
    final settings = app.settings;
    final m = widget.mailbox;
    final host = m.backend.host;
    final quota = _quota;
    final signature = settings.signature.trim();
    final others = app.accounts.where((a) => a != app.current);
    final current = app.current;
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
              RmTopBar(title: 'Settings', onBack: () => Navigator.pop(context)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                  children: [
                    const SectionLabel('Accounts'),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        // Signed out, it has none of its mail to show: its
                        // mail screen signs it in again, or removes it.
                        if (current case final out? when out.signedOut != null)
                          _AccountRow(
                            label: out.label,
                            address: out.address,
                            subtitle: 'Signed out · ${out.host}',
                            primary: true,
                            onTap: () => Navigator.pop(context),
                          )
                        else ...[
                          for (final account in m.accounts)
                            _AccountRow(
                              label: account.label,
                              address: account.address,
                              subtitle: account.isPrimary
                                  ? 'Signed in · $host'
                                  : 'Mailbox of this account · $host',
                              primary: account.isPrimary,
                              onTap: () => _push(
                                context,
                                AccountScreen(mailbox: m, account: account),
                              ),
                            ),
                          if (creates)
                            _AddRow(
                              label: 'Create a mailbox',
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
                              label: 'Link another mailbox',
                              onTap: () =>
                                  _push(context, LinkAccountScreen(mailbox: m)),
                            ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Accounts of their own, each with its own session,
                    // perhaps on another server. Tapping one puts it on
                    // screen.
                    const SectionLabel('Other accounts'),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        for (final other in others)
                          _AccountRow(
                            label: other.label,
                            address: other.address,
                            subtitle: other.signedOut == null
                                ? 'Signed in · ${other.host}'
                                : 'Signed out · ${other.host}',
                            icon: Icons.swap_horiz_rounded,
                            onTap: () => unawaited(app.switchTo(other)),
                          ),
                        _AddRow(
                          label: 'Add an account',
                          onTap: () => _push(context, const AddAccountScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (administers) ...[
                      const SectionLabel('Server'),
                      const SizedBox(height: 9),
                      RmGroup(
                        children: [
                          RmRow(
                            label: 'Administration',
                            subtitle: 'What this session may run on $host',
                            onTap: () => _push(
                              context,
                              AdministrationScreen(account: current),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                    _NotificationsSection(app: app),
                    InterfaceSettings(
                      prefs: settings.interface,
                      onChanged: (prefs) => unawaited(
                        app.updateSettings(settings.copyWith(interface: prefs)),
                      ),
                    ),
                    const SectionLabel('General'),
                    const SizedBox(height: 9),
                    RmGroup(
                      children: [
                        RmRow(
                          label: 'Signature',
                          value: signature.isEmpty
                              ? 'None'
                              : signature.split('\n').first,
                          onTap: () => _push(context, const SignatureScreen()),
                        ),
                        if (m.backend.canScheduleSend)
                          RmRow(
                            label: 'Scheduled',
                            subtitle: 'Messages the server will send later',
                            onTap: () =>
                                _push(context, ScheduledScreen(mailbox: m)),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Appearance',
                                  style: rmText(
                                    14.5,
                                    color: c.ink,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (ThemePack.byId(settings.packId).followsSystem)
                                RmSegmented<ThemeMode>(
                                  options: const [
                                    (ThemeMode.system, 'System'),
                                    (ThemeMode.light, 'Light'),
                                    (ThemeMode.dark, 'Dark'),
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
                    Text(
                      [
                        'rest-mail for mobile $appVersion · $host',
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
          const SectionLabel('Notifications'),
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
    this.icon = Icons.chevron_right_rounded,
  });

  final String label;
  final String address;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;

  /// What tapping does: open the account, or switch to it.
  final IconData icon;

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
            Icon(icon, size: 20, color: c.ink3),
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

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    required this.mailbox,
    required this.account,
  });

  final MailboxState mailbox;
  final Account account;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  QuotaInfo? _quota;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadQuota());
  }

  Future<void> _loadQuota() async {
    try {
      final quota = await widget.mailbox.backend.quota(widget.account.id);
      if (mounted) setState(() => _quota = quota);
    } on ApiException {
      // Storage is left off.
    }
  }

  Future<void> _remove() async {
    final account = widget.account;
    final host = widget.mailbox.backend.host;
    final app = AppScope.read(context);
    if (account.isPrimary) {
      // This account only: any others on the phone stay signed in.
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
    final account = widget.account;
    final host = widget.mailbox.backend.host;
    final quota = _quota;
    // App passwords are a REST Mail account's: the session's own, or one it
    // owns, which it created or linked. Not an IMAP account's.
    final session = switch (AppScope.of(context).current) {
      final RestAccount rest
          when identical(rest.backend, widget.mailbox.backend) =>
        rest,
      _ => null,
    };
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(title: 'Account', onBack: () => Navigator.pop(context)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 40),
                children: [
                  Row(
                    children: [
                      RmAvatar(
                        name: account.label,
                        seed: account.address,
                        size: 52,
                        color: account.isPrimary ? c.accent : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.address,
                              style: rmText(
                                17,
                                color: c.ink,
                                weight: FontWeight.w700,
                                tracking: -0.02,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${account.isPrimary ? 'Primary mailbox' : 'Mailbox of this account'} · $host',
                              style: rmText(13, color: c.ink3),
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
                        value: widget.mailbox.backend.canLinkMailboxes
                            ? 'Pushed live by the server'
                            : 'Live while the app is open',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (session != null) ...[
                    RmGroup(
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],
                  RmGroup(
                    children: [
                      RmRow(
                        label: 'Signature',
                        onTap: () => _push(context, const SignatureScreen()),
                      ),
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
