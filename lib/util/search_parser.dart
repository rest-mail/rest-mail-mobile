import 'package:restmail_api/restmail_api.dart';

/// Reads the search box the way the suggestion chips spell it: `from:` and
/// `in:` narrow the search, `has:attachment` keeps messages with files, and
/// the rest is free text.
SearchQuery parseSearch(String input) {
  String? from, folder;
  var hasAttachment = false;
  final words = <String>[];
  for (final token in input.trim().split(RegExp(r'\s+'))) {
    if (token.isEmpty) continue;
    final lower = token.toLowerCase();
    if (lower.startsWith('from:') && token.length > 5) {
      from = token.substring(5);
    } else if (lower.startsWith('in:') && token.length > 3) {
      folder = _folderNamed(token.substring(3));
    } else if (lower == 'has:attachment' || lower == 'has:attachments') {
      hasAttachment = true;
    } else {
      words.add(token);
    }
  }
  return SearchQuery(
    text: words.isEmpty ? null : words.join(' '),
    from: from,
    folder: folder,
    hasAttachment: hasAttachment,
  );
}

/// `in:sent` means the Sent folder; a name that is not one of rest-mail's own
/// folders is passed through as typed.
String _folderNamed(String name) =>
    StandardFolder.ordered
        .where((f) => f.toLowerCase() == name.toLowerCase())
        .firstOrNull ??
    name;
