import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail_api/restmail_api.dart';

import 'scripted_server.dart';

/// Gmail's answer to fetching the inbox's three messages: a plain one read,
/// one with an attachment and an encoded subject, and a flagged one.
const _inboxFetch = r'''* 1 FETCH (UID 101 FLAGS (\Seen) INTERNALDATE "14-Oct-2026 09:15:02 +0000" RFC822.SIZE 2210 ENVELOPE ("Wed, 14 Oct 2026 10:15:00 +0100" "Lunch on Friday?" (("Grace Hopper" NIL "grace" "example.com")) (("Grace Hopper" NIL "grace" "example.com")) (("Grace Hopper" NIL "grace" "example.com")) (("Ada Lovelace" NIL "ada" "gmail.com")) NIL NIL NIL "<lunch-1@example.com>") BODYSTRUCTURE ("TEXT" "PLAIN" ("CHARSET" "UTF-8") NIL NIL "7BIT" 120 4 NIL NIL NIL NIL))
* 2 FETCH (UID 105 FLAGS () INTERNALDATE "15-Oct-2026 18:00:00 +0000" RFC822.SIZE 51234 ENVELOPE ("Thu, 15 Oct 2026 18:00:00 +0000" "=?UTF-8?Q?Invoice_=E2=80=93_October?=" (("Billing" NIL "billing" "shop.example")) (("Billing" NIL "billing" "shop.example")) (("Billing" NIL "billing" "shop.example")) ((NIL NIL "ada" "gmail.com")) NIL NIL NIL "<inv-10@shop.example>") BODYSTRUCTURE (("TEXT" "PLAIN" ("CHARSET" "UTF-8") NIL NIL "QUOTED-PRINTABLE" 200 6 NIL NIL NIL NIL)("APPLICATION" "PDF" ("NAME" "invoice.pdf") NIL NIL "BASE64" 50000 NIL ("ATTACHMENT" ("FILENAME" "invoice.pdf")) NIL NIL) "MIXED" ("BOUNDARY" "b1") NIL NIL NIL))
* 3 FETCH (UID 110 FLAGS (\Flagged) INTERNALDATE "16-Oct-2026 07:30:00 +0000" RFC822.SIZE 900 ENVELOPE ("Fri, 16 Oct 2026 07:29:58 +0000" "Re: Lunch on Friday?" (("Grace Hopper" NIL "grace" "example.com")) (("Grace Hopper" NIL "grace" "example.com")) (("Grace Hopper" NIL "grace" "example.com")) (("Ada Lovelace" NIL "ada" "gmail.com")) (("Alan Turing" NIL "alan" "example.org")) NIL "<lunch-1@example.com>" "<lunch-2@example.com>") BODYSTRUCTURE ("TEXT" "PLAIN" ("CHARSET" "UTF-8") NIL NIL "7BIT" 80 2 NIL NIL NIL NIL))
{tag} OK Success''';

const _lunchBody =
    'From: Grace Hopper <grace@example.com>\r\n'
    'To: Ada Lovelace <ada@gmail.com>\r\n'
    'Subject: Lunch on Friday?\r\n'
    'Date: Wed, 14 Oct 2026 10:15:00 +0100\r\n'
    'Message-ID: <lunch-1@example.com>\r\n'
    'Content-Type: text/plain; charset=UTF-8\r\n'
    '\r\n'
    'Shall we try the new place at one?\r\n';

const _gmail = MailServerSettings(
  imapHost: 'imap.gmail.com',
  smtpHost: 'smtp.gmail.com',
  filesSentMail: true,
);

ImapBackend _backend(
  ScriptedServer imap, {
  MailServerSettings settings = _gmail,
  OpenMailSocket? sockets,
}) => ImapBackend(
  address: 'ada@gmail.com',
  displayName: 'Ada Lovelace',
  password: 'abcdabcdabcdabcd',
  settings: settings,
  openSocket: sockets ?? imap.sockets,
);

