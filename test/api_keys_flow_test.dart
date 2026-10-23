import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/util/secret_clipboard.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _token = 'rmk_ABCDEFGHIJKL_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

/// A fixture for the new server contract. Ordinary requests still reach the
/// fake, so these tests exercise the real sign-in and Settings navigation.
class _Keys {
  Map<String, dynamic>? request;
  String? refusal;
  bool exists = false;
  int revoked = 0;

  Map<String, Object?> get metadata => {
    'id': 77,
    'name': 'Provisioning',
    'kind': 'api_key',
    'public_id': 'ABCDEFGHIJKL',
    'created_at': '2026-10-22T12:00:00Z',
    'last_used_at': null,
    'expires_at': '2027-01-20T12:00:00Z',
    'permissions': [
      {
        'capability': 'mail:read',
        'scope': 'mailbox:${FakeAccounts.adminEmail}',
      },
    ],
  };
}

class _KeyClient extends http.BaseClient {
  _KeyClient(this.inner, this.keys);
  final http.Client inner;
  final _Keys keys;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.contains('/api-keys')) return inner.send(request);
    final raw = await request.finalize().toBytes();
    Object? body;
    var status = 200;
    switch (request.method) {
      case 'GET':
        body = {
          'data': [if (keys.exists) keys.metadata],
        };
      case 'POST':
        keys.request = jsonDecode(utf8.decode(raw)) as Map<String, dynamic>;
        if (keys.refusal case final code?) {
          status = code == 'validation_failed'
              ? 422
              : code == 'http_404'
              ? 404
              : 403;
          body = {
            'error': {
              'code': code,
              'message': 'The request was refused',
              if (code == 'validation_failed')
                'details': {
                  'fields': {'permissions': 'scope invalid'},
                },
            },
          };
        } else {
          keys.exists = true;
          status = 201;
          body = {
            'data': {...keys.metadata, 'token': _token},
          };
        }
      case 'DELETE':
        keys.revoked++;
        keys.exists = false;
        status = 204;
    }
    return http.StreamedResponse(
      Stream.value(body == null ? <int>[] : utf8.encode(jsonEncode(body))),
      status,
      headers: {'content-type': 'application/json'},
    );
  }

  @override
  void close() => inner.close();
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, MemoryKeyValueStore)> open(
    WidgetTester tester,
    _Keys keys,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    final state = AppState(
      store: store,
      httpClientFactory: () => _KeyClient(fake.client, keys),
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state, store);
  }

  Future<void> tap(WidgetTester tester, Finder target) async {
    for (final delta in [-250.0, 250.0]) {
      for (var i = 0; i < 25 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }
    expect(target, findsWidgets);
    await tester.ensureVisible(target.last);
    await tester.pumpAndSettle();
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<void> text(WidgetTester tester, String value) =>
      tap(tester, find.text(value));

  Finder field(String label) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );

  Future<void> createForm(WidgetTester tester) async {
    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await text(tester, FakeAccounts.adminEmail);
    await text(tester, 'API keys');
    await text(tester, 'Create an API key');
    await tester.enterText(field('Name'), 'Provisioning');
    await tester.enterText(
      field('Current password'),
      FakeAccounts.adminPassword,
    );
    await tester.pump();
  }

  Future<void> close(
    WidgetTester tester,
    FakeRestmail fake,
    AppState state,
  ) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('create a scoped key, copy it once, then list and revoke it', (
    tester,
  ) async {
    final keys = _Keys();
    final (fake, state, store) = await open(tester, keys);
    final copies = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SecretClipboard.channel,
      (call) async {
        copies.add(call);
        return true;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SecretClipboard.channel,
        null,
      ),
    );

    await createForm(tester);
    await text(tester, 'Create API key');
    expect(keys.request, {
      'name': 'Provisioning',
      'password': FakeAccounts.adminPassword,
      'permissions': [
        {
          'capability': 'mail:read',
          'scope': 'mailbox:${FakeAccounts.adminEmail}',
        },
      ],
    });
    expect(find.text('API key created'), findsOneWidget);
    expect(
      tester.widget<SelectableText>(find.byType(SelectableText)).data,
      _token,
    );
    await text(tester, 'Copy API key');
    expect((copies.single.arguments as Map<Object?, Object?>)['text'], _token);
    expect(store.values.values.any((value) => value.contains(_token)), isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byType(SelectableText), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.byType(SelectableText), findsOneWidget);

    await text(tester, 'Done');
    expect(find.text('Provisioning'), findsOneWidget);
    expect(find.byType(SelectableText), findsNothing);
    await text(tester, 'Revoke');
    await text(tester, 'Cancel');
    expect(keys.revoked, 0);
    await text(tester, 'Revoke');
    await text(tester, 'Revoke');
    expect(keys.revoked, 1);
    expect(find.text('No API keys yet.'), findsOneWidget);
    expect((state.current! as RestAccount).client.tokens, isNotNull);
    await close(tester, fake, state);
  });

  for (final code in [
    'two_factor_required',
    'invalid_password',
    'validation_failed',
    'http_404',
  ]) {
    testWidgets('$code keeps the form and signed-in session', (tester) async {
      final keys = _Keys()..refusal = code;
      final (fake, state, _) = await open(tester, keys);
      await createForm(tester);
      await text(tester, 'Create API key');
      expect(find.text('New API key'), findsOneWidget);
      expect(
        tester.widget<TextField>(field('Current password')).controller!.text,
        isEmpty,
      );
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      if (code == 'two_factor_required') {
        expect(find.text('Sign in with a code'), findsOneWidget);
      } else if (code == 'validation_failed') {
        expect(find.text('permissions: scope invalid'), findsOneWidget);
      } else if (code == 'http_404') {
        expect(
          find.text(
            'API keys are not available for this mailbox on this server.',
          ),
          findsOneWidget,
        );
      } else {
        expect(
          find.textContaining('current password of the account'),
          findsOneWidget,
        );
      }
      await close(tester, fake, state);
    });
  }
}
