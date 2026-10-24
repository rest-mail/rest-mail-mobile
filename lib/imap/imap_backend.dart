import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:enough_mail/enough_mail.dart' hide MailEvent, MailEventType;
import 'package:restmail_api/restmail_api.dart';

import '../state/mail_backend.dart';
import 'mail_connection.dart';
import 'mail_settings.dart';

/// A mailbox at an IMAP provider (Gmail, iCloud, Fastmail, anyone), read
/// over IMAP and sent through SMTP, both over TLS.
///
/// The screens see rest-mail's shapes, so this maps onto them:
/// - **Folders** with a SPECIAL-USE flag (RFC 6154) take rest-mail's names,
///   so Gmail's `[Gmail]/Sent Mail` and a German `Gesendet` are both "Sent".
///   The rest keep their own.
/// - **Ids:** a message is its folder, UIDVALIDITY and UID. The folder and
///   UIDVALIDITY get a number of their own, kept for as long as this backend
///   lives, and an id is that number above the UID's 32 bits. A message that
///   moves gets a new UID; its old id is kept pointing at it, so Undo works.
/// - **Failures** are [ApiException]s, as from the REST API.
/// - **Gmail** (anything offering `X-GM-EXT-1`, so Google Workspace too)
///   is Gmail rather than a folder tree: messages carry labels, archiving
///   takes a message out of the inbox, deleting puts it in Trash, the list
///   shows conversations by `X-GM-THRID`, and search speaks Gmail's syntax.
class ImapBackend implements MailBackend {
  ImapBackend({
    required this.address,
    required this.displayName,
    this.password,
    this.accessToken,
    required this.settings,
    required this.openSocket,
    bool signedOut = false,
  }) : assert(signedOut || (password == null) != (accessToken == null));

  final String address;
  final String displayName;

  /// What IMAP and SMTP sign in with: the password, or for an account
  /// signed in with Microsoft or Google, an access token (XOAUTH2).
  final String? password;
  final AccessToken? accessToken;

  final MailServerSettings settings;
  final OpenMailSocket openSocket;

  /// An IMAP account is a single mailbox.
  static const accountId = 1;

  static const pageSize = 50;

  /// Messages up to this size are fetched whole when opened; above it only
  /// their text, and attachments when they are opened.
  static const _wholeMessageLimit = 256 * 1024;

  @override
  String get host => settings.imapHost;

  // IMAP does not say which server software it runs.
  @override
  Future<ServerDescription?> describeServer() async => null;

  // ── Connection ────────────────────────────────────────────────────────

  ImapConnection? _connection;
  DateTime _lastUsed = DateTime.now();

  /// Whether the server is Gmail, as its capabilities said on the last
  /// connection.
  bool _gmail = false;
  Future<void> _queue = Future.value();
  bool _closed = false;

  /// The folder selected on [_connection], as SELECT described it.
  Mailbox? _selected;

