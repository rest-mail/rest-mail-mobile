import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../version.dart';
import 'add_account_screen.dart';
import 'admin/admin_screen.dart';
import 'app_passwords_screen.dart';
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
        current is RestAccount && AdminAccess(current.capabilities).any;
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
                        for (final account in m.accounts)
                          _AccountRow(
                            label: account.label,
                            address: account.address,
                            subtitle: account.isPrimary
                                ? 'Signed in · $host'
                                : 'Linked mailbox · $host',
                            primary: account.isPrimary,
                            onTap: () => _push(
                              context,
                              AccountScreen(mailbox: m, account: account),
                            ),
                          ),
                        if (m.backend.canLinkMailboxes)
                          _AddRow(
                            label: 'Link another mailbox',
                            onTap: () =>
                                _push(context, LinkAccountScreen(mailbox: m)),
                          ),
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
                            subtitle: other.hasMailbox
                                ? 'Signed in · ${other.host}'
                                : 'Administrator · ${other.host}',
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
          'The session for ${account.address} is removed from this device. '
              'Your mail stays on $host.',
          if (app.accounts.length > 1) 'Your other accounts stay signed in.',
        ].join(' '),
        action: 'Sign out',
      );
      if (sure && signedIn != null) await app.signOut(signedIn);
      return;
    }
    final sure = await confirmAction(
      context,
      title: 'Remove ${account.address}?',
      message: 'It is unlinked from this session. The mailbox and its mail are untouched.',
      action: 'Remove',
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
        SnackBar(content: Text('Removed ${account.address}')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(e, host: host));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final account = widget.account;
    final host = widget.mailbox.backend.host;
    final quota = _quota;
    // App passwords are a REST Mail mailbox's, made by its own session: not
    // a linked mailbox's, and not an IMAP account's.
    final session = switch (AppScope.of(context).current) {
      final RestAccount rest
          when account.isPrimary &&
              identical(rest.backend, widget.mailbox.backend) =>
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
                              '${account.isPrimary ? 'Primary mailbox' : 'Linked mailbox'} · $host',
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
                            : 'Remove from this session',
                        danger: true,
                        onTap: _busy ? null : () => unawaited(_remove()),
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

/// Adds another mailbox on the same server to the session.
class LinkAccountScreen extends StatefulWidget {
  const LinkAccountScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  bool get _ready =>
      !_busy && _email.text.contains('@') && _password.text.isNotEmpty;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
      );
      await widget.mailbox.reloadAccounts();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Linked ${linked.address}')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e) {
          ApiException(code: 'unauthorized') => 'Wrong address or password.',
          ApiException(statusCode: 409) => 'That mailbox is already linked.',
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
                    'Add another mailbox on $host to this session. Switch between them from the menu.',
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
