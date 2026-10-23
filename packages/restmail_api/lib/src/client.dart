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
import 'filter_models.dart';
import 'grants_models.dart';
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
  // Rotating tokens belong to the same session. A later login or sign-out is
  // a different one and must survive a late security-change response.
  int _sessionEpoch = 0;

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
    _sessionEpoch++;
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
    final latest = _tokens;
    if (latest == null ||
        latest.accessToken != current.accessToken ||
        latest.refreshToken != current.refreshToken) {
      if (latest == null) throw const SessionExpiredException();
      return latest;
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      _setTokens(null);
      throw const SessionExpiredException();
    }
    _throwIfError(response);
    final renewed = _tokensFrom(response, _data(response));
    // An escalation may have updated only capabilities while this request
    // was in flight. Keep that newer metadata and still persist the rotated
    // credentials; ignoring the rotation would leave a spent refresh token.
    final tokens = identical(latest, current)
        ? renewed
        : SessionTokens(
            accessToken: renewed.accessToken,
            refreshToken: renewed.refreshToken,
            accessExpiresAt: renewed.accessExpiresAt,
            capabilities: latest.capabilities,
          );
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

  /// The session owner's own status, never a linked mailbox's.
  Future<TwoFactorStatus> twoFactorStatus() async {
    final response = await _authed('GET', ['auth', '2fa']);
    try {
      return TwoFactorStatus.fromJson(_data(response));
    } on Object {
      throw _unreadable(response);
    }
  }

  /// Starts enrolling an authenticator. Show the result once, then
  /// [confirmTwoFactor] with a code the authenticator produces.
  Future<TotpEnrollment> enrollTwoFactor() async {
    final response = await _authed('POST', ['auth', '2fa', 'enroll']);
    try {
      final enrollment = TotpEnrollment.fromJson(_data(response));
      if (enrollment.secret.isEmpty ||
          enrollment.otpauthUri.scheme != 'otpauth' ||
          enrollment.recoveryCodes.isEmpty) {
        throw const FormatException('Invalid enrollment');
      }
      return enrollment;
    } on Object {
      throw _unreadable(response);
    }
  }

  /// Finishes enrolling: from now on signing in also takes a code. A wrong
  /// code is 403 `invalid_totp`, never 401: the session is still good.
  Future<void> confirmTwoFactor(String code) async {
    final response = await _authed(
      'POST',
      ['auth', '2fa', 'confirm'],
      body: {'totp_code': code},
    );
    if (response.statusCode != 204) throw _unreadable(response);
  }

  /// Turns off the session owner's authenticator using a current code or an
  /// unused recovery code. Success ends all of that account's sessions, this
  /// one included; the token callback also clears persisted credentials.
  /// Wrong proof and mandatory-2FA refusals are 403 and keep the session.
  Future<void> disableTwoFactor({
    String? totpCode,
    String? recoveryCode,
  }) async {
    final epoch = _sessionEpoch;
    final response = await _authed(
      'POST',
      ['auth', '2fa', 'disable'],
      body: {
        if (totpCode != null && totpCode.isNotEmpty) 'totp_code': totpCode,
        if (recoveryCode != null && recoveryCode.isNotEmpty)
          'recovery_code': recoveryCode,
      },
    );
    if (response.statusCode != 204) throw _unreadable(response);
    if (_sessionEpoch == epoch) _setTokens(null);
  }

  /// Replaces the signed-in account's password. The server ends every
  /// session of the account, this one included, so this client is signed out
  /// after it: sign in again with [next]. A wrong [current] is 403
  /// `invalid_password`, never 401: the session is still good.
  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    final epoch = _sessionEpoch;
    await _authed(
      'POST',
      ['auth', 'password'],
      body: {'current_password': current, 'new_password': next},
    );
    if (_sessionEpoch == epoch) _setTokens(null);
  }

  // ── Admin ────────────────────────────────────────────────────────────
  //
  // Each call needs a capability (see [Capability]); without it the server
  // answers 403, whatever the app showed.

  /// One page of the outbound queue, newest first, optionally only those in
  /// [status]. Needs `queue:read`.
  Future<OffsetPage<QueueEntry>> queue({
    QueueStatus? status,
    String? domain,
    String? sender,
    String? recipient,
    int offset = 0,
    int limit = 50,
  }) async {
    final data = _data(
      await _authed(
        'GET',
        ['admin', 'queue'],
        query: {
          'status': ?status?.name,
          'domain': ?domain,
          'sender': ?sender,
          'recipient': ?recipient,
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
  Future<QueueActionResult> retryQueueEntry(int id) =>
      _queueAction(id, 'retry', 'retrying');

  /// Gives up on an entry and bounces it to its sender. Needs `queue:manage`.
  Future<QueueActionResult> bounceQueueEntry(int id) =>
      _queueAction(id, 'bounce', 'bounced');

  Future<QueueActionResult> _queueAction(
    int id,
    String action,
    String expectedStatus,
  ) async {
    final response = await _authed('POST', ['admin', 'queue', '$id', action]);
    if (response.statusCode != 200) throw _unreadable(response);
    try {
      final result = QueueActionResult.fromJson(_data(response));
      if (result.status != expectedStatus) throw _unreadable(response);
      return result;
    } on FormatException {
      throw _unreadable(response);
    }
  }

  /// Drops an entry without telling its sender. Needs `queue:manage`.
  Future<void> deleteQueueEntry(int id) async {
    await _authed('DELETE', ['admin', 'queue', '$id']);
  }

  /// Retry pending/deferred entries in the selection. Needs `queue:manage`.
  Future<BulkQueueResult> bulkRetryQueue(QueueSelection selection) =>
      _bulkQueue('POST', 'bulk-retry', selection);

  /// Bounce entries still in flight. Needs `queue:manage`.
  Future<BulkQueueResult> bulkBounceQueue(QueueSelection selection) =>
      _bulkQueue('POST', 'bulk-bounce', selection);

  /// Delete matching entries without notification. Needs `queue:manage`.
  Future<BulkQueueResult> bulkDeleteQueue(QueueSelection selection) =>
      _bulkQueue('DELETE', 'bulk-delete', selection);

  Future<BulkQueueResult> _bulkQueue(
    String method,
    String operation,
    QueueSelection selection,
  ) async {
    final response = await _authed(method, [
      'admin',
      'queue',
      operation,
    ], body: selection.toJson());
    try {
      return BulkQueueResult.fromJson(_data(response));
    } on Object {
      throw _unreadable(response);
    }
  }

  /// Needs `domains:read`.
  Future<OffsetPage<AdminDomain>> domains({int offset = 0, int limit = 100}) =>
      _offsetPage(['admin', 'domains'], AdminDomain.fromJson, offset, limit);

  /// Fresh detail. Needs `domains:read` on this domain.
  Future<AdminDomain> domain(int id) async => AdminDomain.fromJson(
    _data(await _authed('GET', ['admin', 'domains', '$id'])),
  );

  /// Creates a domain; [serverType] is `restmail` (the server keeps the mail)
  /// or `traditional`. A new domain is never live: going live is
  /// [updateDomain] with `active`. Throws [ApiException] with code
  /// `already_exists` when it is there already. Needs `domains:write`.
  Future<AdminDomain> createDomain(
    String name, {
    String serverType = 'restmail',
    int? defaultQuotaBytes,
    String? sendingPolicy,
  }) async => AdminDomain.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'domains'],
        body: {
          'name': name,
          'server_type': serverType,
          'default_quota_bytes': ?defaultQuotaBytes,
          'sending_policy': ?sendingPolicy,
        },
      ),
    ),
  );

  /// Changes what is given: whether the domain's mail is on, the quota new
  /// mailboxes get, and its sending policy (empty clears it).
  /// Needs `domains:write`.
  Future<AdminDomain> updateDomain(
    int id, {
    bool? active,
    int? defaultQuotaBytes,
    String? sendingPolicy,
  }) async => AdminDomain.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'domains', '$id'],
        body: {
          'active': ?active,
          'default_quota_bytes': ?defaultQuotaBytes,
          'sending_policy': ?sendingPolicy,
        },
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

  /// Fresh detail. Needs `mailboxes:read` on this mailbox.
  Future<AdminMailbox> adminMailbox(int id) async => AdminMailbox.fromJson(
    _data(await _authed('GET', ['admin', 'mailboxes', '$id'])),
  );

  /// Changes what is given; a new [password] ends the mailbox's sessions.
  /// Needs `mailboxes:write`.
  Future<AdminMailbox> updateMailbox(
    int id, {
    String? displayName,
    String? password,
    bool? active,
    int? quotaBytes,
  }) async => AdminMailbox.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'mailboxes', '$id'],
        body: {
          'display_name': ?displayName,
          'password': ?password,
          'active': ?active,
          'quota_bytes': ?quotaBytes,
        },
      ),
    ),
  );

  /// Signs the mailbox out everywhere: its refresh tokens are revoked and
  /// every access token it holds is refused. Passwords and app passwords
  /// stay. Needs `mailboxes:write`.
  Future<void> endMailboxSessions(int id) async {
    await _authed('DELETE', ['admin', 'mailboxes', '$id', 'sessions']);
  }

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

  /// Fresh detail. The server currently needs global `mailboxes:read`.
  Future<AdminAlias> alias(int id) async => AdminAlias.fromJson(
    _data(await _authed('GET', ['admin', 'aliases', '$id'])),
  );

  /// Sends mail for [source], on a domain the server has, to [destination].
  /// Needs `mailboxes:write`.
  Future<AdminAlias> createAlias({
    required String source,
    required String destination,
  }) async => AdminAlias.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'aliases'],
        body: {'source_address': source, 'destination_address': destination},
      ),
    ),
  );

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

  /// Global `bans:read`. By default only unexpired bans are returned.
  /// [active] false includes both current and expired bans. [protocol]
  /// includes bans on that protocol plus bans on all protocols.
  Future<OffsetPage<Ban>> bans({
    String? protocol,
    bool? active,
    String? ip,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'bans'],
    Ban.fromJson,
    offset,
    limit,
    {'protocol': ?protocol, 'active': ?active?.toString(), 'ip': ?ip},
  );

  /// Creates or replaces a ban by IP. The server requires [createdBy]; the
  /// mobile form supplies the signed-in address. Needs global `bans:write`.
  /// Omit both durations for a permanent ban. [durationText] accepts the
  /// server's complete Go duration syntax; it cannot be combined with [duration].
  Future<Ban> createBan({
    required String ip,
    required String createdBy,
    String reason = '',
    String protocol = 'all',
    Duration? duration,
    String? durationText,
  }) async {
    if (duration != null && durationText != null) {
      throw ArgumentError('Supply duration or durationText, not both.');
    }
    final wireDuration =
        durationText ??
        (duration == null
            ? null
            : duration.inMicroseconds % Duration.microsecondsPerMinute == 0
            ? '${duration.inMinutes}m'
            : '${duration.inMicroseconds}us');
    return Ban.fromJson(
      _data(
        await _authed(
          'POST',
          ['admin', 'bans'],
          body: {
            'ip': ip,
            'reason': reason,
            'protocol': protocol,
            'created_by': createdBy,
            'duration': ?wireDuration,
          },
        ),
      ),
    );
  }

  /// Lifts a ban. Needs global `bans:delete`.
  Future<void> deleteBan(int id) async {
    await _authed('DELETE', ['admin', 'bans', '$id']);
  }

  /// Removes a ban by its exact IPv4 or IPv6 address; answers 404 if absent.
  Future<void> unbanIP(String ip) async {
    await _authed('DELETE', ['admin', 'bans', 'ip', ip]);
  }

  /// Mail sent to other servers, newest first, with how each went: the
  /// outbound queue's history. Needs `messages:read`.
  Future<OffsetPage<QueueEntry>> deliveryLog({
    QueueStatus? status,
    String? domain,
    String? sender,
    String? recipient,
    DateTime? since,
    DateTime? until,
    int offset = 0,
    int limit = 50,
  }) => _offsetPage(
    ['admin', 'logs', 'delivery'],
    QueueEntry.fromJson,
    offset,
    limit,
    {
      'status': ?status?.name,
      'domain': ?domain,
      'sender': ?sender,
      'recipient': ?recipient,
      'since': ?since?.toUtc().toIso8601String(),
      'until': ?until?.toUtc().toIso8601String(),
    },
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
  Future<OffsetPage<TlsReport>> tlsReports({
    int? domainId,
    String? policyType,
    String? reportingOrg,
    int offset = 0,
    int limit = 50,
  }) => _offsetPage(
    ['admin', 'tls-reports'],
    TlsReport.fromJson,
    offset,
    limit,
    {
      'domain_id': ?domainId?.toString(),
      'policy_type': ?policyType,
      'reporting_org': ?reportingOrg,
    },
  );

  /// The audit log, newest first, a page at a time: hand the page's cursor
  /// back as [before] for the next. Only entries with [outcome] or by an
  /// [actorKind], when given. The server records the read itself. Needs
  /// `audit:read`.
  Future<Paged<AuditEntry>> audit({
    String? before,
    String? outcome,
    String? actorKind,
    int? actorId,
    String? actor,
    String? action,
    DateTime? since,
    DateTime? until,
    int limit = 50,
  }) async => _cursorPage(
    await _authed(
      'GET',
      ['admin', 'audit'],
      query: {
        'before_seq': ?before,
        'outcome': ?outcome,
        'actor_kind': ?actorKind,
        'actor_id': ?actorId?.toString(),
        'actor': ?actor,
        'action': ?action,
        'since': ?since?.toUtc().toIso8601String(),
        'until': ?until?.toUtc().toIso8601String(),
        'limit': '$limit',
      },
    ),
    AuditEntry.fromJson,
  );

  /// Has the server walk the whole audit log and check its chain. Needs
  /// `audit:read`.
  Future<AuditCheck> verifyAudit({String? anchor}) async => AuditCheck.fromJson(
    _data(
      await _authed(
        'GET',
        ['admin', 'audit', 'verify'],
        query: {'anchor': ?anchor},
      ),
    ),
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

  /// One certificate as the server holds it now, with its PEM. Needs
  /// `domains:read`.
  Future<TlsCertificate> certificate(int id) async => TlsCertificate.fromJson(
    _data(await _authed('GET', ['admin', 'certificates', '$id'])),
  );

  /// Stores a certificate and its private key for [domainId]. The server
  /// reads the issuer and validity from [certPem]; it renews by itself
  /// unless [autoRenew] says not. Needs `domains:write`.
  Future<TlsCertificate> uploadCertificate({
    required int domainId,
    required String certPem,
    required String keyPem,
    bool? autoRenew,
  }) async => TlsCertificate.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'certificates'],
        body: {
          'domain_id': domainId,
          'cert_pem': certPem,
          'key_pem': keyPem,
          'auto_renew': ?autoRenew,
        },
      ),
    ),
  );

  /// Needs `domains:write`, as the server asks.
  Future<void> deleteCertificate(int id) async {
    await _authed('DELETE', ['admin', 'certificates', '$id']);
  }

  /// Needs global `pipelines:read`. The server filters before pagination.
  Future<OffsetPage<Pipeline>> pipelines({
    int? domainId,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'pipelines'],
    Pipeline.fromJson,
    offset,
    limit,
    {'domain_id': ?domainId?.toString()},
  );

  /// Needs global `pipelines:write`. Omitted active defaults to true.
  Future<Pipeline> createPipeline({
    required int domainId,
    required String direction,
    required List<PipelineFilter> filters,
    bool? active,
  }) async => Pipeline.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'pipelines'],
        body: {
          'domain_id': domainId,
          'direction': direction,
          'filters': [for (final filter in filters) filter.toJson()],
          'active': ?active,
        },
      ),
    ),
  );

  /// Only supplied fields change. An empty filter list clears all steps.
  Future<Pipeline> updatePipeline(
    int id, {
    bool? active,
    List<PipelineFilter>? filters,
  }) async => Pipeline.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'pipelines', '$id'],
        body: {
          'active': ?active,
          if (filters != null)
            'filters': [for (final filter in filters) filter.toJson()],
        },
      ),
    ),
  );

  /// Needs `pipelines:delete`.
  Future<void> deletePipeline(int id) async =>
      _expectDeleted(await _authed('DELETE', ['admin', 'pipelines', '$id']));

  /// Executes the saved pipeline. Requires global `pipelines:write`.
  Future<PipelineTestResult> testPipeline(
    int id, {
    required Map<String, dynamic> email,
  }) async => PipelineTestResult.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'pipelines', 'test'],
        body: {'pipeline_id': id, 'email': email},
      ),
    ),
  );

  /// Tests one built-in filter with its complete config and canonical email.
  Future<FilterTestResult> testFilter({
    required String filterName,
    required Map<String, dynamic> config,
    required Map<String, dynamic> email,
  }) async => FilterTestResult.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'pipelines', 'test-filter'],
        body: {'filter_name': filterName, 'config': config, 'email': email},
      ),
    ),
  );

  /// Needs global `pipelines:read`.
  Future<OffsetPage<CustomFilter>> customFilters({
    int? domainId,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'custom-filters'],
    CustomFilter.fromJson,
    offset,
    limit,
    {'domain_id': ?domainId?.toString()},
  );

  Future<CustomFilter> customFilter(int id) async => CustomFilter.fromJson(
    _data(await _authed('GET', ['admin', 'custom-filters', '$id'])),
  );

  Future<CustomFilter> createCustomFilter({
    required int domainId,
    required String name,
    required String filterType,
    required String direction,
    required Map<String, dynamic> config,
    String? description,
    bool? enabled,
  }) async => CustomFilter.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'custom-filters'],
        body: {
          'domain_id': domainId,
          'name': name,
          'filter_type': filterType,
          'direction': direction,
          'config': config,
          'description': ?description,
          'enabled': ?enabled,
        },
      ),
    ),
  );

  /// Omitted fields are unchanged, including config. Empty objects are sent.
  Future<CustomFilter> updateCustomFilter(
    int id, {
    String? name,
    String? description,
    String? filterType,
    String? direction,
    Map<String, dynamic>? config,
    bool? enabled,
  }) async => CustomFilter.fromJson(
    _data(
      await _authed(
        'PATCH',
        ['admin', 'custom-filters', '$id'],
        body: {
          'name': ?name,
          'description': ?description,
          'filter_type': ?filterType,
          'direction': ?direction,
          'config': ?config,
          'enabled': ?enabled,
        },
      ),
    ),
  );

  /// These sidecar endpoints return bare objects, without a data envelope.
  Future<FilterValidation> validateCustomFilter(
    String script, {
    Map<String, dynamic>? email,
  }) async => FilterValidation.fromJson(
    _envelope(
      await _authed(
        'POST',
        ['admin', 'custom-filters', 'validate'],
        body: {'script': script, 'email': ?email},
      ),
    ),
  );

  Future<ScriptTestResult> testCustomFilter(
    int id, {
    Map<String, dynamic>? email,
  }) async => ScriptTestResult.fromJson(
    _envelope(
      await _authed(
        'POST',
        ['admin', 'custom-filters', '$id', 'test'],
        body: {'email': ?email},
      ),
    ),
  );

  /// Needs `pipelines:delete`.
  Future<void> deleteCustomFilter(int id) async => _expectDeleted(
    await _authed('DELETE', ['admin', 'custom-filters', '$id']),
  );

  /// A pipeline or custom filter is gone only when the server says so: 200
  /// and `{"data": {"status": "deleted"}}`. Anything else is not taken as
  /// done.
  void _expectDeleted(http.Response response) {
    if (response.statusCode != 200) throw _unreadable(response);
    try {
      if (_data(response)['status'] != 'deleted') throw _unreadable(response);
    } on FormatException {
      throw _unreadable(response);
    }
  }

  /// Each message the filters handled, newest first, delivered or not: the
  /// pipeline log. Only those that went [direction] or ended in [outcome],
  /// when given. Needs `pipelines:read`.
  Future<OffsetPage<MessageTrace>> pipelineLog({
    int? pipelineId,
    String? direction,
    String? action,
    String? rfcMessageId,
    String? outcome,
    String? reasonCode,
    int offset = 0,
    int limit = 50,
  }) => _offsetPage(
    ['admin', 'pipelines', 'logs'],
    MessageTrace.fromJson,
    offset,
    limit,
    {
      'pipeline_id': ?pipelineId?.toString(),
      'direction': ?direction,
      'action': ?action,
      'rfc_message_id': ?rfcMessageId,
      'outcome': ?outcome,
      'reason_code': ?reasonCode,
    },
  );

  /// Windowed analytics plus optional cumulative counters. [since] takes
  /// precedence; [windowText] accepts a Go duration, including subsecond units.
  /// Needs `observability:read`.
  Future<PipelineAnalytics> pipelineAnalytics({
    Duration window = const Duration(days: 1),
    String? windowText,
    DateTime? since,
  }) async => PipelineAnalytics.fromJson(
    _data(
      await _authed(
        'GET',
        ['admin', 'pipelines', 'analytics'],
        query: {
          if (since != null)
            'since': since.toUtc().toIso8601String()
          else
            'window':
                windowText ??
                (window.inMicroseconds % Duration.microsecondsPerHour == 0
                    ? '${window.inHours}h'
                    : '${window.inMicroseconds}us'),
        },
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

  /// How [domainId]'s outgoing mail leaves the server. Needs
  /// `domains:read`.
  Future<DomainRelay> domainRelay(int domainId) async => DomainRelay.fromJson(
    _data(await _authed('GET', ['admin', 'domains', '$domainId', 'relay'])),
  );

  /// Replaces [domainId]'s outbound transport. For a relay, [host], [port]
  /// and [tlsMode] are needed. A [password] left out keeps the stored one;
  /// an empty one clears it. Needs `domains:write` on every domain, as the
  /// server asks.
  Future<DomainRelay> setDomainRelay(
    int domainId, {
    required OutboundTransport transport,
    String host = '',
    int? port,
    RelayTlsMode? tlsMode,
    String username = '',
    String? password,
  }) async => DomainRelay.fromJson(
    _data(
      await _authed(
        'PUT',
        ['admin', 'domains', '$domainId', 'relay'],
        body: {
          'transport': transport.value,
          if (transport == OutboundTransport.relay) ...{
            'host': host,
            'port': ?port,
            'tls_mode': ?tlsMode?.value,
            'username': username,
            'password': ?password,
          },
        },
      ),
    ),
  );

  /// The recipients [domainId]'s mail is no longer sent to, most recently
  /// bounced first. Needs `domains:read`.
  Future<List<Suppression>> suppressions(int domainId) async => _list(
    await _authed('GET', ['admin', 'domains', '$domainId', 'suppressions']),
    Suppression.fromJson,
  );

  /// Clears a suppression, so mail to the address is tried again. Needs
  /// `domains:write`.
  Future<void> clearSuppression(int domainId, int id) async {
    await _authed('DELETE', [
      'admin',
      'domains',
      '$domainId',
      'suppressions',
      '$id',
    ]);
  }

  /// [domainId]'s MTA-STS policy; none when it has none. Needs
  /// `domains:read`.
  Future<MtaStsPolicy?> mtaStsPolicy(int domainId) async {
    try {
      final response = await _authed('GET', [
        'admin',
        'domains',
        '$domainId',
        'mta-sts',
      ]);
      if (response.statusCode != 200) throw _unreadable(response);
      return MtaStsPolicy.fromJson(_data(response));
    } on ApiException catch (e) {
      if (e.statusCode == 404 &&
          e.code == 'not_found' &&
          e.message == 'No MTA-STS policy found for this domain') {
        return null;
      }
      rethrow;
    }
  }

  /// Sets [domainId]'s MTA-STS policy, making it if there is none; what is
  /// left out stays as it was. Empty MX hosts also leave the saved hosts
  /// unchanged. [maxAgeSeconds] preserves the server's full integer range;
  /// supply it or [maxAge], not both. Needs `domains:write` on this domain.
  Future<MtaStsPolicy> setMtaStsPolicy(
    int domainId, {
    MtaStsMode? mode,
    List<String>? mxHosts,
    Duration? maxAge,
    int? maxAgeSeconds,
    bool? active,
  }) async {
    if (maxAge != null && maxAgeSeconds != null) {
      throw ArgumentError('Use maxAge or maxAgeSeconds, not both');
    }
    final response = await _authed(
      'PUT',
      ['admin', 'domains', '$domainId', 'mta-sts'],
      body: {
        'mode': ?mode?.name,
        'mx_hosts': ?mxHosts?.join(','),
        'max_age': ?(maxAgeSeconds ?? maxAge?.inSeconds),
        'active': ?active,
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw _unreadable(response);
    }
    return MtaStsPolicy.fromJson(_data(response));
  }

  /// Needs `domains:write`, as the server asks.
  Future<void> deleteMtaStsPolicy(int domainId) async {
    final response = await _authed('DELETE', [
      'admin',
      'domains',
      '$domainId',
      'mta-sts',
    ]);
    if (response.statusCode != 204) throw _unreadable(response);
  }

  /// Has the server look up [domainId]'s DNS records: MX, SPF, DMARC, DKIM,
  /// MTA-STS and TLS-RPT. Needs `domains:read`.
  Future<DnsCheck> dnsCheck(int domainId) async => DnsCheck.fromJson(
    _data(await _authed('GET', ['admin', 'domains', '$domainId', 'dns'])),
  );

  // ── Roles, grants and escalation ─────────────────────────────────────
  //
  // Changing grants needs `users:write` and a session signed in with a second
  // factor; the server also refuses a role, or a scope, wider than the
  // granter's own. Each account's own grants, and switching its eligible ones
  // on and off, need no capability.

  /// The roles that can be granted, each with its capabilities. Needs
  /// `users:read`.
  Future<List<AdminRole>> roles() async =>
      _list(await _authed('GET', ['admin', 'roles']), AdminRole.fromJson);

  /// Every capability the server checks, by name. Needs `users:read`.
  Future<List<CapabilityDefinition>> capabilityDefinitions() async => _list(
    await _authed('GET', ['admin', 'capabilities']),
    CapabilityDefinition.fromJson,
  );

  /// One page of grants, oldest first: only [holder]'s, or only those at
  /// [scope], when given. Needs `users:read`.
  Future<OffsetPage<Grant>> grants({
    GrantHolder? holder,
    String? scope,
    int offset = 0,
    int limit = 100,
  }) => _offsetPage(
    ['admin', 'grants'],
    Grant.fromJson,
    offset,
    limit,
    {
      'holder_kind': ?holder?.kind,
      'holder_id': ?holder?.id.toString(),
      'scope': ?scope,
    },
  );

  /// Grants [role] to [holder] at [scope] (`*`, `domain:<name>` or
  /// `mailbox:<address>`): [GrantMode.active] when [mode] is not given, until
  /// [expiresAt] or until removed. Throws [ApiException] with a
  /// [GrantErrorCode], or `validation_failed` naming the field. Needs
  /// `users:write`.
  Future<Grant> createGrant({
    required GrantHolder holder,
    required String role,
    required String scope,
    GrantMode? mode,
    DateTime? expiresAt,
  }) async => Grant.fromJson(
    _data(
      await _authed(
        'POST',
        ['admin', 'grants'],
        body: {
          'holder': holder.toJson(),
          'role': role,
          'scope': scope,
          'mode': ?(mode == null || mode == GrantMode.unknown
              ? null
              : mode.name),
          'expires_at': ?expiresAt?.toUtc().toIso8601String(),
        },
      ),
    ),
  );

  /// Removes a grant. Needs `users:write`.
  Future<void> deleteGrant(int id) async {
    await _authed('DELETE', ['admin', 'grants', '$id']);
  }

  /// The signed-in account's own grants, each with any activation running
  /// now.
  Future<List<Grant>> myGrants() async =>
      _list(await _authed('GET', ['admin', 'grants', 'mine']), Grant.fromJson);

  /// Switches one of the account's own eligible grants on for [minutes] (the
  /// server's 60 when not given, at most 240), saying why. Needs a fresh
  /// [totpCode] from the authenticator, or an unused [recoveryCode]: without
  /// either it throws [TotpRequiredException], and a wrong one is
  /// [GrantErrorCode.invalidTotp]. The session's capabilities become the ones
  /// the server answers with.
  Future<Escalation> activateGrant(
    int id, {
    required String reason,
    int? minutes,
    String? totpCode,
    String? recoveryCode,
  }) => _escalationRequest(
    id,
    'activate',
    body: {
      'reason': reason,
      'minutes': ?minutes,
      'totp_code': ?totpCode,
      'recovery_code': ?recoveryCode,
    },
  );

  /// Switches one of the account's own grants off before its activation runs
  /// out. The session's capabilities become the ones the server answers with.
  Future<Escalation> deactivateGrant(int id) =>
      _escalationRequest(id, 'deactivate');

  /// Makes one of the account's own active grants eligible: from then on it
  /// gives nothing until switched on. Needs a fresh code, as [activateGrant]
  /// does. The session's capabilities become the ones the server answers
  /// with.
  Future<Escalation> makeGrantEligible(
    int id, {
    String? totpCode,
    String? recoveryCode,
  }) => _escalationRequest(
    id,
    'make-eligible',
    body: {'totp_code': ?totpCode, 'recovery_code': ?recoveryCode},
  );

  Future<Escalation> _escalationRequest(
    int id,
    String operation, {
    Map<String, Object?>? body,
  }) async {
    final epoch = _sessionEpoch;
    final response = await _authed('POST', [
      'admin',
      'grants',
      '$id',
      operation,
    ], body: body);
    if (response.statusCode != (operation == 'activate' ? 201 : 200)) {
      throw _unreadable(response);
    }
    return _escalated(response, epoch);
  }

  /// Reads a step of escalation, and keeps what it says the account now
  /// holds as the session's capabilities until the next refresh brings them.
  /// A late answer cannot apply the old account's grants to a replacement
  /// login or restore a signed-out session. Normal rotation keeps the epoch.
  Escalation _escalated(http.Response response, int epoch) {
    final data = _data(response);
    if (data['grant'] is! Map<String, dynamic>) throw _unreadable(response);
    final step = Escalation.fromJson(data);
    final tokens = _tokens;
    if (tokens != null && _sessionEpoch == epoch) {
      _setTokens(
        SessionTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          accessExpiresAt: tokens.accessExpiresAt,
          capabilities: step.capabilities,
        ),
      );
    }
    return step;
  }

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

  // ── API keys ─────────────────────────────────────────────────────────
  //
  // For the session's own account, or one it manages. Creating and revoking
  // need a two-factor sign-in, and creating the session's current password
  // too: the server answers 403 otherwise, a refusal of the request, not of
  // the session, so it never renews or ends it.

  /// The account's API keys: metadata only, never a token.
  Future<List<APIKey>> apiKeys(int accountId) async => _list(
    await _authed('GET', ['accounts', '$accountId', 'api-keys']),
    APIKey.fromJson,
  );

  /// Makes an API key holding [permissions] (1 to 64), each within what the
  /// session and the account hold, and returns it with its token, which the
  /// server shows this once. Without [expiresAt] the server picks 90 days.
  Future<CreatedAPIKey> createAPIKey(
    int accountId, {
    required String name,
    required String password,
    required List<APIKeyPermission> permissions,
    DateTime? expiresAt,
  }) async {
    final response = await _authed(
      'POST',
      ['accounts', '$accountId', 'api-keys'],
      body: {
        'name': name,
        'password': password,
        'permissions': [
          for (final permission in permissions) permission.toJson(),
        ],
        if (expiresAt != null)
          'expires_at': expiresAt.toUtc().toIso8601String(),
      },
    );
    try {
      return CreatedAPIKey.fromJson(_data(response));
    } on Object {
      throw _unreadable(response);
    }
  }

  /// Revokes an API key. The server refuses it from the next request on.
  Future<void> revokeAPIKey(int accountId, int credentialId) async {
    await _authed('DELETE', [
      'accounts',
      '$accountId',
      'api-keys',
      '$credentialId',
    ]);
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
      capabilities: Capabilities.fromJson(
        data['capabilities'],
        scoped: data['scoped_capabilities'],
      ),
    );
  }

  void _setTokens(SessionTokens? tokens) {
    if (tokens == null) _sessionEpoch++;
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
