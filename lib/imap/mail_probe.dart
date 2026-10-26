import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import '../net/http_client.dart';
import 'mail_connection.dart';

enum MailProtocol { imap, pop3, smtp }

/// A service to try. STARTTLS always means an upgrade is required.
class MailEndpoint {
  const MailEndpoint(
    this.protocol,
    this.host,
    this.port, {
    this.starttls = false,
    this.plaintext = false,
  }) : assert(!plaintext || (protocol == MailProtocol.pop3 && !starttls));

  final MailProtocol protocol;
  final String host;
  final int port;
  final bool starttls;
  final bool plaintext;

  String get label =>
      '$host:$port · ${plaintext
          ? 'TCP'
          : starttls
          ? 'STARTTLS'
          : 'TLS'}';

  @override
  bool operator ==(Object other) =>
      other is MailEndpoint &&
      other.protocol == protocol &&
      other.host == host &&
      other.port == port &&
      other.starttls == starttls &&
      other.plaintext == plaintext;

  @override
  int get hashCode => Object.hash(protocol, host, port, starttls, plaintext);
}

/// Cancels an obsolete search and closes its active sockets.
class MailSearchCancellation {
  bool _cancelled = false;
  final _close = <void Function()>{};

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
    for (final close in [..._close]) {
      close();
    }
  }
}

typedef UpgradeProbeSocket = Future<Socket> Function(
  Socket socket,
  String host,
);

Future<Socket> _upgrade(Socket socket, String host) =>
    SecureSocket.secure(socket, host: host, context: createSecurityContext());

/// Checks the protocol and capabilities, without credentials. TLS
/// certificates are verified; plain POP3 is reported for diagnosis only.
/// An open TCP port alone never counts as a working mail service.
Future<bool> probeMailEndpoint(
  MailEndpoint endpoint, {
  required OpenMailSocket openSocket,
  UpgradeProbeSocket upgradeSocket = _upgrade,
  Duration timeout = const Duration(seconds: 6),
  MailSearchCancellation? cancellation,
}) async {
  if (cancellation?.isCancelled ?? false) return false;
  _ProbeSession? session;
  var expired = false;
  void abort() {
    expired = true;
    session?.close();
  }

  cancellation?._close.add(abort);
  final timer = Timer(timeout, abort);
  try {
    final socket =
        await openSocket(
              endpoint.host,
              endpoint.port,
              tls: !endpoint.starttls && !endpoint.plaintext,
            )
            .then((socket) {
              if (expired) socket.destroy();
              return socket;
            })
            .timeout(timeout);
    if (expired) {
      socket.destroy();
      return false;
    }
    final connection = session = _ProbeSession(socket, timeout);
    switch (endpoint.protocol) {
      case MailProtocol.imap:
        final greeting = await connection.line();
        if (!RegExp(
          r'^\* (OK|PREAUTH)\b',
          caseSensitive: false,
        ).hasMatch(greeting)) {
          return false;
        }
        var capabilities = await connection.imap('p1', 'CAPABILITY');
        if (endpoint.starttls) {
          if (!capabilities.toUpperCase().contains('STARTTLS')) return false;
          await connection.imap('p2', 'STARTTLS');
          await connection.upgrade(endpoint.host, upgradeSocket);
          capabilities = await connection.imap('p3', 'CAPABILITY');
        }
        return RegExp(
          r'IMAP4REV[12]',
          caseSensitive: false,
        ).hasMatch(capabilities);
      case MailProtocol.pop3:
        if (!(await connection.line()).startsWith('+OK')) return false;
        if (endpoint.starttls) {
          connection.send('STLS');
          if (!(await connection.line()).startsWith('+OK')) return false;
          await connection.upgrade(endpoint.host, upgradeSocket);
        }
        connection.send('CAPA');
        final capabilities = await connection.line();
        if (capabilities.startsWith('-ERR')) return true;
        if (!capabilities.startsWith('+OK')) return false;
        for (var i = 0; i < 100; i++) {
          if (await connection.line() == '.') return true;
        }
        return false;
      case MailProtocol.smtp:
        await connection.smtpReply(220);
        connection.send('EHLO restmail.invalid');
        var capabilities = await connection.smtpReply(250);
        if (endpoint.starttls) {
          if (!RegExp(
            r'^250[ -]STARTTLS\b',
            caseSensitive: false,
            multiLine: true,
          ).hasMatch(capabilities)) {
            return false;
          }
          connection.send('STARTTLS');
          await connection.smtpReply(220);
          await connection.upgrade(endpoint.host, upgradeSocket);
          connection.send('EHLO restmail.invalid');
          capabilities = await connection.smtpReply(250);
        }
        return RegExp(
          r'^250[ -]AUTH[ =]',
          caseSensitive: false,
          multiLine: true,
        ).hasMatch(capabilities);
    }
  } on Object {
    return false;
  } finally {
    expired = true;
    timer.cancel();
    cancellation?._close.remove(abort);
    session?.close();
  }
}

