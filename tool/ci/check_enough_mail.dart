// Pure-Dart transport checks for upstream enough_mail upgrades. These drive the
// app's connection/backend over scripted sockets; widget/full suites stay in CI.
import 'dart:async';
import 'dart:io';

import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../test/imap/scripted_server.dart';

const _settings = MailServerSettings(
  imapHost: 'imap.example.test',
  smtpHost: 'smtp.example.test',
);

void _require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Rule _logout() => Rule(r'^LOGOUT', '* BYE\n{tag} OK done', repeat: true);

ImapBackend _backend(ScriptedServer server) => ImapBackend(
  address: 'alice@example.test',
  displayName: 'Alice',
  password: 'fixture-password',
  settings: _settings,
  openSocket: server.sockets,
);

Future<void> _cleanup(
  ScriptedServer server, {
  ImapBackend? backend,
  ImapConnection? connection,
}) async {
  try {
    await (backend?.close() ?? connection?.close() ?? Future<void>.value())
        .timeout(const Duration(seconds: 5));
  } finally {
    await server.close();
  }
}

Future<void> _status(String mailbox) async {
  final server = await ScriptedServer.start(gmailGreeting, [
    gmailLogin(),
    gmailList(),
    _logout(),
    Rule(
      r'^STATUS',
      '* STATUS $mailbox (MESSAGES 231 UNSEEN 12)\n{tag} OK done',
      repeat: true,
    ),
  ]);
  final backend = _backend(server);
  try {
    final folders = await backend
        .folders(ImapBackend.accountId)
        .timeout(const Duration(seconds: 5));
    _require(
      folders.first.total == 231 && folders.first.unread == 12,
      'STATUS $mailbox lost its message/unread counts',
    );
    _require(server.unexpected.isEmpty, 'unexpected STATUS exchange');
  } finally {
    await _cleanup(server, backend: backend);
  }
}

Future<void> _credentials() async {
  const password = r'pa"ss\word';
  const command = r'LOGIN "alice@example.test" "pa\"ss\\word"';
  final server = await ScriptedServer.start('* OK IMAP ready', [
    Rule(
      '^${RegExp.escape(command)}${r'$'}',
      '{tag} OK [CAPABILITY IMAP4rev1] signed in',
    ),
    _logout(),
  ]);
  ImapConnection? connection;
  try {
    connection = await ImapConnection.open(
      _settings,
      address: 'alice@example.test',
      password: password,
      openSocket: server.sockets,
    ).timeout(const Duration(seconds: 5));
    _require(
      server.commands.contains(command),
      'credentials were double-escaped',
    );
    _require(server.unexpected.isEmpty, 'unexpected credential exchange');
  } finally {
    await _cleanup(server, connection: connection);
  }
}

Future<void> _mailboxEncoding() async {
  final server = await ScriptedServer.start('* OK IMAP ready', [
    Rule(r'^LOGIN ', '{tag} OK [CAPABILITY IMAP4rev1] signed in'),
    Rule(r'^CREATE (?:"&U,BTFw-"|&U,BTFw-)$', '{tag} OK created'),
    Rule(r'^LIST ', '* LIST () "/" "&U,BTFw-"\n{tag} OK listed'),
    _logout(),
  ]);
  ImapConnection? connection;
  try {
    connection = await ImapConnection.open(
      _settings,
      address: 'alice@example.test',
      password: 'fixture-password',
      openSocket: server.sockets,
    ).timeout(const Duration(seconds: 5));
    final box = await connection
        .run((client) => client.createMailbox('台北'))
        .timeout(const Duration(seconds: 5));
    _require(
      box.path == '台北',
      'created mailbox did not decode to its display path',
    );
    _require(
      server.commands.any(
        (c) => c == 'CREATE "&U,BTFw-"' || c == 'CREATE &U,BTFw-',
      ),
      'CREATE did not use modified UTF-7',
    );
    _require(
      server.commands
          .where((c) => c.startsWith('LIST '))
          .any((c) => c.contains('&U,BTFw-') && !c.contains('台北')),
      'post-create LIST sent a raw UTF-8 mailbox path',
    );
    _require(server.unexpected.isEmpty, 'unexpected mailbox encoding exchange');
  } finally {
    await _cleanup(server, connection: connection);
  }
}

Future<void> _idleEvents() async {
  final server = await ScriptedServer.start(gmailGreeting, [
    gmailLogin(),
    gmailList(),
    _logout(),
    Rule(r'^SELECT', selected('INBOX'), repeat: true),
  ]);
  final backend = _backend(server);
  final live = Completer<void>();
  final received = Completer<void>();
  final subscription = backend
      .events(
        ImapBackend.accountId,
        onLiveChanged: (up) {
          if (up && !live.isCompleted) live.complete();
        },
      )
      .listen((event) {
        if (event.type == MailEventType.newMessage &&
            event.folder == StandardFolder.inbox &&
            !received.isCompleted) {
          received.complete();
        }
      });
  try {
    await live.future.timeout(const Duration(seconds: 5));
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (!server.commands.contains('IDLE') &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    _require(server.commands.contains('IDLE'), 'watcher did not enter IDLE');
    server.push('* 4 EXISTS');
    await received.future.timeout(const Duration(seconds: 5));
    _require(server.unexpected.isEmpty, 'unexpected IDLE exchange');
  } finally {
    try {
      await subscription.cancel().timeout(const Duration(seconds: 5));
    } finally {
      await _cleanup(server, backend: backend);
    }
  }
}

Future<void> main() async {
  final checks = <String, Future<void> Function()>{
    'Outlook unquoted STATUS': () => _status('INBOX'),
    'quoted STATUS': () => _status('"INBOX"'),
    'parentheses inside quoted mailbox': () => _status('"Project (team)"'),
    'LOGIN credentials escaped once': _credentials,
    'CREATE and follow-up LIST mailbox encoding': _mailboxEncoding,
    'typed stream IDLE notification': _idleEvents,
  };
  try {
    for (final entry in checks.entries) {
      await entry.value().timeout(const Duration(seconds: 20));
      stdout.writeln('PASS ${entry.key}');
    }
    stdout.writeln('${checks.length} enough_mail compatibility checks passed');
  } on Object catch (error, stack) {
    stderr.writeln('FAIL enough_mail compatibility: $error');
    stderr.writeln(stack);
    exitCode = 1;
  }
}
