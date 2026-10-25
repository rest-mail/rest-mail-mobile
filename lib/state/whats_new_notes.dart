import 'dart:convert';

/// One issue or pull request in a release.
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
          for (final item in json['items'] as List<Object?>? ?? const [])
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

/// The latest ten public releases, ordered by their numeric version.
class WhatsNewHistory {
  const WhatsNewHistory({required this.releases});

  factory WhatsNewHistory.fromJson(Map<String, dynamic> json) {
    if (json['schema'] != 1 || json['releases'] is! List<Object?>) {
      throw const FormatException('Invalid release history');
    }
    final document = releaseHistoryDocument(json['releases'] as List<Object?>);
    final rows = document['releases'] as List<Map<String, Object?>>;
    if (rows.isEmpty) throw const FormatException('Empty release history');
    return WhatsNewHistory(
      releases: List.unmodifiable([
        for (final row in rows)
          parseRelease(
            version: (row['tag_name'] as String).substring(1),
            name: row['name'] as String,
            body: row['body'] as String,
          ),
      ]),
    );
  }

  static const limit = 10;
  final List<WhatsNewNotes> releases;
}

final _releaseTag = RegExp(
  r'^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$',
);

/// The same small document the release workflow publishes as whats-new.json.
/// GitHub's other metadata, drafts and prereleases never enter this file.
Map<String, Object> releaseHistoryDocument(List<Object?> releases) {
  final seen = <String>{};
  final rows = <Map<String, Object?>>[];
  for (final value in releases) {
    if (value is! Map<String, dynamic> ||
        value['draft'] == true ||
        value['prerelease'] == true) {
      continue;
    }
    final tag = value['tag_name'];
    if (tag is! String || !_releaseTag.hasMatch(tag) || seen.contains(tag)) {
      continue;
    }
    final name = value['name'], body = value['body'];
    if ((name != null && name is! String) ||
        (body != null && body is! String)) {
      continue;
    }
    seen.add(tag);
    rows.add({
      'tag_name': tag,
      'name': name ?? '',
      'body': body ?? '',
      if (value['published_at'] is String)
        'published_at': value['published_at'],
    });
  }
  rows.sort(
    (a, b) => compareReleaseVersions(
      b['tag_name'] as String,
      a['tag_name'] as String,
    ),
  );
  return {'schema': 1, 'releases': rows.take(WhatsNewHistory.limit).toList()};
}

int compareReleaseVersions(String a, String b) {
  final left = a
      .replaceFirst(RegExp(r'^v'), '')
      .split('.')
      .map(int.parse)
      .toList();
  final right = b
      .replaceFirst(RegExp(r'^v'), '')
      .split('.')
      .map(int.parse)
      .toList();
  for (var i = 0; i < 3; i++) {
    final order = left[i].compareTo(right[i]);
    if (order != 0) return order;
  }
  return 0;
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
    title: name.trim(),
    summary: summary.toString(),
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
