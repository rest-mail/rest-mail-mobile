import 'package:intl/intl.dart';

import 'format.dart';

import 'package:restmail_api/restmail_api.dart';

/// A row in the message list: either a day heading or a conversation.
sealed class ListEntry {
  const ListEntry();
}

final class DayEntry extends ListEntry {
  const DayEntry(this.day, this.count);

  final DateTime day;
  final int count;
}

final class ConversationEntry extends ListEntry {
  const ConversationEntry(this.conversation);

  final List<Message> conversation;
}

/// Midnight of the day [when] fell on.
DateTime dayOf(DateTime when) => DateTime(when.year, when.month, when.day);

/// The list with day headings interleaved, or the plain list when the panel
/// is off. Built once per frame rather than per row.
List<ListEntry> buildListEntries(
  List<List<Message>> conversations, {
  required bool withDays,
}) {
  if (!withDays) {
    return [
      for (final conversation in conversations) ConversationEntry(conversation),
    ];
  }

  final days = <DateTime>[];
  final grouped = <DateTime, List<List<Message>>>{};
  for (final conversation in conversations) {
    final day = dayOf(conversation.first.date);
    final group = grouped[day];
    if (group == null) {
      days.add(day);
      grouped[day] = [conversation];
    } else {
      group.add(conversation);
    }
  }

  final entries = <ListEntry>[];
  for (final day in days) {
    final group = grouped[day]!;
    entries.add(DayEntry(day, group.length));
    for (final conversation in group) {
      entries.add(ConversationEntry(conversation));
    }
  }
  return entries;
}

/// "Today", "Yesterday", a weekday within the week, then a date. The absolute
/// style always writes the full day, for people who want the date, not a
/// word that changes meaning tomorrow.
String dayHeading(DateTime day, {bool absolute = false, DateTime? now}) {
  if (absolute) {
    return DateFormat.yMMMMEEEEd().format(day);
  }
  final today = dayOf(now ?? DateTime.now());
  final target = dayOf(day);
  // Whole calendar days in UTC, so a DST change cannot make a day 23 hours
  // long and round it away.
  final days = DateTime.utc(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime.utc(target.year, target.month, target.day)).inDays;
  if (days == 0) return relativeDayLabel('today');
  if (days == 1) return relativeDayLabel('yesterday');
  if (days > 1 && days < 7) return DateFormat.EEEE().format(target);
  if (target.year == today.year) return DateFormat.MMMMd().format(target);
  return DateFormat.yMMMMd().format(target);
}
