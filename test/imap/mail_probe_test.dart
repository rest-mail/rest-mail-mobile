import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/imap/discovery.dart';
import 'package:restmail/imap/mail_connection.dart';
import 'package:restmail/imap/mail_probe.dart';
import 'package:restmail/imap/mail_settings.dart';
import 'package:restmail_api/restmail_api.dart';

import 'scripted_server.dart';

void main() {
  test(
    'search finds multiple hosts and working ports, without signing in',
    () async {
      final imap = await ScriptedServer.start('* OK IMAP ready', [
        Rule(
          r'^CAPABILITY',
          '* CAPABILITY IMAP4rev1 IDLE\n{tag} OK done',
          repeat: true,
        ),
      ]);
      final smtp = await ScriptedServer.start('220 SMTP ready', [
        Rule(r'^EHLO', '250-server\n250 AUTH PLAIN LOGIN', repeat: true),
      ], smtp: true);
      final pop = await ScriptedServer.start('+OK POP3 ready', [
        Rule(r'^CAPA', '+OK capabilities\nUSER\nUIDL\n.', repeat: true),
      ], smtp: true);
      addTearDown(imap.close);
      addTearDown(smtp.close);
      addTearDown(pop.close);
      final opened = <(String, int, bool)>[];
      final dnsNames = <String>{};
      const resolved = {
        'example.net',
        'mail.example.net',
        'imap.example.net',
        'smtp.example.net',
        'pop3.example.net',
        'mx.provider.test',
      };
      final results = await searchMailSettings(
        'ada@example.net',
        httpClient: MockClient((request) async {
          final name = request.url.queryParameters['name'];
          final type = request.url.queryParameters['type'];
          if (name != null) dnsNames.add(name);
          if (name == 'example.net' && type == 'MX') {
            return http.Response(
              jsonEncode({
                'Answer': [
                  {'type': 15, 'data': '10 mx.provider.test.'},
                ],
              }),
              200,
            );
          }
          if (type == 'A' && resolved.contains(name)) {
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
        }),
        openSocket: (host, port, {required tls}) {
          opened.add((host, port, tls));
          if ([
                'example.net',
                'imap.example.net',
                'mx.provider.test',
              ].contains(host) &&
              port == 993) {
            return imap.sockets(host, port, tls: tls);
          }
          if (host == 'smtp.example.net' && port == 465) {
            return smtp.sockets(host, port, tls: tls);
          }
          if (host == 'pop3.example.net' && port == 995) {
            return pop.sockets(host, port, tls: tls);
          }
          throw const SocketException('Connection refused');
        },
      );

      expect(
        dnsNames,
        containsAll([
          'example.net',
          'smtp.example.net',
          'imap.example.net',
          'mail.example.net',
          'pop3.example.net',
          'pop.example.net',
          'submission.example.net',
        ]),
      );
      expect(
        opened,
        containsAll([
          ('example.net', 993, true),
          ('smtp.example.net', 587, false),
          ('smtp.example.net', 465, true),
          ('smtp.example.net', 2525, false),
          ('mail.example.net', 143, false),
          ('pop3.example.net', 110, false),
        ]),
      );
      expect(results.imap.map((endpoint) => endpoint.host), [
        'example.net',
        'imap.example.net',
        'mx.provider.test',
      ]);
      expect(results.smtp.single.port, 465);
      expect(results.pop3.single.host, 'pop3.example.net');
      expect(results.canConfigure, isTrue);
      final chosen = results.settingsFor(results.imap[1], results.smtp.single);
      expect(chosen.settings.imapHost, 'imap.example.net');
      expect(chosen.settings.smtpPort, 465);
      expect(chosen.source, SettingsSource.probe);
      expect(imap.commands.every((command) => command == 'CAPABILITY'), isTrue);
      expect(
        smtp.commands.every((command) => command.startsWith('EHLO')),
        isTrue,
      );
      expect(pop.commands, ['CAPA']);
    },
  );

  test(
    'a listening port with the wrong protocol or no SMTP AUTH is rejected',
    () async {
      final server = await ScriptedServer.start('220 delivery server', [
        Rule(r'^EHLO', '250-server\n250 8BITMIME', repeat: true),
      ], smtp: true);
      addTearDown(server.close);
      expect(
        await probeMailEndpoint(
          const MailEndpoint(MailProtocol.imap, 'mail.example.net', 993),
          openSocket: server.sockets,
        ),
        isFalse,
      );
      expect(
        await probeMailEndpoint(
          const MailEndpoint(MailProtocol.smtp, 'mail.example.net', 465),
          openSocket: server.sockets,
        ),
        isFalse,
      );
      expect(
        await probeMailEndpoint(
          const MailEndpoint(
            MailProtocol.smtp,
            'mail.example.net',
            587,
            starttls: true,
          ),
          openSocket: server.sockets,
        ),
        isFalse,
      );
      expect(
        server.commands.where((command) => command.startsWith('AUTH')),
        isEmpty,
      );
    },
  );

  test('published POP3 and SMTP hosts on custom ports are probed outside the domain', () async {
    final pop = await ScriptedServer.start('+OK POP3 ready', [
      Rule(r'^CAPA', '+OK capabilities\nUSER\n.', repeat: true),
    ], smtp: true);
    final smtp = await ScriptedServer.start('220 SMTP ready', [
      Rule(r'^EHLO', '250-server\n250 AUTH PLAIN', repeat: true),
    ], smtp: true);
    addTearDown(pop.close);
    addTearDown(smtp.close);
    final results = await searchMailSettings(
      'ada@example.net',
      httpClient: MockClient(
        (request) async => request.url.host == 'autoconfig.thunderbird.net'
            ? http.Response('''<clientConfig><emailProvider>
            <incomingServer type="pop3"><hostname>pop.provider.test</hostname>
              <port>1995</port><socketType>SSL</socketType></incomingServer>
            <outgoingServer type="smtp"><hostname>smtp.provider.test</hostname>
              <port>1465</port><socketType>SSL</socketType></outgoingServer>
          </emailProvider></clientConfig>''', 200)
            : http.Response('', 404),
      ),
      openSocket: (host, port, {required tls}) {
        if (host == 'pop.provider.test' && port == 1995) {
          return pop.sockets(host, port, tls: tls);
        }
        if (host == 'smtp.provider.test' && port == 1465) {
          return smtp.sockets(host, port, tls: tls);
        }
        throw const SocketException('Connection refused');
      },
    );
    expect(results.imap, isEmpty);
    expect(results.pop3.single.host, 'pop.provider.test');
    expect(results.pop3.single.port, 1995);
    expect(results.smtp.single.port, 1465);
    expect(results.canConfigure, isFalse);
  });

  for (final protocol in MailProtocol.values) {
    test('${protocol.name} STARTTLS completes TLS and checks capabilities again', () async {
      final server = await _StartTlsServer.start(protocol);
      addTearDown(server.close);
      final trusted = SecurityContext(withTrustedRoots: false)
        ..setTrustedCertificates('test/imap/fixtures/discovery-test.crt');
      final fixturePem = File('test/imap/fixtures/discovery-test.crt')
          .readAsStringSync()
          .trim();
      final endpoint = MailEndpoint(
        protocol,
        'localhost',
        server.port,
        starttls: true,
      );
      final clientErrors = <Object>[];
      final accepted = await probeMailEndpoint(
        endpoint,
        openSocket: (host, port, {required tls}) =>
            Socket.connect('127.0.0.1', port),
        upgradeSocket: (socket, host) async {
          try {
            return await SecureSocket.secure(
              socket,
              host: host,
              context: trusted,
              // Only this loopback fixture is trusted by the test.
              onBadCertificate: (certificate) =>
                  host == 'localhost' && certificate.pem.trim() == fixturePem,
            );
          } on Object catch (error) {
            clientErrors.add(error);
            rethrow;
          }
        },
      );
      expect(
        accepted,
        isTrue,
        reason:
            'commands=${server.commands}, upgrades=${server.upgrades}, errors=${server.errors}, clientErrors=$clientErrors',
      );
      expect(server.upgrades, 1);
      expect(
        server.commands.any(
          (command) => RegExp(r'^(AUTH|LOGIN|USER|PASS)\b').hasMatch(command),
        ),
        isFalse,
      );
      if (protocol == MailProtocol.smtp) {
        expect(
          server.commands.where((command) => command.startsWith('EHLO')),
          hasLength(2),
        );
      }
    });
  }

  test(
    'STARTTLS with an untrusted certificate is never offered as a choice',
    () async {
      final server = await _StartTlsServer.start(MailProtocol.smtp);
      addTearDown(server.close);
      expect(
        await probeMailEndpoint(
          MailEndpoint(
            MailProtocol.smtp,
            'localhost',
            server.port,
            starttls: true,
          ),
          openSocket: (host, port, {required tls}) =>
              Socket.connect('127.0.0.1', port),
        ),
        isFalse,
      );
    },
  );

  test(
    'legacy plain POP3 is detected for diagnosis without sending credentials',
    () async {
      final server = await ScriptedServer.start('+OK POP3 ready', [
        Rule(r'^CAPA', '-ERR CAPA unsupported', repeat: true),
      ], smtp: true);
      addTearDown(server.close);
      expect(
        await probeMailEndpoint(
          const MailEndpoint(
            MailProtocol.pop3,
            'pop3.example.net',
            110,
            plaintext: true,
          ),
          openSocket: (host, port, {required tls}) {
            expect(tls, isFalse);
            return server.sockets(host, port, tls: tls);
          },
        ),
        isTrue,
      );
      expect(server.commands, ['CAPA']);
    },
  );

  test('cancelling a search closes a stalled protocol probe', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final accepted = Completer<Socket>();
    server.listen(accepted.complete);
    final cancellation = MailSearchCancellation();
    final result = probeMailEndpoint(
      const MailEndpoint(MailProtocol.imap, 'mail.example.net', 993),
      openSocket: (host, port, {required tls}) =>
          Socket.connect('127.0.0.1', server.port),
      cancellation: cancellation,
    );
    final socket = await accepted.future;
    cancellation.cancel();
    expect(await result.timeout(const Duration(seconds: 1)), isFalse);
    socket.destroy();
    await server.close();
  });

  test(
    'IMAP STARTTLS without STARTTLS capability sends no credentials',
    () async {
      final server = await ScriptedServer.start('* OK IMAP ready', [
        Rule(
          r'^CAPABILITY',
          '* CAPABILITY IMAP4rev1\n{tag} OK done',
          repeat: true,
        ),
      ]);
      addTearDown(server.close);
      await expectLater(
        ImapConnection.open(
          const MailServerSettings(
            imapHost: 'mail.example.net',
            imapPort: 143,
            imapSecurity: ImapSecurity.starttls,
            smtpHost: 'mail.example.net',
          ),
          address: 'ada@example.net',
          password: 'secret',
          openSocket: server.sockets,
        ),
        throwsA(
          isA<ApiException>().having((error) => error.code, 'code', 'no_tls'),
        ),
      );
      expect(server.commands, ['CAPABILITY']);
    },
  );
}

