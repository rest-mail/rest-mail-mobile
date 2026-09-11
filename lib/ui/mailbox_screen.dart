import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/format.dart';
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

  Future<void> _open(Message message) async {
    final m = widget.mailbox;
    if (m.folder == StandardFolder.drafts || message.isDraft) {
      try {
        final draft = await m.client.message(message.id);
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
        builder: (_) => MessageScreen(mailbox: m, message: message),
      ),
    );
  }

  Future<void> _swipedAway(Message message) async {
    final m = widget.mailbox;
    final permanent = message.folder == StandardFolder.trash;
    await removeWithUndo(
      messenger: ScaffoldMessenger.of(context),
      mailbox: m,
      message: message,
      action: () => m.delete(message),
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
        _topOnSwitch(m);
        return Scaffold(
          drawer: MailDrawer(mailbox: m),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Header(mailbox: m),
                Expanded(child: _list(context, m)),
              ],
            ),
          ),
          floatingActionButton: _ComposeButton(
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
        text: describeError(error, host: m.client.server.host),
        onRetry: () => unawaited(m.retry()),
      );
    }
    return RefreshIndicator(
      color: c.accent,
      onRefresh: m.refresh,
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        itemCount: m.messages.length + 1,
        itemBuilder: (context, index) {
          if (index == m.messages.length) return _Footer(mailbox: m);
          final message = m.messages[index];
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
            onDismissed: (_) => unawaited(_swipedAway(message)),
            child: MessageRow(
              message: message,
              onTap: () => unawaited(_open(message)),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.mailbox});

  final MailboxState mailbox;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final m = mailbox;
    final address = m.account?.address;
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
                    SyncDot(m.live),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        address == null
                            ? liveLabel(m.live)
                            : '${liveLabel(m.live)} · $address',
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
              MaterialPageRoute<void>(builder: (_) => SearchScreen(mailbox: m)),
            ),
          ),
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

/// Accounts along the top, then folders with their counts, then settings.
class MailDrawer extends StatelessWidget {
  const MailDrawer({super.key, required this.mailbox});

  final MailboxState mailbox;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final m = mailbox;
    final account = m.account;
    final others = m.accounts.where((a) => a.id != account?.id);
    final folders = m.folders.isEmpty
        ? [Folder(name: m.folder, total: 0, unread: 0)]
        : m.folders;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.line)),
              ),
              child: Row(
                children: [
                  RmAvatar(
                    name: account?.label ?? '?',
                    seed: account?.address ?? '',
                    size: 38,
                    color: c.accent,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account?.label ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rmText(
                            14.5,
                            color: c.ink,
                            weight: FontWeight.w700,
                            tracking: -0.01,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          account?.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rmText(12, color: c.ink3),
                        ),
                      ],
                    ),
                  ),
                  for (final other in others)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Tooltip(
                        message: 'Switch to ${other.address}',
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            Navigator.pop(context);
                            unawaited(m.selectAccount(other));
                          },
                          child: RmAvatar(
                            name: other.label,
                            seed: other.address,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                children: [
                  for (final folder in folders)
                    _FolderRow(
                      folder: folder,
                      selected: folder.name == m.folder,
                      onTap: () {
                        Navigator.pop(context);
                        unawaited(m.selectFolder(folder.name));
                      },
                    ),
                  Container(
                    height: 1,
                    color: c.line,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context);
                      unawaited(
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => SettingsScreen(mailbox: m),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            size: 18,
                            color: c.ink2,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Settings',
                            style: rmText(
                              14.5,
                              color: c.ink,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                    child: Row(
                      children: [
                        SyncDot(m.live),
                        const SizedBox(width: 8),
                        Text(
                          liveLabel(m.live),
                          style: rmText(
                            11.5,
                            color: c.ink3,
                            weight: FontWeight.w600,
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
}

class _FolderRow extends StatelessWidget {
  const _FolderRow({
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
    // Drafts counts what is waiting; everywhere else counts what is unread.
    final count = folder.name == StandardFolder.drafts
        ? folder.total
        : folder.unread;
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
              if (count > 0)
                Text(
                  countLabel(count),
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
