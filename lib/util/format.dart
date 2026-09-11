import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// A list row's time: the clock today, then "Yesterday", the weekday within
/// a week, and a date after that.
String timeLabel(DateTime when, {DateTime? now}) {
  final today = now ?? DateTime.now();
  // Whole calendar days, counted in UTC so a DST change cannot make a day
  // 23 hours long and round it away.
  final days = DateTime.utc(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime.utc(when.year, when.month, when.day)).inDays;
  if (days <= 0) return DateFormat.Hm().format(when);
  if (days == 1) return 'Yesterday';
  if (days < 7) return DateFormat.E().format(when);
  if (when.year == today.year) return DateFormat.MMMd().format(when);
  return DateFormat.yMMMd().format(when);
}

String longDate(DateTime when) =>
    DateFormat('EEE d MMM yyyy, HH:mm').format(when);

String sizeLabel(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var value = bytes / 1024;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final number = unit == 0 || value >= 10
      ? '${value.round()}'
      : value.toStringAsFixed(1);
  return '$number ${units[unit]}';
}

String countLabel(int count) => NumberFormat.decimalPattern().format(count);

/// Two letters for an avatar: the first letters of the first two words of a
/// name, or the first two letters of a single word or an address's local part.
String initialsOf(String name) {
  var source = name.trim();
  if (source.contains('@')) source = source.split('@').first;
  final words = source
      .split(RegExp(r'[\s._\-+]+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return '?';
  if (words.length == 1) {
    return words.first.characters.take(2).toString().toUpperCase();
  }
  return '${words[0].characters.first}${words[1].characters.first}'
      .toUpperCase();
}

const _avatarTints = [
  // Slate rather than the design's near-black, which all but vanished on the
  // dark background.
  Color(0xFF57606A),
  Color(0xFF5B57D8),
  Color(0xFF0F9E6E),
  Color(0xFF4C4FD8),
  Color(0xFFC2483A),
  Color(0xFFD08420),
  Color(0xFFE2632A),
  Color(0xFF2B59FF),
  Color(0xFF7A5CFF),
  Color(0xFF0B7CFF),
];

/// The same sender gets the same colour every time, on every device —
/// `String.hashCode` promises neither, so the hash is spelled out.
Color avatarTint(String seed) {
  var hash = 0;
  for (final unit in seed.toLowerCase().codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return _avatarTints[hash % _avatarTints.length];
}

/// The extension, as the badge on an attachment tile shows it.
String fileKind(String filename) {
  final dot = filename.lastIndexOf('.');
  return dot > 0 && dot < filename.length - 1
      ? filename.substring(dot + 1).toLowerCase()
      : 'file';
}

String kindLabel(String contentType) {
  final type = contentType.toLowerCase();
  if (type.startsWith('image/')) return 'Image';
  if (type == 'application/pdf') return 'PDF';
  if (type.startsWith('text/')) return 'Text';
  if (type.startsWith('audio/')) return 'Audio';
  if (type.startsWith('video/')) return 'Video';
  if (type.contains('zip') || type.contains('compressed')) return 'Archive';
  return 'File';
}
