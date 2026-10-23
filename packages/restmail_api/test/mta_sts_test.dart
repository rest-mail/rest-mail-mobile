import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _path = '/api/v1/admin/domains/42/mta-sts';
const _policy = {
  'id': 9,
  'domain_id': 42,
  'mode': 'enforce',
  'mx_hosts': 'mx.example.test, *.example.test',
  'max_age': 12345,
  'active': false,
  'created_at': '2026-10-20T10:20:30Z',
  'updated_at': '2026-10-22T12:34:56Z',
};

http.Response _json(Object body, {int status = 200}) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);

RestmailClient _client(Future<http.Response> Function(http.Request) answer) =>
    RestmailClient(
      server: Uri.parse('https://mail.example.test'),
      httpClient: MockClient(answer),
      tokens: SessionTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
      ),
    );

void main() {
  test(
    'GET uses the domain route and parses all public policy fields',
    () async {
      final client = _client((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, _path);
        expect(request.url.query, isEmpty);
        expect(request.body, isEmpty);
        return _json({'data': _policy});
      });
      addTearDown(client.close);
      final policy = (await client.mtaStsPolicy(42))!;
      expect(policy.id, 9);
      expect(policy.domainId, 42);
      expect(policy.mode, MtaStsMode.enforce);
      expect(policy.mxHosts, ['mx.example.test', '*.example.test']);
      expect(policy.maxAgeSeconds, 12345);
      expect(policy.maxAge, const Duration(seconds: 12345));
      expect(policy.active, isFalse);
      expect(policy.createdAt!.toUtc(), DateTime.utc(2026, 10, 20, 10, 20, 30));
      expect(policy.updatedAt!.toUtc(), DateTime.utc(2026, 10, 22, 12, 34, 56));
      expect(policy.domain, isNull);
    },
  );

  test('optional loaded domain is parsed; Go zero association is absent', () {
    final policy = MtaStsPolicy.fromJson({
      ..._policy,
      'domain': {'id': 42, 'name': 'example.test', 'server_type': 'restmail'},
    });
    expect(policy.domain!.id, 42);
    expect(policy.domain!.name, 'example.test');
    expect(policy.domain!.serverType, 'restmail');
    expect(
      MtaStsPolicy.fromJson({
        ..._policy,
        'domain': {'id': 0, 'name': ''},
      }).domain,
      isNull,
    );
  });

  test('only the documented no-policy 404 becomes null', () async {
    var missing = 'No MTA-STS policy found for this domain';
    final client = _client(
      (_) async => _json({
        'error': {'code': 'not_found', 'message': missing},
      }, status: 404),
    );
    addTearDown(client.close);
    expect(await client.mtaStsPolicy(42), isNull);
    missing = 'Domain not found';
    await expectLater(
      client.mtaStsPolicy(42),
      throwsA(isA<ApiException>().having((e) => e.message, 'message', missing)),
    );
  });

  for (final status in [200, 201]) {
    test(
      'PUT sends every field and reads the $status upsert response',
      () async {
        final client = _client((request) async {
          expect(request.method, 'PUT');
          expect(request.url.path, _path);
          expect(jsonDecode(request.body), {
            'mode': 'enforce',
            'mx_hosts': 'mx.example.test,*.example.test',
            'max_age': 12345,
            'active': false,
          });
          return _json({'data': _policy}, status: status);
        });
        addTearDown(client.close);
        final policy = await client.setMtaStsPolicy(
          42,
          mode: MtaStsMode.enforce,
          mxHosts: ['mx.example.test', '*.example.test'],
          maxAgeSeconds: 12345,
          active: false,
        );
        expect(policy.id, 9);
        expect(policy.maxAgeSeconds, 12345);
        expect(policy.active, isFalse);
      },
    );
  }

  test(
    'PUT preserves omitted fields and explicitly sends zero and false',
    () async {
      final sent = <Object?>[];
      final client = _client((request) async {
        sent.add(jsonDecode(request.body));
        return _json({'data': _policy});
      });
      addTearDown(client.close);
      await client.setMtaStsPolicy(42);
      await client.setMtaStsPolicy(42, maxAgeSeconds: 0);
      await client.setMtaStsPolicy(42, active: false);
      await client.setMtaStsPolicy(42, active: true);
      await client.setMtaStsPolicy(42, mxHosts: []);
      await client.setMtaStsPolicy(42, maxAge: const Duration(seconds: 71));
      for (final mode in MtaStsMode.values) {
        await client.setMtaStsPolicy(42, mode: mode);
      }
      expect(sent, [
        <String, Object?>{},
        {'max_age': 0},
        {'active': false},
        {'active': true},
        {'mx_hosts': ''},
        {'max_age': 71},
        for (final mode in MtaStsMode.values) {'mode': mode.name},
      ]);
    },
  );

  test('wire seconds survive the full signed server integer range', () async {
    const seconds = 9223372036854775807;
    final client = _client((request) async {
      expect(jsonDecode(request.body), {'max_age': seconds});
      return _json({
        'data': {..._policy, 'max_age': seconds},
      });
    });
    addTearDown(client.close);
    final result = await client.setMtaStsPolicy(42, maxAgeSeconds: seconds);
    expect(result.maxAgeSeconds, seconds);
  });

  test('ambiguous lifetime arguments are refused before a request', () async {
    final client = _client((_) async => fail('must not send a request'));
    addTearDown(client.close);
    await expectLater(
      client.setMtaStsPolicy(42, maxAge: Duration.zero, maxAgeSeconds: 0),
      throwsArgumentError,
    );
  });

  test('DELETE needs an empty-body 204 and sends no request body', () async {
    final client = _client((request) async {
      expect(request.method, 'DELETE');
      expect(request.url.path, _path);
      expect(request.body, isEmpty);
      return http.Response('', 204);
    });
    addTearDown(client.close);
    await client.deleteMtaStsPolicy(42);
  });

  for (final method in ['GET', 'PUT', 'DELETE']) {
    test('$method refuses an unexpected success status', () async {
      final client = _client(
        (_) async => _json({'data': _policy}, status: 202),
      );
      addTearDown(client.close);
      final request = switch (method) {
        'GET' => client.mtaStsPolicy(42),
        'PUT' => client.setMtaStsPolicy(42),
        _ => client.deleteMtaStsPolicy(42),
      };
      await expectLater(
        request,
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
        ),
      );
      expect(client.tokens!.refreshToken, 'refresh');
    });

    test(
      '$method permission refusal never refreshes or ends the session',
      () async {
        var requests = 0;
        final client = _client((request) async {
          requests++;
          expect(request.url.path, _path);
          return _json({
            'error': {'code': 'forbidden', 'message': 'Permission denied'},
          }, status: 403);
        });
        addTearDown(client.close);
        final request = switch (method) {
          'GET' => client.mtaStsPolicy(42),
          'PUT' => client.setMtaStsPolicy(42),
          _ => client.deleteMtaStsPolicy(42),
        };
        await expectLater(
          request,
          throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'status', 403),
          ),
        );
        expect(requests, 1);
        expect(client.tokens!.accessToken, 'access');
        expect(client.tokens!.refreshToken, 'refresh');
      },
    );
  }

  test(
    'PUT exposes server validation fields without changing tokens',
    () async {
      final client = _client(
        (_) async => _json({
          'error': {
            'code': 'validation_failed',
            'message': 'Request body failed validation',
            'details': {'max_age': 'Must be a non-negative integer (seconds)'},
          },
        }, status: 422),
      );
      addTearDown(client.close);
      await expectLater(
        client.setMtaStsPolicy(42, maxAgeSeconds: -1),
        throwsA(
          isA<ApiException>().having(
            (e) => e.fields['max_age'],
            'field message',
            'Must be a non-negative integer (seconds)',
          ),
        ),
      );
      expect(client.tokens!.refreshToken, 'refresh');
    },
  );
}
