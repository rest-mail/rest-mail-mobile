import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

Future<(RestmailClient, int)> _login(FakeRestmail fake, String email) async {
  final client = RestmailClient(
    server: Uri.parse('https://${FakeAccounts.host}'),
    httpClient: fake.client,
  );
  final result = await client.login(
    email: email,
    password: email == FakeAccounts.adminEmail
        ? FakeAccounts.adminPassword
        : FakeAccounts.password,
    totpCode: FakeAccounts.totpCode,
  );
  return (client, result.user.id);
}

void main() {
  test(
    'the sample account holds two messages, newest first, with reasons',
    () async {
      final fake = FakeRestmail();
      final (client, id) = await _login(fake, FakeAccounts.email);
      final page = await client.quarantine(id);
      expect(page.total, 2);
      expect(page.items.map((m) => m.reason), [
        'spam_threshold',
        'dmarc_quarantine',
      ]);
      expect(page.items.first.sender, 'prizes@winner.test');
      expect(page.items.first.spamScore, 9.4);
      expect(
        page.items.first.expiresAt!.isAfter(page.items.first.receivedAt!),
        isTrue,
      );
    },
  );

  test('release delivers to the inbox and leaves the list', () async {
    final fake = FakeRestmail();
    final (client, id) = await _login(fake, FakeAccounts.email);
    final held = (await client.quarantine(id)).items.first;
    final messageId = await client.releaseQuarantined(id, held.id);
    final message = await client.message(messageId);
    expect(message.folder, 'INBOX');
    expect(message.subject, held.subject);
    expect(
      (await client.quarantine(id)).items.map((m) => m.id),
      isNot(contains(held.id)),
    );
    expect(fake.quarantined.map((row) => row['id']), isNot(contains(held.id)));
  });

  test('delete removes it for good, and a second delete is 404', () async {
    final fake = FakeRestmail();
    final (client, id) = await _login(fake, FakeAccounts.email);
    final held = (await client.quarantine(id)).items.last;
    await client.deleteQuarantined(id, held.id);
    expect((await client.quarantine(id)).total, 1);
    await expectLater(
      client.deleteQuarantined(id, held.id),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
  });

  test("another account's held message is not found from this one", () async {
    final fake = FakeRestmail();
    final other = fake.hold(
      FakeAccounts.otherEmail,
      sender: 'x@spam.test',
      subject: 'Not yours',
    );
    final (client, id) = await _login(fake, FakeAccounts.email);
    await expectLater(
      client.releaseQuarantined(id, other),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
    await expectLater(
      client.deleteQuarantined(id, other),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
    );
  });

  test('the list pages', () async {
    final fake = FakeRestmail();
    for (var i = 0; i < 3; i++) {
      fake.hold(
        FakeAccounts.email,
        sender: 's$i@spam.test',
        age: Duration(days: 2 + i),
      );
    }
    final (client, id) = await _login(fake, FakeAccounts.email);
    final first = await client.quarantine(id, limit: 2);
    expect(first.items, hasLength(2));
    expect(first.total, 5);
    final rest = await client.quarantine(id, offset: 4, limit: 2);
    expect(rest.items.single.sender, 's2@spam.test');
  });
}
