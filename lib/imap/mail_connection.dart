import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../l10n/catalog.dart';
import '../l10n/localized_error.dart';

import 'package:enough_mail/enough_mail.dart';
// Not exported, but needed to hand the client a socket this app opened, with
// its own certificate trust, rather than one enough_mail opens.
// ignore: implementation_imports
import 'package:enough_mail/src/private/util/client_base.dart'
    show ConnectionInfo;
// Not exported either, and needed for Gmail: the server's answers as they
// came, to read what Gmail adds to FETCH and LIST (labels, thread and
// message ids, `\Important`), which enough_mail skips; and a command of our
// own for STORE X-GM-LABELS, which it has no method for.
// ignore: implementation_imports
import 'package:enough_mail/src/private/imap/command.dart' show Command;
// ignore: implementation_imports
import 'package:enough_mail/src/private/imap/fetch_parser.dart'
    show FetchParser;
// ignore: implementation_imports
import 'package:enough_mail/src/private/imap/imap_response.dart'
    show ImapResponse;
import 'package:restmail_api/restmail_api.dart';

import 'mail_settings.dart';

/// Opens the socket to a mail server: TLS from the first byte when [tls] is
/// set, plain only for SMTP's STARTTLS, which must then upgrade.
typedef OpenMailSocket = Future<Socket> Function(
  String host,
  int port, {
  required bool tls,
});

/// Certificates are checked against [context] (the device's roots), with no
/// way to accept one that fails.
OpenMailSocket defaultMailSockets(SecurityContext Function() context) =>
    (host, port, {required tls}) async {
      const connect = Duration(seconds: 15);
      if (!tls) return Socket.connect(host, port, timeout: connect);
      return SecureSocket.connect(
        host,
        port,
        context: context(),
        timeout: connect,
      ).timeout(const Duration(seconds: 30));
    };

/// Where an account signed in with Microsoft or Google gets the access token
/// IMAP and SMTP sign in with (XOAUTH2). [rejected] is one a server just
/// turned down, to be replaced.
typedef AccessToken = Future<String> Function({String? rejected});

const _greetingTimeout = Duration(seconds: 30);
const _smtpTimeout = Duration(seconds: 60);

/// An IMAP client that says when the server's greeting has arrived, and when
/// the connection drops, so nothing waits on a dead socket.
class _Imap extends ImapClient {
  _Imap()
    : super(
        defaultWriteTimeout: const Duration(seconds: 30),
        defaultResponseTimeout: const Duration(seconds: 90),
      ) {
    // A drop with nothing waiting on it is not an error anyone must hear.
    lost.future.ignore();
  }

  final greeted = Completer<void>();
  final lost = Completer<Never>();

  /// What Gmail added to FETCH answers, by sequence number, until taken.
  final gmail = <int, GmailFetch>{};

  /// The folders Gmail's LIST marked `\Important`. enough_mail reads that
  /// flag as `\Flagged`, so Important and Starred would look the same.
  final important = <String>{};

  @override
  FutureOr<void> onConnectionEstablished(
    ConnectionInfo connectionInfo,
    String serverGreeting,
  ) async {
    await super.onConnectionEstablished(connectionInfo, serverGreeting);
    if (!greeted.isCompleted) greeted.complete();
  }

  @override
  void onServerResponse(ImapResponse imapResponse) {
    _readGmail(imapResponse);
    super.onServerResponse(imapResponse);
  }

  void _readGmail(ImapResponse response) {
    final first = response.lines.firstOrNull?.line ?? '';
    if (!first.startsWith('* ')) return;
    if (first.contains(' FETCH (')) {
      if (!response.lines.any((l) => l.rawLine?.contains('X-GM-') ?? false)) {
        return;
      }
      final sequence = int.tryParse(first.substring(2, first.indexOf(' ', 2)));
      if (sequence == null) return;
      final items =
          response
              .iterate()
              .values
              .where((v) => v.value == 'FETCH')
              .firstOrNull
              ?.children ??
          const [];
      String? messageId, threadId;
      List<String>? labels;
      for (var i = 0; i + 1 < items.length; i++) {
        switch (items[i].value) {
          case 'X-GM-MSGID':
            messageId = items[++i].value;
          case 'X-GM-THRID':
            threadId = items[++i].value;
          case 'X-GM-LABELS':
            final list = items[++i].children;
            labels = [
              if (list != null)
                for (final label in list) ?_text(label.value, label.data),
            ];
        }
      }
      final before = gmail[sequence];
      gmail[sequence] = GmailFetch(
        messageId: messageId ?? before?.messageId,
        threadId: threadId ?? before?.threadId,
        labels: labels ?? before?.labels,
      );
    } else if (first.startsWith('* LIST ') || first.startsWith('* XLIST ')) {
      if (!first.toLowerCase().contains(r'\important')) return;
      // * LIST (\HasNoChildren \Important) "/" "[Gmail]/Important"
      final values = response.iterate().values;
      final flags = values.where((v) => v.children != null).firstOrNull;
      final path = values.lastOrNull;
      if (flags == null || path == null || identical(flags, path)) return;
      final marked = flags.children!.any(
        (f) => f.value?.toLowerCase() == r'\important',
      );
      final name = _text(path.value, path.data);
      if (marked && name != null) important.add(name);
    }
  }

