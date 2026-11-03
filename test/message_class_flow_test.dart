import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:restmail/app.dart';
import 'package:restmail/imap/imap_backend.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail/state/app_scope.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/mailbox_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/theme/packs.dart';
import 'package:restmail/theme/theme.dart';
import 'package:restmail/ui/mailbox_screen.dart';
import 'package:restmail/ui/widgets/message_class_label.dart';
import 'package:restmail/ui/widgets/message_row.dart';
import 'package:restmail_fake/restmail_fake.dart';
import 'package:restmail_api/restmail_api.dart';

class _WithoutClass extends http.BaseClient {
  _WithoutClass(this.inner);

  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await inner.send(request);
    if (!request.url.path.endsWith('/messages') &&
        !request.url.path.contains('/messages/')) {
      return response;
    }
    final body = jsonDecode(
      await response.stream.bytesToString(),
    ) as Map<String, dynamic>;
    final data = body['data'];
    if (data is List) {
      for (final message in data) {
        (message as Map<String, dynamic>).remove('class');
      }
    } else if (data is Map<String, dynamic>) {
      data.remove('class');
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  setUpAll(() => EditableText.debugDeterministicCursor = true);
  late FakeRestmail fake;
  late AppState state;

  Future<void> open(
    WidgetTester tester, {
    List<String> classes = const [
      'person',
      'newsletter',
      'receipt',
      'notification',
      'future',
    ],
    bool oldServer = false,
    String language = 'en',
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    fake = FakeRestmail(scenario: FakeScenario.empty);
    for (final value in classes) {
      fake.deliver(
        to: FakeAccounts.email,
        from: '$value@example.test',
        subject: 'Message $value',
        messageClass: value,
      );
    }
    state = AppState(
      store: MemoryKeyValueStore(),
      httpClientFactory: () =>
          oldServer ? _WithoutClass(fake.client) : fake.client,
    );
    await state.start();
    await state.updateSettings(state.settings.copyWith(languageCode: language));
    await state.signIn(
      server: Uri.parse('https://${fake.host}'),
      email: FakeAccounts.email,
      password: FakeAccounts.password,
    );
    await tester.pumpWidget(RestmailApp(state: state));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    state.dispose();
    fake.close();
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets(
    'default expanded; only newsletter collapses; labels match webmail',
    (tester) async {
      await open(tester);
      expect(find.byType(MessageRow), findsNWidgets(5));
      expect(find.text('list'), findsOneWidget);
      expect(find.text('receipt'), findsOneWidget);
      expect(find.text('automated'), findsOneWidget);
      expect(find.byType(MessageClassLabel), findsNWidgets(3));
      expect(
        find.byTooltip(
          'The headers say this came through a mailing list. Anyone can send those headers.',
        ),
        findsOneWidget,
      );
      expect(
        find.byTooltip('One of your mail rules marked this as a receipt.'),
        findsOneWidget,
      );
      expect(
        find.byTooltip(
          'The headers say this was sent automatically. Anyone can send those headers.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Collapse list mail (1)'));
      await tester.pumpAndSettle();
      expect(find.text('Message newsletter'), findsNothing);
      for (final value in ['person', 'receipt', 'notification', 'future']) {
        expect(find.text('Message $value'), findsOneWidget);
      }
      await tester.tap(find.text('Show list mail (1)'));
      await tester.pumpAndSettle();
      expect(find.text('Message newsletter'), findsOneWidget);
      await close(tester);
    },
  );

  testWidgets('all-list folder keeps the expansion control available', (
    tester,
  ) async {
    await open(tester, classes: ['newsletter']);
    await tester.tap(find.text('Collapse list mail (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(MessageRow), findsNothing);
    await tester.tap(find.text('Show list mail (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Message newsletter'), findsOneWidget);
    await close(tester);
  });

  testWidgets('search does not collapse and selected list mail stays visible', (
    tester,
  ) async {
    await open(tester);
    await tester.tap(find.text('Collapse list mail (1)'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Message');
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Message newsletter'), findsOneWidget);
    expect(find.text('Show list mail (1)'), findsNothing);
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    expect(find.text('Message newsletter'), findsNothing);
    await tester.tap(find.text('Show list mail (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Message newsletter'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collapse list mail (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Message newsletter'), findsOneWidget);
    expect(find.text('Message person'), findsOneWidget);
    await close(tester);
  });

  testWidgets('missing class stays visible and offers no collapse', (
    tester,
  ) async {
    await open(tester, oldServer: true);
    expect(find.byType(MessageRow), findsNWidgets(5));
    expect(find.byType(MessageClassLabel), findsNothing);
    expect(find.textContaining('list mail'), findsNothing);
    await close(tester);
  });

  testWidgets(
    'IMAP mail has no class and stays expanded despite list headers',
    (tester) async {
      final backend = ImapBackend(
        address: 'ada@example.test',
        displayName: 'Ada',
        password: 'secret',
        settings: const MailServerSettings(
          imapHost: 'imap.example.test',
          smtpHost: 'smtp.example.test',
        ),
        openSocket: (host, port, {required tls}) =>
            throw StateError('No network expected'),
      );
      final mailbox = MailboxState(backend)
        ..loading = false
        ..messages = [
          Message(
            id: 1,
            mailboxId: 1,
            folder: 'INBOX',
            sender: 'list@example.test',
            subject: 'An IMAP list message',
            receivedAt: DateTime.now(),
            headers: {'List-Id': '<list.example.test>', 'Precedence': 'bulk'},
          ),
        ];
      final app = AppState(
        store: MemoryKeyValueStore(),
        httpClientFactory: http.Client.new,
      );
      addTearDown(() {
        mailbox.dispose();
        backend.close();
        app.dispose();
      });
      await tester.pumpWidget(
        AppScope(
          state: app,
          child: MaterialApp(
            theme: buildTheme(ThemePack.classic, Brightness.light),
            home: MailboxScreen(mailbox: mailbox),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(mailbox.messages.single.messageClass, isNull);
      expect(find.text('An IMAP list message'), findsOneWidget);
      expect(find.byType(MessageClassLabel), findsNothing);
      expect(find.textContaining('list mail'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final (language, label) in [
    ('de', 'Listenmails einklappen (1)'),
    ('ar', 'طي بريد القوائم (1)'),
  ]) {
    testWidgets('collapse control is translated in $language', (tester) async {
      await open(tester, classes: ['newsletter', 'person'], language: language);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Message newsletter'), findsNothing);
      expect(find.text('Message person'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await close(tester);
    });
  }
}
