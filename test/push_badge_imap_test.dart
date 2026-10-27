import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/push/push_service.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/settings.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'fake_push_service.dart';
import 'imap/scripted_server.dart';

void main() {
  test(
    'badge counts REST and phone-owned IMAP inboxes without server push',
    () async {
      final fake = FakeRestmail(pushPlatforms: const {});
      final imap = await ScriptedServer.start(gmailGreeting, [
        gmailLogin(),
        gmailList(),
        Rule(r'^SELECT', selected('INBOX', exists: 0), repeat: true),
        Rule(
          r'^STATUS',
          '* STATUS "x" (MESSAGES 7 UNSEEN 4)\n{tag} OK Success',
          repeat: true,
        ),
        Rule(r'^LOGOUT', '* BYE\n{tag} OK Success', repeat: true),
      ]);
      final store = MemoryKeyValueStore();
      final first = AppState(
        store: store,
        httpClientFactory: () => fake.client,
      );
      await first.start();
      await first.signIn(
        server: Uri.parse('https://${FakeAccounts.host}'),
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      final restKey = first.accounts.single.key;
      first.dispose();
      const imapKey = 'imaps://imap.gmail.com|ada@gmail.com';
      await store.write(
        'account:$imapKey',
        jsonEncode({
          'kind': 'imap',
          'address': 'ada@gmail.com',
          'display_name': 'Ada',
          'password': 'test-phone-only',
          'settings': const MailServerSettings(
            imapHost: 'imap.gmail.com',
            smtpHost: 'smtp.gmail.com',
            filesSentMail: true,
          ).toJson(),
          'provider': 'gmail',
        }),
      );
      await store.write(
        'accounts',
        jsonEncode({
          'order': [restKey, imapKey],
          'current': restKey,
        }),
      );
      final push = FakePushService(
        deviceToken: null,
        permissionState: NotificationPermission.granted,
      );
      final state = AppState(
        store: store,
        httpClientFactory: () => fake.client,
        pushService: push,
        mailSockets: imap.sockets,
      );
      try {
        await state.start();
        await state.push.start();
        await state.push.reconcileBadge();
        final restUnread = fake
            .messagesIn(FakeAccounts.email, 'INBOX')
            .where((m) => !m.isRead)
            .length;
        expect(state.accounts.whereType<ImapAccount>(), hasLength(1));
        expect(push.badges.last, restUnread + 4);
        expect(state.settings.notifications, NotificationChoice.undecided);
        expect(fake.devicesOf(FakeAccounts.email), isEmpty);
        expect(push.prompts, 0);

        await state.removeAccount(
          state.accounts.whereType<RestAccount>().single,
        );
        await state.push.reconcileBadge();
        expect(push.badges.last, 4);
        push.badgePermissionState = NotificationPermission.denied;
        await state.push.sync();
        expect(push.badges.last, 0);
        push.badgePermissionState = NotificationPermission.granted;
        await state.push.sync();
        expect(push.badges.last, 4);
        expect(imap.unexpected, isEmpty);

        await state.removeAccount(
          state.accounts.whereType<ImapAccount>().single,
        );
        await state.push.reconcileBadge();
        expect(push.badges.last, 0);
      } finally {
        state.dispose();
        fake.close();
        await imap.close();
      }
    },
  );
}
