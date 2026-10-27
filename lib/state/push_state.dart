import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:restmail_api/restmail_api.dart';

import '../push/push_service.dart';
import '../l10n/catalog.dart';
import 'app_state.dart';
import 'mailbox_state.dart';
import 'settings.dart';

/// Where new mail notifications stand for one REST Mail account.
enum PushStatus {
  /// Not known yet: its server hasn't been asked, or couldn't be reached.
  unknown,

  /// Its server sends none: it is from before them, or has no credentials
  /// for this phone's push service.
  unsupported,

  /// Its server could, but this phone isn't registered with it.
  off,

  /// Registered: its server tells this phone when mail arrives.
  on,
}

/// What a push from REST Mail says, and all of it the app reads: the
/// registration it was sent to, the account with new mail, and that
/// account's unread count. Whatever else a payload carries, a sender or a
/// subject included, is ignored, so what a notification shows always comes
/// from the server over the API, never from Apple's or Google's servers.
@immutable
class PushSignal {
  const PushSignal({this.device, this.account, this.unread});

  /// An empty signal, a bare "fetch", for a payload with nothing of ours.
  factory PushSignal.parse(Map<String, Object?> payload) {
    final ours = payload['restmail'];
    if (ours is! Map) return const PushSignal();
    return PushSignal(
      device: switch (ours['device']) {
        final String id when id.isNotEmpty => id,
        final int id => '$id',
        _ => null,
      },
      account: _whole(ours['account']),
      unread: _whole(ours['unread']),
    );
  }

  final String? device;

  /// By its id on the server, as `GET /api/v1/accounts` lists it.
  final int? account;

  /// The account's unread mail in its inbox, as the server counted it.
  final int? unread;

  static int? _whole(Object? value) => switch (value) {
    final int n when n >= 0 => n,
    final double n when n >= 0 && n == n.roundToDouble() => n.toInt(),
    _ => null,
  };
}

/// New mail notifications and the app-icon badge for the accounts on this
/// phone.
///
/// Each REST Mail account's session registers this phone's push token with
/// its server (`POST /api/v1/devices`), once the user has turned
/// notifications on and iOS allows them. A push then says only that there is
/// mail; the app fetches it over the API and posts a notification for each
/// new message.
///
/// The badge sums the unread mail in every signed-in account's inbox, REST
/// Mail or IMAP, regardless of which account or folder is on screen. It is
/// reconciled on launch and resume, follows the inbox on screen as messages
/// arrive or are read, and drops an account as soon as it is removed or
/// signed out.
///
/// With no push token or no server that can push, new-mail notifications are
/// not offered; the badge still works where the platform allows it.
class PushNotifications extends ChangeNotifier {
  PushNotifications(this._app, this.service);

  final AppState _app;
  final PushService service;

  /// Whether the app is on screen. The app keeps it up to date; while it
  /// is, mail for the inbox on screen shows in the list, not as a
  /// notification.
  bool foreground = true;

  /// More than this many new messages from one push make one notification
  /// that counts the rest.
  static const _shownPerPush = 3;

  String? _token;
  bool _tokenAsked = false;
  NotificationPermission permission = NotificationPermission.undetermined;
  NotificationPermission badgePermission = NotificationPermission.undetermined;
  final _status = <String, PushStatus>{};
  final _saved = <String, _Registration>{};
  final _loaded = <String>{};
  Future<void>? _syncing;
  Future<void>? _starting;
  Future<void>? _reconciling;
  bool _again = false;
  bool _disposed = false;

  MailboxState? _watched;
  Set<int>? _watchedIds;
  Set<String>? _watchedAccounts;
  Timer? _reconcileTimer;

  /// Each inbox's unread count as last seen, keyed by account key and
  /// mailbox id. Summed for the app-icon badge.
  final _unread = <String, int>{};
  int? _badge;

  static String _storeKey(String accountKey) => 'push:$accountKey';
  static const _badgeKey = 'badge:counts';

