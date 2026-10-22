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

/// Every account down the side, each with its inbox's unread count, and
/// opened out, its folders with theirs; then settings.
class MailboxesScreen extends StatefulWidget {
  const MailboxesScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<MailboxesScreen> createState() => _MailboxesScreenState();
}

class _MailboxesScreenState extends State<MailboxesScreen> {
  /// The folders of the accounts not on screen, as they come in.
  final _folders = <String, List<Folder>>{};

  /// Those whose folders could not be loaded.
  final _failed = <String>{};

  final _requested = <String>{};

  /// The account opened out to show its folders, one at a time; the one on
  /// screen to begin with.
  String? _open;
  bool _opened = false;

  /// One entry per account, in the order they were added, so switching
  /// doesn't reshuffle them. The one on screen stands in for its linked
  /// mailboxes; signed out, its mail isn't loaded and it shows as it was
  /// saved.
  List<_MailboxAccount> _accounts(AppState app) {
    final m = widget.mailbox;
    final account = m.account;
    return [
      for (final other in app.accounts)
        if (other != app.current)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            selected: false,
            open: (folder) => app.switchTo(other, folder: folder),
            load: other.signedOut == null ? () => app.folders(other) : null,
          )
        else if (m.accounts.isEmpty)
          _MailboxAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            selected: true,
            signedOut: other.signedOut != null,
            open: m.selectFolder,
          )
        else
          for (final linked in m.accounts)
            _MailboxAccount(
              key: '${other.key}#${linked.id}',
              label: linked.label,
              address: linked.address,
              selected: linked.id == account?.id,
              open: (folder) => m.selectAccount(linked, folder: folder),
              load: linked.id == account?.id
                  ? null
                  : () async => sortFolders(await m.backend.folders(linked.id)),
            ),
    ];
  }

  /// Asks every account not on screen for its folders, once, for the
  /// unread counts.
  void _load(List<_MailboxAccount> accounts) {
    for (final a in accounts) {
      final load = a.load;
      if (load == null || !_requested.add(a.key)) continue;
      unawaited(
        load().then(
          (folders) {
            if (mounted) setState(() => _folders[a.key] = folders);
          },
          onError: (Object _) {
            if (mounted) setState(() => _failed.add(a.key));
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadQuota());
    });
  }

  QuotaInfo? _quota;

  /// The storage summary is an extra, not a requirement: a backend that
  /// cannot answer (IMAP, or a signed-out account) leaves it out.
  Future<void> _loadQuota() async {
    final account = widget.mailbox.account;
    if (account == null) return;
    if (AppScope.read(context).current?.signedOut != null) return;
    try {
      final quota = await widget.mailbox.backend.quota(account.id);
      if (mounted) setState(() => _quota = quota);
    } on ApiException {
      // The summary leaves storage out.
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.mailbox,
    builder: (context, _) => _screen(context),
  );

  Widget _screen(BuildContext context) {
    final c = context.rm;
    final m = widget.mailbox;
    final app = AppScope.of(context);
    final current = app.current;
    final signedOut = current?.signedOut != null;
    final administers =
        current is RestAccount &&
        !signedOut &&
        AdminAccess(current.capabilities).any;
    final accounts = _accounts(app);
    _load(accounts);
    if (!_opened) {
      _opened = true;
      _open = accounts
          .where((a) => a.selected && !a.signedOut)
          .firstOrNull
          ?.key;
    }
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
                  const SectionLabel('This account'),
                  const SizedBox(height: 9),
                  _summary(context, m, signedOut),
                  const SizedBox(height: 22),
                  const SectionLabel('Accounts'),
                  const SizedBox(height: 9),
                  for (final a in accounts) ...[
                    _MailboxAccountRow(
                      account: a,
                      folders: a.selected ? m.folders : _folders[a.key],
                      expandable: _expandable(a),
                      expanded: _open == a.key,
                      // Like an accordion: it opens, and the one open closes.
                      // One with no folders to show, signed out, is put on
                      // screen to be signed in again.
                      onTap: () {
                        if (_expandable(a)) {
                          setState(() => _open = _open == a.key ? null : a.key);
                        } else {
                          Navigator.pop(context);
                          if (!a.selected) {
                            unawaited(a.open(StandardFolder.inbox));
                          }
                        }
                      },
                    ),
                    if (_expandable(a))
                      _Fold(
                        open: _open == a.key,
                        children: _accountFolders(
                          a,
                          a.selected ? m.folders : _folders[a.key],
                        ),
                      ),
                  ],
                  const _SectionRule(),
                  if (administers)
                    _LinkRow(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Administration',
                      screen: AdministrationScreen(account: current),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                    child: Row(
                      children: [
                        SyncDot(signedOut ? LiveStatus.offline : m.live),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            signedOut ? 'Signed out' : liveLabel(m.live),
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

  /// The account on screen, with the numbers a drawer had no room for: the
  /// inbox waiting on you, the rest of the unread mail, the size of the
  /// mailbox, and how much of its storage is used.
  Widget _summary(BuildContext context, MailboxState m, bool signedOut) {
    final c = context.rm;
    final account = m.account;
    if (account == null) return const SizedBox.shrink();
    final inbox = m.folders
        .where((f) => f.name == StandardFolder.inbox)
        .firstOrNull;
    final unread = m.folders.fold<int>(0, (sum, f) => sum + f.unread);
    final total = m.folders.fold<int>(0, (sum, f) => sum + f.total);
    final quota = _quota;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RmAvatar(
                name: account.label.isEmpty ? '?' : account.label,
                seed: account.address,
                size: 44,
                color: c.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.label,
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
                      account.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(12.5, color: c.ink3),
                    ),
                  ],
                ),
              ),
              SyncDot(signedOut ? LiveStatus.offline : m.live),
              const SizedBox(width: 6),
              Text(
                signedOut ? 'Signed out' : liveLabel(m.live),
                style: rmText(11.5, color: c.ink3, weight: FontWeight.w600),
              ),
            ],
          ),
          if (signedOut) ...[
            const SizedBox(height: 14),
            Text(
              'This account is signed out. Open it in the list below to sign '
              'in again.',
              style: rmText(12.5, color: c.ink3, height: 1.4),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _Stat(value: inbox?.unread ?? 0, label: 'Inbox unread'),
                _Stat(value: unread, label: 'Unread'),
                _Stat(value: total, label: 'Messages'),
                _Stat(value: m.folders.length, label: 'Folders'),
              ],
            ),
            if (quota != null && quota.quotaBytes > 0) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Storage',
                    style: rmText(12.5, color: c.ink3, weight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '${sizeLabel(quota.usedBytes)} of '
                    '${sizeLabel(quota.quotaBytes)}',
                    style: rmText(12, color: c.ink3),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (quota.percentUsed / 100).clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: c.line,
                  valueColor: AlwaysStoppedAnimation<Color>(c.accent),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// Whether [account] has folders to open out to.
  bool _expandable(_MailboxAccount account) =>
      !account.signedOut && (account.selected || account.load != null);

  /// [account]'s folders under its row; tapping one puts the account on
  /// screen there.
  List<Widget> _accountFolders(_MailboxAccount account, List<Folder>? folders) {
    final m = widget.mailbox;
    final c = context.rm;
    final counted = folders != null && folders.isNotEmpty;
    if (folders == null || folders.isEmpty) {
      final failed = _failed.contains(account.key);
      // The one on screen has at least the folder it shows.
      if (account.selected) {
        folders = [Folder(name: m.folder, total: 0, unread: 0)];
      } else {
        return [
          Padding(
            padding: const EdgeInsets.fromLTRB(46, 8, 12, 10),
            child: Text(
              failed ? 'Couldn’t load its folders' : 'Loading folders…',
              style: rmText(12.5, color: c.ink3),
            ),
          ),
        ];
      }
    }
    return [
      for (final folder in folders)
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: _MailboxFolderRow(
            folder: folder,
            counted: counted,
            selected: account.selected && folder.name == m.folder,
            onTap: () {
              Navigator.pop(context);
              unawaited(account.open(folder.name));
            },
          ),
        ),
    ];
  }
}

/// One number in the account summary.
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

/// [children] sliding open and shut beneath an account's row.
class _Fold extends StatefulWidget {
  const _Fold({required this.open, required this.children});

  final bool open;
  final List<Widget> children;

  @override
  State<_Fold> createState() => _FoldState();
}

class _FoldState extends State<_Fold> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: widget.open ? 1 : 0,
  )..addStatusListener((_) => setState(() {}));

  late final _size = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void didUpdateWidget(_Fold old) {
    super.didUpdateWidget(old);
    if (widget.open != old.open) {
      unawaited(widget.open ? _controller.forward() : _controller.reverse());
    }
  }

  @override
  void dispose() {
    _size.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Shut, the folders aren't there at all, so nothing finds them hidden.
  @override
  Widget build(BuildContext context) => _controller.isDismissed
      ? const SizedBox.shrink()
      : SizeTransition(
          sizeFactor: _size,
          alignment: Alignment.topCenter,
          child: Column(children: widget.children),
        );
}

