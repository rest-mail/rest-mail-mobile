import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart'
    show accessCookieName, refreshCookieName;

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
  var _nextId = 1;
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
    _accessTokens.updateAll((_, grant) => _Grant(grant.session, past));
  }

  /// Ends every session: the next refresh is refused.
  void revokeSessions() {
    _accessTokens.clear();
    _refreshTokens.clear();
  }

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
        return _login(_object(bytes));
      case ('POST', ['api', 'v1', 'auth', 'refresh']):
        return _refresh(request);
      case ('POST', ['api', 'v1', 'auth', 'logout']):
        _refreshTokens.remove(_cookie(request, refreshCookieName));
        return _noContent();
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
    return _issue(_Session(box.id));
  }

  /// The server retires a refresh token when it is used; so does this.
  http.StreamedResponse _refresh(http.BaseRequest request) {
    final session = _refreshTokens.remove(_cookie(request, refreshCookieName));
    if (session == null) _fail(401, 'unauthorized', 'Invalid refresh token');
    return _issue(session);
  }

  http.StreamedResponse _issue(_Session session) {
    final access = _token('access'), refresh = _token('refresh');
    _accessTokens[access] = _Grant(session, _clock().add(accessTokenLifetime));
    _refreshTokens[refresh] = session;
    final user = _mailboxes[session.primary]!;
    return _json(
      {
        'data': {
          'expires_in': accessTokenLifetime.inSeconds,
          'user': {
            'id': user.id,
            'email': user.address,
            'display_name': user.displayName,
          },
        },
      },
      headers: {
        // Folded into one value, as dart:io hands several Set-Cookie lines
        // to package:http.
        'set-cookie': [
          '$accessCookieName=$access; Path=/; HttpOnly; Secure; SameSite=Strict',
          '$refreshCookieName=$refresh; Path=/api/v1/auth; HttpOnly; Secure; SameSite=Strict',
          'restmail_csrf=${_token('csrf')}; Path=/; Secure; SameSite=Strict',
        ].join(', '),
      },
    );
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
    final now = _clock();
    final twoFactor = scenario == FakeScenario.twoFactor;
    final dana = _addMailbox(
      FakeAccounts.email,
      'Dana Ruiz',
      twoFactor: twoFactor,
    );
    final other = _addMailbox(FakeAccounts.otherEmail, 'Dana at Oakline');
    if (scenario == FakeScenario.empty) return;
    for (final message in danaMail(now)) {
      _add(dana, message);
    }
    for (final message in otherMail(now)) {
      _add(other, message);
    }
  }

  FakeMailbox _addMailbox(
    String address,
    String name, {
    bool twoFactor = false,
  }) {
    final box = FakeMailbox(
      id: _mailboxes.length + 1,
      address: address,
      displayName: name,
      password: FakeAccounts.password,
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
}

class _Session {
  _Session(this.primary);

  final int primary;
  final linked = <int>{};

  Set<int> get mailboxes => {primary, ...linked};
}

class _Grant {
  const _Grant(this.session, this.expiresAt);

  final _Session session;
  final DateTime expiresAt;
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

String? _cookie(http.BaseRequest request, String name) {
  for (final part in (request.headers['cookie'] ?? '').split(';')) {
    final pair = part.trim();
    if (pair.startsWith('$name=')) return pair.substring(name.length + 1);
  }
  return null;
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
