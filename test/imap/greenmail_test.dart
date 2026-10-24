import 'dart:io';

import 'package:enough_mail/enough_mail.dart' show ImapException;
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail_api/restmail_api.dart';

/// The backend against a real IMAP and SMTP server: GreenMail, in a
/// container, over IMAPS and SMTPS. CI starts it (see ci.yml); locally:
///
///     docker run --rm -p 3993:3993 -p 3465:3465 \
///       -e GREENMAIL_OPTS='-Dgreenmail.setup.test.all
///         -Dgreenmail.hostname=0.0.0.0
///         -Dgreenmail.users=ada:secret@example.test
///         -Dgreenmail.users.login=email' \
///       greenmail/standalone:2.1.3
///     GREENMAIL_HOST=127.0.0.1 flutter test test/imap/greenmail_test.dart
///
/// Skipped when GREENMAIL_HOST isn't set. GREENMAIL_IMAPS_PORT and
/// GREENMAIL_SMTPS_PORT move it off 3993 and 3465.
void main() {
  final host = Platform.environment['GREENMAIL_HOST'];
  const address = 'ada@example.test';

  // GreenMail's certificate is its own, self-signed. Accepting it here, in a
  // test, is the only place the app's code ever does; the app has no way to.
  Future<Socket> sockets(String h, int port, {required bool tls}) => tls
      ? SecureSocket.connect(h, port, onBadCertificate: (_) => true)
      : Socket.connect(h, port);

  int port(String name, int fallback) =>
      int.tryParse(Platform.environment[name] ?? '') ?? fallback;
  final settings = MailServerSettings(
    imapHost: host ?? '',
    imapPort: port('GREENMAIL_IMAPS_PORT', 3993),
    smtpHost: host ?? '',
    smtpPort: port('GREENMAIL_SMTPS_PORT', 3465),
  );

  ImapBackend backend() => ImapBackend(
    address: address,
    displayName: 'Ada',
    password: 'secret',
    settings: settings,
    openSocket: sockets,
  );

  test(
    'read, send, search, move and delete against GreenMail',
    () async {
      // GreenMail starts with an inbox alone; real servers have the rest.
      final setup = await ImapConnection.open(
        settings,
        address: address,
        password: 'secret',
        openSocket: sockets,
      );
      final existing = await setup.client.listMailboxes(recursive: true);
      for (final name in ['Sent', 'Trash', 'Drafts', 'Archive']) {
        if (!existing.any((b) => b.name == name)) {
          try {
            await setup.client.createMailbox(name);
          } on ImapException {
            // Created; enough_mail just can't find it where it looked.
          }
        }
      }
      await setup.close();

      final mail = backend();
      addTearDown(mail.close);
      await mail.verify();
      final subject = 'Hello ${DateTime.now().microsecondsSinceEpoch}';

      await mail.send(
        OutgoingMessage(
          from: address,
          to: const [address],
          subject: subject,
          bodyText: 'Over SMTPS, back over IMAPS.',
        ),
      );

      Message? arrived;
      for (var i = 0; i < 50 && arrived == null; i++) {
        final page = await mail.messages(
          ImapBackend.accountId,
          StandardFolder.inbox,
        );
        arrived = page.items.where((m) => m.subject == subject).firstOrNull;
        if (arrived == null) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      }
      expect(arrived, isNotNull, reason: 'the message never arrived');
      final folders = await mail.folders(ImapBackend.accountId);
      expect(
        folders.map((f) => f.name),
        containsAll([StandardFolder.inbox, StandardFolder.sent]),
      );
      // Filed in Sent by the app, once.
      final sent = await mail.messages(
        ImapBackend.accountId,
        StandardFolder.sent,
      );
      expect(sent.items.where((m) => m.subject == subject), hasLength(1));

      final full = await mail.message(arrived!.id);
      expect(full.bodyText?.trim(), 'Over SMTPS, back over IMAPS.');

      await mail.updateMessage(arrived.id, isRead: true, isFlagged: true);
      final again = await mail.message(arrived.id);
      expect(again.isRead, isTrue);
      expect(again.isFlagged, isTrue);

      final found = await mail.search(
        ImapBackend.accountId,
        SearchQuery(text: subject.split(' ').last),
      );
      expect(found.items.map((m) => m.subject), contains(subject));

      await mail.updateMessage(arrived.id, folder: StandardFolder.archive);
      final archived = await mail.message(arrived.id);
      expect(archived.folder, StandardFolder.archive);

      await mail.deleteMessage(arrived.id);
      final trashed = await mail.message(arrived.id);
      expect(trashed.folder, StandardFolder.trash);
      await mail.deleteMessage(arrived.id);
      await expectLater(mail.message(arrived.id), throwsA(isA<ApiException>()));

      final draft = await mail.saveDraft(
        const OutgoingMessage(from: address, subject: 'Unfinished'),
      );
      final drafts = await mail.messages(
        ImapBackend.accountId,
        StandardFolder.drafts,
      );
      expect(drafts.items.map((m) => m.id), contains(draft.id));
    },
    skip: host == null ? 'GREENMAIL_HOST is not set' : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'folders are made, renamed and deleted against GreenMail, '
    'and the standard ones are not',
    () async {
      final mail = backend();
      addTearDown(mail.close);
      await mail.verify();
      expect(mail.canManageFolders, isTrue);
      Matcher refused(String code) =>
          throwsA(isA<ApiException>().having((e) => e.code, 'code', code));
      Future<List<String>> names() async => [
        for (final f in await mail.folders(ImapBackend.accountId)) f.name,
      ];
      final stamp = DateTime.now().microsecondsSinceEpoch;

      final made = await mail.createFolder(
        ImapBackend.accountId,
        'Projects$stamp',
      );
      expect(await names(), contains(made));
      await expectLater(
        mail.createFolder(ImapBackend.accountId, 'Projects$stamp'),
        refused('already_exists'),
      );
      await expectLater(
        mail.createFolder(ImapBackend.accountId, 'inbox'),
        refused('already_exists'),
      );

      // The folder on screen is left before it is renamed.
      await mail.messages(ImapBackend.accountId, made);
      final renamed = await mail.renameFolder(
        ImapBackend.accountId,
        made,
        'Done$stamp',
      );
      expect(await names(), allOf(contains(renamed), isNot(contains(made))));
      await expectLater(
        mail.renameFolder(ImapBackend.accountId, renamed, StandardFolder.sent),
        refused('bad_request'),
      );
      await expectLater(
        mail.renameFolder(ImapBackend.accountId, StandardFolder.inbox, 'Old'),
        refused('bad_request'),
      );

      await mail.deleteFolder(ImapBackend.accountId, renamed);
      expect(await names(), isNot(contains(renamed)));
      await expectLater(
        mail.deleteFolder(ImapBackend.accountId, renamed),
        refused('not_found'),
      );
      await expectLater(
        mail.deleteFolder(ImapBackend.accountId, StandardFolder.inbox),
        refused('bad_request'),
      );
    },
    skip: host == null ? 'GREENMAIL_HOST is not set' : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
