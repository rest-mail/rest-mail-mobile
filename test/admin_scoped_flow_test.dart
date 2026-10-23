import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/settings_screen.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, MemoryKeyValueStore, List<String>)> open(
    WidgetTester tester, {
    required bool mailboxOnly,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final store = MemoryKeyValueStore();
    final requests = <String>[];
    final state = AppState(
      store: store,
      httpClientFactory: () =>
          _ScopedClient(fake.client, mailboxOnly, requests),
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
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administration'));
    await tester.pumpAndSettle();
    return (fake, state, store, requests);
  }

  Future<void> tap(WidgetTester tester, String text) async {
    for (var i = 0; i < 12 && find.text(text).evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -250));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
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

  testWidgets(
    'a domain session reaches its domain and sender lists, with no global actions',
    (tester) async {
      final (fake, state, _, requests) = await open(tester, mailboxOnly: false);
      final account = state.current! as RestAccount;
      expect(account.capabilities.names, isEmpty);
      expect(account.capabilities.scoped, hasLength(4));
      expect(find.text('Overview'), findsNothing);
      expect(find.text('Certificates'), findsNothing);
      expect(find.text('Permissions'), findsNothing);
      await tap(tester, 'Domains');
      expect(find.text('Add a domain'), findsNothing);
      await tap(tester, FakeAccounts.host);
      await tap(tester, 'Mailbox size');
      await tester.enterText(find.byType(TextField), '250');
      await tester.pump();
      await tap(tester, 'Save');
      expect(
        fake.domains
            .singleWhere((d) => d.name == FakeAccounts.host)
            .defaultQuotaBytes,
        250 * 1024 * 1024,
      );
      await tap(tester, 'Sender lists');
      expect(find.text('Turn a sender away'), findsOneWidget);
      expect(requests.any((r) => r.endsWith('/blocklist')), isTrue);
      expect(requests.any((r) => r.contains('/admin/stats')), isFalse);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'a mailbox session sees only its mailbox and no creation action',
    (tester) async {
      final (fake, state, _, requests) = await open(tester, mailboxOnly: true);
      expect(find.text('Domains'), findsNothing);
      expect(find.text('Aliases'), findsNothing);
      await tap(tester, 'Mailboxes');
      expect(find.text('Add a mailbox'), findsNothing);
      expect(find.text(FakeAccounts.adminEmail), findsNothing);
      await tap(tester, FakeAccounts.email);
      expect(find.text('Domain'), findsNothing);
      await tap(tester, 'Name');
      await tester.enterText(find.byType(TextField), 'Scoped name');
      await tester.pump();
      await tap(tester, 'Save');
      expect(find.text('Scoped name'), findsOneWidget);
      expect(requests.any((r) => r.contains('/admin/domains')), isFalse);
      expect(requests.any((r) => r.contains('/admin/aliases')), isFalse);
      await close(tester, fake, state);
    },
  );

  testWidgets('mailbox creation starts on a writable grant domain', (
    tester,
  ) async {
    final (fake, state, _, _) = await open(tester, mailboxOnly: false);
    final account = state.current! as RestAccount;
    account.capabilities = Capabilities.fromJson(
      [],
      scoped: [
        {'capability': 'mailboxes:write', 'scope': 'domain:managed.test'},
      ],
    );
    unawaited(
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .push<void>(
            MaterialPageRoute(
              builder: (_) => CreateMailboxScreen(
                account: account,
                mailbox: state.mailbox!,
              ),
            ),
          ),
    );
    await tester.pumpAndSettle();
    expect(find.text('@managed.test'), findsOneWidget);
    expect(find.text('@${FakeAccounts.host}'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets(
    'an app restart retains the scoped snapshot without globalizing it',
    (tester) async {
      final (fake, state, store, requests) = await open(
        tester,
        mailboxOnly: true,
      );
      await tester.pumpWidget(const SizedBox());
      state.dispose();
      final restored = AppState(
        store: store,
        httpClientFactory: () => _ScopedClient(fake.client, true, requests),
      );
      await restored.start();
      final account = restored.current! as RestAccount;
      expect(account.capabilities.names, isEmpty);
      expect(account.capabilities.scoped, hasLength(2));
      await tester.pumpWidget(RestmailApp(state: restored));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mailboxes'));
      await tester.pumpAndSettle();
      expect(find.text('Administration'), findsOneWidget);
      await close(tester, fake, restored);
    },
  );
}

/// A scoped server response fixture. Server tenant enforcement has separate
/// PostgreSQL tests in server PR #619; these tests exercise the mobile gates.
class _ScopedClient extends http.BaseClient {
  _ScopedClient(this.inner, this.mailboxOnly, this.requests);
  final http.Client inner;
  final bool mailboxOnly;
  final List<String> requests;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add('${request.method} ${request.url.path}');
    final response = await http.Response.fromStream(await inner.send(request));
    if (response.statusCode != 200 ||
        !(response.headers['content-type'] ?? '').contains(
          'application/json',
        )) {
      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final path = request.url.path;
    if (path.endsWith('/auth/login') || path.endsWith('/auth/refresh')) {
      final data = body['data'] as Map<String, dynamic>;
      data['capabilities'] = <String>[];
      data['scoped_capabilities'] = [
        for (final capability in [
          'mailboxes:read',
          'mailboxes:write',
          if (!mailboxOnly) ...['domains:read', 'domains:write'],
        ])
          {
            'capability': capability,
            'scope': mailboxOnly
                ? 'mailbox:${FakeAccounts.email}'
                : 'domain:${FakeAccounts.host}',
          },
      ];
    }
    if (request.method == 'GET' &&
        body['data'] is List &&
        const [
          '/api/v1/admin/domains',
          '/api/v1/admin/mailboxes',
          '/api/v1/admin/aliases',
        ].contains(path)) {
      final items = (body['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      body['data'] = items
          .where(
            (row) => switch (path.split('/').last) {
              'domains' => !mailboxOnly && row['name'] == FakeAccounts.host,
              'mailboxes' =>
                mailboxOnly
                    ? row['address'] == FakeAccounts.email
                    : (row['address'] as String).endsWith(
                        '@${FakeAccounts.host}',
                      ),
              _ =>
                !mailboxOnly &&
                    (row['source_address'] as String).endsWith(
                      '@${FakeAccounts.host}',
                    ),
            },
          )
          .toList();
      body['pagination'] = {
        'total': (body['data'] as List<dynamic>).length,
        'has_more': false,
      };
    }
    if (mailboxOnly &&
        body['data'] is Map<String, dynamic> &&
        path.contains('/admin/mailboxes/')) {
      (body['data'] as Map<String, dynamic>)['domain'] = {'id': 0, 'name': ''};
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      response.statusCode,
      headers: response.headers,
    );
  }
}
