import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';

import '../util/sign_in_link.dart';
import '../version.dart';
import 'mail_backend.dart';
import 'mailbox_state.dart';
import 'settings.dart';
import 'storage.dart';

enum AppPhase { starting, signedOut, signedIn }

/// One account signed in on this phone: a session on a REST Mail server.
/// Its linked mailboxes, if it has any, belong to it.
class SignedInAccount {
  SignedInAccount._(this.server, this.user, this.client);

  final Uri server;
  final User user;
  final RestmailClient client;

  /// Names the account in storage: one per address per server.
  String get key => _keyOf(server, user);

  String get address => user.email;

  String get label =>
      user.displayName.isNotEmpty ? user.displayName : user.email;

  String get host => server.host;
}

String _keyOf(Uri server, User user) => '$server|${user.email.toLowerCase()}';

/// Who is signed in to which servers, and the settings — everything that
/// outlives a single screen.
class AppState extends ChangeNotifier {
  AppState({required this.store, required this.httpClientFactory});

  final KeyValueStore store;

  /// Makes the HTTP client each server connection uses, so TLS trust is set
  /// in one place (and tests can hand in a fake).
  final http.Client Function() httpClientFactory;

  /// Before there could be more than one account, its session lived here.
  static const _legacySessionKey = 'session';

  /// Which accounts there are, in order, and which one is on screen. Each
  /// account's session is stored under its own key, so one that can't be
  /// read signs out that account alone.
  static const _accountsKey = 'accounts';
  static const _settingsKey = 'settings';
  static const userAgent = 'restmail-mobile/$appVersion';

  static String _accountKey(String key) => 'account:$key';

  AppPhase phase = AppPhase.starting;
  AppSettings settings = const AppSettings();

  /// Every account signed in on this phone, in the order they were added.
  List<SignedInAccount> accounts = const [];

  /// The account on screen.
  SignedInAccount? current;

  /// The mail of the account on screen. Only that account's mail is loaded
  /// and listening; switching stops it and starts the next one's.
  MailboxState? mailbox;

  /// Why the last account ended when the user did not end it themselves.
  String? signedOutReason;

  final _notices = StreamController<String>.broadcast();

  /// One-line news for whoever is looking, such as another account's session
  /// running out. The app shows each as a snackbar.
  Stream<String> get notices => _notices.stream;

  int _sessions = 0;
  final _signingOut = <SignedInAccount>{};

  SignInLink? _pendingSetup;
  String? _lastLink;

  /// A sign-in link the app was opened with, waiting for the screen on top to
  /// start setting the server up. [takePendingSetup] hands it over once.
  SignInLink? get pendingSetup => _pendingSetup;

  /// Takes a link the app was opened with. A sign-in link, from the QR code
  /// the installer showed (`https://rest-mail.com/setup#server=…&username=…`
  /// `&password=…`), waits in [pendingSetup]; anything else is ignored. The
  /// same link delivered twice (at launch, and again by the stream of links)
  /// counts once.
  void openLink(Uri link) {
    final raw = link.toString();
    if (raw == _lastLink) return;
    _lastLink = raw;
    final scan = SignInLink.parse(raw);
    if (scan == null) return;
    _pendingSetup = scan;
    notifyListeners();
  }

  SignInLink? takePendingSetup() {
    final scan = _pendingSetup;
    _pendingSetup = null;
    return scan;
  }

  /// Changes whenever the account on screen does; keys the navigator.
  Object get sessionKey => (phase, _sessions);

  Future<void> start() async {
    settings = AppSettings.decode(await _read(_settingsKey));
    await _moveLegacySession();
    final (saved, currentKey, dropped) = await _readSaved();
    accounts = [for (final s in saved) _open(s)];
    if (accounts.isEmpty) {
      phase = AppPhase.signedOut;
    } else {
      _show(
        accounts.firstWhere(
          (a) => a.key == currentKey,
          orElse: () => accounts.first,
        ),
      );
    }
    notifyListeners();
    if (dropped) await _writeIndex();
  }

  /// A client for [server] with no session, for discovery and health checks.
  RestmailClient probe(Uri server) => RestmailClient(
    server: server,
    httpClient: httpClientFactory(),
    userAgent: userAgent,
  );

  /// Signs in and adds the account, or renews it if it is already here, and
  /// puts it on screen.
  ///
  /// Throws [TotpRequiredException] when the account wants a second factor,
  /// and [ApiException] for anything else the server refuses.
  Future<void> signIn({
    required Uri server,
    required String email,
    required String password,
    String? totpCode,
    String? recoveryCode,
  }) async {
    final candidate = probe(server);
    try {
      final result = await candidate.login(
        email: email,
        password: password,
        totpCode: totpCode,
        recoveryCode: recoveryCode,
      );
      final saved = _SavedSession(server, result.user, result.tokens);
      await store.write(_accountKey(saved.key), saved.encode());
      final account = _open(saved);
      final index = accounts.indexWhere((a) => a.key == account.key);
      final replaced = index < 0 ? null : accounts[index];
      accounts = index < 0
          ? [...accounts, account]
          : ([...accounts]..[index] = account);
      signedOutReason = null;
      _show(account);
      notifyListeners();
      // The session this one replaces is ended on the server too, rather
      // than left valid until it expires.
      if (replaced != null) {
        unawaited(replaced.client.logout().whenComplete(replaced.client.close));
      }
      await _writeIndex();
    } finally {
      candidate.close();
    }
  }

  /// Puts [account] on screen.
  Future<void> switchTo(SignedInAccount account) async {
    if (identical(account, current) || !accounts.contains(account)) return;
    _show(account);
    notifyListeners();
    await _writeIndex();
  }

