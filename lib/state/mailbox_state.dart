import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restmail_api/restmail_api.dart';

import '../imap/imap_backend.dart' show allMail;
import 'mail_backend.dart';

enum LiveStatus { connecting, live, offline }

/// One signed-in session's mail: its accounts, the folder on screen and the
/// messages in it, kept current by the server's event stream.
class MailboxState extends ChangeNotifier {
  MailboxState(this.backend);

  final MailBackend backend;

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

  /// The list's rows: a message each, or where the backend groups threads
  /// (Gmail), a conversation each, its newest message first.
  List<List<Message>> get conversations => backend.groupsThreads
      ? groupThreads(messages)
      : [
          for (final m in messages) [m],
        ];

  Future<void> start() async {
    try {
      accounts = await backend.accounts();
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
    accounts = await backend.accounts();
    if (!accounts.any((a) => a.id == account?.id) && accounts.isNotEmpty) {
      await selectAccount(accounts.first);
    }
    _notify();
  }

  /// Puts [next] on screen, at [folder].
  Future<void> selectAccount(
    Account next, {
    String folder = StandardFolder.inbox,
  }) async {
    if (next.id == account?.id) return selectFolder(folder);
    account = next;
    this.folder = folder;
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
      final fresh = await backend.folders(account.id);
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
      final page = await backend.messages(account.id, folder, cursor: cursor);
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
    () => backend.updateMessage(message.id, isRead: read),
  );

  Future<void> setFlagged(Message message, bool flagged) => _change(
    message,
    message.copyWith(isFlagged: flagged),
    () => backend.updateMessage(message.id, isFlagged: flagged),
  );

  /// Moves [message], and [others] from its conversation with it.
  Future<void> move(
    Message message,
    String to, {
    List<Message> others = const [],
  }) => _remove([
    message,
    ...others,
  ], (m) => backend.updateMessage(m.id, folder: to));

  /// To Trash, or gone for good if it is already there; [others] from its
  /// conversation too.
  Future<void> delete(Message message, {List<Message> others = const []}) =>
      _remove([message, ...others], (m) => backend.deleteMessage(m.id));

  /// Puts labels on and takes them off (Gmail), [others] from its
  /// conversation's too. Taking off the label of the folder on screen takes
  /// them out of it, and [undoRemoval] puts it back on.
  Future<void> setLabels(
    Message message, {
    Set<String> add = const {},
    Set<String> remove = const {},
    List<Message> others = const [],
  }) async {
    Future<Message> call(Message m) =>
        backend.updateLabels(m.id, add: add, remove: remove);
    final all = [message, ...others];
    if (message.folder == folder && remove.contains(folder)) {
      return _remove(all, call);
    }
    for (final m in all) {
      final labels = {...m.labels, ...add}..removeAll(remove);
      await _change(m, m.copyWith(labels: [...labels]), () => call(m));
    }
  }

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
    await backend.updateMessage(original.id, folder: original.folder);
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

  /// Takes [removed] out of the list at once, a conversation's row
  /// whole, then [call]s the server for each, putting back any it refuses.
  Future<void> _remove(
    List<Message> removed,
    Future<Object?> Function(Message message) call,
  ) async {
    final ids = {for (final m in removed) m.id};
    final shown = {
      for (final m in messages)
        if (ids.contains(m.id)) m.id,
    };
    if (shown.isNotEmpty) {
      messages = messages.where((m) => !ids.contains(m.id)).toList();
      _notify();
    }
    ApiException? refused;
    for (final message in removed) {
      try {
        await call(message);
      } on ApiException catch (e) {
        refused ??= e;
        if (shown.contains(message.id)) restore(message);
      }
    }
    if (refused != null) throw refused;
    unawaited(refreshFolders());
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
      final page = await backend.messages(account.id, folder);
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
      final page = await backend.messages(account.id, folder);
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
    _events = backend
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

/// [messages], newest first, as conversations: those sharing a
/// [Message.threadId] together, in the order their newest came.
List<List<Message>> groupThreads(List<Message> messages) {
  final byThread = <String, List<Message>>{};
  final rows = <List<Message>>[];
  for (final m in messages) {
    final thread = m.threadId;
    if (thread == null) {
      rows.add([m]);
    } else if (byThread[thread] case final row?) {
      row.add(m);
    } else {
      rows.add(byThread[thread] = [m]);
    }
  }
  return rows;
}

/// How many messages an account holds: its folders' counts added up. Where
/// an All Mail folder holds every message but the spam and the bin (Gmail,
/// and other servers' `\All`), the rest are in it already, so it is All Mail,
/// Spam and Trash alone, and a message is counted once.
int accountTotal(List<Folder> folders) {
  final all = folders.where((f) => f.name == allMail).firstOrNull;
  if (all == null) return folders.fold(0, (sum, f) => sum + f.total);
  return all.total +
      folders
          .where(
            (f) =>
                f.name == StandardFolder.spam || f.name == StandardFolder.trash,
          )
          .fold(0, (sum, f) => sum + f.total);
}

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
