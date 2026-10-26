import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';

/// A host whose favicon must not be shown. The compiled default is empty;
/// a release can add a domain here after a complaint, and the cached copy is
/// removed the next time it is asked for.
const deniedFaviconHosts = <String>{};

/// Fetches and keeps one favicon per host. A successful fetch is kept until
/// the cache version changes or the host is denied; failed fetches are tried
/// again the next time the app starts.
class FaviconCache {
  FaviconCache({
    http.Client Function()? clientFactory,
    Future<Directory> Function()? directory,
    this.cacheVersion = '1',
    this.deniedHosts = deniedFaviconHosts,
  }) : _clientFactory = clientFactory ?? (() => http.Client()),
       _directory = directory ?? _defaultDirectory;

  static const _maxBytes = 1024 * 1024;
  static const _requestTimeout = Duration(seconds: 8);
  static const _readTimeout = Duration(seconds: 10);
  static const _userAgent = 'restmail-mobile favicon';

  final String cacheVersion;
  final Set<String> deniedHosts;
  final http.Client Function() _clientFactory;
  final Future<Directory> Function() _directory;

  final _futures = <String, Future<File?>>{};
  Future<Directory>? _ready;

  /// The icon for the first host that has one, in order.
  Future<File?> iconFor(Iterable<String> hosts) async {
    for (final host in hosts) {
      final file = await iconForHost(host);
      if (file != null) return file;
    }
    return null;
  }

  /// The cached icon for [host], fetching it once if needed.
  Future<File?> iconForHost(String host) {
    final normalized = _normalizeHost(host);
    if (normalized == null || _denied(normalized)) {
      return Future.value(null);
    }
    return _futures.putIfAbsent(normalized, () => _load(normalized));
  }

  /// The cache version and deny list are read at startup; a denied host's
  /// cached copy is dropped here too.
  Future<File?> _load(String host) async {
    final directory = await _cacheDirectory();
    final cached = File('${directory.path}/${_name(host)}.png');
    if (_denied(host)) {
      if (await cached.exists()) {
        try {
          await cached.delete();
        } on FileSystemException {
          // The next denied read still refuses it.
        }
      }
      return null;
    }
    if (await cached.exists()) return cached;

    final client = _clientFactory();
    try {
      for (final base in _bases(host)) {
        for (final uri in await _candidates(client, base)) {
          final bytes = await _get(client, uri, accept: 'image/*');
          if (bytes == null) continue;
          final png = _asPng(bytes);
          if (png == null) continue;
          try {
            await cached.writeAsBytes(png, flush: true);
            return cached;
          } on FileSystemException {
            return null;
          }
        }
      }
    } finally {
      client.close();
    }
    return null;
  }

  /// The base domain first, then the host itself when it is a mail
  /// subdomain, then the common website hosts. This is a bounded, ordered
  /// scan; the first usable icon wins.
  static List<Uri> _bases(String host) {
    final base = _baseDomain(host) ?? host;
    final hosts = <String>[base];
    if (host != base) hosts.add(host);
    for (final prefix in _commonPrefixes) {
      final candidate = '$prefix$base';
      if (!hosts.contains(candidate)) hosts.add(candidate);
    }
    return [for (final candidate in hosts) Uri.parse('https://$candidate/')];
  }

  static const _commonPrefixes = [
    'www.',
    'mail.',
    'webmail.',
    'smtp.',
    'imap.',
  ];

  static const _mailPrefixes = ['www.', 'mail.', 'webmail.', 'smtp.', 'imap.'];

  /// The registrable-looking host under a mail subdomain, or null when the
  /// host is already the base. `mail.com` stays `mail.com`; `mail.example.com`
  /// becomes `example.com`.
  static String? _baseDomain(String host) {
    var value = host;
    var changed = false;
    while (true) {
      for (final prefix in _mailPrefixes) {
        if (!value.startsWith(prefix)) continue;
        final rest = value.substring(prefix.length);
        if (!rest.contains('.')) continue;
        value = rest;
        changed = true;
        break;
      }
      if (value == host || !changed) break;
      // One pass is enough for the mail prefixes; avoid looping forever on a
      // pathological name such as mail.mail.example.com.
      if (!_mailPrefixes.any(value.startsWith)) break;
    }
    return changed ? value : null;
  }

