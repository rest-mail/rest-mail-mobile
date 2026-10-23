import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/state/app_scope.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/tokens.dart';
import 'package:restmail/ui/admin/filter_editors.dart';
import 'package:restmail/ui/admin/pipelines_screen.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// Only preview execution is a response fixture; definition CRUD and permission
/// checks go through FakeRestmail. No local JavaScript execution is simulated.
class _PreviewClient extends http.BaseClient {
  _PreviewClient(this.inner);
  final http.Client inner;
  Object validation = const {
    'valid': false,
    'error': 'Unexpected token',
    'phase': 'syntax',
  };
  int? refusal;
  Map<String, dynamic>? request;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/custom-filters/validate')) {
      this.request = jsonDecode(
        utf8.decode(await request.finalize().toBytes()),
      ) as Map<String, dynamic>;
      return http.StreamedResponse(
        Stream.value(
          utf8.encode(
            jsonEncode(
              refusal == null
                  ? validation
                  : {
                      'error': {'code': 'forbidden', 'message': 'Refused'},
                    },
            ),
          ),
        ),
        refusal ?? 200,
        headers: {'content-type': 'application/json'},
      );
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);
  Future<(FakeRestmail, AppState, RestAccount, _PreviewClient)> open(
    WidgetTester tester,
    Widget Function(RestAccount) screen, {
    bool readonly = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    if (readonly)
      fake.grant(FakeAccounts.adminEmail, {Capability.pipelinesRead});
    final transport = _PreviewClient(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => transport,
    );
    await state.start();
    await state.signIn(
      server: Uri.parse('https://${FakeAccounts.host}'),
      email: FakeAccounts.adminEmail,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    final account = state.current! as RestAccount;
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: ThemeData(extensions: const [RmColors.light]),
          home: screen(account),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (fake, state, account, transport);
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

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    for (final delta in [-300.0, 300.0]) {
      for (var i = 0; i < 20 && finder.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(ListView).last, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String label) async {
    final finder = find.text(label).last;
    await reveal(tester, finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String label, String text) async {
    final finder = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.labelText == label,
    );
    await reveal(tester, finder);
    await tester.enterText(finder, text);
    await tester.pump();
  }

  testWidgets('native pipeline create edits and retains all filter fields', (
    tester,
  ) async {
    final (fake, state, _, _) = await open(
      tester,
      (account) => PipelinesScreen(account: account),
    );
    final before = fake.pipelines.length;
    await tap(tester, 'Add a pipeline');
    await enter(tester, 'Domain ID', '${fake.domains.first.id}');
    await tap(tester, 'Add a filter step');
    await enter(tester, 'Filter name', 'sieve');
    await enter(
      tester,
      'Configuration (JSON object)',
      '{"script":"keep;","extra":{"value":true}}',
    );
    await tap(tester, 'Always run');
    await tap(tester, 'Use step');
    await tap(tester, 'Save');
    expect(fake.pipelines, hasLength(before + 1));
    final created = fake.pipelines.last;
    expect(created.active, isFalse);
    expect(created.filters.single['unskippable'], isTrue);
    expect(created.filters.single['config'], {
      'script': 'keep;',
      'extra': {'value': true},
    });
    expect(find.text('Edit pipeline'), findsOneWidget);
    await tap(tester, 'Edit pipeline');
    await tester.tap(find.byTooltip('Remove step'));
    await tester.pumpAndSettle();
    await tap(tester, 'Save');
    expect(created.filters, isEmpty);
    await close(tester, fake, state);
  });
  testWidgets(
    'custom filter creates, opens fresh detail and edits configuration',
    (tester) async {
      final (fake, state, _, _) = await open(
        tester,
        (account) => CustomFiltersScreen(account: account),
      );
      await tap(tester, 'Add a custom filter');
      await enter(tester, 'Domain ID', '${fake.domains.first.id}');
      await enter(tester, 'Name', 'Native filter');
      await enter(tester, 'Description', 'Created on phone');
      await enter(
        tester,
        'Configuration (JSON object)',
        '{"script":"function filter(email) { return {action: \'continue\'}; }"}',
      );
      await tap(tester, 'Save');
      expect(fake.customFilters.last.name, 'Native filter');
      expect(fake.customFilters.last.enabled, isFalse);
      expect(find.text('Edit custom filter'), findsOneWidget);
      await tap(tester, 'Edit custom filter');
      await enter(tester, 'Name', 'Edited filter');
      await enter(tester, 'Description', '');
      await enter(
        tester,
        'Configuration (JSON object)',
        '{"script":"updated","nested":[1,true]}',
      );
      await tap(tester, 'Save');
      expect(fake.customFilters.last.name, 'Edited filter');
      expect(fake.customFilters.last.description, '');
      expect(fake.customFilters.last.config, {
        'script': 'updated',
        'nested': [1, true],
      });
      await close(tester, fake, state);
    },
  );
  testWidgets(
    'local invalid JSON stays editable without creating a definition',
    (tester) async {
      final (fake, state, _, _) = await open(
        tester,
        (account) => CustomFilterEditorScreen(account: account),
      );
      final count = fake.customFilters.length;
      await enter(tester, 'Domain ID', '${fake.domains.first.id}');
      await enter(tester, 'Name', 'Invalid');
      await enter(tester, 'Configuration (JSON object)', '[]');
      await tap(tester, 'Save');
      expect(find.text('Configuration must be a JSON object.'), findsOneWidget);
      expect(fake.customFilters, hasLength(count));
      await close(tester, fake, state);
    },
  );
  testWidgets(
    'validation distinguishes syntax and execution failures and preserves session on 403',
    (tester) async {
      final (fake, state, account, transport) = await open(
        tester,
        (account) => FilterPreviewScreen(account: account, script: 'broken'),
      );
      await tap(tester, 'Validate');
      expect(find.text('Syntax failed: Unexpected token'), findsOneWidget);
      expect(transport.request!['script'], 'broken');
      transport.validation = {
        'valid': true,
        'phase': 'execution',
        'dry_run': {
          'error': 'execution timeout',
          'logs': ['before'],
        },
      };
      await tap(tester, 'Validate');
      expect(
        find.text('Syntax valid; dry run failed: execution timeout'),
        findsOneWidget,
      );
      transport.refusal = 403;
      await tap(tester, 'Validate');
      expect(find.text("You don't have permission for this"), findsOneWidget);
      expect(account.client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );
  testWidgets(
    'read-only pipeline operators have no create edit or preview actions',
    (tester) async {
      final (fake, state, _, _) = await open(
        tester,
        (account) => PipelinesScreen(account: account),
        readonly: true,
      );
      expect(find.text('Add a pipeline'), findsNothing);
      await tap(tester, 'Coming in · 7 filters');
      expect(find.text('Edit pipeline'), findsNothing);
      expect(find.text('Preview saved pipeline'), findsNothing);
      expect(find.text('Delete pipeline'), findsNothing);
      await close(tester, fake, state);
    },
  );
}
