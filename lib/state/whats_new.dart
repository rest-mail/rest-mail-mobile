import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../version.dart';
import 'whats_new_notes.dart';

export 'whats_new_notes.dart';

/// One history file, shared by every app version and cached for offline use.
/// The release workflow uploads it only after the TestFlight upload succeeds.
class WhatsNewService {
  const WhatsNewService({
    this.httpClient,
    this.cacheDirectory,
    this.fetchInDevelopment = false,
  });

  final http.Client? httpClient;
  final Future<Directory> Function()? cacheDirectory;
  final bool fetchInDevelopment;

  static const _repo = 'rest-mail/rest-mail-mobile';
  static final historyUrl = Uri.parse(
    'https://github.com/$_repo/releases/latest/download/whats-new.json',
  );
  static final _releasesUrl = Uri.parse(
    'https://api.github.com/repos/$_repo/releases?per_page=100',
  );

  Future<WhatsNewHistory?> load({bool refresh = false}) async {
    final cached = await readCache();
    if (cached != null && !refresh) return cached;
    if (appVersion == 'dev' && !fetchInDevelopment) return cached;
    final document = await _fetch();
    if (document == null) return cached;
    final history = WhatsNewHistory.fromJson(document);
    await _write(document);
    return history;
  }

  Future<File?> _cacheFile() async {
    try {
      final dir =
          await (cacheDirectory?.call() ?? getApplicationDocumentsDirectory());
      return File('${dir.path}/whats-new.json');
    } on Object {
      return null;
    }
  }

  Future<WhatsNewHistory?> readCache() async {
    try {
      final file = await _cacheFile();
      if (file == null || !await file.exists()) return null;
      final raw = jsonDecode(await file.readAsString());
      if (raw is! Map<String, dynamic>) return null;
      return WhatsNewHistory.fromJson(raw);
    } on Object {
      return null;
    }
  }

  Future<void> _write(Map<String, dynamic> document) async {
    File? temporary;
    try {
      final file = await _cacheFile();
      if (file == null) return;
      temporary = File(
        '${file.path}.${DateTime.now().microsecondsSinceEpoch}.tmp',
      );
      await temporary.writeAsString(jsonEncode(document), flush: true);
      await temporary.rename(file.path);
    } on Object {
      // The notes still show even if this phone cannot save the cache.
    } finally {
      try {
        if (temporary != null && await temporary.exists()) {
          await temporary.delete();
        }
      } on Object {
        // Best effort after an interrupted cache write.
      }
    }
  }

  Future<http.Response> _get(Uri url) =>
      (httpClient?.get(url, headers: _headers) ??
              http.get(url, headers: _headers))
          .timeout(const Duration(seconds: 10));

  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    'User-Agent': 'restmail-mobile/$appVersion',
  };

  Future<Map<String, dynamic>?> _fetch() async {
    try {
      final response = await _get(historyUrl);
      if (response.statusCode == 200) {
        final raw = jsonDecode(utf8.decode(response.bodyBytes));
        if (raw is! Map<String, dynamic>) return null;
        // Never replace a good cache with bad data.
        WhatsNewHistory.fromJson(raw);
        return releaseHistoryDocument(raw['releases'] as List<Object?>);
      }
      if (response.statusCode != 404) return null;
      // A previous release has no history asset yet. Bootstrap the same
      // single document from GitHub until the first new release publishes it.
      final releases = await _get(_releasesUrl);
      if (releases.statusCode != 200) return null;
      final raw = jsonDecode(utf8.decode(releases.bodyBytes));
      if (raw is! List<Object?>) return null;
      final document = releaseHistoryDocument(raw);
      WhatsNewHistory.fromJson(document);
      return document;
    } on Object {
      return null;
    }
  }
}