  /// Runs [action] on the connection, one at a time: IMAP has one selected
  /// folder per connection, so actions can't interleave.
  Future<T> _run<T>(Future<T> Function(ImapConnection c) action) {
    final result = _queue.then((_) async => action(await _connect()));
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<ImapConnection> _connect() async {
    if (_closed) {
      throw const ApiException(0, 'closed', 'This account is signed out.');
    }
    var c = _connection;
    // A connection left alone for a while may have died without saying so
    // (the phone slept, a NAT forgot it); a NOOP finds out before anything
    // that matters is sent on it.
    if (c != null &&
        c.isOpen &&
        DateTime.now().difference(_lastUsed) > const Duration(minutes: 2)) {
      try {
        await c.client.noop().timeout(const Duration(seconds: 10));
      } on Object {
        unawaited(c.close());
      }
    }
    if (c == null || !c.isOpen) {
      _selected = null;
      c = _connection = await _open();
      _gmail = c.isGmail;
    }
    _lastUsed = DateTime.now();
    return c;
  }

  Future<ImapConnection> _open() => ImapConnection.open(
    settings,
    address: address,
    password: password,
    accessToken: accessToken,
    openSocket: openSocket,
  );

  Future<SmtpClient> _openSmtp() => openSmtp(
    settings,
    address: address,
    password: password,
    accessToken: accessToken,
    openSocket: openSocket,
  );

  /// Checks the address and password against both servers, as adding the
  /// account does, and keeps the IMAP connection for what comes next.
  Future<void> verify() async {
    await _run((_) async {});
    final smtp = await _openSmtp();
    unawaited(_quit(smtp));
  }

  /// Drops the connections. The next call opens them again; [close] for
  /// good.
  Future<void> disconnect() async {
    final c = _connection;
    _connection = null;
    _selected = null;
    await c?.close();
  }

  Future<void> close() async {
    _closed = true;
    await disconnect();
  }

  Future<Mailbox> _select(
    ImapConnection c,
    MappedFolder folder, {
    bool fresh = false,
  }) async {
    final selected = _selected;
    if (!fresh && selected != null && selected.path == folder.box.path) {
      return selected;
    }
    _selected = null;
    final box = await c.run((client) => client.selectMailbox(folder.box));
    return _selected = box;
  }

  // ── Folders ───────────────────────────────────────────────────────────

  List<MappedFolder>? _folders;
  final _counts = <String, Folder>{};

  Future<List<MappedFolder>> _list(
    ImapConnection c, {
    bool fresh = false,
  }) async {
    final known = _folders;
    if (known != null && !fresh) return known;
    final boxes = await c.run(
      (client) => client.listMailboxes(recursive: true),
    );
    return _folders = mapFolders(
      boxes,
      gmail: c.isGmail,
      important: c.importantFolders,
    );
  }

  Future<MappedFolder> _folderNamed(ImapConnection c, String name) async {
    var found = (await _list(c)).where((f) => f.name == name).firstOrNull;
    found ??= (await _list(
      c,
      fresh: true,
    )).where((f) => f.name == name).firstOrNull;
    if (found == null) {
      throw ApiException(404, 'not_found', 'There is no folder called $name.');
    }
    return found;
  }

  Future<MappedFolder?> _role(ImapConnection c, String name) async =>
      (await _list(c)).where((f) => f.name == name && f.role).firstOrNull;

  /// On Gmail, the folders that are labels: the inbox, Important and the
  /// user's own. All Mail, Sent, Drafts, Spam, Trash and Starred aren't.
  bool _isLabel(MappedFolder f) =>
      _gmail &&
      (!f.role || f.name == StandardFolder.inbox || f.name == gmailImportant);

  @override
  Future<List<Folder>> folders(int accountId) => _run((c) async {
    final folders = await _list(c, fresh: true);
    final result = <Folder>[];
    for (final folder in folders) {
      final status = await c.run(
        (client) => client.statusMailbox(folder.box, [
          StatusFlags.messages,
          StatusFlags.unseen,
        ]),
      );
      result.add(
        _counts[folder.name] = Folder(
          name: folder.name,
          total: status.messagesExists,
          unread: status.messagesUnseen,
          isLabel: _isLabel(folder),
        ),
      );
    }
    return result;
  });

  // ── Ids ───────────────────────────────────────────────────────────────

  final _refs = <(String, int)>[];
  final _movedTo = <int, int>{};

  int _idOf(String path, int uidValidity, int uid) {
    var index = _refs.indexOf((path, uidValidity));
    if (index < 0) {
      _refs.add((path, uidValidity));
      index = _refs.length - 1;
    }
    return ((index + 1) << 32) | uid;
  }

  int _resolve(int id) {
    var current = id;
    for (var hops = 0; hops < 100; hops++) {
      final next = _movedTo[current];
      if (next == null) return current;
      current = next;
    }
    return current;
  }

  /// Where [id] is now: its folder, selected, and its UID there.
  Future<(MappedFolder, int)> _locate(ImapConnection c, int id) async {
    final resolved = _resolve(id);
    final index = (resolved >> 32) - 1;
    if (index < 0 || index >= _refs.length) throw _gone();
    final (path, uidValidity) = _refs[index];
    final folder = (await _list(c))
        .where((f) => f.box.path == path)
        .firstOrNull;
    if (folder == null) throw _gone();
    final box = await _select(c, folder);
    if (box.uidValidity != uidValidity) throw _gone();
    return (folder, resolved & 0xffffffff);
  }

  static ApiException _gone() => const ApiException(
    404,
    'not_found',
    'That message is no longer there. Pull to refresh.',
  );

  // ── Messages ──────────────────────────────────────────────────────────

  static const _listItems =
      '(UID FLAGS INTERNALDATE RFC822.SIZE ENVELOPE BODYSTRUCTURE)';

  /// The same, plus Gmail's message id, conversation and labels.
  static const _gmailItems =
      '(UID FLAGS INTERNALDATE RFC822.SIZE ENVELOPE BODYSTRUCTURE '
      'X-GM-MSGID X-GM-THRID X-GM-LABELS)';

  String get _items => _gmail ? _gmailItems : _listItems;

  /// What Gmail said about each message fetched, beside enough_mail's own.
  final _gmailFetched = Expando<GmailFetch>();

  /// What Gmail said about each message by id: its X-GM-MSGID, which
  /// finds it again in another folder, and its conversation.
  final _gmailOf = <int, GmailFetch>{};

  /// The id and folder each Gmail message was last listed under outside All
  /// Mail, by X-GM-MSGID, so a conversation names the messages the list
  /// has rather than their All Mail selves.
  final _listedAs = <String, (int, String)>{};

  /// Messages as the screens last saw them, for answering a change without
  /// fetching the message again.
  final _known = <int, Message>{};
  final _full = <int, MimeMessage>{};

  @override
  Future<Paged<Message>> messages(
    int accountId,
    String folder, {
    String? cursor,
  }) => _run((c) async {
    final f = await _folderNamed(c, folder);
    final box = await _select(c, f, fresh: cursor == null);
    final validity = box.uidValidity ?? 0;
    final exists = box.messagesExists;
    List<MimeMessage> page;
    bool hasMore;
    if (cursor == null) {
      if (exists == 0) return const Paged<Message>([], total: 0);
      final start = max(1, exists - pageSize + 1);
      page = await _fetch(c, MessageSequence.fromRange(start, exists));
      hasMore = start > 1;
    } else {
      final (cursorValidity, lowest) = _parseCursor(cursor);
      if (cursorValidity != validity || lowest <= 1) {
        return const Paged<Message>([]);
      }
      // The sequence number of the oldest message shown so far; the next
      // page ends just below it.
      final at = await c.run(
        (client) => client.searchMessages(searchCriteria: 'UID $lowest'),
      );
      final top = at.matchingSequence?.toList().firstOrNull;
      if (top != null) {
        if (top <= 1) return const Paged<Message>([]);
        final start = max(1, top - pageSize);
        page = await _fetch(c, MessageSequence.fromRange(start, top - 1));
        hasMore = start > 1;
      } else {
        // It went meanwhile: find what is older by UID instead.
        final older = await c.run(
          (client) =>
              client.uidSearchMessages(searchCriteria: 'UID 1:${lowest - 1}'),
        );
        final uids = (older.matchingSequence?.toList() ?? <int>[])..sort();
        final take = uids.sublist(max(0, uids.length - pageSize));
        page = take.isEmpty
            ? const []
            : await _fetch(c, MessageSequence.fromIds(take, isUid: true));
        hasMore = uids.length > take.length;
      }
    }
    final items = [
      for (final m in page)
        if (m.uid != null && !m.isDeleted) _toMessage(m, f, validity),
    ]..sort((a, b) => b.id.compareTo(a.id));
    final lowestUid = items.isEmpty ? null : items.last.id & 0xffffffff;
    return Paged(
      items,
      cursor: hasMore && lowestUid != null ? '$validity:$lowestUid' : null,
      hasMore: hasMore && lowestUid != null,
      total: exists,
    );
  });

  Future<List<MimeMessage>> _fetch(
    ImapConnection c,
    MessageSequence sequence,
  ) async {
    c.takeGmail();
    final items = _items;
    final result = await c.run(
      (client) => sequence.isUidSequence
          ? client.uidFetchMessages(sequence, items)
          : client.fetchMessages(sequence, items),
    );
    _keepGmail(c, result.messages);
    return result.messages;
  }

  void _keepGmail(ImapConnection c, List<MimeMessage> messages) {
    final gmail = c.takeGmail();
    for (final m in messages) {
      if (gmail[m.sequenceId] case final found?) _gmailFetched[m] = found;
    }
  }

  static (int, int) _parseCursor(String cursor) {
    final parts = cursor.split(':');
    return (
      int.tryParse(parts.first) ?? -1,
      int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
    );
  }

  @override
  Future<Message> message(int id) => _run((c) async {
    final (folder, uid) = await _locate(c, id);
    final sequence = MessageSequence.fromId(uid, isUid: true);
    final head = await _fetch(c, sequence);
    final summary = head.firstOrNull;
    if (summary == null) throw _gone();
    MimeMessage full;
    if ((summary.size ?? 0) <= _wholeMessageLimit || summary.body == null) {
      final result = await c.run(
        (client) => client.uidFetchMessages(
          sequence,
          '(UID FLAGS INTERNALDATE RFC822.SIZE ENVELOPE BODY.PEEK[])',
        ),
      );
      full = result.messages.firstOrNull ?? summary;
    } else {
      // A big one: its text only. Attachments come when they are opened.
      final texts = <ContentInfo>[];
      summary.body!.collectContentInfo(
        ContentDisposition.attachment,
        texts,
        reverse: true,
      );
      final parts = [
        for (final info in texts)
          if (info.mediaType?.top == MediaToptype.text)
            'BODY.PEEK[${info.fetchId}]',
      ];
      full = summary;
      if (parts.isNotEmpty) {
        final result = await c.run(
          (client) => client.uidFetchMessages(
            sequence,
            '(BODY.PEEK[HEADER] ${parts.join(' ')})',
          ),
        );
        final fetched = result.messages.firstOrNull;
        if (fetched != null) {
          full
            ..headers = fetched.headers
            ..copyIndividualParts(fetched);
        }
      }
    }
    _gmailFetched[full] = _gmailFetched[summary];
    full
      ..uid = uid
      ..flags = summary.flags
      ..internalDate = summary.internalDate
      ..size = summary.size
      ..envelope ??= summary.envelope
      ..body ??= summary.body;
    final validity = _selected?.uidValidity ?? 0;
    final resolved = _idOf(folder.box.path, validity, uid);
    _remember(_full, resolved, full);
    final mapped = _toMessage(full, folder, validity, withBody: true);
    return id == resolved ? mapped : _withId(mapped, id);
  });

  void _remember<T>(Map<int, T> cache, int id, T value) {
    cache.remove(id);
    cache[id] = value;
    if (cache.length > 40) cache.remove(cache.keys.first);
  }

  Message _toMessage(
    MimeMessage m,
    MappedFolder folder,
    int uidValidity, {
    bool withBody = false,
  }) {
    final envelope = m.envelope;
    final from = envelope?.from?.firstOrNull ?? m.from?.firstOrNull;
    List<Recipient> recipients(List<MailAddress>? list) => [
      for (final a in list ?? const <MailAddress>[])
        Recipient(a.email, _nonEmpty(a.personalName)),
    ];
    final html = withBody ? m.decodeTextHtmlPart() : null;
    var text = withBody ? m.decodeTextPlainPart() : null;
    if (withBody && text == null && html == null) {
      text = m.decodeContentText();
    }
    final id = _idOf(folder.box.path, uidValidity, m.uid!);
    final gmail = _gmailFetched[m];
    if (gmail != null) {
      _gmailOf[id] = gmail;
      final gmailId = gmail.messageId;
      if (gmailId != null && folder.name != allMail) {
        _listedAs[gmailId] = (id, folder.name);
      }
    }
    final message = Message(
      id: id,
      mailboxId: accountId,
      folder: folder.name,
      messageId: _nonEmpty(
        envelope?.messageId ?? m.getHeaderValue('message-id'),
      ),
      inReplyTo: _nonEmpty(
        envelope?.inReplyTo ?? m.getHeaderValue('in-reply-to'),
      ),
      references: _nonEmpty(m.getHeaderValue('references')),
      threadId: gmail?.threadId,
      sender: from?.email ?? '',
      senderName: _nonEmpty(from?.personalName),
      to: recipients(envelope?.to ?? m.to),
      cc: recipients(envelope?.cc ?? m.cc),
      subject: envelope?.subject ?? m.decodeSubject() ?? '',
      bodyText: text,
      bodyHtml: html,
      sizeBytes: m.size ?? 0,
      hasAttachments: (m.body != null || withBody) && m.hasAttachments(),
      isRead: m.isSeen,
      isFlagged: m.isFlagged,
      isStarred: m.isFlagged,
      isDraft: m.hasFlag(MessageFlags.draft),
      receivedAt:
          parseInternalDate(m.internalDate) ??
          envelope?.date ??
          m.decodeDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      dateHeader: envelope?.date ?? m.decodeDate(),
      labels: gmail == null ? const [] : _labelsOf(gmail.labels, folder),
    );
    _remember(_known, message.id, message);
    return message;
  }

  /// A message's Gmail labels as folder names, in the folder list's order.
  /// Gmail leaves the label of the folder being read out of X-GM-LABELS,
  /// so that one is added back.
  List<String> _labelsOf(List<String>? labels, MappedFolder from) {
    final names = {
      if (_isLabel(from)) from.name,
      for (final label in labels ?? const <String>[])
        if (_folderOf(label) case final f? when _isLabel(f)) f.name,
    };
    return [
      for (final f in _folders ?? const <MappedFolder>[])
        if (names.contains(f.name)) f.name,
    ];
  }

  /// The folder a Gmail label shows as: Gmail's own (`\Inbox`) by role,
  /// the user's by path.
  MappedFolder? _folderOf(String label) {
    final folders = _folders ?? const <MappedFolder>[];
    final role = switch (label.toLowerCase()) {
      r'\inbox' => StandardFolder.inbox,
      r'\important' => gmailImportant,
      r'\starred' => gmailStarred,
      r'\sent' => StandardFolder.sent,
      r'\draft' => StandardFolder.drafts,
      r'\spam' => StandardFolder.spam,
      r'\trash' => StandardFolder.trash,
      _ => null,
    };
    return role != null
        ? folders.where((f) => f.role && f.name == role).firstOrNull
        : folders
              .where((f) => !f.role && unquote(f.box.encodedPath) == label)
              .firstOrNull;
  }

  /// The Gmail label a folder stands for.
  static String _labelOf(MappedFolder f) => switch (f.role ? f.name : null) {
    StandardFolder.inbox => r'\Inbox',
    gmailImportant => r'\Important',
    gmailStarred => r'\Starred',
    StandardFolder.sent => r'\Sent',
    StandardFolder.drafts => r'\Draft',
    StandardFolder.spam => r'\Spam',
    StandardFolder.trash => r'\Trash',
    _ => unquote(f.box.encodedPath),
  };

  static Message _withId(Message m, int id, {String? folder}) => Message(
    id: id,
    mailboxId: m.mailboxId,
    folder: folder ?? m.folder,
    messageId: m.messageId,
    inReplyTo: m.inReplyTo,
    references: m.references,
    threadId: m.threadId,
    sender: m.sender,
    senderName: m.senderName,
    to: m.to,
    cc: m.cc,
    subject: m.subject,
    bodyText: m.bodyText,
    bodyHtml: m.bodyHtml,
    sizeBytes: m.sizeBytes,
    hasAttachments: m.hasAttachments,
    isRead: m.isRead,
    isFlagged: m.isFlagged,
    isStarred: m.isStarred,
    isDraft: m.isDraft,
    receivedAt: m.receivedAt,
    dateHeader: m.dateHeader,
    labels: m.labels,
  );

  // ── Changes ───────────────────────────────────────────────────────────

  @override
  Future<Message> updateMessage(
    int id, {
    bool? isRead,
    bool? isFlagged,
    String? folder,
  }) => _run((c) async {
    final (from, uid) = await _locate(c, id);
    final sequence = MessageSequence.fromId(uid, isUid: true);
    Future<void> flag(String flag, bool on) => c.run(
      (client) => client.uidStore(
        sequence,
        [flag],
        action: on ? StoreAction.add : StoreAction.remove,
        silent: true,
      ),
    );
    if (isRead != null) await flag(MessageFlags.seen, isRead);
    if (isFlagged != null) await flag(MessageFlags.flagged, isFlagged);
    final known = _known[_resolve(id)];
    var result = known?.copyWith(isRead: isRead, isFlagged: isFlagged);
    if (folder != null && folder != from.name) {
      if (_gmail && folder == StandardFolder.archive) {
        // Gmail has no Archive folder: archiving takes the Inbox label
        // off, and the message stays in All Mail with any others.
        final left = await _relabel(c, id, from, uid, remove: {r'\Inbox'});
        result = result?.copyWith(
          folder: left?.name,
          labels: [...result.labels]..remove(StandardFolder.inbox),
        );
      } else {
        final to = await _folderNamed(c, folder);
        await _move(c, id, from, uid, to, messageId: known?.messageId);
        result = result?.copyWith(folder: to.name);
      }
    }
    return result == null ? await _summary(c, id) : _withId(result, id);
  });

  @override
  bool get hasLabels => _gmail;

  @override
  Future<Message> updateLabels(
    int id, {
    Set<String> add = const {},
    Set<String> remove = const {},
  }) => _run((c) async {
    if (!_gmail) {
      throw const ApiException(
        400,
        'not_supported',
        'This account has folders, not labels.',
      );
    }
    final before = _known[_resolve(id)] ?? await _summary(c, id);
    Future<Set<String>> labels(Set<String> names) async => {
      for (final name in names) _labelOf(await _folderNamed(c, name)),
    };
    final adding = await labels(add), removing = await labels(remove);
    final (from, uid) = await _locate(c, id);
    final left = await _relabel(
      c,
      id,
      from,
      uid,
      add: adding,
      remove: removing,
    );
    final now = {...before.labels, ...add}..removeAll(remove);
    return _withId(
      before.copyWith(
        folder: left?.name,
        labels: [
          for (final f in _folders ?? const <MappedFolder>[])
            if (now.contains(f.name)) f.name,
        ],
      ),
      id,
    );
  });

  /// Puts Gmail labels on and takes them off. Taking off the label of the
  /// folder the message was found in takes it out of that folder, so [id]
  /// is pointed at it in All Mail, which is returned.
  Future<MappedFolder?> _relabel(
    ImapConnection c,
    int id,
    MappedFolder from,
    int uid, {
    Set<String> add = const {},
    Set<String> remove = const {},
  }) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    if (add.isNotEmpty) {
      await c.storeLabels(sequence, [...add], add: true);
    }
    if (remove.isNotEmpty) {
      await c.storeLabels(sequence, [...remove], add: false);
    }
    c.takeGmail();
    if (!_isLabel(from) || !remove.contains(_labelOf(from))) return null;
    final all = await _role(c, allMail);
    final gmailId = _gmailOf[_resolve(id)]?.messageId;
    if (all == null || gmailId == null) return null;
    final moved = await _findByGmailId(c, all, gmailId);
    if (moved != null) _follow(id, moved, all);
    return all;
  }

