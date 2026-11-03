@TestOn('vm')
library;

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

import 'live_server.dart';

void main() {
  test(
    'real deliveries are sealed, editable drafts are not',
    () async {
      final admin = await LiveAdmin.setUp();
      addTearDown(admin.client.close);
      final client = admin.client;
      final outgoing = OutgoingMessage(
        from: liveEmail,
        to: [liveEmail],
        subject: 'Receipt seal integration',
        bodyText: 'Accepted source and displayed body',
      );
      final draft = await client.saveDraft(outgoing);
      final unsealed = await client.verifyMessageSeal(draft.id);
      expect(unsealed.state, MessageSealState.notSealed);
      expect(unsealed.sealedHash, isNull);
      final sent = await client.send(outgoing);
      expect(sent.sealedHash, matches(RegExp(r'^[0-9a-f]{64}$')));
      final seal = await client.verifyMessageSeal(sent.id);
      expect(seal.state, MessageSealState.intact);
      expect(seal.sealedHash, sent.sealedHash);
      expect(seal.computedHash, sent.sealedHash);
      await client.updateMessage(sent.id, isRead: true, isFlagged: true);
      expect(
        (await client.verifyMessageSeal(sent.id)).state,
        MessageSealState.intact,
      );
      expect((await client.message(sent.id)).sealedHash, sent.sealedHash);
    },
    skip: skipLive,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