class _ProbeSession {
  _ProbeSession(this.socket, this.timeout) {
    _listen();
  }

  Socket socket;
  final Duration timeout;
  late StreamSubscription<List<int>> _subscription;
  final _lines = Queue<String>();
  final _buffer = <int>[];
  Completer<void>? _ready;
  bool _closed = false;
  int _receivedBytes = 0;

  void _listen() {
    _subscription = socket.listen(
      (data) {
        _receivedBytes += data.length;
        _buffer.addAll(data);
        if (_receivedBytes > 131072 || _buffer.length > 65536) {
          close();
          return;
        }
        var end = _buffer.indexOf(10);
        while (end >= 0) {
          _lines.add(
            utf8
                .decode(_buffer.sublist(0, end), allowMalformed: true)
                .replaceFirst(RegExp(r'\r$'), ''),
          );
          _buffer.removeRange(0, end + 1);
          end = _buffer.indexOf(10);
        }
        _wake();
      },
      onError: (Object _) => close(),
      onDone: close,
    );
  }

  void _wake() {
    final ready = _ready;
    _ready = null;
    ready?.complete();
  }

  Future<String> line() async {
    while (_lines.isEmpty) {
      if (_closed) throw const SocketException('Connection closed');
      _ready ??= Completer<void>();
      await _ready!.future.timeout(timeout);
    }
    return _lines.removeFirst();
  }

  void send(String command) => socket.write('$command\r\n');

  Future<String> imap(String tag, String command) async {
    send('$tag $command');
    final lines = <String>[];
    for (var i = 0; i < 100; i++) {
      final response = await line();
      lines.add(response);
      if (response.toUpperCase().startsWith('${tag.toUpperCase()} ')) {
        if (!response.toUpperCase().startsWith('${tag.toUpperCase()} OK')) {
          throw const FormatException('IMAP command refused');
        }
        return lines.join('\n');
      }
    }
    throw const FormatException('IMAP reply too long');
  }

  Future<String> smtpReply(int code) async {
    final lines = <String>[];
    for (var i = 0; i < 100; i++) {
      final response = await line();
      if (!response.startsWith('$code ') && !response.startsWith('$code-')) {
        throw const FormatException('Unexpected SMTP reply');
      }
      lines.add(response);
      if (response.startsWith('$code ')) return lines.join('\n');
    }
    throw const FormatException('SMTP reply too long');
  }

  Future<void> upgrade(String host, UpgradeProbeSocket upgradeSocket) async {
    _subscription.pause();
    final secured = await upgradeSocket(socket, host).timeout(timeout);
    if (_closed) {
      secured.destroy();
      throw const SocketException('Connection closed');
    }
    await _subscription.cancel();
    socket = secured;
    _lines.clear();
    _buffer.clear();
    _listen();
  }

  void close() {
    if (_closed) return;
    _closed = true;
    socket.destroy();
    unawaited(_subscription.cancel());
    _wake();
  }
}
