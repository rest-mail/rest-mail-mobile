import 'dart:async';
import 'dart:convert';
import 'dart:io' show HandshakeException;
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'events.dart';
import 'models.dart';
import 'session.dart';

/// Called whenever the session's tokens change: after sign-in, after every
/// refresh (rest-mail rotates the refresh token each time), and with null
/// when the session ends. Persist what it is given, or the next launch starts
/// from a refresh token the server has already retired.
typedef TokensChanged = void Function(SessionTokens? tokens);

/// What `GET /api/health` reports.
class ServerHealth {
  const ServerHealth({required this.status, this.database});

  /// `healthy` when the server can do its job.
  final String status;
  final String? database;

  bool get isHealthy => status == 'healthy';
}

/// A connection to one rest-mail server on behalf of one user.
class RestmailClient {
  RestmailClient({
    required this.server,
    http.Client? httpClient,
    SessionTokens? tokens,
    this.onTokensChanged,
    this.userAgent = 'restmail-mobile',
    this.timeout = const Duration(seconds: 30),
  }) : _http = httpClient ?? http.Client(),
       _tokens = tokens;

  /// The server's base URL, as [parseServerUrl] returns it.
  final Uri server;
  final TokensChanged? onTokensChanged;
  final String userAgent;

  /// How long an ordinary request may take. The event stream is exempt, and
  /// attachment downloads get longer.
  final Duration timeout;

  final http.Client _http;
  SessionTokens? _tokens;
  Future<SessionTokens>? _refreshing;

  /// An access token this close to expiry is renewed before use rather than
  /// sent to be refused.
  static const _refreshMargin = Duration(seconds: 30);

  /// A healthy event stream carries a keepalive every 30 seconds, so this long
  /// without a byte means the connection died without closing.
  static const _streamSilenceLimit = Duration(seconds: 75);

  static const _downloadTimeout = Duration(minutes: 5);

  SessionTokens? get tokens => _tokens;

  /// Asks whether this is a rest-mail server that is up. Needs no session.
  /// Throws [ApiException] when the answer is no, or not rest-mail's.
  Future<ServerHealth> health() async {
    final response = await _send(
      'GET',
      server.replace(pathSegments: [...server.pathSegments, 'api', 'health']),
    );
    _throwIfError(response);
    final data = _data(response);
    final status = data['status'];
    if (status is! String) throw _unreadable(response);
    return ServerHealth(status: status, database: data['db'] as String?);
  }

  // ── Session ──────────────────────────────────────────────────────────

  /// Signs in with a mailbox address and password.
  ///
  /// Throws [TotpRequiredException] when the password was right but the
  /// account has two-factor authentication; call again with [totpCode] or
  /// [recoveryCode].
  Future<LoginResult> login({
    required String email,
    required String password,
    String? totpCode,
    String? recoveryCode,
  }) async {
    final response = await _send(
      'POST',
      _uri(['auth', 'login']),
      body: {
        'email': email,
        'password': password,
        if (totpCode != null && totpCode.isNotEmpty) 'totp_code': totpCode,
        if (recoveryCode != null && recoveryCode.isNotEmpty)
          'recovery_code': recoveryCode,
      },
    );
    _throwIfError(response);
    final data = _data(response);
    final tokens = _tokensFrom(response, data);
    _setTokens(tokens);
    return LoginResult(
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      tokens: tokens,
    );
  }

  /// Ends the session here, then tells the server. The server call is best
  /// effort: the local session is gone whether or not it gets through.
  Future<void> logout() async {
    final tokens = _tokens;
    if (tokens == null) return;
    _setTokens(null);
    try {
      await _send(
        'POST',
        _uri(['auth', 'logout']),
        headers: {'Cookie': '$refreshCookieName=${tokens.refreshToken}'},
      );
    } on ApiException {
      // The refresh token will expire on its own.
    }
  }

  /// Trades the refresh token for a new pair.
  ///
  /// Concurrent callers share one request: the server retires a refresh token
  /// the moment it is used, so a second request with the same one would fail.
  Future<SessionTokens> refresh() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<SessionTokens> _refresh() async {
    final current = _tokens;
    if (current == null) throw const SessionExpiredException();
    final response = await _send(
      'POST',
      _uri(['auth', 'refresh']),
      headers: {'Cookie': '$refreshCookieName=${current.refreshToken}'},
    );
    if (response.statusCode == 401 || response.statusCode == 403) {
      _setTokens(null);
      throw const SessionExpiredException();
    }
    _throwIfError(response);
    final tokens = _tokensFrom(
      response,
      _data(response),
      previousRefreshToken: current.refreshToken,
    );
    // Signed out while the refresh was in flight: stay signed out.
    if (_tokens == null) throw const SessionExpiredException();
    _setTokens(tokens);
    return tokens;
  }

