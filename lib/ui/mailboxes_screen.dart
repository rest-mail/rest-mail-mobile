import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../l10n/voice.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'add_account_screen.dart';
import 'admin/admin_screen.dart';
import 'admin/overview_screen.dart';
import 'settings_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';

/// The accounts this phone knows. Picking one makes it the account on screen,
/// and everything below the selector — its numbers, its folders and its
/// storage — changes with it. Settings opens for that account too.
class MailboxesScreen extends StatefulWidget {
  const MailboxesScreen({super.key});

  @override
  State<MailboxesScreen> createState() => _MailboxesScreenState();
}

class _MailboxesScreenState extends State<MailboxesScreen> {
  QuotaInfo? _quota;
  int? _quotaFor;

  ServerStats? _health;
  ApiException? _healthError;
  String? _healthFor;
  bool _healthLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_refreshQuota());
        unawaited(_refreshHealth());
      }
    });
  }

  /// The server's own health, for a REST Mail admin who may read the
  /// overview. It belongs to the account on screen, so it follows a switch.
  Future<void> _refreshHealth() async {
    final app = AppScope.read(context);
    final current = app.current;
    if (current is! RestAccount ||
        current.signedOut != null ||
        !AdminAccess(current.capabilities).canRead(AdminSection.overview)) {
      if (mounted) {
        setState(() {
          _health = null;
          _healthFor = null;
          _healthError = null;
          _healthLoading = false;
        });
      }
      return;
    }
    if (_healthFor == current.key && _health != null) return;
    setState(() {
      _healthFor = current.key;
      _healthLoading = true;
      _healthError = null;
    });
    try {
      final stats = await current.client.stats();
      if (mounted && _healthFor == current.key) {
        setState(() {
          _health = stats;
          _healthLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted && _healthFor == current.key) {
        setState(() {
          _healthError = e;
          _healthLoading = false;
        });
      }
    }
  }

  /// Storage is an extra, not a requirement: a backend that cannot answer
  /// (IMAP, or a signed-out account) leaves it out.
  Future<void> _refreshQuota() async {
    final app = AppScope.read(context);
    final m = app.mailbox;
    final account = m?.account;
    if (m == null || account == null || app.current?.signedOut != null) {
      if (mounted) setState(() => _quota = null);
      return;
    }
    if (_quotaFor == account.id) return;
    setState(() {
      _quotaFor = account.id;
      _quota = null;
    });
    try {
      final quota = await m.backend.quota(account.id);
      if (mounted && _quotaFor == account.id) setState(() => _quota = quota);
    } on ApiException {
      // The stats leave storage out.
    }
  }

  Future<void> _select(_MailboxAccount account) async {
    if (account.current) return;
    await account.open(StandardFolder.inbox);
    if (!mounted) return;
    _quotaFor = null;
    _healthFor = null;
    await Future.wait([_refreshQuota(), _refreshHealth()]);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final m = app.mailbox;
    if (m == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              RmTopBar(
                title: tr(context, 'mailboxes.title'),
                onBack: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(child: Text('No accounts are signed in.')),
              ),
            ],
          ),
        ),
      );
    }
    return ListenableBuilder(
      listenable: m,
      builder: (context, _) {
        if (_quotaFor != m.account?.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) unawaited(_refreshQuota());
          });
        }
        return _screen(context, app, m);
      },
    );
  }

  Widget _screen(BuildContext context, AppState app, MailboxState m) {
    final current = app.current;
    final signedOut = current?.signedOut != null;
    final admin = current is RestAccount && !signedOut
        ? AdminAccess(current.capabilities)
        : null;
    final administers = admin?.any ?? false;
    final adminAccount = administers && current is RestAccount ? current : null;
    final showsHealth = admin?.canRead(AdminSection.overview) ?? false;
    final healthAccount = showsHealth && current is RestAccount
        ? current
        : null;
    if (healthAccount != null && _healthFor != healthAccount.key) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refreshHealth());
      });
    }
    final accounts = _accounts(app, m);
    final selected =
        accounts.where((account) => account.current).firstOrNull ??
        (accounts.isEmpty ? null : accounts.first);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailboxes.title'),
              onBack: () => Navigator.pop(context),
              actions: [
                RmIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: tr(context, 'settings.mailboxTitle'),
                  onPressed: () => unawaited(
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => MailboxSettingsScreen(mailbox: m),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  if (selected != null)
                    _AccountSelector(
                      account: selected,
                      live: m.live,
                      onTap: () => unawaited(_pickAccount(context, accounts)),
                    ),
                  const SizedBox(height: 12),
                  _Stats(
                    folders: m.folders,
                    quota: _quota,
                    loading: m.loading && m.folders.isEmpty,
                    signedOut: signedOut,
                  ),
                  const SizedBox(height: 22),
                  SectionLabel(tr(context, 'mailboxes.folders')),
                  const SizedBox(height: 9),
                  _Folders(
                    folders: m.folders,
                    currentFolder: m.folder,
                    loading: m.loading,
                    onOpen: (folder) {
                      Navigator.pop(context);
                      unawaited(m.selectFolder(folder.name));
                    },
                  ),
                  if (adminAccount != null) ...[
                    const SizedBox(height: 22),
                    RmGroup(
                      children: [
                        _LinkRow(
                          icon: Icons.admin_panel_settings_outlined,
                          label: 'Administration',
                          screen: AdministrationScreen(account: adminAccount),
                        ),
                      ],
                    ),
                  ],
                  if (healthAccount != null) ...[
                    const SizedBox(height: 22),
                    SectionLabel(tr(context, 'health.title')),
                    const SizedBox(height: 9),
                    _ServerHealth(
                      stats: _health,
                      loading: _healthLoading,
                      error: _healthError,
                      host: healthAccount.server.host,
                      onRetry: () => unawaited(_refreshHealth()),
                      onOpen: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              OverviewScreen(account: healthAccount),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// One entry per account or mailbox this phone can switch to, in the order
  /// the app added them. Linking a mailbox puts it under its signed-in
  /// account, so that account's folders are its primary's.
  List<_MailboxAccount> _accounts(AppState app, MailboxState m) {
    final account = m.account;
    return [
      for (final other in app.accounts)
        if (other != app.current)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            current: false,
            signedOut: other.signedOut != null,
            open: (folder) =>
                app.switchTo(other, folder: folder, keepNavigator: true),
          )
        else if (m.accounts.isEmpty)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            current: true,
            signedOut: other.signedOut != null,
            open: m.selectFolder,
          )
        else
          for (final linked in m.accounts)
            _MailboxAccount(
              key: '${other.key}#${linked.id}',
              label: linked.label,
              address: linked.address,
              current: linked.id == account?.id,
              open: (folder) => m.selectAccount(linked, folder: folder),
            ),
    ];
  }

  Future<void> _pickAccount(
    BuildContext context,
    List<_MailboxAccount> accounts,
  ) async {
    final chosen = await showModalBottomSheet<_MailboxAccount>(
      context: context,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheet) => _AccountPicker(
        accounts: accounts,
        onAddAccount: () {
          Navigator.pop(sheet);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const AddAccountScreen()),
          );
        },
      ),
    );
    if (chosen == null || !mounted) return;
    await _select(chosen);
  }
}