  static String? _text(String? value, Uint8List? data) {
    final text = value ?? (data == null ? null : utf8.decode(data));
    return text == null ? null : unquote(text);
  }

  @override
  void onConnectionError(dynamic error) {
    super.onConnectionError(error);
    const closed = SocketException('The connection closed');
    if (!greeted.isCompleted) greeted.completeError(closed);
    if (!lost.isCompleted) lost.completeError(closed);
  }
}

class _Smtp extends SmtpClient {
  _Smtp() : super('[127.0.0.1]');

  final greeted = Completer<void>();
  final _pending = BytesBuilder(copy: false);

  /// Hands enough_mail whole replies only. It reads each chunk off the
  /// socket as one reply, and takes EHLO as done only when a chunk holds
  /// more than one line, so a multi-line reply split across reads (TLS
  /// records, GreenMail) would leave it waiting for ever.
  @override
  void onDataReceived(Uint8List data) {
    _pending.add(data);
    final bytes = _pending.takeBytes();
    final end = completeReplies(bytes);
    if (end < bytes.length) _pending.add(Uint8List.sublistView(bytes, end));
    if (end > 0) super.onDataReceived(Uint8List.sublistView(bytes, 0, end));
  }

  @override
  FutureOr<void> onConnectionEstablished(
    ConnectionInfo connectionInfo,
    String serverGreeting,
  ) {
    super.onConnectionEstablished(connectionInfo, serverGreeting);
    if (!greeted.isCompleted) greeted.complete();
  }

  @override
  void onConnectionError(dynamic error) {
    super.onConnectionError(error);
    if (!greeted.isCompleted) {
      greeted.completeError(const SocketException('The connection closed'));
    }
  }
}

/// How many of [bytes] make whole SMTP replies: up to the end of the last
/// line whose code is followed by a space (`250 OK`), not a dash (`250-…`).
int completeReplies(List<int> bytes) {
  var end = 0, lineStart = 0;
  for (var i = 0; i + 1 < bytes.length; i++) {
    if (bytes[i] != 13 || bytes[i + 1] != 10) continue;
    final length = i - lineStart;
    final last = length <= 3 || bytes[lineStart + 3] != 0x2d; // '-'
    if (last) end = i + 2;
    lineStart = i + 2;
  }
  return end;
}

/// One signed-in IMAP connection.
class ImapConnection {
  ImapConnection._(this._client, this.host);

  final _Imap _client;
  final String host;

  ImapClient get client => _client;
  ImapServerInfo get server => _client.serverInfo;
  bool get isOpen => _client.isConnected && !_client.lost.isCompleted;

  /// Gmail, or Google Workspace: told by its IMAP extensions, not the
  /// domain, so a company's own addresses at Google count too.
  bool get isGmail => server.supports('X-GM-EXT-1');

  /// What Gmail said about each message in FETCH answers since the last
  /// call, by sequence number.
  Map<int, GmailFetch> takeGmail() {
    final taken = Map.of(_client.gmail);
    _client.gmail.clear();
    return taken;
  }

  /// The folders Gmail's LIST marked `\Important`, by encoded path.
  Set<String> get importantFolders => _client.important;

  /// Puts Gmail labels on the messages with [uids], or takes them off.
  /// Gmail answers with each message's labels as they now are, which
  /// [takeGmail] then has.
  Future<void> storeLabels(
    MessageSequence uids,
    List<String> labels, {
    required bool add,
  }) => run(
    (client) => client.sendCommand<FetchImapResult>(
      Command(
        'UID STORE $uids ${add ? '+' : '-'}X-GM-LABELS '
        '(${labels.map(gmailLabelArgument).join(' ')})',
      ),
      FetchParser(isUidFetch: true),
    ),
  );

  /// A future that fails when the connection drops.
  Future<Never> get lost => _client.lost.future;

