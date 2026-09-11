import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:restmail_api/restmail_api.dart';

import 'mailbox_state.dart';
import 'settings.dart';
import 'storage.dart';

enum AppPhase { starting, signedOut, signedIn }

/// Who is signed in to which server, and the settings — everything that
/// outlives a single screen.
class AppState extends ChangeNotifier {
  AppState({required this.store, required this.httpClientFactory});

  final KeyValueStore store;

  /// Makes the HTTP client each server connection uses, so TLS trust is set
  /// in one place (and tests can hand in a fake).
  final http.Client Function() httpClientFactory;

  static const _sessionKey = 'session';
  static const _settingsKey = 'settings';
  static const userAgent = 'restmail-mobile/0.1.0';

  AppPhase phase = AppPhase.starting;
  AppSettings settings = const AppSettings();

  Uri? server;
  User? user;
  RestmailClient? client;
  MailboxState? mailbox;

  /// Why the last session ended when the user did not end it themselves.
  String? signedOutReason;

  int _sessions = 0;
  bool _signingOut = false;

  /// Changes whenever a session starts or ends; keys the navigator.
  Object get sessionKey => (phase, _sessions);

  Future<void> start() async {
    settings = AppSettings.decode(await store.read(_settingsKey));
    final saved = _SavedSession.decode(await store.read(_sessionKey));
    if (saved == null) {
      phase = AppPhase.signedOut;
    } else {
      _open(saved.server, saved.user, saved.tokens);
    }
    notifyListeners();
  }

  /// A client for [server] with no session, for discovery and health checks.
  RestmailClient probe(Uri server) => RestmailClient(
    server: server,
    httpClient: httpClientFactory(),
    userAgent: userAgent,
  );

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
      await store.write(
        _sessionKey,
        _SavedSession(server, result.user, result.tokens).encode(),
      );
      signedOutReason = null;
      _open(server, result.user, result.tokens);
      notifyListeners();
    } finally {
      candidate.close();
    }
  }

  Future<void> signOut() async {
    _signingOut = true;
    try {
      await client?.logout();
    } finally {
      _signingOut = false;
    }
    await _end();
  }

  Future<void> updateSettings(AppSettings next) async {
    settings = next;
    notifyListeners();
    await store.write(_settingsKey, next.encode());
  }

  void _open(Uri server, User user, SessionTokens tokens) {
    this.server = server;
    this.user = user;
    final client = RestmailClient(
      server: server,
      httpClient: httpClientFactory(),
      tokens: tokens,
      onTokensChanged: _tokensChanged,
      userAgent: userAgent,
    );
    this.client = client;
    mailbox = MailboxState(client)..start();
    phase = AppPhase.signedIn;
    _sessions++;
  }

  void _tokensChanged(SessionTokens? tokens) {
    final server = this.server, user = this.user;
    if (tokens != null && server != null && user != null) {
      unawaited(
        store.write(_sessionKey, _SavedSession(server, user, tokens).encode()),
      );
    } else if (tokens == null && !_signingOut && phase == AppPhase.signedIn) {
      unawaited(_end(reason: 'Your session ended. Sign in again to carry on.'));
    }
  }

  Future<void> _end({String? reason}) async {
    final mailbox = this.mailbox, client = this.client;
    this.mailbox = null;
    this.client = null;
    user = null;
    phase = AppPhase.signedOut;
    signedOutReason = reason;
    _sessions++;
    notifyListeners();
    // The mailbox stops listening before the connection it listens on closes.
    mailbox?.dispose();
    client?.close();
    await store.delete(_sessionKey);
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

  String encode() => jsonEncode({
    'server': server.toString(),
    'user': user.toJson(),
    'tokens': tokens.toJson(),
  });
}
