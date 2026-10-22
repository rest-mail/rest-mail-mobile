import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../version.dart';

/// One issue or pull request in a release.
@immutable
class WhatsNewItem {
  const WhatsNewItem({this.number, required this.title});

  factory WhatsNewItem.fromJson(Map<String, dynamic> json) => WhatsNewItem(
    number: (json['number'] as num?)?.toInt(),
    title: json['title'] as String? ?? '',
  );

  final int? number;
  final String title;

  Map<String, Object?> toJson() => {'number': number, 'title': title};
}

/// A release's notes, as the What's New screen renders them.
@immutable
class WhatsNewNotes {
  const WhatsNewNotes({
    required this.version,
    required this.title,
    required this.summary,
    this.items = const [],
  });

  factory WhatsNewNotes.fromJson(String version, Map<String, dynamic> json) =>
      WhatsNewNotes(
        version: version,
        title: json['title'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        items: [
          for (final item in json['items'] as List? ?? const [])
            if (item is Map<String, dynamic>) WhatsNewItem.fromJson(item),
        ],
      );

  final String version;
  final String title;
  final String summary;
  final List<WhatsNewItem> items;

  Map<String, Object?> toJson() => {
    'title': title,
    'summary': summary,
    'items': [for (final item in items) item.toJson()],
  };
}

/// The release notes for a version: cached on the phone, then fetched from
/// the GitHub release for that tag.
class WhatsNewService {
  const WhatsNewService();

  static const _repo = 'rest-mail/rest-mail-mobile';

  Future<WhatsNewNotes?> load(String version, {bool refresh = false}) async {
    if (version.isEmpty || version == 'dev') return null;
    final cached = await _read(version);
    if (cached != null && !refresh) return cached;

    final fetched = await _fetch(version);
    if (fetched != null) await _write(version, fetched);
    return fetched ?? cached;
  }

  Future<File?> _cacheFile(String version) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/whats_new_$version.json');
    } on Object {
      return null;
    }
  }

  Future<WhatsNewNotes?> _read(String version) async {
    try {
      final file = await _cacheFile(version);
      if (file == null || !await file.exists()) return null;
      final raw = jsonDecode(await file.readAsString());
      if (raw is! Map<String, dynamic>) return null;
      return WhatsNewNotes.fromJson(version, raw);
    } on Object {
      return null;
    }
  }

  Future<void> _write(String version, WhatsNewNotes notes) async {
    try {
      final file = await _cacheFile(version);
      await file?.writeAsString(jsonEncode(notes.toJson()));
    } on Object {
      // The notes are still shown; the next launch can fetch them again.
    }
  }

  Future<WhatsNewNotes?> _fetch(String version) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.github.com/repos/$_repo/releases/tags/v$version',
        ),
        headers: {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'restmail-mobile/$appVersion',
        },
      );
      if (response.statusCode != 200) return null;
      final raw = jsonDecode(response.body);
      if (raw is! Map<String, dynamic>) return null;
      return parseRelease(
        version: version,
        name: raw['name'] as String? ?? '',
        body: raw['body'] as String? ?? '',
      );
    } on Object {
      return null;
    }
  }
}

/// Turns a GitHub release's name and body into a title, a short explanation
/// and the list of merged pull requests. The body is what GitHub's generated
/// notes look like; an agent-written body that follows the same shape works
/// too.
WhatsNewNotes parseRelease({
  required String version,
  required String name,
  required String body,
}) {
  final lines = const LineSplitter().convert(body);
  final summary = StringBuffer();
  final items = <WhatsNewItem>[];
  var summaryDone = false;

  for (final line in lines) {
    final text = line.trim();
    if (text.isEmpty) {
      if (summary.isNotEmpty) summaryDone = true;
      continue;
    }
    if (text.startsWith('#')) continue;
    if (text.startsWith('**Full Changelog**')) continue;
    if (text.startsWith('- ') || text.startsWith('* ')) {
      final item = _item(text.substring(2).trim());
      if (item != null) items.add(item);
      continue;
    }
    if (!summaryDone &&
        summary.isEmpty &&
        !text.startsWith('**') &&
        !text.startsWith('https://') &&
        !text.startsWith('@')) {
      summary.write(text);
    }
  }

  return WhatsNewNotes(
    version: version,
    title: name.trim().isEmpty ? 'What’s new in $version' : name.trim(),
    summary: summary.isEmpty
        ? 'The latest release of REST Mail.'
        : summary.toString(),
    items: items,
  );
}

WhatsNewItem? _item(String text) {
  if (text.isEmpty) return null;
  final pull = RegExp(r'(?:#|/pull/)(\d+)').firstMatch(text)?.group(1);
  final number = pull == null ? null : int.tryParse(pull);
  final withoutBy = text.split(' by @').first.trim();
  final title = withoutBy.replaceAll(RegExp(r'\s*https?://\S+$'), '').trim();
  return WhatsNewItem(number: number, title: title.isEmpty ? text : title);
}
