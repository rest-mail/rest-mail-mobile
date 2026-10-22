import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';

import '../imap/imap_backend.dart';
import '../imap/mail_connection.dart';
import '../imap/mail_settings.dart';
import '../imap/oauth.dart';
import '../imap/oauth_browser.dart';
import '../net/http_client.dart';
import '../push/push_service.dart';
import '../util/sign_in_link.dart';
import '../version.dart';
import 'mail_backend.dart';
import 'mailbox_state.dart';
import 'push_state.dart';
import 'settings.dart';
import 'storage.dart';

enum AppPhase { starting, signedOut, signedIn }

/// What an account is, as its saved entry says.
enum AccountKind { rest, imap }

/// One account on this phone, signed in or [signedOut]: a session on a
/// REST Mail server ([RestAccount]), or a mailbox at an IMAP provider such
/// as Gmail ([ImapAccount]).
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

  /// Why it can't reach its mail until it is signed in again, or null while
  /// it can: its session ended, or Microsoft or Google stopped letting REST
  /// Mail in. It stays on the phone all the same, with its settings and its
  /// place in the list, until it is signed in again or removed.
  String? get signedOut;

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
  String? get signedOut => client.tokens == null
      ? 'Your session for $address ended. Sign in again to carry on.'
      : null;

  @override
  void close() => client.close();
}

/// A mailbox read over IMAP and sent through SMTP, signed in with its
/// password or an app password, kept in the Keychain or Keystore as IMAP
/// and SMTP want it each time they connect; or signed in with Microsoft or
/// Google, when the Keychain or Keystore holds the refresh token instead.
class ImapAccount extends SignedInAccount {
  ImapAccount._(
    this.backend, {
    this.provider,
    this.oauth,
    this.wasSignedOut = false,
  });

  @override
  final ImapBackend backend;

  /// The provider whose preset it was set up from, if it was.
  final MailProvider? provider;