  /// The REST Mail accounts signed in. An IMAP account's mail doesn't come
  /// from REST Mail, and a signed-out one has no session to register.
  List<RestAccount> get _accounts => [
    for (final a in _app.accounts)
      if (a is RestAccount && a.signedOut == null) a,
  ];

  /// True once this phone has a push token and the server of one of its
  /// accounts can push to it. Until then notifications aren't mentioned.
  bool get available =>
      _token != null &&
      _accounts.any(
        (a) => switch (_status[a.key]) {
          PushStatus.on || PushStatus.off => true,
          _ => false,
        },
      );

  /// On, and iOS lets the app show them.
  bool get enabled =>
      _app.settings.notifications == NotificationChoice.on &&
      permission == NotificationPermission.granted;

  /// Badges are local to the phone and need neither a token nor server push.
  bool get badgeEnabled =>
      _app.settings.appIconBadge &&
      badgePermission == NotificationPermission.granted;

  /// Time to explain notifications and ask: they are there to have, and
  /// the user hasn't been asked.
  bool get shouldOffer =>
      available &&
      _app.settings.notifications == NotificationChoice.undecided &&
      permission != NotificationPermission.denied;

  PushStatus statusOf(SignedInAccount account) => switch (account) {
    RestAccount() => _status[account.key] ?? PushStatus.unknown,
    _ => PushStatus.unsupported,
  };

  /// The first call does the work; later calls wait on the same start.
  Future<void> start() => _starting ??= _start();

  /// Takes the pushes and taps the platform held while the app started,
  /// then brings the registrations and the badge up to date.
  Future<void> _start() async {
    if (service.platform == null) return;
    service
      ..onPush = handlePush
      ..onOpen = _open;
    await _loadBadgeCounts();
    permission = await service.permission();
    await service.listen();
    _watchedAccounts = _app.accounts.map((a) => a.key).toSet();
    _app.addListener(_appChanged);
    _watchCurrentMailbox();
    await sync();
    await _updateBadge();
    unawaited(reconcileBadge());
  }

  /// Brings each account's registration in line with the user's choice and
  /// iOS's permission. The token and each server's support are asked for
  /// once; after that only what changed costs a request.
  Future<void> sync() {
    if (service.platform == null) return Future.value();
    if (_syncing case final running?) {
      _again = true;
      return running;
    }
    return _syncing = () async {
      do {
        _again = false;
        await _sync();
      } while (_again && !_disposed);
    }().whenComplete(() => _syncing = null);
  }

  Future<void> _sync() async {
    // Refresh permission even with IMAP only, no token or no push server.
    permission = await service.permission();
    badgePermission = await service.badgePermission();
    await _updateBadge();
    final accounts = _accounts;
    if (accounts.isEmpty) return _notify();
    if (!_tokenAsked) {
      _tokenAsked = true;
      _token = await service.token();
    }
    final token = _token;
    if (token == null) return _notify();
    final wanted = enabled;
    for (final account in accounts) {
      await _syncAccount(account, token, wanted: wanted);
    }
    await _updateBadge();
    _notify();
  }

  Future<void> _syncAccount(
    RestAccount account,
    String token, {
    required bool wanted,
  }) async {
    final key = account.key;
    var saved = await _load(account);
    try {
      if ((_status[key] ?? PushStatus.unknown) == PushStatus.unknown) {
        final server = await account.client.pushDevices();
        if (!server.supports(service.platform!)) {
          _status[key] = PushStatus.unsupported;
          await _drop(key);
          return;
        }
        // The server has forgotten this phone: it registers afresh.
        if (saved != null && !server.devices.any((d) => d.id == saved!.id)) {
          await _drop(key);
          saved = null;
        }
        _status[key] = saved == null ? PushStatus.off : PushStatus.on;
      }
      if (_status[key] == PushStatus.unsupported) return;
      if (wanted && saved?.token != token) {
        if (saved != null) await _removeFromServer(account, saved);
        final device = await account.client.registerPushDevice(
          platform: service.platform!,
          token: token,
          environment: service.environment,
          appId: service.appId,
        );
        await _save(
          key,
          _Registration(id: device.id, token: token, since: DateTime.now()),
        );
        _status[key] = PushStatus.on;
      } else if (!wanted && saved != null) {
        await _removeFromServer(account, saved);
        await _drop(key);
        _status[key] = PushStatus.off;
      }
    } on ApiException catch (e) {
      // No route for devices: the server has no push configured, and
      // nothing is said about it.
      if (e.statusCode == 404) {
        _status[key] = PushStatus.unsupported;
        await _drop(key);
      }
      // Anything else is tried again at the next sync.
    }
  }

