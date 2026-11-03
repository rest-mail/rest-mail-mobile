/// A thread's snooze: while [snoozedUntil] is set, its messages are hidden from
/// folders and still found by search, and they return at that time.
class ThreadSnooze {
  const ThreadSnooze({
    required this.mailboxId,
    required this.threadId,
    required this.snoozedUntil,
  });

  final int mailboxId;
  final String threadId;
  final DateTime? snoozedUntil;
}
