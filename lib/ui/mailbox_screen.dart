import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../state/interface_prefs.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/day_sections.dart';
import '../util/format.dart';
import 'add_account_screen.dart';
import 'imap_account_screen.dart';
import 'compose_sheet.dart';
import 'mail_actions.dart';
import 'mailboxes_screen.dart';
import 'message_screen.dart';
import 'search_screen.dart';
import 'widgets/common.dart';
import 'widgets/day_heading.dart';
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
    final prefs = AppScope.of(context).settings.interface;
    final absolute =
        prefs.choice(dateSeparatorsPanel, dayStyleOption) == 'absolute';
    final showCount = prefs.toggle(dateSeparatorsPanel, dayCountOption);
    final previewLines = prefs.isOn(listPreviewPanel)
        ? switch (prefs.choice(listPreviewPanel, previewLinesOption)) {
            'one' => 1,
            'none' => 0,
            _ => 2,
          }
        : 2;
    final showAttachments = prefs.isOn(listAttachmentsPanel);
    final showConversationCount = prefs.isOn(listCountPanel);
    final showFlags = prefs.isOn(listFlagPanel);
    final entries = buildListEntries(
      m.conversations,
      withDays: prefs.isOn(dateSeparatorsPanel),
    );
    return RefreshIndicator(
      color: c.accent,
      onRefresh: m.refresh,
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == entries.length) return _Footer(mailbox: m);
          final entry = entries[index];
          if (entry is DayEntry) {
            return RmDayHeading(
              label: dayHeading(entry.day, absolute: absolute),
              count: showCount ? entry.count : null,
            );
          }
          final conversation = (entry as ConversationEntry).conversation;
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
              previewLines: previewLines,
              showAttachment: showAttachments,
              showCount: showConversationCount,
              showFlag: showFlags,
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
            onPressed: () => unawaited(
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const MailboxesScreen(),
                ),
              ),
            ),
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
