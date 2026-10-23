import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

class _PermissionTransport extends http.BaseClient {
  _PermissionTransport(this.inner);
  final http.Client inner;
  final grantQueries = <Map<String, String>>[];
  final mailboxOffsets = <int>[];
  final created = <Map<String, dynamic>>[];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (request.url.path.endsWith('/admin/grants')) {
      if (request.method == 'GET') {
        grantQueries.add({...request.url.queryParameters});
      } else if (request.method == 'POST' && request is http.Request) {
        created.add(jsonDecode(request.body) as Map<String, dynamic>);
      }
    }
    if (request.method == 'GET' &&
        request.url.path.endsWith('/admin/mailboxes')) {
      mailboxOffsets.add(
        int.parse(request.url.queryParameters['offset'] ?? '0'),
      );
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<void> reveal(WidgetTester tester, Finder target) async {
    for (final delta in [-250.0, 250.0]) {
      for (var i = 0; i < 25 && target.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(target.first);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String text) async {
    final target = find.text(text);
    await reveal(tester, target);
    await tester.tap(target.last);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String key, String value) async {
    final field = find.byKey(ValueKey(key));
    await reveal(tester, field);
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<(FakeRestmail, AppState, _PermissionTransport)> open(
    WidgetTester tester, {
    bool readOnly = false,
    bool manyAccounts = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    if (manyAccounts) {
      for (var i = 0; i < 205; i++) {
        fake.addAccount(
          'bulk${i.toString().padLeft(3, '0')}@${FakeAccounts.host}',
        );
      }
    }
    final email = readOnly
        ? 'permissions-reader@${FakeAccounts.host}'
        : FakeAccounts.adminEmail;
    if (readOnly) {
      fake.addAccount(email, capabilities: {Capability.usersRead});
    }
    final transport = _PermissionTransport(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => transport,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: email,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mailboxes'));
    await tester.pumpAndSettle();
    await tap(tester, 'Administration');
    await tap(tester, 'Permissions');
    return (fake, state, transport);
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
    'holder and scope filters are applied together and can be cleared',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      final client = (state.current! as RestAccount).client;
      final ownId = (await client.accounts()).firstWhere((a) => a.isPrimary).id;
      await enter(tester, 'grant-holder-filter', '$ownId');
      await enter(tester, 'grant-scope-filter', ' * ');
      await tap(tester, 'Filter grants');
      expect(transport.grantQueries.last, {
        'holder_kind': 'account',
        'holder_id': '$ownId',
        'scope': '*',
        'offset': '0',
        'limit': '100',
      });
      final calls = transport.grantQueries.length;
      await enter(tester, 'grant-holder-filter', 'not-a-number');
      await tap(tester, 'Filter grants');
      expect(find.text('Enter a valid account number.'), findsOneWidget);
      expect(transport.grantQueries.length, calls);
      await tap(tester, 'Clear filters');
      expect(transport.grantQueries.last, {'offset': '0', 'limit': '100'});
      expect(find.text('Enter a valid account number.'), findsNothing);
      expect(client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'account picker loads past200; manual ID can create and remove an eligible grant',
    (tester) async {
      final (fake, state, transport) = await open(tester, manyAccounts: true);
      expect(transport.mailboxOffsets, contains(200));
      await tap(tester, 'Grant a role');
      final picker = tester.widget<DropdownButton<int>>(
        find.byWidgetPredicate((w) => w is DropdownButton<int>),
      );
      const address = 'bulk204@${FakeAccounts.host}';
      final target = picker.items!
          .firstWhere((item) => (item.child as Text).data == address)
          .value!;
      await tap(tester, 'Enter an account number');
      await enter(tester, 'grant-holder-id', '$target');
      await tap(tester, 'Choose a role');
      await tester.tap(find.text('admin').last);
      await tester.pumpAndSettle();
      await tap(tester, 'A domain');
      await enter(tester, 'grant-scope-name', FakeAccounts.host);
      await tap(tester, 'Eligible');
      await tap(tester, 'A day');
      await tap(tester, 'Grant');
      expect(transport.created, hasLength(1));
      final body = transport.created.single;
      expect(body['holder'], {'kind': 'account', 'id': target});
      expect(body['role'], 'admin');
      expect(body['scope'], 'domain:${FakeAccounts.host}');
      expect(body['mode'], 'eligible');
      expect(
        DateTime.parse(body['expires_at'] as String)
            .isAfter(DateTime.now().toUtc().add(const Duration(hours: 23))),
        isTrue,
      );
      final client = (state.current! as RestAccount).client;
      final grants = await client.grants(holder: GrantHolder.account(target));
      expect(grants.items, hasLength(1));
      expect(grants.items.single.mode, GrantMode.eligible);
      expect(grants.items.single.scope, 'domain:${FakeAccounts.host}');
      final remove = find.byTooltip('Remove admin from $address');
      await reveal(tester, remove);
      await tester.tap(remove);
      await tester.pumpAndSettle();
      await tap(tester, 'Remove');
      expect(
        (await client.grants(holder: GrantHolder.account(target))).items,
        isEmpty,
      );
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'users read can inspect roles/capabilities without mailbox reads or grant writes',
    (tester) async {
      final (fake, state, transport) = await open(tester, readOnly: true);
      expect(find.text('Grant a role'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is Tooltip && (w.message ?? '').startsWith('Remove '),
        ),
        findsNothing,
      );
      expect(transport.mailboxOffsets, isEmpty);
      await tap(tester, 'Roles');
      expect(find.text('superadmin'), findsOneWidget);
      expect(find.text('admin'), findsOneWidget);
      await tap(tester, 'Capabilities');
      await reveal(tester, find.text(Capability.usersRead));
      expect(find.text(Capability.usersRead), findsOneWidget);
      expect(transport.created, isEmpty);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );
}
