import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/state/app_scope.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/mailbox_screen.dart';
import 'package:restmail/util/search_parser.dart';
import 'package:restmail_api/restmail_api.dart';

import 'scripted_server.dart';

// Gmail's own behaviour (rest-mail-mobile#42), against Gmail's answers as
// its IMAP extensions documentation gives them
// (https://developers.google.com/gmail/imap/imap-extensions): X-GM-MSGID,
// X-GM-THRID and X-GM-LABELS in FETCH, STORE ±X-GM-LABELS, and SEARCH
// X-GM-RAW, X-GM-MSGID and X-GM-THRID. Gmail's own labels come quoted with
// the backslash escaped ("\\Important") or bare (\Inbox); both are here.

/// Gmail's folders, with two labels of the user's own.
Rule _list() => Rule(r'^LIST ', r'''* LIST (\HasNoChildren) "/" "INBOX"
* LIST (\HasNoChildren) "/" "Muy Importante"
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

const _lunchThread = '1266894439832287888';
const _lunchId = '1266894439832287888';
const _sentReplyId = '1266894439832287889';
const _replyId = '1266894439832287891';
const _invoiceId = '1278455344230334865';

const _lunchEnvelope =
    '("Wed, 14 Oct 2026 10:15:00 +0100" "Lunch on Friday?" '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Ada Lovelace" NIL "ada" "gmail.com")) NIL NIL NIL '
    '"<lunch-1@example.com>")';
const _sentEnvelope =
    '("Wed, 14 Oct 2026 11:02:00 +0100" "Re: Lunch on Friday?" '
    '(("Ada Lovelace" NIL "ada" "gmail.com")) '
    '(("Ada Lovelace" NIL "ada" "gmail.com")) '
    '(("Ada Lovelace" NIL "ada" "gmail.com")) '
    '(("Grace Hopper" NIL "grace" "example.com")) NIL NIL '
    '"<lunch-1@example.com>" "<lunch-ada@gmail.com>")';
const _replyEnvelope =
    '("Fri, 16 Oct 2026 07:29:58 +0000" "Re: Lunch on Friday?" '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Grace Hopper" NIL "grace" "example.com")) '
    '(("Ada Lovelace" NIL "ada" "gmail.com")) NIL NIL '
    '"<lunch-ada@gmail.com>" "<lunch-2@example.com>")';
const _invoiceEnvelope =
    '("Thu, 15 Oct 2026 18:00:00 +0000" "Invoice October" '
    '(("Billing" NIL "billing" "shop.example")) '
    '(("Billing" NIL "billing" "shop.example")) '
    '(("Billing" NIL "billing" "shop.example")) '
    '((NIL NIL "ada" "gmail.com")) NIL NIL NIL "<inv-10@shop.example>")';
const _text =
    '("TEXT" "PLAIN" ("CHARSET" "UTF-8") NIL NIL "7BIT" 120 4 NIL NIL NIL '
    'NIL)';

/// The inbox: Grace's lunch question and her reply, one conversation, and
/// an invoice labelled Receipts. Gmail leaves the selected folder's own
/// label (\Inbox here) out of X-GM-LABELS.
const _inboxFetch =
    '* 1 FETCH (X-GM-THRID $_lunchThread X-GM-MSGID $_lunchId X-GM-LABELS () '
    'UID 101 FLAGS (\\Seen) INTERNALDATE "14-Oct-2026 09:15:02 +0000" '
    'RFC822.SIZE 2210 ENVELOPE $_lunchEnvelope BODYSTRUCTURE $_text)\n'
    '* 2 FETCH (X-GM-THRID $_invoiceId X-GM-MSGID $_invoiceId '
    'X-GM-LABELS (Receipts) UID 105 FLAGS () '
    'INTERNALDATE "15-Oct-2026 18:00:00 +0000" RFC822.SIZE 900 '
    'ENVELOPE $_invoiceEnvelope BODYSTRUCTURE $_text)\n'
    '* 3 FETCH (X-GM-THRID $_lunchThread X-GM-MSGID $_replyId '
    'X-GM-LABELS ("\\\\Important" "Muy Importante") UID 110 FLAGS () '
    'INTERNALDATE "16-Oct-2026 07:30:00 +0000" RFC822.SIZE 900 '
    'ENVELOPE $_replyEnvelope BODYSTRUCTURE $_text)\n'
    '{tag} OK Success';

/// The lunch conversation as All Mail has it, Ada's own reply included.
const _threadFetch =
    '* 1 FETCH (X-GM-THRID $_lunchThread X-GM-MSGID $_lunchId '
    'X-GM-LABELS (\\Inbox) UID 2001 FLAGS (\\Seen) '
    'INTERNALDATE "14-Oct-2026 09:15:02 +0000" RFC822.SIZE 2210 '
    'ENVELOPE $_lunchEnvelope BODYSTRUCTURE $_text)\n'
    '* 2 FETCH (X-GM-THRID $_lunchThread X-GM-MSGID $_sentReplyId '
    'X-GM-LABELS ("\\\\Sent") UID 2003 FLAGS (\\Seen) '
    'INTERNALDATE "14-Oct-2026 10:02:00 +0000" RFC822.SIZE 1100 '
    'ENVELOPE $_sentEnvelope BODYSTRUCTURE $_text)\n'
    '* 3 FETCH (X-GM-THRID $_lunchThread X-GM-MSGID $_replyId '
    'X-GM-LABELS ("\\\\Important" "\\\\Inbox" "Muy Importante") UID 2010 '
    'FLAGS () INTERNALDATE "16-Oct-2026 07:30:00 +0000" RFC822.SIZE 900 '
    'ENVELOPE $_replyEnvelope BODYSTRUCTURE $_text)\n'
    '{tag} OK Success';

Rule _logout() => Rule(r'^LOGOUT', '* BYE\n{tag} OK Success', repeat: true);

Rule _status() => Rule(
  r'^STATUS',
  '* STATUS "x" (MESSAGES 3 UNSEEN 1)\n{tag} OK Success',
  repeat: true,
);

Future<ScriptedServer> _gmail(List<Rule> more) => ScriptedServer.start(
  gmailGreeting,
  [gmailLogin(), _list(), _logout(), _status(), ...more],
);

ImapBackend _backend(
  ScriptedServer imap, {
  MailServerSettings settings = const MailServerSettings(
    imapHost: 'imap.gmail.com',
    smtpHost: 'smtp.gmail.com',
    filesSentMail: true,
  ),
  String address = 'ada@gmail.com',
}) => ImapBackend(
  address: address,
  displayName: 'Ada Lovelace',
  password: 'abcdabcdabcdabcd',
  settings: settings,
  openSocket: imap.sockets,
);

/// The inbox's first page, the folders listed first as the app does.
Future<List<Message>> _inbox(ImapBackend backend) async {
  await backend.folders(ImapBackend.accountId);
  final page = await backend.messages(
    ImapBackend.accountId,
    StandardFolder.inbox,
  );
  return page.items;
}

List<String> _uidCommands(ScriptedServer server) => [
  for (final c in server.commands)
    if (c.startsWith('UID') || c.startsWith('EXPUNGE')) c,
];

void main() {
  test('Gmail is told by X-GM-EXT-1; its labels are folders that say '
      'so, and each message carries its labels', () async {
    final server = await _gmail([
      Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
      Rule(
        r'^FETCH 1:3 \(UID FLAGS INTERNALDATE RFC822.SIZE ENVELOPE '
        r'BODYSTRUCTURE X-GM-MSGID X-GM-THRID X-GM-LABELS\)',
        _inboxFetch,
      ),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    final printed = <String>[];

    final folders = await runZoned(
      () => backend.folders(ImapBackend.accountId),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => printed.add(line),
      ),
    );
    final messages = await runZoned(
      () => backend.messages(ImapBackend.accountId, StandardFolder.inbox),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => printed.add(line),
      ),
    );

    expect(server.unexpected, isEmpty);
    expect(backend.hasLabels, isTrue);
    expect(backend.groupsThreads, isTrue);
    expect(
      {for (final f in folders) f.name: f.isLabel},
      {
        'INBOX': true,
        'Muy Importante': true,
        'Receipts': true,
        'All Mail': false,
        'Drafts': false,
        'Important': true,
        'Sent': false,
        'Spam': false,
        'Starred': false,
        'Trash': false,
      },
    );
    final [reply, invoice, lunch] = messages.items;
    expect(lunch.labels, [StandardFolder.inbox]);
    expect(invoice.labels, [StandardFolder.inbox, 'Receipts']);
    expect(reply.labels, [StandardFolder.inbox, 'Muy Importante', 'Important']);
    expect(lunch.threadId, _lunchThread);
    expect(reply.threadId, _lunchThread);
    expect(invoice.threadId, _invoiceId);
    // enough_mail would print each X-GM item with the whole answer,
    // subjects and addresses, to the device log.
    expect(printed.where((l) => l.contains('Lunch')), isEmpty);
  });

  test('conversations are grouped by X-GM-THRID, and one opens whole from '
      'All Mail', () async {
    final server = await _gmail([
      Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
      Rule(r'^FETCH 1:3 ', _inboxFetch),
      Rule(
        r'^SELECT "\[Gmail\]/All Mail"',
        selected('All Mail', exists: 4000, validity: 2),
      ),
      Rule(
        '^UID SEARCH X-GM-THRID $_lunchThread\$',
        '* SEARCH 2001 2003 2010\n{tag} OK SEARCH (Success)',
      ),
      Rule(r'^UID FETCH 2001,2003,2010 \(.*X-GM-THRID', _threadFetch),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    final [reply, invoice, lunch] = await _inbox(backend);

    final rows = groupThreads([reply, invoice, lunch]);
    final conversation = await backend.conversation(reply.id);

    expect(server.unexpected, isEmpty);
    expect(rows.map((r) => [for (final m in r) m.id]), [
      [reply.id, lunch.id],
      [invoice.id],
    ]);
    // Oldest first, Ada's reply from Sent among them. The two the inbox
    // shows keep their inbox ids, so acting on them here acts on the list.
    expect(conversation.map((m) => m.subject), [
      'Lunch on Friday?',
      'Re: Lunch on Friday?',
      'Re: Lunch on Friday?',
    ]);
    expect(conversation.map((m) => m.id), [
      lunch.id,
      isNot(anyOf(lunch.id, reply.id, invoice.id)),
      reply.id,
    ]);
    expect(conversation[0].folder, StandardFolder.inbox);
    expect(conversation[1].folder, allMail);
    expect(conversation[1].sender, 'ada@gmail.com');
  });

  test('archive takes the Inbox label off, and Undo puts it back', () async {
    final server = await _gmail([
      Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
      Rule(r'^FETCH 1:3 ', _inboxFetch),
      Rule(
        r'^UID STORE 101 -X-GM-LABELS \(\\Inbox\)$',
        '* 1 FETCH (X-GM-LABELS () UID 101)\n{tag} OK Success',
      ),
      Rule(
        r'^SELECT "\[Gmail\]/All Mail"',
        selected('All Mail', exists: 4000, validity: 2),
        repeat: true,
      ),
      Rule(
        '^UID SEARCH X-GM-MSGID $_lunchId\$',
        '* SEARCH 2001\n{tag} OK SEARCH (Success)',
      ),
      Rule(
        r'^UID STORE 2001 \+X-GM-LABELS \(\\Inbox\)$',
        '* 1 FETCH (X-GM-LABELS (\\Inbox) UID 2001)\n{tag} OK Success',
      ),
      // Back in the inbox under a new UID, as IMAP has it.
      Rule(
        '^UID SEARCH X-GM-MSGID $_lunchId\$',
        '* SEARCH 121\n{tag} OK SEARCH (Success)',
      ),
      Rule(r'^UID STORE 121 \+FLAGS.SILENT \(\\Flagged\)$', '{tag} OK Success'),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    final lunch = (await _inbox(backend)).last;

    final archived = await backend.updateMessage(
      lunch.id,
      folder: StandardFolder.archive,
    );
    final back = await backend.updateMessage(
      lunch.id,
      folder: StandardFolder.inbox,
    );
    // Star is \Flagged, on the message back in the inbox.
    await backend.updateMessage(lunch.id, isFlagged: true);

    expect(server.unexpected, isEmpty);
    expect(archived.folder, allMail);
    expect(archived.labels, isEmpty);
    expect(back.id, lunch.id);
    expect(back.folder, StandardFolder.inbox);
    // Nothing is moved or expunged, which in All Mail could delete it.
    expect(_uidCommands(server), [
      r'UID STORE 101 -X-GM-LABELS (\Inbox)',
      'UID SEARCH X-GM-MSGID $_lunchId',
      r'UID STORE 2001 +X-GM-LABELS (\Inbox)',
      'UID SEARCH X-GM-MSGID $_lunchId',
      r'UID STORE 121 +FLAGS.SILENT (\Flagged)',
    ]);
  });

  test('labels go on and come off with STORE X-GM-LABELS, Important '
      'among them', () async {
    final server = await _gmail([
      Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
      Rule(r'^FETCH 1:3 ', _inboxFetch),
      Rule(
        r'^UID STORE 105 \+X-GM-LABELS \("Muy Importante" \\Important\)$',
        '* 2 FETCH (X-GM-LABELS ("\\\\Important" "Muy Importante" Receipts) '
            'UID 105)\n{tag} OK Success',
      ),
      Rule(
        r'^UID STORE 105 -X-GM-LABELS \("Receipts"\)$',
        '* 2 FETCH (X-GM-LABELS ("\\\\Important" "Muy Importante") UID 105)\n'
            '{tag} OK Success',
      ),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);
    final invoice = (await _inbox(backend))[1];

    final changed = await backend.updateLabels(
      invoice.id,
      add: {'Muy Importante', gmailImportant},
      remove: {'Receipts'},
    );

    expect(server.unexpected, isEmpty);
    expect(changed.id, invoice.id);
    expect(changed.folder, StandardFolder.inbox);
    expect(changed.labels, [
      StandardFolder.inbox,
      'Muy Importante',
      gmailImportant,
    ]);
  });

  test('search speaks Gmail: X-GM-RAW in All Mail, and a message found '
      'there is deleted by putting it in Trash', () async {
    final server = await _gmail([
      Rule(
        r'^SELECT "\[Gmail\]/All Mail"',
        selected('All Mail', exists: 4000, validity: 2),
        repeat: true,
      ),
      Rule(
        r'^UID SEARCH X-GM-RAW "from:grace has:attachment older_than:1y"$',
        '* SEARCH 2010\n{tag} OK SEARCH (Success)',
      ),
      Rule(
        r'^UID FETCH 2010 ',
        '${_threadFetch.split('\n')[2]}\n{tag} OK Success',
      ),
      Rule(
        r'^UID STORE 2010 \+X-GM-LABELS \(\\Trash\)$',
        '* 3 FETCH (X-GM-LABELS () UID 2010)\n{tag} OK Success',
      ),
      Rule(
        r'^SELECT "\[Gmail\]/Trash"',
        selected('Trash', validity: 7),
        repeat: true,
      ),
      Rule(
        '^UID SEARCH X-GM-MSGID $_replyId\$',
        '* SEARCH 34\n{tag} OK SEARCH (Success)',
      ),
      Rule(
        r'^UID SEARCH X-GM-RAW "in:trash lunch"$',
        '* SEARCH\n{tag} OK SEARCH (Success)',
      ),
    ]);
    addTearDown(server.close);
    final backend = _backend(server);
    addTearDown(backend.close);

    final found = await backend.search(
      ImapBackend.accountId,
      parseSearch('from:grace has:attachment older_than:1y'),
    );
    await backend.deleteMessage(found.items.single.id);
    final inTrash = await backend.search(
      ImapBackend.accountId,
      parseSearch('in:trash lunch'),
    );

    expect(server.unexpected, isEmpty);
    expect(found.items.single.folder, allMail);
    expect(found.items.single.labels, [
      StandardFolder.inbox,
      'Muy Importante',
      gmailImportant,
    ]);
    expect(inTrash.items, isEmpty);
    expect(
      server.commands.where((c) => c.startsWith('SELECT')).last,
      'SELECT "[Gmail]/Trash"',
    );
    expect(_uidCommands(server), [
      'UID SEARCH X-GM-RAW "from:grace has:attachment older_than:1y"',
      startsWith('UID FETCH 2010 '),
      r'UID STORE 2010 +X-GM-LABELS (\Trash)',
      'UID SEARCH X-GM-MSGID $_replyId',
      'UID SEARCH X-GM-RAW "in:trash lunch"',
    ]);
  });

  test('Gmail set up by hand (Google Workspace) is still Gmail: sent mail '
      'is never appended to Sent', () async {
    final smtp = await ScriptedServer.start('220 smtp.gmail.com ESMTP', [
      Rule(
        r'^EHLO',
        '250-smtp.gmail.com at your service\n250-AUTH LOGIN PLAIN\n'
            '250 SMTPUTF8',
        repeat: true,
      ),
      Rule(r'^AUTH PLAIN', '235 2.7.0 Accepted'),
      Rule(r'^MAIL FROM', '250 2.1.0 OK'),
      Rule(r'^RCPT TO', '250 2.1.5 OK', repeat: true),
      Rule(r'^DATA', '354 Go ahead'),
      Rule(r'^\.$', '250 2.0.0 OK queued'),
      Rule(r'^QUIT', '221 2.0.0 closing connection'),
    ], smtp: true);
    final imap = await _gmail([]);
    addTearDown(smtp.close);
    addTearDown(imap.close);
    final backend = ImapBackend(
      address: 'ada@analytical.example',
      displayName: 'Ada Lovelace',
      password: 'abcdabcdabcdabcd',
      // No preset: entered by hand, so nothing says it files sent mail.
      settings: const MailServerSettings(
        imapHost: 'imap.gmail.com',
        smtpHost: 'smtp.gmail.com',
      ),
      openSocket: (host, port, {required tls}) =>
          (host.startsWith('smtp') ? smtp : imap).sockets(host, port, tls: tls),
    );
    addTearDown(backend.close);

    final sent = await backend.send(
      const OutgoingMessage(
        from: 'ada@analytical.example',
        to: ['grace@example.com'],
        subject: 'Hi',
        bodyText: 'Hello',
      ),
    );

    expect(smtp.commands, contains('.'));
    expect(imap.unexpected, isEmpty);
    expect(imap.commands.where((c) => c.startsWith('APPEND')), isEmpty);
    expect(imap.commands.where((c) => c.contains('SEARCH')), isEmpty);
    expect(sent.folder, StandardFolder.sent);
  });

  testWidgets('the inbox shows a conversation as one row; opened, a '
      'message shows its labels and the rest of its conversation', (
    tester,
  ) async {
    const body =
        'From: Grace Hopper <grace@example.com>\r\n'
        'Subject: Re: Lunch on Friday?\r\n'
        'Message-ID: <lunch-2@example.com>\r\n'
        'Content-Type: text/plain; charset=UTF-8\r\n'
        '\r\n'
        'One it is, then.\r\n';
    final server = (await tester.runAsync(
      () => _gmail([
        Rule(r'^SELECT "?INBOX', selected('INBOX'), repeat: true),
        Rule(r'^FETCH 1:3 ', _inboxFetch, repeat: true),
        Rule(
          r'^UID FETCH 110 \(.*X-GM-LABELS\)$',
          '${_inboxFetch.split('\n')[2]}\n{tag} OK Success',
        ),
        Rule(
          r'^UID FETCH 110 .*BODY.PEEK\[\]',
          '* 3 FETCH (UID 110 FLAGS () BODY[] {${body.length}}\n'
              '$body)\n{tag} OK Success',
        ),
        Rule(r'^UID STORE 110 \+FLAGS.SILENT \(\\Seen\)$', '{tag} OK Success'),
        Rule(
          r'^SELECT "\[Gmail\]/All Mail"',
          selected('All Mail', exists: 4000, validity: 2),
        ),
        Rule(
          '^UID SEARCH X-GM-THRID $_lunchThread\$',
          '* SEARCH 2001 2003 2010\n{tag} OK SEARCH (Success)',
        ),
        Rule(r'^UID FETCH 2001,2003,2010 ', _threadFetch),
      ]),
    ))!;
    // Real sockets, so made, started and shut down outside the test's fake
    // time: futures made in it wait for a pump.
    final backend = (await tester.runAsync(() async => _backend(server)))!;
    final mailbox = MailboxState(backend);
    await tester.runAsync(mailbox.start);
    try {
      // Real sockets: let them answer, then draw what they said.
      Future<void> settle() async {
        for (var i = 0; i < 12; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 25)),
          );
          await tester.pump();
        }
      }

      // The screen asks the app which account is on screen; none is.
      final app = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => MockClient((_) => throw UnimplementedError()),
      );
      addTearDown(app.dispose);
      await tester.pumpWidget(
        AppScope(
          state: app,
          child: MaterialApp(
            theme: buildTheme(Brightness.light),
            home: MailboxScreen(mailbox: mailbox),
          ),
        ),
      );
      await settle();

      // Grace's question and her reply are one row, with a count.
      expect(find.text('Grace Hopper'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Lunch on Friday?'), findsNothing);
      await tester.tap(find.text('Re: Lunch on Friday?'));
      await settle();
      await tester.pumpAndSettle();

      expect(
        find.textContaining('One it is, then.', findRichText: true),
        findsOneWidget,
      );
      for (final label in ['Inbox', 'Muy Importante', 'Important']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.byTooltip('Archive'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('3 MESSAGES IN THIS CONVERSATION'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Lunch on Friday?'), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsOneWidget);
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      expect(find.text('Star'), findsOneWidget);
      expect(find.text('Labels…'), findsOneWidget);
      expect(server.unexpected, isEmpty);
    } finally {
      await tester.pumpWidget(const SizedBox());
      // enough_mail leaves each command's response timeout running after
      // the answer; in fake time they must run out before the test ends.
      await tester.pump(const Duration(minutes: 2));
      mailbox.dispose();
      await tester.runAsync(() async {
        await backend.close();
        await server.close();
      });
    }
  });

  test('X-GM-RAW criteria: UTF-8 says so', () {
    expect(
      gmailSearchCriteria('label:receipts "Grüße"'),
      r'CHARSET UTF-8 X-GM-RAW "label:receipts \"Grüße\""',
    );
    expect(parseSearch(' in:sent lunch ').raw, 'in:sent lunch');
  });
}