  // ── Accounts and folders ─────────────────────────────────────────────

  Future<List<Account>> accounts() async =>
      _list(await _authed('GET', ['accounts']), Account.fromJson);

  /// Adds another mailbox on this server to the session, proving access to it
  /// with its own password.
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
  }) async => Account.fromJson(
    _data(
      await _authed(
        'POST',
        ['accounts'],
        body: {
          'address': address,
          'password': password,
          'display_name': ?displayName,
        },
      ),
    ),
  );

  /// Removes a linked mailbox from the session. The primary one cannot be.
  Future<void> unlinkAccount(int id) async {
    await _authed('DELETE', ['accounts', '$id']);
  }

  Future<List<Folder>> folders(int accountId) async => _list(
    await _authed('GET', ['accounts', '$accountId', 'folders']),
    Folder.fromJson,
  );

  Future<QuotaInfo> quota(int accountId) async => QuotaInfo.fromJson(
    _data(await _authed('GET', ['accounts', '$accountId', 'quota'])),
  );

  // ── Messages ─────────────────────────────────────────────────────────

  /// One page of a folder, newest first. Pass the previous page's cursor to
  /// get the next.
  Future<Paged<Message>> messages(
    int accountId,
    String folder, {
    int limit = 50,
    String? cursor,
  }) async => _messagePage(
    await _authed(
      'GET',
      ['accounts', '$accountId', 'folders', folder, 'messages'],
      query: {'limit': '$limit', 'cursor': ?cursor},
    ),
  );

  Future<Message> message(int id) async =>
      Message.fromJson(_data(await _authed('GET', ['messages', '$id'])));

  /// Every message in a conversation.
  Future<List<Message>> thread(int accountId, String threadId) async => _list(
    await _authed('GET', ['accounts', '$accountId', 'threads', threadId]),
    Message.fromJson,
  );

  Future<Paged<Message>> search(
    int accountId,
    SearchQuery query, {
    int limit = 50,
    String? cursor,
  }) async => _messagePage(
    await _authed(
      'GET',
      ['accounts', '$accountId', 'search'],
      query: {
        ...query.toQueryParameters(),
        'limit': '$limit',
        'cursor': ?cursor,
      },
    ),
  );

  /// Changes flags, or moves the message by naming another [folder].
  Future<Message> updateMessage(
    int id, {
    bool? isRead,
    bool? isFlagged,
    bool? isStarred,
    String? folder,
  }) async => Message.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['messages', '$id'],
        body: {
          'is_read': ?isRead,
          'is_flagged': ?isFlagged,
          'is_starred': ?isStarred,
          'folder': ?folder,
        },
      ),
    ),
  );

  /// Moves a message to Trash. Deleting one that is already in Trash removes
  /// it for good.
  Future<void> deleteMessage(int id) async {
    await _authed('DELETE', ['messages', '$id']);
  }

  Future<Message> send(OutgoingMessage message) async => Message.fromJson(
    _data(
      await _authed('POST', ['messages', 'send'], body: message.toSendJson()),
    ),
  );

  Future<Message> saveDraft(OutgoingMessage draft) async => Message.fromJson(
    _data(
      await _authed('POST', ['messages', 'draft'], body: draft.toDraftJson()),
    ),
  );

  Future<Message> updateDraft(int id, OutgoingMessage draft) async =>
      Message.fromJson(
        _data(
          await _authed('PUT', [
            'messages',
            'draft',
            '$id',
          ], body: draft.toDraftJson()),
        ),
      );

  Future<Message> sendDraft(int id) async => Message.fromJson(
    _data(await _authed('POST', ['messages', 'draft', '$id', 'send'])),
  );

  // ── Attachments ──────────────────────────────────────────────────────

  Future<List<Attachment>> attachments(int messageId) async => _list(
    await _authed('GET', ['messages', '$messageId', 'attachments']),
    Attachment.fromJson,
  );

  Future<Uint8List> downloadAttachment(int id) async => (await _authed(
    'GET',
    ['attachments', '$id'],
    accept: '*/*',
    timeout: _downloadTimeout,
  )).bodyBytes;

  // ── Live events ──────────────────────────────────────────────────────

  /// Changes to one account's mailbox, pushed by the server for as long as
  /// the stream has a listener.
  ///
  /// When the connection drops it reconnects on its own and asks the server
  /// to replay what was missed; transient failures are retried with backoff
  /// rather than reported. [onLiveChanged] hears when the connection comes up
  /// and when it drops, for a status line. The stream ends with a
  /// [SessionExpiredException] error once the session cannot be renewed.
  Stream<MailEvent> events(
    int accountId, {
    Duration retryDelay = const Duration(seconds: 1),
    Duration maxRetryDelay = const Duration(minutes: 1),
    void Function(bool live)? onLiveChanged,
  }) {
    late final StreamController<MailEvent> controller;
    final stop = Completer<void>();
    String? lastEventId;
    var live = false;

    void setLive(bool value) {
      if (live == value || stop.isCompleted) return;
      live = value;
      onLiveChanged?.call(value);
    }

    Future<void> run() async {
      var failures = 0;
      var refusedInARow = 0;
      while (!stop.isCompleted) {
        try {
          final tokens = await _currentTokens();
          final request =
              http.AbortableRequest(
                  'GET',
                  _uri(['accounts', '$accountId', 'events']),
                  abortTrigger: stop.future,
                )
                ..headers.addAll({
                  ..._headers(accept: 'text/event-stream'),
                  'Authorization': 'Bearer ${tokens.accessToken}',
                  'Cache-Control': 'no-cache',
                  'Last-Event-ID': ?lastEventId,
                });
          final response = await _http.send(request).timeout(timeout);
          if (response.statusCode == 401) {
            await response.stream.drain<void>();
            if (++refusedInARow > 1) {
              _setTokens(null);
              throw const SessionExpiredException();
            }
            await refresh();
            continue;
          }
          if (response.statusCode != 200) {
            final body = await response.stream.toBytes();
            throw ApiException.fromResponse(
              response.statusCode,
              utf8.decode(body, allowMalformed: true),
              reason: response.reasonPhrase,
            );
          }
          refusedInARow = 0;
          failures = 0;
          setLive(true);
          final stream = decodeServerSentEvents(
            response.stream.timeout(_streamSilenceLimit),
          );
          await for (final sse in stream) {
            lastEventId = sse.id ?? lastEventId;
            if (MailEvent.fromServerSentEvent(sse) case final event?) {
              controller.add(event);
            }
          }
        } on SessionExpiredException catch (error) {
          if (!stop.isCompleted) controller.addError(error);
          break;
        } on http.RequestAbortedException {
          break;
        } catch (_) {
          // A dropped connection, a silent one, a server error: retry.
          failures++;
        }
        if (stop.isCompleted) break;
        setLive(false);
        await Future.any([
          Future<void>.delayed(_backoff(retryDelay, maxRetryDelay, failures)),
          stop.future,
        ]);
      }
      await controller.close();
    }

    controller = StreamController<MailEvent>(
      onListen: () => unawaited(run()),
      onCancel: () {
        if (!stop.isCompleted) stop.complete();
      },
    );
    return controller.stream;
  }

  /// Releases the connection pool. The client cannot be used afterwards.
  void close() => _http.close();

  // ── Plumbing ─────────────────────────────────────────────────────────

  Uri _uri(List<String> segments, [Map<String, String>? query]) =>
      server.replace(
        pathSegments: [...server.pathSegments, 'api', 'v1', ...segments],
        queryParameters: (query == null || query.isEmpty) ? null : query,
      );

  Map<String, String> _headers({String accept = 'application/json'}) => {
    'Accept': accept,
    'User-Agent': userAgent,
  };

  Future<SessionTokens> _currentTokens() async {
    final tokens = _tokens;
    if (tokens == null) throw const SessionExpiredException();
    return tokens.expiresWithin(_refreshMargin) ? refresh() : tokens;
  }

  /// Sends a request as the signed-in user, renewing the session once if the
  /// server says the access token is no longer good.
  ///
  /// Only a refused renewal ends the session. A 401 that comes back even with
  /// a fresh token is the request's own refusal — linking a mailbox with the
  /// wrong password answers 401 — and is reported like any other error.
  Future<http.Response> _authed(
    String method,
    List<String> path, {
    Map<String, String>? query,
    Object? body,
    String accept = 'application/json',
    Duration? timeout,
  }) async {
    final uri = _uri(path, query);
    Future<http.Response> attempt(SessionTokens tokens) => _send(
      method,
      uri,
      body: body,
      accept: accept,
      timeout: timeout,
      headers: {'Authorization': 'Bearer ${tokens.accessToken}'},
    );

    final sentWith = await _currentTokens();
    var response = await attempt(sentWith);
    if (response.statusCode == 401) {
      // Another request may already have renewed the session.
      final latest = _tokens;
      final renewed =
          latest != null && latest.accessToken != sentWith.accessToken
          ? latest
          : await refresh();
      response = await attempt(renewed);
    }
    _throwIfError(response);
    return response;
  }

  Future<http.Response> _send(
    String method,
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
    String accept = 'application/json',
    Duration? timeout,
  }) async {
    final limit = timeout ?? this.timeout;
    final request = http.Request(method, uri)
      ..headers.addAll({..._headers(accept: accept), ...?headers});
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    try {
      final streamed = await _http.send(request).timeout(limit);
      return await http.Response.fromStream(streamed).timeout(limit);
    } on TimeoutException {
      throw const ApiException(
        0,
        'timeout',
        'The server took too long to answer',
      );
    } on HandshakeException catch (error) {
      throw ApiException(
        0,
        'tls_error',
        "The server's certificate is not trusted: ${error.message}",
      );
    } on http.ClientException catch (error) {
      throw ApiException(0, 'network_error', error.message);
    }
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode < 400) return;
    throw ApiException.fromResponse(
      response.statusCode,
      utf8.decode(response.bodyBytes, allowMalformed: true),
      reason: response.reasonPhrase,
    );
  }

  /// The whole JSON body, decoded as UTF-8 whatever the Content-Type says:
  /// package:http falls back to Latin-1 when no charset is named, which would
  /// mangle every non-ASCII subject.
  Map<String, dynamic> _envelope(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Reported below.
    }
    throw _unreadable(response);
  }

  /// The `data` member of rest-mail's `{"data": ...}` envelope.
  Map<String, dynamic> _data(http.Response response) {
    final data = _envelope(response)['data'];
    if (data is Map<String, dynamic>) return data;
    throw _unreadable(response);
  }

  List<T> _list<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) => _items(_envelope(response)['data'], response, fromJson);

  Paged<Message> _messagePage(http.Response response) {
    final envelope = _envelope(response);
    final pagination = envelope['pagination'];
    final page = pagination is Map<String, dynamic>
        ? pagination
        : const <String, dynamic>{};
    return Paged(
      _items(envelope['data'], response, Message.fromJson),
      cursor: switch (page['cursor']) {
        final String cursor when cursor.isNotEmpty => cursor,
        _ => null,
      },
      hasMore: page['has_more'] == true,
      total: (page['total'] as num?)?.toInt(),
    );
  }

  List<T> _items<T>(
    Object? data,
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data == null) return []; // Go encodes an empty slice as null.
    if (data is! List) throw _unreadable(response);
    return [for (final item in data) fromJson(item as Map<String, dynamic>)];
  }

  ApiException _unreadable(http.Response response) => ApiException(
    response.statusCode,
    'bad_response',
    'The server sent a response this app does not understand',
  );

  SessionTokens _tokensFrom(
    http.Response response,
    Map<String, dynamic> data, {
    String? previousRefreshToken,
  }) {
    final cookies = parseSetCookies(
      response.headersSplitValues['set-cookie'] ?? const [],
    );
    final access = cookies[accessCookieName];
    final refresh = cookies[refreshCookieName] ?? previousRefreshToken;
    if (access == null || refresh == null) {
      throw ApiException(
        response.statusCode,
        'missing_tokens',
        'The server accepted the sign-in but sent no session',
      );
    }
    final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 0;
    return SessionTokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }

  void _setTokens(SessionTokens? tokens) {
    _tokens = tokens;
    onTokensChanged?.call(tokens);
  }

  static final _jitter = Random();

  /// Doubles per consecutive failure up to [ceiling], give or take a fifth so
  /// a server restart is not met by every client at the same instant.
  static Duration _backoff(Duration base, Duration ceiling, int failures) {
    final doubled = base * pow(2, max(0, failures - 1)).toDouble();
    final capped = doubled > ceiling ? ceiling : doubled;
    return capped * (0.8 + 0.4 * _jitter.nextDouble());
  }
}
