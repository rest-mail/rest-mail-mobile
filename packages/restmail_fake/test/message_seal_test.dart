import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late FakeMessage message;

  setUp(() async {
    fake = FakeRestmail();
    message = fake.messagesIn(FakeAccounts.email, 'INBOX').first;
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

  test('pre-seal deliveries have no seal, not a mismatch', () async {
    message.sealMismatch = true;
    expect((await client.message(message.id)).sealedHash, isNull);
    final seal = await client.verifyMessageSeal(message.id);
    expect(seal.state, MessageSealState.notSealed);
    expect(seal.sealedHash, isNull);
    expect(seal.computedHash, isNull);
    expect(message.sealedHash, isNull);
  });

  test(
    'seeded verdicts and stored authentication reach the generated client',
    () async {
      message
        ..sealedHash = 'a' * 64
        ..authResults = [
          {'method': 'dkim', 'result': 'pass', 'domain': 'example.test'},
        ];
      final full = await client.message(message.id);
      expect(full.sealedHash, 'a' * 64);
      expect(full.authResults.single.method, 'dkim');
      expect(
        (await client.verifyMessageSeal(message.id)).state,
        MessageSealState.intact,
      );
      await client.updateMessage(message.id, isRead: true, isFlagged: true);
      expect(
        (await client.verifyMessageSeal(message.id)).state,
        MessageSealState.intact,
      );
      message.sealMismatch = true;
      final seal = await client.verifyMessageSeal(message.id);
      expect(seal.state, MessageSealState.mismatch);
      expect(seal.sealedHash, 'a' * 64);
      expect(seal.computedHash, isNot(seal.sealedHash));
    },
  );

  test('another account and an unknown message cannot be verified', () async {
    final other = fake.deliver(
      to: FakeAccounts.adminEmail,
      from: FakeAccounts.email,
      subject: 'Other account',
      body: 'Other',
    );
    for (final id in [other.id, 999999]) {
      await expectLater(
        client.verifyMessageSeal(id),
        throwsA(
          isA<ApiException>().having(
            (error) => error.statusCode,
            'status',
            404,
          ),
        ),
      );
    }
  });
}