  /// Its sign-in with Microsoft or Google, if it has no password.
  final OAuthSession? oauth;
  final bool wasSignedOut;

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
  String? get signedOut => wasSignedOut
      ? 'You signed out of $address. Sign in again to carry on.'
      : switch (oauth) {
          final session? when session.hasEnded =>
            '${session.kind.label} no longer lets REST Mail into $address. '
                'Sign in again to carry on.',
          final session? when session.refreshToken == null =>
            'Sign in with ${session.kind.label} again to carry on with $address.',
          _ => null,
        };

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
    this.oauth = OAuthClients.none,
    this.oauthBrowser = systemOAuthBrowser,
    PushService pushService = const NoPushService(),
  }) : mailSockets = mailSockets ?? defaultMailSockets(createSecurityContext) {
    push = PushNotifications(this, pushService);
  }

  final KeyValueStore store;

  /// Makes the HTTP client each server connection uses, so TLS trust is set
  /// in one place (and tests can hand in a fake).
  final http.Client Function() httpClientFactory;

  /// Opens the IMAP and SMTP sockets: TLS with the same trust as HTTPS.
  final OpenMailSocket mailSockets;

  /// The Microsoft and Google clients this build has. A provider without
  /// one has no sign-in button.
  final OAuthClients oauth;

  /// Shows a provider's sign-in page in the system browser.
  final OAuthBrowser oauthBrowser;

  /// New mail notifications, for the REST Mail accounts whose server can
  /// send them.
  late final PushNotifications push;

  /// Which accounts there are, in order, and which one is on screen. Each
  /// account's session is stored under its own key, so one that can't be
  /// read signs out that account alone.
  static const _accountsKey = 'accounts';
  static const _settingsKey = 'settings';
  static const userAgent = 'restmail-mobile/$appVersion';

  static String _accountKey(String key) => 'account:$key';

  AppPhase phase = AppPhase.starting;
  AppSettings settings = const AppSettings();

  /// Every account on this phone, in the order they were added.
  List<SignedInAccount> accounts = const [];

  /// The account on screen.
  SignedInAccount? current;

  /// The mail of the account on screen. Only that account's mail is loaded
  /// and listening; switching stops it and starts the next one's.
  MailboxState? mailbox;

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
    unawaited(push.start());
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
    final account = _openRest(saved);
    await _add(account);
    await _queueWrite(account, () async {
      if (!accounts.contains(account) ||
          !identical(account.client.tokens, tokens)) {
        return;
      }
      await store.write(_accountKey(saved.key), saved.encode());
    });
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

  /// Adds an account by signing in with Microsoft or Google ([kind]) in
  /// the system browser, rather than with a password, or renews it if it is
  /// already here, and puts it on screen. [address] is a hint: the account
  /// is the one that signed in. Its refresh token is kept in the Keychain
  /// or Keystore; the access token, in memory only.
  ///
  /// Throws [ApiException]: `cancelled` if the browser was closed,
  /// `access_denied` if permission was refused, `oauth_state` for an answer
  /// to some other request, and what IMAP and SMTP throw.
  Future<void> addOAuthAccount({
    required OAuthKind kind,
    required String address,
    required MailServerSettings settings,
    String displayName = '',
    MailProvider? provider,
  }) => _addOAuth(
    kind: kind,
    address: address,
    settings: settings,
    displayName: displayName,
    provider: provider,
  );

  /// Signs [account] in with Microsoft or Google again once they have
  /// stopped letting REST Mail in, keeping its name, its servers and its
  /// place in the list. Throws as [addOAuthAccount] does, and
  /// `other_account` when a different account signs in.
  Future<void> signInAgain(ImapAccount account) async {
    final kind = account.oauth?.kind;
    if (kind == null) return;
    await _addOAuth(
      kind: kind,
      address: account.address,
      settings: account.settings,
      displayName: account.displayName,
      provider: account.provider,
      only: account.address,
    );
  }

  /// [addOAuthAccount], or with [only], [signInAgain] for that address.
  Future<void> _addOAuth({
    required OAuthKind kind,
    required String address,
    required MailServerSettings settings,
    required String displayName,
    required MailProvider? provider,
    String? only,
  }) async {
    final client = oauth[kind];
    if (client == null) {
      throw ApiException(
        0,
        'oauth_unavailable',
        "This build of REST Mail can't sign in with ${kind.label}.",
      );
    }
    final http = httpClientFactory();
    final OAuthGrant grant;
    try {
      grant = await signInWithOAuth(
        client,
        httpClient: http,
        browser: oauthBrowser,
        loginHint: address,
      );
    } finally {
      http.close();
    }
    final email = grant.email ?? address.trim();
    if (only != null && email.toLowerCase() != only.toLowerCase()) {
      throw ApiException(
        409,
        'other_account',
        'You signed in to ${kind.label} as $email. Sign in as $only to carry '
            'on with it, or add $email as an account of its own.',
      );
    }
    final name = displayName.trim();
    final saved = _SavedImap(
      address: email,
      displayName: name.isNotEmpty ? name : grant.name ?? '',
      oauth: _SavedOAuth(kind, grant.refreshToken),
      settings: settings,
      provider: provider?.id,
    );
    final account = _openImap(saved, access: grant.access);
    try {
      await account.backend.verify();
    } on Object {
      account.close();
      rethrow;
    }
    // The refresh token as it is now: one that came while checking the
    // servers replaced the first.
    final kept = saved.withRefreshToken(account.oauth!.refreshToken);
    await store.write(_accountKey(kept.key), kept.encode());
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
    _show(account);
    notifyListeners();
    switch (replaced) {
      // The session this one replaces is ended on the server too, rather
      // than left valid until it expires, and its push registration goes
      // first: the new session registers its own.
      case RestAccount(:final client):
        final device = await push.detach(replaced);
        unawaited(
          () async {
            if (device != null) {
              try {
                await client.removePushDevice(device);
              } on ApiException {
                // It goes with the session regardless.
              }
            }
            await client.logout();
          }().whenComplete(client.close),
        );
      case ImapAccount():
        replaced.close();
      case null:
    }
    await _writeIndex();
    unawaited(push.sync());
  }

  /// Puts [account] on screen, at [folder].
  Future<void> switchTo(
    SignedInAccount account, {
    String folder = StandardFolder.inbox,
    bool keepNavigator = false,
  }) async {
    if (identical(account, current) || !accounts.contains(account)) return;
    _show(account, folder: folder, keepNavigator: keepNavigator);
    notifyListeners();
    await _writeIndex();
  }

  /// [account]'s folders, without putting it on screen: its primary
  /// mailbox's, for the drawer. An IMAP account lets go of the connection
  /// again, unless it was put on screen in the meantime.
  Future<List<Folder>> folders(SignedInAccount account) async {
    final backend = account.backend;
    try {
      final mailboxes = await backend.accounts();
      final primary = mailboxes.firstWhere(
        (a) => a.isPrimary,
        orElse: () => mailboxes.first,
      );
      return sortFolders(await backend.folders(primary.id));
    } finally {
      if (account is ImapAccount && !identical(account, current)) {
        unawaited(account.backend.disconnect());
      }
    }
  }

  /// Signs [account] out but keeps it on the phone. Defaults to the account
  /// on screen; the others stay signed in.
  Future<void> signOut([SignedInAccount? account]) => _signOut(account);

  /// Signs [account] out and removes its saved entry from this phone.
  Future<void> removeAccount([SignedInAccount? account]) =>
      _signOut(account, remove: true);

  Future<void> _signOut(SignedInAccount? account, {bool remove = false}) async {
    account ??= current;
    if (account == null) return;
    _signingOut.add(account);
    try {
      // An IMAP account has no session on the server to end; forgetting
      // its password here is signing out. One signed in with Google gives
      // its refresh token back, so it stops working there too. A REST Mail
      // one takes this phone off its server's push list first, while its
      // session still can.
      switch (account) {
        case RestAccount(:final client):
          await push.unregister(account);
          await client.logout();
        case ImapAccount(:final oauth?):
          await _revoke(oauth);
        case ImapAccount():
      }
    } finally {
      _signingOut.remove(account);
    }
    if (remove) {
      await _end(account);
    } else if (account case RestAccount()) {
      _accessEnded(account, _SavedSession(account.server, account.user, null));
    } else if (account case ImapAccount()) {
      final saved = _SavedImap(
        address: account.address,
        displayName: account.displayName,
        settings: account.settings,
        provider: account.provider?.id,
        oauth: account.oauth == null
            ? null
            : _SavedOAuth(account.oauth!.kind, null),
        signedOut: true,
      );
      final index = accounts.indexOf(account);
      final signedOut = _openImap(saved);
      accounts = [...accounts]..[index] = signedOut;
      if (identical(current, account)) _show(signedOut);
      account.close();
      await store.write(_accountKey(saved.key), saved.encode());
      notifyListeners();
    }
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
      capabilities: saved.tokens?.capabilities ?? Capabilities.none,
    );
  }

  ImapAccount _openImap(_SavedImap saved, {AccessGrant? access}) {
    late final ImapAccount account;
    final signIn = saved.oauth;
    final session = signIn == null
        ? null
        : OAuthSession(
            kind: signIn.kind,
            provider: oauth[signIn.kind],
            refreshToken: signIn.refreshToken,
            httpClient: httpClientFactory,
            access: access,
            onRefreshTokenChanged: (token) =>
                _refreshTokenChanged(account, saved, token),
            onEnded: () => _accessEnded(account, saved.withRefreshToken(null)),
          );
    return account = ImapAccount._(
      ImapBackend(
        address: saved.address,
        displayName: saved.displayName,
        password: saved.password,
        accessToken: session?.accessToken,
        settings: saved.settings,
        openSocket: mailSockets,
        signedOut:
            saved.signedOut ||
            (saved.password == null && saved.oauth?.refreshToken == null),
      ),
      provider: MailProviders.byId(saved.provider),
      wasSignedOut: saved.signedOut,
      oauth: session,
    );
  }

  /// Keeps the refresh token Microsoft sends with each new access token:
  /// the one before it may soon stop working.
  void _refreshTokenChanged(
    ImapAccount account,
    _SavedImap saved,
    String token,
  ) {
    // An account already ended or replaced is never saved, so it can't
    // overwrite the one that took its place.
    if (!accounts.contains(account)) return;
    final next = saved.withRefreshToken(token);
    unawaited(store.write(_accountKey(next.key), next.encode()));
  }

  /// [account] can no longer reach its mail: its session ended, or its
  /// owner took REST Mail's access away at Microsoft or Google, or changed
  /// their password. Taking access away isn't removing the account from the
  /// phone, so it stays, signed out, with everything saved for it but the
  /// credential that stopped working ([saved]), until it is signed in again
  /// or removed.
  void _accessEnded(SignedInAccount account, _Saved saved) {
    if (_signingOut.contains(account) || !accounts.contains(account)) return;
    notifyListeners();
    // The one on screen says so in place of its mail.
    if (!identical(account, current)) _notices.add(account.signedOut!);
    unawaited(
      _queueWrite(account, () async {
        // Taken off the phone while this waited: it is not brought back.
        if (!accounts.contains(account)) return;
        await store.write(_accountKey(saved.key), saved.encode());
      }),
    );
    if (account is RestAccount) unawaited(push.forget(account));
  }

  /// The Keychain writes still to land for each account, in the order they
  /// were asked for.
  final _pendingWrites = <String, Future<void>>{};

  /// Writes to [account]'s entry one after another, so an older session can
  /// never land on top of a newer one, whatever order the Keychain finishes
  /// them in.
  Future<void> _queueWrite(
    SignedInAccount account,
    Future<void> Function() write,
  ) {
    final previous = _pendingWrites[account.key];
    final next = () async {
      if (previous != null) {
        try {
          await previous;
        } on Object {
          // Reported to whoever asked for it; this write goes ahead.
        }
      }
      await write();
    }();
    _pendingWrites[account.key] = next;
    return next;
  }

  /// Sessions that renewal is under way for, so a second resume while the
  /// first is still renewing waits on it rather than asking again.
  Future<void>? _renewing;

  /// The app is back on screen: each signed-in REST Mail account whose access
  /// token ran out, or is about to, while it was away is renewed now, rather
  /// than by the first request to be refused.
  ///
  /// A server that can't be reached leaves the session, and its refresh
  /// token, as they were; only a refresh the server refuses signs the account
  /// out.
  Future<void> resumed() =>
      _renewing ??= _renewAll().whenComplete(() => _renewing = null);

  Future<void> _renewAll() => Future.wait([
    for (final account in accounts)
      if (account is RestAccount && account.signedOut == null) _renew(account),
  ]);

  Future<void> _renew(RestAccount account) async {
    try {
      await account.client.renewIfExpiring();
    } on SessionExpiredException {
      // Already signed out, through the client's onTokensChanged.
    } on ApiException {
      // Unreachable for now: the next request tries again.
    }
  }

  /// Gives a refresh token back, where the provider takes them back
  /// (Google). Best effort: signing out goes ahead whatever it answers.
  Future<void> _revoke(OAuthSession session) async {
    final endpoint = session.provider?.revocationEndpoint;
    final token = session.refreshToken;
    if (endpoint == null || token == null) return;
    final http = httpClientFactory();
    try {
      await http
          .post(endpoint, body: {'token': token})
          .timeout(const Duration(seconds: 10));
    } on Object {
      // Signed out on the phone all the same.
    } finally {
      http.close();
    }
  }

  /// Starts [account]'s mail, at [folder], and stops the previous account's.
  void _show(
    SignedInAccount account, {
    String folder = StandardFolder.inbox,
    bool keepNavigator = false,
  }) {
    final previous = mailbox;
    final previousAccount = current;
    current = account;
    final next = mailbox = MailboxState(account.backend)..folder = folder;
    // Signed out, it has nothing to load until it signs in again.
    if (account.signedOut == null) unawaited(next.start());
    phase = AppPhase.signedIn;
    if (!keepNavigator) _sessions++;
    // Keeping the navigator means the screen that asked is still on it, so
    // the old mailbox is let go after that screen has rebuilt with the new
    // one.
    if (keepNavigator) {
      Future<void>.delayed(Duration.zero, () => previous?.dispose());
    } else {
      previous?.dispose();
    }
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
        _queueWrite(account, () async {
          // A newer pair, or the end of the session, came in while this one
          // waited its turn, or the account was taken off the phone: what
          // the Keychain keeps is whatever came last.
          if (!accounts.contains(account) ||
              !identical(account.client.tokens, tokens)) {
            return;
          }
          await store.write(
            _accountKey(account.key),
            _SavedSession(account.server, account.user, tokens).encode(),
          );
        }),
      );
      // The server re-reads the grants at every refresh: what it took away
      // goes from the screens now.
      if (tokens.capabilities != account.capabilities) {
        account.capabilities = tokens.capabilities;
        notifyListeners();
      }
    } else {
      _accessEnded(account, _SavedSession(account.server, account.user, null));
    }
  }

  /// Takes [account] off the phone.
  Future<void> _end(SignedInAccount account) async {
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
        _sessions++;
      }
    }
    notifyListeners();
    account.close();
    // A write already under way lands before the entry goes, not after.
    await _queueWrite(account, () async {
      // A new sign-in may have replaced the account while an older write
      // was finishing. Its entry belongs to the new session now.
      if (accounts.any((kept) => kept.key == account.key)) return;
      await store.delete(_accountKey(account.key));
    });
    await push.forget(account);
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
  /// had to be dropped. An entry that can't be read, or isn't the account its
  /// key names, is deleted: that account signs in again, and the others are
  /// kept.
  Future<(List<_Saved>, String?, bool)> _readSaved() async {
    final (order, currentKey) = _decodeIndex(await _read(_accountsKey));
    final saved = <_Saved>[];
    var dropped = false;
    for (final key in order) {
      final session = _Saved.decode(await _read(_accountKey(key)));
      if (session == null || session.key != key) {
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
    push.dispose();
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

/// A REST Mail account, with its session's tokens while it is signed in.
class _SavedSession extends _Saved {
  const _SavedSession(this.server, this.user, this.tokens);

  factory _SavedSession.fromJson(Map<String, dynamic> json) => _SavedSession(
    Uri.parse(json['server'] as String),
    User.fromJson(json['user'] as Map<String, dynamic>),
    switch (json['tokens']) {
      null => null,
      final tokens => SessionTokens.fromJson(tokens as Map<String, dynamic>),
    },
  );

  final Uri server;
  final User user;

  /// Null once the session has ended.
  final SessionTokens? tokens;

  @override
  String get key => _keyOf(server, user.email);

  @override
  String encode() => jsonEncode({
    'kind': AccountKind.rest.name,
    'server': server.toString(),
    'user': user.toJson(),
    'tokens': ?tokens?.toJson(),
  });
}

/// An IMAP account's sign-in with Microsoft or Google: who, and the
/// refresh token while it works.
class _SavedOAuth {
  const _SavedOAuth(this.kind, this.refreshToken);

  static _SavedOAuth? fromJson(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    final kind = OAuthKind.values
        .where((k) => k.name == json['provider'])
        .firstOrNull;
    final token = json['refresh_token'];
    if (kind == null) return null;
    if (token != null && (token is! String || token.isEmpty)) return null;
    return _SavedOAuth(kind, token as String?);
  }

  final OAuthKind kind;

  /// Null once Microsoft or Google stopped taking it.
  final String? refreshToken;

  Map<String, String> toJson() => {
    'provider': kind.name,
    'refresh_token': ?refreshToken,
  };
}

/// An IMAP account with its password, or with its sign-in with Microsoft
/// or Google; never both.
class _SavedImap extends _Saved {
  const _SavedImap({
    required this.address,
    required this.displayName,
    this.password,
    this.oauth,
    required this.settings,
    this.provider,
    this.signedOut = false,
  }) : assert(
         signedOut ? password == null : (password == null) != (oauth == null),
       );

  static _SavedImap? fromJson(Map<String, dynamic> json) {
    final settings = MailServerSettings.fromJson(json['settings']);
    final password = json['password'] as String?;
    final oauth = _SavedOAuth.fromJson(json['oauth']);
    final signedOut = json['signed_out'] as bool? ?? false;
    if (settings == null ||
        (signedOut
            ? password != null || (oauth != null && oauth.refreshToken != null)
            : (password == null) == (oauth == null))) {
      return null;
    }
    return _SavedImap(
      address: json['address'] as String,
      displayName: json['display_name'] as String? ?? '',
      password: password,
      oauth: oauth,
      settings: settings,
      provider: json['provider'] as String?,
      signedOut: signedOut,
    );
  }

  final String address;
  final String displayName;
  final String? password;
  final _SavedOAuth? oauth;
  final MailServerSettings settings;
  final String? provider;
  final bool signedOut;

  _SavedImap withRefreshToken(String? token) => _SavedImap(
    address: address,
    displayName: displayName,
    oauth: _SavedOAuth(oauth!.kind, token),
    settings: settings,
    provider: provider,
    signedOut: false,
  );

  @override
  String get key =>
      _keyOf(Uri(scheme: 'imaps', host: settings.imapHost), address);

  @override
  String encode() => jsonEncode({
    'kind': AccountKind.imap.name,
    'address': address,
    'display_name': displayName,
    'password': ?password,
    'oauth': ?oauth?.toJson(),
    'settings': settings.toJson(),
    'provider': ?provider,
    'signed_out': signedOut,
  });
}
