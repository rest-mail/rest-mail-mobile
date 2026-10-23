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

class _PolicyTransport extends http.BaseClient {
  _PolicyTransport(this.inner);
  final http.Client inner;
  var refuseRead = false;
  var refuseWrite = false;
  var writes = 0;
  Completer<void>? holdRead;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/mta-sts')) {
      if (request.method == 'GET') {
        await holdRead?.future;
        if (refuseRead) return _error(403, 'forbidden', 'Permission denied');
      }
      if (request.method == 'PUT') {
        writes++;
        if (refuseWrite) {
          return _error(
            422,
            'validation_failed',
            'Request body failed validation',
            {
              'fields': {'max_age': 'Try a shorter lifetime'},
            },
          );
        }
      }
    }
    return inner.send(request);
  }

  http.StreamedResponse _error(
    int status,
    String code,
    String message, [
    Map<String, Object?>? details,
  ]) => http.StreamedResponse(
    Stream.value(
      utf8.encode(
        jsonEncode({
          'error': {'code': code, 'message': message, 'details': ?details},
        }),
      ),
    ),
    status,
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

  Future<(FakeRestmail, AppState, _PolicyTransport)> open(
    WidgetTester tester, {
    bool readOnly = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail();
    final transport = _PolicyTransport(fake.client);
    final email = readOnly
        ? 'policy-reader@${FakeAccounts.host}'
        : FakeAccounts.adminEmail;
    if (readOnly) {
      fake.addAccount(email, capabilities: {Capability.domainsRead});
    }
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
    await tap(tester, 'MTA-STS');
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

  Future<void> seconds(WidgetTester tester, String value) async {
    final field = find.byKey(const ValueKey('mta-sts-max-age'));
    await reveal(tester, field);
    await tester.enterText(field, value);
    await tester.pump();
  }

  testWidgets(
    'custom seconds, zero and large lifetimes round-trip without rounding',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      final domain = fake.domains.firstWhere(
        (d) => d.name == FakeAccounts.host,
      );
      for (final value in ['12345', '0', '9223372036854775807']) {
        await tap(tester, 'Change the policy');
        await seconds(tester, value);
        await tap(tester, 'Save');
        expect(domain.mtaSts!.maxAge, int.parse(value));
        await reveal(tester, find.text('$value seconds'));
        expect(find.text('$value seconds'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      }
      await tap(tester, 'Change the policy');
      final before = transport.writes;
      for (final invalid in ['-1', '1.5', '', '9223372036854775808']) {
        await seconds(tester, invalid);
        await tap(tester, 'Save');
        expect(
          find.text('Enter a whole number of seconds, 0 or more.'),
          findsOneWidget,
        );
        expect(transport.writes, before);
      }
      await seconds(tester, '71');
      await tap(tester, 'Save');
      expect(domain.mtaSts!.maxAge, 71);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      await close(tester, fake, state);
    },
  );

  testWidgets('create an unpublished zero-lifetime policy with no MX hosts', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);
    final domain = fake.domains.firstWhere((d) => d.name == FakeAccounts.host);
    await tap(tester, 'Delete policy');
    await tap(tester, 'Delete');
    // The toast goes first: it sits over the form's Save.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tap(tester, 'Set up a policy');
    await tap(tester, 'None');
    await seconds(tester, '0');
    final published = find.byType(RmSwitch);
    await reveal(tester, published);
    await tester.tap(published);
    await tester.pumpAndSettle();
    await tap(tester, 'Save');
    expect(domain.mtaSts!.mode, 'none');
    expect(domain.mtaSts!.maxAge, 0);
    expect(domain.mtaSts!.active, isFalse);
    expect(domain.mtaSts!.mxHosts, isEmpty);
    await tap(tester, 'Refresh policy');
    for (final label in ['Policy ID', 'Domain ID', 'Added', 'Changed']) {
      await reveal(tester, find.text(label));
      expect(find.text(label), findsOneWidget);
    }
    await close(tester, fake, state);
  });

  testWidgets(
    'pending and refused refresh removes stale values and actions, retry restores them',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      transport.holdRead = Completer<void>();
      transport.refuseRead = true;
      final refresh = find.text('Refresh policy');
      await reveal(tester, refresh);
      await tester.tap(refresh);
      await tester.pump();
      expect(find.text('Testing'), findsNothing);
      expect(find.text('Change the policy'), findsNothing);
      expect(find.text('Delete policy'), findsNothing);
      expect(find.byType(RmSwitch), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      transport.holdRead!.complete();
      transport.holdRead = null;
      await tester.pumpAndSettle();
      expect(find.text(noPermission), findsOneWidget);
      expect(find.text('Set up a policy'), findsNothing);
      expect((state.current! as RestAccount).client.tokens, isNotNull);
      transport.refuseRead = false;
      await tap(tester, 'Try again');
      expect(find.text('Testing'), findsOneWidget);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'server field errors keep the editor open and preserve saved policy',
    (tester) async {
      final (fake, state, transport) = await open(tester);
      final policy = fake.domains
          .firstWhere((d) => d.name == FakeAccounts.host)
          .mtaSts!;
      final before = policy.maxAge;
      await tap(tester, 'Change the policy');
      await seconds(tester, '71');
      transport.refuseWrite = true;
      await tap(tester, 'Save');
      expect(find.textContaining('Try a shorter lifetime'), findsOneWidget);
      expect(policy.maxAge, before);
      transport.refuseWrite = false;
      await seconds(tester, '72');
      expect(find.textContaining('Try a shorter lifetime'), findsNothing);
      await tap(tester, 'Save');
      expect(policy.maxAge, 72);
      await close(tester, fake, state);
    },
  );

  testWidgets(
    'read-only policy viewer has fresh metadata and no write actions',
    (tester) async {
      final (fake, state, transport) = await open(tester, readOnly: true);
      expect(find.byType(RmSwitch), findsNothing);
      expect(find.text('Change the policy'), findsNothing);
      expect(find.text('Delete policy'), findsNothing);
      await tap(tester, 'Refresh policy');
      expect(find.text('Testing'), findsOneWidget);
      expect(transport.writes, 0);
      await close(tester, fake, state);
    },
  );
}