  /// Turns notifications on: iOS's prompt the first time, then a
  /// registration with each server that can push. False if iOS said no.
  Future<bool> enable() async {
    final granted = await service.requestPermission();
    await _app.updateSettings(
      _app.settings.copyWith(
        notifications: granted ? NotificationChoice.on : NotificationChoice.off,
      ),
    );
    await sync();
    return granted;
  }

  /// Turns them off, and takes this phone off every server.
  Future<void> disable() async {
    await _app.updateSettings(
      _app.settings.copyWith(notifications: NotificationChoice.off),
    );
    await sync();
  }

  /// The badge control is available without server push. Asking here does
  /// not enable new-mail alerts or register this phone with a server.
  Future<void> setBadgeEnabled(bool on) async {
    if (service.platform == null) return;
    if (on) await service.requestPermission();
    permission = await service.permission();
    badgePermission = await service.badgePermission();
    await _app.updateSettings(_app.settings.copyWith(appIconBadge: on));
    await _updateBadge();
    _notify();
  }

  /// "Not now": the app doesn't ask again. Settings can turn them on.
  Future<void> decline() async {
    await _app.updateSettings(
      _app.settings.copyWith(notifications: NotificationChoice.off),
    );
    _notify();
  }

  /// Removes [account]'s registration from its server while its session
  /// can still do it, before it signs out. The server drops it with the
  /// session too; this is not left to that alone.
  Future<void> unregister(RestAccount account) async {
    if (await _load(account) case final saved?) {
      await _removeFromServer(account, saved);
    }
    await forget(account);
  }

  /// Lets go of [account]'s registration as a new session for the same
  /// account takes its place, and hands back its device id for the old
  /// session to remove from the server.
  Future<String?> detach(RestAccount account) async {
    final saved = await _load(account);
    _status.remove(account.key);
    await _drop(account.key);
    return saved?.id;
  }

  /// Forgets [account] here, its session over.
  Future<void> forget(SignedInAccount account) async {
    _status.remove(account.key);
    await _drop(account.key);
    _dropBadge(account.key);
    await _saveBadgeCounts();
    if (_disposed) return;
    await _updateBadge();
    _notify();
  }

  /// The app came back on screen, or went off it.
  void lifecycleChanged({required bool onScreen}) {
    if (onScreen == foreground) return;
    foreground = onScreen;
    if (onScreen) {
      // Notifications may have been turned on or off in iOS's Settings. Put
      // the badge back too: the launcher may have cleared it while away.
      _badge = null;
      // A token request that failed last time (no network, or APNs not ready
      // yet) is worth trying again now that the app is back.
      if (_token == null) _tokenAsked = false;
      unawaited(sync());
      unawaited(reconcileBadge());
    } else {
      unawaited(_badgeFromMailbox());
    }
  }

  // ── Pushes ────────────────────────────────────────────────────────────

  /// A push arrived: fetches the new mail of the account it names, or of
  /// every registered account if it names none this phone knows, posts its
  /// notifications and sets the badge. True if there was new mail.
  @visibleForTesting
  Future<bool> handlePush(Map<String, Object?> payload) async {
    final signal = PushSignal.parse(payload);
    final registered = <RestAccount>[
      for (final account in _accounts)
        if (await _load(account) != null) account,
    ];
    final named = [
      for (final account in registered)
        if (signal.device != null && _saved[account.key]?.id == signal.device)
          account,
    ];
    var news = false;
    for (final account in named.isNotEmpty ? named : registered) {
      if (await _fetch(account, named.contains(account) ? signal : null)) {
        news = true;
      }
    }
    await _updateBadge();
    return news;
  }

