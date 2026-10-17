import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/mail_backend.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'scripted_server.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');

const _settings = MailServerSettings(
  imapHost: 'imap.gmail.com',
  smtpHost: 'smtp.gmail.com',
  filesSentMail: true,
);

void main() {
  late FakeRestmail fake;
  late ScriptedServer imap;
  late ScriptedServer smtp;
  late MemoryKeyValueStore store;

  setUp(() async {
    fake = FakeRestmail();
    store = MemoryKeyValueStore();
    imap = await ScriptedServer.start(gmailGreeting, [
      Rule(
        r'^LOGIN "ada@gmail.com" "wrong"',
        '{tag} NO [AUTHENTICATIONFAILED] Invalid credentials (Failure)',
        repeat: true,
      ),
      gmailLogin(),
      gmailList(),
      Rule(r'^SELECT', selected('INBOX', exists: 0), repeat: true),
      Rule(
        r'^STATUS',
        '* STATUS "x" (MESSAGES 0 UNSEEN 0)\n{tag} OK Success',
        repeat: true,
      ),
      Rule(r'^LOGOUT', '* BYE\n{tag} OK Success', repeat: true),
    ]);
    smtp = await ScriptedServer.start('220 smtp.gmail.com ESMTP', [
      Rule(
        r'^EHLO',
        '250-smtp.gmail.com\n250-AUTH LOGIN PLAIN\n250 8BITMIME',
        repeat: true,
      ),
      Rule(r'^AUTH PLAIN', '235 2.7.0 Accepted', repeat: true),
      Rule(r'^QUIT', '221 2.0.0 closing connection', repeat: true),
    ], smtp: true);
  });
  tearDown(() async {
    fake.close();
    await imap.close();
    await smtp.close();
  });

  AppState newState() {
    final state = AppState(
      store: store,
      httpClientFactory: () => fake.client,
      mailSockets: (host, port, {required tls}) =>
          (host.startsWith('smtp') ? smtp : imap).sockets(host, port, tls: tls),
    );
    addTearDown(state.dispose);
    return state;
  }

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 100));

  test('a Gmail account sits beside a REST Mail one, tagged by kind, and '
      'both come back after a restart', () async {
    final state = newState();
    await state.start();
    await state.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );

    await state.addImapAccount(
      address: 'ada@gmail.com',
      password: 'abcdabcdabcdabcd',
      displayName: 'Ada',
      settings: _settings,
      provider: MailProviders.gmail,
    );
    await settle();

    expect(state.accounts.map((a) => a.kind), [
      AccountKind.rest,
      AccountKind.imap,
    ]);
    expect(state.current, isA<ImapAccount>());
    expect(state.mailbox!.backend, isA<ImapBackend>());
    expect(state.mailbox!.account?.address, 'ada@gmail.com');
    // Both servers were tried before it was added.
    expect(smtp.commands.where((c) => c.startsWith('AUTH')), hasLength(1));

    final index = jsonDecode(store.values['accounts']!) as Map;
    final keys = (index['order'] as List).cast<String>();
    expect(keys.last, 'imaps://imap.gmail.com|ada@gmail.com');
    final rest = jsonDecode(store.values['account:${keys.first}']!) as Map;
    final gmail = jsonDecode(store.values['account:${keys.last}']!) as Map;
    expect(rest['kind'], 'rest');
    expect(gmail['kind'], 'imap');
    expect(gmail['password'], 'abcdabcdabcdabcd');
    expect(gmail['provider'], 'gmail');

    final again = newState();
    await again.start();
    await settle();

    expect(again.accounts.map((a) => a.address), [
      FakeAccounts.email,
      'ada@gmail.com',
    ]);
    expect(again.current?.address, 'ada@gmail.com');
    expect((again.current! as ImapAccount).provider, MailProviders.gmail);

    // Switching back to the REST Mail account leaves it as it was.
    await again.switchTo(again.accounts.first);
    await settle();
    expect(again.mailbox!.backend, isA<RestBackend>());
    expect(again.mailbox!.messages, isNotEmpty);
  });

  test('a wrong password adds nothing and keeps nothing', () async {
    final state = newState();
    await state.start();

    await expectLater(
      state.addImapAccount(
        address: 'ada@gmail.com',
        password: 'wrong',
        settings: _settings,
      ),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'unauthorized'),
      ),
    );

    expect(state.accounts, isEmpty);
    expect(state.phase, AppPhase.signedOut);
    expect(store.values, isEmpty);
  });

  test('signing out of the IMAP account forgets its password and leaves the '
      'REST Mail account signed in', () async {
    final state = newState();
    await state.start();
    await state.signIn(
      server: _server,
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await state.addImapAccount(
      address: 'ada@gmail.com',
      password: 'abcdabcdabcdabcd',
      settings: _settings,
    );
    await settle();

    await state.signOut();
    await settle();

    expect(state.accounts.single.kind, AccountKind.rest);
    expect(state.current?.address, FakeAccounts.email);
    expect(
      store.values.values.where((v) => v.contains('abcdabcdabcdabcd')),
      isEmpty,
    );
  });
}
