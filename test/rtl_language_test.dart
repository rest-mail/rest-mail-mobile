import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show Intl;
import 'package:restmail/app.dart';
import 'package:restmail/l10n/voice.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);

  for (final (language, region, addAccount, email) in [
    ('ar', 'SA', 'إضافة حساب', 'عنوان البريد الإلكتروني'),
    ('fa', 'IR', 'افزودن حساب', 'نشانی ایمیل'),
  ]) {
    for (final useSystem in [false, true]) {
      testWidgets(
        '$language uses RTL with ${useSystem ? 'system' : 'saved'} language',
        (tester) async {
          tester.view.physicalSize = const Size(1170, 2532);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);
          final deviceLocale = useSystem
              ? Locale(language, region)
              : const Locale('en');
          tester.binding.platformDispatcher.localeTestValue = deviceLocale;
          tester.binding.platformDispatcher.localesTestValue = [deviceLocale];
          addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
          addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
          addTearDown(() => Intl.defaultLocale = 'en');

          final fake = FakeRestmail();
          addTearDown(fake.close);
          final state = AppState(
            store: MemoryKeyValueStore(),
            httpClientFactory: () => fake.client,
          );
          await state.start();
          if (!useSystem) {
            await state.updateSettings(
              state.settings.copyWith(languageCode: language),
            );
          }
          await tester.pumpWidget(RestmailApp(state: state));
          await tester.pumpAndSettle();

          expect(find.text(addAccount), findsOneWidget);
          final welcome = tester.element(find.text(addAccount));
          expect(Localizations.localeOf(welcome).languageCode, language);
          expect(Directionality.of(welcome), TextDirection.rtl);
          expect(Intl.defaultLocale, language);

          await tester.tap(find.text(addAccount));
          await tester.pumpAndSettle();
          expect(find.text(email), findsOneWidget);
          final signIn = tester.element(find.byType(TextField).first);
          expect(Directionality.of(signIn), TextDirection.rtl);
          expect(
            MaterialLocalizations.of(signIn).cancelButtonLabel,
            isNot('Cancel'),
          );
          expect(tester.takeException(), isNull);

          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 5));
        },
      );
    }
  }

  test('the language picker names Arabic and Farsi in their own scripts', () {
    expect(languageLabel('ar'), 'العربية');
    expect(languageLabel('fa'), 'فارسی');
  });
}