/// An account in the drawer, on screen or not.
class _MailboxAccount {
  const _MailboxAccount({
    required this.key,
    required this.label,
    required this.address,
    required this.selected,
    required this.open,
    this.load,
    this.signedOut = false,
  });

  final String key;
  final String label;
  final String address;

  /// On screen.
  final bool selected;
  final bool signedOut;

  /// Puts it on screen at a folder.
  final Future<void> Function(String folder) open;

  /// Its folders, for one not on screen and signed in.
  final Future<List<Folder>> Function()? load;
}

/// The line between the drawer's accounts, folders and links.
class _SectionRule extends StatelessWidget {
  const _SectionRule();

  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: context.rm.line,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  );
}

/// A row at the foot of the drawer that opens [screen].
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
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        unawaited(
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => screen),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c.ink2),
            const SizedBox(width: 12),
            Text(
              label,
              style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// An account or mailbox in the drawer, by name and address, with its
/// inbox's number: the same one as the Inbox row under it. Tapping it opens
/// out its folders.
class _MailboxAccountRow extends StatelessWidget {
  const _MailboxAccountRow({
    required this.account,
    required this.folders,
    required this.expandable,
    required this.expanded,
    required this.onTap,
  });

  final _MailboxAccount account;

  /// Its folders, or null until they come in.
  final List<Folder>? folders;

  /// Has folders to open out to.
  final bool expandable;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final a = account;
    final inbox = folders
        ?.where((f) => f.name == StandardFolder.inbox)
        .firstOrNull;
    return Material(
      color: a.selected ? c.accentSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 0, 9),
          child: Row(
            children: [
              RmAvatar(
                name: a.label.isEmpty ? '?' : a.label,
                seed: a.address,
                size: 32,
                color: a.selected ? c.accent : null,
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
                        weight: a.selected ? FontWeight.w700 : FontWeight.w600,
                        tracking: -0.01,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      a.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(12, color: c.ink3),
                    ),
                  ],
                ),
              ),
              if (inbox != null)
                Text(
                  countLabel(inbox.total),
                  style: rmText(
                    12.5,
                    color: a.selected ? c.accent : c.ink3,
                    weight: FontWeight.w700,
                  ),
                ),
              if (expandable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.expand_more, size: 20, color: c.ink3),
                  ),
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// A folder, with how many messages it holds.
class _MailboxFolderRow extends StatelessWidget {
  const _MailboxFolderRow({
    required this.folder,
    required this.selected,
    required this.onTap,
    this.counted = true,
  });

  final Folder folder;
  final bool selected;
  final VoidCallback onTap;

  /// False while its count hasn't come in, rather than show it as none.
  final bool counted;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final dot = switch (folder.name) {
      StandardFolder.inbox => c.accent,
      _ when StandardFolder.ordered.contains(folder.name) => c.ink3,
      _ => c.tintPurple,
    };
    return Material(
      color: selected ? c.accentSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: dot,
                  borderRadius: BorderRadius.circular(2),
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
                    color: c.ink,
                    weight: selected ? FontWeight.w700 : FontWeight.w500,
                    tracking: -0.01,
                  ),
                ),
              ),
              if (counted)
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
