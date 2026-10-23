import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

const _step = PipelineFilter(
  name: 'sieve',
  type: 'transform',
  enabled: false,
  unskippable: true,
  config: {
    'script': 'keep;',
    'extra': {
      'key': [1, true],
    },
  },
);
const _pipeline = <String, dynamic>{
  'id': 9,
  'domain_id': 4,
  'direction': 'inbound',
  'active': false,
  'filters': <Object?>[],
  'created_at': '2026-10-01T12:00:00Z',
  'updated_at': '2026-10-02T12:00:00Z',
  'domain': {'name': 'example.com'},
};
const _custom = <String, dynamic>{
  'id': 8,
  'domain_id': 4,
  'name': 'sample',
  'description': 'description',
  'filter_type': 'transform',
  'direction': 'both',
  'config': {'script': 'function filter(email) { return email; }'},
  'enabled': false,
  'created_at': '2026-10-01T12:00:00Z',
  'updated_at': '2026-10-02T12:00:00Z',
  'domain': {'name': 'example.com'},
};
const _email = <String, dynamic>{
  'envelope': {'mail_from': 'a@example.com', 'tls': true},
  'headers': {'subject': 'é'},
  'body': {
    'parts': [
      {'content': 'body'},
    ],
  },
  'attachments': [
    {'filename': 'file', 'content': 'YQ=='},
  ],
  'calendar_events': [
    {'uid': 'event'},
  ],
  'metadata': {'key': 'value'},
};