  /// Connects over TLS and signs in, with [password] or, for an account
  /// signed in with Microsoft or Google, an [accessToken]. Failures come
  /// back as [ApiException]s.
  static Future<ImapConnection> open(
    MailServerSettings settings, {
    required String address,
    String? password,
    AccessToken? accessToken,
    required OpenMailSocket openSocket,
  }) async {
    assert((password == null) != (accessToken == null));
    final host = settings.imapHost;
    final client = _Imap();
    try {
      final tls = settings.imapSecurity == ImapSecurity.tls;
      final socket = await openSocket(host, settings.imapPort, tls: tls);
      // The socket's answers are parsed in this zone. enough_mail prints
      // every FETCH item it doesn't know (Gmail's, here) with the whole
      // answer, subject and addresses included, to the device log.
      runZoned(
        () => client.connect(
          socket,
          connectionInformation: ConnectionInfo(
            host,
            settings.imapPort,
            isSecure: tls,
          ),
        ),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {
            if (!line.startsWith('fetch: encountered unexpected')) {
              parent.print(zone, line);
            }
          },
        ),
      );
      await client.greeted.future.timeout(_greetingTimeout);
      if (!tls) {
        await client.capability().timeout(_greetingTimeout);
        if (!client.serverInfo.supportsStartTls) {
          throw LocalizedApiException(
            0,
            'no_tls',
            UiText('imap.starttlsRequired', {
              'host': host,
              'port': '${settings.imapPort}',
            }),
          );
        }
        await client.startTls().timeout(_greetingTimeout);
        await client.capability().timeout(_greetingTimeout);
      }
      final user = settings.usernameFor(address);
      try {
        if (accessToken == null) {
          await client.login(quoted(user), quoted(password!));
        } else {
          await _withToken(
            accessToken,
            (token) => client.authenticateWithOAuth2(user, token),
          );
        }
      } on ImapException catch (e) {
        throw signInRefused(e.message, host: host);
      }
      if (client.serverInfo.capabilities?.isEmpty ?? true) {
        await client.capability();
      }
      return ImapConnection._(client, host);
    } on Object catch (e) {
      unawaited(client.disconnect().catchError((Object _) {}));
      throw mailException(e, host: host);
    }
  }

  /// Runs [action], failing at once if the connection drops meanwhile.
  Future<T> run<T>(Future<T> Function(ImapClient client) action) async {
    try {
      return await Future.any([action(_client), lost]);
    } on Object catch (e) {
      throw mailException(e, host: host);
    }
  }

  Future<void> close() async {
    try {
      if (isOpen) await _client.logout().timeout(const Duration(seconds: 3));
    } on Object {
      // Closing anyway.
    }
    try {
      await _client.disconnect();
    } on Object {
      // Already gone.
    }
  }
}

/// Connects to the SMTP server, over TLS or with STARTTLS required, and
/// signs in. The caller sends, then calls [SmtpClient.quit].
Future<SmtpClient> openSmtp(
  MailServerSettings settings, {
  required String address,
  String? password,
  AccessToken? accessToken,
  required OpenMailSocket openSocket,
}) async {
  assert((password == null) != (accessToken == null));
  final host = settings.smtpHost, port = settings.smtpPort;
  final tls = settings.smtpSecurity == SmtpSecurity.tls;
  final client = _Smtp();
  try {
    final socket = await openSocket(host, port, tls: tls);
    client.connect(
      socket,
      connectionInformation: ConnectionInfo(host, port, isSecure: tls),
    );
    await client.greeted.future.timeout(_greetingTimeout);
    await client.ehlo().timeout(_smtpTimeout);
    if (!tls) {
      // Required, never opportunistic: without it the password and the
      // message would cross the network in the clear.
      if (!client.serverInfo.supportsStartTls) {
        throw LocalizedApiException(
          0,
          'no_tls',
          UiText('client.hostDoesnTOfferSTARTTLSOnPort', {
            'host': (host).toString(),
            'port': (port).toString(),
          }),
        );
      }
      await client.startTls().timeout(_smtpTimeout);
    }
    final user = settings.usernameFor(address);
    try {
      if (accessToken == null) {
        final mechanisms = client.serverInfo.authMechanisms;
        final mechanism =
            mechanisms.contains(AuthMechanism.login) &&
                !mechanisms.contains(AuthMechanism.plain)
            ? AuthMechanism.login
            : AuthMechanism.plain;
        await client
            .authenticate(user, password!, mechanism)
            .timeout(_smtpTimeout);
      } else {
        await _withToken(
          accessToken,
          (token) => client
              .authenticate(user, token, AuthMechanism.xoauth2)
              .timeout(_smtpTimeout),
        );
      }
    } on SmtpException catch (e) {
      throw signInRefused(e.message, host: host);
    }
    return client;
  } on Object catch (e) {
    unawaited(client.disconnect().catchError((Object _) {}));
    throw mailException(e, host: host);
  }
}

