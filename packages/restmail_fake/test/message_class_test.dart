import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

void main() {
  for (final value in ['person', 'newsletter', 'receipt', 'notification']) {
    test(
      'serves $value unchanged without classifying fixture content',
      () async {
        final fake = FakeRestmail(scenario: FakeScenario.empty);
        final client = RestmailClient(
          server: Uri.parse('https://${fake.host}'),
          httpClient: fake.client,
        );
        addTearDown(() {
          client.close();
          fake.close();
        });
        await client.login(
          email: FakeAccounts.email,
          password: FakeAccounts.password,
        );
        final account = (await client.accounts()).first.id;
        final stored = fake.deliver(
          to: FakeAccounts.email,
          from: 'person@example.test',
          subject: 'A receipt',
          messageClass: value,
        );
        final raw = await fake.client.get(
          Uri.parse('https://${fake.host}/api/v1/messages/${stored.id}'),
          headers: {'authorization': 'Bearer ${client.tokens!.accessToken}'},
        );
        expect(
          (jsonDecode(raw.body) as Map<String, dynamic>)['data']['class'],
          value,
        );
        expect((await client.message(stored.id)).messageClass, value);
        expect(
          (await client.messages(account, 'INBOX')).items.single.messageClass,
          value,
        );
        expect(
          (await client.search(
            account,
            const SearchQuery(text: 'receipt'),
          )).items.single.messageClass,
          value,
        );
        expect(
          (await client.thread(account, stored.threadId!)).single.messageClass,
          value,
        );
        expect(
          (await client.updateMessage(stored.id, isRead: true)).messageClass,
          value,
        );
      },
    );
  }
}
