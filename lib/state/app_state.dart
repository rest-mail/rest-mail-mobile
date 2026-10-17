import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';

import '../imap/imap_backend.dart';
import '../imap/mail_connection.dart';
import '../imap/mail_settings.dart';
import '../net/http_client.dart';
import '../util/sign_in_link.dart';
import '../version.dart';
import 'mail_backend.dart';
import 'mailbox_state.dart';
import 'settings.dart';
import 'storage.dart';

enum AppPhase { starting, signedOut, signedIn }

/// What an account is, as its saved entry says.
enum AccountKind { rest, imap }

/// One account signed in on this phone: a session on a REST Mail server
/// ([RestAccount]), or a mailbox at an IMAP provider such as Gmail
/// ([ImapAccount]).
sealed class SignedInAccount {
  AccountKind get kind;

  /// Names the account in storage: one per address per server.
  String get key;

  String get address;
  String get displayName;
  String get label => displayName.isNotEmpty ? displayName : address;

  /// Where its mail comes from.
  String get host;

  /// Its mail. The account keeps it for as long as it is signed in.
  MailBackend get backend;

  /// What it may do on the server's admin API, as its session last heard.
  Capabilities get capabilities => Capabilities.none;

  /// Lets go of its connections, for good.
  void close();
}

/// A session on a REST Mail server: an account's, which is a mailbox, with
/// the accounts it created or linked. What it may administer comes with the
/// session, as [capabilities].
class RestAccount extends SignedInAccount {
  RestAccount._(
    this.server,
    this.user,
    this.client, {
    required this.capabilities,
  }) : backend = RestBackend(client);

  final Uri server;
  final User user;
  final RestmailClient client;

  @override
  final MailBackend backend;

  /// Renewed with the tokens at every refresh.
  @override
  Capabilities capabilities;

  @override
  AccountKind get kind => AccountKind.rest;

  @override
  String get key => _keyOf(server, user.email);

  @override
  String get address => user.email;

  @override
  String get displayName => user.displayName;

  @override
  String get host => server.host;

  @override
  void close() => client.close();
}

/// A mailbox read over IMAP and sent through SMTP, signed in with its
/// password or an app password. Both are kept in the Keychain or Keystore,
/// as IMAP and SMTP want them each time they connect.
class ImapAccount extends SignedInAccount {
  ImapAccount._(this.backend, {this.provider});

  @override
  final ImapBackend backend;

  /// The provider whose preset it was set up from, if it was.
  final MailProvider? provider;

  MailServerSettings get settings => backend.settings;

  @override
  AccountKind get kind => AccountKind.imap;

  @override
  String get key =>
      _keyOf(Uri(scheme: 'imaps', host: settings.imapHost), address);

  @override
  String get address => backend.address;

  @override
  String get displayName => backend.displayName;

  @override
  String get host => settings.imapHost;

  @override
  void close() => unawaited(backend.close());
}

String _keyOf(Uri server, String email) => '$server|${email.toLowerCase()}';

/// Who is signed in to which servers, and the settings — everything that
/// outlives a single screen.
class AppState extends ChangeNotifier {
  AppState({
    required this.store,
    required this.httpClientFactory,
    OpenMailSocket? mailSockets,
  }) : mailSockets = mailSockets ?? defaultMailSockets(createSecurityContext);

  final KeyValueStore store;

  /// Makes the HTTP client each server connection uses, so TLS trust is set
  /// in one place (and tests can hand in a fake).
  final http.Client Function() httpClientFactory;

