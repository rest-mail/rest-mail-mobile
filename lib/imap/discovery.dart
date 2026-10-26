import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'mail_settings.dart';
import 'mail_connection.dart';
import 'mail_probe.dart';

/// Where a domain's settings were found, in the order they are tried.
/// The screen words each one as `imap.source.<name>`.
enum SettingsSource { preset, saved, ispdb, autoconfig, dns, probe }

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
  void Function(String body)? onAutoconfig,
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
    if (body != null) onAutoconfig?.call(body);
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
  final submissions = (await srv('_submissions._tcp')).firstOrNull;
  final submission = submissions == null
      ? (await srv('_submission._tcp')).firstOrNull
      : null;
  final smtp = submissions ?? submission;
  if (imap != null && smtp != null) {
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

  return null;
}

class MailSearchResults {
  const MailSearchResults({
    this.imap = const [],
    this.smtp = const [],
    this.pop3 = const [],
    this.advertised,
  });

  final List<MailEndpoint> imap;
  final List<MailEndpoint> smtp;
  final List<MailEndpoint> pop3;
  final FoundSettings? advertised;

  bool get canConfigure => imap.isNotEmpty && smtp.isNotEmpty;

  FoundSettings settingsFor(MailEndpoint incoming, MailEndpoint outgoing) {
    final original = advertised?.settings;
    final sameIncoming =
        original?.imapHost.toLowerCase() == incoming.host.toLowerCase();
    final sameOutgoing =
        original?.smtpHost.toLowerCase() == outgoing.host.toLowerCase();
    return FoundSettings(
      MailServerSettings(
        imapHost: incoming.host,
        imapPort: incoming.port,
        imapSecurity: incoming.starttls
            ? ImapSecurity.starttls
            : ImapSecurity.tls,
        smtpHost: outgoing.host,
        smtpPort: outgoing.port,
        smtpSecurity: outgoing.starttls
            ? SmtpSecurity.starttls
            : SmtpSecurity.tls,
        username: sameIncoming ? original?.username : null,
        filesSentMail:
            sameIncoming && sameOutgoing && (original?.filesSentMail ?? false),
      ),
      SettingsSource.probe,
      provider: sameIncoming && sameOutgoing ? advertised?.provider : null,
    );
  }
}

/// Searches published settings, MX/SRV targets, the bare domain and common
/// mail subdomains. Only IMAP/SMTP over verified TLS become configuration
/// choices. POP3 is reported separately for diagnosis.
/// Passwords are never used during this search.
Future<MailSearchResults> searchMailSettings(
  String address, {
  required http.Client httpClient,
  required OpenMailSocket openSocket,
  MailSearchCancellation? cancellation,
  void Function(int checked, int total)? onProgress,
  Duration probeTimeout = const Duration(seconds: 6),
  Duration searchTimeout = const Duration(seconds: 45),
}) async {
  final domain = domainOf(address);
  if (domain == null) return const MailSearchResults();
  final control = cancellation ?? MailSearchCancellation();
  final deadline = Timer(searchTimeout, control.cancel);
  try {
    final published = <MailEndpoint>{};
    final advertised = await discoverMailSettings(
      address,
      httpClient: httpClient,
      timeout: const Duration(seconds: 3),
      onAutoconfig: (body) =>
          published.addAll(_publishedEndpoints(body, address)),
    );
    Future<String?> dns(String name, String type) async {
      if (control.isCancelled) return null;
      try {
        final response = await httpClient
            .get(
              Uri.https('cloudflare-dns.com', '/dns-query', {
                'name': name,
                'type': type,
              }),
              headers: const {'accept': 'application/dns-json'},
            )
            .timeout(const Duration(seconds: 3));
        return response.statusCode == 200 ? response.body : null;
      } on Object {
        return null;
      }
    }

    final endpoints = <MailEndpoint>{...published.take(16)};
    final suggested = advertised?.settings;
    if (suggested != null) {
      endpoints.add(
        MailEndpoint(
          MailProtocol.imap,
          suggested.imapHost,
          suggested.imapPort,
          starttls: suggested.imapSecurity == ImapSecurity.starttls,
        ),
      );
      endpoints.add(
        MailEndpoint(
          MailProtocol.smtp,
          suggested.smtpHost,
          suggested.smtpPort,
          starttls: suggested.smtpSecurity == SmtpSecurity.starttls,
        ),
      );
    }
    final services = [
      ('_imaps._tcp', MailProtocol.imap, false),
      ('_imap._tcp', MailProtocol.imap, true),
      ('_submissions._tcp', MailProtocol.smtp, false),
      ('_submission._tcp', MailProtocol.smtp, true),
      ('_pop3s._tcp', MailProtocol.pop3, false),
      ('_pop3._tcp', MailProtocol.pop3, true),
    ];
    final records = await Future.wait([
      for (final service in services) dns('${service.$1}.$domain', 'SRV'),
      dns(domain, 'MX'),
    ]);
    for (var i = 0; i < services.length; i++) {
      for (final record in _parseSrv(records[i] ?? '').take(4)) {
        endpoints.add(
          MailEndpoint(
            services[i].$2,
            record.host,
            record.port,
            starttls: services[i].$3,
          ),
        );
      }
    }
    final hosts = <String>{
      domain,
      for (final prefix in const [
        'mail',
        'imap',
        'smtp',
        'pop3',
        'pop',
        'imap.mail',
        'smtp.mail',
        'submission',
        'submit',
        'mx',
        'mx1',
        'mail1',
        'email',
        'secure',
      ])
        '$prefix.$domain',
      ..._parseMx(records.last ?? '').take(3),
      for (final endpoint in endpoints) endpoint.host,
    }.take(24).toList();
    final resolved = await Future.wait([
      for (final host in hosts)
        Future.wait([dns(host, 'A'), dns(host, 'AAAA')]),
    ]);
    for (var i = 0; i < hosts.length; i++) {
      if (!resolved[i].any((body) => _hasAddress(body ?? ''))) continue;
      final host = hosts[i];
      endpoints.addAll([
        MailEndpoint(MailProtocol.imap, host, 993),
        MailEndpoint(MailProtocol.imap, host, 143, starttls: true),
        MailEndpoint(MailProtocol.smtp, host, 587, starttls: true),
        MailEndpoint(MailProtocol.smtp, host, 465),
        MailEndpoint(MailProtocol.smtp, host, 2525, starttls: true),
        MailEndpoint(MailProtocol.pop3, host, 995),
        MailEndpoint(MailProtocol.pop3, host, 110, starttls: true),
        MailEndpoint(MailProtocol.pop3, host, 110, plaintext: true),
      ]);
    }
    final candidates = endpoints.toList();
    final working = <MailEndpoint>{};
    var next = 0, checked = 0;
    onProgress?.call(0, candidates.length);
    Future<void> worker() async {
      while (!control.isCancelled && next < candidates.length) {
        final endpoint = candidates[next++];
        if (await probeMailEndpoint(
          endpoint,
          openSocket: openSocket,
          timeout: probeTimeout,
          cancellation: control,
        )) {
          working.add(endpoint);
        }
        onProgress?.call(++checked, candidates.length);
      }
    }

    await Future.wait([for (var i = 0; i < 6; i++) worker()]);
    List<MailEndpoint> found(MailProtocol protocol) => [
      for (final candidate in candidates)
        if (candidate.protocol == protocol && working.contains(candidate))
          candidate,
    ];
    return MailSearchResults(
      imap: found(MailProtocol.imap),
      smtp: found(MailProtocol.smtp),
      pop3: found(MailProtocol.pop3),
      advertised: advertised,
    );
  } finally {
    deadline.cancel();
  }
}

