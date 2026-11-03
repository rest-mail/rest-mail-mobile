import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/app.dart';
import 'package:restmail/l10n/catalog.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/quiet_hours_screen.dart';
import 'package:restmail/ui/settings_screen.dart';
import 'package:restmail/ui/widgets/common.dart';
import 'package:restmail_api/restmail_api.dart';
import 'package:restmail_fake/restmail_fake.dart';

import 'quiet_hours_fixture.dart';

void main() {
  late QuietHoursFixture fixture;
  const channel = MethodChannel('flutter_timezone');
  setUpAll(() => EditableText.debugDeterministicCursor = true);
  setUp(() async {
    fixture = QuietHoursFixture();
    await fixture.start();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => 'Asia/Kathmandu');
  });
  tearDown(() {
    fixture.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> open(
    WidgetTester tester, {
    int? accountId,
    String language = 'en',
    bool pending = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(ThemePack.classic, Brightness.light),
        locale: Locale(language),
        supportedLocales: [Locale(language)],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: QuietHoursScreen(
          client: fixture.client,
          accountId: accountId ?? fixture.accountId,
        ),
      ),
    );
    if (pending) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  TextField field(WidgetTester tester, String name) =>
      tester.widget<TextField>(find.byKey(ValueKey('quietHours.$name')));

  Future<void> edit(WidgetTester tester, String name, String value) async {
    final finder = find.byKey(ValueKey('quietHours.$name'));
    await tester.ensureVisible(finder);
    await tester.enterText(finder, value);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    tester.testTextInput.hide();
    await tester.ensureVisible(find.byType(RmPrimaryButton));
    await tester.tap(find.byType(RmPrimaryButton));
    await tester.pumpAndSettle();
  }

  Future<void> enable(WidgetTester tester) async {
    await tester.ensureVisible(find.byType(RmSwitch));
    await tester.tap(find.byType(RmSwitch));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'load is disabled until known, device IANA default, and exact owner copy',
    (tester) async {
      fixture.gate.hold = Completer<void>();
      await open(tester, pending: true);
      expect(find.text('Loading quiet hours...'), findsOneWidget);
      expect(field(tester, 'start').enabled, isFalse);
      expect(tester.widget<RmSwitch>(find.byType(RmSwitch)).onChanged, isNull);
      await tester.tap(find.byType(RmSwitch));
      expect(fixture.gate.puts, 0);
      fixture.gate.hold!.complete();
      fixture.gate.hold = null;
      await tester.pumpAndSettle();
      expect(field(tester, 'time_zone').controller!.text, 'Asia/Kathmandu');
      expect(tester.widget<RmSwitch>(find.byType(RmSwitch)).value, isFalse);
      expect(find.text(languageLine('en', 'quietHours.help')), findsOneWidget);
    },
  );

  testWidgets(
    'enable, edit, save and disable round trip without filtering mail',
    (tester) async {
      await open(tester);
      await enable(tester);
      await edit(tester, 'start', '22:00');
      await edit(tester, 'end', '08:00');
      await edit(tester, 'time_zone', 'Europe/Berlin');
      expect(fixture.gate.puts, 0);
      await save(tester);
      expect(find.text('Quiet hours saved.'), findsOneWidget);
      expect(
        (await fixture.client.quietHours(fixture.accountId)).enabled,
        isTrue,
      );
      fixture.fake.deliver(
        to: FakeAccounts.email,
        from: 'sender@example.test',
        subject: 'Still arrives',
      );
      expect(
        (await fixture.client.messages(
          fixture.accountId,
          'INBOX',
        )).items.any((message) => message.subject == 'Still arrives'),
        isTrue,
      );
      await edit(tester, 'start', '23:15');
      await save(tester);
      expect(
        (await fixture.client.quietHours(fixture.accountId)).start,
        '23:15',
      );
      await enable(tester);
      await save(tester);
      final setting = await fixture.client.quietHours(fixture.accountId);
      expect(setting.enabled, isFalse);
      expect(setting.start, '23:15');
      expect(setting.end, '08:00');
      expect(setting.timeZone, 'Europe/Berlin');
    },
  );

  testWidgets(
    'saved schedule loads unchanged and permits only one save at a time',
    (tester) async {
      await fixture.client.setQuietHours(
        fixture.accountId,
        const QuietHoursSetting(
          enabled: true,
          start: '22:00',
          end: '08:00',
          timeZone: 'America/New_York',
        ),
      );
      await open(tester);
      expect(field(tester, 'time_zone').controller!.text, 'America/New_York');
      fixture.gate.hold = Completer<void>();
      await tester.ensureVisible(find.byType(RmPrimaryButton));
      await tester.tap(find.byType(RmPrimaryButton));
      await tester.pump();
      expect(find.text('Saving...'), findsOneWidget);
      expect(field(tester, 'start').enabled, isFalse);
      await tester.tap(find.byType(RmPrimaryButton));
      expect(fixture.gate.puts, 2, reason: 'setup PUT plus one save');
      fixture.gate.hold!.complete();
      fixture.gate.hold = null;
      await tester.pumpAndSettle();
      expect(find.text('Quiet hours saved.'), findsOneWidget);
    },
  );

  testWidgets(
    'validation errors stay at server-named fields, draft retained and recoverable',
    (tester) async {
      await open(tester);
      await enable(tester);
      await edit(tester, 'start', '22:00');
      await edit(tester, 'end', '22:00');
      await edit(tester, 'time_zone', 'Mars/Olympus');
      await save(tester);
      expect(
        field(tester, 'end').decoration!.errorText,
        'must differ from start',
      );
      expect(
        field(tester, 'time_zone').decoration!.errorText,
        'must be an IANA time zone name',
      );
      expect(field(tester, 'end').controller!.text, '22:00');
      expect(
        (await fixture.client.quietHours(fixture.accountId)).enabled,
        isFalse,
      );
      await edit(tester, 'start', '9:00');
      await save(tester);
      expect(field(tester, 'start').decoration!.errorText, isNotEmpty);
      await edit(tester, 'start', '23:00');
      await edit(tester, 'end', '08:00');
      await edit(tester, 'time_zone', 'Europe/Berlin');
      await save(tester);
      expect(find.text('Quiet hours saved.'), findsOneWidget);
      expect(field(tester, 'end').decoration!.errorText, isNull);
    },
  );

  testWidgets('load failure offers retry without allowing edits or writes', (
    tester,
  ) async {
    fixture.fake.online = false;
    await open(tester);
    expect(find.text('Could not load quiet hours.'), findsOneWidget);
    expect(field(tester, 'start').enabled, isFalse);
    expect(tester.widget<RmSwitch>(find.byType(RmSwitch)).onChanged, isNull);
    fixture.fake.online = true;
    await tester.scrollUntilVisible(
      find.text('Try again'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(field(tester, 'start').enabled, isTrue);
    expect(fixture.gate.puts, 0);
  });

  testWidgets(
    'write permission refusal displays server message and preserves draft',
    (tester) async {
      fixture.fake.grant(FakeAccounts.email, {'mail:read'});
      await open(tester, accountId: fixture.otherId);
      await enable(tester);
      await edit(tester, 'start', '22:00');
      await edit(tester, 'end', '08:00');
      await save(tester);
      await tester.scrollUntilVisible(
        find.text('Access denied'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Access denied'), findsOneWidget);
      expect(field(tester, 'start').controller!.text, '22:00');
      expect(
        (await fixture.client.quietHours(fixture.otherId)).enabled,
        isFalse,
      );
      expect(fixture.client.tokens, isNotNull);
    },
  );

  testWidgets('read permission refusal leaves editor locked', (tester) async {
    fixture.fake.grant(FakeAccounts.email, {'mail:write'});
    await open(tester, accountId: fixture.otherId);
    expect(find.text('Access denied'), findsOneWidget);
    expect(field(tester, 'start').enabled, isFalse);
    expect(fixture.gate.puts, 0);
  });

  for (final language in ['de', 'ar', 'fa']) {
    testWidgets(
      '$language uses its catalog while server field messages stay original',
      (tester) async {
        await open(tester, language: language);
        expect(
          find.text(languageLine(language, 'quietHours.title')),
          findsOneWidget,
        );
        await enable(tester);
        await edit(tester, 'start', '22:00');
        await edit(tester, 'end', '22:00');
        await save(tester);
        expect(
          field(tester, 'end').decoration!.errorText,
          'must differ from start',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'mailbox settings links its own quiet-hours editor beside preferences',
    (tester) async {
      final app = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: () => fixture.fake.client,
      );
      await app.start();
      await app.signIn(
        server: Uri.parse('https://${fixture.fake.host}'),
        email: FakeAccounts.email,
        password: FakeAccounts.password,
      );
      await tester.pumpWidget(RestmailApp(state: app));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mailboxes'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Mailbox settings'));
      await tester.pumpAndSettle();
      final row = find.widgetWithText(RmRow, 'Notification quiet hours');
      await tester.scrollUntilVisible(
        row,
        250,
        scrollable: find
            .descendant(
              of: find.byType(MailboxSettingsScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.byType(QuietHoursScreen), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      app.dispose();
      fixture.fake.close();
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