  /// Points [id] at where its message is now.
  void _follow(int id, int moved, MappedFolder to) {
    final before = _resolve(id);
    if (before == moved) return;
    final known = _known[before];
    if (known != null) {
      _remember(_known, moved, known.copyWith(folder: to.name));
    }
    if (_gmailOf[before] case final gmail?) _gmailOf[moved] = gmail;
    // It is at [moved] now, whatever was there before: back where it
    // started, after Undo, the old pointer would go round in a circle.
    _movedTo
      ..remove(moved)
      ..[before] = moved;
  }

  Future<int?> _findByGmailId(
    ImapConnection c,
    MappedFolder folder,
    String gmailId,
  ) async {
    final box = await _select(c, folder, fresh: true);
    final found = await c.run(
      (client) =>
          client.uidSearchMessages(searchCriteria: 'X-GM-MSGID $gmailId'),
    );
    final uids = found.matchingSequence?.toList() ?? const <int>[];
    if (uids.isEmpty) return null;
    return _idOf(folder.box.path, box.uidValidity ?? 0, uids.reduce(max));
  }

  @override
  Future<void> deleteMessage(int id) => _run((c) async {
    final (folder, uid) = await _locate(c, id);
    if (folder.name == StandardFolder.trash) {
      await _expunge(c, uid);
      return;
    }
    final trash = await _role(c, StandardFolder.trash);
    if (trash == null) {
      throw const ApiException(
        409,
        'no_trash',
        'This account has no Trash folder, so the message was left where '
            'it is.',
      );
    }
    await _move(c, id, folder, uid, trash, messageId: _known[id]?.messageId);
  });