  Future<List<Uri>> _candidates(http.Client client, Uri base) async {
    final found = <({Uri uri, int score})>[];
    final page = await _get(client, base, accept: 'text/html');
    if (page != null) {
      try {
        final document = html_parser.parse(
          utf8.decode(page, allowMalformed: true),
        );
        for (final link in document.querySelectorAll('link[rel][href]')) {
          final rel = (link.attributes['rel'] ?? '').toLowerCase();
          final parts = rel.split(RegExp(r'\s+'));
          if (!parts.any(
            (part) =>
                part == 'icon' ||
                part == 'shortcut' ||
                part == 'apple-touch-icon' ||
                part == 'apple-touch-icon-precomposed',
          )) {
            continue;
          }
          final href = (link.attributes['href'] ?? '').trim();
          if (href.isEmpty ||
              href.startsWith('data:') ||
              href.toLowerCase().endsWith('.svg')) {
            continue;
          }
          final uri = base.resolve(href);
          if (uri.scheme != 'https') continue;
          final type = (link.attributes['type'] ?? '').toLowerCase();
          if (type.contains('svg')) continue;
          final score =
              (type.contains('png') || uri.path.toLowerCase().endsWith('.png')
                  ? 1000
                  : 0) +
              (rel.contains('apple-touch-icon') ? 300 : 100) +
              _sizeScore(link.attributes['sizes']);
          found.add((uri: uri, score: score));
        }
      } on Object {
        // A malformed page leaves only the well-known paths.
      }
    }
    found.sort((a, b) => b.score.compareTo(a.score));
    final urls = <Uri>[
      for (final item in found) item.uri,
      base.resolve('apple-touch-icon.png'),
      base.resolve('favicon.ico'),
    ];
    final seen = <String>{};
    return [
      for (final uri in urls)
        if (seen.add(uri.toString())) uri,
    ];
  }

  static int _sizeScore(String? sizes) {
    if (sizes == null || sizes.isEmpty) return 0;
    var best = 0;
    for (final part in sizes.toLowerCase().split(RegExp(r'\s+'))) {
      final match = RegExp(r'^(\d+)x(\d+)$').firstMatch(part);
      if (match == null) continue;
      final area =
          (int.tryParse(match.group(1)!) ?? 0) *
          (int.tryParse(match.group(2)!) ?? 0);
      if (area > best) best = area;
    }
    return best;
  }

  Future<Uint8List?> _get(
    http.Client client,
    Uri uri, {
    required String accept,
  }) async {
    try {
      final request = http.Request('GET', uri)
        ..headers['Accept'] = accept
        ..headers['User-Agent'] = _userAgent;
      final response = await client.send(request).timeout(_requestTimeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        await response.stream.drain<void>();
        return null;
      }
      final body = BytesBuilder(copy: false);
      await for (final chunk in response.stream.timeout(_readTimeout)) {
        body.add(chunk);
        if (body.length > _maxBytes) return null;
      }
      return body.takeBytes();
    } on Object {
      return null;
    }
  }

  /// ICO is the only format Flutter cannot decode itself. Everything that
  /// decodes is saved as PNG, so the cache has one extension and the UI does
  /// not depend on the source format.
  static Uint8List? _asPng(Uint8List bytes) {
    try {
      final decoded = _isIco(bytes)
          ? image.IcoDecoder().decodeImageLargest(bytes)
          : image.decodeImage(bytes);
      if (decoded == null) return null;
      return Uint8List.fromList(image.encodePng(decoded));
    } on Object {
      return null;
    }
  }

  static bool _isIco(Uint8List bytes) =>
      bytes.length >= 4 &&
      bytes[0] == 0x00 &&
      bytes[1] == 0x00 &&
      bytes[2] == 0x01 &&
      bytes[3] == 0x00;

  Future<Directory> _cacheDirectory() => _ready ??= _prepare();

  Future<Directory> _prepare() async {
    final directory = await _directory();
    if (!await directory.exists()) await directory.create(recursive: true);
    final version = File('${directory.path}/.version');
    var current = '';
    try {
      if (await version.exists()) current = await version.readAsString();
    } on FileSystemException {
      // Treat an unreadable marker as a new version.
    }
    if (current != cacheVersion) {
      await for (final entity in directory.list()) {
        if (entity is File && !entity.path.endsWith('/.version')) {
          try {
            await entity.delete();
          } on FileSystemException {
            // The next start tries again.
          }
        }
      }
      try {
        await version.writeAsString(cacheVersion);
      } on FileSystemException {
        // The cache still works for this run.
      }
    }
    return directory;
  }

  static String _name(String host) =>
      sha256.convert(utf8.encode(host)).toString();

  static String? _normalizeHost(String host) {
    var value = host.trim().toLowerCase();
    if (value.isEmpty) return null;
    if (value.contains('://')) {
      final uri = Uri.tryParse(value);
      value = uri?.host ?? '';
    }
    value = value.replaceFirst(RegExp(r'^www\.'), '');
    if (value.isEmpty ||
        value.contains('/') ||
        value.contains('\\') ||
        value.startsWith('.') ||
        !value.contains('.')) {
      return null;
    }
    return value;
  }

  bool _denied(String host) =>
      deniedHosts.any((denied) => host == denied || host.endsWith('.$denied'));

  static Future<Directory> _defaultDirectory() async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}/favicons');
  }
}