  /// Opens the IMAP and SMTP sockets: TLS with the same trust as HTTPS.
  final OpenMailSocket mailSockets;

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
  /// the installer showed (`https://rest-mail.com/setup#server=…&address=…`
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
  /// puts it on screen. An administrator signs in here too, as the account
  /// it is; Administration shows by the session's capabilities.
  ///
  /// Throws [TotpRequiredException] when the account wants a second factor,
  /// and [ApiException] for anything else the server refuses: 403
  /// `setup_required` for an account that has still to choose its own
  /// password or enroll an authenticator (a fresh install's first one),
  /// which is not kept until it has.
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
      if (!result.isSetUp) {
        // A session that can only finish the setup is no use kept.
        await candidate.logout();
        throw ApiException(
          403,
          'setup_required',
          '${result.user.email} has to choose its own password and set up '
              'two-factor sign-in first.',
        );
      }
      await keep(server, result.user, result.tokens);
    } finally {
      candidate.close();
    }
  }

  /// Adds a session already signed in, such as the one finishing a server's
  /// setup ends with, or renews the account if it is already here, and puts
  /// it on screen. Whatever signed in hands it over and uses it no more.
  Future<void> keep(Uri server, User user, SessionTokens tokens) async {
    final saved = _SavedSession(server, user, tokens);
    await store.write(_accountKey(saved.key), saved.encode());
    await _add(_openRest(saved));
  }

  /// Adds a Gmail or other IMAP account, or renews it if it is already
  /// here, and puts it on screen. The address and password are tried on
  /// both the IMAP and the SMTP server first, so a wrong setting shows now
  /// rather than at the first send.
  ///
  /// Throws [ApiException]: `unauthorized` for a wrong password,
  /// `app_password_required` when Gmail wants an app password, `no_tls` for
  /// a server that won't talk TLS, and the network codes.
  Future<void> addImapAccount({
    required String address,
    required String password,
    required MailServerSettings settings,
    String displayName = '',
    MailProvider? provider,
  }) async {
    final saved = _SavedImap(
      address: address.trim(),
      displayName: displayName.trim(),
      password: password,
      settings: settings,
      provider: provider?.id,
    );
    final account = _openImap(saved);
    try {
      await account.backend.verify();
    } on Object {
      account.close();
      rethrow;
    }
    await store.write(_accountKey(saved.key), saved.encode());
    await _add(account);
  }

  /// Puts [account] in the list, in place of one with the same key, and on
  /// screen.
  Future<void> _add(SignedInAccount account) async {
    final index = accounts.indexWhere((a) => a.key == account.key);
    final replaced = index < 0 ? null : accounts[index];
    accounts = index < 0
        ? [...accounts, account]
        : ([...accounts]..[index] = account);
    signedOutReason = null;
    _show(account);
    notifyListeners();
    switch (replaced) {
      // The session this one replaces is ended on the server too, rather
      // than left valid until it expires.
      case RestAccount(:final client):
        unawaited(client.logout().whenComplete(client.close));
      case ImapAccount():
        replaced.close();
      case null:
    }
    await _writeIndex();
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
      // An IMAP account has no session on the server to end; forgetting
      // its password here is signing out.
      if (account is RestAccount) await account.client.logout();
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

  SignedInAccount _open(_Saved saved) => switch (saved) {
    _SavedSession() => _openRest(saved),
    _SavedImap() => _openImap(saved),
  };

  RestAccount _openRest(_SavedSession saved) {
    late final RestAccount account;
    final client = RestmailClient(
      server: saved.server,
      httpClient: httpClientFactory(),
      tokens: saved.tokens,
      onTokensChanged: (tokens) => _tokensChanged(account, tokens),
      userAgent: userAgent,
    );
    return account = RestAccount._(
      saved.server,
      saved.user,
      client,
      capabilities: saved.tokens.capabilities,
    );
  }

  ImapAccount _openImap(_SavedImap saved) => ImapAccount._(
    ImapBackend(
      address: saved.address,
      displayName: saved.displayName,
      password: saved.password,
      settings: saved.settings,
      openSocket: mailSockets,
    ),
    provider: MailProviders.byId(saved.provider),
  );

  /// Starts [account]'s mail and stops the previous account's.
  void _show(SignedInAccount account) {
    final previous = mailbox;
    final previousAccount = current;
    current = account;
    mailbox = MailboxState(account.backend)..start();
    phase = AppPhase.signedIn;
    _sessions++;
    previous?.dispose();
    // An IMAP account off screen keeps no connection open; it reconnects
    // when it is shown again.
    if (previousAccount is ImapAccount && previousAccount != account) {
      unawaited(previousAccount.backend.disconnect());
    }
  }

  void _tokensChanged(RestAccount account, SessionTokens? tokens) {
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
      // The server re-reads the grants at every refresh: what it took away
      // goes from the screens now.
      if (tokens.capabilities != account.capabilities) {
        account.capabilities = tokens.capabilities;
        notifyListeners();
      }
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
    account.close();
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

  /// The saved accounts in order, which one was on screen, and whether any
  /// had to be dropped. An entry that can't be read is deleted: that account
  /// signs in again, and the others are kept.
  Future<(List<_Saved>, String?, bool)> _readSaved() async {
    final (order, currentKey) = _decodeIndex(await _read(_accountsKey));
    final saved = <_Saved>[];
    var dropped = false;
    for (final key in order) {
      final session = _Saved.decode(await _read(_accountKey(key)));
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
      account.close();
    }
    unawaited(_notices.close());
    super.dispose();
  }
}

/// One account's entry in the Keychain or Keystore. `kind` says which sort
/// it is; an entry without one can't be read, and is dropped.
sealed class _Saved {
  const _Saved();

  static _Saved? decode(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return switch (json['kind']) {
        'rest' => _SavedSession.fromJson(json),
        'imap' => _SavedImap.fromJson(json),
        _ => null,
      };
    } on Object {
      return null; // Unreadable: sign in again rather than crash.
    }
  }

  String get key;

  String encode();
}

class _SavedSession extends _Saved {
  const _SavedSession(this.server, this.user, this.tokens);

  factory _SavedSession.fromJson(Map<String, dynamic> json) => _SavedSession(
    Uri.parse(json['server'] as String),
    User.fromJson(json['user'] as Map<String, dynamic>),
    SessionTokens.fromJson(json['tokens'] as Map<String, dynamic>),
  );

  final Uri server;
  final User user;
  final SessionTokens tokens;

  @override
  String get key => _keyOf(server, user.email);

  @override
  String encode() => jsonEncode({
    'kind': AccountKind.rest.name,
    'server': server.toString(),
    'user': user.toJson(),
    'tokens': tokens.toJson(),
  });
}

class _SavedImap extends _Saved {
  const _SavedImap({
    required this.address,
    required this.displayName,
    required this.password,
    required this.settings,
    this.provider,
  });

  static _SavedImap? fromJson(Map<String, dynamic> json) {
    final settings = MailServerSettings.fromJson(json['settings']);
    if (settings == null) return null;
    return _SavedImap(
      address: json['address'] as String,
      displayName: json['display_name'] as String? ?? '',
      password: json['password'] as String,
      settings: settings,
      provider: json['provider'] as String?,
    );
  }

  final String address;
  final String displayName;
  final String password;
  final MailServerSettings settings;
  final String? provider;

  @override
  String get key =>
      _keyOf(Uri(scheme: 'imaps', host: settings.imapHost), address);

  @override
  String encode() => jsonEncode({
    'kind': AccountKind.imap.name,
    'address': address,
    'display_name': displayName,
    'password': password,
    'settings': settings.toJson(),
    'provider': ?provider,
  });
}