/// A local server that switches from plain protocol bytes to real TLS.
/// The certificate and key are test fixtures, trusted only by these tests.
class _StartTlsServer {
  _StartTlsServer(this.server, this.protocol);

  final ServerSocket server;
  final MailProtocol protocol;
  final commands = <String>[];
  final errors = <Object>[];
  final _clients = <Socket>[];
  int upgrades = 0;
  int get port => server.port;

  static Future<_StartTlsServer> start(MailProtocol protocol) async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final server = _StartTlsServer(socket, protocol);
    socket.listen(server._serve);
    return server;
  }

  void _serve(Socket client) {
    _clients.add(client);
    client.write(switch (protocol) {
      MailProtocol.imap => '* OK IMAP ready\r\n',
      MailProtocol.smtp => '220 SMTP ready\r\n',
      MailProtocol.pop3 => '+OK POP3 ready\r\n',
    });
    _listen(client, false);
  }

  void _listen(Socket client, bool secure) {
    var buffer = '';
    late StreamSubscription<List<int>> subscription;
    subscription = client.listen((data) async {
      buffer += utf8.decode(data);
      while (buffer.contains('\r\n')) {
        final end = buffer.indexOf('\r\n');
        final line = buffer.substring(0, end);
        buffer = buffer.substring(end + 2);
        commands.add(line);
        if (line.contains('STARTTLS') || line == 'STLS') {
          final tag = line.split(' ').first;
          client.write(switch (protocol) {
            MailProtocol.imap => '$tag OK begin TLS\r\n',
            MailProtocol.smtp => '220 begin TLS\r\n',
            MailProtocol.pop3 => '+OK begin TLS\r\n',
          });
          subscription.pause();
          await client.flush();
          final context = SecurityContext()
            ..useCertificateChain('test/imap/fixtures/discovery-test.crt')
            ..usePrivateKey('test/imap/fixtures/discovery-test.key');
          try {
            final secured = await SecureSocket.secureServer(client, context);
            await subscription.cancel();
            _clients.add(secured);
            upgrades++;
            _listen(secured, true);
          } on Object catch (error) {
            errors.add(error);
            await subscription.cancel();
            client.destroy();
          }
          return;
        }
        if (protocol == MailProtocol.imap && line.endsWith(' CAPABILITY')) {
          client.write(
            '* CAPABILITY IMAP4rev1${secure ? '' : ' STARTTLS'}\r\n'
            '${line.split(' ').first} OK done\r\n',
          );
        } else if (protocol == MailProtocol.smtp && line.startsWith('EHLO')) {
          client.write(
            secure
                ? '250-server\r\n250 AUTH PLAIN\r\n'
                : '250-server\r\n250 STARTTLS\r\n',
          );
        } else if (protocol == MailProtocol.pop3 && line == 'CAPA') {
          client.write('+OK capabilities\r\nUSER\r\nUIDL\r\n.\r\n');
        }
      }
    }, onError: (Object _) {});
  }

  Future<void> close() async {
    for (final socket in _clients) {
      socket.destroy();
    }
    await server.close();
  }
}