void main() {
  late RestmailClient client;
  late http.Request sent;
  late Object reply;
  late int status;
  late int calls;
  setUp(() {
    reply = {'data': _pipeline};
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
          headers: {
            'content-type': 'application/json',
            if (status == 429) 'retry-after': '12',
          },
        );
      }),
    );
  });
  tearDown(() => client.close());
  void request(String method, String path, Object body) {
    expect(sent.method, method);
    expect(sent.url.path, '/api/v1/admin/$path');
    expect(jsonDecode(sent.body), body);
    expect(sent.headers['Authorization'], 'Bearer access');
  }

  test(
    'pipeline create sends every field and reads config and metadata',
    () async {
      reply = {
        'data': {
          ..._pipeline,
          'filters': [_step.toJson()],
        },
      };
      status = 201;
      final result = await client.createPipeline(
        domainId: 4,
        direction: 'inbound',
        filters: [_step],
        active: false,
      );
      request('POST', 'pipelines', {
        'domain_id': 4,
        'direction': 'inbound',
        'active': false,
        'filters': [_step.toJson()],
      });
      expect(result.filters.single.config, _step.config);
      expect(result.filters.single.toJson(), _step.toJson());
      expect(result.createdAt!.toUtc(), DateTime.utc(2026, 10, 1, 12));
      expect(result.updatedAt!.toUtc(), DateTime.utc(2026, 10, 2, 12));
      expect(result.domain, 'example.com');
      expect(result.active, isFalse);
    },
  );
  test(
    'pipeline create omits active and sends empty ordered filters',
    () async {
      await client.createPipeline(
        domainId: 4,
        direction: 'outbound',
        filters: [],
      );
      request('POST', 'pipelines', {
        'domain_id': 4,
        'direction': 'outbound',
        'filters': <Object?>[],
      });
    },
  );
  test(
    'pipeline patch omits unchanged fields, sends false and empty filters',
    () async {
      await client.updatePipeline(9, active: false);
      request('PATCH', 'pipelines/9', {'active': false});
      await client.updatePipeline(9, filters: []);
      request('PATCH', 'pipelines/9', {'filters': <Object?>[]});
      await client.updatePipeline(9, filters: [_step], active: true);
      request('PATCH', 'pipelines/9', {
        'filters': [_step.toJson()],
        'active': true,
      });
    },
  );
  for (final custom in [false, true]) {
    test(
      '${custom ? 'custom filters' : 'pipelines'} list all query fields and pages',
      () async {
        reply = {
          'data': [custom ? _custom : _pipeline],
          'pagination': {'total': 12},
        };
        final page = custom
            ? await client.customFilters(domainId: 4, offset: 2, limit: 3)
            : await client.pipelines(domainId: 4, offset: 2, limit: 3);
        expect(sent.method, 'GET');
        expect(
          sent.url.path,
          '/api/v1/admin/${custom ? 'custom-filters' : 'pipelines'}',
        );
        expect(sent.url.queryParameters, {
          'domain_id': '4',
          'offset': '2',
          'limit': '3',
        });
        expect(page.total, 12);
        expect(page.hasMore, isTrue);
      },
    );
  }
  test('custom create sends all fields and reads complete response', () async {
    reply = {'data': _custom};
    status = 201;
    final result = await client.createCustomFilter(
      domainId: 4,
      name: 'sample',
      description: 'description',
      filterType: 'transform',
      direction: 'both',
      config: _custom['config'] as Map<String, dynamic>,
      enabled: false,
    );
    request('POST', 'custom-filters', {
      'domain_id': 4,
      'name': 'sample',
      'description': 'description',
      'filter_type': 'transform',
      'direction': 'both',
      'config': _custom['config'],
      'enabled': false,
    });
    expect(result.config, _custom['config']);
    expect(result.domain, 'example.com');
    expect(result.createdAt!.toUtc(), DateTime.utc(2026, 10, 1, 12));
  });
  test('custom create leaves defaults to server', () async {
    reply = {'data': _custom};
    await client.createCustomFilter(
      domainId: 4,
      name: 'sample',
      filterType: 'action',
      direction: 'inbound',
      config: {},
    );
    request('POST', 'custom-filters', {
      'domain_id': 4,
      'name': 'sample',
      'filter_type': 'action',
      'direction': 'inbound',
      'config': <String, Object?>{},
    });
  });
  test(
    'custom GET and patch use exact paths and all writable fields',
    () async {
      reply = {'data': _custom};
      final result = await client.customFilter(8);
      expect(sent.method, 'GET');
      expect(sent.url.path, '/api/v1/admin/custom-filters/8');
      expect(result.id, 8);
      await client.updateCustomFilter(
        8,
        name: 'new',
        description: '',
        filterType: 'action',
        direction: 'outbound',
        config: {},
        enabled: false,
      );
      request('PATCH', 'custom-filters/8', {
        'name': 'new',
        'description': '',
        'filter_type': 'action',
        'direction': 'outbound',
        'config': <String, Object?>{},
        'enabled': false,
      });
      await client.updateCustomFilter(8, enabled: true);
      request('PATCH', 'custom-filters/8', {'enabled': true});
    },
  );
  test(
    'pipeline preview retains every result, step, auth and email field',
    () async {
      final data = {
        'final_action': 'reject',
        'final_email': _email,
        'reject_message': 'blocked',
        'duration_ms': 100,
        'steps': [
          {
            'filter_name': 'sieve',
            'filter_type': 'transform',
            'action': 'continue',
            'skipped': true,
            'skip_reason': 'earlier',
            'duration_ms': 50,
            'error': 'example',
            'log': {'filter': 'sieve', 'result': 'skip', 'detail': 'why'},
          },
        ],
        'auth_results': [
          {'method': 'dkim', 'result': 'pass'},
        ],
      };
      reply = {'data': data};
      final result = await client.testPipeline(9, email: _email);
      request('POST', 'pipelines/test', {'pipeline_id': 9, 'email': _email});
      expect(result.json, data);
      expect(result.finalEmail, _email);
      expect(result.finalAction, 'reject');
      expect(result.rejectMessage, 'blocked');
      expect(result.durationMs, 100);
      final step = result.steps.single;
      expect(step.filterName, 'sieve');
      expect(step.filterType, 'transform');
      expect(step.skipped, isTrue);
      expect(step.skipReason, 'earlier');
      expect(step.error, 'example');
      expect(step.durationMs, 50);
      expect(result.authResults.single['result'], 'pass');
    },
  );
  test(
    'single filter preview retains skip list, log and transformed email',
    () async {
      reply = {
        'data': {
          'type': 'transform',
          'action': 'continue',
          'message': _email,
          'skip_filters': ['spam'],
          'reject_message': 'reason',
          'log': {'result': 'ok', 'detail': 'done'},
        },
      };
      final result = await client.testFilter(
        filterName: 'sieve',
        config: {'script': 'keep;'},
        email: _email,
      );
      request('POST', 'pipelines/test-filter', {
        'filter_name': 'sieve',
        'config': {'script': 'keep;'},
        'email': _email,
      });
      expect(result.message, _email);
      expect(result.skipFilters, ['spam']);
      expect(result.log['detail'], 'done');
      expect(result.rejectMessage, 'reason');
      expect(result.type, 'transform');
    },
  );
  test(
    'validation reads bare syntax failure without assuming HTTP 200 valid',
    () async {
      reply = {'valid': false, 'error': 'Unexpected token', 'phase': 'syntax'};
      final result = await client.validateCustomFilter('broken');
      request('POST', 'custom-filters/validate', {'script': 'broken'});
      expect(result.valid, isFalse);
      expect(result.error, 'Unexpected token');
      expect(result.phase, 'syntax');
    },
  );
  test('valid syntax with a failed dry run stays visibly failed', () async {
    reply = {
      'valid': true,
      'dry_run': {
        'error': 'execution timeout',
        'logs': ['before'],
      },
      'phase': 'execution',
    };
    final result = await client.validateCustomFilter('script', email: _email);
    request('POST', 'custom-filters/validate', {
      'script': 'script',
      'email': _email,
    });
    expect(result.valid, isTrue);
    expect(result.dryRun!.error, 'execution timeout');
    expect(result.dryRun!.logs, ['before']);
  });
  test('custom test bare response retains arbitrary result and logs', () async {
    reply = {
      'result': [
        'arbitrary',
        {'message': _email},
      ],
      'logs': ['é'],
    };
    final result = await client.testCustomFilter(8, email: _email);
    request('POST', 'custom-filters/8/test', {'email': _email});
    expect(result.result, (reply as Map<String, Object>)['result']);
    expect(result.logs, ['é']);
    await client.testCustomFilter(8);
    request('POST', 'custom-filters/8/test', {});
  });
  test('bare sidecar error keeps server explanation', () async {
    reply = {'error': 'script must define a filter(email) function'};
    status = 500;
    await expectLater(
      client.testCustomFilter(8),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'script must define a filter(email) function',
        ),
      ),
    );
  });
  for (final (name, delete, path) in [
    ('pipeline', (RestmailClient c) => c.deletePipeline(9), 'pipelines/9'),
    (
      'custom filter',
      (RestmailClient c) => c.deleteCustomFilter(8),
      'custom-filters/8',
    ),
  ]) {
    test('$name delete reads the deleted acknowledgement', () async {
      reply = {
        'data': {'status': 'deleted'},
      };
      await delete(client);
      expect(sent.method, 'DELETE');
      expect(sent.url.path, '/api/v1/admin/$path');
      expect(calls, 1);
    });
    for (final (what, body, code) in <(String, Object, int)>[
      (
        'another status',
        {
          'data': {'status': 'queued'},
        },
        200,
      ),
      ('no status', {'data': <String, Object?>{}}, 200),
      ('no data', <String, Object?>{}, 200),
      (
        'an unexpected success code',
        {
          'data': {'status': 'deleted'},
        },
        202,
      ),
    ]) {
      test('$name delete with $what is not taken as done', () async {
        reply = body;
        status = code;
        await expectLater(
          delete(client),
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', 'bad_response')
                .having((e) => e.statusCode, 'status', code),
          ),
        );
        expect(calls, 1);
        expect(client.tokens!.accessToken, 'access');
      });
    }
  }
  for (final code in [400, 403, 404, 422, 429, 503]) {
    test('$code refusal keeps session, field errors and retry delay', () async {
      reply = {
        'error': {
          'code': 'example',
          'message': 'Refused',
          'details': {
            'fields': {'config': 'bad object'},
          },
        },
      };
      status = code;
      await expectLater(
        client.createPipeline(domainId: 4, direction: 'inbound', filters: []),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', code)
              .having((e) => e.fields['config'], 'field', 'bad object')
              .having(
                (e) => e.retryAfter,
                'retry after',
                code == 429 ? const Duration(seconds: 12) : null,
              ),
        ),
      );
      expect(calls, 1);
      expect(client.tokens!.accessToken, 'access');
    });
  }
}
