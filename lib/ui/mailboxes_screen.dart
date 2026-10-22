import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'admin/admin_screen.dart';
import 'settings_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';

/// The accounts this phone knows, and one of them opened up: its numbers,
/// its folders and its storage. Picking another account changes everything
/// below the selector; tapping a folder opens that account's mail there.
class MailboxesScreen extends StatefulWidget {
  const MailboxesScreen({super.key});

  @override
  State<MailboxesScreen> createState() => _MailboxesScreenState();
}

typedef _AccountLoad = ({List<Folder> folders, QuotaInfo? quota});

class _MailboxesScreenState extends State<MailboxesScreen> {
  /// The account the screen is showing. The one on screen in the app until
  /// another is picked.
  String? _selectedKey;

  List<Folder>? _previewFolders;
  QuotaInfo? _previewQuota;
  bool _previewLoading = false;
  Object? _previewError;
  int _generation = 0;

  QuotaInfo? _currentQuota;
  int? _currentQuotaFor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadCurrentQuota());
    });
  }

  Future<void> _loadCurrentQuota() async {
    final app = AppScope.read(context);
    final m = app.mailbox;
    final account = m?.account;
    if (m == null || account == null || app.current?.signedOut != null) {
      if (mounted) setState(() => _currentQuota = null);
      return;
    }
    if (_currentQuotaFor == account.id) return;
    setState(() {
      _currentQuotaFor = account.id;
      _currentQuota = null;
    });
    try {
      final quota = await m.backend.quota(account.id);
      if (mounted && _currentQuotaFor == account.id) {
        setState(() => _currentQuota = quota);
      }
    } on ApiException {
      // The stats leave storage out.
    }
  }

  Future<void> _select(_MailboxAccount account) async {
    if (account.key == _selectedKey) return;
    final generation = ++_generation;
    setState(() {
      _selectedKey = account.key;
      _previewFolders = null;
      _previewQuota = null;
      _previewError = null;
      _previewLoading = true;
    });
    if (account.current) {
      await _loadCurrentQuota();
      if (!mounted || generation != _generation) return;
      setState(() => _previewLoading = false);
      return;
    }
    final load = account.load;
    if (load == null) {
      if (mounted) setState(() => _previewLoading = false);
      return;
    }
    try {
      final result = await load();
      if (!mounted || generation != _generation) return;
      setState(() {
        _previewFolders = result.folders;
        _previewQuota = result.quota;
        _previewLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _previewError = e;
        _previewLoading = false;
      });
    }
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
                title: 'Mailboxes',
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
        if (_currentQuotaFor != m.account?.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) unawaited(_loadCurrentQuota());
          });
        }
        return _screen(context, app, m);
      },
    );
  }

  Widget _screen(BuildContext context, AppState app, MailboxState m) {
    final c = context.rm;
    final accounts = _accounts(app, m);
    if (_selectedKey == null ||
        !accounts.any((account) => account.key == _selectedKey)) {
      _selectedKey =
          accounts.where((account) => account.current).firstOrNull?.key ??
          accounts.firstOrNull?.key;
    }
    final selected = accounts.firstWhere(
      (account) => account.key == _selectedKey,
      orElse: () => accounts.first,
    );
    final folders = selected.current ? m.folders : _previewFolders;
    final quota = selected.current ? _currentQuota : _previewQuota;
    final loading = selected.current
        ? m.loading && m.folders.isEmpty
        : _previewLoading;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Mailboxes',
              onBack: () => Navigator.pop(context),
              trailingText: 'Settings',
              onTrailing: () => unawaited(
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => SettingsScreen(mailbox: m),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _AccountSelector(
                    account: selected,
                    onTap: accounts.isEmpty
                        ? null
                        : () => unawaited(_pickAccount(context, accounts)),
                  ),
                  const SizedBox(height: 12),
                  _Stats(
                    folders: folders,
                    quota: quota,
                    loading: loading,
                    signedOut: selected.signedOut,
                    unread: _previewError == null,
                  ),
                  const SizedBox(height: 22),
                  const SectionLabel('Folders'),
                  const SizedBox(height: 9),
                  _Folders(
                    folders: folders,
                    currentFolder: selected.current ? m.folder : null,
                    loading: loading,
                    error: selected.current ? null : _previewError,
                    onOpen: (folder) {
                      Navigator.pop(context);
                      unawaited(selected.open(folder.name));
                    },
                  ),
                  if (selected.administers &&
                      selected.adminAccount != null) ...[
                    const SizedBox(height: 22),
                    RmGroup(
                      children: [
                        _LinkRow(
                          icon: Icons.admin_panel_settings_outlined,
                          label: 'Administration',
                          screen: AdministrationScreen(
                            account: selected.adminAccount!,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
                    child: Row(
                      children: [
                        selected.current
                            ? SyncDot(m.live)
                            : Icon(
                                Icons.visibility_outlined,
                                size: 12,
                                color: c.ink3,
                              ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            selected.current
                                ? (selected.signedOut
                                      ? 'Signed out'
                                      : liveLabel(m.live))
                                : 'Tap a folder to open this account',
                            style: rmText(
                              11.5,
                              color: c.ink3,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// One entry per account or mailbox this phone can show, in the order the
  /// app added them. Linking a mailbox puts it under its signed-in account.
  List<_MailboxAccount> _accounts(AppState app, MailboxState m) {
    final account = m.account;
    final admin = app.current;
    final administers =
        admin is RestAccount &&
        admin.signedOut == null &&
        AdminAccess(admin.capabilities).any;
    return [
      for (final other in app.accounts)
        if (other != app.current)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            current: false,
            signedOut: other.signedOut != null,
            administers:
                other is RestAccount &&
                other.signedOut == null &&
                AdminAccess(other.capabilities).any,
            adminAccount: other is RestAccount ? other : null,
            open: (folder) => app.switchTo(other, folder: folder),
            load: () => _loadAccount(app, other),
          )
        else if (m.accounts.isEmpty)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            current: true,
            signedOut: other.signedOut != null,
            administers: administers,
            adminAccount: admin is RestAccount ? admin : null,
            open: m.selectFolder,
          )
        else
          for (final linked in m.accounts)
            _MailboxAccount(
              key: '${other.key}#${linked.id}',
              label: linked.label,
              address: linked.address,
              current: linked.id == account?.id,
              signedOut: other.signedOut != null,
              administers: administers,
              adminAccount: admin is RestAccount ? admin : null,
              open: (folder) => m.selectAccount(linked, folder: folder),
              load: () => _loadLinked(m, linked),
            ),
    ];
  }

  Future<_AccountLoad> _loadAccount(
    AppState app,
    SignedInAccount account,
  ) async {
    final folders = await app.folders(account);
    QuotaInfo? quota;
    if (account is RestAccount) {
      try {
        final boxes = await account.backend.accounts();
        final primary = boxes.firstWhere(
          (box) => box.isPrimary,
          orElse: () => boxes.first,
        );
        quota = await account.backend.quota(primary.id);
      } on ApiException {
        // Leave storage out.
      }
    }
    return (folders: folders, quota: quota);
  }

  Future<_AccountLoad> _loadLinked(MailboxState m, Account linked) async {
    final folders = sortFolders(await m.backend.folders(linked.id));
    QuotaInfo? quota;
    try {
      quota = await m.backend.quota(linked.id);
    } on ApiException {
      // Leave storage out.
    }
    return (folders: folders, quota: quota);
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
      builder: (sheet) =>
          _AccountPicker(accounts: accounts, selectedKey: _selectedKey),
    );
    if (chosen == null || !mounted) return;
    await _select(chosen);
  }
}

/// The account the screen is showing, opening the accounts this phone knows.
class _AccountSelector extends StatelessWidget {
  const _AccountSelector({required this.account, required this.onTap});

  final _MailboxAccount account;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final a = account;
    return Tooltip(
      message: 'Switch account',
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
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      'Signed out',
                      style: rmText(
                        11.5,
                        color: c.ink3,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                Icon(Icons.expand_more_rounded, size: 22, color: c.ink3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The accounts in a sheet, one tap away from changing the screen.
class _AccountPicker extends StatelessWidget {
  const _AccountPicker({required this.accounts, required this.selectedKey});

  final List<_MailboxAccount> accounts;
  final String? selectedKey;

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
              'Switch account',
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
                  _AccountChoice(
                    account: account,
                    selected: account.key == selectedKey,
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
  const _AccountChoice({required this.account, required this.selected});

  final _MailboxAccount account;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final a = account;
    return Material(
      color: selected ? c.accentSoft : Colors.transparent,
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
                color: selected ? c.accent : null,
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
                        weight: selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      a.signedOut ? '${a.address} · Signed out' : a.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(12, color: c.ink3),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, size: 20, color: c.accent),
            ],
          ),
        ),
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
    required this.unread,
  });

  final List<Folder>? folders;
  final QuotaInfo? quota;
  final bool loading;
  final bool signedOut;
  final bool unread;

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
          'This account is signed out. Sign in again to load its folders.',
          style: rmText(12.5, color: c.ink3, height: 1.4),
        ),
      );
    }
    final list = folders ?? const <Folder>[];
    final inbox = list
        .where((folder) => folder.name == StandardFolder.inbox)
        .firstOrNull;
    final unreadCount = list.fold<int>(0, (sum, f) => sum + f.unread);
    final total = list.fold<int>(0, (sum, f) => sum + f.total);
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
          if (loading && list.isEmpty)
            Text('Loading this account…', style: rmText(12.5, color: c.ink3))
          else
            Row(
              children: [
                _Stat(
                  value: unread ? (inbox?.unread ?? 0) : 0,
                  label: 'Inbox unread',
                ),
                _Stat(value: unread ? unreadCount : 0, label: 'Unread'),
                _Stat(value: total, label: 'Messages'),
                _Stat(value: list.length, label: 'Folders'),
              ],
            ),
          if (q != null && q.quotaBytes > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Storage',
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
    return Expanded(
      child: Column(
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
      ),
    );
  }
}

/// The selected account's folders, as one card of icon rows.
class _Folders extends StatelessWidget {
  const _Folders({
    required this.folders,
    required this.currentFolder,
    required this.loading,
    required this.error,
    required this.onOpen,
  });

  final List<Folder>? folders;
  final String? currentFolder;
  final bool loading;
  final Object? error;
  final ValueChanged<Folder> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final list = folders;
    if (error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          'Could not load this account’s folders.',
          style: rmText(12.5, color: c.ink3),
        ),
      );
    }
    if (list == null || list.isEmpty) {
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
        for (final folder in list)
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
                  folderLabel(folder.name),
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
    this.administers = false,
    this.adminAccount,
    this.load,
  });

  final String key;
  final String label;
  final String address;

  /// The account the app is on, whose folders are live.
  final bool current;
  final bool signedOut;
  final bool administers;
  final RestAccount? adminAccount;

  /// Puts it on screen at a folder.
  final Future<void> Function(String folder) open;

  /// Its folders and storage, for one not on screen.
  final Future<_AccountLoad> Function()? load;
}
