import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

class _SenderTransport extends http.BaseClient {
  _SenderTransport(this.inner);
  final http.Client inner;
  Completer<void>? holdAllow;
  var refuseAllow = false;
  var refuseDelete = false;
  var creatorInList = false;
  final reads = <String, int>{};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    final list = path.endsWith('/allowlist')
        ? 'allowlist'
        : path.endsWith('/blocklist')
        ? 'blocklist'
        : null;
    if (request.method == 'GET' && list != null) {
      reads.update(list, (n) => n + 1, ifAbsent: () => 1);
      if (list == 'allowlist') {
        await holdAllow?.future;
        if (refuseAllow) return _forbidden();
      }
      if (creatorInList) {
        final response = await inner.send(request);
        final body = jsonDecode(
          utf8.decode(await response.stream.toBytes()),
        ) as Map<String, dynamic>;
        for (final rule in body['data'] as List<dynamic>) {
          (rule as Map<String, dynamic>)['created_by'] = 88;
        }
        return http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode(body))),
          response.statusCode,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    if (request.method == 'DELETE' &&
        (path.contains('/allowlist/') || path.contains('/blocklist/')) &&
        refuseDelete) {
      return _forbidden();
    }
    return inner.send(request);
  }

  http.StreamedResponse _forbidden() => http.StreamedResponse(
    Stream.value(
      utf8.encode(
        jsonEncode({
          'error': {'code': 'forbidden', 'message': 'Permission denied'},
        }),
      ),
    ),
    403,
    headers: {'content-type': 'application/json'},
  );
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<void> reveal(WidgetTester tester, Finder target) async {
    for (final delta in [-250.0, 250.0]) {
      for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
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
    await tester.tap(target.first);
    await tester.pumpAndSettle();
  }

  Future<(FakeRestmail, AppState, _SenderTransport)> open(
    WidgetTester tester, {
    bool readOnly = false,
    bool creatorInList = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final transport = _SenderTransport(fake.client)
      ..creatorInList = creatorInList;
    final email = readOnly
        ? 'sender-reader@${FakeAccounts.host}'
        : FakeAccounts.adminEmail;
    if (readOnly)
      fake.addAccount(email, capabilities: {Capability.domainsRead});
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
    await tap(tester, 'Domains');
    await tap(tester, FakeAccounts.host);
    await tap(tester, 'Sender lists');
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
    'list switching removes old rows; a late answer cannot replace the latest list',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      expect(find.text('@deals.test'), findsOneWidget);
      transport.holdAllow = Completer<void>();
      await tester.tap(find.text('Let in'));
      await tester.pump();
      expect(find.text('@deals.test'), findsNothing);
      expect(find.text('ana@harbor.test'), findsNothing);
      expect(find.text('Let a sender in'), findsNothing);
      expect(find.byTooltip('Remove @deals.test'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Turned away'));
      await tester.pumpAndSettle();
      expect(find.text('@deals.test'), findsOneWidget);
      transport.holdAllow!.complete();
      transport.holdAllow = null;
      await tester.pumpAndSettle();
      expect(find.text('@deals.test'), findsOneWidget);
      expect(find.text('ana@harbor.test'), findsNothing);
      expect(transport.reads['allowlist'], 1);
      expect(transport.reads['blocklist'], 2);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'a refused list cannot expose old removal or add actions; retry recovers',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      transport.refuseAllow = true;
      await tap(tester, 'Let in');
      expect(find.text(noPermission), findsOneWidget);
      expect(find.text('@deals.test'), findsNothing);
      expect(find.text('Let a sender in'), findsNothing);
      expect(find.byTooltip('Remove @deals.test'), findsNothing);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      transport.refuseAllow = false;
      await tap(tester, 'Try again');
      expect(find.text('ana@harbor.test'), findsOneWidget);
      expect(find.text('Let a sender in'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets('details display every rule field and the recorded creator', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester, creatorInList: true);
    final rule = fake.senderRules.firstWhere((r) => r.pattern == '@deals.test');
    await tap(tester, '@deals.test');
    expect(find.text('Sender rule'), findsOneWidget);
    expect(find.text('Rule ID'), findsOneWidget);
    expect(find.text('${rule.id}'), findsOneWidget);
    expect(find.text('Domain ID'), findsOneWidget);
    expect(find.text('Created by'), findsOneWidget);
    expect(find.text('Account 88'), findsOneWidget);
    expect(find.text(rule.reason), findsWidgets);
    expect(
      find.text(rule.createdAt.toLocal().toIso8601String()),
      findsOneWidget,
    );
    expect(find.byType(SelectableText), findsNWidgets(3));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await close(tester, fake, state);
  });

  testWidgets(
    'duplicate sender409 stays on the form; the same sender may be on both lists',
    (tester) async {
      final (fake, state, _) = await open(tester);
      final before = fake.senderRules.length;
      await tap(tester, 'Turn a sender away');
      await tester.enterText(find.byType(TextField).first, '@deals.test');
      await tap(tester, 'Turn away');
      expect(
        find.textContaining('Sender is already on the blocklist'),
        findsOneWidget,
      );
      expect(fake.senderRules.length, before);
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tap(tester, 'Let in');
      await tap(tester, 'Let a sender in');
      await tester.enterText(find.byType(TextField).first, '@deals.test');
      await tester.enterText(
        find.byType(TextField).at(1),
        'Reviewed exception',
      );
      await tap(tester, 'Let in');
      expect(
        fake.senderRules
            .where((r) => r.pattern == '@deals.test')
            .map((r) => r.list)
            .toSet(),
        {'allow', 'block'},
      );
      expect(find.text('Reviewed exception'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'refused deletion keeps the rule and session; cancellation sends no mutation',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      final before = fake.senderRules.length;
      await tester.tap(find.byTooltip('Remove @deals.test'));
      await tester.pumpAndSettle();
      await tap(tester, 'Cancel');
      expect(fake.senderRules.length, before);
      transport.refuseDelete = true;
      await tester.tap(find.byTooltip('Remove @deals.test'));
      await tester.pumpAndSettle();
      await tap(tester, 'Remove');
      expect(find.text(noPermission), findsOneWidget);
      expect(fake.senderRules.length, before);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );

  testWidgets('read-only session can inspect metadata with no mutations', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester, readOnly: true);
    expect(find.text('Turn a sender away'), findsNothing);
    expect(find.byTooltip('Remove @deals.test'), findsNothing);
    await tap(tester, '@deals.test');
    expect(find.text('Not recorded'), findsOneWidget);
    expect(find.text('Created by'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tap(tester, 'Let in');
    expect(find.text('ana@harbor.test'), findsOneWidget);
    expect(find.text('Let a sender in'), findsNothing);
    expect(find.byTooltip('Remove ana@harbor.test'), findsNothing);
    await close(tester, fake, state);
  });
}
