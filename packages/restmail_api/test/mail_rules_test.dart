import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  setUp(() {
    status = 200;
    client = RestmailClient(
      server: Uri.parse('https://mail.example.com'),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
      httpClient: MockClient((request) async {
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

  test('the vacation reply is read, set and turned off', () async {
    reply = {
      'data': {'enabled': false, 'subject': '', 'body': ''},
    };
    final none = await client.vacation(3);
    expect(sent.url.path, '/api/v1/accounts/3/vacation');
    expect(none.enabled, isFalse);
    expect(none.startDate, isNull);

    reply = {
      'data': {
        'enabled': true,
        'subject': 'Away',
        'body': 'Back Monday',
        'start_date': '2026-10-24T00:00:00Z',
        'end_date': '2026-10-26T00:00:00Z',
      },
    };
    final set = await client.setVacation(
      3,
      enabled: true,
      subject: 'Away',
      body: 'Back Monday',
      startDate: DateTime.utc(2026, 10, 24),
      endDate: DateTime.utc(2026, 10, 26),
    );
    expect(sent.method, 'PUT');
    expect(body(), {
      'enabled': true,
      'subject': 'Away',
      'body': 'Back Monday',
      'start_date': '2026-10-24T00:00:00.000Z',
      'end_date': '2026-10-26T00:00:00.000Z',
    });
    expect(set.enabled, isTrue);
    expect(set.endDate!.toUtc(), DateTime.utc(2026, 10, 26));

    await client.setVacation(3, enabled: false);
    expect(body(), {'enabled': false, 'subject': '', 'body': ''});

    status = 204;
    reply = '';
    await client.disableVacation(3);
    expect(sent.method, 'DELETE');
    expect(sent.url.path, '/api/v1/accounts/3/vacation');
  });

  test('the Sieve script is read, saved, checked and deleted', () async {
    reply = {
      'data': {'mailbox_id': 3, 'script': '', 'active': false},
    };
    final none = await client.sieveScript(3);
    expect(sent.url.path, '/api/v1/accounts/3/sieve');
    expect(none.stored, isFalse);
    expect(none.script, '');

    status = 201;
    reply = {
      'data': {
        'id': 5,
        'mailbox_id': 3,
        'script': 'keep;',
        'script_hash': 'ab' * 32,
        'validated_at': '2026-10-23T09:00:00Z',
        'active': true,
        'created_at': '2026-10-23T09:00:00Z',
        'updated_at': '2026-10-23T09:00:00Z',
      },
    };
    final saved = await client.putSieveScript(3, 'keep;');
    expect(sent.method, 'PUT');
    expect(body(), {'script': 'keep;'});
    expect(saved.stored, isTrue);
    expect(saved.id, 5);
    expect(saved.scriptHash, 'ab' * 32);
    expect(saved.active, isTrue);
    await client.putSieveScript(3, 'keep;', active: false);
    expect(body(), {'script': 'keep;', 'active': false});

    status = 200;
    reply = {
      'data': {'message': 'Script is valid', 'valid': true},
    };
    final checked = await client.validateSieveScript(3, 'keep;');
    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/accounts/3/sieve/validate');
    expect(body(), {'script': 'keep;'});
    expect(checked.valid, isTrue);
    expect(checked.message, 'Script is valid');

    reply = {
      'data': {'status': 'deleted'},
    };
    await client.deleteSieveScript(3);
    expect(sent.method, 'DELETE');
  });

  test('a script that does not install is refused with its message', () async {
    status = 400;
    reply = {
      'error': {
        'code': 'invalid_sieve',
        'message': 'sieve parse error: 1:1: unknown command "fileinto"',
      },
    };
    await expectLater(
      client.putSieveScript(3, 'fileinto "x";'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'status', 400)
            .having((e) => e.code, 'code', 'invalid_sieve')
            .having((e) => e.message, 'message', contains('fileinto')),
      ),
    );
  });
}