/// Signs in with an access token, and if the server turns it down, once
/// more with a new one: a token can be revoked, or run out early, while the
/// app still holds it. A refresh token that no longer works fails here with
/// `invalid_grant`, which ends the account.
Future<void> _withToken(
  AccessToken accessToken,
  Future<Object?> Function(String token) signIn,
) async {
  final token = await accessToken();
  try {
    await signIn(token);
  } on ImapException {
    await signIn(await accessToken(rejected: token));
  } on SmtpException {
    await signIn(await accessToken(rejected: token));
  }
}

/// An IMAP quoted string (RFC 3501): backslashes and quotes escaped. Line
/// breaks can't be in one at all, so they are dropped rather than let a
/// pasted password carry a second command.
String quoted(String value) => value
    .replaceAll(RegExp(r'[\r\n]'), '')
    .replaceAll(r'\', r'\\')
    .replaceAll('"', r'\"');

/// What Gmail adds to a FETCH answer
/// (https://developers.google.com/gmail/imap/imap-extensions).
class GmailFetch {
  const GmailFetch({this.messageId, this.threadId, this.labels});

  /// `X-GM-MSGID`: the message's id, the same in every folder it shows in.
  final String? messageId;

  /// `X-GM-THRID`: its conversation, as Gmail groups them.
  final String? threadId;

  /// `X-GM-LABELS`: Gmail's own labels with a backslash (`\Inbox`,
  /// `\Important`, `\Sent`), the user's by their encoded folder path.
  final List<String>? labels;
}

/// A label as STORE X-GM-LABELS takes it: Gmail's own as the atom it is,
/// anything else quoted.
String gmailLabelArgument(String label) =>
    RegExp(r'^\\[A-Za-z]+$').hasMatch(label) ? label : '"${quoted(label)}"';

/// Undoes [quoted]: what a quoted string held, escapes taken out.
String unquote(String value) =>
    value.replaceAllMapped(RegExp(r'\\(.)'), (m) => m[1]!);

/// The server turned the password down. Gmail says why in words worth
/// keeping: it wants an app password, or a sign-in in the browser first.
ApiException signInRefused(String? serverText, {required String host}) {
  final text = (serverText ?? '').trim();
  final lower = text.toLowerCase();
  if (lower.contains('application-specific password')) {
    return ApiException(401, 'app_password_required', text);
  }
  if (lower.contains('web browser') || lower.contains('webalert')) {
    return ApiException(401, 'web_login_required', text);
  }
  return LocalizedApiException(
    401,
    'unauthorized',
    text.isEmpty
        ? UiText('client.hostTurnedDownTheAddressOrPassword', {
            'host': (host).toString(),
          })
        : text,
  );
}

/// What went wrong, as the [ApiException] the screens already handle.
ApiException mailException(
  Object error, {
  required String host,
}) => switch (error) {
  ApiException() => error,
  HandshakeException() || TlsException()
      when '$error'.toUpperCase().contains('CERTIFICATE') =>
    LocalizedApiException(
      0,
      'tls_error',
      UiText('client.hostSCertificateIsnTTrusted', {'host': (host).toString()}),
    ),
  HandshakeException() || TlsException() => LocalizedApiException(
    0,
    'no_tls',
    UiText('client.hostDidnTAnswerOverTLSSo', {'host': (host).toString()}),
  ),
  TimeoutException() => LocalizedApiException(
    0,
    'timeout',
    UiText('client.hostTookTooLongToAnswer', {'host': (host).toString()}),
  ),
  SocketException() => LocalizedApiException(
    0,
    'network_error',
    UiText('client.canTReachHost', {'host': (host).toString()}),
  ),
  ImapException(:final message) => LocalizedApiException(
    502,
    'imap_error',
    message?.trim().isNotEmpty == true
        ? '$host said: ${message!.trim()}'
        : UiText('client.hostTurnedThatDown', {'host': (host).toString()}),
  ),
  SmtpException(:final message) => LocalizedApiException(
    502,
    'smtp_error',
    message?.trim().isNotEmpty == true
        ? '$host said: ${message!.trim()}'
        : UiText('client.hostWouldnTSendIt', {'host': (host).toString()}),
  ),
  _ => LocalizedApiException(
    0,
    'mail_error',
    UiText('client.somethingWentWrongWithHost', {'host': (host).toString()}),
  ),
};