  /// Fetches [account]'s inbox, or those of its linked mailboxes too when
  /// [signal] doesn't say which, and posts a notification for each unread
  /// message newer than the last one seen.
  Future<bool> _fetch(RestAccount account, PushSignal? signal) async {
    final saved = _saved[account.key];
    if (saved == null) return false;
    final backend = account.backend;
    List<Account> mailboxes;
    try {
      mailboxes = await backend.accounts();
    } on ApiException {
      _takeServerCount(account, saved, signal);
      await _save(account.key, saved);
      return false;
    }
    final named = mailboxes.where((m) => m.id == signal?.account).toList();
    var news = false;
    for (final mailbox in named.isNotEmpty ? named : mailboxes) {
      try {
        final folders = await backend.folders(mailbox.id);
        final unread = folders
            .where((f) => f.name == StandardFolder.inbox)
            .fold(0, (sum, f) => sum + f.unread);
        saved.unread[mailbox.id] = unread;
        _unread['${account.key}#${mailbox.id}'] = unread;
        final page = await backend.messages(mailbox.id, StandardFolder.inbox);
        final last = saved.seen[mailbox.id];
        final fresh = [
          for (final m in page.items)
            if (!m.isRead &&
                (last == null
                    ? m.receivedAt.isAfter(saved.since)
                    : m.id > last))
              m,
        ];
        if (page.items.isNotEmpty) {
          saved.seen[mailbox.id] = page.items
              .map((m) => m.id)
              .fold(last ?? 0, max);
        }
        if (fresh.isEmpty) continue;
        news = true;
        if (_onScreen(account, mailbox)) continue;
        await _post(account, mailbox, fresh);
      } on ApiException {
        if (signal?.account == mailbox.id) {
          _takeServerCount(account, saved, signal);
        }
      }
    }
    await _save(account.key, saved);
    // The list on screen catches up too, should its event stream have
    // dropped while the app was away.
    if (news && identical(_app.current, account)) {
      unawaited(_app.mailbox?.refresh());
    }
    return news;
  }

  /// The push's own unread count, for a mailbox the app couldn't fetch.
  void _takeServerCount(
    RestAccount account,
    _Registration saved,
    PushSignal? signal,
  ) {
    final mailboxId = signal?.account, unread = signal?.unread;
    if (mailboxId != null && unread != null) {
      saved.unread[mailboxId] = unread;
      _unread['${account.key}#$mailboxId'] = unread;
    }
  }

  bool _onScreen(RestAccount account, Account mailbox) =>
      foreground &&
      identical(_app.current, account) &&
      _app.mailbox?.account?.id == mailbox.id;

  String _line(String key, [Map<String, String> args = const {}]) =>
      languageLine(
        _app.settings.languageCode == 'system'
            ? ui.PlatformDispatcher.instance.locale.languageCode
            : _app.settings.languageCode,
        key,
        voice: _app.settings.packId,
        args: args,
      );

  Future<void> _post(
    RestAccount account,
    Account mailbox,
    List<Message> fresh,
  ) async {
    final data = {'account': account.key, 'mailbox': '${mailbox.id}'};
    final thread = '${account.key}#${mailbox.id}';
    final icon = await _app.iconFileOf(account);
    for (final m in fresh.take(_shownPerPush)) {
      final subject = m.subject.trim().isEmpty
          ? _line('message.noSubject')
          : m.subject;
      await service.show(
        LocalNotification(
          id: '${account.key}#${m.id}',
          title: subject,
          subtitle: account.address,
          body: [m.senderLabel, if (m.preview.isNotEmpty) m.preview].join('\n'),
          thread: thread,
          data: data,
          icon: icon?.path,
        ),
      );
    }
    final more = fresh.length - _shownPerPush;
    if (more > 0) {
      await service.show(
        LocalNotification(
          id: '$thread#more',
          title: more == 1
              ? _line('push.oneMoreMessage')
              : _line('push.moreMessages', {'count': '$more'}),
          subtitle: account.address,
          body: mailbox.address,
          thread: thread,
          data: data,
          icon: icon?.path,
        ),
      );
    }
  }

