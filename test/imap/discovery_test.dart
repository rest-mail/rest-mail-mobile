import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restmail/imap/discovery.dart';
import 'package:restmail/imap/mail_settings.dart';

const _gmx = '''<?xml version="1.0"?>
<clientConfig version="1.1">
  <emailProvider id="gmx.net">
    <domain>gmx.de</domain>
    <incomingServer type="imap">
      <hostname>imap.gmx.net</hostname>
      <port>143</port>
      <socketType>STARTTLS</socketType>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <incomingServer type="imap">
      <hostname>imap.gmx.net</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <username>%EMAILADDRESS%</username>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>plain.gmx.net</hostname>
      <port>25</port>
      <socketType>plain</socketType>
    </outgoingServer>
    <outgoingServer type="smtp">
      <hostname>mail.gmx.net</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <username>%EMAILLOCALPART%</username>
    </outgoingServer>
  </emailProvider>
</clientConfig>''';

void main() {
  test('the big providers are built in, and asked nothing', () async {
    final asked = <Uri>[];
    final client = MockClient((r) async {
      asked.add(r.url);
      return http.Response('', 404);
    });

    final gmail = await discoverMailSettings(
      'ada@googlemail.com',
      httpClient: client,
    );
    final icloud = await discoverMailSettings('ada@me.com', httpClient: client);

    expect(asked, isEmpty);
    expect(gmail!.provider, MailProviders.gmail);
    expect(gmail.source, SettingsSource.preset);
    expect(gmail.settings.filesSentMail, isTrue);
    expect(icloud!.settings.smtpSecurity, SmtpSecurity.starttls);
    expect(icloud.settings.smtpPort, 587);
    expect(
      MailProviders.forAddress('someone@outlook.com')!.needsMicrosoftSignIn,
      isTrue,
    );
  });

  test("Thunderbird's database comes first, and only TLS is taken", () async {
    final asked = <Uri>[];
    final found = await discoverMailSettings(
      'ada@gmx.de',
      httpClient: MockClient((r) async {
        asked.add(r.url);
        return r.url.host == 'autoconfig.thunderbird.net'
            ? http.Response(_gmx, 200)
            : http.Response('', 404);
      }),
    );

    expect(
      asked.single.toString(),
      'https://autoconfig.thunderbird.net/v1.1/gmx.de',
    );
    expect(found!.source, SettingsSource.ispdb);
    expect(
      found.settings,
      const MailServerSettings(
        imapHost: 'imap.gmx.net',
        smtpHost: 'mail.gmx.net',
        smtpPort: 587,
        smtpSecurity: SmtpSecurity.starttls,
      ),
    );
  });

  test("then the domain's own file, over HTTPS only", () async {
    final asked = <Uri>[];
    final found = await discoverMailSettings(
      'ada@example.org',
      httpClient: MockClient((r) async {
        asked.add(r.url);
        return r.url.host == 'autoconfig.example.org'
            ? http.Response(_gmx.replaceAll('gmx.net', 'example.org'), 200)
            : http.Response('', 404);
      }),
    );

    expect(found!.source, SettingsSource.autoconfig);
    expect(found.settings.imapHost, 'imap.example.org');
    expect(asked.every((u) => u.scheme == 'https'), isTrue);
  });

  test('then DNS SRV records', () async {
    String answer(String name, String data) => jsonEncode({
      'Status': 0,
      'Answer': [
        {'name': name, 'type': 33, 'TTL': 3600, 'data': data},
      ],
    });
    final found = await discoverMailSettings(
      'ada@example.net',
      httpClient: MockClient((r) async {
        final name = r.url.queryParameters['name'];
        return switch (name) {
          '_imaps._tcp.example.net' => http.Response(
            answer(name!, '0 1 993 mail.example.net.'),
            200,
          ),
          '_submissions._tcp.example.net' => http.Response(
            answer(name!, '0 1 465 smtp.example.net.'),
            200,
          ),
          _ => http.Response('', 404),
        };
      }),
    );

    expect(found!.source, SettingsSource.dns);
    expect(
      found.settings,
      const MailServerSettings(
        imapHost: 'mail.example.net',
        smtpHost: 'smtp.example.net',
      ),
    );
  });

  test('nothing found means typing them in', () async {
    final found = await discoverMailSettings(
      'ada@nowhere.example',
      httpClient: MockClient((_) async => http.Response('', 404)),
    );

    expect(found, isNull);
  });

  test('a plaintext-only file is not used', () {
    expect(
      parseAutoconfig(
        _gmx.replaceAll('STARTTLS', 'plain').replaceAll('SSL', 'plain'),
        'ada@gmx.de',
      ),
      isNull,
    );
  });

  test('settings survive being saved', () {
    const settings = MailServerSettings(
      imapHost: 'imap.example.org',
      imapPort: 1993,
      smtpHost: 'smtp.example.org',
      smtpPort: 587,
      smtpSecurity: SmtpSecurity.starttls,
      username: 'ada',
    );

    expect(MailServerSettings.fromJson(settings.toJson()), settings);
    expect(MailServerSettings.fromJson({'imap_host': 'x'}), isNull);
  });
}
