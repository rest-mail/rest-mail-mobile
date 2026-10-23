import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

Map<String, Object?> _rule(SenderList list) => {
  'id': 7,
  'domain_id': 42,
  'pattern': 'spam@example.test',
  'list_type': list == SenderList.allow ? 'allow' : 'block',
  'reason': 'Repeated spam — reviewed',
  'created_by': 81,
  'created_at': '2026-10-23T02:03:04Z',
};

http.Response _json(Object? body, {int status = 200}) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
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
        accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
      ),
    );

void main() {
  for (final list in SenderList.values) {
    final path = '/api/v1/admin/domains/42/${list.path}';
    group(list.path, () {
      test('GET request and every response field', () async {
        final client = _client((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, path);
          expect(request.url.query, isEmpty);
          expect(request.body, isEmpty);
          return _json({
            'data': [_rule(list)],
          });
        });
        addTearDown(client.close);
        final rule = (await client.senderRules(42, list)).single;
        expect(rule.id, 7);
        expect(rule.domainId, 42);
        expect(rule.list, list);
        expect(rule.pattern, 'spam@example.test');
        expect(rule.reason, 'Repeated spam — reviewed');
        expect(rule.createdBy, 81);
        expect(rule.createdAt!.toUtc(), DateTime.utc(2026, 10, 23, 2, 3, 4));
      });

      for (final empty in [null, <Object?>[]]) {
        test('GET accepts empty Go slice $empty', () async {
          final client = _client((_) async => _json({'data': empty}));
          addTearDown(client.close);
          expect(await client.senderRules(42, list), isEmpty);
        });
      }

      test('POST sends pattern/reason only and reads the 201 rule', () async {
        final client = _client((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, path);
          expect(jsonDecode(request.body), {
            'pattern': 'spam@example.test',
            'reason': 'Repeated spam — reviewed',
          });
          return _json({'data': _rule(list)}, status: 201);
        });
        addTearDown(client.close);
        final created = await client.addSenderRule(
          42,
          list,
          pattern: 'spam@example.test',
          reason: 'Repeated spam — reviewed',
        );
        expect(created.id, 7);
        expect(created.list, list);
        expect(created.createdBy, 81);
      });

      test('POST default reason and unrecorded creator', () async {
        final client = _client((request) async {
          expect(jsonDecode(request.body), {
            'pattern': '@example.test',
            'reason': '',
          });
          return _json({
            'data': {
              ..._rule(list),
              'pattern': '@example.test',
              'created_by': null,
            },
          }, status: 201);
        });
        addTearDown(client.close);
        expect(
          (await client.addSenderRule(
            42,
            list,
            pattern: '@example.test',
          )).createdBy,
          isNull,
        );
        final legacy = _rule(list)
          ..remove('created_by')
          ..remove('reason');
        final parsed = SenderRule.fromJson(legacy);
        expect(parsed.createdBy, isNull);
        expect(parsed.reason, isEmpty);
      });

      test('DELETE uses the exact domain/list/rule and expects 204', () async {
        final client = _client((request) async {
          expect(request.method, 'DELETE');
          expect(request.url.path, '$path/7');
          expect(request.url.query, isEmpty);
          expect(request.body, isEmpty);
          return http.Response('', 204);
        });
        addTearDown(client.close);
        await client.removeSenderRule(42, list, 7);
      });

      for (final method in ['GET', 'POST', 'DELETE']) {
        test('$method rejects an unexpected success status', () async {
          final client = _client(
            (_) async => _json({'data': _rule(list)}, status: 202),
          );
          addTearDown(client.close);
          final request = switch (method) {
            'GET' => client.senderRules(42, list),
            'POST' => client.addSenderRule(42, list, pattern: '@example.test'),
            _ => client.removeSenderRule(42, list, 7),
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
          '$method permission refusal does not refresh or end the session',
          () async {
            var calls = 0;
            final client = _client((request) async {
              calls++;
              expect(request.url.path, method == 'DELETE' ? '$path/7' : path);
              return _json({
                'error': {'code': 'forbidden', 'message': 'Permission denied'},
              }, status: 403);
            });
            addTearDown(client.close);
            final request = switch (method) {
              'GET' => client.senderRules(42, list),
              'POST' => client.addSenderRule(
                42,
                list,
                pattern: '@example.test',
              ),
              _ => client.removeSenderRule(42, list, 7),
            };
            await expectLater(
              request,
              throwsA(
                isA<ApiException>().having((e) => e.statusCode, 'status', 403),
              ),
            );
            expect(calls, 1);
            expect(client.tokens!.accessToken, 'access');
            expect(client.tokens!.refreshToken, 'refresh');
          },
        );
      }

      for (final bad in <String, Object?>{
        'wrong domain': {..._rule(list), 'domain_id': 99},
        'wrong list': {
          ..._rule(list),
          'list_type': list == SenderList.allow ? 'block' : 'allow',
        },
        'unknown list': {..._rule(list), 'list_type': 'future'},
        'missing list': {..._rule(list)}..remove('list_type'),
        'missing sender': {..._rule(list)}..remove('pattern'),
        'missing id': {..._rule(list)}..remove('id'),
        'missing creation time': {..._rule(list)}..remove('created_at'),
        'invalid creator': {..._rule(list), 'created_by': 'unrecognised'},
        'not an object': 7,
      }.entries) {
        test('GET and POST reject ${bad.key}', () async {
          final client = _client(
            (request) async => _json({
              'data': request.method == 'GET' ? [bad.value] : bad.value,
            }, status: request.method == 'GET' ? 200 : 201),
          );
          addTearDown(client.close);
          for (final request in <Future<Object?> Function()>[
            () => client.senderRules(42, list),
            () => client.addSenderRule(42, list, pattern: '@example.test'),
          ]) {
            await expectLater(
              request(),
              throwsA(
                isA<ApiException>().having(
                  (e) => e.code,
                  'code',
                  'bad_response',
                ),
              ),
            );
          }
          expect(client.tokens!.refreshToken, 'refresh');
        });
      }

      test('missing list envelope is an error, not an empty list', () async {
        final client = _client((_) async => _json({'other': <Object?>[]}));
        addTearDown(client.close);
        await expectLater(
          client.senderRules(42, list),
          throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'bad_response'),
          ),
        );
      });

      for (final refusal in [
        (409, 'already_exists'),
        (422, 'validation_failed'),
      ]) {
        test('POST surfaces ${refusal.$2} without retry or sign-out', () async {
          var calls = 0;
          final client = _client((_) async {
            calls++;
            return _json({
              'error': {
                'code': refusal.$2,
                'message': refusal.$1 == 409
                    ? 'Sender is already on the ${list.path}'
                    : 'Request body failed validation',
                if (refusal.$1 == 422)
                  'details': {
                    'fields': {'pattern': 'required'},
                  },
              },
            }, status: refusal.$1);
          });
          addTearDown(client.close);
          await expectLater(
            client.addSenderRule(42, list, pattern: ''),
            throwsA(
              isA<ApiException>().having((e) => e.code, 'code', refusal.$2),
            ),
          );
          expect(calls, 1);
          expect(client.tokens!.refreshToken, 'refresh');
        });
      }
    });
  }
}
