import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

/// GET /api/v1/messages/{id}/raw, as REST Mail answers it.
void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  test('a message without a kept source has one made from its fields', () async {
    final message = fake.deliver(
      to: FakeAccounts.email,
      from: 'ada@example.test',
      fromName: 'Ada',
      subject: 'Engines',
      body: 'First line\nSecond line',
    );
    final source = utf8.decode(await client.rawMessage(message.id));
    final lines = source.split('\r\n');
    expect(lines.first, 'From: Ada <ada@example.test>');
    expect(lines, contains('Subject: Engines'));
    expect(lines, contains('Message-ID: ${message.messageId}'));
    expect(
      lines.where((l) => l.startsWith('Date: ')).single,
      matches(
        RegExp(r'^Date: \w{3}, \d{1,2} \w{3} \d{4} \d\d:\d\d:\d\d \+0000$'),
      ),
    );
    // The header ends at the first empty line; the body follows, line by line.
    final blank = lines.indexOf('');
    expect(lines.sublist(blank + 1), ['First line', 'Second line']);
  });

  test('a kept source is served byte for byte', () async {
    final message = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@b.test',
      subject: 'x',
    )..raw = 'Subject: as it came\r\n\r\nbody';
    expect(
      utf8.decode(await client.rawMessage(message.id)),
      'Subject: as it came\r\n\r\nbody',
    );
  });

  test('refusals are the server\'s', () async {
    final none = fake.deliver(
      to: FakeAccounts.email,
      from: 'a@b.test',
      subject: 'x',
    )..raw = '';
    await expectLater(client.rawMessage(none.id), _refused(404, 'not_found'));
    await expectLater(
      client.rawMessage(999999),
      _refused(404, 'message_not_found'),
    );
    fake.addAccount('other@restmail.test');
    final theirs = fake.deliver(
      to: 'other@restmail.test',
      from: 'a@b.test',
      subject: 'x',
    );
    await expectLater(client.rawMessage(theirs.id), _refused(403, 'forbidden'));
  });
}