List<MailEndpoint> _publishedEndpoints(String body, String address) {
  try {
    final doc = XmlDocument.parse(body);
    final endpoints = <MailEndpoint>[];
    for (final server in [
      ...doc.findAllElements('incomingServer'),
      ...doc.findAllElements('outgoingServer'),
    ]) {
      final protocol = switch (server.getAttribute('type')) {
        'imap' => MailProtocol.imap,
        'smtp' => MailProtocol.smtp,
        'pop3' => MailProtocol.pop3,
        _ => null,
      };
      final socket = server
          .getElement('socketType')
          ?.innerText
          .trim()
          .toUpperCase();
      final host = server
          .getElement('hostname')
          ?.innerText
          .trim()
          .replaceAll('%EMAILDOMAIN%', domainOf(address) ?? '')
          .toLowerCase();
      final port = int.tryParse(
        server.getElement('port')?.innerText.trim() ?? '',
      );
      final plaintext = protocol == MailProtocol.pop3 && socket == 'PLAIN';
      if (protocol == null ||
          host == null ||
          host.isEmpty ||
          port == null ||
          port <= 0 ||
          port > 65535 ||
          (!['SSL', 'STARTTLS'].contains(socket) && !plaintext)) {
        continue;
      }
      endpoints.add(
        MailEndpoint(
          protocol,
          host,
          port,
          starttls: socket == 'STARTTLS',
          plaintext: plaintext,
        ),
      );
    }
    return endpoints;
  } on Object {
    return const [];
  }
}

bool _hasAddress(String body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return (json['Answer'] as List? ?? const []).any(
      (answer) =>
          answer is Map<String, dynamic> &&
          (answer['type'] == 1 || answer['type'] == 28),
    );
  } on Object {
    return false;
  }
}

List<String> _parseMx(String body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final records = <(int, String)>[];
    for (final answer in json['Answer'] as List? ?? const []) {
      if (answer is! Map<String, dynamic> || answer['type'] != 15) continue;
      final parts = (answer['data'] as String).trim().split(RegExp(r'\s+'));
      if (parts.length != 2 || parts[1] == '.') continue;
      records.add((
        int.tryParse(parts[0]) ?? 0,
        parts[1].replaceFirst(RegExp(r'\.$'), ''),
      ));
    }
    records.sort((a, b) => a.$1.compareTo(b.$1));
    return [for (final record in records) record.$2];
  } on Object {
    return const [];
  }
}

/// Reads a Thunderbird autoconfig file (config-v1.1.xml). Only TLS is
/// taken: IMAP and SMTP over SSL or required STARTTLS. Plaintext settings
/// are never used.
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
      incoming.where((e) => socket(e) == 'STARTTLS').firstOrNull;
  final smtp =
      outgoing.where((e) => socket(e) == 'SSL').firstOrNull ??
      outgoing.where((e) => socket(e) == 'STARTTLS').firstOrNull;
  if (imap == null || smtp == null) return null;
  final smtpPort = int.tryParse(text(smtp, 'port') ?? '');
  final smtpTls = socket(smtp) == 'SSL';
  return MailServerSettings(
    imapHost: text(imap, 'hostname')!,
    imapPort:
        int.tryParse(text(imap, 'port') ?? '') ??
        (socket(imap) == 'SSL' ? 993 : 143),
    imapSecurity: socket(imap) == 'SSL'
        ? ImapSecurity.tls
        : ImapSecurity.starttls,
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
