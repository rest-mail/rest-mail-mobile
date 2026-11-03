import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/state/mail_backend.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

class _Backend extends RestBackend {
  _Backend(super.client);

  Completer<Paged<Message>>? pending;
  final cursors = <String?>[];

  @override
  Future<Paged<Message>> awaitingThreads(int accountId, {String? cursor}) {
    cursors.add(cursor);
    final held = pending;
    pending = null;
    return held?.future ??
        client.awaitingThreads(accountId, limit: 1, cursor: cursor);
  }

  @override
  Stream<MailEvent> events(
    int accountId, {
    void Function(bool)? onLiveChanged,
  }) => const Stream.empty();
}

void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late _Backend backend;
  late MailboxState mailbox;
  late FakeMessage sent;

  setUp(() async {
    fake = FakeRestmail(scenario: FakeScenario.empty);
    sent = fake.deliver(
      to: FakeAccounts.email,
      from: FakeAccounts.email,
      subject: 'Sent',
    )..folder = 'Sent';
    fake.deliver(
      to: FakeAccounts.email,
      from: 'friend@example.test',
      subject: 'Inbox',
    );
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    backend = _Backend(client);
    mailbox = MailboxState(backend);
    await mailbox.start();
  });
  tearDown(() {
    mailbox.dispose();
    client.close();
    fake.close();
  });

  test(
    'waiting cursor loads more across folders, refresh preserves the mode',
    () async {
      final second = fake.deliver(
        to: FakeAccounts.email,
        from: FakeAccounts.email,
        subject: 'Archived',
      )..folder = 'Archive';
      await mailbox.showWaiting();
      expect(mailbox.messages.single.id, second.id);
      expect(mailbox.hasMore, isTrue);
      await mailbox.loadMore();
      expect(mailbox.messages.map((message) => message.id), [
        second.id,
        sent.id,
      ]);
      expect(backend.cursors, hasLength(2));
      expect(backend.cursors.last, isNotNull);
      await mailbox.refresh();
      expect(mailbox.showingWaiting, isTrue);
      expect(mailbox.messages.single.id, second.id);
    },
  );

  test('leaving waiting for the same folder drops its late answer', () async {
    final pending = Completer<Paged<Message>>();
    backend.pending = pending;
    final load = mailbox.showWaiting();
    await mailbox.selectFolder('INBOX');
    pending.complete(Paged([Message.fromJson(sent.toJson())]));
    await load;
    expect(mailbox.showingWaiting, isFalse);
    expect(mailbox.messages.single.subject, 'Inbox');
  });

  test('switching account drops a late waiting answer', () async {
    final pending = Completer<Paged<Message>>();
    backend.pending = pending;
    final load = mailbox.showWaiting();
    final account = mailbox.account!;
    await mailbox.selectAccount(
      Account(
        id: account.id + 100,
        address: 'other@example.test',
        displayName: 'Other',
        isPrimary: false,
      ),
    );
    pending.complete(Paged([Message.fromJson(sent.toJson())]));
    await load;
    expect(mailbox.showingWaiting, isFalse);
    expect(mailbox.messages, isEmpty);
    expect(mailbox.loading, isFalse);
  });
}
