import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'mail_settings.dart';

/// Where a domain's settings were found, in the order they are tried.
enum SettingsSource {
  preset('Built in'),
  ispdb("From Thunderbird's database"),
  autoconfig("From the domain's own settings"),
  dns('From DNS');

  const SettingsSource(this.label);

  final String label;
}

class FoundSettings {
  const FoundSettings(this.settings, this.source, {this.provider});

  final MailServerSettings settings;
  final SettingsSource source;
  final MailProvider? provider;
}

/// Finds the IMAP and SMTP servers for [address]: a built-in preset for the
/// big providers, then Thunderbird's autoconfig database, then the domain's
/// own autoconfig file, then DNS SRV records (RFC 6186). Null means none of
/// them knew, and the settings are typed in by hand.
///
/// Everything is fetched over HTTPS. Thunderbird also tries plain HTTP for a
/// domain's own file; that would let anyone on the network point the app,
/// and the password, at a server of their choosing, so this doesn't.
Future<FoundSettings?> discoverMailSettings(
  String address, {
  required http.Client httpClient,
  Duration timeout = const Duration(seconds: 8),
}) async {
  final domain = domainOf(address);
  if (domain == null) return null;
  final provider = MailProviders.forAddress(address);
  if (provider != null) {
    return FoundSettings(
      provider.settings,
      SettingsSource.preset,
      provider: provider,
    );
  }
  Future<String?> get(Uri url, [Map<String, String>? headers]) async {
    try {
      final response = await httpClient
          .get(url, headers: headers)
          .timeout(timeout);
      return response.statusCode == 200 ? response.body : null;
    } on Object {
      return null; // Not there, or not reachable: try the next place.
    }
  }

  final encoded = Uri.encodeQueryComponent(address);
  final sources = [
    (
      SettingsSource.ispdb,
      Uri.parse('https://autoconfig.thunderbird.net/v1.1/$domain'),
    ),
    (
      SettingsSource.autoconfig,
      Uri.parse(
        'https://autoconfig.$domain/mail/config-v1.1.xml?emailaddress=$encoded',
      ),
    ),
    (
      SettingsSource.autoconfig,
      Uri.parse(
        'https://$domain/.well-known/autoconfig/mail/config-v1.1.xml'
        '?emailaddress=$encoded',
      ),
    ),
  ];
  for (final (source, url) in sources) {
    final body = await get(url);
    final settings = body == null ? null : parseAutoconfig(body, address);
    if (settings != null) return FoundSettings(settings, source);
  }

  Future<List<_Srv>> srv(String name) async {
    final body = await get(
      Uri.https('cloudflare-dns.com', '/dns-query', {
        'name': '$name.$domain',
        'type': 'SRV',
      }),
      const {'accept': 'application/dns-json'},
    );
    return body == null ? const [] : _parseSrv(body);
  }

  final imap = (await srv('_imaps._tcp')).firstOrNull;
  if (imap == null) return null;
  final submissions = (await srv('_submissions._tcp')).firstOrNull;
  final submission = submissions == null
      ? (await srv('_submission._tcp')).firstOrNull
      : null;
  final smtp = submissions ?? submission;
  if (smtp == null) return null;
  return FoundSettings(
    MailServerSettings(
      imapHost: imap.host,
      imapPort: imap.port,
      smtpHost: smtp.host,
      smtpPort: smtp.port,
      smtpSecurity: submissions != null
          ? SmtpSecurity.tls
          : SmtpSecurity.starttls,
    ),
    SettingsSource.dns,
  );
}

/// Reads a Thunderbird autoconfig file (config-v1.1.xml). Only TLS is
/// taken: IMAP over SSL, and SMTP over SSL or STARTTLS. An IMAP server
/// listed with STARTTLS alone is tried on 993 instead; a plaintext one is
/// never used.
MailServerSettings? parseAutoconfig(String body, String address) {
  final XmlDocument doc;
  try {
    doc = XmlDocument.parse(body);
  } on XmlException {
    return null;
  }
  String? text(XmlElement e, String name) =>
      e.getElement(name)?.innerText.trim();
  final local = address.substring(0, address.lastIndexOf('@'));
  String? username(XmlElement e) {
    final raw = text(e, 'username');
    if (raw == null || raw.isEmpty || raw == '%EMAILADDRESS%') return null;
    return raw
        .replaceAll('%EMAILADDRESS%', address)
        .replaceAll('%EMAILLOCALPART%', local)
        .replaceAll('%EMAILDOMAIN%', domainOf(address) ?? '');
  }

  final incoming = [
    for (final e in doc.findAllElements('incomingServer'))
      if (e.getAttribute('type') == 'imap' && text(e, 'hostname') != null) e,
  ];
  final outgoing = [
    for (final e in doc.findAllElements('outgoingServer'))
      if (e.getAttribute('type') == 'smtp' && text(e, 'hostname') != null) e,
  ];
  String socket(XmlElement e) => (text(e, 'socketType') ?? '').toUpperCase();
  final imap =
      incoming.where((e) => socket(e) == 'SSL').firstOrNull ??
      incoming.firstOrNull;
  final smtp =
      outgoing.where((e) => socket(e) == 'SSL').firstOrNull ??
      outgoing.where((e) => socket(e) == 'STARTTLS').firstOrNull;
  if (imap == null || smtp == null) return null;
  final smtpPort = int.tryParse(text(smtp, 'port') ?? '');
  final smtpTls = socket(smtp) == 'SSL';
  return MailServerSettings(
    imapHost: text(imap, 'hostname')!,
    imapPort: socket(imap) == 'SSL'
        ? int.tryParse(text(imap, 'port') ?? '') ?? 993
        : 993,
    smtpHost: text(smtp, 'hostname')!,
    smtpPort: smtpPort ?? (smtpTls ? 465 : 587),
    smtpSecurity: smtpTls ? SmtpSecurity.tls : SmtpSecurity.starttls,
    username: username(imap),
  );
}

class _Srv {
  const _Srv(this.priority, this.weight, this.port, this.host);

  final int priority;
  final int weight;
  final int port;
  final String host;
}

/// SRV answers from a DNS-over-HTTPS JSON reply, best first. A target of
/// "." means the service is not offered (RFC 2782).
List<_Srv> _parseSrv(String body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final records = <_Srv>[];
    for (final answer in json['Answer'] as List? ?? const []) {
      if (answer is! Map<String, dynamic> || answer['type'] != 33) continue;
      final parts = (answer['data'] as String).trim().split(RegExp(r'\s+'));
      if (parts.length != 4) continue;
      final host = parts[3].endsWith('.')
          ? parts[3].substring(0, parts[3].length - 1)
          : parts[3];
      final port = int.tryParse(parts[2]);
      if (host.isEmpty || port == null || port == 0) continue;
      records.add(
        _Srv(
          int.tryParse(parts[0]) ?? 0,
          int.tryParse(parts[1]) ?? 0,
          port,
          host,
        ),
      );
    }
    return records..sort(
      (a, b) => a.priority != b.priority
          ? a.priority.compareTo(b.priority)
          : b.weight.compareTo(a.weight),
    );
  } on Object {
    return const [];
  }
}