  /// Moves a message with MOVE, or COPY and EXPUNGE where the server has no
  /// MOVE, and points [id] at where it went.
  ///
  /// On Gmail, MOVE between labels swaps one for the other, and to Trash or
  /// Spam it trashes or reports the message, as in Gmail. Out of All Mail,
  /// which isn't a label, the new label is put on instead: an EXPUNGE there
  /// could delete it.
  Future<void> _move(
    ImapConnection c,
    int id,
    MappedFolder from,
    int uid,
    MappedFolder to, {
    String? messageId,
  }) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    final gmailId = _gmailOf[_resolve(id)]?.messageId;
    if (_gmail && from.name == allMail && gmailId != null) {
      await c.storeLabels(sequence, [_labelOf(to)], add: true);
      c.takeGmail();
      final moved = await _findByGmailId(c, to, gmailId);
      if (moved != null) _follow(id, moved, to);
      return;
    }
    final GenericImapResult result;
    if (c.server.supportsMove) {
      result = await c.run(
        (client) => client.uidMove(sequence, targetMailbox: to.box),
      );
    } else {
      result = await c.run(
        (client) => client.uidCopy(sequence, targetMailbox: to.box),
      );
      await _expunge(c, uid);
    }
    final copied = result.responseCodeCopyUid;
    final newUid = copied?.targetSequence.toList().firstOrNull;
    int? moved;
    if (copied != null && newUid != null) {
      moved = _idOf(to.box.path, copied.uidValidity, newUid);
    } else if (_gmail && gmailId != null) {
      moved = await _findByGmailId(c, to, gmailId);
    } else if (messageId != null) {
      // No COPYUID (no UIDPLUS): find it by its Message-ID instead.
      moved = await _findByMessageId(c, to, messageId);
    }
    if (moved != null) _follow(id, moved, to);
  }

  /// Removes a message for good. On Gmail an EXPUNGE outside Trash only
  /// takes a label off, and the message lives on in All Mail, so there it
  /// goes to Trash first and is expunged from there.
  Future<void> _destroy(ImapConnection c, MappedFolder folder, int uid) async {
    final trash = _gmail && folder.name != StandardFolder.trash
        ? await _role(c, StandardFolder.trash)
        : null;
    if (trash == null) return _expunge(c, uid);
    final result = await c.run(
      (client) => client.uidMove(
        MessageSequence.fromId(uid, isUid: true),
        targetMailbox: trash.box,
      ),
    );
    final copied = result.responseCodeCopyUid;
    final inTrash = copied?.targetSequence.toList().firstOrNull;
    // Without COPYUID it waits in Trash, which Gmail empties after 30 days.
    if (inTrash == null) return;
    final box = await _select(c, trash);
    if (box.uidValidity == copied!.uidValidity) await _expunge(c, inTrash);
  }

  Future<void> _expunge(ImapConnection c, int uid) async {
    final sequence = MessageSequence.fromId(uid, isUid: true);
    await c.run(
      (client) => client.uidStore(
        sequence,
        [MessageFlags.deleted],
        action: StoreAction.add,
        silent: true,
      ),
    );
    if (c.server.supportsUidPlus) {
      await c.run((client) => client.uidExpunge(sequence));
    } else {
      await c.run((client) => client.expunge());
    }
  }

  Future<int?> _findByMessageId(
    ImapConnection c,
    MappedFolder folder,
    String messageId,
  ) async {
    final box = await _select(c, folder);
    final found = await c.run(
      (client) => client.uidSearchMessages(
        searchCriteria: 'HEADER Message-ID ${_quote(messageId)}',
      ),
    );
    final uids = found.matchingSequence?.toList() ?? const <int>[];
    if (uids.isEmpty) return null;
    return _idOf(folder.box.path, box.uidValidity ?? 0, uids.reduce(max));
  }

  Future<Message> _summary(ImapConnection c, int id) async {
    final (folder, uid) = await _locate(c, id);
    final found = await _fetch(c, MessageSequence.fromId(uid, isUid: true));
    final m = found.firstOrNull;
    if (m == null) throw _gone();
    final mapped = _toMessage(m, folder, _selected?.uidValidity ?? 0);
    return mapped.id == id ? mapped : _withId(mapped, id);
  }

  // ── Search ────────────────────────────────────────────────────────────

  @override
  Future<Paged<Message>> search(
    int accountId,
    SearchQuery query, {
    String? cursor,
  }) => _run((c) async {
    // One folder per search: the one asked for, else everything where the
    // server has an All Mail (Gmail does), else the inbox. Gmail reads the
    // search as typed (`X-GM-RAW`), `in:` and `label:` included, in All
    // Mail, except in Trash and Spam, which All Mail leaves out.
    final named = query.folder;
    final typed = query.raw?.trim();
    final raw = typed == null || typed.isEmpty ? null : typed;
    final MappedFolder folder;
    if (_gmail && raw != null) {
      folder =
          (named == StandardFolder.trash || named == StandardFolder.spam
              ? await _role(c, named!)
              : null) ??
          await _role(c, allMail) ??
          await _folderNamed(c, StandardFolder.inbox);
    } else {
      folder = named != null
          ? await _folderNamed(c, named)
          : await _role(c, allMail) ??
                await _folderNamed(c, StandardFolder.inbox);
    }
    final box = await _select(c, folder, fresh: true);
    final criteria = _gmail && raw != null
        ? gmailSearchCriteria(raw)
        : searchCriteria(query);
    final found = await c.run(
      (client) => client.uidSearchMessages(searchCriteria: criteria),
    );
    final uids = (found.matchingSequence?.toList() ?? <int>[])..sort();
    final take = uids.sublist(max(0, uids.length - pageSize));
    if (take.isEmpty) return Paged<Message>(const [], total: uids.length);
    final page = await _fetch(c, MessageSequence.fromIds(take, isUid: true));
    final items = [
      for (final m in page)
        if (m.uid != null) _toMessage(m, folder, box.uidValidity ?? 0),
    ]..sort((a, b) => b.id.compareTo(a.id));
    return Paged(items, total: uids.length);
  });

  // ── Conversations ─────────────────────────────────────────────────────

  @override
  bool get groupsThreads => _gmail;

  @override
  Future<List<Message>> conversation(int id) => _run((c) async {
    final resolved = _resolve(id);
    final opened = _known[resolved] ?? await _summary(c, id);
    final thread = _gmailOf[resolved]?.threadId;
    final all = _gmail ? await _role(c, allMail) : null;
    if (thread == null || all == null) return [opened];
    final mine = _gmailOf[resolved]?.messageId;
    final box = await _select(c, all, fresh: true);
    final found = await c.run(
      (client) =>
          client.uidSearchMessages(searchCriteria: 'X-GM-THRID $thread'),
    );
    final uids = (found.matchingSequence?.toList() ?? <int>[])..sort();
    final take = uids.sublist(max(0, uids.length - pageSize));
    if (take.isEmpty) return [opened];
    final page = await _fetch(c, MessageSequence.fromIds(take, isUid: true));
    final items = <Message>[];
    for (final m in page) {
      if (m.uid == null) continue;
      final gmailId = _gmailFetched[m]?.messageId;
      final listed = gmailId != null && gmailId == mine
          ? (id, opened.folder)
          : _listedAs[gmailId];
      final mapped = _toMessage(m, all, box.uidValidity ?? 0);
      items.add(
        listed == null ? mapped : _withId(mapped, listed.$1, folder: listed.$2),
      );
    }
    if (!items.any((m) => m.id == id)) items.add(opened);
    return items..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));
  });

  // ── Sending and drafts ────────────────────────────────────────────────

  @override
  bool get canScheduleSend => false;

  @override
  Future<ScheduledSend> schedule(OutgoingMessage message, DateTime at) async =>
      throw const ApiException(
        400,
        'not_supported',
        'Send later needs a rest-mail account.',
      );

  @override
  Future<List<ScheduledSend>> scheduledSends() async => const [];

  @override
  Future<void> cancelScheduledSend(int id) async {}

  // IMAP has no quarantine: a provider's spam folder is an ordinary folder.
  @override
  bool get hasQuarantine => false;

  @override
  Future<OffsetPage<QuarantinedMessage>> quarantine(
    int accountId, {
    int offset = 0,
  }) async => OffsetPage(const [], offset: offset, total: 0);

  @override
  Future<int> releaseQuarantined(int accountId, int id) =>
      throw const ApiException(400, 'not_supported', 'IMAP has no quarantine.');

  @override
  Future<void> deleteQuarantined(int accountId, int id) =>
      throw const ApiException(400, 'not_supported', 'IMAP has no quarantine.');

  // Folders are made, renamed and deleted with IMAP's CREATE, RENAME and
  // DELETE (RFC 9051 §6.3.4–6.3.6), refused as REST Mail refuses them: a
  // standard folder stays as it is, and a name that is taken is 409. Gmail's
  // folders are labels, whose deletion keeps the mail, so they are not
  // offered here yet.
  @override
  bool get canManageFolders => !_gmail;

  @override
  Future<String> createFolder(int accountId, String name) => _run((c) async {
    final folders = await _list(c, fresh: true);
    final path = _pathFor(folders, name);
    if (_taken(folders, name, path)) throw _folderExists;
    try {
      await c.run((client) => client.createMailbox(path));
    } on ApiException {
      // enough_mail lists the new mailbox to return it, and a server may not
      // answer that LIST as it expects even though the CREATE worked.
      if (!(await _list(c, fresh: true)).any((f) => f.box.path == path)) {
        rethrow;
      }
    }
    _folders = null;
    return path;
  });

  @override
  Future<String> renameFolder(int accountId, String folder, String name) =>
      _run((c) async {
        final folders = await _list(c, fresh: true);
        final from = _ownFolder(folders, folder, 'rename');
        if (_isStandardName(name)) {
          throw const ApiException(
            400,
            'bad_request',
            'Cannot rename a folder to a standard folder',
          );
        }
        final path = _pathFor(folders, name);
        if (_taken(folders, name, path)) throw _folderExists;
        await _leave(c, folders, from);
        await c.run((client) => client.renameMailbox(from.box, path));
        _folders = null;
        return path;
      });

  @override
  Future<void> deleteFolder(int accountId, String folder) => _run((c) async {
    final folders = await _list(c, fresh: true);
    final target = _ownFolder(folders, folder, 'delete');
    await _leave(c, folders, target);
    await c.run((client) => client.deleteMailbox(target.box));
    _folders = null;
  });

  static const _folderExists = ApiException(
    409,
    'already_exists',
    'Folder already exists',
  );

  /// The user's own folder called [name], to [verb]: a standard one, or the
  /// inbox, is refused (400), and one that is not there is 404.
  MappedFolder _ownFolder(
    List<MappedFolder> folders,
    String name,
    String verb,
  ) {
    final folder = folders.where((f) => f.name == name).firstOrNull;
    if (folder == null) {
      throw const ApiException(404, 'not_found', 'Folder not found');
    }
    if (folder.role || folder.box.isInbox) {
      throw ApiException(400, 'bad_request', 'Cannot $verb standard folder');
    }
    return folder;
  }

  /// Whether [name] is a standard folder's: INBOX in any case, the others as
  /// written.
  static bool _isStandardName(String name) =>
      name.toUpperCase() == StandardFolder.inbox ||
      StandardFolder.ordered.contains(name);

  /// Whether a folder of that name or path is there already, INBOX in any
  /// case among them.
  static bool _taken(List<MappedFolder> folders, String name, String path) =>
      name.toUpperCase() == StandardFolder.inbox ||
      folders.any((f) => f.name == name || f.box.path == path);

  /// The path a folder the user named goes under: the app shows "/" as the
  /// hierarchy, which is written with the server's own delimiter.
  static String _pathFor(List<MappedFolder> folders, String name) {
    final delimiter =
        folders
            .map((f) => f.box.pathSeparator)
            .where((d) => d.isNotEmpty)
            .firstOrNull ??
        '/';
    return delimiter == '/' ? name : name.replaceAll('/', delimiter);
  }

  /// Steps out of [folder] when it is the one selected, so a server that
  /// refuses to rename or delete a selected mailbox does not. Selecting the
  /// inbox leaves it on any server: UNSELECT is an extension (RFC 3691), and
  /// CLOSE would expunge the folder's deleted messages.
  Future<void> _leave(
    ImapConnection c,
    List<MappedFolder> folders,
    MappedFolder folder,
  ) async {
    if (_selected?.path != folder.box.path) return;
    _selected = null;
    final inbox = folders.where((f) => f.box.isInbox).firstOrNull;
    if (inbox != null) await _select(c, inbox, fresh: true);
  }

  // Not yet over IMAP: the provider's own calendar answers invitations.
  @override
  bool get hasCalendar => false;

  @override
  Future<List<CalendarEventSummary>> calendarEvents(int accountId) async =>
      const [];

  @override
  Future<CalendarResponse> respondToCalendar(
    int messageId, {
    required CalendarResponse response,
    required String from,
  }) => throw const ApiException(
    400,
    'not_supported',
    'Invitations cannot be answered on this account yet.',
  );

  // Not yet over IMAP, whose BODY.PEEK[] is the source.
  @override
  bool get hasMessageSource => false;

  @override
  Future<Uint8List> messageSource(int id) => throw const ApiException(
    400,
    'not_supported',
    'The source of this message cannot be shown yet.',
  );

  // IMAP keeps no contacts: an address book is the provider's own service.
  @override
  bool get hasContacts => false;

  @override
  Future<OffsetPage<Contact>> contacts(
    int accountId, {
    String? search,
    TrustLevel? trustLevel,
    int offset = 0,
  }) async => OffsetPage(const [], offset: offset, total: 0);

  @override
  Future<Contact> createContact(
    int accountId, {
    required String email,
    String? name,
    TrustLevel? trustLevel,
  }) => throw const ApiException(400, 'not_supported', 'IMAP has no contacts.');

  @override
  Future<Contact> updateContact(
    int accountId,
    int contactId, {
    String? name,
    TrustLevel? trustLevel,
  }) => throw const ApiException(400, 'not_supported', 'IMAP has no contacts.');

  @override
  Future<void> deleteContact(int accountId, int contactId) =>
      throw const ApiException(400, 'not_supported', 'IMAP has no contacts.');

  @override
  Future<Contact> blockSender(int accountId, String email) =>
      throw const ApiException(400, 'not_supported', 'IMAP has no contacts.');

  @override
  Future<List<Contact>> suggestContacts(int accountId, String query) async =>
      const [];

  final _drafts = <int, OutgoingMessage>{};

  @override
  Future<Message> send(OutgoingMessage message) async {
    final mime = buildMime(message, displayName: displayName);
    final smtp = await _openSmtp();
    try {
      await smtp
          .sendMessage(mime, from: MailAddress(null, message.from))
          .timeout(const Duration(minutes: 3));
    } on Object catch (e) {
      throw mailException(e, host: settings.smtpHost);
    } finally {
      unawaited(_quit(smtp));
    }
    // Sent now; filing it is a courtesy, and a failure there mustn't look
    // like the message didn't go.
    try {
      return await _run((c) async {
        final sent = await _role(c, StandardFolder.sent);
        if (sent == null) return _outgoing(message, mime, -1);
        final messageId = mime.getHeaderValue('message-id');
        // Gmail files what its SMTP server sends, set up from the preset or
        // by hand, so a second copy is never added.
        final filed = settings.filesSentMail || c.isGmail;
        var id = filed || messageId == null
            ? null
            : await _findByMessageId(c, sent, messageId);
        if (id == null && !filed) {
          id = await _append(c, sent, mime, [MessageFlags.seen]);
        }
        return _outgoing(message, mime, id ?? -1, folder: sent.name);
      });
    } on ApiException {
      return _outgoing(message, mime, -1);
    }
  }

  static Future<void> _quit(SmtpClient smtp) async {
    try {
      await smtp.quit().timeout(const Duration(seconds: 5));
    } on Object {
      // Gone already.
    }
    try {
      await smtp.disconnect();
    } on Object {
      // Gone already.
    }
  }

  Future<int?> _append(
    ImapConnection c,
    MappedFolder folder,
    MimeMessage mime,
    List<String> flags,
  ) async {
    final result = await c.run(
      (client) =>
          client.appendMessage(mime, targetMailbox: folder.box, flags: flags),
    );
    final appended = result.responseCodeAppendUid;
    final uid = appended?.targetSequence.toList().firstOrNull;
    if (appended != null && uid != null) {
      return _idOf(folder.box.path, appended.uidValidity, uid);
    }
    final messageId = mime.getHeaderValue('message-id');
    return messageId == null ? null : _findByMessageId(c, folder, messageId);
  }

  Message _outgoing(
    OutgoingMessage m,
    MimeMessage mime,
    int id, {
    String folder = StandardFolder.sent,
  }) => Message(
    id: id,
    mailboxId: accountId,
    folder: folder,
    messageId: mime.getHeaderValue('message-id'),
    inReplyTo: m.inReplyTo,
    references: m.references,
    sender: m.from,
    senderName: _nonEmpty(displayName),
    to: [for (final a in m.to) Recipient(a)],
    cc: [for (final a in m.cc) Recipient(a)],
    subject: m.subject,
    bodyText: m.bodyText,
    isRead: true,
    isDraft: folder == StandardFolder.drafts,
    receivedAt: DateTime.now(),
  );

  @override
  Future<Message> saveDraft(OutgoingMessage draft) =>
      _run((c) => _saveDraft(c, draft));

  Future<Message> _saveDraft(ImapConnection c, OutgoingMessage draft) async {
    final drafts = await _role(c, StandardFolder.drafts);
    if (drafts == null) {
      throw const ApiException(
        409,
        'no_drafts',
        'This account has no Drafts folder to keep it in.',
      );
    }
    final mime = buildMime(draft, displayName: displayName);
    final id = await _append(c, drafts, mime, [
      MessageFlags.draft,
      MessageFlags.seen,
    ]);
    if (id == null) {
      throw const ApiException(
        502,
        'imap_error',
        'The draft was saved but could not be found again.',
      );
    }
    _remember(_drafts, id, draft);
    return _outgoing(draft, mime, id, folder: drafts.name);
  }

  @override
  Future<Message> updateDraft(int id, OutgoingMessage draft) => _run((c) async {
    final saved = await _saveDraft(c, draft);
    // The old version goes once the new one is safe. A failure here
    // leaves two drafts, not none.
    try {
      final (folder, uid) = await _locate(c, id);
      await _destroy(c, folder, uid);
    } on ApiException {
      // Already gone, or left for the user to delete.
    }
    _movedTo[_resolve(id)] = saved.id;
    return _withId(saved, id);
  });

  @override
  Future<Message> sendDraft(int id) async {
    final resolved = _resolve(id);
    final draft = _drafts[resolved] ?? await _draftFromServer(id);
    final sent = await send(draft);
    try {
      await _run((c) async {
        final (folder, uid) = await _locate(c, id);
        await _destroy(c, folder, uid);
      });
    } on ApiException {
      // Sent; a draft left behind is a nuisance, not a failure.
    }
    _drafts.remove(resolved);
    return sent;
  }

  Future<OutgoingMessage> _draftFromServer(int id) async {
    final m = await message(id);
    return OutgoingMessage(
      from: address,
      to: [for (final r in m.to) r.address],
      cc: [for (final r in m.cc) r.address],
      subject: m.subject,
      bodyText: m.bodyText ?? '',
      inReplyTo: m.inReplyTo,
      references: m.references,
    );
  }

  // ── Attachments ───────────────────────────────────────────────────────

  final _attachmentRefs = <(int, String)>[];

  @override
  Future<List<Attachment>> attachments(int messageId) async {
    final resolved = _resolve(messageId);
    var full = _full[resolved];
    if (full == null) {
      await message(messageId);
      full = _full[_resolve(messageId)];
    }
    if (full == null) return const [];
    return [
      for (final info in full.findContentInfo())
        Attachment(
          id: _attachmentId(messageId, info.fetchId),
          messageId: messageId,
          filename: info.fileName ?? 'attachment',
          contentType: info.mediaType?.text ?? 'application/octet-stream',
          sizeBytes: info.size ?? 0,
        ),
    ];
  }

  int _attachmentId(int messageId, String fetchId) {
    var index = _attachmentRefs.indexOf((messageId, fetchId));
    if (index < 0) {
      _attachmentRefs.add((messageId, fetchId));
      index = _attachmentRefs.length - 1;
    }
    return index + 1;
  }

  @override
  Future<Uint8List> downloadAttachment(int id) => _run((c) async {
    if (id < 1 || id > _attachmentRefs.length) throw _gone();
    final (messageId, fetchId) = _attachmentRefs[id - 1];
    final (_, uid) = await _locate(c, messageId);
    final result = await c.run(
      (client) => client.uidFetchMessages(
        MessageSequence.fromId(uid, isUid: true),
        '(BODY.PEEK[$fetchId])',
      ),
    );
    final part = result.messages.firstOrNull?.getPart(fetchId);
    final bytes = part?.decodeContentBinary();
    if (bytes == null) throw _gone();
    return bytes;
  });

  // ── Account ───────────────────────────────────────────────────────────

  @override
  Future<List<Account>> accounts() async => [
    Account(
      id: accountId,
      address: address,
      displayName: displayName,
      isPrimary: true,
    ),
  ];

  @override
  bool get canLinkMailboxes => false;

  @override
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
    String? totpCode,
    String? recoveryCode,
  }) => throw const ApiException(
    400,
    'not_supported',
    'An IMAP account is one mailbox. Add another as an account of its own.',
  );

  @override
  Future<void> unlinkAccount(int id) => throw const ApiException(
    400,
    'not_supported',
    'An IMAP account has no linked mailboxes.',
  );

  @override
  Future<QuotaInfo> quota(int accountId) => _run((c) async {
    if (!c.server.supports('QUOTA')) {
      throw const ApiException(404, 'not_supported', 'No quota to show.');
    }
    final result = await c.run(
      (client) => client.getQuotaRoot(mailboxName: 'INBOX'),
    );
    final limits = [
      for (final root in result.quotaRoots.values) ...root.resourceLimits,
    ];
    final storage = limits
        .where((l) => l.name.toUpperCase() == 'STORAGE')
        .firstOrNull;
    if (storage == null) {
      throw const ApiException(404, 'not_supported', 'No quota to show.');
    }
    // STORAGE is counted in units of 1024 octets (RFC 9208).
    final used = (storage.currentUsage ?? 0) * 1024;
    final limit = (storage.usageLimit ?? 0) * 1024;
    final count = limits
        .where((l) => l.name.toUpperCase() == 'MESSAGE')
        .firstOrNull
        ?.currentUsage;
    return QuotaInfo(
      quotaBytes: limit,
      usedBytes: used,
      messageCount:
          count ??
          _counts.values
              .where((f) => f.name != allMail)
              .fold(0, (sum, f) => sum + f.total),
      percentUsed: limit > 0 ? used * 100 / limit : 0,
    );
  });

  // ── Live updates ──────────────────────────────────────────────────────

  @override
  Stream<MailEvent> events(
    int accountId, {
    void Function(bool live)? onLiveChanged,
  }) {
    late final StreamController<MailEvent> controller;
    _Watcher? watcher;
    controller = StreamController<MailEvent>(
      onListen: () =>
          watcher = _Watcher(this, controller, onLiveChanged)..start(),
      onCancel: () => watcher?.stop(),
    );
    return controller.stream;
  }
}

