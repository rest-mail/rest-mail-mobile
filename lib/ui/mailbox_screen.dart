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
import '../util/search_parser.dart';
import 'add_account_screen.dart';
import 'imap_account_screen.dart';
import 'compose_sheet.dart';
import 'mail_actions.dart';
import 'mailboxes_screen.dart';
import 'message_screen.dart';
import 'settings_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/day_heading.dart';
import 'widgets/message_row.dart';

/// The folder on screen, with the Mailboxes screen and the button to write
/// a message.
class MailboxScreen extends StatefulWidget {
  const MailboxScreen({super.key, this.mailbox});

  /// A mailbox to show directly, for tests; the app follows the account on
  /// screen instead, so switching accounts updates this screen in place.
  final MailboxState? mailbox;

  @override
  State<MailboxScreen> createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen> {
  final _scroll = ScrollController();
  (int?, String)? _showing;

  /// The inline search over the list below the header.
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _searchDebounce;
  int _searchRuns = 0;
  bool _searching = false;
  Paged<Message>? _searchResults;
  ApiException? _searchError;
  int _searchMs = 0;

  MailboxState get _mailbox =>
      widget.mailbox ?? AppScope.read(context).mailbox!;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        unawaited(_mailbox.loadMore());
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    _searchFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Clears the query and closes the results, returning to the folder.
  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchRuns++;
    _search.clear();
    _searchFocus.unfocus();
    setState(() {
      _searching = false;
      _searchResults = null;
      _searchError = null;
    });
  }

  void _searchChanged(String text) {
    _searchDebounce?.cancel();
    _searchRuns++;
    if (text.trim().isEmpty) {
      setState(() {
        _searchResults = null;
        _searchError = null;
        _searching = false;
      });
      return;
    }
    setState(() {});
    // A second of quiet, so a half-written word never becomes a request.
    _searchDebounce = Timer(
      const Duration(seconds: 1),
      () => unawaited(_runSearch(text)),
    );
  }

  Future<void> _runSearch(String text) async {
    final account = _mailbox.account;
    final query = text.trim();
    if (account == null || query.isEmpty) return;
    _searchDebounce?.cancel();
    final run = ++_searchRuns;
    setState(() {
      _searching = true;
      _searchError = null;
    });
    final watch = Stopwatch()..start();
    try {
      final page = await _mailbox.backend.search(
        account.id,
        parseSearch(query),
      );
      if (!mounted || run != _searchRuns) return;
      setState(() {
        _searchResults = page;
        _searchMs = watch.elapsedMilliseconds;
        _searching = false;
      });
    } on ApiException catch (e) {
      if (!mounted || run != _searchRuns) return;
      setState(() {
        _searchError = e;
        _searching = false;
      });
    }
  }

  Widget _searchBar(BuildContext context) {
    final c = context.rm;
    final query = _search.text.trim();
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border.all(color: c.accentLine, width: 1.5),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 18, color: c.ink3),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      focusNode: _searchFocus,
                      autocorrect: false,
                      textInputAction: TextInputAction.search,
                      onChanged: _searchChanged,
                      onSubmitted: (text) => unawaited(_runSearch(text)),
                      style: rmText(15.5, color: c.ink),
                      decoration: bareInput(context, 'Search mail', size: 15.5),
                    ),
                  ),
                  if (_searching)
                    SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: c.ink3,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (query.isNotEmpty || _searching)
            RmIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Close search',
              color: c.ink3,
              onPressed: _clearSearch,
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _searchList(BuildContext context, MailboxState m) {
    final c = context.rm;
    final error = _searchError, results = _searchResults;
    final query = _search.text.trim();
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ErrorText(describeError(error, host: m.backend.host)),
          )
        else if (_searching && results == null)
          const Padding(
            padding: EdgeInsets.only(top: 44),
            child: Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (results != null && results.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Text(
              'No messages match “$query”.',
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink3, height: 1.5),
            ),
          )
        else if (results != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Text(
              '${countLabel(results.items.length)}${results.hasMore ? '+' : ''} '
              '${results.items.length == 1 ? 'result' : 'results'} · '
              '$_searchMs ms',
              style: rmText(12, color: c.ink3, weight: FontWeight.w600),
            ),
          ),
          for (final message in results.items)
            MessageRow(
              message: message,
              dense: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => MessageScreen(mailbox: m, message: message),
                ),
              ),
            ),
        ],
      ],
    );
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
    final m = _mailbox;
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
    final m = _mailbox;
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
    final current = widget.mailbox ?? AppScope.of(context).mailbox;
    if (current == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: current,
      builder: (context, _) {
        final m = current;
        final account = AppScope.of(context).current;
        final signedOut = account?.signedOut != null;
        _topOnSwitch(m);
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Header(mailbox: m, account: account),
                if (account != null && !signedOut) _searchBar(context),
                Expanded(
                  child: account != null && signedOut
                      ? _SignedOut(account: account)
                      : _search.text.trim().isNotEmpty
                      ? _searchList(context, m)
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
          Expanded(
            child: Tooltip(
              message: 'Mailboxes',
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const MailboxesScreen(),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                  child: Row(
                    children: [
                      LogoMark(size: 28),
                      const SizedBox(width: 10),
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
                                SyncDot(
                                  signedOut ? LiveStatus.offline : m.live,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    address == null
                                        ? status
                                        : '$status · $address',
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
                    ],
                  ),
                ),
              ),
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
              icon: Icons.settings_outlined,
              tooltip: 'App settings',
              color: c.ink2,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const AppSettingsScreen(),
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
