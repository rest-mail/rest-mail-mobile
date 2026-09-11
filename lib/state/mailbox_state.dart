import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restmail_api/restmail_api.dart';

enum LiveStatus { connecting, live, offline }

/// One signed-in session's mail: its accounts, the folder on screen and the
/// messages in it, kept current by the server's event stream.
class MailboxState extends ChangeNotifier {
  MailboxState(this.client);

  final RestmailClient client;

  List<Account> accounts = const [];
  Account? account;
  List<Folder> folders = const [];
  String folder = StandardFolder.inbox;

  List<Message> messages = const [];
  bool hasMore = false;
  bool loading = true;
  bool loadingMore = false;

  /// Why the folder could not be loaded, shown in place of the list.
  ApiException? error;

  LiveStatus live = LiveStatus.connecting;

  String? _cursor;
  StreamSubscription<MailEvent>? _events;
  bool _disposed = false;

  /// Bumped whenever the account or folder changes, so an answer that comes
  /// back for the old one is dropped rather than shown under the new name.
  int _generation = 0;

  Set<String> get ownAddresses => {
    for (final a in accounts) a.address.toLowerCase(),
  };

  Folder? get currentFolder =>
      folders.where((f) => f.name == folder).firstOrNull;

  Future<void> start() async {
    try {
      accounts = await client.accounts();
      if (accounts.isEmpty) {
        throw const ApiException(
          0,
          'no_mailbox',
          'This session has no mailbox',
        );
      }
      account = accounts.firstWhere(
        (a) => a.isPrimary,
        orElse: () => accounts.first,
      );
    } on ApiException catch (e) {
      error = e;
      loading = false;
      _notify();
      return;
    }
    _listen();
    await Future.wait([refreshFolders(), _loadFirstPage()]);
  }

  Future<void> reloadAccounts() async {
    accounts = await client.accounts();
    if (!accounts.any((a) => a.id == account?.id) && accounts.isNotEmpty) {
      await selectAccount(accounts.first);
    }
    _notify();
  }

  Future<void> selectAccount(Account next) async {
    if (next.id == account?.id) return;
    account = next;
    folder = StandardFolder.inbox;
    folders = const [];
    messages = const [];
    _listen();
    await Future.wait([refreshFolders(), _loadFirstPage()]);
  }

  Future<void> selectFolder(String name) async {
    if (name == folder) return;
    folder = name;
    messages = const [];
    await _loadFirstPage();
  }

  Future<void> refresh() => Future.wait([refreshFolders(), _loadFirstPage()]);

  /// Retries the event stream and the folder after a failure.
  Future<void> retry() async {
    if (account == null) return start();
    _listen();
    await refresh();
  }

  Future<void> refreshFolders() async {
    final account = this.account;
    if (account == null) return;
    try {
      final fresh = await client.folders(account.id);
      if (account.id != this.account?.id) return;
      folders = sortFolders(fresh);
      _notify();
    } on ApiException {
      // Keep the counts we had; the next event or refresh tries again.
    }
  }

  Future<void> loadMore() async {
    final account = this.account, cursor = _cursor;
    if (account == null ||
        cursor == null ||
        !hasMore ||
        loading ||
        loadingMore) {
      return;
    }
    final generation = _generation;
    loadingMore = true;
    _notify();
    try {
      final page = await client.messages(account.id, folder, cursor: cursor);
      if (generation != _generation) return;
      final known = {for (final m in messages) m.id};
      messages = [
        ...messages,
        ...page.items.where((m) => !known.contains(m.id)),
      ];
      _cursor = page.cursor;
      hasMore = page.hasMore;
    } on ApiException {
      // Scrolling to the end again retries.
    } finally {
      loadingMore = false;
      _notify();
    }
  }

  // ── Changes, applied here first and undone if the server refuses ──────

  Future<void> setRead(Message message, bool read) => _change(
    message,
    message.copyWith(isRead: read),
    () => client.updateMessage(message.id, isRead: read),
  );

  Future<void> setFlagged(Message message, bool flagged) => _change(
    message,
    message.copyWith(isFlagged: flagged),
    () => client.updateMessage(message.id, isFlagged: flagged),
  );

  Future<void> move(Message message, String to) =>
      _remove(message, () => client.updateMessage(message.id, folder: to));

  /// To Trash, or gone for good if it is already there.
  Future<void> delete(Message message) =>
      _remove(message, () => client.deleteMessage(message.id));

  /// Puts back a message that [move] or [delete] took out of the list.
  void restore(Message message) {
    if (message.folder != folder || messages.any((m) => m.id == message.id)) {
      return;
    }
    messages = [...messages, message]..sort(_newestFirst);
    _notify();
  }

