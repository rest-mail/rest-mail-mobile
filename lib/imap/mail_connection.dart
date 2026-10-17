import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:enough_mail/enough_mail.dart';
// Not exported, but needed to hand the client a socket this app opened, with
// its own certificate trust, rather than one enough_mail opens.
// ignore: implementation_imports
import 'package:enough_mail/src/private/util/client_base.dart'
    show ConnectionInfo;
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

  @override
  FutureOr<void> onConnectionEstablished(
    ConnectionInfo connectionInfo,
    String serverGreeting,
  ) async {
    await super.onConnectionEstablished(connectionInfo, serverGreeting);
    if (!greeted.isCompleted) greeted.complete();
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

  /// A future that fails when the connection drops.
  Future<Never> get lost => _client.lost.future;

  /// Connects over TLS and signs in. Failures come back as [ApiException]s.
  static Future<ImapConnection> open(
    MailServerSettings settings, {
    required String address,
    required String password,
    required OpenMailSocket openSocket,
  }) async {
    final host = settings.imapHost;
    final client = _Imap();
    try {
      final socket = await openSocket(host, settings.imapPort, tls: true);
      client.connect(
        socket,
        connectionInformation: ConnectionInfo(
          host,
          settings.imapPort,
          isSecure: true,
        ),
      );
      await client.greeted.future.timeout(_greetingTimeout);
      try {
        await client.login(
          quoted(settings.usernameFor(address)),
          quoted(password),
        );
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
  required String password,
  required OpenMailSocket openSocket,
}) async {
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
        throw ApiException(
          0,
          'no_tls',
          "$host doesn't offer STARTTLS on port $port, so REST Mail won't "
              'send through it.',
        );
      }
      await client.startTls().timeout(_smtpTimeout);
    }
    final mechanisms = client.serverInfo.authMechanisms;
    final mechanism =
        mechanisms.contains(AuthMechanism.login) &&
            !mechanisms.contains(AuthMechanism.plain)
        ? AuthMechanism.login
        : AuthMechanism.plain;
    try {
      await client
          .authenticate(settings.usernameFor(address), password, mechanism)
          .timeout(_smtpTimeout);
    } on SmtpException catch (e) {
      throw signInRefused(e.message, host: host);
    }
    return client;
  } on Object catch (e) {
    unawaited(client.disconnect().catchError((Object _) {}));
    throw mailException(e, host: host);
  }
}

/// An IMAP quoted string (RFC 3501): backslashes and quotes escaped. Line
/// breaks can't be in one at all, so they are dropped rather than let a
/// pasted password carry a second command.
String quoted(String value) => value
    .replaceAll(RegExp(r'[\r\n]'), '')
    .replaceAll(r'\', r'\\')
    .replaceAll('"', r'\"');

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
  return ApiException(
    401,
    'unauthorized',
    text.isEmpty ? '$host turned down the address or password.' : text,
  );
}

/// What went wrong, as the [ApiException] the screens already handle.
ApiException mailException(Object error, {required String host}) =>
    switch (error) {
      ApiException() => error,
      HandshakeException() || TlsException()
          when '$error'.toUpperCase().contains('CERTIFICATE') =>
        ApiException(0, 'tls_error', "$host's certificate isn't trusted."),
      HandshakeException() || TlsException() => ApiException(
        0,
        'no_tls',
        "$host didn't answer over TLS, so REST Mail won't use it.",
      ),
      TimeoutException() => ApiException(
        0,
        'timeout',
        '$host took too long to answer.',
      ),
      SocketException() => ApiException(
        0,
        'network_error',
        "Can't reach $host.",
      ),
      ImapException(:final message) => ApiException(
        502,
        'imap_error',
        message?.trim().isNotEmpty == true
            ? '$host said: ${message!.trim()}'
            : '$host turned that down.',
      ),
      SmtpException(:final message) => ApiException(
        502,
        'smtp_error',
        message?.trim().isNotEmpty == true
            ? '$host said: ${message!.trim()}'
            : "$host wouldn't send it.",
      ),
      _ => ApiException(0, 'mail_error', 'Something went wrong with $host.'),
    };
