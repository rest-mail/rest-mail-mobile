import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:test/test.dart';

/// A send's List-Unsubscribe (RFC 2369, RFC 8058) against the sender domain's
/// sending policy, as the server holds it (#144).
void main() {
  late FakeRestmail fake;
  late RestmailClient client;
  late AdminDomain domain;
  setUp(() async {
    fake = FakeRestmail();
    client = RestmailClient(
      server: Uri.parse('https://${fake.host}'),
      httpClient: fake.client,
    );
    await client.login(
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    domain = (await client.domains()).items.firstWhere(
      (d) => d.name == FakeAccounts.host,
    );
  });
  tearDown(() {
    client.close();
    fake.close();
  });

  OutgoingMessage message({ListUnsubscribe? unsubscribe}) => OutgoingMessage(
    from: FakeAccounts.adminEmail,
    to: const [FakeAccounts.email],
    subject: 'Spring newsletter',
    bodyText: 'Hello',
    listUnsubscribe: unsubscribe,
  );

  Matcher refused(int status, String code) => isA<ApiException>()
      .having((e) => e.statusCode, 'status', status)
      .having((e) => e.code, 'code', code);

  test('the send body carries the targets it was given, and only those', () {
    expect(message().toSendJson().containsKey('list_unsubscribe'), isFalse);
    expect(
      message(
        unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
      ).toSendJson()['list_unsubscribe'],
      {'mailto': 'leave@restmail.test'},
    );
    expect(
      message(
        unsubscribe: const ListUnsubscribe(
          mailto: 'leave@restmail.test',
          https: 'https://restmail.test/leave?t=1',
        ),
      ).toSendJson()['list_unsubscribe'],
      {
        'mailto': 'leave@restmail.test',
        'https': 'https://restmail.test/leave?t=1',
      },
    );
    // The draft endpoints have no List-Unsubscribe field.
    expect(
      message(
        unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
      ).toDraftJson().containsKey('list_unsubscribe'),
      isFalse,
    );
  });

  test('a domain with no policy sends with or without one', () async {
    await client.send(message());
    await client.send(
      message(
        unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
      ),
    );
  });

  test('a bulk domain needs one on every message, a draft send too', () async {
    await client.updateDomain(domain.id, sendingPolicy: 'bulk');
    await expectLater(
      client.send(message()),
      throwsA(refused(422, 'list_unsubscribe_required')),
    );
    final draft = await client.saveDraft(message());
    await expectLater(
      client.sendDraft(draft.id),
      throwsA(refused(422, 'list_unsubscribe_required')),
    );
    await client.send(
      message(
        unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
      ),
    );
  });

  test('a transactional domain refuses one', () async {
    await client.updateDomain(domain.id, sendingPolicy: 'transactional');
    await expectLater(
      client.send(
        message(
          unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
        ),
      ),
      throwsA(refused(422, 'list_unsubscribe_not_allowed')),
    );
    await client.send(message());
  });

  test('a one-click link needs the domain to sign with DKIM', () async {
    const oneClick = ListUnsubscribe(https: 'https://restmail.test/leave?t=1');
    await client.send(message(unsubscribe: oneClick));
    await client.deleteDkimKey(domain.id);
    await expectLater(
      client.send(message(unsubscribe: oneClick)),
      throwsA(refused(422, 'dkim_required')),
    );
    // An address makes no one-click claim, so it is sent unsigned.
    await client.send(
      message(
        unsubscribe: const ListUnsubscribe(mailto: 'leave@restmail.test'),
      ),
    );
  });

  test('a target that would not make a header field is refused', () async {
    for (final bad in const [
      ListUnsubscribe(mailto: 'Leave <leave@restmail.test>'),
      ListUnsubscribe(mailto: 'leave?subject=x@restmail.test'),
      ListUnsubscribe(mailto: 'leave'),
      ListUnsubscribe(https: 'http://restmail.test/leave'),
      ListUnsubscribe(https: 'https://restmail.test/a,b'),
      ListUnsubscribe(https: 'https://user:pw@restmail.test/leave'),
      ListUnsubscribe(),
    ]) {
      await expectLater(
        client.send(message(unsubscribe: bad)),
        throwsA(refused(400, 'bad_request')),
        reason: '${bad.toJson()}',
      );
    }
  });
}
