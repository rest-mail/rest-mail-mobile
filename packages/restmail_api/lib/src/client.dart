import 'dart:async';
import 'dart:convert';
import 'dart:io' show HandshakeException, HttpDate, HttpException;
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'admin_models.dart';
import 'capabilities.dart';
import 'errors.dart';
import 'events.dart';
import 'models.dart';
import 'push.dart';
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

  /// Signs an account in by its address and password. There is no other
  /// kind of sign-in: an administrator is an account like any other, and
  /// what it may administer comes with the session's capabilities.
  ///
  /// Throws [TotpRequiredException] when the password was right but the
  /// account has two-factor authentication; call again with [totpCode] or
  /// [recoveryCode]. An account still in setup (a fresh install's bootstrap
  /// one) is signed in all the same, and [LoginResult.setupRequired] says
  /// what it owes; until then those steps are all its session can do.
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
        'client': 'native',
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
      setupRequired: SetupStep.fromJson(data['setup_required']),
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
        body: {'refresh_token': tokens.refreshToken},
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
      body: {'refresh_token': current.refreshToken},
    );
    // Signed out, or handed another session, while the refresh was in
    // flight: the answer is about tokens that are no longer this session's,
    // so it neither ends nor overwrites what took their place.
    if (!identical(_tokens, current)) {
      final latest = _tokens;
      if (latest == null) throw const SessionExpiredException();
      return latest;
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      _setTokens(null);
      throw const SessionExpiredException();
    }
    _throwIfError(response);
    final tokens = _tokensFrom(response, _data(response));
    _setTokens(tokens);
    return tokens;
  }

  /// Renews the session now if its access token runs out within [margin], as
  /// when the app comes back to the foreground after a while away. It shares
  /// any refresh already in flight, so calling it again costs nothing more.
  ///
  /// Throws [SessionExpiredException] when the server refuses the refresh
  /// token, and [ApiException] when it can't be reached; then the session is
  /// kept as it was, to be renewed by the next request.
  Future<void> renewIfExpiring({
    Duration margin = const Duration(minutes: 2),
  }) async {
    final tokens = _tokens;
    if (tokens == null || !tokens.expiresWithin(margin)) return;
    await refresh();
  }

  // ── Setup ────────────────────────────────────────────────────────────

  /// Starts enrolling an authenticator. Show the result once, then
  /// [confirmTwoFactor] with a code the authenticator produces.
  Future<TotpEnrollment> enrollTwoFactor() async => TotpEnrollment.fromJson(
    _data(await _authed('POST', ['auth', '2fa', 'enroll'])),
  );

  /// Finishes enrolling: from now on signing in also takes a code. A wrong
  /// code is 403 `invalid_totp`, never 401: the session is still good.
  Future<void> confirmTwoFactor(String code) async {
    await _authed(
      'POST',
      ['auth', '2fa', 'confirm'],
      body: {'totp_code': code},
    );
  }

  /// Replaces the signed-in account's password. The server ends every
  /// session of the account, this one included, so this client is signed out
  /// after it: sign in again with [next]. A wrong [current] is 403
  /// `invalid_password`, never 401: the session is still good.
  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    await _authed(
      'POST',
      ['auth', 'password'],
      body: {'current_password': current, 'new_password': next},
    );
    _setTokens(null);
  }

  // ── Admin ────────────────────────────────────────────────────────────
  //
  // Each call needs a capability (see [Capability]); without it the server
  // answers 403, whatever the app showed.

  /// One page of the outbound queue, newest first, optionally only those in
  /// [status]. Needs `queue:read`.
  Future<OffsetPage<QueueEntry>> queue({
    QueueStatus? status,
    int offset = 0,
    int limit = 50,
  }) async {
    final data = _data(
      await _authed(
        'GET',
        ['admin', 'queue'],
        query: {
          'status': ?status?.name,
          'limit': '$limit',
          'offset': '$offset',
        },
      ),
    );
    final items = data['items'];
    return OffsetPage(
      [
        if (items is List)
          for (final item in items)
            QueueEntry.fromJson(item as Map<String, dynamic>),
      ],
      offset: (data['offset'] as num?)?.toInt() ?? offset,
      total: (data['total'] as num?)?.toInt() ?? 0,
    );
  }

  /// How many entries are in each state. Needs `queue:read`.
  Future<QueueStats> queueStats() async => QueueStats.fromJson(
    _data(await _authed('GET', ['admin', 'queue', 'stats'])),
  );

  Future<QueueEntry> queueEntry(int id) async => QueueEntry.fromJson(
    _data(await _authed('GET', ['admin', 'queue', '$id'])),
  );

  /// Tries a waiting entry again now. Needs `queue:manage`.
  Future<void> retryQueueEntry(int id) async {
    await _authed('POST', ['admin', 'queue', '$id', 'retry']);
  }

  /// Gives up on an entry and bounces it to its sender. Needs `queue:manage`.
  Future<void> bounceQueueEntry(int id) async {
    await _authed('POST', ['admin', 'queue', '$id', 'bounce']);
  }

  /// Drops an entry without telling its sender. Needs `queue:manage`.
  Future<void> deleteQueueEntry(int id) async {
    await _authed('DELETE', ['admin', 'queue', '$id']);
  }

  /// Needs `domains:read`.
  Future<OffsetPage<AdminDomain>> domains({int offset = 0, int limit = 100}) =>
      _offsetPage(['admin', 'domains'], AdminDomain.fromJson, offset, limit);

  /// Creates a domain whose mail rest-mail serves itself. Throws
  /// [ApiException] with code `already_exists` when it is there already.
  /// Needs `domains:write`.
  Future<void> createDomain(String name) async {
    await _authed(
      'POST',
      ['admin', 'domains'],
      body: {'name': name, 'server_type': 'restmail'},
    );
  }

  /// Turns a domain's mail on or off. Needs `domains:write`.
  Future<AdminDomain> updateDomain(int id, {bool? active}) async =>
      AdminDomain.fromJson(
        _data(
          await _authed(
            'PATCH',
            ['admin', 'domains', '$id'],
            body: {'active': ?active},
          ),
        ),
      );

  /// Needs `domains:delete`.
  Future<void> deleteDomain(int id) async {
    await _authed('DELETE', ['admin', 'domains', '$id']);
  }

  /// Needs `mailboxes:read`.
  Future<OffsetPage<AdminMailbox>> mailboxes({
    int? domainId,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'mailboxes'],
    AdminMailbox.fromJson,
    offset,
    limit,
    {'domain_id': ?domainId?.toString()},
  );

  /// Changes what is given; a new [password] ends the mailbox's sessions.
  /// Needs `mailboxes:write`.
  Future<AdminMailbox> updateMailbox(
    int id, {
    String? displayName,
    String? password,
    bool? active,
  }) async => AdminMailbox.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'mailboxes', '$id'],
        body: {
          'display_name': ?displayName,
          'password': ?password,
          'active': ?active,
        },
      ),
    ),
  );

  /// Deletes the mailbox and its mail. Needs `mailboxes:delete`.
  Future<void> deleteMailbox(int id) async {
    await _authed('DELETE', ['admin', 'mailboxes', '$id']);
  }

  /// Needs `mailboxes:read`.
  Future<OffsetPage<AdminAlias>> aliases({
    int? domainId,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'aliases'],
    AdminAlias.fromJson,
    offset,
    limit,
    {'domain_id': ?domainId?.toString()},
  );

  /// Sends mail for [source], on a domain the server has, to [destination].
  /// Needs `mailboxes:write`.
  Future<void> createAlias({
    required String source,
    required String destination,
  }) async {
    await _authed(
      'POST',
      ['admin', 'aliases'],
      body: {'source_address': source, 'destination_address': destination},
    );
  }

  /// Needs `mailboxes:write`.
  Future<AdminAlias> updateAlias(
    int id, {
    String? destination,
    bool? active,
  }) async => AdminAlias.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'aliases', '$id'],
        body: {'destination_address': ?destination, 'active': ?active},
      ),
    ),
  );

  /// Needs `mailboxes:delete`.
  Future<void> deleteAlias(int id) async {
    await _authed('DELETE', ['admin', 'aliases', '$id']);
  }

  /// The server at a glance. Any admin may read it today; the app shows it
  /// with `observability:read`, where the server's design puts it.
  Future<ServerStats> stats() async =>
      ServerStats.fromJson(_data(await _authed('GET', ['admin', 'stats'])));

  /// The bans in force. Needs `bans:read`.
  Future<OffsetPage<Ban>> bans({int offset = 0, int limit = 100}) =>
      _offsetPage(['admin', 'bans'], Ban.fromJson, offset, limit);

  /// Keeps [ip] out of [protocol] (`all` of them unless named) for
  /// [duration], or for good. Needs `bans:write`.
  Future<void> createBan({
    required String ip,
    required String createdBy,
    String reason = '',
    String protocol = 'all',
    Duration? duration,
  }) async {
    await _authed(
      'POST',
      ['admin', 'bans'],
      body: {
        'ip': ip,
        'reason': reason,
        'protocol': protocol,
        'created_by': createdBy,
        if (duration != null) 'duration': '${duration.inMinutes}m',
      },
    );
  }

  /// Lifts a ban. Needs `bans:delete`.
  Future<void> deleteBan(int id) async {
    await _authed('DELETE', ['admin', 'bans', '$id']);
  }

  /// Mail sent to other servers, newest first, with how each went: the
  /// outbound queue's history. Needs `messages:read`.
  Future<OffsetPage<QueueEntry>> deliveryLog({
    QueueStatus? status,
    String? recipient,
    int offset = 0,
    int limit = 50,
  }) => _offsetPage(
    ['admin', 'logs', 'delivery'],
    QueueEntry.fromJson,
    offset,
    limit,
    {'status': ?status?.name, 'recipient': ?recipient},
  );

  /// How the message stored as [messageId] went through the filters. Throws
  /// [ApiException] 404 for one with no trace: mail that was turned away
  /// never became a message. Needs `observability:read`.
  Future<MessageTrace> messageTrace(int messageId) async =>
      MessageTrace.fromJson(
        _data(
          await _authed('GET', ['admin', 'messages', '$messageId', 'trace']),
        ),
      );

  /// The TLS reports other servers sent, newest first. Needs `domains:read`.
  Future<OffsetPage<TlsReport>> tlsReports({int offset = 0, int limit = 50}) =>
      _offsetPage(['admin', 'tls-reports'], TlsReport.fromJson, offset, limit);

  /// The audit log, newest first, a page at a time: hand the page's cursor
  /// back as [before] for the next. Only entries with [outcome] or by an
  /// [actorKind], when given. The server records the read itself. Needs
  /// `audit:read`.
  Future<Paged<AuditEntry>> audit({
    String? before,
    String? outcome,
    String? actorKind,
    int limit = 50,
  }) async => _cursorPage(
    await _authed(
      'GET',
      ['admin', 'audit'],
      query: {
        'before_seq': ?before,
        'outcome': ?outcome,
        'actor_kind': ?actorKind,
        'limit': '$limit',
      },
    ),
    AuditEntry.fromJson,
  );

  /// Has the server walk the whole audit log and check its chain. Needs
  /// `audit:read`.
  Future<AuditCheck> verifyAudit() async => AuditCheck.fromJson(
    _data(await _authed('GET', ['admin', 'audit', 'verify'])),
  );

  /// The domains that sign their mail. Needs `domains:read`.
  Future<List<DkimKey>> dkimKeys() async =>
      _list(await _authed('GET', ['admin', 'dkim']), DkimKey.fromJson);

  /// Signs [domainId]'s mail with [privateKey], a PEM private key published
  /// under [selector], replacing any key it had. Needs `domains:write`. The
  /// server refuses a key it cannot sign with (422) and never sends the key
  /// back: the answer holds only the selector and when the key was set.
  Future<DkimKey> setDkimKey(
    int domainId, {
    required String selector,
    required String privateKey,
  }) async => DkimKey.fromJson(
    _data(
      await _authed(
        'PUT',
        ['admin', 'dkim', '$domainId'],
        body: {'selector': selector, 'private_key': privateKey},
      ),
    ),
  );

  /// How often [domainId]'s key is due to be replaced. Needs `domains:read`.
  Future<DkimRotation> dkimRotation(int domainId) async =>
      DkimRotation.fromJson(
        _data(await _authed('GET', ['admin', 'dkim', '$domainId', 'rotation'])),
      );

  /// Sets [domainId]'s rotation to every [intervalDays] days, 0 to never
  /// rotate, at most [DkimRotation.maxIntervalDays]. Needs `domains:write`.
  Future<DkimRotation> setDkimRotation(int domainId, int intervalDays) async =>
      DkimRotation.fromJson(
        _data(
          await _authed(
            'PUT',
            ['admin', 'dkim', '$domainId', 'rotation'],
            body: {'rotation_interval_days': intervalDays},
          ),
        ),
      );

  /// Stops signing [domainId]'s mail and forgets its key. Needs
  /// `domains:write`, as the server asks.
  Future<void> deleteDkimKey(int domainId) async {
    await _authed('DELETE', ['admin', 'dkim', '$domainId']);
  }

  /// Needs `domains:read`.
  Future<OffsetPage<TlsCertificate>> certificates({
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'certificates'],
    TlsCertificate.fromJson,
    offset,
    limit,
  );

  /// Needs `domains:write`, as the server asks.
  Future<void> deleteCertificate(int id) async {
    await _authed('DELETE', ['admin', 'certificates', '$id']);
  }

  /// Needs `pipelines:read`.
  Future<OffsetPage<Pipeline>> pipelines({int offset = 0, int limit = 100}) =>
      _offsetPage(['admin', 'pipelines'], Pipeline.fromJson, offset, limit);

  /// Turns a pipeline on or off. Needs `pipelines:write`.
  Future<Pipeline> updatePipeline(int id, {bool? active}) async =>
      Pipeline.fromJson(
        _data(
          await _authed(
            'PATCH',
            ['admin', 'pipelines', '$id'],
            body: {'active': ?active},
          ),
        ),
      );

  /// Needs `pipelines:delete`.
  Future<void> deletePipeline(int id) async {
    await _authed('DELETE', ['admin', 'pipelines', '$id']);
  }

  /// Needs `pipelines:read`.
  Future<OffsetPage<CustomFilter>> customFilters({
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'custom-filters'],
    CustomFilter.fromJson,
    offset,
    limit,
  );

  /// Turns a custom filter on or off. Needs `pipelines:write`.
  Future<CustomFilter> updateCustomFilter(int id, {bool? enabled}) async =>
      CustomFilter.fromJson(
        _data(
          await _authed(
            'PATCH',
            ['admin', 'custom-filters', '$id'],
            body: {'enabled': ?enabled},
          ),
        ),
      );

  /// Needs `pipelines:delete`.
  Future<void> deleteCustomFilter(int id) async {
    await _authed('DELETE', ['admin', 'custom-filters', '$id']);
  }

  /// Each message the filters handled, newest first, delivered or not: the
  /// pipeline log. Only those that went [direction] or ended in [outcome],
  /// when given. Needs `pipelines:read`.
  Future<OffsetPage<MessageTrace>> pipelineLog({
    String? direction,
    String? outcome,
    int offset = 0,
    int limit = 50,
  }) => _offsetPage(
    ['admin', 'pipelines', 'logs'],
    MessageTrace.fromJson,
    offset,
    limit,
    {'direction': ?direction, 'outcome': ?outcome},
  );

  /// What the filters did over the last [window]. Needs
  /// `observability:read`.
  Future<PipelineAnalytics> pipelineAnalytics({
    Duration window = const Duration(days: 1),
  }) async => PipelineAnalytics.fromJson(
    _data(
      await _authed(
        'GET',
        ['admin', 'pipelines', 'analytics'],
        query: {'window': '${window.inHours}h'},
      ),
    ),
  );

  /// The senders on one of [domainId]'s lists, newest first. Needs
  /// `domains:read`.
  Future<List<SenderRule>> senderRules(int domainId, SenderList list) async =>
      _list(
        await _authed('GET', ['admin', 'domains', '$domainId', list.path]),
        SenderRule.fromJson,
      );

  /// Puts [pattern], an address or `@` and a domain, on one of [domainId]'s
  /// lists. Needs `domains:write`.
  Future<SenderRule> addSenderRule(
    int domainId,
    SenderList list, {
    required String pattern,
    String reason = '',
  }) async => SenderRule.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'domains', '$domainId', list.path],
        body: {'pattern': pattern, 'reason': reason},
      ),
    ),
  );

  /// Needs `domains:write`, as the server asks.
  Future<void> removeSenderRule(int domainId, SenderList list, int id) async {
    await _authed('DELETE', [
      'admin',
      'domains',
      '$domainId',
      list.path,
      '$id',
    ]);
  }

  /// [domainId]'s MTA-STS policy; none when it has none. Needs
  /// `domains:read`.
  Future<MtaStsPolicy?> mtaStsPolicy(int domainId) async {
    try {
      return MtaStsPolicy.fromJson(
        _data(
          await _authed('GET', ['admin', 'domains', '$domainId', 'mta-sts']),
        ),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Sets [domainId]'s MTA-STS policy, making it if there is none; what is
  /// left out stays as it was. Needs `domains:write`.
  Future<MtaStsPolicy> setMtaStsPolicy(
    int domainId, {
    MtaStsMode? mode,
    List<String>? mxHosts,
    Duration? maxAge,
    bool? active,
  }) async => MtaStsPolicy.fromJson(
    _data(
      await _authed(
        'PUT',
        ['admin', 'domains', '$domainId', 'mta-sts'],
        body: {
          'mode': ?mode?.name,
          'mx_hosts': ?mxHosts?.join(','),
          'max_age': ?maxAge?.inSeconds,
          'active': ?active,
        },
      ),
    ),
  );

  /// Needs `domains:write`, as the server asks.
  Future<void> deleteMtaStsPolicy(int domainId) async {
    await _authed('DELETE', ['admin', 'domains', '$domainId', 'mta-sts']);
  }

  /// Has the server look up [domainId]'s DNS records: MX, SPF, DMARC, DKIM,
  /// MTA-STS and TLS-RPT. Needs `domains:read`.
  Future<DnsCheck> dnsCheck(int domainId) async => DnsCheck.fromJson(
    _data(await _authed('GET', ['admin', 'domains', '$domainId', 'dns'])),
  );

  // ── Accounts and folders ─────────────────────────────────────────────

  Future<List<Account>> accounts() async =>
      _list(await _authed('GET', ['accounts']), Account.fromJson);

  /// Creates an account on a domain this server hosts, owned by this one:
  /// the session gets the owner grant on it, so it is listed in [accounts]
  /// at once, readable and sendable. Without [password] the new account has
  /// no credentials, and is reached only through its owners.
  ///
  /// Needs `mailboxes:write` covering the address's domain; without it the
  /// server answers 403. It answers 409 when the address is taken, and 422
  /// for a bad address, a domain it doesn't host, or a password under 12
  /// characters.
  Future<Account> createAccount({
    required String address,
    String? displayName,
    String? password,
  }) async => Account.fromJson(
    _data(
      await _authed(
        'POST',
        ['accounts'],
        body: {
          'address': address,
          'display_name': ?displayName,
          'password': ?password,
        },
      ),
    ),
  );

  /// Links an existing account on this server to this one, proving one of
  /// its passwords, and its second factor when it has one: the same proof as
  /// signing in to it.
  ///
  /// A refused link is 403, never 401: the secrets are the other account's,
  /// so this session is neither renewed nor ended, and nothing is sent
  /// twice. Throws [TotpRequiredException] when the password was right but
  /// the account has two-factor authentication; call again with [totpCode]
  /// or [recoveryCode]. `invalid_credentials` is a wrong address or
  /// password, `invalid_totp` a wrong code, and `setup_required` an account
  /// that has yet to choose its own password; 409 is one already linked, or
  /// this session's own.
  Future<Account> linkAccount({
    required String address,
    required String password,
    String? displayName,
    String? totpCode,
    String? recoveryCode,
  }) async => Account.fromJson(
    _data(
      await _authed(
        'POST',
        ['accounts', 'link'],
        body: {
          'address': address,
          'password': password,
          'display_name': ?displayName,
          if (totpCode != null && totpCode.isNotEmpty) 'totp_code': totpCode,
          if (recoveryCode != null && recoveryCode.isNotEmpty)
            'recovery_code': recoveryCode,
        },
      ),
    ),
  );

  /// Gives up this session's access to an account it created or linked. Its
  /// own account cannot be unlinked.
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

  // ── App passwords ────────────────────────────────────────────────────
  //
  // For the session's own account, or one it owns (created or linked):
  // [accountId] is either. Any other is answered 404.

  /// The mailbox's app passwords, newest first. Revoked ones are gone;
  /// expired ones stay until they are revoked.
  Future<List<AppPassword>> appPasswords(int accountId) async => _list(
    await _authed('GET', ['accounts', '$accountId', 'credentials']),
    AppPassword.fromJson,
  );

  /// Makes an app password and returns it with its secret, which the server
  /// shows this once.
  ///
  /// [password] is the session's own current password, entered again, even
  /// for an account it owns. Without it the server answers 403
  /// `reauth_required`, and with a wrong one 403 `invalid_password`:
  /// refusals of this request, not of the session, so they never renew or
  /// end the session. It also answers 403
  /// `two_factor_required` when the session's account has two-factor
  /// authentication and its sign-in didn't take it, and 429 when sign-in's
  /// budget, which it shares, is spent.
  Future<NewAppPassword> createAppPassword(
    int accountId, {
    required String name,
    required String password,
    DateTime? expiresAt,
  }) async {
    final response = await _authed(
      'POST',
      ['accounts', '$accountId', 'credentials'],
      body: {
        'name': name,
        'password': password,
        if (expiresAt != null)
          'expires_at': expiresAt.toUtc().toIso8601String(),
      },
    );
    try {
      return NewAppPassword.fromJson(_data(response));
    } on Object {
      throw _unreadable(response);
    }
  }

  /// Revokes an app password. It stops working at once, on open IMAP
  /// sessions too.
  Future<void> revokeAppPassword(int accountId, int id) async {
    await _authed('DELETE', ['accounts', '$accountId', 'credentials', '$id']);
  }

  // ── Push devices ─────────────────────────────────────────────────────
  //
  // A device registered here belongs to this session: the server pushes to
  // it when mail reaches any mailbox the session lists, and forgets it when
  // the session ends. The push says only that there is mail to fetch, never
  // what it is. A server without push, from before it or with no APNs or FCM
  // credentials set, has none of these routes and answers 404.

  /// Which services the server pushes through, and this session's devices.
  Future<PushRegistrations> pushDevices() async =>
      PushRegistrations.fromJson(_data(await _authed('GET', ['devices'])));

  /// Registers this phone's push [token] with the session. Registering the
  /// same token again answers with the device it already made.
  ///
  /// [environment] says which APNs the token came from; [appId] is the
  /// bundle id the push has to be addressed to.
  Future<PushDevice> registerPushDevice({
    required String platform,
    required String token,
    String? environment,
    String? appId,
  }) async => PushDevice.fromJson(
    _data(
      await _authed(
        'POST',
        ['devices'],
        body: {
          'platform': platform,
          'token': token,
          'environment': ?environment,
          'app_id': ?appId,
        },
      ),
    ),
  );

  /// Stops pushes to a device this session registered.
  Future<void> removePushDevice(String id) async {
    await _authed('DELETE', ['devices', id]);
  }

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

  /// Leaves [message] with the server to send at [at]. Returns the stored
  /// scheduled message rather than a sent one.
  Future<ScheduledSend> schedule(OutgoingMessage message, DateTime at) async =>
      ScheduledSend.fromJson(
        _data(
          await _authed(
            'POST',
            ['messages', 'send'],
            body: {
              ...message.toSendJson(),
              'scheduled_at': at.toUtc().toIso8601String(),
            },
          ),
        ),
      );

  /// The messages still waiting to be sent, soonest first.
  Future<List<ScheduledSend>> scheduledSends() async => _list(
    await _authed('GET', ['messages', 'scheduled']),
    ScheduledSend.fromJson,
  );

  Future<void> cancelScheduledSend(int id) async {
    await _authed('DELETE', ['messages', 'scheduled', '$id']);
  }

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
  /// a fresh token is the request's own refusal, and is reported like any
  /// other error.
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
    throw _error(response);
  }

  ApiException _error(http.Response response) => ApiException.fromResponse(
    response.statusCode,
    utf8.decode(response.bodyBytes, allowMalformed: true),
    reason: response.reasonPhrase,
    retryAfter: _retryAfter(response.headers['retry-after']),
  );

  /// `Retry-After` in seconds, as rest-mail sends it, or as an HTTP date.
  static Duration? _retryAfter(String? value) {
    if (value == null) return null;
    if (int.tryParse(value.trim()) case final seconds?) {
      return seconds < 0 ? null : Duration(seconds: seconds);
    }
    try {
      final wait = HttpDate.parse(value).difference(DateTime.now());
      return wait.isNegative ? Duration.zero : wait;
    } on FormatException {
      return null;
    } on HttpException {
      return null;
    }
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

  /// A `{"data": [...], "pagination": {"total"}}` list, paged by offset.
  Future<OffsetPage<T>> _offsetPage<T>(
    List<String> path,
    T Function(Map<String, dynamic>) fromJson,
    int offset,
    int limit, [
    Map<String, String> query = const {},
  ]) async {
    final response = await _authed(
      'GET',
      path,
      query: {...query, 'limit': '$limit', 'offset': '$offset'},
    );
    final envelope = _envelope(response);
    final items = _items(envelope['data'], response, fromJson);
    final pagination = envelope['pagination'];
    final total = pagination is Map<String, dynamic>
        ? (pagination['total'] as num?)?.toInt()
        : null;
    return OffsetPage(
      items,
      offset: offset,
      total: total ?? offset + items.length,
    );
  }

  List<T> _list<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) => _items(_envelope(response)['data'], response, fromJson);

  Paged<Message> _messagePage(http.Response response) =>
      _cursorPage(response, Message.fromJson);

  /// A `{"data": [...], "pagination": {"cursor", "has_more"}}` list.
  Paged<T> _cursorPage<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final envelope = _envelope(response);
    final pagination = envelope['pagination'];
    final page = pagination is Map<String, dynamic>
        ? pagination
        : const <String, dynamic>{};
    return Paged(
      _items(envelope['data'], response, fromJson),
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

  /// Reads the pair a native sign-in or refresh returns in its body, with the
  /// capabilities they carry. A server from before native clients were
  /// supported answers with cookies only, and lands here as `missing_tokens`.
  SessionTokens _tokensFrom(http.Response response, Map<String, dynamic> data) {
    final access = data['access_token'];
    final refresh = data['refresh_token'];
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty) {
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
      capabilities: Capabilities.fromJson(data['capabilities']),
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