Rule _logout() => Rule(r'^LOGOUT', '* BYE\n{tag} OK Success', repeat: true);

Future<ScriptedServer> _gmailServer(List<Rule> more) => ScriptedServer.start(
  gmailGreeting,
  [gmailLogin(), gmailList(), _logout(), ...more],
);

void main() {
  group('folders', () {
    test('take rest-mail names from their SPECIAL-USE flags, and Gmail '
        'names Important and Starred', () async {
      final server = await _gmailServer([
        Rule(
          r'^STATUS',
          '* STATUS "x" (MESSAGES 3 UNSEEN 1)\n{tag} OK Success',
          repeat: true,
        ),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);

      final folders = await backend.folders(ImapBackend.accountId);

      expect(folders.map((f) => f.name), [
        'INBOX',
        'Receipts',
        'All Mail',
        'Drafts',
        'Important',
        'Sent',
        'Spam',
        'Starred',
        'Trash',
      ]);
      expect(folders.first.total, 3);
      expect(folders.first.unread, 1);
      // `[Gmail]` itself can't be selected, so it isn't asked about.
      expect(
        server.commands.where((c) => c.startsWith('STATUS')),
        hasLength(9),
      );
      expect(server.unexpected, isEmpty);
    });

    test('count a mailbox Outlook names without quotes', () async {
      // Outlook.com answers `STATUS INBOX (...)`, the name an atom; read as
      // nothing, every Hotmail folder showed 0.
      final server = await _gmailServer([
        Rule(
          r'^STATUS',
          '* STATUS INBOX (MESSAGES 231 UNSEEN 12)\n{tag} OK STATUS completed.',
          repeat: true,
        ),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);

      final folders = await backend.folders(ImapBackend.accountId);

      expect(folders.first.total, 231);
      expect(folders.first.unread, 12);
      expect(server.unexpected, isEmpty);
    });

    test('without SPECIAL-USE, the usual names stand in', () async {
      final server = await ScriptedServer.start('* OK Dovecot ready.', [
        Rule(r'^LOGIN', '{tag} OK [CAPABILITY IMAP4rev1 IDLE] Logged in'),
        Rule(r'^LIST', r'''* LIST (\HasNoChildren) "." INBOX
* LIST (\HasNoChildren) "." "Sent Items"
* LIST (\HasNoChildren) "." "Deleted Items"
* LIST (\HasNoChildren) "." "Junk E-mail"
* LIST (\HasNoChildren) "." INBOX.Drafts
* LIST (\HasNoChildren) "." Projects
{tag} OK List completed.''', repeat: true),
        Rule(
          r'^STATUS',
          '* STATUS x (MESSAGES 0 UNSEEN 0)\n{tag} OK done',
          repeat: true,
        ),
        _logout(),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);

      final folders = await backend.folders(ImapBackend.accountId);

      expect(folders.map((f) => f.name), [
        'INBOX',
        'Sent',
        'Trash',
        'Spam',
        'Drafts',
        'Projects',
      ]);
    });
  });

  group('messages', () {
    test('come newest first, mapped onto rest-mail messages', () async {
      final server = await _gmailServer([
        Rule(r'^SELECT', selected('INBOX'), repeat: true),
        Rule(r'^FETCH 1:3 ', _inboxFetch),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);

      final page = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
      );

      expect(server.unexpected, isEmpty);
      expect(page.items.map((m) => m.id & 0xffffffff), [110, 105, 101]);
      expect(page.hasMore, isFalse);
      expect(page.cursor, isNull);
      final [reply, invoice, lunch] = page.items;
      expect(lunch.subject, 'Lunch on Friday?');
      expect(lunch.sender, 'grace@example.com');
      expect(lunch.senderName, 'Grace Hopper');
      expect(lunch.to.single.address, 'ada@gmail.com');
      expect(lunch.messageId, '<lunch-1@example.com>');
      expect(lunch.isRead, isTrue);
      expect(lunch.folder, StandardFolder.inbox);
      expect(lunch.receivedAt, DateTime.utc(2026, 10, 14, 9, 15, 2).toLocal());
      expect(invoice.subject, 'Invoice – October');
      expect(invoice.hasAttachments, isTrue);
      expect(invoice.isRead, isFalse);
      expect(reply.isFlagged, isTrue);
      expect(reply.inReplyTo, '<lunch-1@example.com>');
      expect(reply.cc.single.name, 'Alan Turing');
      expect({for (final m in page.items) m.id}, hasLength(3));
    });

    test('page by UID: the next page ends below the oldest shown', () async {
      final server = await _gmailServer([
        Rule(r'^SELECT', selected('INBOX', exists: 120), repeat: true),
        Rule(r'^FETCH 71:120 ', _inboxFetch),
        Rule(r'^SEARCH UID 101$', '* SEARCH 71\n{tag} OK SEARCH completed'),
        Rule(r'^FETCH 21:70 ', _inboxFetch.replaceAll('UID 1', 'UID ')),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);

      final first = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
      );
      expect(first.hasMore, isTrue);
      expect(first.cursor, '11:101');

      final next = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
        cursor: first.cursor,
      );

      expect(server.unexpected, isEmpty);
      expect(next.items.map((m) => m.id & 0xffffffff), [10, 5, 1]);
      expect(next.hasMore, isTrue);
    });

    test('a message opens with its body', () async {
      final server = await _gmailServer([
        Rule(r'^SELECT', selected('INBOX'), repeat: true),
        Rule(r'^FETCH 1:3 ', _inboxFetch),
        Rule(
          r'^UID FETCH 101 \(UID FLAGS INTERNALDATE RFC822.SIZE ENVELOPE '
              r'BODYSTRUCTURE( X-GM-MSGID X-GM-THRID X-GM-LABELS)?\)',
          '${_inboxFetch.split('\n').first}\n{tag} OK Success',
        ),
        Rule(
          r'^UID FETCH 101 .*BODY.PEEK\[\]',
          '* 1 FETCH (UID 101 FLAGS (\\Seen) BODY[] {${_lunchBody.length}}\n'
              '$_lunchBody)\n{tag} OK Success',
        ),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);
      final page = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
      );

      final lunch = await backend.message(page.items.last.id);

      expect(server.unexpected, isEmpty);
      expect(lunch.id, page.items.last.id);
      expect(lunch.bodyText?.trim(), 'Shall we try the new place at one?');
      expect(lunch.subject, 'Lunch on Friday?');
    });
  });

  group('changes', () {
    test('delete moves to Trash, and Undo follows it there and back', () async {
      final server = await _gmailServer([
        Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
        Rule(r'^SELECT "?\[Gmail\]/Trash"?', selected('Trash', validity: 7)),
        Rule(r'^FETCH 1:3 ', _inboxFetch),
        Rule(
          r'^UID MOVE 101 "?\[Gmail\]/Trash"?',
          '* OK [COPYUID 7 101 33]\n* 1 EXPUNGE\n{tag} OK Success',
        ),
        Rule(
          r'^UID MOVE 33 "?INBOX',
          '* OK [COPYUID 11 33 130]\n* 1 EXPUNGE\n{tag} OK Success',
        ),
        Rule(
          r'^UID STORE 130 \+FLAGS.SILENT \(\\Flagged\)',
          '{tag} OK Success',
        ),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);
      final page = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
      );
      final lunch = page.items.last;

      await backend.deleteMessage(lunch.id);
      final back = await backend.updateMessage(
        lunch.id,
        folder: StandardFolder.inbox,
      );
      // Still the same id, now naming UID 130 in the inbox.
      await backend.updateMessage(lunch.id, isFlagged: true);

      expect(server.unexpected, isEmpty);
      expect(back.id, lunch.id);
      expect(back.folder, StandardFolder.inbox);
      expect(server.commands.where((c) => c.startsWith('UID')), [
        'UID MOVE 101 "[Gmail]/Trash"',
        'UID MOVE 33 "INBOX"',
        r'UID STORE 130 +FLAGS.SILENT (\Flagged)',
      ]);
    });

    test('without MOVE: COPY, mark deleted, EXPUNGE, and find it by its '
        'Message-ID', () async {
      final server = await ScriptedServer.start('* OK ready', [
        Rule(r'^LOGIN', '{tag} OK [CAPABILITY IMAP4rev1] Logged in'),
        gmailList(),
        _logout(),
        Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
        Rule(r'^SELECT "?\[Gmail\]/Spam"?', selected('Spam', validity: 9)),
        Rule(r'^FETCH 1:3 ', _inboxFetch),
        Rule(r'^UID COPY 101 "?\[Gmail\]/Spam"?', '{tag} OK COPY completed'),
        Rule(
          r'^UID STORE 101 \+FLAGS.SILENT \(\\Deleted\)',
          '{tag} OK STORE completed',
        ),
        Rule(r'^EXPUNGE$', '* 1 EXPUNGE\n{tag} OK EXPUNGE completed'),
        Rule(
          r'^UID SEARCH HEADER Message-ID "<lunch-1@example.com>"',
          '* SEARCH 44\n{tag} OK SEARCH completed',
        ),
      ]);
      addTearDown(server.close);
      final backend = _backend(server);
      addTearDown(backend.close);
      final page = await backend.messages(
        ImapBackend.accountId,
        StandardFolder.inbox,
      );

      await backend.updateMessage(
        page.items.last.id,
        folder: StandardFolder.spam,
      );

      expect(server.unexpected, isEmpty);
      expect(server.commands.where((c) => !c.startsWith('LOGIN')).skip(3), [
        'UID COPY 101 "[Gmail]/Spam"',
        r'UID STORE 101 +FLAGS.SILENT (\Deleted)',
        'EXPUNGE',
        'SELECT "[Gmail]/Spam"',
        'UID SEARCH HEADER Message-ID "<lunch-1@example.com>"',
      ]);
    });

    test(
      'a draft is appended to Drafts, and replaced when it changes; on Gmail '
      'the old one goes by way of Trash',
      () async {
        final server = await _gmailServer([
          Rule(
            r'^APPEND "?\[Gmail\]/Drafts"? \(\\Draft \\Seen\) \{literal\}',
            '{tag} OK [APPENDUID 3 20] (Success)',
          ),
          Rule(
            r'^APPEND "?\[Gmail\]/Drafts"? \(\\Draft \\Seen\) \{literal\}',
            '{tag} OK [APPENDUID 3 21] (Success)',
          ),
          Rule(
            r'^SELECT "?\[Gmail\]/Drafts"?',
            selected('Drafts', validity: 3),
          ),
          // An EXPUNGE in Drafts would leave the old draft in All Mail.
          Rule(
            r'^UID MOVE 20 "?\[Gmail\]/Trash"?',
            '* OK [COPYUID 7 20 51]\n* 1 EXPUNGE\n{tag} OK Success',
          ),
          Rule(r'^SELECT "?\[Gmail\]/Trash"?', selected('Trash', validity: 7)),
          Rule(
            r'^UID STORE 51 \+FLAGS.SILENT \(\\Deleted\)',
            '{tag} OK Success',
          ),
          Rule(r'^UID EXPUNGE 51$', '* 1 EXPUNGE\n{tag} OK Success'),
        ]);
        addTearDown(server.close);
        final backend = _backend(server);
        addTearDown(backend.close);

        final draft = await backend.saveDraft(
          const OutgoingMessage(
            from: 'ada@gmail.com',
            to: ['grace@example.com'],
            subject: 'Notes',
            bodyText: 'First go',
          ),
        );
        final updated = await backend.updateDraft(
          draft.id,
          const OutgoingMessage(
            from: 'ada@gmail.com',
            to: ['grace@example.com'],
            subject: 'Notes',
            bodyText: 'Second go',
          ),
        );

        expect(server.unexpected, isEmpty);
        expect(draft.folder, StandardFolder.drafts);
        expect(draft.id & 0xffffffff, 20);
        expect(updated.id, draft.id);
        expect(server.bodies, hasLength(2));
        expect(server.bodies.last, contains('Second go'));
        expect(server.bodies.last, contains('"Ada Lovelace" <ada@gmail.com>'));
        expect(
          server.commands.where(
            (c) => c.startsWith('UID') || c.startsWith('EXPUNGE'),
          ),
          [
            'UID MOVE 20 "[Gmail]/Trash"',
            r'UID STORE 51 +FLAGS.SILENT (\Deleted)',
            'UID EXPUNGE 51',
          ],
        );
      },
    );
  });

  group('sending', () {
    Future<ScriptedServer> smtpServer({bool startTls = true}) =>
        ScriptedServer.start('220 smtp.example.test ESMTP ready', [
          Rule(
            r'^EHLO',
            [
              '250-smtp.example.test at your service',
              '250-SIZE 35882577',
              '250-8BITMIME',
              if (startTls) '250-STARTTLS',
              '250-AUTH LOGIN PLAIN',
              '250 SMTPUTF8',
            ].join('\n'),
            repeat: true,
          ),
          Rule(r'^AUTH PLAIN', '235 2.7.0 Accepted'),
          Rule(r'^MAIL FROM', '250 2.1.0 OK'),
          Rule(r'^RCPT TO', '250 2.1.5 OK', repeat: true),
          Rule(r'^DATA', '354 Go ahead'),
          Rule(r'^\.$', '250 2.0.0 OK queued'),
          Rule(r'^QUIT', '221 2.0.0 closing connection'),
        ], smtp: true);

    test('goes over SMTP and is filed in Sent once', () async {
      final smtp = await smtpServer();
      // A provider that isn't Gmail: no X-GM-EXT-1.
      final imap = await ScriptedServer.start('* OK IMAP ready', [
        Rule(
          r'^LOGIN ',
          '{tag} OK [CAPABILITY IMAP4rev1 IDLE UIDPLUS MOVE SPECIAL-USE] '
              'Logged in',
        ),
        gmailList(),
        _logout(),
        Rule(r'^SELECT "\[Gmail\]/Sent Mail"', selected('Sent', validity: 5)),
        Rule(
          r'^UID SEARCH HEADER Message-ID',
          '* SEARCH\n{tag} OK SEARCH completed',
        ),
        Rule(
          r'^APPEND "\[Gmail\]/Sent Mail" \(\\Seen\)',
          '{tag} OK [APPENDUID 5 77] (Success)',
        ),
      ]);
      addTearDown(smtp.close);
      addTearDown(imap.close);
      // A provider that doesn't file sent mail itself, on 465.
      const settings = MailServerSettings(
        imapHost: 'imap.example.test',
        smtpHost: 'smtp.example.test',
      );
      final backend = _backend(
        imap,
        settings: settings,
        sockets: (host, port, {required tls}) =>
            (host.startsWith('smtp') ? smtp : imap).sockets(
              host,
              port,
              tls: tls,
            ),
      );
      addTearDown(backend.close);

      final sent = await backend.send(
        const OutgoingMessage(
          from: 'ada@gmail.com',
          to: ['grace@example.com'],
          bcc: ['charles@example.com'],
          subject: 'Lunch',
          bodyText: 'One it is.',
          inReplyTo: '<lunch-1@example.com>',
        ),
      );

      expect(smtp.unexpected, isEmpty);
      expect(imap.unexpected, isEmpty);
      expect(smtp.commands, contains('RCPT TO:<charles@example.com>'));
      final data = smtp.bodies.join('\n');
      expect(data, contains('In-Reply-To: <lunch-1@example.com>'));
      expect(data, isNot(contains('charles@example.com')));
      expect(imap.commands.where((c) => c.startsWith('APPEND')), hasLength(1));
      expect(imap.bodies.single, contains('Bcc:'));
      expect(sent.folder, StandardFolder.sent);
      expect(sent.id & 0xffffffff, 77);
    });

    test('Gmail files it itself, so nothing is appended', () async {
      final smtp = await smtpServer();
      final imap = await _gmailServer([]);
      addTearDown(smtp.close);
      addTearDown(imap.close);
      final backend = _backend(
        imap,
        sockets: (host, port, {required tls}) =>
            (host.startsWith('smtp') ? smtp : imap).sockets(
              host,
              port,
              tls: tls,
            ),
      );
      addTearDown(backend.close);

      await backend.send(
        const OutgoingMessage(
          from: 'ada@gmail.com',
          to: ['grace@example.com'],
          subject: 'Hi',
          bodyText: 'Hello',
        ),
      );

      expect(smtp.commands, contains('.'));
      expect(imap.commands.where((c) => c.startsWith('APPEND')), isEmpty);
      expect(imap.unexpected, isEmpty);
    });

    test('on 587, a server without STARTTLS is refused before the password '
        'is sent', () async {
      final smtp = await smtpServer(startTls: false);
      addTearDown(smtp.close);

      await expectLater(
        openSmtp(
          const MailServerSettings(
            imapHost: 'imap.example.test',
            smtpHost: 'smtp.example.test',
            smtpPort: 587,
            smtpSecurity: SmtpSecurity.starttls,
          ),
          address: 'ada@example.test',
          password: 'secret',
          openSocket: smtp.sockets,
        ),
        throwsA(isA<ApiException>().having((e) => e.code, 'code', 'no_tls')),
      );
      expect(smtp.commands.where((c) => c.startsWith('AUTH')), isEmpty);
    });
  });

  group('signing in', () {
    test('Gmail asking for an app password says so', () async {
      final server = await ScriptedServer.start(gmailGreeting, [
        Rule(
          r'^LOGIN',
          '{tag} NO [ALERT] Application-specific password required: '
              'https://support.google.com/accounts/answer/185833 (Failure)',
        ),
      ]);
      addTearDown(server.close);

      await expectLater(
        _backend(server).verify(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'app_password_required')
              .having((e) => e.statusCode, 'status', 401),
        ),
      );
    });

    test('a password with quotes and backslashes is sent escaped', () async {
      final server = await ScriptedServer.start(gmailGreeting, [
        Rule(r'^LOGIN "ada@gmail.com" "a\\"b\\\\c"$', '{tag} OK Logged in'),
        _logout(),
        Rule(r'^CAPABILITY', '* CAPABILITY IMAP4rev1\n{tag} OK done'),
      ]);
      addTearDown(server.close);

      final connection = await ImapConnection.open(
        _gmail,
        address: 'ada@gmail.com',
        password: r'a"b\c',
        openSocket: server.sockets,
      );
      addTearDown(connection.close);

      expect(server.unexpected, isEmpty);
    });

    test(
      'a server that doesn\'t talk TLS on the IMAP port is refused',
      () async {
        final plain = await ScriptedServer.start(gmailGreeting, []);
        addTearDown(plain.close);
        final sockets = defaultMailSockets(SecurityContext.new);

        await expectLater(
          ImapConnection.open(
            const MailServerSettings(
              imapHost: '127.0.0.1',
              smtpHost: '127.0.0.1',
            ),
            address: 'ada@example.test',
            password: 'secret',
            openSocket: (host, port, {required tls}) =>
                sockets(host, plain.port, tls: tls),
          ),
          throwsA(isA<ApiException>().having((e) => e.code, 'code', 'no_tls')),
        );
        expect(plain.commands, isEmpty);
      },
    );
  });

  test('IDLE turns new mail in the inbox into an event', () async {
    final server = await _gmailServer([
      Rule(r'^SELECT', selected('INBOX'), repeat: true),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    final live = Completer<void>();
    final events = <MailEvent>[];

    final subscription = backend
        .events(
          ImapBackend.accountId,
          onLiveChanged: (up) {
            if (up && !live.isCompleted) live.complete();
          },
        )
        .listen(events.add);
    await live.future.timeout(const Duration(seconds: 5));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    server.push('* 4 EXISTS');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await subscription.cancel();

    expect(server.commands, contains('IDLE'));
    expect(events.map((e) => (e.type, e.folder)), [
      (MailEventType.newMessage, StandardFolder.inbox),
    ]);
  });

  test('without IDLE, the configured interval is used to poll', () async {
    final server = await ScriptedServer.start(gmailGreeting, [
      Rule(
        r'^LOGIN ',
        '{tag} OK [CAPABILITY IMAP4rev1 UNSELECT NAMESPACE QUOTA] '
            'ada@gmail.com authenticated (Success)',
        repeat: true,
      ),
      Rule(
        r'^CAPABILITY',
        '* CAPABILITY IMAP4rev1 UNSELECT NAMESPACE QUOTA\n{tag} OK done',
        repeat: true,
      ),
      gmailList(),
      Rule(r'^SELECT', selected('INBOX'), repeat: true),
      Rule(r'^NOOP', '{tag} OK NOOP completed', repeat: true),
      _logout(),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    backend.pollInterval = const Duration(milliseconds: 50);

    final subscription = backend.events(ImapBackend.accountId).listen((_) {});
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await subscription.cancel();

    final noops = server.commands.where((c) => c.startsWith('NOOP')).length;
    expect(noops, greaterThanOrEqualTo(2));
  });

  test('live checks can be turned off on a server that offers IDLE', () async {
    final server = await _gmailServer([
      Rule(r'^SELECT', selected('INBOX'), repeat: true),
      Rule(r'^NOOP', '{tag} OK NOOP completed', repeat: true),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    backend
      ..useIdle = false
      ..pollInterval = const Duration(milliseconds: 50);

    final subscription = backend.events(ImapBackend.accountId).listen((_) {});
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await subscription.cancel();

    expect(server.commands, isNot(contains('IDLE')));
    expect(
      server.commands.where((c) => c.startsWith('NOOP')).length,
      greaterThanOrEqualTo(2),
    );
  });

  group('helpers', () {
    test('search criteria', () {
      expect(
        searchCriteria(
          SearchQuery(
            text: 'lunch friday',
            from: 'grace',
            after: DateTime(2026, 10, 1),
            hasAttachment: true,
          ),
        ),
        'UNDELETED TEXT "lunch" TEXT "friday" FROM "grace" SINCE "1-Oct-2026" '
        'HEADER Content-Type "multipart/mixed"',
      );
      expect(
        searchCriteria(const SearchQuery(text: 'Grüße')),
        'CHARSET UTF-8 UNDELETED TEXT "Grüße"',
      );
    });

    test('SMTP replies are handed on whole, however they arrive', () {
      List<int> bytes(String text) => text.codeUnits;
      expect(completeReplies(bytes('250-mx.example\r\n')), 0);
      expect(
        completeReplies(bytes('250-mx.example\r\n250 AUTH PLAIN\r\n')),
        32,
      );
      expect(completeReplies(bytes('235 2.7.0 Accepted\r\n250 OK')), 20);
    });

    test('INTERNALDATE', () {
      expect(
        parseInternalDate('17-Jul-1996 02:44:25 -0700'),
        DateTime.utc(1996, 7, 17, 9, 44, 25).toLocal(),
      );
      expect(
        parseInternalDate(' 1-Feb-2026 00:00:00 +0100'),
        DateTime.utc(2026, 1, 31, 23).toLocal(),
      );
      expect(parseInternalDate('yesterday'), isNull);
    });
  });
}
