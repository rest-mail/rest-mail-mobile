import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'model.dart';
import 'sample_mail.dart';

/// Ready-made states for a fake to start in.
enum FakeScenario {
  /// Dana's mailbox with a week of mail, a second one she can link, and
  /// the server's administrator, [FakeAccounts.adminEmail].
  sample,

  /// The same two mailboxes with nothing in them.
  empty,

  /// The sample, with Dana's sign-in behind two-factor authentication.
  twoFactor,

  /// A server just installed: only its bootstrap account,
  /// [FakeAccounts.adminEmail], and its domain. The account must set a new
  /// password and enroll an authenticator before the server answers it
  /// anything else.
  freshInstall,
}

const _standardFolders = [
  'INBOX',
  'Drafts',
  'Sent',
  'Archive',
  'Spam',
  'Trash',
];

/// An in-memory rest-mail server on [host], reached through [client].
///
/// Mail sent between the fake's own mailboxes is delivered, and every change
/// is pushed to open event streams, as the real server does.
class FakeRestmail {
  FakeRestmail({
    this.scenario = FakeScenario.sample,
    this.host = FakeAccounts.host,
    this.accessTokenLifetime = const Duration(minutes: 15),
    this.latency = Duration.zero,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now {
    _load();
  }

  final FakeScenario scenario;

  /// Requests to any other host fail as if it could not be reached.
  final String host;
  final Duration accessTokenLifetime;

  /// What a sign-in reports as the refresh token's lifetime, the real
  /// server's. The fake never expires one.
  static const _refreshTokenLifetime = Duration(days: 7);

  /// A pause before every answer, for a slow network.
  final Duration latency;

  final DateTime Function() _clock;

  /// False to act like a server that cannot be reached.
  bool online = true;

  final _mailboxes = <int, FakeMailbox>{};
  final _messages = <int, FakeMessage>{};
  final _attachments = <int, FakeAttachment>{};
  final _accessTokens = <String, _Grant>{};
  final _refreshTokens = <String, _Session>{};
  final _streams = <int, List<StreamController<List<int>>>>{};
  final _domains = <String, FakeDomain>{};
  final _aliases = <int, FakeAlias>{};
  final _queue = <int, FakeQueueEntry>{};
  final _bans = <int, FakeBan>{};
  final _certificates = <int, FakeCertificate>{};
  final _pipelines = <int, FakePipeline>{};
  final _customFilters = <int, FakeCustomFilter>{};
  final _senderRules = <int, FakeSenderRule>{};
  final _audit = <FakeAuditEntry>[];

  /// The owner grants: by account, the accounts it created or linked.
  final _owned = <int, Set<int>>{};

  /// Read-only records, kept as the server answers them: newest first, and
  /// traces by the message they are for. [_traceLog] has every trace, those
  /// of mail that never became a message too.
  final _tlsReports = <Map<String, Object?>>[];
  final _traces = <int, Map<String, Object?>>{};
  final _traceLog = <Map<String, Object?>>[];
  final _appPasswords = <int, FakeAppPassword>{};
  var _nextId = 1;
  var _nextMailboxId = 1;

  /// For domains, aliases, queue entries and the other admin records.
  var _nextRowId = 1;
  var _nextEventId = 0;
  var _nextToken = 0;

  /// Until when sign-in's budget is spent; see [throttleSignIns].
  DateTime? _throttledUntil;

  /// A client that talks to this fake; hand it to a `RestmailClient`.
  http.Client get client => MockClient.streaming(_handle);

  /// What a mailbox holds in [folder], for a test to check.
  List<FakeMessage> messagesIn(String address, String folder) {
    final box = _mailboxAt(address);
    if (box == null) return const [];
    return [
      for (final m in _messages.values)
        if (m.mailboxId == box.id && m.folder == folder) m,
    ];
  }

  /// Mail arriving from outside: stored in [to]'s inbox and pushed to its
  /// open event streams.
  FakeMessage deliver({
    required String to,
    required String from,
    required String subject,
    String? fromName,
    String body = '',
  }) {
    final box = _mailboxAt(to);
    if (box == null) throw ArgumentError.value(to, 'to', 'No such mailbox');
    final message = _add(
      box,
      FakeMessage(
        folder: 'INBOX',
        sender: from,
        senderName: fromName,
        to: [FakeRecipient(box.address, box.displayName)],
        subject: subject,
        bodyText: body,
        receivedAt: _clock(),
      ),
    );
    _announce(message);
    return message;
  }

  /// Makes every access token stale, as time passing would.
  void expireAccessTokens() {
    final past = _clock().subtract(const Duration(seconds: 1));
    _accessTokens.updateAll(
      (_, grant) => _Grant(grant.session, past, grant.capabilities),
    );
  }

  /// Ends every session: the next refresh is refused.
  void revokeSessions() {
    _accessTokens.clear();
    _refreshTokens.clear();
  }

  /// Ends the sessions signed in as [address] only; the rest carry on.
  void revokeSessionsOf(String address) {
    final box = _mailboxAt(address);
    if (box == null) return;
    _accessTokens.removeWhere((_, grant) => grant.session.primary == box.id);
    _refreshTokens.removeWhere((_, session) => session.primary == box.id);
  }

  /// [address]'s password as it stands, for a test to check a change; null
  /// for an account with none.
  String? passwordOf(String address) => _mailboxAt(address)?.password;

  /// Adds an account on [host]'s domain, or another, that is set up
  /// already: with [capabilities] it is an administrator, and with
  /// [twoFactor] signing in takes [FakeAccounts.totpCode] too.
  void addAccount(
    String address, {
    String? password = FakeAccounts.adminPassword,
    Set<String> capabilities = const {},
    bool twoFactor = true,
    String name = '',
  }) {
    _addMailbox(
      address,
      name,
      password: password,
      twoFactor: twoFactor,
    ).capabilities = {
      ...capabilities,
    };
  }

  /// What the `admin` role carries, as the real server seeds it: everything
  /// but the people who run the server.
  static const adminRole = {
    'domains:read', 'domains:write', 'domains:delete', //
    'mailboxes:read', 'mailboxes:write', 'mailboxes:delete',
    'queue:read', 'queue:manage', 'bans:read', 'bans:write',
    'bans:delete', 'pipelines:read', 'pipelines:write',
    'pipelines:delete', 'messages:read', 'observability:read',
    'audit:read',
  };

  /// Changes what [address] may do on the admin API, as a change of its
  /// grants on the server does. An access token keeps the capabilities it
  /// was minted with, for the app to show; the session gets the new ones
  /// when it next refreshes. Creating an account reads them as they are.
  void grant(String address, Set<String> capabilities) {
    final box = _mailboxAt(address);
    if (box == null) {
      throw ArgumentError.value(address, 'address', 'No such account');
    }
    box.capabilities = {...capabilities};
  }

  /// The addresses [owner] holds the owner grant on: the accounts it
  /// created or linked.
  List<String> ownedBy(String owner) => [
    for (final id in _owned[_mailboxAt(owner)?.id] ?? const <int>{})
      ?_mailboxes[id]?.address,
  ];

  /// Whether a mailbox exists, for a test to check onboarding created it.
  bool hasMailbox(String address) => _mailboxAt(address) != null;

  /// What the admin API holds, for a test to check a change.
  List<FakeDomain> get domains => [..._domains.values];
  List<FakeAlias> get aliases => [..._aliases.values];
  List<FakeQueueEntry> get queue => [..._queue.values];
  List<FakeBan> get bans => [..._bans.values];
  List<FakeCertificate> get certificates => [..._certificates.values];
  List<FakePipeline> get pipelines => [..._pipelines.values];
  List<FakeCustomFilter> get customFilters => [..._customFilters.values];
  List<FakeSenderRule> get senderRules => [..._senderRules.values];

  /// The audit log, oldest first.
  List<FakeAuditEntry> get auditLog => [..._audit];

  /// Changes entry [seq] of the audit log behind the chain's back, as
  /// someone with the database might; checking the chain then finds it.
  void tamperWithAudit(int seq) =>
      _audit.firstWhere((e) => e.seq == seq).actorName = 'nobody';

  /// A mailbox's app passwords, revoked ones included, for a test to check.
  List<FakeAppPassword> appPasswordsOf(String address) {
    final box = _mailboxAt(address);
    return [
      for (final p in _appPasswords.values)
        if (p.mailboxId == box?.id) p,
    ];
  }

  /// Whether a mail client signing in to [address] with [password] would be
  /// let in now, as the gateways ask the real server: an app password of
  /// that mailbox, not revoked or expired, on a mailbox that is active. A
  /// use is recorded as its last.
  bool acceptsAppPassword(String address, String password) {
    final box = _mailboxAt(address);
    if (box == null || !box.active) return false;
    final now = _clock();
    for (final p in _appPasswords.values) {
      if (p.mailboxId != box.id || p.secret != password || p.isRevoked) {
        continue;
      }
      if (p.expiresAt case final expires? when !expires.isAfter(now)) {
        return false;
      }
      p.lastUsedAt = now;
      return true;
    }
    return false;
  }

  /// Turns on two-factor authentication for [address] after the fact, as
  /// the webmail does: a session signed in before it took no code.
  void enableTwoFactor(String address) {
    final box = _mailboxAt(address);
    if (box == null) {
      throw ArgumentError.value(address, 'address', 'No such mailbox');
    }
    box
      ..totpCode = FakeAccounts.totpCode
      ..recoveryCode = FakeAccounts.recoveryCode;
  }

  /// Spends sign-in's budget for [wait]: until then signing in, and making
  /// an app password, which shares the budget, answer 429 with the time
  /// left in Retry-After.
  void throttleSignIns(Duration wait) => _throttledUntil = _clock().add(wait);

  /// Ends every open event stream.
  void close() {
    final open = [for (final list in _streams.values) ...list];
    _streams.clear();
    for (final controller in open) {
      unawaited(controller.close());
    }
  }

  // ── Requests ──────────────────────────────────────────────────────────

  Future<http.StreamedResponse> _handle(
    http.BaseRequest request,
    http.ByteStream body,
  ) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (!online || request.url.host != host) {
      throw http.ClientException('Connection refused', request.url);
    }
    final bytes = await body.toBytes();
    try {
      return _route(request, request.url.pathSegments, bytes);
    } on _Reply catch (reply) {
      return reply.response;
    }
  }

  http.StreamedResponse _route(
    http.BaseRequest request,
    List<String> path,
    List<int> bytes,
  ) {
    final method = request.method;
    switch ((method, path)) {
      case ('GET', ['api', 'health']):
        return _json({
          'data': {'status': 'healthy', 'db': 'connected'},
        });
      case ('POST', ['api', 'v1', 'auth', 'login']):
        final body = _object(bytes);
        final email = '${body['email'] ?? ''}';
        return _audited(
          request,
          'auth.sign_in',
          actorKind: 'account',
          actorName: email,
          actorId: _mailboxAt(email)?.id,
          () => _login(body),
        );
      case ('POST', ['api', 'v1', 'auth', 'refresh']):
        return _refresh(_object(bytes));
      case ('POST', ['api', 'v1', 'auth', 'logout']):
        _refreshTokens.remove(_object(bytes)['refresh_token']);
        return _noContent();
    }

    if (path case ['api', 'v1', 'admin', ...final rest]) {
      // Changes are audited, and so is every read of the audit log.
      final action = rest.firstOrNull == 'audit'
          ? 'audit.read'
          : method == 'GET'
          ? null
          : 'admin.change';
      final box = _mailboxes[_accessTokens[_bearer(request)]?.session.primary];
      return action == null
          ? _adminApi(request, method, rest, bytes)
          : _audited(
              request,
              action,
              actorKind: box != null ? 'account' : 'anonymous',
              actorName: box?.address ?? '',
              actorId: box?.id,
              () => _adminApi(request, method, rest, bytes),
            );
    }
    if (_setup(request, method, path, bytes) case final response?) {
      return response;
    }

    final session = _authenticate(request);
    final query = request.url.queryParameters;
    return switch ((method, path)) {
      ('GET', ['api', 'v1', 'accounts']) => _json({
        'data': [for (final id in _reach(session)) _account(id, session)],
      }),
      // Recorded in the audit log, refused ones too, as the server does.
      ('POST', ['api', 'v1', 'accounts']) => _auditedBy(
        request,
        session,
        'accounts.create',
        () => _createAccount(session, _object(bytes)),
      ),
      ('POST', ['api', 'v1', 'accounts', 'link']) => _auditedBy(
        request,
        session,
        'accounts.link',
        () => _link(session, _object(bytes)),
      ),
      ('DELETE', ['api', 'v1', 'accounts', final id]) => _unlink(session, id),
      ('GET', ['api', 'v1', 'accounts', final id, 'folders']) => _folders(
        _own(session, id),
      ),
      (
        'GET',
        [
          'api',
          'v1',
          'accounts',
          final id,
          'folders',
          final folder,
          'messages',
        ],
      ) =>
        _page(_own(session, id), query, (m) => m.folder == folder),
      ('GET', ['api', 'v1', 'accounts', final id, 'search']) => _page(
        _own(session, id),
        query,
        _matcher(query),
      ),
      ('GET', ['api', 'v1', 'accounts', final id, 'quota']) => _quota(
        _own(session, id),
      ),
      ('GET', ['api', 'v1', 'accounts', final id, 'events']) => _events(
        _own(session, id),
      ),
      ('GET', ['api', 'v1', 'accounts', final id, 'credentials']) =>
        _listAppPasswords(_manageable(session, id)),
      // Recorded in the audit log, refused ones too, as the server does.
      ('POST', ['api', 'v1', 'accounts', final id, 'credentials']) =>
        _auditedBy(
          request,
          session,
          'credentials.create',
          () => _createAppPassword(session, id, bytes),
        ),
      (
        'DELETE',
        ['api', 'v1', 'accounts', final id, 'credentials', final credential],
      ) =>
        _auditedBy(
          request,
          session,
          'credentials.revoke',
          () => _revokeAppPassword(_manageable(session, id), credential),
        ),
      ('POST', ['api', 'v1', 'messages', 'send']) => _send(
        session,
        _object(bytes),
      ),
      ('POST', ['api', 'v1', 'messages', 'draft']) => _saveDraft(
        session,
        _object(bytes),
      ),
      ('PUT', ['api', 'v1', 'messages', 'draft', final id]) => _updateDraft(
        _draft(session, id),
        _object(bytes),
      ),
      ('POST', ['api', 'v1', 'messages', 'draft', final id, 'send']) =>
        _sendDraft(session, _draft(session, id)),
      ('GET', ['api', 'v1', 'messages', final id]) => _json({
        'data': _message(session, id).toJson(),
      }),
      ('PATCH', ['api', 'v1', 'messages', final id]) => _update(
        _message(session, id),
        _object(bytes),
      ),
      ('DELETE', ['api', 'v1', 'messages', final id]) => _delete(
        _message(session, id),
      ),
      ('GET', ['api', 'v1', 'messages', final id, 'attachments']) => _json({
        'data': [
          for (final a in _message(session, id).attachments) _attachmentJson(a),
        ],
      }),
      ('GET', ['api', 'v1', 'attachments', final id]) => _download(session, id),
      _ => _fail(404, 'not_found', 'No route for $method ${request.url.path}'),
    };
  }

  // ── Sessions ──────────────────────────────────────────────────────────

  http.StreamedResponse _login(Map<String, dynamic> body) {
    _spendSignInBudget();
    // There is no username: an account signs in by its address.
    if (body['email'] is! String) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'email': 'required'},
      );
    }
    final box = _mailboxAt(body['email'] as String);
    // An account with no password is answered as a wrong password.
    if (box == null ||
        box.password == null ||
        body['password'] != box.password) {
      _fail(401, 'unauthorized', 'Invalid email or password');
    }
    if (!box.active) _fail(401, 'unauthorized', 'Account is disabled');
    if (box.totpCode != null) {
      final code = body['totp_code'] as String? ?? '';
      final recovery = body['recovery_code'] as String? ?? '';
      if (code.isEmpty && recovery.isEmpty) {
        _fail(401, 'totp_required', 'Two-factor authentication code required');
      }
      if (code != box.totpCode && recovery != box.recoveryCode) {
        _fail(401, 'unauthorized', 'Invalid two-factor authentication code');
      }
    }
    // The real server marks a session that took the second factor, and a
    // refresh keeps the mark; making an app password asks for it.
    return _issue(
      _Session(box.id, twoFactor: box.totpCode != null),
      native: body['client'] == 'native',
    );
  }

  /// [_audited], for a request made by a mailbox's session.
  http.StreamedResponse _auditedBy(
    http.BaseRequest request,
    _Session session,
    String action,
    http.StreamedResponse Function() answer,
  ) => _audited(
    request,
    action,
    answer,
    actorKind: 'account',
    actorName: _mailboxes[session.primary]!.address,
    actorId: session.primary,
  );

  /// Answers 429 while sign-in's budget is spent, as login's throttle does.
  void _spendSignInBudget() {
    final until = _throttledUntil;
    if (until == null) return;
    final left = until.difference(_clock());
    if (left <= Duration.zero) {
      _throttledUntil = null;
      return;
    }
    throw _Reply(
      _json(
        {
          'error': {
            'code': 'rate_limited',
            'message': 'Too many requests; please slow down',
          },
        },
        status: 429,
        headers: {'retry-after': '${(left.inMilliseconds / 1000).ceil()}'},
      ),
    );
  }

  /// The server retires a refresh token when it is used; so does this. A
  /// refresh token sent in the body is a native client's, and so is the
  /// answer.
  http.StreamedResponse _refresh(Map<String, dynamic> body) {
    final session = _refreshTokens.remove(body['refresh_token']);
    if (session == null) _fail(401, 'unauthorized', 'Invalid refresh token');
    return _issue(session, native: true);
  }

  /// Hands out a new pair. Only a native client gets it in the body; a login
  /// that does not say `"client": "native"` is a browser's, which the real
  /// server answers with cookies, so here it gets no tokens at all. The
  /// capabilities are the account's grants as they are now; an account in
  /// setup holds none, and says what it owes.
  http.StreamedResponse _issue(_Session session, {required bool native}) {
    final access = _token('access'), refresh = _token('refresh');
    final user = _mailboxes[session.primary]!;
    final setup = user.setupRequired;
    final capabilities = setup.isEmpty ? {...user.capabilities} : <String>{};
    _accessTokens[access] = _Grant(
      session,
      _clock().add(accessTokenLifetime),
      capabilities,
    );
    _refreshTokens[refresh] = session;
    return _json({
      'data': {
        'expires_in': accessTokenLifetime.inSeconds,
        'user': {
          'id': user.id,
          'email': user.address,
          'display_name': user.displayName,
        },
        if (capabilities.isNotEmpty) 'capabilities': [...capabilities],
        if (setup.isNotEmpty) 'setup_required': setup,
        if (native) ...{
          'access_token': access,
          'refresh_token': refresh,
          'refresh_expires_in': _refreshTokenLifetime.inSeconds,
        },
      },
    });
  }

  /// The session of the request's access token. One whose account is in
  /// setup reaches nothing but the setup ([_setup]).
  _Session _authenticate(http.BaseRequest request) {
    final session = _sessionOf(request);
    if (_mailboxes[session.primary]!.setupRequired.isNotEmpty) {
      _fail(403, 'setup_required', 'Finish setting up this account first');
    }
    return session;
  }

  _Session _sessionOf(http.BaseRequest request) {
    final grant = _accessTokens[_bearer(request)];
    if (grant == null || !_clock().isBefore(grant.expiresAt)) {
      _fail(401, 'unauthorized', 'Invalid or expired token');
    }
    return grant.session;
  }

  /// The accounts [session] reaches: its own, then every one it holds the
  /// owner grant on, by address.
  List<int> _reach(_Session session) => [
    session.primary,
    ...([
      for (final id in _owned[session.primary] ?? const <int>{})
        ?_mailboxes[id],
    ]..sort((a, b) => a.address.compareTo(b.address))).map((b) => b.id),
  ];

  // ── Accounts and folders ──────────────────────────────────────────────

  Map<String, Object> _account(int id, _Session session) {
    final box = _mailboxes[id]!;
    return {
      'id': box.id,
      'address': box.address,
      'display_name': box.displayName,
      'is_primary': id == session.primary,
    };
  }

  /// Gives [session]'s account the owner grant on [box].
  void _grantOwner(_Session session, FakeMailbox box) =>
      (_owned[session.primary] ??= {}).add(box.id);

  /// The real server's rules (rest-mail-server#347): `mailboxes:write`
  /// covering the domain, as the account's grants are now; 409 for an
  /// address taken; 422 for a bad address, a domain the server doesn't host,
  /// or a short password. The creator becomes the owner.
  http.StreamedResponse _createAccount(
    _Session session,
    Map<String, dynamic> body,
  ) {
    final address = (body['address'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final at = address.indexOf('@');
    final invalid = <String, String>{
      if (address.isEmpty)
        'address': 'required'
      else if (at <= 0 || at == address.length - 1 || address.contains(' '))
        'address': 'must be a mail address: local@domain',
      if (password.isNotEmpty && password.length < 12)
        'password': 'must be at least 12 characters',
    };
    if (invalid.isNotEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: invalid,
      );
    }
    final domain = address.substring(at + 1);
    final held = _mailboxes[session.primary]!.capabilities;
    if (!held.contains('*') && !held.contains('mailboxes:write')) {
      _fail(403, 'forbidden', 'You cannot create accounts on $domain');
    }
    if (!_domains.containsKey(domain)) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'address': 'this server does not host $domain'},
      );
    }
    if (_mailboxAt(address) != null) {
      _fail(
        409,
        'already_exists',
        'An account with this address already exists',
      );
    }
    final box = _addMailbox(
      address,
      (body['display_name'] as String? ?? '').trim(),
      password: password.isEmpty ? null : password,
    );
    _grantOwner(session, box);
    return _json({'data': _account(box.id, session)}, status: 201);
  }

  /// Linking proves the account's password, and its second factor when it
  /// has one: the same proof as signing in to it. Throttled with sign-in.
  http.StreamedResponse _link(_Session session, Map<String, dynamic> body) {
    _spendSignInBudget();
    final address = (body['address'] as String? ?? '').trim();
    final password = body['password'] as String? ?? '';
    if (address.isEmpty || password.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'address': 'required', 'password': 'required'},
      );
    }
    final box = _mailboxAt(address);
    if (box == null ||
        box.password == null ||
        box.password != password ||
        !box.active) {
      _fail(401, 'unauthorized', 'Invalid email or password');
    }
    if (box.mustChangePassword) {
      _fail(
        403,
        'setup_required',
        'That account must first sign in and choose its own password',
      );
    }
    if (box.totpCode != null) {
      final code = body['totp_code'] as String? ?? '';
      final recovery = body['recovery_code'] as String? ?? '';
      if (code.isEmpty && recovery.isEmpty) {
        _fail(
          401,
          'totp_required',
          'That account has two-factor authentication: send its code too',
        );
      }
      if (code != box.totpCode && recovery != box.recoveryCode) {
        _fail(401, 'unauthorized', 'Invalid two-factor authentication code');
      }
    }
    if (box.id == session.primary) {
      _fail(409, 'already_exists', 'This is your own account');
    }
    if (_owned[session.primary]?.contains(box.id) ?? false) {
      _fail(409, 'already_exists', 'This account is already linked');
    }
    final name = (body['display_name'] as String? ?? '').trim();
    if (name.isNotEmpty && box.displayName.isEmpty) box.displayName = name;
    _grantOwner(session, box);
    return _json({'data': _account(box.id, session)}, status: 201);
  }

  /// Removes the session's own grant on the account.
  http.StreamedResponse _unlink(_Session session, String id) {
    final accountId = int.tryParse(id);
    if (accountId == null) _fail(400, 'bad_request', 'Invalid account ID');
    if (accountId == session.primary) {
      _fail(409, 'own_account', 'You cannot unlink your own account');
    }
    if (!(_owned[session.primary]?.remove(accountId) ?? false)) {
      _fail(404, 'not_found', 'Linked account not found');
    }
    return _noContent();
  }

  http.StreamedResponse _folders(FakeMailbox box) {
    final mine = _messages.values.where((m) => m.mailboxId == box.id).toList();
    final names = {..._standardFolders, for (final m in mine) m.folder};
    return _json({
      'data': [
        for (final name in names)
          {
            'name': name,
            'total': mine.where((m) => m.folder == name).length,
            'unread': mine.where((m) => m.folder == name && !m.isRead).length,
          },
      ],
    });
  }

  http.StreamedResponse _quota(FakeMailbox box) {
    final mine = _messages.values.where((m) => m.mailboxId == box.id).toList();
    final used = mine.fold<int>(0, (sum, m) => sum + m.sizeBytes);
    return _json({
      'data': {
        'quota_bytes': box.quotaBytes,
        'quota_used_bytes': used,
        'message_count': mine.length,
        'percent_used': used * 100 / box.quotaBytes,
      },
    });
  }

  // ── App passwords ─────────────────────────────────────────────────────
  //
  // The real server's rules (rest-mail-server#344, #347): the session's own
  // account, or one it owns; making one needs the session's own current
  // password entered again, and its second factor when it has one; the
  // secret is answered once; a revoked one stops working at once.

  /// `/accounts/{id}` for the app password routes: the session's own
  /// account, or one it holds the owner grant on.
  FakeMailbox _manageable(_Session session, String id) {
    final box = _mailboxes[int.tryParse(id)];
    if (box == null || !_reach(session).contains(box.id)) {
      _fail(404, 'not_found', 'Account not found');
    }
    return box;
  }

  http.StreamedResponse _listAppPasswords(FakeMailbox box) {
    final listed =
        [
          for (final p in _appPasswords.values)
            if (p.mailboxId == box.id && !p.isRevoked) p,
        ]..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt) != 0
              ? b.createdAt.compareTo(a.createdAt)
              : b.id.compareTo(a.id),
        );
    return _json({
      'data': [for (final p in listed) _appPasswordJson(p)],
    });
  }

  http.StreamedResponse _createAppPassword(
    _Session session,
    String id,
    List<int> bytes,
  ) {
    // Login's throttle sits in front of the route, before anything else.
    _spendSignInBudget();
    final box = _manageable(session, id);
    final own = _mailboxes[session.primary]!;
    final body = _object(bytes);
    final name = (body['name'] as String? ?? '').trim();
    final rawExpiry = body['expires_at'];
    final expiresAt = rawExpiry is String ? DateTime.tryParse(rawExpiry) : null;
    if (rawExpiry != null && expiresAt == null) {
      _fail(400, 'bad_request', 'Invalid request body');
    }
    final now = _clock();
    final invalid = switch (name) {
      '' => {'name': 'required'},
      _ when name.runes.length > 100 => {
        'name': 'must be at most 100 characters',
      },
      _ when name.runes.any((r) => r < 0x20 || (r >= 0x7f && r < 0xa0)) => {
        'name': 'must not contain control characters',
      },
      _ when expiresAt != null && !expiresAt.isAfter(now) => {
        'expires_at': 'must be in the future',
      },
      _ => null,
    };
    if (invalid != null) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: invalid,
      );
    }
    final password = body['password'] as String? ?? '';
    if (password.isEmpty) {
      _fail(
        401,
        'reauth_required',
        'Enter your current password to create an app password',
      );
    }
    if (password != own.password || !own.active || !box.active) {
      _fail(401, 'invalid_password', 'The password is incorrect');
    }
    if (own.totpCode != null && !session.twoFactor) {
      _fail(
        403,
        'two_factor_required',
        'Your account has two-factor authentication: sign in again with '
            'your code to create an app password',
      );
    }
    final publicId = _base62(12);
    final created = _appPasswords[_nextRowId] = FakeAppPassword(
      id: _nextRowId++,
      mailboxId: box.id,
      name: name,
      publicId: publicId,
      secret: 'rm_${publicId}_${_base62(43)}',
      createdAt: now,
      expiresAt: expiresAt,
    );
    return _json({
      'data': {..._appPasswordJson(created), 'password': created.secret},
    }, status: 201);
  }

  http.StreamedResponse _revokeAppPassword(FakeMailbox box, String id) {
    final credentialId = int.tryParse(id);
    if (credentialId == null) {
      _fail(400, 'bad_request', 'Invalid credential ID');
    }
    final found = _appPasswords[credentialId];
    if (found == null || found.mailboxId != box.id || found.isRevoked) {
      _fail(404, 'not_found', 'Credential not found');
    }
    found.revokedAt = _clock();
    return _noContent();
  }

  /// Never the secret.
  Map<String, Object?> _appPasswordJson(FakeAppPassword p) => {
    'id': p.id,
    'name': p.name,
    'kind': 'app_password',
    'public_id': p.publicId,
    'created_at': _time(p.createdAt),
    'last_used_at': p.lastUsedAt == null ? null : _time(p.lastUsedAt!),
    'expires_at': p.expiresAt == null ? null : _time(p.expiresAt!),
  };

  static final _secureRandom = Random.secure();
  static const _base62Alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  static String _base62(int length) => String.fromCharCodes([
    for (var i = 0; i < length; i++)
      _base62Alphabet.codeUnitAt(_secureRandom.nextInt(62)),
  ]);

  // ── Messages ──────────────────────────────────────────────────────────

  /// Newest first, with the server's cursor: base64 of `{"id": last}`.
  http.StreamedResponse _page(
    FakeMailbox box,
    Map<String, String> query,
    bool Function(FakeMessage) include,
  ) {
    final limit = int.tryParse(query['limit'] ?? '') ?? 50;
    final before = _cursorId(query['cursor']);
    final all =
        _messages.values
            .where((m) => m.mailboxId == box.id && include(m))
            .toList()
          ..sort((a, b) {
            final byTime = b.receivedAt.compareTo(a.receivedAt);
            return byTime != 0 ? byTime : b.id.compareTo(a.id);
          });
    final remaining = before == null
        ? all
        : all.where((m) => m.id < before).toList();
    final page = remaining.take(limit).toList();
    final hasMore = remaining.length > page.length;
    return _json({
      'data': [for (final m in page) m.toJson()],
      'pagination': {
        'cursor': hasMore
            ? base64.encode(utf8.encode(jsonEncode({'id': page.last.id})))
            : '',
        'has_more': hasMore,
        'total': all.length,
      },
    });
  }

  bool Function(FakeMessage) _matcher(Map<String, String> query) {
    final text = query['q']?.toLowerCase();
    final from = query['from']?.toLowerCase();
    final folder = query['folder'];
    final withFiles = query['has:attachment'] == 'true';
    final after = DateTime.tryParse(query['after'] ?? '');
    final before = DateTime.tryParse(query['before'] ?? '');
    return (m) =>
        (text == null ||
            '${m.subject} ${m.bodyText} ${m.sender} ${m.senderName ?? ''}'
                .toLowerCase()
                .contains(text)) &&
        (from == null ||
            '${m.sender} ${m.senderName ?? ''}'.toLowerCase().contains(from)) &&
        (folder == null || m.folder == folder) &&
        (!withFiles || m.attachments.isNotEmpty) &&
        (after == null || m.receivedAt.isAfter(after)) &&
        (before == null || m.receivedAt.isBefore(before));
  }

  http.StreamedResponse _send(_Session session, Map<String, dynamic> body) {
    final sender = _sender(session, body);
    final to = _recipients(body['to']);
    final cc = _recipients(body['cc']);
    final bcc = _recipients(body['bcc']);
    if (to.isEmpty && cc.isEmpty && bcc.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'to': 'at least one recipient is required'},
      );
    }
    final sent = _add(
      sender,
      FakeMessage(
        folder: 'Sent',
        sender: sender.address,
        senderName: sender.displayName,
        to: to,
        cc: cc,
        subject: body['subject'] as String? ?? '',
        bodyText: body['body_text'] as String? ?? '',
        bodyHtml: _nonEmpty(body['body_html']),
        receivedAt: _clock(),
        isRead: true,
        inReplyTo: _nonEmpty(body['in_reply_to']),
      ),
    );
    _emit(sender.id, 'folder_update', {'folder': 'Sent'});
    // Mail between the fake's own mailboxes is delivered, Bcc included.
    final addresses = {
      for (final r in [...to, ...cc, ...bcc]) r.address.toLowerCase(),
    };
    for (final address in addresses) {
      final target = _mailboxAt(address);
      if (target == null) continue;
      _announce(
        _add(
          target,
          FakeMessage(
            folder: 'INBOX',
            sender: sent.sender,
            senderName: sent.senderName,
            to: to,
            cc: cc,
            subject: sent.subject,
            bodyText: sent.bodyText,
            bodyHtml: sent.bodyHtml,
            receivedAt: _clock(),
            inReplyTo: sent.inReplyTo,
          ),
        ),
      );
    }
    return _json({'data': sent.toJson()}, status: 201);
  }

  http.StreamedResponse _saveDraft(
    _Session session,
    Map<String, dynamic> body,
  ) {
    final sender = _sender(session, body);
    final draft = _add(
      sender,
      FakeMessage(
        folder: 'Drafts',
        sender: sender.address,
        senderName: sender.displayName,
        receivedAt: _clock(),
        isRead: true,
        isDraft: true,
      ),
    );
    _fillDraft(draft, body);
    _emit(sender.id, 'folder_update', {'folder': 'Drafts'});
    return _json({'data': draft.toJson()}, status: 201);
  }

  http.StreamedResponse _updateDraft(
    FakeMessage draft,
    Map<String, dynamic> body,
  ) {
    _fillDraft(draft, body);
    return _json({'data': draft.toJson()});
  }

  void _fillDraft(FakeMessage draft, Map<String, dynamic> body) {
    if (body.containsKey('to')) draft.to = _recipients(body['to']);
    if (body.containsKey('cc')) draft.cc = _recipients(body['cc']);
    if (body['subject'] case final String subject) draft.subject = subject;
    if (body['body_text'] case final String text) draft.bodyText = text;
    if (body.containsKey('body_html')) {
      draft.bodyHtml = _nonEmpty(body['body_html']);
    }
    if (body['in_reply_to'] case final String id) draft.inReplyTo = id;
    draft.receivedAt = _clock();
  }

  /// Sends the draft as a new message and takes it out of Drafts.
  http.StreamedResponse _sendDraft(_Session session, FakeMessage draft) {
    final response = _send(session, {
      'from': draft.sender,
      'to': [for (final r in draft.to) r.address],
      'cc': [for (final r in draft.cc) r.address],
      'subject': draft.subject,
      'body_text': draft.bodyText,
      'body_html': draft.bodyHtml,
      'in_reply_to': draft.inReplyTo,
    });
    _messages.remove(draft.id);
    _emit(draft.mailboxId, 'message_deleted', {'message_id': draft.id});
    return response;
  }

  http.StreamedResponse _update(
    FakeMessage message,
    Map<String, dynamic> body,
  ) {
    final before = message.folder;
    if (body['is_read'] case final bool read) message.isRead = read;
    if (body['is_flagged'] case final bool flagged) message.isFlagged = flagged;
    if (body['is_starred'] case final bool starred) message.isStarred = starred;
    if (body['folder'] case final String folder when folder.isNotEmpty) {
      message.folder = folder;
    }
    _emit(message.mailboxId, 'message_updated', {
      'message_id': message.id,
      'folder': message.folder,
      'is_read': message.isRead,
      'is_flagged': message.isFlagged,
      'is_starred': message.isStarred,
      'is_draft': message.isDraft,
    });
    if (message.folder != before) {
      _emit(message.mailboxId, 'folder_update', {'folder': message.folder});
    }
    return _json({'data': message.toJson()});
  }

  /// To Trash, or gone for good if it is already there.
  http.StreamedResponse _delete(FakeMessage message) {
    if (message.folder == 'Trash') {
      _messages.remove(message.id);
    } else {
      message.folder = 'Trash';
    }
    _emit(message.mailboxId, 'message_deleted', {'message_id': message.id});
    return _noContent();
  }

  Map<String, Object> _attachmentJson(FakeAttachment a) => {
    'id': a.id,
    'message_id': a.messageId,
    'filename': a.filename,
    'content_type': a.contentType,
    'size_bytes': a.bytes.length,
    'storage_type': 'filesystem',
    'storage_ref': '',
    'checksum': '',
    'created_at': _clock().toUtc().toIso8601String(),
  };

  http.StreamedResponse _download(_Session session, String id) {
    final attachment = _attachments[int.tryParse(id)];
    final owner = attachment == null ? null : _messages[attachment.messageId];
    if (attachment == null ||
        owner == null ||
        !_reach(session).contains(owner.mailboxId)) {
      _fail(404, 'not_found', 'Attachment not found');
    }
    return http.StreamedResponse(
      Stream.value(attachment.bytes),
      200,
      headers: {'content-type': attachment.contentType},
    );
  }

  // ── Live events ───────────────────────────────────────────────────────

  http.StreamedResponse _events(FakeMailbox box) {
    final streams = _streams.putIfAbsent(box.id, () => []);
    late final StreamController<List<int>> controller;
    controller = StreamController<List<int>>(
      onCancel: () => streams.remove(controller),
    );
    streams.add(controller);
    return http.StreamedResponse(
      controller.stream,
      200,
      headers: {'content-type': 'text/event-stream'},
    );
  }

  void _emit(int mailboxId, String type, Map<String, Object?> data) {
    final frame = utf8.encode(
      'id: ${++_nextEventId}\nevent: $type\ndata: ${jsonEncode(data)}\n\n',
    );
    for (final controller in [...?_streams[mailboxId]]) {
      if (!controller.isClosed) controller.add(frame);
    }
  }

  void _announce(FakeMessage message) {
    _emit(message.mailboxId, 'new_message', {
      'message_id': message.id,
      'folder': message.folder,
      'sender': message.sender,
      'subject': message.subject,
    });
    _emit(message.mailboxId, 'folder_update', {
      'folder': message.folder,
      'unread_count': messagesIn(
        _mailboxes[message.mailboxId]!.address,
        message.folder,
      ).where((m) => !m.isRead).length,
    });
  }

  // ── State ─────────────────────────────────────────────────────────────

  void _load() {
    if (scenario == FakeScenario.freshInstall) {
      // The bootstrap account, made from the deploy's password, holding the
      // admin role; its domain is made with it.
      _addMailbox(
          FakeAccounts.adminEmail,
          '',
          password: FakeAccounts.bootstrapPassword,
        )
        ..capabilities = {...adminRole}
        ..mustChangePassword = true
        ..owesTwoFactor = true;
      return;
    }
    final now = _clock();
    final twoFactor = scenario == FakeScenario.twoFactor;
    final dana = _addMailbox(
      FakeAccounts.email,
      'Dana Ruiz',
      twoFactor: twoFactor,
    );
    final other = _addMailbox(FakeAccounts.otherEmail, 'Dana at Oakline');
    addAccount(FakeAccounts.adminEmail, capabilities: {'*'});
    addAccount(FakeAccounts.queueWatcher, capabilities: {'queue:read'});
    if (scenario == FakeScenario.empty) return;
    for (final message in danaMail(now)) {
      _add(dana, message);
    }
    for (final message in otherMail(now)) {
      _add(other, message);
    }
    _aliases[_nextRowId] = FakeAlias(
      id: _nextRowId++,
      source: 'hello@${FakeAccounts.host}',
      destination: FakeAccounts.email,
    );
    for (final (recipient, status, attempts, code, error, age) in [
      (
        'tom@ryeworks.test',
        'deferred',
        3,
        451,
        '451 4.7.1 Greylisted, please try again later',
        const Duration(minutes: 40),
      ),
      ('ana@harbor.test', 'pending', 0, 0, '', const Duration(minutes: 2)),
      (
        'nobody@ryeworks.test',
        'bounced',
        1,
        550,
        '550 5.1.1 No such user here',
        const Duration(hours: 5),
      ),
      ('lee@harbor.test', 'delivered', 1, 0, '', const Duration(hours: 9)),
    ]) {
      final entry = _queue[_nextRowId] = FakeQueueEntry(
        id: _nextRowId++,
        messageId: _nextId++,
        sender: FakeAccounts.email,
        recipient: recipient,
        status: status,
        attempts: attempts,
        lastErrorCode: code,
        lastError: error,
        createdAt: now.subtract(age),
      );
      _addTrace(
        messageId: entry.messageId,
        direction: 'outbound',
        outcome: 'queued',
        from: entry.sender,
        to: recipient,
        at: entry.createdAt,
        stages: [
          ('sender_verify', 'continue', 'pass'),
          ('header_cleanup', 'continue', 'removed 2 headers'),
          ('dkim_sign', 'continue', 'signed with mail._domainkey'),
        ],
      );
    }
    _loadAdminRecords(now, dana);
    _bans[_nextRowId] = FakeBan(
      id: _nextRowId++,
      ip: '203.0.113.7',
      protocol: 'smtp',
      reason: 'Too many failed sign-ins',
      createdAt: now.subtract(const Duration(hours: 2)),
      expiresAt: now.add(const Duration(hours: 22)),
    );
  }

  /// The logs, reports, keys and filters a running server has.
  void _loadAdminRecords(DateTime now, FakeMailbox dana) {
    final host = FakeAccounts.host;
    final latest = messagesIn(dana.address, 'INBOX')
      ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    if (latest.firstOrNull case final message?) {
      _addTrace(
        messageId: message.id,
        direction: 'inbound',
        outcome: 'delivered',
        transport: 'tls',
        from: message.sender,
        to: dana.address,
        at: message.receivedAt,
        stages: [
          ('size_check', 'continue', 'pass'),
          ('spf_check', 'continue', 'pass'),
          ('dkim_verify', 'continue', 'pass'),
          ('dmarc_check', 'continue', 'pass'),
          ('rspamd', 'continue', 'score 1.2'),
        ],
      );
    }
    // Mail turned away or held, which never became a message: in the
    // pipeline log, and in its analytics.
    for (final (from, outcome, reason, stages, transport, age) in [
      (
        'promo@deals.test',
        'rejected',
        'spam_threshold',
        [
          ('size_check', 'continue', 'pass'),
          ('spf_check', 'continue', 'pass'),
          ('dmarc_check', 'continue', 'pass'),
          ('rspamd', 'reject', 'score 14.2'),
        ],
        'tls',
        const Duration(hours: 3),
      ),
      (
        'billing@paypa1.test',
        'rejected',
        'dmarc_reject',
        [
          ('size_check', 'continue', 'pass'),
          ('spf_check', 'continue', 'fail'),
          ('dmarc_check', 'reject', 'fail'),
        ],
        'plaintext',
        const Duration(days: 1, hours: 2),
      ),
      (
        'invoices@unknown.test',
        'quarantined',
        'other',
        [
          ('spf_check', 'continue', 'pass'),
          ('dmarc_check', 'continue', 'pass'),
          ('hold_invoices', 'quarantine', 'matched'),
        ],
        'tls',
        const Duration(days: 2),
      ),
      (
        'news@deals.test',
        'rejected',
        'custom_reject',
        [
          ('size_check', 'continue', 'pass'),
          ('domain_allowlist', 'reject', 'blocked'),
        ],
        'tls',
        const Duration(days: 4),
      ),
    ]) {
      _addTrace(
        direction: 'inbound',
        outcome: outcome,
        reasonCode: reason,
        transport: transport,
        from: from,
        to: dana.address,
        at: now.subtract(age),
        stages: stages,
      );
    }

    final day = DateTime.utc(now.year, now.month, now.day);
    for (final (org, ok, failed, details) in [
      ('Google Inc.', 214, 0, null),
      (
        'Microsoft Corporation',
        96,
        3,
        [
          {
            'result-type': 'certificate-expired',
            'sending-mta-ip': '198.51.100.20',
            'receiving-mx-hostname': 'mx.$host',
            'failed-session-count': 3,
          },
        ],
      ),
    ]) {
      _tlsReports.add({
        'id': _nextRowId++,
        'domain_id': _domains[host]?.id ?? 0,
        'reporting_org': org,
        'start_date': _time(day.subtract(const Duration(days: 1))),
        'end_date': _time(day.subtract(const Duration(seconds: 1))),
        'policy_type': 'sts',
        'policy_domain': host,
        'total_successful': ok,
        'total_failure': failed,
        'failure_details': details,
        'raw_report': '',
        'received_at': _time(day.add(const Duration(hours: 3))),
        'created_at': _time(day.add(const Duration(hours: 3))),
      });
    }

    for (final domain in _domains.values) {
      _certificates[_nextRowId] = FakeCertificate(
        id: _nextRowId++,
        domain: domain.name,
        notBefore: now.subtract(const Duration(days: 30)),
        notAfter: now.add(const Duration(days: 60)),
      );
    }

    for (final (direction, filters) in [
      (
        'inbound',
        [
          'size_check',
          'spf_check',
          'dkim_verify',
          'dmarc_check',
          'rspamd',
          'greylist',
          'sieve',
        ],
      ),
      ('outbound', ['sender_verify', 'header_cleanup', 'dkim_sign']),
    ]) {
      _pipelines[_nextRowId] = FakePipeline(
        id: _nextRowId++,
        domain: host,
        direction: direction,
        filters: [
          for (final name in filters)
            {
              'name': name,
              'type': name == 'header_cleanup' || name == 'dkim_sign'
                  ? 'transform'
                  : 'action',
              'enabled': name != 'greylist',
              if (name == 'dkim_sign') 'unskippable': true,
            },
        ],
      );
    }
    _customFilters[_nextRowId] = FakeCustomFilter(
      id: _nextRowId++,
      domain: host,
      name: 'Hold invoices from strangers',
      description: 'Quarantines invoices from senders not in contacts',
      config: {
        'match': {'subject_contains': 'invoice', 'sender_known': false},
        'action': 'quarantine',
      },
    );

    for (final (pattern, list, reason, age) in [
      (
        'ana@harbor.test',
        'allow',
        'A customer: never hold her mail',
        const Duration(days: 5),
      ),
      ('@deals.test', 'block', 'Sends spam', const Duration(days: 2)),
    ]) {
      _senderRules[_nextRowId] = FakeSenderRule(
        id: _nextRowId++,
        domain: host,
        pattern: pattern,
        list: list,
        reason: reason,
        createdAt: now.subtract(age),
      );
    }
    _domains[host]!.mtaSts = FakeMtaStsPolicy(
      id: _nextRowId++,
      mxHosts: 'mx.$host',
    );
    // A week of the audit log, oldest first: sign-ins, a few changes, and
    // someone guessing passwords.
    final start = now.subtract(const Duration(days: 7));
    for (var i = 0; i < 60; i++) {
      final at = start.add(Duration(hours: i * 2 + 1));
      final (
        kind,
        name,
        id,
        action,
        outcome,
        method,
        route,
        status,
      ) = switch (i % 6) {
        0 || 3 => (
          'account',
          FakeAccounts.email,
          dana.id,
          'auth.sign_in',
          'success',
          'POST',
          '/api/v1/auth/login',
          200,
        ),
        1 => (
          'account',
          'root@$host',
          null,
          'auth.sign_in',
          'denied',
          'POST',
          '/api/v1/auth/login',
          401,
        ),
        2 => (
          'account',
          FakeAccounts.adminEmail,
          _mailboxAt(FakeAccounts.adminEmail)!.id,
          'admin.change',
          'success',
          'PATCH',
          '/api/v1/admin/mailboxes/{id}',
          200,
        ),
        4 => (
          'account',
          FakeAccounts.queueWatcher,
          _mailboxAt(FakeAccounts.queueWatcher)!.id,
          'admin.change',
          'denied',
          'POST',
          '/api/v1/admin/queue/{id}/retry',
          403,
        ),
        _ => ('system', 'system', null, 'system.prune', 'success', '', '', 0),
      };
      _record(
        FakeAuditEntry(
          seq: i + 1,
          occurredAt: at,
          actorKind: kind,
          actorId: id,
          actorName: name,
          action: action,
          outcome: outcome,
          method: method,
          route: route,
          status: status,
          ip: outcome == 'denied' && kind == 'account'
              ? '203.0.113.7'
              : '192.0.2.10',
        ),
      );
    }
  }

  /// Records how a message went through the filters, in the pipeline log
  /// and, when it became one, by its message.
  void _addTrace({
    required String direction,
    required String outcome,
    required String from,
    required String to,
    required DateTime at,
    required List<(String, String, String)> stages,
    int? messageId,
    String transport = '',
    String reasonCode = '',
  }) {
    final id = _nextRowId++;
    final trace = {
      'id': id,
      'message_id': messageId,
      'rfc_message_id': '<${messageId ?? 'trace-$id'}@fake.restmail.test>',
      'direction': direction,
      'transport': transport,
      'mail_from': from,
      'rcpt_to': to,
      'client_ip': direction == 'inbound' ? '198.51.100.20' : '',
      'pipeline_id': 0,
      'final_action': stages.lastOrNull?.$2 ?? 'continue',
      'outcome': outcome,
      'reason_code': reasonCode,
      'spam_score': direction == 'inbound'
          ? (reasonCode == 'spam_threshold' ? 14.2 : 1.2)
          : null,
      'duration_ms': 18 * stages.length,
      'stages': [
        for (final (filter, action, result) in stages)
          {
            'filter_name': filter,
            'filter_type': 'action',
            'action': action,
            'log': {'filter': filter, 'result': result},
            // Go writes a time.Duration as nanoseconds, whatever the name.
            'duration_ms': 18000000,
          },
      ],
      'sampled': true,
      'created_at': _time(at),
      'expires_at': null,
    };
    _traceLog.add(trace);
    if (messageId != null) _traces[messageId] = trace;
  }

  FakeMailbox _addMailbox(
    String address,
    String name, {
    bool twoFactor = false,
    String? password = FakeAccounts.password,
  }) {
    _domainNamed(address.split('@').last);
    final box = FakeMailbox(
      id: _nextMailboxId++,
      address: address,
      displayName: name,
      password: password,
      totpCode: twoFactor ? FakeAccounts.totpCode : null,
      recoveryCode: twoFactor ? FakeAccounts.recoveryCode : null,
    );
    return _mailboxes[box.id] = box;
  }

  FakeMessage _add(FakeMailbox box, FakeMessage message) {
    message
      ..id = _nextId++
      ..mailboxId = box.id;
    for (final attachment in message.attachments) {
      attachment
        ..id = _nextId++
        ..messageId = message.id;
      _attachments[attachment.id] = attachment;
    }
    return _messages[message.id] = message;
  }

  FakeMailbox? _mailboxAt(String address) {
    final wanted = address.trim().toLowerCase();
    return _mailboxes.values.where((b) => b.address == wanted).firstOrNull;
  }

  FakeDomain _domainNamed(String name) => _domains.putIfAbsent(
    name,
    () => FakeDomain(id: _nextRowId++, name: name),
  );

  FakeMailbox _own(_Session session, String id) {
    final box = _mailboxes[int.tryParse(id)];
    if (box == null || !_reach(session).contains(box.id)) {
      _fail(404, 'not_found', 'Account not found');
    }
    return box;
  }

  FakeMailbox _sender(_Session session, Map<String, dynamic> body) {
    final box = _mailboxAt(body['from'] as String? ?? '');
    if (box == null || !_reach(session).contains(box.id)) {
      _fail(403, 'forbidden', 'You cannot send from that address');
    }
    return box;
  }

  FakeMessage _message(_Session session, String id) {
    final message = _messages[int.tryParse(id)];
    if (message == null || !_reach(session).contains(message.mailboxId)) {
      _fail(404, 'not_found', 'Message not found');
    }
    return message;
  }

  FakeMessage _draft(_Session session, String id) {
    final message = _message(session, id);
    if (!message.isDraft) _fail(404, 'not_found', 'Draft not found');
    return message;
  }

  String _token(String kind) =>
      '$kind-${++_nextToken}-${_clock().microsecondsSinceEpoch}';

  // ── Admin ─────────────────────────────────────────────────────────────
  //
  // The real server's rules: an account in setup gets a session with no
  // capabilities that reaches only the calls finishing the setup, and every
  // other route answers 403 setup_required until it is done. After that, each
  // admin route needs its capability, as the access token carries them; `*`
  // allows them all. A session holding none is refused outright.

  /// Answers with [answer], and records the request in the audit log with
  /// how it went, refused or not.
  http.StreamedResponse _audited(
    http.BaseRequest request,
    String action,
    http.StreamedResponse Function() answer, {
    required String actorKind,
    required String actorName,
    int? actorId,
  }) {
    http.StreamedResponse response;
    try {
      response = answer();
    } on _Reply catch (reply) {
      response = reply.response;
    }
    final status = response.statusCode;
    _record(
      FakeAuditEntry(
        seq: (_audit.lastOrNull?.seq ?? 0) + 1,
        occurredAt: _clock(),
        actorKind: actorKind,
        // A sign-in names its account even when it fails, but proves it
        // only when it does not.
        actorId: status < 400 ? actorId : null,
        actorName: actorName,
        action: action,
        outcome: switch (status) {
          < 400 => 'success',
          401 || 403 || 429 => 'denied',
          < 500 => 'failed',
          _ => 'error',
        },
        method: request.method,
        route: request.url.path,
        status: status,
      ),
    );
    return response;
  }

  void _record(FakeAuditEntry entry) {
    entry
      ..prevHash = _audit.lastOrNull?.hash ?? _zeroHash
      ..hash = _auditHash(entry);
    _audit.add(entry);
  }

  static final _zeroHash = '0' * 64;

  /// Walks the chain from the first entry, as the server's check does.
  Map<String, Object?> _verifyAudit() {
    var previous = _zeroHash;
    var checked = 0;
    FakeAuditEntry? last;
    for (final entry in _audit) {
      final reason = entry.prevHash != previous
          ? 'prev_hash does not match the previous entry'
          : entry.hash != _auditHash(entry)
          ? 'hash does not match its contents'
          : null;
      if (reason != null) {
        return {
          'ok': false,
          'checked': checked,
          'first_seq': _audit.first.seq,
          'last_seq': last?.seq ?? 0,
          'last_hash': last?.hash ?? _zeroHash,
          'broken_at_seq': entry.seq,
          'reason': reason,
        };
      }
      previous = entry.hash;
      last = entry;
      checked++;
    }
    return {
      'ok': true,
      'checked': checked,
      'first_seq': _audit.firstOrNull?.seq ?? 0,
      'last_seq': last?.seq ?? 0,
      'last_hash': last?.hash ?? _zeroHash,
    };
  }

  http.StreamedResponse _auditList(Map<String, String> query) {
    final invalid = <String, String>{};
    final kind = query['actor_kind'], outcome = query['outcome'];
    if (kind != null &&
        !const {'account', 'system', 'anonymous'}.contains(kind)) {
      invalid['actor_kind'] = 'must be account, system or anonymous';
    }
    if (outcome != null &&
        !const {'success', 'denied', 'failed', 'error'}.contains(outcome)) {
      invalid['outcome'] = 'must be success, denied, failed or error';
    }
    final before = int.tryParse(query['before_seq'] ?? '');
    if (query['before_seq'] != null && (before == null || before < 1)) {
      invalid['before_seq'] = 'must be a positive whole number';
    }
    final limit = int.tryParse(query['limit'] ?? '50');
    if (limit == null || limit < 1 || limit > 200) {
      invalid['limit'] = 'must be between 1 and 200';
    }
    if (invalid.isNotEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: invalid,
      );
    }
    final matching = [
      for (final entry in _audit.reversed)
        if ((kind == null || entry.actorKind == kind) &&
            (outcome == null || entry.outcome == outcome) &&
            (before == null || entry.seq < before))
          entry,
    ];
    final page = matching.take(limit!).toList();
    final more = matching.length > page.length;
    return _json({
      'data': [for (final entry in page) _auditJson(entry)],
      'pagination': {'has_more': more, if (more) 'cursor': '${page.last.seq}'},
    });
  }

  Map<String, Object?> _auditJson(FakeAuditEntry e) => {
    'seq': e.seq,
    'occurred_at': _time(e.occurredAt),
    'actor_kind': e.actorKind,
    'actor_id': e.actorId,
    'actor_name': e.actorName,
    'credential_id': null,
    'session_id': '',
    'action': e.action,
    'outcome': e.outcome,
    'error_code': '',
    'method': e.method,
    'route': e.route,
    'status': e.status,
    'target': <String, String>{},
    'ip': e.ip,
    'user_agent': e.userAgent,
    'request_id': 'req-${e.seq}',
    'prev_hash': e.prevHash,
    'hash': e.hash,
  };

  String? _bearer(http.BaseRequest request) {
    final header = request.headers['authorization'] ?? '';
    return header.startsWith('Bearer ')
        ? header.substring('Bearer '.length)
        : null;
  }

  /// Answers an account's calls finishing its setup, or null for a route
  /// that is not one: the only ones a session in setup reaches.
  http.StreamedResponse? _setup(
    http.BaseRequest request,
    String method,
    List<String> path,
    List<int> bytes,
  ) {
    if (method != 'POST') return null;
    final route = switch (path) {
      ['api', 'v1', 'auth', '2fa', 'enroll'] => 'enroll',
      ['api', 'v1', 'auth', '2fa', 'confirm'] => 'confirm',
      ['api', 'v1', 'auth', 'password'] => 'password',
      _ => null,
    };
    if (route == null) return null;
    final box = _mailboxes[_sessionOf(request).primary]!;
    final body = _object(bytes);

    switch (route) {
      case 'enroll':
        if (box.totpCode != null) {
          _fail(
            409,
            'conflict',
            'Two-factor authentication is already enabled',
          );
        }
        box.totpPending = true;
        return _json({
          'data': {
            'secret': FakeAccounts.totpSecret,
            'otpauth_url': FakeAccounts.totpUri,
            'recovery_codes': [FakeAccounts.recoveryCode],
          },
        });
      case 'confirm':
        if (!box.totpPending) {
          _fail(400, 'bad_request', 'No pending 2FA enrollment');
        }
        if (body['code'] != FakeAccounts.totpCode) {
          _fail(401, 'unauthorized', 'Invalid 2FA code');
        }
        box
          ..totpPending = false
          ..totpCode = FakeAccounts.totpCode
          ..recoveryCode = FakeAccounts.recoveryCode;
        return _noContent();
      case 'password':
        final current = body['current_password'] as String? ?? '';
        final next = body['new_password'] as String? ?? '';
        if (current.isEmpty || next.isEmpty) {
          _fail(
            422,
            'validation_error',
            'Validation failed',
            fields: {
              'current_password': 'required',
              'new_password': 'required',
            },
          );
        }
        if (current != box.password) {
          _fail(401, 'unauthorized', 'Current password is incorrect');
        }
        if (next.length < 12) {
          _fail(
            422,
            'validation_error',
            'Validation failed',
            fields: {'new_password': 'must be at least 12 characters'},
          );
        }
        if (next == current) {
          _fail(
            422,
            'validation_error',
            'Validation failed',
            fields: {'new_password': 'must differ from the current password'},
          );
        }
        box
          ..password = next
          ..mustChangePassword = false;
        // Every session of the account ends, this one included.
        revokeSessionsOf(box.address);
        return _json({
          'data': {
            'message': 'Password changed. Sign in again with the new password.',
          },
        });
    }
    return null;
  }

  /// What the caller's access token may do on the admin API, refusing one
  /// that may do nothing there.
  Set<String> _adminCapabilities(http.BaseRequest request) {
    _authenticate(request);
    final grant = _accessTokens[_bearer(request)]!;
    if (grant.capabilities.isEmpty) {
      _fail(403, 'forbidden', 'Admin access required');
    }
    return grant.capabilities;
  }

  /// `/api/v1/admin/…`, each route behind the capability the real server's
  /// routes.go gives it.
  http.StreamedResponse _adminApi(
    http.BaseRequest request,
    String method,
    List<String> path,
    List<int> bytes,
  ) {
    final capabilities = _adminCapabilities(request);
    void need(String capability) {
      if (!capabilities.contains('*') && !capabilities.contains(capability)) {
        _fail(403, 'forbidden', 'Insufficient permissions');
      }
    }

    final query = request.url.queryParameters;
    switch ((method, path)) {
      case ('GET', ['queue']):
        need('queue:read');
        return _queueList(query);
      case ('GET', ['queue', 'stats']):
        need('queue:read');
        final counts = <String, int>{};
        for (final entry in _queue.values) {
          counts.update(entry.status, (n) => n + 1, ifAbsent: () => 1);
        }
        return _json({
          'data': {...counts, 'total': _queue.length},
        });
      case ('GET', ['queue', final id]):
        need('queue:read');
        return _json({'data': _queueJson(_queueEntry(id))});
      case ('POST', ['queue', final id, 'retry']):
        need('queue:manage');
        final entry = _queueEntry(id);
        if (entry.status != 'pending' && entry.status != 'deferred') {
          _fail(
            400,
            'bad_request',
            'Only pending or deferred entries can be retried',
          );
        }
        entry.status = 'pending';
        return _json({
          'data': {'status': 'retrying'},
        });
      case ('POST', ['queue', final id, 'bounce']):
        need('queue:manage');
        _queueEntry(id)
          ..status = 'bounced'
          ..lastError = 'manually bounced by admin';
        return _json({
          'data': {'status': 'bounced'},
        });
      case ('DELETE', ['queue', final id]):
        need('queue:manage');
        _queue.remove(int.tryParse(id));
        return _noContent();

      case ('GET', ['domains']):
        need('domains:read');
        return _listPage(
          _domains.values.toList()..sort((a, b) => a.name.compareTo(b.name)),
          query,
          _domainJson,
        );
      case ('POST', ['domains']):
        need('domains:write');
        return _createDomain(_object(bytes));
      case ('GET', ['domains', final id]):
        need('domains:read');
        return _json({'data': _domainJson(_domain(id))});
      case ('PATCH', ['domains', final id]):
        need('domains:write');
        final domain = _domain(id);
        if (_object(bytes)['active'] case final bool active) {
          domain.active = active;
        }
        return _json({'data': _domainJson(domain)});
      case ('DELETE', ['domains', final id]):
        need('domains:delete');
        final domain = _domain(id);
        if (_mailboxes.values.any((b) => b.domain == domain.name) ||
            _aliases.values.any((a) => a.domain == domain.name)) {
          _fail(
            409,
            'conflict',
            'Delete the mailboxes and aliases on ${domain.name} first',
          );
        }
        _domains.remove(domain.name);
        return _noContent();
      case ('GET', ['domains', final id, 'dns']):
        need('domains:read');
        return _json({'data': _dnsCheck(_domain(id))});

      case ('GET', ['domains', final id, final list])
          when list == 'allowlist' || list == 'blocklist':
        need('domains:read');
        final domainId = int.tryParse(id);
        return _json({
          'data': [
            for (final rule
                in _senderRules.values.toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
              if (rule.list == _listType(list) &&
                  _domains[rule.domain]?.id == domainId)
                _senderRuleJson(rule),
          ],
        });
      case ('POST', ['domains', final id, final list])
          when list == 'allowlist' || list == 'blocklist':
        need('domains:write');
        return _addSenderRule(id, _listType(list), _object(bytes));
      case ('DELETE', ['domains', final id, final list, final ruleId])
          when list == 'allowlist' || list == 'blocklist':
        need('domains:write');
        final type = _listType(list);
        final rule = _senderRules[int.tryParse(ruleId)];
        if (rule == null ||
            rule.list != type ||
            _domains[rule.domain]?.id != int.tryParse(id)) {
          _fail(
            404,
            'not_found',
            '${type == 'allow' ? 'Allowlist' : 'Blocklist'} rule not found',
          );
        }
        _senderRules.remove(rule.id);
        return _noContent();

      case ('GET', ['domains', final id, 'mta-sts']):
        need('domains:read');
        final domain = _domains.values
            .where((d) => d.id == int.tryParse(id))
            .firstOrNull;
        if (domain == null) _fail(404, 'not_found', 'Domain not found');
        final policy =
            domain.mtaSts ??
            _fail(404, 'not_found', 'No MTA-STS policy found for this domain');
        return _json({'data': _mtaStsJson(domain, policy)});
      case ('PUT', ['domains', final id, 'mta-sts']):
        need('domains:write');
        return _setMtaSts(id, _object(bytes));
      case ('DELETE', ['domains', final id, 'mta-sts']):
        need('domains:write');
        final domain = _domains.values
            .where((d) => d.id == int.tryParse(id))
            .firstOrNull;
        if (domain?.mtaSts == null) {
          _fail(404, 'not_found', 'No MTA-STS policy found for this domain');
        }
        domain!.mtaSts = null;
        return _noContent();

      case ('GET', ['mailboxes']):
        need('mailboxes:read');
        final domain = _domainFilter(query);
        return _listPage(
          _mailboxes.values
              .where((b) => domain == null || b.domain == domain.name)
              .toList()
            ..sort((a, b) => a.address.compareTo(b.address)),
          query,
          _mailboxJson,
        );
      case ('GET', ['mailboxes', final id]):
        need('mailboxes:read');
        return _json({'data': _mailboxJson(_adminMailbox(id))});
      case ('PATCH', ['mailboxes', final id]):
        need('mailboxes:write');
        return _updateMailbox(_adminMailbox(id), _object(bytes));
      case ('DELETE', ['mailboxes', final id]):
        need('mailboxes:delete');
        _deleteMailbox(_adminMailbox(id));
        return _noContent();

      case ('GET', ['aliases']):
        need('mailboxes:read');
        final domain = _domainFilter(query);
        return _listPage(
          _aliases.values
              .where((a) => domain == null || a.domain == domain.name)
              .toList()
            ..sort((a, b) => a.source.compareTo(b.source)),
          query,
          _aliasJson,
        );
      case ('POST', ['aliases']):
        need('mailboxes:write');
        return _createAlias(_object(bytes));
      case ('GET', ['aliases', final id]):
        need('mailboxes:read');
        return _json({'data': _aliasJson(_alias(id))});
      case ('PATCH', ['aliases', final id]):
        need('mailboxes:write');
        final alias = _alias(id);
        final body = _object(bytes);
        if (body['destination_address'] case final String to
            when to.contains('@')) {
          alias.destination = to.trim().toLowerCase();
        }
        if (body['active'] case final bool active) alias.active = active;
        return _json({'data': _aliasJson(alias)});
      case ('DELETE', ['aliases', final id]):
        need('mailboxes:delete');
        _aliases.remove(_alias(id).id);
        return _noContent();

      case ('GET', ['stats']):
        // The real server asks no capability of this one, only an admin.
        return _stats();

      case ('GET', ['bans']):
        need('bans:read');
        return _listPage(
          _bans.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          query,
          _banJson,
        );
      case ('POST', ['bans']):
        need('bans:write');
        return _createBan(_object(bytes));
      case ('DELETE', ['bans', final id]):
        need('bans:delete');
        _bans.remove(int.tryParse(id));
        return _noContent();

      case ('GET', ['logs', 'delivery']):
        need('messages:read');
        final status = query['status'], recipient = query['recipient'];
        return _listPage(
          _queue.values
              .where(
                (e) =>
                    (status == null || e.status == status) &&
                    (recipient == null ||
                        e.recipient.contains(recipient.toLowerCase())),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          query,
          _queueJson,
        );
      case ('GET', ['messages', final id, 'trace']):
        need('observability:read');
        return _json({
          'data':
              _traces[int.tryParse(id)] ??
              _fail(404, 'not_found', 'No pipeline trace for this message'),
        });
      case ('GET', ['tls-reports']):
        need('domains:read');
        return _listPage(_tlsReports, query, (r) => r);

      case ('GET', ['audit']):
        need('audit:read');
        return _auditList(query);
      case ('GET', ['audit', 'verify']):
        need('audit:read');
        return _json({'data': _verifyAudit()});

      case ('GET', ['dkim']):
        need('domains:read');
        final signing = _domains.values.where((d) => d.signs).toList();
        // Go's nil slice: no keys at all is null, not [].
        return _json({
          'data': signing.isEmpty
              ? null
              : [
                  for (final d in signing)
                    {
                      'domain_id': d.id,
                      'domain': d.name,
                      'selector': d.dkimSelector,
                      'has_key': true,
                    },
                ],
        });
      case ('DELETE', ['dkim', final id]):
        need('domains:write');
        _domain(id).dkimSelector = '';
        return _noContent();

      case ('GET', ['certificates']):
        need('domains:read');
        return _listPage(
          _certificates.values.toList(),
          query,
          _certificateJson,
        );
      case ('DELETE', ['certificates', final id]):
        need('domains:write');
        if (_certificates.remove(int.tryParse(id)) == null) {
          _fail(404, 'not_found', 'Certificate not found');
        }
        return _noContent();

      case ('GET', ['pipelines', 'logs']):
        need('pipelines:read');
        final direction = query['direction'], outcome = query['outcome'];
        return _listPage(
          _traceLog
              .where(
                (t) =>
                    (direction == null || t['direction'] == direction) &&
                    (outcome == null || t['outcome'] == outcome),
              )
              .toList()
            ..sort((a, b) => _createdAt(b).compareTo(_createdAt(a))),
          query,
          (t) => t,
        );
      case ('GET', ['pipelines', 'analytics']):
        need('observability:read');
        return _json({'data': _pipelineAnalytics(query['window'])});

      case ('GET', ['pipelines']):
        need('pipelines:read');
        return _listPage(
          _pipelines.values.toList()
            ..sort((a, b) => a.direction.compareTo(b.direction)),
          query,
          _pipelineJson,
        );
      case ('PATCH', ['pipelines', final id]):
        need('pipelines:write');
        final pipeline =
            _pipelines[int.tryParse(id)] ??
            _fail(404, 'not_found', 'Pipeline not found');
        if (_object(bytes)['active'] case final bool active) {
          pipeline.active = active;
        }
        return _json({'data': _pipelineJson(pipeline)});
      case ('DELETE', ['pipelines', final id]):
        need('pipelines:delete');
        _pipelines.remove(int.tryParse(id));
        return _json({
          'data': {'status': 'deleted'},
        });

      case ('GET', ['custom-filters']):
        need('pipelines:read');
        return _listPage(
          _customFilters.values.toList()
            ..sort((a, b) => a.name.compareTo(b.name)),
          query,
          _customFilterJson,
        );
      case ('PATCH', ['custom-filters', final id]):
        need('pipelines:write');
        final filter =
            _customFilters[int.tryParse(id)] ??
            _fail(404, 'not_found', 'Custom filter not found');
        if (_object(bytes)['enabled'] case final bool enabled) {
          filter.enabled = enabled;
        }
        return _json({'data': _customFilterJson(filter)});
      case ('DELETE', ['custom-filters', final id]):
        need('pipelines:delete');
        _customFilters.remove(int.tryParse(id));
        return _json({
          'data': {'status': 'deleted'},
        });
    }
    _fail(404, 'not_found', 'No route for $method ${request.url.path}');
  }

  http.StreamedResponse _queueList(Map<String, String> query) {
    final status = query['status'];
    final (limit, offset) = _paging(query);
    final all =
        _queue.values
            .where((e) => status == null || e.status == status)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _json({
      'data': {
        'items': [for (final e in all.skip(offset).take(limit)) _queueJson(e)],
        'total': all.length,
        'limit': limit,
        'offset': offset,
      },
    });
  }

  /// The real server's `limit` and `offset`: 50 by default, 200 at most.
  (int, int) _paging(Map<String, String> query) => (
    (int.tryParse(query['limit'] ?? '') ?? 50).clamp(1, 200),
    max(0, int.tryParse(query['offset'] ?? '') ?? 0),
  );

  /// `{"data": [...], "pagination": {...}}`, as the admin lists answer.
  http.StreamedResponse _listPage<T>(
    List<T> all,
    Map<String, String> query,
    Map<String, Object?> Function(T) toJson,
  ) {
    final (limit, offset) = _paging(query);
    return _json({
      'data': [for (final item in all.skip(offset).take(limit)) toJson(item)],
      'pagination': {
        'total': all.length,
        'has_more': offset + limit < all.length,
      },
    });
  }

  String _time(DateTime time) => time.toUtc().toIso8601String();

  Map<String, Object?> _queueJson(FakeQueueEntry e) => {
    'id': e.id,
    'message_id': e.messageId,
    'sender': e.sender,
    'recipient': e.recipient,
    'domain': e.domain,
    'body_type': '8BITMIME',
    'status': e.status,
    'attempts': e.attempts,
    'last_attempt': e.attempts == 0 ? null : _time(e.createdAt),
    'next_attempt': _time(e.createdAt.add(const Duration(minutes: 15))),
    'last_error': e.lastError,
    'last_error_code': e.lastErrorCode,
    'max_retries': 30,
    'created_at': _time(e.createdAt),
    'expires_at': _time(e.createdAt.add(const Duration(days: 5))),
  };

  Map<String, Object?> _domainJson(FakeDomain d) => {
    'id': d.id,
    'name': d.name,
    'server_type': 'restmail',
    'active': d.active,
    'default_quota_bytes': 1073741824,
    'dkim_selector': d.dkimSelector,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
  };

  Map<String, Object?> _mailboxJson(FakeMailbox b) => {
    'id': b.id,
    'domain_id': _domains[b.domain]?.id ?? 0,
    'local_part': b.address.substring(0, b.address.indexOf('@')),
    'address': b.address,
    'display_name': b.displayName,
    'quota_bytes': b.quotaBytes,
    'quota_used_bytes': _messages.values
        .where((m) => m.mailboxId == b.id)
        .fold<int>(0, (sum, m) => sum + m.sizeBytes),
    'active': b.active,
    'last_login_at': null,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
  };

  Map<String, Object?> _aliasJson(FakeAlias a) => {
    'id': a.id,
    'domain_id': _domains[a.domain]?.id ?? 0,
    'source_address': a.source,
    'destination_address': a.destination,
    'active': a.active,
    'created_at': _time(_clock()),
  };

  Map<String, Object?> _certificateJson(FakeCertificate c) => {
    'id': c.id,
    'domain_id': _domains[c.domain]?.id ?? 0,
    'issuer': c.issuer,
    'not_before': _time(c.notBefore),
    'not_after': _time(c.notAfter),
    'auto_renew': c.autoRenew,
    'created_at': _time(c.notBefore),
    'updated_at': _time(c.notBefore),
    if (_domains[c.domain] case final domain?) 'domain': _domainJson(domain),
  };

  // The server does not load a pipeline's or a filter's domain into the
  // list, so it comes back empty, as Go writes a zero struct.
  static const _noDomain = {'id': 0, 'name': ''};

  Map<String, Object?> _pipelineJson(FakePipeline p) => {
    'id': p.id,
    'domain_id': _domains[p.domain]?.id ?? 0,
    'direction': p.direction,
    'filters': p.filters,
    'active': p.active,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
    'domain': _noDomain,
  };

  Map<String, Object?> _customFilterJson(FakeCustomFilter f) => {
    'id': f.id,
    'domain_id': _domains[f.domain]?.id ?? 0,
    'name': f.name,
    'description': f.description,
    'filter_type': f.filterType,
    'direction': f.direction,
    'config': f.config,
    'enabled': f.enabled,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
    'domain': _noDomain,
  };

  Map<String, Object?> _senderRuleJson(FakeSenderRule r) => {
    'id': r.id,
    'domain_id': _domains[r.domain]?.id ?? 0,
    'pattern': r.pattern,
    'list_type': r.list,
    if (r.reason.isNotEmpty) 'reason': r.reason,
    'created_at': _time(r.createdAt),
  };

  Map<String, Object?> _mtaStsJson(FakeDomain d, FakeMtaStsPolicy p) => {
    'id': p.id,
    'domain_id': d.id,
    'mode': p.mode,
    'mx_hosts': p.mxHosts,
    'max_age': p.maxAge,
    'active': p.active,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
    'domain': _noDomain,
  };

  DateTime _createdAt(Map<String, Object?> record) =>
      DateTime.parse(record['created_at']! as String);

  /// `allow` or `block`, from the route's `allowlist` or `blocklist`.
  static String _listType(String route) =>
      route == 'allowlist' ? 'allow' : 'block';

  http.StreamedResponse _addSenderRule(
    String id,
    String list,
    Map<String, dynamic> body,
  ) {
    final pattern = body['pattern'] as String? ?? '';
    if (pattern.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'pattern': 'required'},
      );
    }
    final domain = _domain(id);
    final name = list == 'allow' ? 'allowlist' : 'blocklist';
    // The server's unique index refuses the same sender twice, and its
    // handler reports that as a failure of its own.
    if (_senderRules.values.any(
      (r) => r.domain == domain.name && r.list == list && r.pattern == pattern,
    )) {
      _fail(500, 'internal_error', 'Failed to create $name rule');
    }
    final rule = _senderRules[_nextRowId] = FakeSenderRule(
      id: _nextRowId++,
      domain: domain.name,
      pattern: pattern,
      list: list,
      reason: body['reason'] as String? ?? '',
      createdAt: _clock(),
    );
    return _json({'data': _senderRuleJson(rule)}, status: 201);
  }

  /// The server's upsert: what is left out or empty stays as it was, and a
  /// new policy starts in testing, for a week.
  http.StreamedResponse _setMtaSts(String id, Map<String, dynamic> body) {
    final domain =
        _domains.values.where((d) => d.id == int.tryParse(id)).firstOrNull ??
        _fail(404, 'not_found', 'Domain not found');
    final mode = body['mode'] as String? ?? '';
    if (mode.isNotEmpty &&
        !const {'none', 'testing', 'enforce'}.contains(mode)) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'mode': 'Must be one of: none, testing, enforce'},
      );
    }
    final maxAge = body['max_age'] as int?;
    if (maxAge != null && maxAge < 0) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'max_age': 'Must be a non-negative integer (seconds)'},
      );
    }
    final created = domain.mtaSts == null;
    final policy = domain.mtaSts ??= FakeMtaStsPolicy(id: _nextRowId++);
    if (mode.isNotEmpty) policy.mode = mode;
    if (body['mx_hosts'] case final String hosts when hosts.isNotEmpty) {
      policy.mxHosts = hosts;
    }
    if (maxAge != null) policy.maxAge = maxAge;
    if (body['active'] case final bool active) policy.active = active;
    return _json({
      'data': _mtaStsJson(domain, policy),
    }, status: created ? 201 : 200);
  }

  /// What the fake's DNS holds: the sample host is set up, Oakline only
  /// half, and a domain added since not at all.
  static Map<String, String> _publishedDns(String domain) {
    if (domain == FakeAccounts.host) {
      return {
        'MX': 'mx.$domain. (pri 10)',
        'SPF': 'v=spf1 mx -all',
        'DMARC': 'v=DMARC1; p=quarantine; rua=mailto:dmarc@$domain',
        'DKIM':
            'v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA',
        'MTA-STS': 'v=STSv1; id=20261001',
        'TLS-RPT': 'v=TLSRPTv1; rua=mailto:tls-reports@$domain',
      };
    }
    if (domain == FakeAccounts.otherEmail.split('@').last) {
      return {
        'MX': 'mx.${FakeAccounts.host}. (pri 10)',
        'SPF': 'v=spf1 mx ~all',
      };
    }
    return const {};
  }

  /// The server's DNS check, record by record, with its own wording.
  Map<String, Object?> _dnsCheck(FakeDomain domain) {
    final name = domain.name;
    final published = _publishedDns(name);
    final records = [
      for (final (type, at, missing) in [
        ('MX', name, 'No MX records found'),
        ('SPF', name, 'No SPF record (v=spf1...) found in TXT records'),
        ('DMARC', '_dmarc.$name', 'No DMARC record found'),
        (
          'DKIM',
          'default._domainkey.$name',
          'No DKIM record found for default selector',
        ),
        ('MTA-STS', '_mta-sts.$name', 'No MTA-STS TXT record found'),
        ('TLS-RPT', '_smtp._tls.$name', 'No TLS-RPT TXT record found'),
      ])
        if (published[type] case final value?)
          {'type': type, 'name': at, 'status': 'ok', 'value': value}
        else
          {'type': type, 'name': at, 'status': 'missing', 'message': missing},
    ];
    return {
      'domain': name,
      'records': records,
      'summary': '${published.length}/${records.length} records verified',
    };
  }

  /// The server's funnel over [window] (a Go duration in hours, a day by
  /// default), counted here from the traces rather than from rollups. Go
  /// writes the counts as floats, and an empty list as null.
  Map<String, Object?> _pipelineAnalytics(String? window) {
    final hours =
        int.tryParse(RegExp(r'^(\d+)h$').firstMatch(window ?? '')?[1] ?? '') ??
        24;
    final until = _clock(), since = until.subtract(Duration(hours: hours));
    final traces = _traceLog.where((t) => !_createdAt(t).isBefore(since));
    final received = <String, double>{},
        verdicts = <(String, String), double>{},
        decisions = <(String, String), double>{},
        outcomes = <(String, String), double>{},
        reasons = <String, double>{};
    void bump<K>(Map<K, double> counts, K key) =>
        counts.update(key, (n) => n + 1, ifAbsent: () => 1);
    for (final trace in traces) {
      final direction = trace['direction']! as String;
      if (direction == 'inbound') bump(received, trace['transport']! as String);
      bump(outcomes, (direction, trace['outcome']! as String));
      if (trace['outcome'] == 'rejected') {
        bump(reasons, trace['reason_code']! as String);
      }
      for (final stage in trace['stages']! as List<Map<String, Object?>>) {
        final filter = stage['filter_name']! as String;
        bump(decisions, (filter, stage['action']! as String));
        final mechanism = switch (filter) {
          'spf_check' => 'spf',
          'dkim_verify' => 'dkim',
          'dmarc_check' => 'dmarc',
          _ => null,
        };
        if (mechanism != null) {
          final log = stage['log']! as Map<String, Object?>;
          bump(verdicts, (mechanism, log['result']! as String));
        }
      }
    }
    List<Map<String, Object?>>? rows<K>(
      Map<K, double> counts,
      Map<String, Object?> Function(K key, double count) row,
    ) => counts.isEmpty
        ? null
        : [
            for (final MapEntry(:key, :value) in counts.entries)
              row(key, value),
          ];
    int byPair((String, String) a, (String, String) b) =>
        a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2);
    Map<K, double> sorted<K>(Map<K, double> m, int Function(K, K) by) =>
        Map.fromEntries(m.entries.toList()..sort((a, b) => by(a.key, b.key)));
    return {
      'window': {
        'since': _time(since),
        'until': _time(until),
        'label': '${hours}h0m0s',
      },
      'funnel': {
        'received': rows(
          sorted(received, (a, b) => a.compareTo(b)),
          (transport, n) => {'transport': transport, 'count': n},
        ),
        'auth_verdicts': rows(
          sorted(verdicts, byPair),
          (k, n) => {'mechanism': k.$1, 'result': k.$2, 'count': n},
        ),
        'stage_decisions': rows(
          sorted(decisions, byPair),
          (k, n) => {'filter': k.$1, 'action': k.$2, 'count': n},
        ),
        'terminal_outcomes': rows(
          sorted(outcomes, byPair),
          (k, n) => {'direction': k.$1, 'outcome': k.$2, 'count': n},
        ),
        // Most often first.
        'top_reject_reasons': rows(
          Map.fromEntries(
            reasons.entries.toList()..sort(
              (a, b) => a.value != b.value
                  ? b.value.compareTo(a.value)
                  : a.key.compareTo(b.key),
            ),
          ),
          (reason, n) => {'reason_code': reason, 'count': n},
        ),
      },
    };
  }

  FakeQueueEntry _queueEntry(String id) =>
      _queue[int.tryParse(id)] ??
      _fail(404, 'not_found', 'Queue entry not found');

  FakeDomain _domain(String id) =>
      _domains.values.where((d) => d.id == int.tryParse(id)).firstOrNull ??
      _fail(404, 'domain_not_found', 'Domain not found');

  FakeDomain? _domainFilter(Map<String, String> query) =>
      query['domain_id'] == null ? null : _domain(query['domain_id']!);

  FakeMailbox _adminMailbox(String id) =>
      _mailboxes[int.tryParse(id)] ??
      _fail(404, 'mailbox_not_found', 'Mailbox not found');

  FakeAlias _alias(String id) =>
      _aliases[int.tryParse(id)] ?? _fail(404, 'not_found', 'Alias not found');

  http.StreamedResponse _createDomain(Map<String, dynamic> body) {
    final name = (body['name'] as String? ?? '').trim().toLowerCase();
    if (name.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'name': 'required'},
      );
    }
    if (!name.contains('.')) {
      _fail(400, 'invalid_domain', 'Invalid domain name: $name');
    }
    if (body['server_type'] != 'restmail' &&
        body['server_type'] != 'traditional') {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'server_type': "must be 'traditional' or 'restmail'"},
      );
    }
    if (_domains.containsKey(name)) {
      _fail(409, 'already_exists', 'Domain already exists');
    }
    return _json({'data': _domainJson(_domainNamed(name))}, status: 201);
  }

  http.StreamedResponse _updateMailbox(
    FakeMailbox box,
    Map<String, dynamic> body,
  ) {
    if (body['password'] case final String password) {
      if (password.length < 12) {
        _fail(
          422,
          'validation_failed',
          'Request body failed validation',
          fields: {'password': 'must be at least 12 characters'},
        );
      }
      box.password = password;
      // A new password ends the mailbox's sessions, and revokes its app
      // passwords: whoever knew the old one could have made one.
      revokeSessionsOf(box.address);
      final now = _clock();
      for (final p in _appPasswords.values) {
        if (p.mailboxId == box.id && !p.isRevoked) p.revokedAt = now;
      }
    }
    if (body['display_name'] case final String name) box.displayName = name;
    if (body['active'] case final bool active) {
      box.active = active;
      if (!active) revokeSessionsOf(box.address);
    }
    return _json({'data': _mailboxJson(box)});
  }

  /// The account, its mail, its sessions, and every grant on it or held by
  /// it.
  void _deleteMailbox(FakeMailbox box) {
    revokeSessionsOf(box.address);
    _owned.remove(box.id);
    for (final owned in _owned.values) {
      owned.remove(box.id);
    }
    _messages.removeWhere((_, m) => m.mailboxId == box.id);
    _appPasswords.removeWhere((_, p) => p.mailboxId == box.id);
    _mailboxes.remove(box.id);
  }

  http.StreamedResponse _stats() {
    final today = _clock();
    int count(String status) =>
        _queue.values.where((e) => e.status == status).length;
    return _json({
      'data': {
        'domainCount': _domains.length,
        'mailboxCount': _mailboxes.length,
        'queueStats': {
          'pending': count('pending') + count('deferred'),
          'processing': count('delivering'),
          'failed': count('bounced') + count('expired'),
        },
        'messageVolume': [
          for (var back = 6; back >= 0; back--)
            {
              'date': _dayLabel(today.subtract(Duration(days: back))),
              'count': _messages.values.where((m) {
                final day = today.subtract(Duration(days: back));
                return m.receivedAt.year == day.year &&
                    m.receivedAt.month == day.month &&
                    m.receivedAt.day == day.day;
              }).length,
            },
        ],
        'recentActivity': [
          for (final e in _queue.values.where((e) => e.status == 'bounced'))
            {
              'id': '${e.id}',
              'type': 'bounce',
              'description': 'Bounced: ${e.recipient}',
              'timestamp': _time(e.createdAt),
            },
        ],
        'inboundTransportSecurity': {
          'totalInboundMX': 120,
          'overTLS': 114,
          'plaintext': 6,
          'tlsPercent': 95.0,
          'plaintextPercent': 5.0,
          'plaintextAuthPass': 0,
          'plaintextAuthFail': 0,
        },
      },
    });
  }

  /// `Oct 17`, as the server labels a day.
  static String _dayLabel(DateTime day) =>
      '${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][day.month - 1]} '
      '${day.day}';

  Map<String, Object?> _banJson(FakeBan ban) => {
    'id': ban.id,
    'ip': ban.ip,
    'reason': ban.reason,
    'protocol': ban.protocol,
    'created_by': ban.createdBy,
    if (ban.expiresAt case final expires?) 'expires_at': _time(expires),
    'created_at': _time(ban.createdAt),
  };

  http.StreamedResponse _createBan(Map<String, dynamic> body) {
    final ip = (body['ip'] as String? ?? '').trim();
    if (ip.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'ip': 'IP address is required'},
      );
    }
    Duration? lasts;
    if (body['duration'] case final String raw) {
      final minutes = RegExp(r'^(\d+)m$').firstMatch(raw)?.group(1);
      final hours = RegExp(r'^(\d+)h$').firstMatch(raw)?.group(1);
      lasts = minutes != null
          ? Duration(minutes: int.parse(minutes))
          : hours != null
          ? Duration(hours: int.parse(hours))
          : _fail(
              422,
              'validation_failed',
              'Request body failed validation',
              fields: {'duration': 'invalid duration format (e.g. 24h, 168h)'},
            );
    }
    final ban = _bans[_nextRowId] = FakeBan(
      id: _nextRowId++,
      ip: ip,
      protocol: body['protocol'] as String? ?? 'all',
      reason: body['reason'] as String? ?? '',
      createdBy: body['created_by'] as String? ?? '',
      createdAt: _clock(),
      expiresAt: lasts == null ? null : _clock().add(lasts),
    );
    return _json({'data': _banJson(ban)}, status: 201);
  }

  http.StreamedResponse _createAlias(Map<String, dynamic> body) {
    final source = (body['source_address'] as String? ?? '')
        .trim()
        .toLowerCase();
    final destination = (body['destination_address'] as String? ?? '')
        .trim()
        .toLowerCase();
    final fields = {
      if (!source.contains('@'))
        'source_address': 'must be a valid email address',
      if (!destination.contains('@'))
        'destination_address': 'must be a valid email address',
    };
    if (fields.isNotEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: fields,
      );
    }
    final domain = source.substring(source.indexOf('@') + 1);
    if (!_domains.containsKey(domain)) {
      _fail(404, 'domain_not_found', 'Domain not found for source address');
    }
    if (_aliases.values.any((a) => a.source == source)) {
      _fail(409, 'already_exists', 'Alias already exists');
    }
    final alias = _aliases[_nextRowId] = FakeAlias(
      id: _nextRowId++,
      source: source,
      destination: destination,
    );
    return _json({'data': _aliasJson(alias)}, status: 201);
  }
}