/// Keeps a second connection in IDLE on the inbox while the stream has a
/// listener, and turns what the server says into [MailEvent]s. Without IDLE
/// it asks every minute instead. A dropped connection is reopened, waiting
/// longer each time, up to a minute.
class _Watcher {
  _Watcher(this.backend, this.events, this.onLiveChanged);

  final ImapBackend backend;
  final StreamController<MailEvent> events;
  final void Function(bool live)? onLiveChanged;

  final _stop = Completer<void>();
  ImapConnection? _connection;

  bool get _stopped => _stop.isCompleted;

  /// IDLE is renewed well inside the 29 minutes RFC 2177 allows, since some
  /// servers drop it sooner.
  static const _renew = Duration(minutes: 9);

  Future<void> start() async {
    var delay = const Duration(seconds: 2);
    while (!_stopped) {
      StreamSubscription<ImapEvent>? heard;
      try {
        final c = _connection = await backend._open();
        if (_stopped) break;
        await c.run((client) => client.selectInbox());
        heard = c.client.eventBus.on<ImapEvent>().listen(_heard);
        onLiveChanged?.call(true);
        delay = const Duration(seconds: 2);
        final idle = c.server.supportsIdle;
        while (!_stopped && c.isOpen) {
          if (idle) await c.client.idleStart();
          await Future.any<void>([
            Future<void>.delayed(idle ? _renew : const Duration(minutes: 1)),
            c.lost.then<void>((_) {}, onError: (Object _) {}),
            _stop.future,
          ]);
          if (!c.isOpen) break;
          if (idle) {
            await c.client.idleDone();
          } else {
            await c.client.noop();
          }
        }
      } on ApiException catch (e) {
        // A password that no longer works won't start working by asking
        // again every minute, and asking could get the account locked. A
        // sign-in with Microsoft or Google that ended ends the account.
        if (e.statusCode == 401) {
          onLiveChanged?.call(false);
          if (!events.isClosed) events.addError(e);
          break;
        }
      } on Object {
        // Dropped; try again below.
      } finally {
        await heard?.cancel();
      }
      if (_stopped) break;
      onLiveChanged?.call(false);
      unawaited(_connection?.close());
      await Future.any([Future<void>.delayed(delay), _stop.future]);
      delay = delay * 2 > const Duration(minutes: 1)
          ? const Duration(minutes: 1)
          : delay * 2;
    }
    await _connection?.close();
  }

