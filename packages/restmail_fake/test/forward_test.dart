import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Matcher _refused(int status, String code) => throwsA(
  isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code),
);

/// POST /api/v1/messages/{id}/forward, as REST Mail answers it.
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

  test('a forward reaches the recipient and lands in Sent', () async {
    // Mail between the fake's own mailboxes is delivered; Bob's is one.
    fake.addAccount('bob@restmail.test');
    final message = fake.deliver(
      to: FakeAccounts.email,
      from: 'ada@example.test',
      fromName: 'Ada',
      subject: 'Engines',
      body: 'First line\nSecond line',
    );
    final forwarded = await client.forwardMessage(
      message.id,
      from: FakeAccounts.email,
      to: ['bob@restmail.test'],
      bodyText: 'See below.',
    );
    expect(forwarded.folder, StandardFolder.sent);
    expect(forwarded.subject, 'Fwd: Engines');
    expect(forwarded.to.single.address, 'bob@restmail.test');
    expect(forwarded.bodyText, contains('See below.'));
    expect(forwarded.bodyText, contains('First line\nSecond line'));
    expect(
      fake
          .messagesIn(FakeAccounts.email, 'Sent')
          .where((m) => m.subject == 'Fwd: Engines'),
      hasLength(1),
    );
    expect(
      fake
          .messagesIn('bob@restmail.test', 'INBOX')
          .where((m) => m.subject == 'Fwd: Engines'),
      hasLength(1),
    );
  });

  test('a forward refuses an unknown message', () async {
    await expectLater(
      client.forwardMessage(
        999999,
        from: FakeAccounts.email,
        to: ['bob@restmail.test'],
      ),
      _refused(404, 'message_not_found'),
    );
  });
}
