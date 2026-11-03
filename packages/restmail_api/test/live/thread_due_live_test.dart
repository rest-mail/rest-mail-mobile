@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

void main() {
  test(
    'real thread dates can be set, replaced, projected and cleared without filing',
    () async {
      final admin = await LiveAdmin.setUp();
      final client = admin.client;
      addTearDown(client.close);
      final account = (await client.accounts()).first;
      final message = await client.send(
        OutgoingMessage(
          from: account.address,
          to: [account.address],
          subject: 'Thread due integration',
          bodyText: 'No filing or message changes',
        ),
      );
      addTearDown(() => client.deleteMessage(message.id));
      expect(message.threadId, isNotNull);
      for (final date in [
        DateTime.utc(2026, 12, 1, 10),
        DateTime.utc(2026, 12, 2, 11),
      ]) {
        final saved = await client.setThreadDue(
          account.id,
          message.threadId!,
          date,
        );
        expect(saved.due, date);
        expect(saved.source, 'user');
        final full = await client.message(message.id);
        expect(full.due, date);
        expect(full.dueSource, 'user');
        expect(full.folder, message.folder);
        expect(full.bodyText, message.bodyText);
        expect(
          (await client.thread(
            account.id,
            message.threadId!,
          )).every((item) => item.due == date),
          isTrue,
        );
      }
      await client.setThreadDue(account.id, message.threadId!, null);
      final cleared = await client.message(message.id);
      expect(cleared.due, isNull);
      expect(cleared.dueSource, isNull);
    },
    skip: skipLive,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
