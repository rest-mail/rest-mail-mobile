import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

void main() {
  test(
    'account import sends the hash unchanged and no chosen password',
    () async {
      const hash =
          r'{SHA512-CRYPT}$6$importsalt$ObInO4qcr134i8FQT.XNC6Ma04n9aRTAUNHmm8Yb1idoDBOXKoDTmdosY1xwfageGXo4ZSSrkIPRk9zMWfsG7/';
      final client = RestmailClient(
        server: Uri.parse('https://example.test'),
        tokens: SessionTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        httpClient: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/v1/accounts');
          expect(jsonDecode(request.body), {
            'address': 'import@example.test',
            'display_name': 'Imported',
            'password_hash': hash,
          });
          return http.Response(
            jsonEncode({
              'data': {
                'id': 9,
                'address': 'import@example.test',
                'display_name': 'Imported',
                'is_primary': false,
              },
            }),
            201,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      addTearDown(client.close);
      final account = await client.createAccount(
        address: 'import@example.test',
        displayName: 'Imported',
        passwordHash: hash,
      );
      expect(account.id, 9);
      expect(account.isPrimary, isFalse);
    },
  );
}
