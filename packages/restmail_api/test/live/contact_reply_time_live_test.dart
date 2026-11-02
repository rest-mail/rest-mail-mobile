// The contact reply-time setting against a real server
// (tool/ci/live_server.sh): the generated route, off by default, saved, and no
// estimate for a contact the account's mail says nothing about.
@TestOn('vm')
library;

import 'package:test/test.dart';

import 'live_server.dart';

void main() {
  test(
    'the setting starts off, stays as changed, and invents no estimate',
    () async {
      final admin = await LiveAdmin.setUp();
      addTearDown(admin.client.close);
      final client = admin.client;
      final account = (await client.accounts()).first.id;

      expect(await client.contactReplyTimeEnabled(account), isFalse);
      expect(await client.setContactReplyTimeEnabled(account, true), isTrue);
      expect(await client.contactReplyTimeEnabled(account), isTrue);

      final contact = await client.createContact(
        account,
        email: 'reply-time@live.test',
      );
      addTearDown(() => client.deleteContact(account, contact.id));
      final page = await client.contacts(
        account,
        search: 'reply-time@live.test',
      );
      expect(page.items.single.usualReplySeconds, isNull);

      expect(await client.setContactReplyTimeEnabled(account, false), isFalse);
      expect(await client.contactReplyTimeEnabled(account), isFalse);
    },
    skip: skipLive,
  );
}
