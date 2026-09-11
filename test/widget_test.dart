import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';

http.Response _json(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);

AppState _state(Future<http.Response> Function(http.Request request) handler) =>
    AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => MockClient(handler),
    );

/// An iPhone-sized window, so the sign-in form fits without scrolling.
void _phoneSized(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('a first launch lands on the welcome screen', (tester) async {
    _phoneSized(tester);
    final state = _state((_) async => http.Response('', 404));
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    expect(find.text('Mail that keeps up with you.'), findsOneWidget);
    expect(find.text('Add an account'), findsOneWidget);
  });

  testWidgets('sign-in finds the server, then asks for the second factor', (
    tester,
  ) async {
    _phoneSized(tester);
    final requests = <String>[];
    final state = _state((request) async {
      requests.add('${request.url.host}${request.url.path}');
      return switch ((request.url.host, request.url.path)) {
        ('example.test', '/api/health') => _json({
          'data': {'status': 'healthy', 'db': 'connected'},
        }),
        ('example.test', '/api/v1/auth/login') => _json({
          'error': {
            'code': 'totp_required',
            'message': 'Two-factor authentication code required',
          },
        }, 401),
        _ => http.Response('', 404),
      };
    });
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));

    await tester.tap(find.text('Add an account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'ada@example.test');
    await tester.pump(const Duration(milliseconds: 600)); // past the debounce
    await tester.pumpAndSettle();
    expect(find.text('Found example.test'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'correct horse');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('TWO-FACTOR CODE'), findsOneWidget);
    expect(state.phase, AppPhase.signedOut);
    expect(requests, contains('example.test/api/v1/auth/login'));
  });
}