class _Session {
  _Session(this.primary, {this.twoFactor = false});

  /// The account it signed in to. The others it reaches are the server's
  /// owner grants, as they are now.
  final int primary;

  /// Its sign-in took the account's second factor.
  final bool twoFactor;
}

class _Grant {
  const _Grant(this.session, this.expiresAt, this.capabilities);

  final _Session session;
  final DateTime expiresAt;

  /// What the account could do on the admin API when the token was minted.
  final Set<String> capabilities;
}

/// An error answer, thrown from deep in a handler and returned as is.
class _Reply implements Exception {
  const _Reply(this.response);

  final http.StreamedResponse response;
}

http.StreamedResponse _json(
  Object body, {
  int status = 200,
  Map<String, String> headers = const {},
}) => http.StreamedResponse(
  Stream.value(utf8.encode(jsonEncode(body))),
  status,
  headers: {'content-type': 'application/json', ...headers},
);

http.StreamedResponse _noContent() =>
    http.StreamedResponse(const Stream.empty(), 204);

/// Answers with rest-mail's error envelope.
Never _fail(
  int status,
  String code,
  String message, {
  Map<String, String>? fields,
}) => throw _Reply(
  _json({
    'error': {
      'code': code,
      'message': message,
      if (fields != null) 'details': {'fields': fields},
    },
  }, status: status),
);

