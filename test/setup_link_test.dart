import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

/// The app opened with a setup link starts setting that server up, the code
/// already filled in.
void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  const code = FakeAccounts.setupCode;
  final withServer = Uri.parse(
    'restmail://setup?server=https%3A%2F%2F${FakeAccounts.host}&token=$code',
  );
  final withoutServer = Uri.parse('restmail://setup?token=$code');

  final webLink = Uri.parse(
    'https://rest-mail.com/setup#server=https%3A%2F%2F${FakeAccounts.host}&token=$code',
  );

  group('AppState.openLink', () {
    AppState newState() => AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => FakeRestmail().client,
    );

    test('a setup link waits, once', () {
      final state = newState();
      state.openLink(withServer);
      expect(state.pendingSetup?.code, code);
      expect(state.pendingSetup?.server?.host, FakeAccounts.host);
      expect(state.takePendingSetup()?.code, code);
      expect(state.pendingSetup, isNull);
      // The same link again (at launch and from the stream) is not a second.
      state.openLink(withServer);
      expect(state.pendingSetup, isNull);
    });

    test('a web link is a setup link too', () {
      final state = newState();
      state.openLink(webLink);
      expect(state.pendingSetup?.code, code);
      expect(state.pendingSetup?.server?.host, FakeAccounts.host);
    });

    test('anything else is ignored', () {
      final state = newState();
      for (final link in [
        'restmail://reset?token=$code',
        'https://example.com/setup?token=$code',
        'https://rest-mail.com/#token=$code',
        'restmail://setup?token=nope',
      ]) {
        state.openLink(Uri.parse(link));
      }
      expect(state.pendingSetup, isNull);
    });
  });

  Future<(FakeRestmail, AppState)> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final fake = FakeRestmail(scenario: FakeScenario.unclaimed);
    final state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () => fake.client,
    );
    await state.start();
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
    return (fake, state);
  }

  testWidgets('a link naming the server opens its setup, code filled in', (
    tester,
  ) async {
    final (fake, state) = await openApp(tester);
    state.openLink(withServer);
    await tester.pumpAndSettle();

    expect(find.text('Set up ${FakeAccounts.host}'), findsWidgets);
    expect(find.text(code), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
  });

  testWidgets('a link naming no server asks which, then opens its setup', (
    tester,
  ) async {
    final (fake, state) = await openApp(tester);
    state.openLink(withoutServer);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), FakeAccounts.host);
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use this server'));
    await tester.pumpAndSettle();

    expect(find.text('Set up ${FakeAccounts.host}'), findsWidgets);
    expect(find.text(code), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    fake.close();
  });
}
