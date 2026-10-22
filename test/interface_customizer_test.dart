import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/interface_prefs.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets(
    'the interface customiser pages screens and saves their choices',
    (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final fake = FakeRestmail();
      final state = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => fake.client,
      );
      await state.start();
      await tester.pumpWidget(RestmailApp(state: state));

      await tester.tap(find.text('Add an account'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), FakeAccounts.email);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).at(1),
        FakeAccounts.password,
      );
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('App settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Customize screens'));
      await tester.pumpAndSettle();

      expect(find.text('Interface'), findsOneWidget);
      expect(find.text('MESSAGE LIST'), findsOneWidget);
      expect(find.text('TODAY'), findsNothing);

      // The list page's components are live: date separators change the
      // picture above them.
      await tester.tap(find.byType(RmSwitch).first);
      await tester.pumpAndSettle();
      expect(state.settings.interface.isOn(dateSeparatorsPanel), isTrue);
      expect(find.text('TODAY'), findsOneWidget);

      // Swipe to the reader and back to the list with the tabs.
      await tester.tap(find.text('Reader'));
      await tester.pumpAndSettle();
      expect(find.text('READING VIEW'), findsOneWidget);
      expect(find.text('Sender verification'), findsOneWidget);
      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      // A preset writes the whole set at once.
      await tester.tap(find.text('Presets'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Triage'));
      await tester.pumpAndSettle();
      expect(state.settings.interface.isOn(dateSeparatorsPanel), isTrue);
      expect(
        state.settings.interface.choice(senderTrustPanel, trustShowForOption),
        'warnings',
      );

      await tester.pumpWidget(const SizedBox());
      state.mailbox?.dispose();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