  void _heard(ImapEvent event) {
    if (events.isClosed) return;
    final type = switch (event) {
      ImapMessagesExistEvent(:final newMessagesExists, :final oldMessagesExists)
          when newMessagesExists > oldMessagesExists =>
        MailEventType.newMessage,
      ImapExpungeEvent() ||
      ImapVanishedEvent() ||
      ImapFetchEvent() => MailEventType.folderUpdate,
      _ => null,
    };
    if (type == null) return;
    events.add(
      MailEvent(type: type, data: const {'folder': StandardFolder.inbox}),
    );
  }

  /// Ends the IDLE and closes the connection once [start]'s loop sees it.
  void stop() {
    if (!_stop.isCompleted) _stop.complete();
  }
}

/// The name Gmail's All Mail and other servers' \All folders go by.
const allMail = 'All Mail';

/// Gmail's `\Important` and Starred (`\Flagged`) folders.
const gmailImportant = 'Important';
const gmailStarred = 'Starred';

/// One folder as the screens see it, and the IMAP mailbox behind it.
class MappedFolder {
  const MappedFolder(this.name, this.box, {this.role = false});

  final String name;
  final Mailbox box;

  /// Named for what it is (Sent, Trash, …) rather than what it's called.
  final bool role;
}

/// Names the folders for the screens. Those with a SPECIAL-USE flag take
/// rest-mail's names. On a server with no such flags, a folder whose name
/// is one of the usual ones for its role (Sent Items, Deleted Messages,
/// Junk, …) takes it instead. Every other folder keeps its own path, and
/// one that can't be selected (Gmail's `[Gmail]`) isn't listed.
///
/// On [gmail], Important (its path among [important]) and Starred are
/// named too, and nothing is taken by name: Gmail flags every folder that
/// has a role, so a label called Archive stays a label.
List<MappedFolder> mapFolders(
  List<Mailbox> boxes, {
  bool gmail = false,
  Set<String> important = const {},
}) {
  final selectable = [
    for (final box in boxes)
      if (!box.isNotSelectable && !box.hasFlag(MailboxFlag.nonExistent)) box,
  ];
  final byRole = <String, Mailbox>{};
  void claim(String name, Mailbox box) => byRole.putIfAbsent(name, () => box);
  for (final box in selectable) {
    if (box.path.toUpperCase() == 'INBOX' || box.isInbox) {
      claim(StandardFolder.inbox, box);
    } else if (box.isDrafts) {
      claim(StandardFolder.drafts, box);
    } else if (box.isSent) {
      claim(StandardFolder.sent, box);
    } else if (box.isJunk) {
      claim(StandardFolder.spam, box);
    } else if (box.isTrash) {
      claim(StandardFolder.trash, box);
    } else if (box.isArchive) {
      claim(StandardFolder.archive, box);
    } else if (box.hasFlag(MailboxFlag.all)) {
      claim(allMail, box);
    } else if (gmail && box.hasFlag(MailboxFlag.flagged)) {
      claim(
        important.contains(unquote(box.encodedPath))
            ? gmailImportant
            : gmailStarred,
        box,
      );
    }
  }
  const usual = {
    StandardFolder.drafts: ['drafts', 'draft'],
    StandardFolder.sent: ['sent', 'sent items', 'sent messages', 'sent mail'],
    StandardFolder.spam: ['junk', 'spam', 'junk e-mail', 'junk email'],
    StandardFolder.trash: ['trash', 'deleted items', 'deleted messages', 'bin'],
    StandardFolder.archive: ['archive', 'archives'],
  };
  for (final MapEntry(key: role, value: names) in usual.entries) {
    if (gmail || byRole.containsKey(role)) continue;
    for (final box in selectable) {
      if (byRole.containsValue(box)) continue;
      final leaf = box.name.toLowerCase();
      final path = box.path.toLowerCase();
      if (names.contains(leaf) &&
          (path == leaf || path == 'inbox${box.pathSeparator}$leaf')) {
        claim(role, box);
        break;
      }
    }
  }
  final roleOf = {for (final e in byRole.entries) e.value: e.key};
  final taken = byRole.keys.toSet();
  return [
    for (final box in selectable)
      if (roleOf[box] case final role?)
        MappedFolder(role, box, role: true)
      else
        MappedFolder(_unique(box.path, taken), box),
  ];
}