  /// Undoes a [move], or a [delete] that went to Trash: sends the message
  /// back to the folder it came from and puts it back in the list.
  Future<void> undoRemoval(Message original) async {
    await client.updateMessage(original.id, folder: original.folder);
    restore(original);
    unawaited(refreshFolders());
  }

  Future<void> _change(
    Message before,
    Message after,
    Future<Object?> Function() call,
  ) async {
    _replace(before.id, after);
    try {
      await call();
      if (before.isRead != after.isRead) unawaited(refreshFolders());
    } on ApiException {
      _replace(after.id, before);
      rethrow;
    }
  }

  Future<void> _remove(Message message, Future<Object?> Function() call) async {
    final index = messages.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      messages = [...messages]..removeAt(index);
      _notify();
    }
    try {
      await call();
      unawaited(refreshFolders());
    } on ApiException {
      if (index >= 0) restore(message);
      rethrow;
    }
  }

  void _replace(int id, Message message) {
    final index = messages.indexWhere((m) => m.id == id);
    if (index < 0) return;
    messages = [...messages]..[index] = message;
    _notify();
  }

  // ── Loading ───────────────────────────────────────────────────────────

  Future<void> _loadFirstPage() async {
    final account = this.account;
    if (account == null) return;
    final generation = ++_generation;
    loading = true;
    error = null;
    _notify();
    try {
      final page = await client.messages(account.id, folder);
      if (generation != _generation) return;
      messages = page.items;
      _cursor = page.cursor;
      hasMore = page.hasMore;
    } on ApiException catch (e) {
      if (generation != _generation) return;
      error = e;
    } finally {
      if (generation == _generation) {
        loading = false;
        _notify();
      }
    }
  }

  /// Fetches the newest page and merges it in at the top, keeping whatever
  /// older pages were already scrolled through.
  Future<void> _mergeNewest() async {
    final account = this.account;
    if (account == null) return;
    final generation = _generation;
    try {
      final page = await client.messages(account.id, folder);
      if (generation != _generation) return;
      final fresh = {for (final m in page.items) m.id};
      messages = [
        ...page.items,
        ...messages.where((m) => !fresh.contains(m.id)),
      ]..sort(_newestFirst);
      _notify();
    } on ApiException {
      // The next event or pull-to-refresh catches up.
    }
  }

  // ── Live events ───────────────────────────────────────────────────────

  void _listen() {
    unawaited(_events?.cancel());
    final account = this.account;
    if (account == null) return;
    live = LiveStatus.connecting;
    _events = client
        .events(
          account.id,
          onLiveChanged: (up) {
            live = up ? LiveStatus.live : LiveStatus.offline;
            _notify();
          },
        )
        .listen(
          _onEvent,
          // Only a session that cannot be renewed ends the stream, and the
          // app state signs out for that.
          onError: (Object _) {
            live = LiveStatus.offline;
            _notify();
          },
        );
  }

  void _onEvent(MailEvent event) {
    switch (event.type) {
      case MailEventType.newMessage:
        if (event.folder == folder) unawaited(_mergeNewest());
        unawaited(refreshFolders());
      case MailEventType.messageUpdated:
        _applyUpdate(event);
      case MailEventType.messageDeleted:
        final before = messages.length;
        messages = messages.where((m) => m.id != event.messageId).toList();
        if (messages.length != before) _notify();
        unawaited(refreshFolders());
      case MailEventType.folderUpdate:
        unawaited(refreshFolders());
    }
  }

  void _applyUpdate(MailEvent event) {
    final index = messages.indexWhere((m) => m.id == event.messageId);
    final movedTo = event.folder;
    if (index < 0) {
      // Moved into the folder on screen from somewhere else.
      if (movedTo == folder) unawaited(_mergeNewest());
      return;
    }
    if (movedTo != null && movedTo != folder) {
      messages = [...messages]..removeAt(index);
    } else {
      final data = event.data;
      messages = [...messages]
        ..[index] = messages[index].copyWith(
          isRead: data['is_read'] as bool?,
          isFlagged: data['is_flagged'] as bool?,
          isStarred: data['is_starred'] as bool?,
        );
    }
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_events?.cancel());
    super.dispose();
  }
}

int _newestFirst(Message a, Message b) => b.receivedAt.compareTo(a.receivedAt);

/// rest-mail's own folders first, in the usual order, then the user's.
List<Folder> sortFolders(List<Folder> folders) {
  int rank(Folder f) {
    final index = StandardFolder.ordered.indexOf(f.name);
    return index < 0 ? StandardFolder.ordered.length : index;
  }

  return [...folders]..sort((a, b) {
    final byRank = rank(a).compareTo(rank(b));
    return byRank != 0
        ? byRank
        : a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
}

/// What a folder is called on screen. rest-mail's names are already words,
/// except the inbox, which IMAP heritage spells in capitals.
String folderLabel(String name) =>
    name == StandardFolder.inbox ? 'Inbox' : name;
