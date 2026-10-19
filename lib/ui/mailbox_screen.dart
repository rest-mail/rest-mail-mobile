import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/admin_access.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/format.dart';
import 'add_account_screen.dart';
import 'imap_account_screen.dart';
import 'admin/admin_screen.dart';
import 'compose_sheet.dart';
import 'mail_actions.dart';
import 'message_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/message_row.dart';

/// The folder on screen, with the drawer for folders and accounts and the
/// button to write a message.
class MailboxScreen extends StatefulWidget {
  const MailboxScreen({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<MailboxScreen> createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen> {
  final _scroll = ScrollController();
  (int?, String)? _showing;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        unawaited(widget.mailbox.loadMore());
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// A different folder or account starts at the top, not wherever the last
  /// one was scrolled to.
  void _topOnSwitch(MailboxState m) {
    final showing = (m.account?.id, m.folder);
    if (showing == _showing) return;
    _showing = showing;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(0);
    });
  }

  /// Opens a row: [conversation]'s newest message, the rest of it beside.
  Future<void> _open(List<Message> conversation) async {
    final m = widget.mailbox;
    final message = conversation.first;
    if (m.folder == StandardFolder.drafts || message.isDraft) {
      try {
        final draft = await m.backend.message(message.id);
        if (!mounted) return;
        await openCompose(context, mailbox: m, seed: draftSeed(draft));
      } on ApiException catch (e) {
        if (mounted) showToast(context, describeError(e));
      }
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MessageScreen(
          mailbox: m,
          message: message,
          others: conversation.sublist(1),
        ),
      ),
    );
  }

