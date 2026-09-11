import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';

void main() {
  test(
    'a saved session the server will not renew ends, and says why',
    () async {
      final store = MemoryKeyValueStore();
      await store.write(
        'session',
        jsonEncode({
          'server': 'https://mail.example.test',
          'user': {'id': 1, 'email': 'ada@example.test', 'display_name': 'Ada'},
          'tokens': {
            'access_token': 'a',
            'refresh_token': 'r',
            'access_expires_at': DateTime.now()
                .subtract(const Duration(minutes: 1))
                .toUtc()
                .toIso8601String(),
          },
        }),
      );
      final state = AppState(
        store: store,
        httpClientFactory: () => MockClient(
          (_) async => http.Response(
            jsonEncode({
              'error': {
                'code': 'unauthorized',
                'message': 'Invalid refresh token',
              },
            }),
            401,
          ),
        ),
      );

      await state.start();
      expect(state.phase, AppPhase.signedIn);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(state.phase, AppPhase.signedOut);
      expect(state.signedOutReason, isNotNull);
      expect(store.values.containsKey('session'), isFalse);
    },
  );

  test(
    'an unreadable saved session means signing in again, not a crash',
    () async {
      final store = MemoryKeyValueStore();
      await store.write('session', '{not json');
      final state = AppState(
        store: store,
        httpClientFactory: () =>
            MockClient((_) async => http.Response('', 404)),
      );

      await state.start();

      expect(state.phase, AppPhase.signedOut);
      expect(state.signedOutReason, isNull);
    },
  );
}
