import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:restmail/imap/mail_connection.dart';

/// One answer a [ScriptedServer] gives: to the first command matching
/// [pattern], [reply], with `{tag}` standing for the command's tag. A rule
/// answers once unless [repeat] is set.
class Rule {
  Rule(String pattern, this.reply, {this.repeat = false})
    : pattern = RegExp(pattern, caseSensitive: false);

  final RegExp pattern;
  final String reply;
  final bool repeat;
  bool used = false;
}

/// A pretend IMAP or SMTP server on localhost, answering from recorded
/// responses, so the backend is tested against the bytes real servers send
/// and enough_mail's own parsers read them.
///
/// IMAP mode reads tagged commands, with synchronising literals (`{n}`) as
/// APPEND sends them, and IDLE until DONE. SMTP mode reads plain commands and
/// a DATA body up to the lone dot.
class ScriptedServer {
  ScriptedServer._(this._socket, this.greeting, this.rules, this.smtp);

  static Future<ScriptedServer> start(
    String greeting,
    List<Rule> rules, {
    bool smtp = false,
  }) async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final server = ScriptedServer._(socket, greeting, rules, smtp);
    socket.listen(server._serve);
    return server;
  }

  final ServerSocket _socket;
  final String greeting;
  final List<Rule> rules;
  final bool smtp;

  /// Every command received, tag dropped, literals in braces.
  final commands = <String>[];

  /// The bodies received: APPEND literals and SMTP DATA.
  final bodies = <String>[];

  /// Commands no rule matched.
  final unexpected = <String>[];

  int connections = 0;
  final _clients = <Socket>[];

  int get port => _socket.port;

  /// Opens plain sockets to this server whatever was asked, as the tests
  /// play both TLS and STARTTLS servers in the clear.
  OpenMailSocket get sockets =>
      (host, port, {required tls}) =>
          Socket.connect(InternetAddress.loopbackIPv4, this.port);

  void add(Rule rule) => rules.add(rule);

  Future<void> close() async {
    dropAll();
    await _socket.close();
  }

  /// Sends [text] unasked to every open connection, as a server does to a
  /// client in IDLE.
  void push(String text) {
    for (final c in _clients) {
      c.write('${_crlf(text)}\r\n');
    }
  }

  /// Drops every open connection, as a server or network might.
  void dropAll() {
    for (final c in [..._clients]) {
      c.destroy();
    }
    _clients.clear();
  }

  void _serve(Socket client) {
    connections++;
    _clients.add(client);
    client.write('${_crlf(greeting)}\r\n');
    final buffer = <int>[];
    int? literal;
    String? pendingLine;
    String? idleTag;
    var inData = false;

    void answer(String tag, String command) {
      commands.add(command);
      if (!smtp && command.toUpperCase() == 'IDLE') {
        idleTag = tag;
        client.write('+ idling\r\n');
        return;
      }
      final rule = rules
          .where((r) => (r.repeat || !r.used) && r.pattern.hasMatch(command))
          .firstOrNull;
      if (rule == null) {
        unexpected.add(command);
        // ignore: avoid_print
        print('scripted server: unexpected $command');
        client.write(smtp ? '500 unexpected\r\n' : '$tag BAD unexpected\r\n');
        return;
      }
      rule.used = true;
      if (smtp && command.toUpperCase() == 'DATA') inData = true;
      client.write('${_crlf(rule.reply.replaceAll('{tag}', tag))}\r\n');
    }

    void line(String text) {
      if (smtp) {
        if (inData) {
          if (text == '.') {
            inData = false;
            answer('', '.');
          } else {
            bodies.add(text);
          }
          return;
        }
        answer('', text);
        return;
      }
      if (idleTag != null && text.toUpperCase() == 'DONE') {
        client.write('$idleTag OK IDLE terminated\r\n');
        idleTag = null;
        return;
      }
      final full = pendingLine == null ? text : '$pendingLine$text';
      pendingLine = null;
      final open = RegExp(r'\{(\d+)\+?\}$').firstMatch(full);
      if (open != null) {
        literal = int.parse(open[1]!);
        pendingLine = full;
        if (!full.endsWith('+}')) client.write('+ go ahead\r\n');
        return;
      }
      final space = full.indexOf(' ');
      if (space < 0) return;
      answer(full.substring(0, space), full.substring(space + 1));
    }

    client.listen(
      (data) {
        buffer.addAll(data);
        while (true) {
          final need = literal;
          if (need != null) {
            if (buffer.length < need) return;
            bodies.add(utf8.decode(buffer.sublist(0, need)));
            buffer.removeRange(0, need);
            literal = null;
            pendingLine = pendingLine?.replaceFirst(
              RegExp(r'\{\d+\+?\}$'),
              '{literal}',
            );
            continue;
          }
          final end = _indexOfCrlf(buffer);
          if (end < 0) return;
          final text = utf8.decode(buffer.sublist(0, end));
          buffer.removeRange(0, end + 2);
          line(text);
        }
      },
      onError: (Object _) {},
      onDone: () => _clients.remove(client),
    );
  }

  static String _crlf(String text) =>
      text.replaceAll('\r\n', '\n').replaceAll('\n', '\r\n');

  static int _indexOfCrlf(List<int> bytes) {
    for (var i = 0; i + 1 < bytes.length; i++) {
      if (bytes[i] == 13 && bytes[i + 1] == 10) return i;
    }
    return -1;
  }
}