/// The account on screen, opening the accounts this phone knows.
class _AccountSelector extends StatelessWidget {
  const _AccountSelector({
    required this.account,
    required this.live,
    required this.onTap,
  });

  final _MailboxAccount account;
  final LiveStatus live;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final a = account;
    return Tooltip(
      message: tr(context, 'mailboxes.switch'),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
            decoration: BoxDecoration(
              border: Border.all(color: c.line),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                RmAvatar(
                  name: a.label.isEmpty ? '?' : a.label,
                  seed: a.address,
                  size: 42,
                  color: c.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rmText(
                          16,
                          color: c.ink,
                          weight: FontWeight.w700,
                          tracking: -0.02,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rmText(12.5, color: c.ink3),
                      ),
                    ],
                  ),
                ),
                if (a.signedOut)
                  Text(
                    tr(context, 'status.signedOut'),
                    style: rmText(11.5, color: c.ink3, weight: FontWeight.w600),
                  )
                else ...[
                  SyncDot(live),
                  const SizedBox(width: 6),
                  Text(
                    liveLabelOf(context, live),
                    style: rmText(11.5, color: c.ink3, weight: FontWeight.w600),
                  ),
                ],
                const SizedBox(width: 4),
                Icon(Icons.expand_more_rounded, size: 22, color: c.ink3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The accounts in a sheet, one tap away from being the screen.
class _AccountPicker extends StatelessWidget {
  const _AccountPicker({required this.accounts, required this.onAddAccount});

  final List<_MailboxAccount> accounts;
  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Text(
              tr(context, 'mailboxes.switch'),
              style: rmText(
                17,
                color: c.ink,
                weight: FontWeight.w700,
                tracking: -0.02,
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              children: [
                for (final account in accounts)
                  _AccountChoice(account: account),
                const SizedBox(height: 6),
                Divider(height: 1, color: c.line),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onAddAccount,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, size: 20, color: c.accent),
                        const SizedBox(width: 11),
                        Text(
                          tr(context, 'settings.addAccount'),
                          style: rmText(
                            14.5,
                            color: c.accent,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountChoice extends StatelessWidget {
  const _AccountChoice({required this.account});

  final _MailboxAccount account;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final a = account;
    return Material(
      color: a.current ? c.accentSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pop(context, a),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              RmAvatar(
                name: a.label.isEmpty ? '?' : a.label,
                seed: a.address,
                size: 32,
                color: a.current ? c.accent : null,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(
                        14.5,
                        color: c.ink,
                        weight: a.current ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      a.signedOut
                          ? '${a.address} · ${tr(context, 'status.signedOut')}'
                          : a.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(12, color: c.ink3),
                    ),
                  ],
                ),
              ),
              if (a.current)
                Icon(Icons.check_rounded, size: 20, color: c.accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// The selected REST Mail server's health: the numbers an operator checks
/// first, with a way into the full overview.
class _ServerHealth extends StatelessWidget {
  const _ServerHealth({
    required this.stats,
    required this.loading,
    required this.error,
    required this.host,
    required this.onRetry,
    required this.onOpen,
  });

  final ServerStats? stats;
  final bool loading;
  final ApiException? error;
  final String host;
  final VoidCallback onRetry;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    if (error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                describeError(context, error!, host: host),
                style: rmText(13, color: c.ink2, height: 1.4),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                tr(context, 'health.retry'),
                style: rmText(13, color: c.accent, weight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }
    final values = stats;
    if (values == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (loading) ...[
              SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: c.accent,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              tr(context, 'health.loading'),
              style: rmText(13, color: c.ink3, weight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
    final percent = values.inboundMx == 0
        ? null
        : (values.inboundOverTls * 100 / values.inboundMx).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _Stat(
                  value: values.domains,
                  label: tr(context, 'health.domains'),
                ),
              ),
              Expanded(
                child: _Stat(
                  value: values.mailboxes,
                  label: tr(context, 'health.mailboxes'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  value: values.queuePending,
                  label: tr(context, 'health.waiting'),
                ),
              ),
              Expanded(
                child: _Stat(
                  value: values.queueFailed,
                  label: tr(context, 'health.failed'),
                ),
              ),
            ],
          ),
          if (percent != null) ...[
            const SizedBox(height: 14),
            Text(
              trArgs(context, 'health.tls', {
                'percent': '$percent',
                'total': countLabel(values.inboundMx),
              }),
              style: rmText(12.5, color: c.ink3, height: 1.4),
            ),
          ],
          const SizedBox(height: 6),
          Divider(color: c.line, height: 20),
          InkWell(
            onTap: onOpen,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(context, 'health.open'),
                      style: rmText(
                        13.5,
                        color: c.accent,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 20, color: c.accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The numbers a drawer had no room for: what is waiting, what is stored.
class _Stats extends StatelessWidget {
  const _Stats({
    required this.folders,
    required this.quota,
    required this.loading,
    required this.signedOut,
  });

  final List<Folder> folders;
  final QuotaInfo? quota;
  final bool loading;
  final bool signedOut;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    if (signedOut) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          tr(context, 'mailboxes.signedOutNote'),
          style: rmText(12.5, color: c.ink3, height: 1.4),
        ),
      );
    }
    final inbox = folders
        .where((folder) => folder.name == StandardFolder.inbox)
        .firstOrNull;
    final unread = folders.fold<int>(0, (sum, f) => sum + f.unread);
    final total = folders.fold<int>(0, (sum, f) => sum + f.total);
    final q = quota;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (loading && folders.isEmpty)
            Text(
              tr(context, 'mailboxes.loading'),
              style: rmText(12.5, color: c.ink3),
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: inbox?.unread ?? 0,
                        label: tr(context, 'mailboxes.inboxUnread'),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        value: unread,
                        label: tr(context, 'mailboxes.unread'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: total,
                        label: tr(context, 'mailboxes.messages'),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        value: folders.length,
                        label: tr(context, 'mailboxes.folders'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (q != null && q.quotaBytes > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  tr(context, 'mailboxes.storage'),
                  style: rmText(12.5, color: c.ink3, weight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '${sizeLabel(q.usedBytes)} of ${sizeLabel(q.quotaBytes)}',
                  style: rmText(12, color: c.ink3),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (q.percentUsed / 100).clamp(0, 1),
                minHeight: 6,
                backgroundColor: c.line,
                valueColor: AlwaysStoppedAnimation<Color>(c.accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          countLabel(value),
          style: rmText(
            20,
            color: c.ink,
            weight: FontWeight.w800,
            tracking: -0.03,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: rmText(11.5, color: c.ink3, weight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// The selected account's folders, as one card of icon rows.
class _Folders extends StatelessWidget {
  const _Folders({
    required this.folders,
    required this.currentFolder,
    required this.loading,
    required this.onOpen,
  });

  final List<Folder> folders;
  final String currentFolder;
  final bool loading;
  final ValueChanged<Folder> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    if (folders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          loading ? 'Loading folders…' : 'No folders yet.',
          style: rmText(12.5, color: c.ink3),
        ),
      );
    }
    return RmGroup(
      children: [
        for (final folder in folders)
          _FolderTile(
            folder: folder,
            selected: folder.name == currentFolder,
            onTap: () => onOpen(folder),
          ),
      ],
    );
  }
}

class _FolderTile extends StatelessWidget {
  const _FolderTile({
    required this.folder,
    required this.selected,
    required this.onTap,
  });

  final Folder folder;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final drafts = folder.name == StandardFolder.drafts;
    final unread = drafts ? 0 : folder.unread;
    final tint = selected
        ? c.accent
        : switch (folder.name) {
            StandardFolder.inbox => c.accent,
            _ when StandardFolder.ordered.contains(folder.name) => c.ink2,
            _ => folder.isLabel ? c.tintPurple : c.ink2,
          };
    return Material(
      color: selected ? c.accentSoft : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: selected ? 0.16 : 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _folderIcon(folder.name, folder.isLabel),
                  size: 18,
                  color: tint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  folderLabelOf(context, folder.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: rmText(
                    14.5,
                    color: selected ? c.accent : c.ink,
                    weight: selected || unread > 0
                        ? FontWeight.w700
                        : FontWeight.w500,
                    tracking: -0.01,
                  ),
                ),
              ),
              if (unread > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    countLabel(unread),
                    style: rmText(
                      11.5,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Text(
                  countLabel(folder.total),
                  style: rmText(
                    12.5,
                    color: selected ? c.accent : c.ink3,
                    weight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _folderIcon(String name, bool isLabel) => switch (name) {
  StandardFolder.inbox => Icons.inbox_rounded,
  StandardFolder.drafts => Icons.edit_note_rounded,
  StandardFolder.sent => Icons.send_rounded,
  StandardFolder.archive => Icons.archive_outlined,
  StandardFolder.spam => Icons.report_gmailerrorred_rounded,
  StandardFolder.trash => Icons.delete_outline_rounded,
  _ => isLabel ? Icons.label_outline_rounded : Icons.folder_outlined,
};

/// A row that opens [screen], with the Mailboxes route replaced so Back
/// returns to the mail.
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.screen,
  });

  final IconData icon;
  final String label;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return InkWell(
      onTap: () => unawaited(
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => screen),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c.ink2),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

/// An account or mailbox in the picker, and the thing that puts it on screen.
class _MailboxAccount {
  const _MailboxAccount({
    required this.key,
    required this.label,
    required this.address,
    required this.current,
    required this.open,
    this.signedOut = false,
  });

  final String key;
  final String label;
  final String address;

  /// The account the app is on.
  final bool current;
  final bool signedOut;

  /// Puts it on screen at a folder.
  final Future<void> Function(String folder) open;
}