  /// A tap on a notification: puts its account on screen.
  void _open(Map<String, String> data) {
    final account = _app.accounts
        .where((a) => a.key == data['account'])
        .firstOrNull;
    if (account != null) unawaited(_app.switchTo(account));
  }

  // ── The badge ─────────────────────────────────────────────────────────

  /// Applies the cached total, or zero when the user has badges off.
  Future<void> _updateBadge() async {
    await _setBadge(_unreadTotal);
  }

  Future<void> _setBadge(int total) async {
    if (service.platform == null || _disposed) return;
    final value = badgeEnabled ? total : 0;
    if (value == _badge) return;
    _badge = value;
    await service.setBadge(value);
  }

  /// The sum of every signed-in account's inboxes.
  int get _unreadTotal {
    var total = 0;
    for (final account in _app.accounts) {
      if (account.signedOut != null) continue;
      final prefix = '${account.key}#';
      for (final entry in _unread.entries) {
        if (entry.key.startsWith(prefix)) total += entry.value;
      }
    }
    return total;
  }

  /// Fetches every signed-in account's inbox counts and rebuilds the
  /// aggregate. A mailbox that cannot be reached keeps its last count; an
  /// account or mailbox that is gone is dropped.
  Future<void> reconcileBadge() =>
      _reconciling ??= _reconcile().whenComplete(() => _reconciling = null);

  Future<void> _reconcile() async {
    if (service.platform == null || _disposed) return;
    final next = <String, int>{};
    for (final account in _app.accounts) {
      if (account.signedOut != null) continue;
      final backend = account.backend;
      List<Account> mailboxes;
      try {
        mailboxes = await backend.accounts();
      } on ApiException {
        final prefix = '${account.key}#';
        for (final entry in _unread.entries) {
          if (entry.key.startsWith(prefix)) next[entry.key] = entry.value;
        }
        continue;
      }
      for (final mailbox in mailboxes) {
        final key = '${account.key}#${mailbox.id}';
        try {
          final folders = await backend.folders(mailbox.id);
          next[key] = folders
              .where((f) => f.name == StandardFolder.inbox)
              .fold(0, (sum, f) => sum + f.unread);
        } on ApiException {
          if (_unread[key] case final old?) next[key] = old;
        }
      }
    }
    _unread
      ..clear()
      ..addAll(next);
    await _saveBadgeCounts();
    await _updateBadge();
  }

  /// Takes the inbox on screen as the latest, so a new message or a read
  /// one reaches the badge without another request.
  Future<void> _badgeFromMailbox() async {
    if (_disposed) return;
    final account = _app.current;
    final mailbox = _app.mailbox;
    final serverAccount = mailbox?.account;
    if (account == null || mailbox == null || serverAccount == null) return;
    if (account.signedOut != null) {
      _dropBadge(account.key);
      await _saveBadgeCounts();
      await _updateBadge();
      return;
    }
    final inbox = mailbox.folders
        .where((f) => f.name == StandardFolder.inbox)
        .firstOrNull;
    if (inbox == null) return;
    final key = '${account.key}#${serverAccount.id}';
    if (_unread[key] == inbox.unread) return;
    _unread[key] = inbox.unread;
    await _saveBadgeCounts();
    await _updateBadge();
  }

  void _dropBadge(String accountKey) {
    final prefix = '$accountKey#';
    _unread.removeWhere((key, _) => key.startsWith(prefix));
  }

  Future<void> _loadBadgeCounts() async {
    try {
      final raw = await _app.store.read(_badgeKey);
      if (raw == null) return;
      final json = jsonDecode(raw);
      if (json is! Map) return;
      _unread
        ..clear()
        ..addEntries([
          for (final entry in json.entries)
            if (int.tryParse('${entry.value}') case final value?)
              MapEntry('${entry.key}', value),
        ]);
    } on Object {
      // Start empty; reconcile fetches the counts.
    }
  }

