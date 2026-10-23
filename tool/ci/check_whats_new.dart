import 'dart:convert';
import 'dart:io';

import '../../lib/state/whats_new_notes.dart';

var _checks = 0;
void check(bool condition, String message) {
  if (!condition) throw StateError(message);
  _checks++;
}

Map<String, Object?> release(
  String tag, {
  Object? body = 'Notes',
  bool draft = false,
  bool prerelease = false,
}) => {
  'tag_name': tag,
  'name': 'Release $tag',
  'body': body,
  'draft': draft,
  'prerelease': prerelease,
  'assets': ['not copied'],
};

void main(List<String> args) {
  final raw = <Object?>[
    for (var n = 90; n <= 101; n++) release('v0.3.$n'),
    release('v99.0.0', draft: true),
    release('v98.0.0', prerelease: true),
    release('v1.0.0-beta'),
    release('v01.0.0'),
    release('0.3.102'),
    release('v0.3.101', body: 'Duplicate'),
    null,
  ];
  final document = releaseHistoryDocument(raw);
  final rows = document['releases'] as List<Map<String, Object?>>;
  check(document['schema'] == 1, 'Schema version');
  check(rows.length == 10, 'Exactly the latest ten');
  check(rows.first['tag_name'] == 'v0.3.101', 'Numeric newest first');
  check(rows.last['tag_name'] == 'v0.3.92', 'Oldest entry retained');
  check(rows.map((r) => r['tag_name']).toSet().length == 10, 'Unique versions');
  check(rows.first['body'] == 'Notes', 'Duplicate does not replace notes');
  check(!rows.first.containsKey('assets'), 'Unrelated metadata excluded');
  final history = WhatsNewHistory.fromJson(document);
  check(history.releases.length == 10, 'Parsed ten releases');
  check(history.releases.first.version == '0.3.101', 'Version label');
  check(history.releases.first.title == 'Release v0.3.101', 'Release title');
  check(compareReleaseVersions('v1.0.0', 'v0.99.999') > 0, 'Major order');
  check(compareReleaseVersions('v0.4.0', 'v0.3.999') > 0, 'Minor order');

  final duplicate = releaseHistoryDocument([
    release('v0.3.1', body: 99),
    release('v0.3.1', body: 'Valid'),
  ]);
  check(
    (duplicate['releases'] as List<Object?>).length == 1,
    'Malformed duplicate skipped',
  );
  final notes = WhatsNewHistory.fromJson({
    'schema': 1,
    'releases': [
      release(
        'v0.3.1',
        body: 'Überprüfung.\n\n## Changes\n* Fixed the inbox by @author in https://github.com/rest-mail/rest-mail-mobile/pull/9',
      ),
    ],
  }).releases.single;
  check(notes.summary == 'Überprüfung.', 'Unicode summary retained');
  check(notes.items.single.number == 9, 'Pull request parsed');
  check(notes.items.single.title == 'Fixed the inbox', 'Readable item title');

  for (final bad in <Map<String, dynamic>>[
    {},
    {'schema': 2, 'releases': <Object?>[]},
    {'schema': 1, 'releases': <Object?>[]},
    {'schema': 1, 'releases': 'wrong'},
  ]) {
    var rejected = false;
    try {
      WhatsNewHistory.fromJson(bad);
    } on FormatException {
      rejected = true;
    }
    check(rejected, 'Malformed history rejected');
  }
  if (args.isNotEmpty) {
    final live = WhatsNewHistory.fromJson(
      jsonDecode(File(args.single).readAsStringSync()) as Map<String, dynamic>,
    );
    check(
      live.releases.isNotEmpty && live.releases.length <= 10,
      'Generated file parsed',
    );
    stdout.writeln(
      'Generated history: ${live.releases.map((r) => r.version).join(', ')}',
    );
  }
  stdout.writeln('Release history checks passed ($_checks).');
}
