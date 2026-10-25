import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/l10n/catalog.dart';
import 'package:restmail/l10n/localized_error.dart';
import 'package:restmail/l10n/voice.dart';
import 'package:restmail/state/admin_access.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/interface_prefs.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

void main() {
  test('placeholder-looking user text is preserved verbatim', () {
    expect(
      languageLine(
        'en',
        'compose.quoteSubject',
        args: {
          'subject': 'A subject containing {sender}',
          'sender': 'This must not replace the subject text',
        },
      ),
      'Subject: A subject containing {sender}',
    );
  });
  test('all static interface metadata resolves in every language', () {
    final keys = <String>[
      for (final pack in ThemePack.all) ...[pack.nameKey, pack.taglineKey],
      for (final preset in interfacePresets) ...[
        preset.nameKey,
        preset.descriptionKey,
      ],
      for (final panel in panelRegistry) ...[
        panel.nameKey,
        panel.descriptionKey,
        for (final option in panel.options) ...[
          option.labelKey,
          if (option is ChoiceOption)
            for (final choice in option.values) choice.$2,
        ],
      ],
      for (final section in AdminSection.values) ...[
        section.titleKey,
        section.subtitleKey,
      ],
      for (final group in AdminGroup.values)
        if (group.titleKey != null) group.titleKey!,
    ];
    for (final locale in supportedLocales) {
      for (final key in keys) {
        expect(
          voiceLine(ThemePack.classic, locale, key),
          isNot(key),
          reason: '${locale.languageCode}: $key',
        );
      }
    }
  });

  for (final (language, classic, dateRows, triage) in [
    ('de', 'Klassisch', 'Datumsüberschriften', 'Sichtung'),
    ('ar', 'كلاسيكي', 'فواصل التاريخ', 'الفرز'),
    ('fa', 'کلاسیک', 'جداکننده‌های تاریخ', 'دسته‌بندی'),
  ]) {
    testWidgets('$language translates themes, panels and presets', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final fake = FakeRestmail();
      final state = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => fake.client,
      );
      await state.start();
      await state.updateSettings(
        state.settings.copyWith(languageCode: language),
      );
      await state.signIn(
        server: Uri.parse('https://${FakeAccounts.host}'),
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await tester.pumpWidget(RestmailApp(state: state));
      await tester.pumpAndSettle();

      String line(String key) =>
          voiceLine(ThemePack.classic, Locale(language), key);
      await tester.tap(find.byTooltip(line('mail.appSettings')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(classic), 200);
      expect(find.text(classic), findsOneWidget);
      expect(find.text('Classic'), findsNothing);
      for (final pack in ThemePack.all) {
        await tester.scrollUntilVisible(find.text(line(pack.nameKey)), 180);
        expect(find.text(line(pack.taglineKey)), findsOneWidget);
      }

      await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000));
      await tester.pumpAndSettle();
      await tester.tap(find.text(line('settings.customizeScreens')));
      await tester.pumpAndSettle();
      expect(find.text(dateRows), findsOneWidget);
      expect(find.text('Date separator rows'), findsNothing);
      await tester.tap(find.text(line('interface.presets')));
      await tester.pumpAndSettle();
      expect(find.text(triage), findsOneWidget);
      expect(find.text('Triage'), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox());
      state.mailbox?.dispose();
      fake.close();
      await tester.pump(const Duration(seconds: 5));
    });
  }

  testWidgets('server messages and mailbox content keep their original words', (
    tester,
  ) async {
    const serverMessage = 'This text was supplied by the server.';
    const content = 'Create a mailbox';
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fa'),
        supportedLocales: const [Locale('fa')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            expect(folderLabelOf(context, 'Important'), 'Important');
            expect(folderLabelOf(context, 'All Mail'), 'All Mail');
            expect(
              describeError(
                context,
                const ApiException(422, 'custom', serverMessage),
              ),
              serverMessage,
            );
            final clientError = LocalizedApiException(
              401,
              'client_session_ended',
              const UiText('account.sessionEnded', {
                'address': 'me@example.com',
              }),
            );
            expect(
              describeError(context, clientError),
              contains('me@example.com'),
            );
            expect(
              describeError(context, clientError),
              isNot(clientError.message),
            );
            return const Scaffold(body: RmRow(label: content));
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(content), findsOneWidget);
    expect(find.text('ایجاد صندوق پستی'), findsNothing);
  });
}