Map<String, dynamic> _object(List<int> bytes) {
  if (bytes.isEmpty) return {};
  final decoded = jsonDecode(utf8.decode(bytes));
  if (decoded is Map<String, dynamic>) return decoded;
  _fail(400, 'bad_request', 'Invalid request body');
}

/// 64 hex digits that change with [entry]'s contents and the hash before
/// it. Not the server's SHA-256: the app never checks a hash itself, it asks
/// the server to.
String _auditHash(FakeAuditEntry entry) {
  final bytes = utf8.encode(entry.content);
  final out = StringBuffer();
  for (var seed = 1; seed <= 8; seed++) {
    var hash = 0x811c9dc5 ^ seed;
    for (final byte in bytes) {
      hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
    }
    out.write(hash.toRadixString(16).padLeft(8, '0'));
  }
  return '$out';
}

int? _cursorId(String? cursor) {
  if (cursor == null || cursor.isEmpty) return null;
  try {
    final decoded = jsonDecode(utf8.decode(base64.decode(cursor)));
    return decoded is Map<String, dynamic>
        ? (decoded['id'] as num?)?.toInt()
        : null;
  } on FormatException {
    return null;
  }
}

List<FakeRecipient> _recipients(Object? raw) => [
  if (raw is List)
    for (final item in raw)
      if (item is String && item.isNotEmpty) FakeRecipient(item),
];

String? _nonEmpty(Object? value) =>
    value is String && value.isNotEmpty ? value : null;