  /// Signs [account] out, the one on screen if none is named. The others
  /// stay signed in.
  Future<void> signOut([SignedInAccount? account]) async {
    account ??= current;
    if (account == null) return;
    _signingOut.add(account);
    try {
      await account.client.logout();
    } finally {
      _signingOut.remove(account);
    }
    await _end(account);
    if (accounts.isNotEmpty) _notices.add('Signed out of ${account.address}');
  }

  Future<void> updateSettings(AppSettings next) async {
    settings = next;
    notifyListeners();
    await store.write(_settingsKey, next.encode());
  }

  SignedInAccount _open(_SavedSession saved) {
    late final SignedInAccount account;
    final client = RestmailClient(
      server: saved.server,
      httpClient: httpClientFactory(),
      tokens: saved.tokens,
      onTokensChanged: (tokens) => _tokensChanged(account, tokens),
      userAgent: userAgent,
    );
    return account = SignedInAccount._(saved.server, saved.user, client);
  }

  /// Starts [account]'s mail and stops the previous account's.
  void _show(SignedInAccount account) {
    final previous = mailbox;
    current = account;
    mailbox = MailboxState(RestBackend(account.client))..start();
    phase = AppPhase.signedIn;
    _sessions++;
    previous?.dispose();
  }

  void _tokensChanged(SignedInAccount account, SessionTokens? tokens) {
    // A session already ended or replaced by signing in again is never
    // saved, so it can't overwrite the one that took its place.
    if (!accounts.contains(account)) return;
    if (tokens != null) {
      unawaited(
        store.write(
          _accountKey(account.key),
          _SavedSession(account.server, account.user, tokens).encode(),
        ),
      );
    } else if (!_signingOut.contains(account)) {
      unawaited(
        _end(
          account,
          reason: accounts.length > 1
              ? 'Your session for ${account.address} ended. Add the account '
                    'again to carry on.'
              : 'Your session ended. Sign in again to carry on.',
        ),
      );
    }
  }

  Future<void> _end(SignedInAccount account, {String? reason}) async {
    if (!accounts.contains(account)) return;
    accounts = [...accounts]..remove(account);
    if (identical(account, current)) {
      if (accounts.isNotEmpty) {
        _show(accounts.first);
      } else {
        // The mailbox stops listening before the connection it listens on
        // closes.
        mailbox?.dispose();
        mailbox = null;
        current = null;
        phase = AppPhase.signedOut;
        signedOutReason = reason;
        _sessions++;
      }
    }
    notifyListeners();
    if (reason != null && accounts.isNotEmpty) _notices.add(reason);
    account.client.close();
    await store.delete(_accountKey(account.key));
    await _writeIndex();
  }

  Future<void> _writeIndex() async {
    if (accounts.isEmpty) {
      await store.delete(_accountsKey);
      return;
    }
    await store.write(
      _accountsKey,
      _encodeIndex([for (final a in accounts) a.key], current?.key),
    );
  }

  /// Moves a session saved before there could be several accounts into the
  /// list, so an upgrade keeps it signed in. The old entry goes only once the
  /// new ones are written.
  Future<void> _moveLegacySession() async {
    final raw = await _read(_legacySessionKey);
    if (raw == null) return;
    final saved = _SavedSession.decode(raw);
    if (saved != null) {
      final (order, _) = _decodeIndex(await _read(_accountsKey));
      await store.write(_accountKey(saved.key), saved.encode());
      await store.write(
        _accountsKey,
        _encodeIndex([
          ...order.where((k) => k != saved.key),
          saved.key,
        ], saved.key),
      );
    }
    await store.delete(_legacySessionKey);
  }

  /// The saved accounts in order, which one was on screen, and whether any
  /// had to be dropped. An entry that can't be read is deleted: that account
  /// signs in again, and the others are kept.
  Future<(List<_SavedSession>, String?, bool)> _readSaved() async {
    final (order, currentKey) = _decodeIndex(await _read(_accountsKey));
    final saved = <_SavedSession>[];
    var dropped = false;
    for (final key in order) {
      final session = _SavedSession.decode(await _read(_accountKey(key)));
      if (session == null) {
        await store.delete(_accountKey(key));
        dropped = true;
      } else if (saved.any((s) => s.key == session.key)) {
        dropped = true;
      } else {
        saved.add(session);
      }
    }
    return (saved, currentKey, dropped);
  }

  /// Reads [key], or null if it is missing or the Keychain can't read it.
  Future<String?> _read(String key) async {
    try {
      return await store.read(key);
    } on Object {
      return null;
    }
  }

  static String _encodeIndex(List<String> order, String? current) =>
      jsonEncode({'order': order, 'current': current});

  /// The index's account keys in order and the one on screen; nothing if it
  /// is missing or unreadable.
  static (List<String>, String?) _decodeIndex(String? raw) {
    if (raw == null) return (const [], null);
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return (
        [for (final k in json['order'] as List? ?? const []) k as String],
        json['current'] as String?,
      );
    } on Object {
      return (const [], null);
    }
  }

  @override
  void dispose() {
    mailbox?.dispose();
    for (final account in accounts) {
      account.client.close();
    }
    unawaited(_notices.close());
    super.dispose();
  }
}

class _SavedSession {
  const _SavedSession(this.server, this.user, this.tokens);

  static _SavedSession? decode(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _SavedSession(
        Uri.parse(json['server'] as String),
        User.fromJson(json['user'] as Map<String, dynamic>),
        SessionTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      );
    } on Object {
      return null; // Unreadable: sign in again rather than crash.
    }
  }

  final Uri server;
  final User user;
  final SessionTokens tokens;

  String get key => _keyOf(server, user);

  String encode() => jsonEncode({
    'server': server.toString(),
    'user': user.toJson(),
    'tokens': tokens.toJson(),
  });
}
