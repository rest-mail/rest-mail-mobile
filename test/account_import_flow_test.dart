import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/admin/admin_widgets.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

const _hash =
    r'{SHA512-CRYPT}$6$importsalt$ObInO4qcr134i8FQT.XNC6Ma04n9aRTAUNHmm8Yb1idoDBOXKoDTmdosY1xwfageGXo4ZSSrkIPRk9zMWfsG7/';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  testWidgets(
    'an administrator imports a password, sees validation, and cannot reuse a credential across modes',
    (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final fake = FakeRestmail();
      final store = MemoryKeyValueStore();
      final state = AppState(
        store: store,
        httpClientFactory: () => fake.client,
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

      Future<void> tap(String text) async {
        final candidates = find.text(text);
        if (find.byType(AdminFormScreen).evaluate().isNotEmpty) {
          await tester.scrollUntilVisible(
            candidates,
            150,
            scrollable: find
                .descendant(
                  of: find.byType(AdminFormScreen),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
        }
        final finder = candidates.last;
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      Future<Finder> field(int index) async {
        final finder = find.byKey(ValueKey('admin-field-$index'));
        await tester.scrollUntilVisible(
          finder,
          150,
          scrollable: find
              .descendant(
                of: find.byType(AdminFormScreen),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();
        return finder;
      }

      await tester.tap(find.byTooltip('Mailboxes'));
      await tester.pumpAndSettle();
      await tap('Administration');
      await tap('Mailboxes');
      await tap('Add a mailbox');
      await tester.enterText(await field(0), 'import@${FakeAccounts.host}');
      await tester.enterText(await field(1), 'Imported');
      await tester.enterText(await field(3), 'discard-this-password');
      await tap('Imported password hash');
      expect(
        tester.widget<TextField>(await field(3)).controller!.text,
        isEmpty,
      );
      final secret = tester.widget<TextField>(await field(3));
      expect(secret.obscureText, isTrue);
      expect(secret.autocorrect, isFalse);
      expect(secret.enableSuggestions, isFalse);

      await tester.enterText(await field(3), '{PLAIN}private-password');
      await tap('Add mailbox');
      expect(find.textContaining('use a valid BLF-CRYPT'), findsOneWidget);
      expect(fake.hasMailbox('import@${FakeAccounts.host}'), isFalse);
      await tester.enterText(await field(3), _hash);
      await tap('Add mailbox');
      expect(fake.hasMailbox('import@${FakeAccounts.host}'), isTrue);
      expect(fake.passwordOf('import@${FakeAccounts.host}'), isNull);
      expect(find.text(_hash), findsNothing);

      final imported = RestmailClient(
        server: Uri.parse('https://${FakeAccounts.host}'),
        httpClient: fake.client,
      );
      await imported.login(
        email: 'import@${FakeAccounts.host}',
        password: 'old-password',
      );
      imported.close();
      await tester.pumpWidget(const SizedBox());
      state.dispose();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
