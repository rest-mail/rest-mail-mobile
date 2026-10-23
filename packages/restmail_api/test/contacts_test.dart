import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _contact = <String, dynamic>{
  'id': 9,
  'mailbox_id': 3,
  'email': 'ada@example.test',
  'name': 'Ada',
  'trust_level': 'trusted',
  'source': 'manual',
  'created_at': '2026-10-23T09:00:00Z',
  'updated_at': '2026-10-23T10:00:00Z',
};

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  late int calls;
  setUp(() {
    reply = {'data': _contact};
    status = 200;
    calls = 0;
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
        calls++;
        sent = request;
        return http.Response.bytes(
          utf8.encode(jsonEncode(reply)),
          status,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  });
  tearDown(() => client.close());

  Map<String, dynamic> body() => jsonDecode(sent.body) as Map<String, dynamic>;

  test('the list pages, filters and reads every field', () async {
    reply = {
      'data': [_contact],
      'pagination': {'has_more': false, 'total': 1},
    };
    final page = await client.contacts(
      3,
      search: 'ada',
      trustLevel: TrustLevel.trusted,
      offset: 50,
      limit: 25,
    );
    expect(sent.method, 'GET');
    expect(sent.url.path, '/api/v1/accounts/3/contacts');
    expect(sent.url.queryParameters, {
      'search': 'ada',
      'trust_level': 'trusted',
      'limit': '25',
      'offset': '50',
    });
    expect(page.total, 1);
    final contact = page.items.single;
    expect(contact.id, 9);
    expect(contact.mailboxId, 3);
    expect(contact.email, 'ada@example.test');
    expect(contact.name, 'Ada');
    expect(contact.trustLevel, TrustLevel.trusted);
    expect(contact.source, 'manual');
    expect(contact.createdAt.toUtc(), DateTime.utc(2026, 10, 23, 9));
    expect(contact.updatedAt.toUtc(), DateTime.utc(2026, 10, 23, 10));

    await client.contacts(3);
    expect(sent.url.queryParameters, {'limit': '50', 'offset': '0'});
  });

  test('a new contact sends only what is given', () async {
    status = 201;
    await client.createContact(3, email: 'ada@example.test');
    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/accounts/3/contacts');
    expect(body(), {'email': 'ada@example.test'});

    final made = await client.createContact(
      3,
      email: 'ada@example.test',
      name: 'Ada',
      trustLevel: TrustLevel.auto,
    );
    expect(body(), {
      'email': 'ada@example.test',
      'name': 'Ada',
      'trust_level': 'auto',
    });
    expect(made.id, 9);
  });

  test('an update leaves out what stays as it is', () async {
    await client.updateContact(3, 9, trustLevel: TrustLevel.blocked);
    expect(sent.method, 'PATCH');
    expect(sent.url.path, '/api/v1/accounts/3/contacts/9');
    expect(body(), {'trust_level': 'blocked'});

    await client.updateContact(3, 9, name: '');
    expect(body(), {'name': ''});
  });

  test('delete, block and import go to their routes', () async {
    status = 204;
    reply = '';
    await client.deleteContact(3, 9);
    expect(sent.method, 'DELETE');
    expect(sent.url.path, '/api/v1/accounts/3/contacts/9');

    for (final code in [201, 200]) {
      status = code;
      reply = {
        'data': {..._contact, 'trust_level': 'blocked'},
      };
      final blocked = await client.blockSender(3, 'spam@example.test');
      expect(sent.url.path, '/api/v1/accounts/3/contacts/block');
      expect(body(), {'email': 'spam@example.test'});
      expect(blocked.trustLevel, TrustLevel.blocked);
    }

    status = 200;
    reply = {
      'data': {'imported': 1},
    };
    final imported = await client.importContacts(3, [
      (email: 'ada@example.test', name: 'Ada'),
      (email: 'bob@example.test', name: null),
    ]);
    expect(sent.url.path, '/api/v1/accounts/3/contacts/import');
    expect(body(), {
      'contacts': [
        {'email': 'ada@example.test', 'name': 'Ada'},
        {'email': 'bob@example.test'},
      ],
    });
    expect(imported, 1);
  });

  test('suggestions ask nothing for an empty query', () async {
    expect(await client.suggestContacts(3, ''), isEmpty);
    expect(calls, 0);

    reply = {
      'data': [_contact],
    };
    final suggested = await client.suggestContacts(3, 'ad');
    expect(sent.url.path, '/api/v1/accounts/3/contacts/suggest');
    expect(sent.url.queryParameters, {'q': 'ad'});
    expect(suggested.single.email, 'ada@example.test');
  });

  test('refusals carry their code and fields', () async {
    status = 409;
    reply = {
      'error': {'code': 'already_exists', 'message': 'Contact already exists'},
    };
    await expectLater(
      client.createContact(3, email: 'ada@example.test'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 409)
            .having((e) => e.code, 'code', 'already_exists'),
      ),
    );

    status = 422;
    reply = {
      'error': {
        'code': 'validation_failed',
        'message': 'Request body failed validation',
        'details': {
          'fields': {'contacts[1].email': 'must be an email address'},
        },
      },
    };
    await expectLater(
      client.importContacts(3, [
        (email: 'ada@example.test', name: null),
        (email: 'nope', name: null),
      ]),
      throwsA(
        isA<ApiException>().having(
          (e) => e.fields['contacts[1].email'],
          'field',
          'must be an email address',
        ),
      ),
    );
  });
}