  Future<void> _saveBadgeCounts() async {
    if (service.platform == null) return;
    try {
      await _app.store.write(_badgeKey, jsonEncode(_unread));
    } on Object {
      // The badge still shows for this launch.
    }
  }

  void _appChanged() {
    if (_disposed) return;
    final keys = _app.accounts.map((a) => a.key).toSet();
    if (!setEquals(keys, _watchedAccounts)) {
      _watchedAccounts = keys;
      if (_token == null) _tokenAsked = false;
      _scheduleReconcile();
    }
    _watchCurrentMailbox();
    unawaited(_updateBadge());
  }

  void _watchCurrentMailbox() {
    final next = _app.mailbox;
    if (identical(next, _watched)) return;
    _watched?.removeListener(_mailboxChanged);
    _watched = next;
    _watchedIds = null;
    next?.addListener(_mailboxChanged);
    if (next != null) unawaited(_badgeFromMailbox());
  }

  void _mailboxChanged() {
    if (_disposed) return;
    final ids = _watched?.accounts.map((a) => a.id).toSet();
    if (ids != null && !setEquals(ids, _watchedIds)) {
      _watchedIds = ids;
      _scheduleReconcile();
    }
    unawaited(_badgeFromMailbox());
  }

  void _scheduleReconcile() {
    _reconcileTimer?.cancel();
    _reconcileTimer = Timer(const Duration(seconds: 2), () {
      _reconcileTimer = null;
      unawaited(reconcileBadge());
    });
  }

  // ── Kept on the phone ─────────────────────────────────────────────────

  Future<_Registration?> _load(RestAccount account) async {
    final key = account.key;
    if (_loaded.add(key)) {
      try {
        final saved = _Registration.decode(
          await _app.store.read(_storeKey(key)),
        );
        if (saved != null) _saved[key] = saved;
      } on Object {
        // Unreadable: registers afresh.
      }
    }
    return _saved[key];
  }

  Future<void> _save(String key, _Registration saved) async {
    _saved[key] = saved;
    _loaded.add(key);
    await _app.store.write(_storeKey(key), saved.encode());
  }

  Future<void> _drop(String key) async {
    _loaded.add(key);
    if (_saved.remove(key) == null) return;
    await _app.store.delete(_storeKey(key));
  }

  Future<void> _removeFromServer(
    RestAccount account,
    _Registration saved,
  ) async {
    try {
      await account.client.removePushDevice(saved.id);
    } on ApiException {
      // Gone already, or unreachable: it ends with the session regardless.
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _reconcileTimer?.cancel();
    _app.removeListener(_appChanged);
    _watched?.removeListener(_mailboxChanged);
    _watched = null;
    service
      ..onPush = null
      ..onOpen = null;
    super.dispose();
  }
}

/// One account's registration as this phone keeps it.
class _Registration {
  _Registration({
    required this.id,
    required this.token,
    required this.since,
    Map<int, int>? seen,
    Map<int, int>? unread,
  }) : seen = seen ?? {},
       unread = unread ?? {};

  static _Registration? decode(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      Map<int, int> counts(Object? value) => {
        if (value is Map)
          for (final MapEntry(:key, :value) in value.entries)
            if (int.tryParse('$key') case final id? when value is int)
              id: value,
      };
      return _Registration(
        id: json['id'] as String,
        token: json['token'] as String,
        since: DateTime.parse(json['since'] as String),
        seen: counts(json['seen']),
        unread: counts(json['unread']),
      );
    } on Object {
      return null;
    }
  }

  /// The device's id on the server.
  final String id;

  /// The token it was registered with. A new one registers again.
  final String token;

  /// When it was made: mail from before it isn't news.
  final DateTime since;

  /// The newest message seen in each mailbox's inbox, by id.
  final Map<int, int> seen;

  /// Each mailbox's unread mail in its inbox, as last fetched.
  final Map<int, int> unread;

  String encode() => jsonEncode({
    'id': id,
    'token': token,
    'since': since.toUtc().toIso8601String(),
    'seen': {for (final e in seen.entries) '${e.key}': e.value},
    'unread': {for (final e in unread.entries) '${e.key}': e.value},
  });
}
