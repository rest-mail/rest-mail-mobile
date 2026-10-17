import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'model.dart';
import 'sample_mail.dart';

/// Ready-made states for a fake to start in.
enum FakeScenario {
  /// Dana's mailbox with a week of mail, and a second one she can link.
  sample,

  /// The same two mailboxes with nothing in them.
  empty,

  /// The sample, with Dana's sign-in behind two-factor authentication.
  twoFactor,

  /// A server just installed: no domain, no mailbox, and only its bootstrap
  /// admin, who must set a new password and enroll an authenticator before
  /// the admin API answers anything else.
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
  final _admins = <String, _FakeAdmin>{};
  final _adminAccessTokens = <String, _AdminGrant>{};
  final _adminRefreshTokens = <String, _FakeAdmin>{};
  var _nextId = 1;
  var _nextMailboxId = 1;

  /// For domains, aliases, queue entries and admins.
  var _nextRowId = 1;
  var _nextEventId = 0;
  var _nextToken = 0;

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
    _adminAccessTokens.updateAll(
      (_, grant) => _AdminGrant(
        grant.admin,
        setup: grant.setup,
        capabilities: grant.capabilities,
        expiresAt: past,
      ),
    );
  }

  /// Ends every session: the next refresh is refused.
  void revokeSessions() {
    _accessTokens.clear();
    _refreshTokens.clear();
    _adminAccessTokens.clear();
    _adminRefreshTokens.clear();
  }

  /// Ends the sessions signed in as [address] only; the rest carry on.
  void revokeSessionsOf(String address) {
    final box = _mailboxAt(address);
    if (box == null) return;
    _accessTokens.removeWhere((_, grant) => grant.session.primary == box.id);
    _refreshTokens.removeWhere((_, session) => session.primary == box.id);
  }

  /// The first admin's password as it stands, for a test to check a change.
  String? get adminPassword => _admins.values.firstOrNull?.password;

  /// The first admin's username, once there is one.
  String? get adminUsername => _admins.values.firstOrNull?.username;

  /// Adds an admin user who is set up already, with an authenticator that
  /// shows [FakeAccounts.totpCode]. Its role is the one that grants exactly
  /// [capabilities], made for it if there is none.
  void addAdmin(
    String username, {
    String password = FakeAccounts.adminPassword,
    Set<String> capabilities = const {'*'},
  }) {
    final role = _roleGranting(capabilities);
    _admins[username] =
        _FakeAdmin(
            _nextRowId++,
            username,
            password,
            capabilities: {...capabilities},
          )
          ..roles = {role.id}
          ..setUp();
  }

  /// The roles the real server seeds, and any [addAdmin] made.
  static const _seededRoles = [
    (1, 'superadmin', 'Everything', {'*'}),
    (
      2,
      'admin',
      'Runs the mail: domains, mailboxes, queue, bans and pipelines',
      {
        'domains:read', 'domains:write', 'domains:delete', //
        'mailboxes:read', 'mailboxes:write', 'mailboxes:delete',
        'queue:read', 'queue:manage', 'bans:read', 'bans:write',
        'bans:delete', 'pipelines:read', 'pipelines:write',
        'pipelines:delete', 'messages:read', 'observability:read',
        'audit:read',
      },
    ),
    (
      3,
      'readonly',
      'Sees everything, changes nothing',
      {
        'domains:read', 'mailboxes:read', 'users:read', 'queue:read', //
        'bans:read', 'pipelines:read', 'messages:read',
        'observability:read',
      },
    ),
  ];
  final _roles = <int, _FakeRole>{
    for (final (id, name, description, capabilities) in _seededRoles)
      id: _FakeRole(id, name, description, capabilities, system: true),
  };

  /// The role that grants exactly [capabilities], named after them if it has
  /// to be made.
  _FakeRole _roleGranting(Set<String> capabilities) {
    for (final role in _roles.values) {
      if (role.capabilities.length == capabilities.length &&
          role.capabilities.containsAll(capabilities)) {
        return role;
      }
    }
    final id = _roles.keys.reduce(max) + 1;
    final names = [...capabilities]..sort();
    return _roles[id] = _FakeRole(id, names.join(' '), '', {...capabilities});
  }

  /// Changes what [who], an admin's username or a mailbox's address, may do
  /// on the admin API, as a change of roles on the server does. As there, an
  /// access token keeps the capabilities it was minted with; the session
  /// gets the new ones when it next refreshes.
  void grant(String who, Set<String> capabilities) {
    if (_admins[who] case final admin?) {
      admin.capabilities = {...capabilities};
    } else if (_mailboxAt(who) case final box?) {
      box.capabilities = {...capabilities};
    } else {
      throw ArgumentError.value(who, 'who', 'No such admin or mailbox');
    }
  }

  /// Whether a mailbox exists, for a test to check onboarding created it.
  bool hasMailbox(String address) => _mailboxAt(address) != null;

  /// What the admin API holds, for a test to check a change.
  List<FakeDomain> get domains => [..._domains.values];
  List<FakeAlias> get aliases => [..._aliases.values];
  List<FakeQueueEntry> get queue => [..._queue.values];
  List<FakeBan> get bans => [..._bans.values];

  /// The names of an admin's roles, for a test to check a change.
  List<String> rolesOf(String username) => [
    for (final id in _admins[username]?.roles ?? const <int>{})
      ?_roles[id]?.name,
  ];

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
        return body.containsKey('username') ? _adminLogin(body) : _login(body);
      case ('POST', ['api', 'v1', 'auth', 'refresh']):
        return _refresh(_object(bytes));
      case ('POST', ['api', 'v1', 'auth', 'logout']):
        _refreshTokens.remove(_object(bytes)['refresh_token']);
        return _noContent();
    }

    if (path case ['api', 'v1', 'admin', ...final rest]) {
      return _adminApi(request, method, rest, bytes);
    }
    if (_adminSelf(request, method, path, bytes) case final response?) {
      return response;
    }

    final session = _authenticate(request);
    final query = request.url.queryParameters;
    return switch ((method, path)) {
      ('GET', ['api', 'v1', 'accounts']) => _json({
        'data': [for (final id in session.mailboxes) _account(id, session)],
      }),
      ('POST', ['api', 'v1', 'accounts']) => _link(session, _object(bytes)),
      ('DELETE', ['api', 'v1', 'accounts', final id]) => _unlink(
        session,
        _own(session, id),
      ),
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
    final box = _mailboxAt(body['email'] as String? ?? '');
    if (box == null || body['password'] != box.password) {
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
    return _issue(_Session(box.id), native: body['client'] == 'native');
  }

  /// The server retires a refresh token when it is used; so does this. A
  /// refresh token sent in the body is a native client's, and so is the
  /// answer.
  http.StreamedResponse _refresh(Map<String, dynamic> body) {
    if (_adminRefreshTokens.remove(body['refresh_token']) case final admin?) {
      return _issueAdmin(admin);
    }
    final session = _refreshTokens.remove(body['refresh_token']);
    if (session == null) _fail(401, 'unauthorized', 'Invalid refresh token');
    return _issue(session, native: true);
  }

  /// Hands out a new pair. Only a native client gets it in the body; a login
  /// that does not say `"client": "native"` is a browser's, which the real
  /// server answers with cookies, so here it gets no tokens at all.
  http.StreamedResponse _issue(_Session session, {required bool native}) {
    final access = _token('access'), refresh = _token('refresh');
    final user = _mailboxes[session.primary]!;
    final capabilities = {...user.capabilities};
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
        if (native) ...{
          'access_token': access,
          'refresh_token': refresh,
          'refresh_expires_in': _refreshTokenLifetime.inSeconds,
        },
      },
    });
  }

  _Session _authenticate(http.BaseRequest request) {
    final header = request.headers['authorization'] ?? '';
    final grant = header.startsWith('Bearer ')
        ? _accessTokens[header.substring('Bearer '.length)]
        : null;
    if (grant == null || !_clock().isBefore(grant.expiresAt)) {
      _fail(401, 'unauthorized', 'Invalid or expired token');
    }
    return grant.session;
  }

  // ── Accounts and folders ──────────────────────────────────────────────

  Map<String, Object> _account(int id, _Session session) {
    final box = _mailboxes[id]!;
    return {
      'id': box.id,
      'mailbox_id': box.id,
      'address': box.address,
      'display_name': box.displayName,
      'is_primary': id == session.primary,
    };
  }

  http.StreamedResponse _link(_Session session, Map<String, dynamic> body) {
    final box = _mailboxAt(body['address'] as String? ?? '');
    if (box == null || body['password'] != box.password) {
      _fail(401, 'unauthorized', 'Invalid email or password');
    }
    if (session.mailboxes.contains(box.id)) {
      _fail(409, 'conflict', 'Account already linked');
    }
    session.linked.add(box.id);
    return _json({'data': _account(box.id, session)}, status: 201);
  }

  http.StreamedResponse _unlink(_Session session, FakeMailbox box) {
    if (box.id == session.primary) {
      _fail(400, 'bad_request', 'The primary account cannot be unlinked');
    }
    session.linked.remove(box.id);
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
        !session.mailboxes.contains(owner.mailboxId)) {
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
      _admins[FakeAccounts.adminUsername] = _FakeAdmin(
        _nextRowId++,
        FakeAccounts.adminUsername,
        FakeAccounts.bootstrapPassword,
      )..roles = {1};
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
    addAdmin(FakeAccounts.adminUsername);
    addAdmin(FakeAccounts.queueWatcher, capabilities: {'queue:read'});
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
      _queue[_nextRowId] = FakeQueueEntry(
        id: _nextRowId++,
        sender: FakeAccounts.email,
        recipient: recipient,
        status: status,
        attempts: attempts,
        lastErrorCode: code,
        lastError: error,
        createdAt: now.subtract(age),
      );
    }
    _bans[_nextRowId] = FakeBan(
      id: _nextRowId++,
      ip: '203.0.113.7',
      protocol: 'smtp',
      reason: 'Too many failed sign-ins',
      createdAt: now.subtract(const Duration(hours: 2)),
      expiresAt: now.add(const Duration(hours: 22)),
    );
  }

  FakeMailbox _addMailbox(
    String address,
    String name, {
    bool twoFactor = false,
    String password = FakeAccounts.password,
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
    if (box == null || !session.mailboxes.contains(box.id)) {
      _fail(404, 'not_found', 'Account not found');
    }
    return box;
  }

  FakeMailbox _sender(_Session session, Map<String, dynamic> body) {
    final box = _mailboxAt(body['from'] as String? ?? '');
    if (box == null || !session.mailboxes.contains(box.id)) {
      _fail(403, 'forbidden', 'You cannot send from that address');
    }
    return box;
  }

  FakeMessage _message(_Session session, String id) {
    final message = _messages[int.tryParse(id)];
    if (message == null || !session.mailboxes.contains(message.mailboxId)) {
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
  // The real server's rules: an admin in setup gets a session with no
  // capabilities that reaches only the calls finishing the setup, and every
  // admin route answers 403 setup_required until it is done. After that, each
  // admin route needs its capability, as the access token carries them; `*`
  // allows them all. A mailbox session holds none, and is refused outright.

  http.StreamedResponse _adminLogin(Map<String, dynamic> body) {
    final admin = _admins[body['username']];
    if (admin == null || body['password'] != admin.password) {
      _fail(401, 'unauthorized', 'Invalid username or password');
    }
    if (!admin.active) _fail(401, 'unauthorized', 'Account is disabled');
    if (admin.totpEnrolled) {
      final code = body['totp_code'] as String? ?? '';
      if (code.isEmpty) {
        _fail(401, 'totp_required', 'Two-factor authentication code required');
      }
      if (code != FakeAccounts.totpCode) {
        _fail(401, 'unauthorized', 'Invalid two-factor authentication code');
      }
    }
    return _issueAdmin(admin);
  }

  /// A sign-in or refresh: the capabilities come from the admin's roles as
  /// they are now.
  http.StreamedResponse _issueAdmin(_FakeAdmin admin) {
    final access = _token('access'), refresh = _token('refresh');
    final setup = admin.setupRequired;
    final capabilities = setup.isEmpty ? {...admin.capabilities} : <String>{};
    _adminAccessTokens[access] = _AdminGrant(
      admin,
      setup: setup.isNotEmpty,
      capabilities: capabilities,
      expiresAt: _clock().add(accessTokenLifetime),
    );
    _adminRefreshTokens[refresh] = admin;
    return _json({
      'data': {
        'expires_in': accessTokenLifetime.inSeconds,
        'user': {
          'id': admin.id,
          'email': admin.username,
          'display_name': admin.username,
        },
        if (capabilities.isNotEmpty) 'capabilities': [...capabilities],
        if (setup.isNotEmpty) 'setup_required': setup,
        'access_token': access,
        'refresh_token': refresh,
        'refresh_expires_in': _refreshTokenLifetime.inSeconds,
      },
    });
  }

  String? _bearer(http.BaseRequest request) {
    final header = request.headers['authorization'] ?? '';
    return header.startsWith('Bearer ')
        ? header.substring('Bearer '.length)
        : null;
  }

  /// Answers an admin's calls on its own account, or null for a route that is
  /// not one.
  http.StreamedResponse? _adminSelf(
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

    final grant = _adminAccessTokens[_bearer(request)];
    if (grant == null || !_clock().isBefore(grant.expiresAt)) {
      // Not an admin token: the mailbox routes below decide.
      return null;
    }
    final admin = grant.admin;
    final body = _object(bytes);

    switch (route) {
      case 'enroll':
        if (admin.totpEnrolled) {
          _fail(
            409,
            'conflict',
            'Two-factor authentication is already enabled',
          );
        }
        admin.totpPending = true;
        return _json({
          'data': {
            'secret': FakeAccounts.totpSecret,
            'otpauth_url': FakeAccounts.totpUri,
            'recovery_codes': [FakeAccounts.recoveryCode],
          },
        });
      case 'confirm':
        if (!admin.totpPending) {
          _fail(400, 'bad_request', 'No pending 2FA enrollment');
        }
        if (body['code'] != FakeAccounts.totpCode) {
          _fail(401, 'unauthorized', 'Invalid 2FA code');
        }
        admin
          ..totpPending = false
          ..totpEnrolled = true;
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
        if (current != admin.password) {
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
        admin
          ..password = next
          ..mustChangePassword = false;
        // Every session of the account ends, this one included.
        _adminAccessTokens.removeWhere((_, g) => g.admin == admin);
        _adminRefreshTokens.removeWhere((_, a) => a == admin);
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
    final token = _bearer(request);
    final admin = _adminAccessTokens[token];
    if (admin != null && _clock().isBefore(admin.expiresAt)) {
      if (admin.setup) {
        _fail(403, 'setup_required', 'Finish setting up this account first');
      }
      return admin.capabilities;
    }
    final grant = _accessTokens[token];
    if (grant == null || !_clock().isBefore(grant.expiresAt)) {
      _fail(401, 'unauthorized', 'Invalid or expired token');
    }
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
      case ('POST', ['mailboxes']):
        need('mailboxes:write');
        return _createMailbox(_object(bytes));
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

      case ('GET', ['admin-users']):
        need('users:read');
        return _listPage(
          _admins.values.toList()
            ..sort((a, b) => a.username.compareTo(b.username)),
          query,
          _adminUserJson,
        );
      case ('POST', ['admin-users']):
        need('users:write');
        return _createAdminUser(_object(bytes));
      case ('PUT', ['admin-users', final id]):
        need('users:write');
        return _updateAdminUser(_adminUser(id), _object(bytes));
      case ('DELETE', ['admin-users', final id]):
        need('users:delete');
        final admin = _adminUser(id);
        _endAdminSessions(admin);
        _admins.remove(admin.username);
        return _noContent();
      case ('GET', ['roles']):
        need('users:read');
        return _json({
          'data': [for (final role in _roles.values) _roleJson(role)],
        });

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
    'message_id': null,
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
    'dkim_selector': 'mail',
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

  http.StreamedResponse _createMailbox(Map<String, dynamic> body) {
    final address = (body['address'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final at = address.indexOf('@');
    if (at <= 0 || password.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {
          if (at <= 0) 'address': 'must be a valid email address',
          if (password.isEmpty) 'password': 'required',
        },
      );
    }
    final domain = address.substring(at + 1);
    if (!_domains.containsKey(domain)) {
      _fail(404, 'domain_not_found', "Domain '$domain' not found");
    }
    if (_mailboxAt(address) != null) {
      _fail(409, 'already_exists', 'Mailbox already exists');
    }
    final box = _addMailbox(
      address,
      _nonEmpty(body['display_name']) ?? address.substring(0, at),
      password: password,
    );
    return _json({'data': _mailboxJson(box)}, status: 201);
  }

  http.StreamedResponse _updateMailbox(
    FakeMailbox box,
    Map<String, dynamic> body,
  ) {
    if (body['password'] case final String password) {
      if (password.length < 8) {
        _fail(
          422,
          'validation_failed',
          'Request body failed validation',
          fields: {'password': 'must be at least 8 characters'},
        );
      }
      box.password = password;
      // A new password ends the mailbox's sessions.
      revokeSessionsOf(box.address);
    }
    if (body['display_name'] case final String name) box.displayName = name;
    if (body['active'] case final bool active) {
      box.active = active;
      if (!active) revokeSessionsOf(box.address);
    }
    return _json({'data': _mailboxJson(box)});
  }

  /// The mailbox, its mail, and every session that could read it.
  void _deleteMailbox(FakeMailbox box) {
    revokeSessionsOf(box.address);
    for (final session in [
      ..._refreshTokens.values,
      for (final g in _accessTokens.values) g.session,
    ]) {
      session.linked.remove(box.id);
    }
    _messages.removeWhere((_, m) => m.mailboxId == box.id);
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

  Map<String, Object?> _roleJson(_FakeRole role) => {
    'id': role.id,
    'name': role.name,
    'description': role.description,
    'system_role': role.system,
  };

  Map<String, Object?> _adminUserJson(_FakeAdmin admin) => {
    'id': admin.id,
    'username': admin.username,
    'email': null,
    'active': admin.active,
    'password_change_required': admin.mustChangePassword,
    'last_password_change': null,
    'created_at': _time(_clock()),
    'updated_at': _time(_clock()),
    'roles': [
      for (final id in admin.roles)
        if (_roles[id] case final role?) _roleJson(role),
    ],
  };

  Map<String, Object?> _banJson(FakeBan ban) => {
    'id': ban.id,
    'ip': ban.ip,
    'reason': ban.reason,
    'protocol': ban.protocol,
    'created_by': ban.createdBy,
    if (ban.expiresAt case final expires?) 'expires_at': _time(expires),
    'created_at': _time(ban.createdAt),
  };

  _FakeAdmin _adminUser(String id) =>
      _admins.values.where((a) => a.id == int.tryParse(id)).firstOrNull ??
      _fail(404, 'not_found', 'Admin user not found');

  /// The real server ends an admin's sessions when its password, roles or
  /// standing change, or it goes.
  void _endAdminSessions(_FakeAdmin admin) {
    _adminAccessTokens.removeWhere((_, g) => g.admin == admin);
    _adminRefreshTokens.removeWhere((_, a) => a == admin);
  }

  Set<int> _roleIds(Object? raw) {
    final ids = {
      if (raw is List)
        for (final id in raw)
          if (id is num) id.toInt(),
    };
    if (!_roles.keys.toSet().containsAll(ids)) {
      _fail(500, 'internal_error', 'Failed to assign roles');
    }
    return ids;
  }

  Set<String> _capabilitiesOf(Set<int> roles) => {
    for (final id in roles) ...?_roles[id]?.capabilities,
  };

  http.StreamedResponse _createAdminUser(Map<String, dynamic> body) {
    final username = (body['username'] as String? ?? '').trim();
    final password = body['password'] as String? ?? '';
    if (username.isEmpty || password.isEmpty) {
      _fail(
        422,
        'validation_failed',
        'Request body failed validation',
        fields: {'username': 'required', 'password': 'required'},
      );
    }
    if (_admins.containsKey(username)) {
      _fail(500, 'internal_error', 'Failed to create admin user');
    }
    final roles = _roleIds(body['role_ids']);
    // As on the real server, it owes no setup: it signs in with the password
    // it was given, and no second factor unless it enrolls one.
    final admin = _admins[username] =
        _FakeAdmin(
            _nextRowId++,
            username,
            password,
            capabilities: _capabilitiesOf(roles),
          )
          ..roles = roles
          ..mustChangePassword = false
          ..twoFactorRequired = false;
    return _json({'data': _adminUserJson(admin)}, status: 201);
  }

  http.StreamedResponse _updateAdminUser(
    _FakeAdmin admin,
    Map<String, dynamic> body,
  ) {
    var revoke = false;
    if (body['password'] case final String password when password.isNotEmpty) {
      admin.password = password;
      revoke = true;
    }
    if (body['active'] case final bool active) {
      admin.active = active;
      revoke |= !active;
    }
    if (body.containsKey('role_ids') && body['role_ids'] != null) {
      admin
        ..roles = _roleIds(body['role_ids'])
        ..capabilities = _capabilitiesOf(admin.roles);
      revoke = true;
    }
    if (revoke) _endAdminSessions(admin);
    return _json({
      'data': {'message': 'Admin user updated successfully'},
    });
  }

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
  _Session(this.primary);

  final int primary;
  final linked = <int>{};

  Set<int> get mailboxes => {primary, ...linked};
}

class _Grant {
  const _Grant(this.session, this.expiresAt, this.capabilities);

  final _Session session;
  final DateTime expiresAt;

  /// What the mailbox could do on the admin API when the token was minted.
  final Set<String> capabilities;
}

/// An admin user, and how far its first-start setup has got.
class _FakeAdmin {
  _FakeAdmin(
    this.id,
    this.username,
    this.password, {
    this.capabilities = const {'*'},
  });

  final int id;
  final String username;
  String password;

  /// What its roles grant, once it is set up.
  Set<String> capabilities;
  Set<int> roles = {};
  bool active = true;
  bool mustChangePassword = true;

  /// Kept in setup until an authenticator is enrolled, as a bootstrap admin
  /// is.
  bool twoFactorRequired = true;
  bool totpPending = false;
  bool totpEnrolled = false;

  /// Its own password chosen and an authenticator enrolled.
  void setUp() {
    mustChangePassword = false;
    totpEnrolled = true;
  }

  /// What the real server reports in `setup_required`, in its order.
  List<String> get setupRequired => [
    if (mustChangePassword) 'password',
    if (twoFactorRequired && !totpEnrolled) 'two_factor',
  ];
}

class _AdminGrant {
  const _AdminGrant(
    this.admin, {
    required this.setup,
    required this.capabilities,
    required this.expiresAt,
  });

  final _FakeAdmin admin;

  /// Minted while the account was in setup: the admin API refuses it.
  final bool setup;

  /// What the admin's roles granted when the token was minted.
  final Set<String> capabilities;
  final DateTime expiresAt;
}

class _FakeRole {
  const _FakeRole(
    this.id,
    this.name,
    this.description,
    this.capabilities, {
    this.system = false,
  });

  final int id;
  final String name;
  final String description;
  final Set<String> capabilities;
  final bool system;
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
