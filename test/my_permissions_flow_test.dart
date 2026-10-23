import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

final _server = Uri.parse('https://${FakeAccounts.host}');
const _eve = 'eve@${FakeAccounts.host}';

class _OwnPermissionsTransport extends http.BaseClient {
  _OwnPermissionsTransport(this.inner);

  final http.Client inner;
  var refuseMine = false;
  var refreshes = 0;
  Completer<void>? holdNextMine;
  Completer<void>? mineHeld;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.url.path.endsWith('/auth/refresh')) refreshes++;
    if (request.url.path.endsWith('/admin/grants/mine')) {
      if (refuseMine) {
        return http.StreamedResponse(
          Stream.value(
            utf8.encode(
              jsonEncode({
                'error': {'code': 'forbidden', 'message': 'Permission refused'},
              }),
            ),
          ),
          403,
          headers: {'content-type': 'application/json'},
        );
      }
      final hold = holdNextMine;
      holdNextMine = null;
      final response = await inner.send(request);
      if (hold != null) {
        mineHeld?.complete();
        await hold.future;
      }
      return response;
    }
    return inner.send(request);
  }
}

/// My permissions, under Settings → the account, against the fake, which
/// keeps escalation.go's rules: only the holder's own grants, a reason and
/// a fresh code to switch one on, and what the session holds after.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  Future<(FakeRestmail, AppState, _OwnPermissionsTransport)> open(
    WidgetTester tester, {
    DateTime Function()? clock,
    bool active = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(clock: clock)..addAccount(_eve);
    final grantId = fake.addGrant(_eve, 'admin', mode: 'eligible');
    final transport = _OwnPermissionsTransport(fake.client);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => transport,
    );
    await state.start();
    await state.signIn(
      server: _server,
      email: _eve,
      password: FakeAccounts.adminPassword,
      totpCode: FakeAccounts.totpCode,
    );
    if (active) {
      await (state.current! as RestAccount).client.activateGrant(
        grantId,
        reason: 'Temporary maintenance',
        minutes: 1,
        totpCode: FakeAccounts.totpCode,
      );
    }
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state, transport);
  }

  Future<void> tap(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text).last);

  Finder field(String hint) =>
      find.ancestor(of: find.text(hint), matching: find.byType(TextField));

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

  testWidgets('an account holding only an eligible role reaches My '
      'permissions, and switches the role on with a fresh code', (
    tester,
  ) async {
    final (fake, state, _) = await open(tester);

    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await tapText(tester, _eve);
    // Nothing to administer yet, but its own grants are there.
    expect(find.text('Administration'), findsNothing);
    await tapText(tester, 'My permissions');
    expect(find.text('admin · Everywhere'), findsOneWidget);
    expect(find.text('Switch off'), findsNothing);

    await tapText(tester, 'Switch on…');
    await tester.enterText(field('What you need it for'), 'Clearing a bounce');
    await tester.enterText(field('6-digit code'), '000000');
    await tester.pump();
    await tapText(tester, 'Switch on');
    // A wrong code is explained, and the session is still signed in.
    expect(find.textContaining('That code is wrong'), findsOneWidget);
    expect((state.current! as RestAccount).signedOut, isNull);

    await tester.enterText(field('6-digit code'), FakeAccounts.totpCode);
    await tester.pump();
    await tapText(tester, 'Switch on');
    expect(find.textContaining('Switched on admin until'), findsWidgets);
    expect(find.text('Switch off'), findsOneWidget);
    expect(
      (state.current! as RestAccount).capabilities.allows(Capability.queueRead),
      isTrue,
    );

    // Back in Settings, Administration is there now.
    await tap(tester, find.byTooltip('Back').first);
    expect(find.text('Administration'), findsOneWidget);

    await close(tester, fake, state);
  });

  Future<void> permissions(WidgetTester tester) async {
    await tap(tester, find.byTooltip('Mailboxes'));
    await tap(tester, find.byTooltip('Mailbox settings'));
    await tapText(tester, _eve);
    await tapText(tester, 'My permissions');
  }

  testWidgets('an activation deadline reloads permissions and removes the '
      'expired administration entry without a manual refresh', (tester) async {
    var now = DateTime.now();
    final (fake, state, transport) = await open(
      tester,
      clock: () => now,
      active: true,
    );
    await permissions(tester);
    expect(find.text('Switch off'), findsOneWidget);
    final before = transport.refreshes;

    now = now.add(const Duration(minutes: 2));
    await tester.pump(const Duration(minutes: 2));
    await tester.pumpAndSettle();

    expect(transport.refreshes, before + 1);
    expect(find.text('Switch off'), findsNothing);
    expect(find.text('Switch on…'), findsOneWidget);
    final account = state.current! as RestAccount;
    expect(account.capabilities.allows(Capability.queueRead), isFalse);
    expect(account.signedOut, isNull);
    await tap(tester, find.byTooltip('Back').first);
    expect(find.text('Administration'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('resume reconciles an activation that ended in the background '
      'and shares the app refresh request', (tester) async {
    var now = DateTime.now();
    final (fake, state, transport) = await open(
      tester,
      clock: () => now,
      active: true,
    );
    await permissions(tester);
    expect(find.text('Switch off'), findsOneWidget);
    final before = transport.refreshes;

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    now = now.add(const Duration(minutes: 2));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(transport.refreshes, before + 1);
    expect(find.text('Switch off'), findsNothing);
    expect(find.text('Switch on…'), findsOneWidget);
    expect(
      (state.current! as RestAccount).capabilities.allows(Capability.queueRead),
      isFalse,
    );
    await close(tester, fake, state);
  });

  testWidgets('a refused reload clears old grant actions, keeps the session '
      'and can be retried', (tester) async {
    final (fake, state, transport) = await open(tester, active: true);
    await permissions(tester);
    expect(find.text('Switch off'), findsOneWidget);
    transport.refuseMine = true;

    await tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pumpAndSettle();

    expect(find.text('Switch off'), findsNothing);
    expect(find.text('Switch on…'), findsNothing);
    expect(find.text('admin · Everywhere'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);
    expect((state.current! as RestAccount).signedOut, isNull);

    transport.refuseMine = false;
    await tapText(tester, 'Try again');
    expect(find.text('Switch off'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
    await close(tester, fake, state);
  });

  testWidgets('a late earlier grant response cannot restore an expired '
      'activation after a newer reload', (tester) async {
    var now = DateTime.now();
    final (fake, state, transport) = await open(
      tester,
      clock: () => now,
      active: true,
    );
    await permissions(tester);
    final hold = Completer<void>();
    transport
      ..holdNextMine = hold
      ..mineHeld = Completer<void>();
    addTearDown(() {
      if (!hold.isCompleted) hold.complete();
    });
    final first = tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pump();
    expect(transport.mineHeld!.isCompleted, isTrue);
    expect(find.text('Switch off'), findsNothing);

    now = now.add(const Duration(minutes: 2));
    await tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pumpAndSettle();
    expect(find.text('Switch on…'), findsOneWidget);
    hold.complete();
    await first;
    await tester.pumpAndSettle();

    expect(find.text('Switch off'), findsNothing);
    expect(find.text('Switch on…'), findsOneWidget);
    expect(
      (state.current! as RestAccount).capabilities.allows(Capability.queueRead),
      isFalse,
    );
    await close(tester, fake, state);
  });
}
