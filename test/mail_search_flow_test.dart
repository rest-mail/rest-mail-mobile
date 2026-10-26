import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/app.dart';
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_probe.dart';
import 'package:restmail/state/app_state.dart';
import 'package:restmail/state/storage.dart';
import 'package:restmail/ui/imap_account_screen.dart';

import 'imap/scripted_server.dart';

class _ObservedClient extends MockClient {
  _ObservedClient(super.handler);

  final closed = Completer<void>();

  @override
  void close() {
    super.close();
    if (!closed.isCompleted) closed.complete();
  }
}

Future<List<_ObservedClient>> _openSetup(
  WidgetTester tester,
  Set<String> hosts,
  OpenMailSocket sockets,
) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final clients = <_ObservedClient>[];
  final state = AppState(
    store: MemoryKeyValueStore(),
    httpClientFactory: () {
      final client = _ObservedClient((request) async {
        if (request.url.queryParameters['type'] == 'A' &&
            hosts.contains(request.url.queryParameters['name'])) {
          return http.Response(
            jsonEncode({
              'Answer': [
                {'type': 1, 'data': '192.0.2.10'},
              ],
            }),
            200,
          );
        }
        return http.Response('', 404);
      });
      clients.add(client);
      return client;
    },
    mailSockets: sockets,
  );
  addTearDown(state.dispose);
  await state.start();
  await tester.pumpWidget(RestmailApp(state: state));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Add an account'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Other mail (IMAP)'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, 'ada@example.net');
  tester.testTextInput.hide();
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
  return clients;
}

Future<void> _search(WidgetTester tester, List<_ObservedClient> clients) async {
  await tester.runAsync(() async {
    await tester.tap(find.text('Find working servers'));
    await clients.last.closed.future.timeout(const Duration(seconds: 10));
  });
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'search offers live endpoint choices and keeps selected values editable',
    (tester) async {
      late ScriptedServer imap, smtp;
      await tester.runAsync(() async {
        imap = await ScriptedServer.start('* OK IMAP ready', [
          Rule(
            r'^CAPABILITY',
            '* CAPABILITY IMAP4rev1\n{tag} OK done',
            repeat: true,
          ),
        ]);
        smtp = await ScriptedServer.start('220 SMTP ready', [
          Rule(r'^EHLO', '250-server\n250 AUTH PLAIN', repeat: true),
        ], smtp: true);
      });
      addTearDown(imap.close);
      addTearDown(smtp.close);
      final clients = await _openSetup(
        tester,
        {'example.net', 'mail.example.net'},
        (host, port, {required tls}) {
          if (port == 993) return imap.sockets(host, port, tls: tls);
          if (port == 465) return smtp.sockets(host, port, tls: tls);
          throw const SocketException('Connection refused');
        },
      );
      await _search(tester, clients);
      expect(
        find.text('Secure mail services found. Choose your servers below.'),
        findsOneWidget,
      );
      final setupList = find
          .descendant(
            of: find.byType(ImapAccountScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      final choices = find.byType(DropdownButton<MailEndpoint>);
      await tester.scrollUntilVisible(
        choices.first,
        150,
        scrollable: setupList,
      );
      await tester.pumpAndSettle();
      expect(choices, findsNWidgets(2));
      await tester.tap(choices.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('mail.example.net:993 · TLS').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<DropdownButton<MailEndpoint>>(choices.first).value!.host,
        'mail.example.net',
      );
      await tester.scrollUntilVisible(
        find.text('Change'),
        150,
        scrollable: setupList,
      );
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      expect(find.byType(DropdownButton<MailEndpoint>), findsNothing);
      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(
        fields.any((field) => field.controller!.text == 'mail.example.net'),
        isTrue,
      );
    },
  );

  testWidgets('a POP3-only search explains IMAP is required', (tester) async {
    late ScriptedServer pop;
    await tester.runAsync(() async {
      pop = await ScriptedServer.start('+OK POP3 ready', [
        Rule(r'^CAPA', '+OK capabilities\nUSER\nUIDL\n.', repeat: true),
      ], smtp: true);
    });
    addTearDown(pop.close);
    final clients = await _openSetup(tester, {'pop3.example.net'}, (
      host,
      port, {
      required tls,
    }) {
      if (port == 995) return pop.sockets(host, port, tls: tls);
      throw const SocketException('Connection refused');
    });
    await _search(tester, clients);
    expect(
      find.textContaining('REST Mail requires IMAP to add this account.'),
      findsOneWidget,
    );
    expect(find.byType(DropdownButton<MailEndpoint>), findsNothing);
    expect(find.textContaining('pop3.example.net:995 · TLS'), findsOneWidget);
  });
}
