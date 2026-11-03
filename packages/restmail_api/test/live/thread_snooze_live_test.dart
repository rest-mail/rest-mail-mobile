@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

void main() {
  test(
    'a thread leaves its folder, stays findable and comes back on cancel',
    () async {
      final admin = await LiveAdmin.setUp();
      addTearDown(admin.client.close);
      final client = admin.client;
      final account = (await client.accounts()).first;
      final subject = 'Snooze integration ${DateTime.now().toIso8601String()}';
      final sent = await client.send(
        OutgoingMessage(
          from: liveEmail,
          to: [liveEmail],
          subject: subject,
          bodyText: 'Hidden, not deleted',
        ),
      );
      final thread = sent.threadId!;
      final folder = sent.folder;

      Future<bool> listed() async {
        final page = await client.messages(account.id, folder);
        return page.items.any((m) => m.id == sent.id);
      }

      expect(await listed(), isTrue);
      final events = <MailEvent>[];
      final stream = client.events(account.id).listen(events.add);
      addTearDown(stream.cancel);

      final deadline = DateTime.now().toUtc().add(const Duration(hours: 1));
      final stored = await client.snoozeThread(account.id, thread, deadline);
      expect(stored.threadId, thread);
      expect(
        stored.snoozedUntil!.difference(deadline).inSeconds.abs(),
        lessThan(2),
      );
      expect(await listed(), isFalse);
      final read = await client.message(sent.id);
      expect(read.snoozedUntil, isNotNull);
      final found = await client.search(account.id, SearchQuery(text: subject));
      expect(found.items.map((m) => m.id), contains(sent.id));
      expect(
        found.items.firstWhere((m) => m.id == sent.id).snoozedUntil,
        isNotNull,
      );

      await expectLater(
        client.snoozeThread(account.id, thread, DateTime.utc(2000)),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 422)
              .having(
                (e) => e.fields['snoozed_until'],
                'field',
                'must be in the future',
              ),
        ),
      );
      await expectLater(
        client.snoozeThread(account.id, 'no-such-thread', deadline),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );

      final cancelled = await client.snoozeThread(account.id, thread, null);
      expect(cancelled.snoozedUntil, isNull);
      expect(await listed(), isTrue);
      expect((await client.message(sent.id)).snoozedUntil, isNull);

      // The worker returns a due thread within 30 seconds, and says so on the
      // stream, so a second device needs no refresh.
      await client.snoozeThread(
        account.id,
        thread,
        DateTime.now().toUtc().add(const Duration(seconds: 2)),
      );
      expect(await listed(), isFalse);
      events.clear();
      final back = DateTime.now().add(const Duration(seconds: 60));
      ThreadSnooze? returned;
      while (returned == null && DateTime.now().isBefore(back)) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        returned = events
            .map((event) => event.threadSnooze)
            .where(
              (snooze) =>
                  snooze?.threadId == thread && snooze?.snoozedUntil == null,
            )
            .firstOrNull;
      }
      expect(returned, isNotNull, reason: 'the stream announces the return');
      expect(returned!.mailboxId, account.id);
      expect(await listed(), isTrue);
      expect((await client.message(sent.id)).snoozedUntil, isNull);
    },
    skip: skipLive,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
