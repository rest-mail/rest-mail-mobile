import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/painters.dart';

/// The build's `--build-name`: pubspec's version unless a release overrides
/// it, and "dev" when nothing passes one (as under `flutter test`).
const _version = String.fromEnvironment(
  'FLUTTER_BUILD_NAME',
  defaultValue: 'dev',
);

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
      final quota = await widget.mailbox.client.quota(account.id);
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
    final host = m.client.server.host;
    final quota = _quota;
    final signature = settings.signature.trim();
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
                            account: account,
                            subtitle: account.isPrimary
                                ? 'Signed in · $host'
                                : 'Linked mailbox · $host',
                            onTap: () => _push(
                              context,
                              AccountScreen(mailbox: m, account: account),
                            ),
                          ),
                        _LinkRow(
                          onTap: () =>
                              _push(context, LinkAccountScreen(mailbox: m)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
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
                        'rest-mail for mobile $_version · $host',
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
    required this.account,
    required this.subtitle,
    required this.onTap,
  });

  final Account account;
  final String subtitle;
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
            RmAvatar(
              name: account.label,
              seed: account.address,
              size: 32,
              color: account.isPrimary ? c.accent : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.address,
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

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.onTap});

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
            Text(
              'Link another mailbox',
              style: rmText(14.5, color: c.accent, weight: FontWeight.w600),
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
      final quota = await widget.mailbox.client.quota(widget.account.id);
      if (mounted) setState(() => _quota = quota);
    } on ApiException {
      // Storage is left off.
    }
  }

  Future<void> _remove() async {
    final account = widget.account;
    final host = widget.mailbox.client.server.host;
    final app = AppScope.read(context);
    if (account.isPrimary) {
      final sure = await confirmAction(
        context,
        title: 'Sign out?',
        message:
            'The session is removed from this device. Your mail stays on $host.',
        action: 'Sign out',
      );
      if (sure) await app.signOut();
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
      await widget.mailbox.client.unlinkAccount(account.id);
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
    final host = widget.mailbox.client.server.host;
    final quota = _quota;
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
                      const RmRow(
                        label: 'Updates',
                        value: 'Pushed live by the server',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
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
    final host = widget.mailbox.client.server.host;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final linked = await widget.mailbox.client.linkAccount(
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
    final host = widget.mailbox.client.server.host;
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