  /// A swiped row goes to Trash whole, conversation and all.
  Future<void> _swipedAway(List<Message> conversation) async {
    final m = widget.mailbox;
    final message = conversation.first;
    final permanent = message.folder == StandardFolder.trash;
    await removeWithUndo(
      messenger: ScaffoldMessenger.of(context),
      mailbox: m,
      message: message,
      others: conversation.sublist(1),
      action: () => m.delete(message, others: conversation.sublist(1)),
      done: permanent ? 'Deleted' : 'Moved to Trash',
      undoable: !permanent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.mailbox,
      builder: (context, _) {
        final m = widget.mailbox;
        final account = AppScope.of(context).current;
        final signedOut = account?.signedOut != null;
        _topOnSwitch(m);
        return Scaffold(
          drawer: MailDrawer(mailbox: m),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Header(mailbox: m, account: account),
                Expanded(
                  child: account != null && signedOut
                      ? _SignedOut(account: account)
                      : _list(context, m),
                ),
              ],
            ),
          ),
          floatingActionButton: signedOut
              ? null
              : _ComposeButton(
                  onPressed: () => unawaited(openCompose(context, mailbox: m)),
                ),
        );
      },
    );
  }

  Widget _list(BuildContext context, MailboxState m) {
    final c = context.rm;
    final error = m.error;
    if (m.messages.isEmpty && m.loading) {
      return const Center(
        child: SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (m.messages.isEmpty && error != null) {
      return _Problem(
        text: describeError(error, host: m.backend.host),
        onRetry: () => unawaited(m.retry()),
      );
    }
    final rows = m.conversations;
    return RefreshIndicator(
      color: c.accent,
      onRefresh: m.refresh,
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        itemCount: rows.length + 1,
        itemBuilder: (context, index) {
          if (index == rows.length) return _Footer(mailbox: m);
          final conversation = rows[index];
          final message = conversation.first;
          return Dismissible(
            key: ValueKey('message-${message.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: c.danger,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (_) => confirmPermanentDelete(context, message),
            onDismissed: (_) => unawaited(_swipedAway(conversation)),
            child: MessageRow(
              // Unread while any of it is, flagged if any of it is.
              message: message.copyWith(
                isRead: conversation.every((each) => each.isRead),
                isFlagged: conversation.any((each) => each.isFlagged),
              ),
              count: conversation.length,
              onTap: () => unawaited(_open(conversation)),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.mailbox, required this.account});

  final MailboxState mailbox;

  /// The account on screen, whose mail [mailbox] is.
  final SignedInAccount? account;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final m = mailbox;
    final address = m.account?.address ?? account?.address;
    final signedOut = account?.signedOut != null;
    final status = signedOut ? 'Signed out' : liveLabel(m.live);
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          RmIconButton(
            icon: Icons.menu_rounded,
            tooltip: 'Folders and accounts',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folderLabel(m.folder),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: rmText(
                    19,
                    color: c.ink,
                    weight: FontWeight.w800,
                    tracking: -0.03,
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    SyncDot(signedOut ? LiveStatus.offline : m.live),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        address == null ? status : '$status · $address',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rmText(
                          11.5,
                          color: c.ink3,
                          weight: FontWeight.w600,
                          tracking: -0.01,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!signedOut) ...[
            RmIconButton(
              icon: Icons.refresh_rounded,
              tooltip: 'Refresh',
              color: c.ink2,
              onPressed: () => unawaited(m.retry()),
            ),
            RmIconButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => SearchScreen(mailbox: m),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.mailbox});

  final MailboxState mailbox;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final m = mailbox;
    if (m.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final label = folderLabel(m.folder);
    final String text;
    if (m.messages.isEmpty) {
      text = 'Nothing in $label';
    } else if (m.hasMore) {
      return const SizedBox(height: 24);
    } else {
      text =
          'All caught up — ${countLabel(m.currentFolder?.total ?? m.messages.length)} in $label';
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(16, m.messages.isEmpty ? 80 : 24, 16, 24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: rmText(12, color: c.ink3, tracking: -0.01),
      ),
    );
  }
}

class _Problem extends StatelessWidget {
  const _Problem({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 28, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: rmText(14, color: c.accent, weight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// In place of the mail of an account that can no longer reach it: why,
/// the way back in, and the way to take it off the phone. Signing in again
/// keeps the account as it was, its name, servers and place in the list.
class _SignedOut extends StatefulWidget {
  const _SignedOut({required this.account});

  final SignedInAccount account;

  @override
  State<_SignedOut> createState() => _SignedOutState();
}

class _SignedOutState extends State<_SignedOut> {
  bool _busy = false;
  String? _error;

  Future<void> _signIn() async {
    final account = widget.account;
    switch (account) {
      // A REST Mail account signs in with its password, and its code.
      case RestAccount(:final server, :final address):
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => AddAccountScreen(server: server, email: address),
          ),
        );
      case final ImapAccount imap:
        if (imap.oauth == null) {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => ImapAccountScreen(
                email: imap.address,
                initialSettings: imap.settings,
                initialDisplayName: imap.displayName,
              ),
            ),
          );
          return;
        }
        setState(() {
          _busy = true;
          _error = null;
        });
        try {
          await AppScope.read(context).signInAgain(imap);
          // Signed in: the app puts the account's mail in place of this.
        } on ApiException catch (e) {
          if (!mounted) return;
          setState(() {
            _busy = false;
            // Closing the sign-in page is an answer, not a failure.
            _error = e.code == 'cancelled' ? null : describeError(e);
          });
        }
    }
  }

  Future<void> _remove() async {
    final app = AppScope.read(context);
    final account = widget.account;
    final sure = await confirmAction(
      context,
      title: 'Remove ${account.address}?',
      message: [
        'It comes off this phone, with its settings. Your mail stays on '
            '${account.host}.',
        if (app.accounts.length > 1) 'Your other accounts stay.',
      ].join(' '),
      action: 'Remove',
    );
    if (sure) await app.removeAccount(account);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final account = widget.account;
    final error = _error;
    final label = switch (account) {
      ImapAccount(:final oauth?) => 'Sign in with ${oauth.kind.label}',
      _ => 'Sign in again',
    };
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 28, color: c.ink3),
            const SizedBox(height: 12),
            Text(
              account.signedOut ?? '',
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
            if (error != null) ...[
              const SizedBox(height: 14),
              ErrorText(error),
            ],
            const SizedBox(height: 20),
            RmPrimaryButton(
              label: label,
              busy: _busy,
              onPressed: () => unawaited(_signIn()),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: _busy ? null : () => unawaited(_remove()),
              child: Text(
                'Remove from this phone',
                style: rmText(14, color: c.ink2, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final shape = BorderRadius.circular(19);
    return Tooltip(
      message: 'New message',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: [
            BoxShadow(
              color: c.accent.withValues(alpha: 0.34),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: c.accent,
          borderRadius: shape,
          child: InkWell(
            borderRadius: shape,
            onTap: onPressed,
            child: const SizedBox.square(
              dimension: 58,
              child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

/// Every account down the side, each with its inbox's unread count, and
/// opened out, its folders with theirs; then settings.
class MailDrawer extends StatefulWidget {
  const MailDrawer({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  State<MailDrawer> createState() => _MailDrawerState();
}

class _MailDrawerState extends State<MailDrawer> {
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
  List<_DrawerAccount> _accounts(AppState app) {
    final m = widget.mailbox;
    final account = m.account;
    return [
      for (final other in app.accounts)
        if (other != app.current)
          _DrawerAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            selected: false,
            open: (folder) => app.switchTo(other, folder: folder),
            load: other.signedOut == null ? () => app.folders(other) : null,
          )
        else if (m.accounts.isEmpty)
          _DrawerAccount(
            key: other.key,
            label: other.label,
            address: other.address,
            selected: true,
            signedOut: other.signedOut != null,
            open: m.selectFolder,
          )
        else
          for (final linked in m.accounts)
            _DrawerAccount(
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
  void _load(List<_DrawerAccount> accounts) {
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
  Widget build(BuildContext context) {
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
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          children: [
            for (final a in accounts) ...[
              _AccountRow(
                account: a,
                folders: a.selected ? m.folders : _folders[a.key],
                expandable: _expandable(a),
                expanded: _open == a.key,
                // Like an accordion: it opens, and the one open closes. One
                // with no folders to show, signed out, is put on screen to
                // be signed in again.
                onTap: () {
                  if (_expandable(a)) {
                    setState(() => _open = _open == a.key ? null : a.key);
                  } else {
                    Navigator.pop(context);
                    if (!a.selected) unawaited(a.open(StandardFolder.inbox));
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
            const _DrawerRule(),
            if (administers)
              _DrawerLink(
                icon: Icons.admin_panel_settings_outlined,
                label: 'Administration',
                screen: AdministrationScreen(account: current),
              ),
            _DrawerLink(
              icon: Icons.settings_outlined,
              label: 'Settings',
              screen: SettingsScreen(mailbox: m),
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
    );
  }

  /// Whether [account] has folders to open out to.
  bool _expandable(_DrawerAccount account) =>
      !account.signedOut && (account.selected || account.load != null);

  /// [account]'s folders under its row; tapping one puts the account on
  /// screen there.
  List<Widget> _accountFolders(_DrawerAccount account, List<Folder>? folders) {
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
          child: _FolderRow(
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
class _DrawerAccount {
  const _DrawerAccount({
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
class _DrawerRule extends StatelessWidget {
  const _DrawerRule();

  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: context.rm.line,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  );
}

/// A row at the foot of the drawer that opens [screen].
class _DrawerLink extends StatelessWidget {
  const _DrawerLink({
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
        Navigator.pop(context);
        unawaited(
          Navigator.push(
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
class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.account,
    required this.folders,
    required this.expandable,
    required this.expanded,
    required this.onTap,
  });

  final _DrawerAccount account;

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
class _FolderRow extends StatelessWidget {
  const _FolderRow({
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