String _unique(String name, Set<String> taken) {
  var candidate = name;
  for (var n = 2; !taken.add(candidate); n++) {
    candidate = '$name ($n)';
  }
  return candidate;
}

/// IMAP SEARCH criteria for a search box query.
String searchCriteria(SearchQuery query) {
  final parts = <String>['UNDELETED'];
  var utf8 = false;
  String term(String key, String value) {
    if (value.codeUnits.any((u) => u > 127)) utf8 = true;
    return '$key ${_quote(value)}';
  }

  final text = query.text?.trim();
  if (text != null && text.isNotEmpty) {
    for (final word in text.split(RegExp(r'\s+'))) {
      parts.add(term('TEXT', word));
    }
  }
  final from = query.from?.trim();
  if (from != null && from.isNotEmpty) parts.add(term('FROM', from));
  if (query.after case final after?) {
    parts.add('SINCE ${DateCodec.encodeSearchDate(after)}');
  }
  if (query.before case final before?) {
    parts.add('BEFORE ${DateCodec.encodeSearchDate(before)}');
  }
  // IMAP has no "has an attachment"; a mixed multipart is the usual sign.
  if (query.hasAttachment) parts.add('HEADER Content-Type "multipart/mixed"');
  return '${utf8 ? 'CHARSET UTF-8 ' : ''}${parts.join(' ')}';
}

