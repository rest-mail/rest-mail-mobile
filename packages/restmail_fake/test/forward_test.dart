import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late Account account;
  Future<void> open({
    int maxBytes = 10 * 1024 * 1024,
    bool discard = false,
  }) async {
    fake = FakeRestmail(
      scenario: FakeScenario.empty,
      maxForwardMessageBytes: maxBytes,
      discardForwards: discard,
    );
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    account = (await client.accounts()).firstWhere((a) => a.isPrimary);
    addTearDown(() {
      client.close();
      fake.close();
    });
  }

  FakeMessage original() => fake.deliver(
    to: FakeAccounts.email,
    from: 'ada@example.test',
    subject: 'receipt',
    body: 'original receipt',
    attachments: [
      FakeAttachment(
        filename: 'invoice.bin',
        contentType: 'application/octet-stream',
        bytes: [0, 255, 10, 42],
      ),
      FakeAttachment(
        filename: 'empty.txt',
        contentType: 'text/plain',
        bytes: [],
      ),
      FakeAttachment(
        filename: 'image.png',
        contentType: 'image/png',
        bytes: [1, 2, 3],
        disposition: 'inline',
        contentId: 'original-image',
      ),
    ],
  )..bodyHtml = '<p>original receipt<img src="cid:original-image"></p>';

  test(
    'copies binary, empty and inline parts into independent Sent and local messages',
    () async {
      await open();
      final source = original();
      final result = await client.forwardMessage(
        source.id,
        from: account.address,
        to: [account.address, 'external@example.test'],
        bodyText: 'Please review <this>',
      );
      final sent = (result as ForwardSent).message;
      expect(sent.folder, 'Sent');
      expect(sent.hasAttachments, isTrue);
      expect(sent.subject, 'Fwd: receipt');
      expect(
        sent.bodyText,
        startsWith(
          'Please review <this>\n\n---------- Forwarded message ----------\nFrom: ada@example.test\nSubject: receipt\n\n',
        ),
      );
      expect(sent.bodyHtml, contains('Please review &lt;this&gt;'));
      expect(source.bodyText, 'original receipt');
      expect(source.isRead, isFalse);
      final sentParts = await client.attachments(sent.id);
      expect(sentParts, hasLength(3));
      final inbox = (await client.messages(
        account.id,
        StandardFolder.inbox,
      )).items;
      final local = inbox.singleWhere((m) => m.id != source.id);
      expect(local.messageId, sent.messageId);
      final localParts = await client.attachments(local.id);
      expect(localParts, hasLength(3));
      expect({
        ...sentParts.map((p) => p.id),
        ...localParts.map((p) => p.id),
        ...source.attachments.map((p) => p.id),
      }, hasLength(9));
      final raw = utf8.decode(await client.rawMessage(sent.id));
      expect(raw, contains('Content-ID: <original-image>'));
      expect(
        raw,
        contains('Content-Disposition: inline; filename="image.png"'),
      );
      expect(raw, contains(base64.encode([0, 255, 10, 42])));
      expect(raw, contains('filename="empty.txt"'));
      expect(utf8.decode(await client.rawMessage(local.id)), raw);
      // Deleting either stored message cannot make another copy unreadable.
      await client.deleteMessage(source.id);
      await client.deleteMessage(source.id);
      for (final parts in [sentParts, localParts]) {
        expect(
          await client.downloadAttachment(
            parts.singleWhere((p) => p.filename == 'invoice.bin').id,
          ),
          [0, 255, 10, 42],
        );
        expect(
          await client.downloadAttachment(
            parts.singleWhere((p) => p.filename == 'empty.txt').id,
          ),
          isEmpty,
        );
      }
      await client.deleteMessage(sent.id);
      await client.deleteMessage(sent.id);
      expect(
        await client.downloadAttachment(
          localParts.singleWhere((p) => p.filename == 'image.png').id,
        ),
        [1, 2, 3],
      );
    },
  );

  test(
    'MIME wraps long body and attachment base64 without changing bytes',
    () async {
      await open();
      final bytes = List<int>.generate(512, (index) => index % 256);
      final source = fake.deliver(
        to: FakeAccounts.email,
        from: 'ada@example.test',
        subject: 'long parts',
        body: 'original receipt',
        attachments: [
          FakeAttachment(
            filename: 'long.bin',
            contentType: 'application/octet-stream',
            bytes: bytes,
          ),
        ],
      );
      final note = List<String>.filled(80, 'review').join(' ');
      final result = await client.forwardMessage(
        source.id,
        from: account.address,
        to: ['external@example.test'],
        bodyText: note,
      );
      final sent = (result as ForwardSent).message;
      final raw = utf8.decode(await client.rawMessage(sent.id));
      final blocks = raw
          .split('Content-Transfer-Encoding: base64\r\n\r\n')
          .skip(1)
          .map((part) => part.split('\r\n--').first)
          .toList();
      expect(blocks, hasLength(2));
      for (final block in blocks) {
        expect(
          block.split('\r\n'),
          everyElement(hasLength(lessThanOrEqualTo(76))),
        );
      }
      expect(
        utf8.decode(base64.decode(blocks.first.replaceAll('\r\n', ''))),
        sent.bodyText,
      );
      expect(sent.bodyText, startsWith('$note\n\n'));
      expect(base64.decode(blocks.last.replaceAll('\r\n', '')), bytes);
    },
  );

  test('refreshes an expired session before one successful forward', () async {
    await open();
    final source = original();
    final old = client.tokens!.accessToken;
    fake.expireAccessTokens();
    await client.forwardMessage(
      source.id,
      from: account.address,
      to: ['external@example.test'],
    );
    expect(client.tokens!.accessToken, isNot(old));
    expect(
      (await client.messages(account.id, StandardFolder.sent)).items,
      hasLength(1),
    );
  });

  test(
    'body cap includes serialized MIME and base64 overhead, with no partial copy',
    () async {
      await open(maxBytes: 400);
      final source = original();
      await expectLater(
        client.forwardMessage(
          source.id,
          from: account.address,
          to: ['external@example.test'],
        ),
        _refused(413, 'message_too_large'),
      );
      expect(
        (await client.messages(account.id, StandardFolder.sent)).items,
        isEmpty,
      );
      expect(await client.attachments(source.id), hasLength(3));
    },
  );

  test('sender quota refuses all copies atomically', () async {
    await open();
    final source = original();
    final admin = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    addTearDown(admin.close);
    await admin.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await admin.updateMailbox(account.id, quotaBytes: 1);
    await expectLater(
      client.forwardMessage(
        source.id,
        from: account.address,
        to: [account.address],
      ),
      _refused(422, 'mailbox_full'),
    );
    expect(
      (await client.messages(account.id, StandardFolder.sent)).items,
      isEmpty,
    );
    expect(
      (await client.messages(account.id, StandardFolder.inbox)).items,
      hasLength(1),
    );
  });

  test('policy discard stores and delivers nothing', () async {
    await open(discard: true);
    final source = original();
    expect(
      await client.forwardMessage(
        source.id,
        from: account.address,
        to: [account.address],
      ),
      isA<ForwardDiscarded>(),
    );
    expect(
      (await client.messages(account.id, StandardFolder.sent)).items,
      isEmpty,
    );
    expect(
      (await client.messages(account.id, StandardFolder.inbox)).items,
      hasLength(1),
    );
  });

  test(
    'source access, sender access and required fields keep their refusals',
    () async {
      await open();
      final source = original();
      fake.addAccount('stranger@restmail.test');
      final theirs = fake.deliver(
        to: 'stranger@restmail.test',
        from: 'ada@example.test',
        subject: 'private',
      );
      await expectLater(
        client.forwardMessage(
          theirs.id,
          from: account.address,
          to: ['external@example.test'],
        ),
        _refused(403, 'forbidden'),
      );
      await expectLater(
        client.forwardMessage(
          999999,
          from: account.address,
          to: ['external@example.test'],
        ),
        _refused(404, 'message_not_found'),
      );
      await expectLater(
        client.forwardMessage(
          source.id,
          from: 'stranger@restmail.test',
          to: ['external@example.test'],
        ),
        _refused(403, 'forbidden'),
      );
      await expectLater(
        client.forwardMessage(source.id, from: account.address, to: []),
        _refused(400, 'bad_request'),
      );
      expect(
        (await client.messages(account.id, StandardFolder.sent)).items,
        isEmpty,
      );
    },
  );
}