/// Gmail's greeting and its answer to LOGIN, as it sends them.
const gmailGreeting = '* OK Gimap ready for requests from 192.0.2.1 x1mb';

Rule gmailLogin() => Rule(
  r'^LOGIN ',
  '{tag} OK [CAPABILITY IMAP4rev1 UNSELECT IDLE NAMESPACE QUOTA ID XLIST '
      'CHILDREN X-GM-EXT-1 UIDPLUS COMPRESS=DEFLATE ENABLE MOVE CONDSTORE '
      'ESEARCH LIST-EXTENDED LIST-STATUS LITERAL- SPECIAL-USE '
      'APPENDLIMIT=35651584] ada@gmail.com authenticated (Success)',
  repeat: true,
);

/// Gmail's folder list, with its SPECIAL-USE flags.
Rule gmailList() => Rule(r'^LIST ', r'''* LIST (\HasNoChildren) "/" "INBOX"
* LIST (\HasNoChildren) "/" "Receipts"
* LIST (\HasChildren \Noselect) "/" "[Gmail]"
* LIST (\All \HasNoChildren) "/" "[Gmail]/All Mail"
* LIST (\Drafts \HasNoChildren) "/" "[Gmail]/Drafts"
* LIST (\HasNoChildren \Important) "/" "[Gmail]/Important"
* LIST (\HasNoChildren \Sent) "/" "[Gmail]/Sent Mail"
* LIST (\HasNoChildren \Junk) "/" "[Gmail]/Spam"
* LIST (\Flagged \HasNoChildren) "/" "[Gmail]/Starred"
* LIST (\HasNoChildren \Trash) "/" "[Gmail]/Trash"
{tag} OK Success''', repeat: true);

String selected(String name, {int exists = 3, int validity = 11}) =>
    '''* FLAGS (\\Answered \\Flagged \\Draft \\Deleted \\Seen \$NotPhishing \$Phishing)
* OK [PERMANENTFLAGS (\\Answered \\Flagged \\Draft \\Deleted \\Seen \$NotPhishing \$Phishing \\*)] Flags permitted.
* OK [UIDVALIDITY $validity] UIDs valid.
* $exists EXISTS
* 0 RECENT
* OK [UIDNEXT 120] Predicted next UID.
* OK [HIGHESTMODSEQ 4242]
{tag} OK [READ-WRITE] $name selected. (Success)''';
