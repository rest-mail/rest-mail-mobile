import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/interface_prefs.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/trust_receipt.dart';
import 'package:restmail/ui/widgets/trust_badge.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _labels = {
  'intact': 'Message unchanged since this server accepted it',
  'mismatch': 'Message changed since this server accepted it',
  'not_sealed': 'Not sealed',
  'checking': 'Checking receipt seal',
  'unavailable': 'Receipt seal could not be checked',
};
const _explanation =
    'A receipt seal only checks for changes since this server accepted the message; it does not identify the author or establish that the content is safe.';

class _Gate extends http.BaseClient {
  _Gate(this.inner);

  final http.Client inner;
  Completer<void>? hold;
  int? error;
  int calls = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/seal')) {
      calls++;
      await hold?.future;
      if (error case final status?) {
        return http.StreamedResponse(
          Stream.value(
            '{"error":{"code":"unavailable","message":"Unavailable"}}'
                .codeUnits,
          ),
          status,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    return inner.send(request);
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(_Gate, Future<void> Function())> open(
    WidgetTester tester, {
    String seal = 'intact',
    bool checks = true,
    bool hold = false,
    int? error,
    bool draft = false,
    bool warningsOnly = false,
    bool enabled = true,
    bool receipt = true,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.empty);
    final message =
        fake.deliver(
            to: FakeAccounts.email,
            from: 'sender@example.test',
            subject: 'Receipt fixture',
            body: 'Read the receipt',
          )
          ..sealedHash = seal == 'not_sealed' ? null : 'a' * 64
          ..sealMismatch = seal == 'mismatch'
          ..authResults = checks
              ? [
                  for (final method in ['spf', 'dkim', 'arc', 'dmarc'])
                    {
                      'method': method,
                      'result': 'pass',
                      'domain': 'example.test',
                    },
                ]
              : [];
    message.isDraft = draft;
    final gate = _Gate(fake.client)
      ..hold = hold ? Completer<void>() : null
      ..error = error;
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => gate,
    );
    await state.start();
    await state.updateSettings(
      state.settings.copyWith(
        languageCode: 'en',
        interface: const InterfacePrefs()
            .withPanel(senderTrustPanel.id, enabled)
            .withValue(
              senderTrustPanel.id,
              trustDetailOption.id,
              receipt ? 'receipt' : 'chip',
            )
            .withValue(
              senderTrustPanel.id,
              trustShowForOption.id,
              warningsOnly ? 'warnings' : 'all',
            ),
      ),
    );
    await state.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receipt fixture').last);
    await tester.pumpAndSettle();
    Future<void> close() async {
      await tester.pumpWidget(const SizedBox());
      state.dispose();
      gate.hold?.complete();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    }

    return (gate, close);
  }

  void expectOnly(String state) {
    for (final entry in _labels.entries) {
      expect(
        find.text(entry.value),
        entry.key == state ? findsOneWidget : findsNothing,
      );
    }
    expect(find.text(_explanation), findsOneWidget);
  }

  for (final state in ['intact', 'mismatch', 'not_sealed']) {
    testWidgets('the receipt shows $state beside all four stored checks', (
      tester,
    ) async {
      final (gate, close) = await open(tester, seal: state);
      expect(gate.calls, 1);
      expectOnly(state);
      for (final method in ['spf', 'dkim', 'arc', 'dmarc']) {
        expect(find.text(method), findsOneWidget);
      }
      final receipt = tester.widget<RmTrustReceipt>(
        find.byType(RmTrustReceipt),
      );
      expect(receipt.sealedHash, state == 'not_sealed' ? null : 'a' * 64);
      expect(
        find.text('aaaaaaaa…aaaa'),
        state == 'not_sealed' ? findsNothing : findsOneWidget,
      );
      await close();
    });
  }

  testWidgets('hash presence while checking is not verification', (
    tester,
  ) async {
    final (gate, close) = await open(tester, hold: true);
    expectOnly('checking');
    expect(find.text('aaaaaaaa…aaaa'), findsOneWidget);
    gate.hold!.complete();
    gate.hold = null;
    await tester.pumpAndSettle();
    expectOnly('intact');
    await close();
  });

  for (final status in [404, 500]) {
    testWidgets('$status shows unavailable, not mismatch or not sealed', (
      tester,
    ) async {
      final (_, close) = await open(tester, error: status);
      expectOnly('unavailable');
      expect(find.text('aaaaaaaa…aaaa'), findsNothing);
      await close();
    });
  }

  testWidgets('a seal without sender checks still has a receipt', (
    tester,
  ) async {
    final (_, close) = await open(tester, checks: false);
    expectOnly('intact');
    await close();
  });

  testWidgets(
    'warnings-only receipts include a seal mismatch with passing authentication',
    (tester) async {
      final (_, close) = await open(
        tester,
        seal: 'mismatch',
        warningsOnly: true,
      );
      expectOnly('mismatch');
      await close();
    },
  );

  testWidgets('badge-only mode also uses the stored sender checks', (
    tester,
  ) async {
    final (_, close) = await open(tester, receipt: false);
    expect(find.byType(RmTrustBadge), findsOneWidget);
    expect(find.text('signed'), findsOneWidget);
    expect(find.byType(RmTrustReceipt), findsNothing);
    await close();
  });

  testWidgets('the reader can hide the receipt panel', (tester) async {
    final (_, close) = await open(tester, enabled: false);
    expect(find.byType(RmTrustReceipt), findsNothing);
    await close();
  });

  testWidgets('editable drafts do not request an acceptance seal', (
    tester,
  ) async {
    final (gate, close) = await open(tester, draft: true);
    expect(gate.calls, 0);
    for (final label in _labels.values) {
      expect(find.text(label), findsNothing);
    }
    await close();
  });

  testWidgets('closing a checking message ignores its late answer', (
    tester,
  ) async {
    final (_, close) = await open(tester, hold: true);
    expectOnly('checking');
    await close();
    expect(tester.takeException(), isNull);
  });
}