/// Gmail's SEARCH for what was typed into the search box, in Gmail's own
/// syntax (`from:`, `has:attachment`, `label:`, `older_than:`).
String gmailSearchCriteria(String raw) {
  final utf8 = raw.codeUnits.any((u) => u > 127);
  return '${utf8 ? 'CHARSET UTF-8 ' : ''}X-GM-RAW ${_quote(raw)}';
}

String _quote(String value) => '"${quoted(value)}"';

/// The mail, written out: plain text, UTF-8, with the reply headers.
MimeMessage buildMime(OutgoingMessage m, {String displayName = ''}) {
  final builder = MessageBuilder()
    ..from = [MailAddress(_nonEmpty(displayName), m.from)]
    ..to = [for (final a in m.to) MailAddress(null, a)]
    ..cc = [for (final a in m.cc) MailAddress(null, a)]
    ..bcc = [for (final a in m.bcc) MailAddress(null, a)]
    ..subject = m.subject
    ..text = m.bodyText
    ..characterSet = CharacterSet.utf8
    ..transferEncoding = TransferEncoding.quotedPrintable;
  final inReplyTo = m.inReplyTo;
  if (inReplyTo != null) {
    builder
      ..setHeader('In-Reply-To', inReplyTo)
      ..setHeader('References', m.references ?? inReplyTo);
  }
  return builder.buildMimeMessage();
}

final _internalDate = RegExp(
  r'^\s*(\d{1,2})-([A-Za-z]{3})-(\d{4}) (\d{2}):(\d{2}):(\d{2}) ([+-])(\d{2})(\d{2})',
);
const _months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec',
];

/// IMAP's INTERNALDATE (`17-Jul-1996 02:44:25 -0700`): when the server got
/// the message.
DateTime? parseInternalDate(String? raw) {
  final m = raw == null ? null : _internalDate.firstMatch(raw);
  if (m == null) return null;
  final month = _months.indexOf(m[2]!.toLowerCase()) + 1;
  if (month == 0) return null;
  final offset = Duration(hours: int.parse(m[8]!), minutes: int.parse(m[9]!));
  final utc = DateTime.utc(
    int.parse(m[3]!),
    month,
    int.parse(m[1]!),
    int.parse(m[4]!),
    int.parse(m[5]!),
    int.parse(m[6]!),
  ).subtract(m[7] == '-' ? -offset : offset);
  return utc.toLocal();
}

String? _nonEmpty(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();
