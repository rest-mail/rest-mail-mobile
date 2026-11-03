import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

/// What the sheet did: [until] is the stored deadline, null if it was cancelled.
class ThreadSnoozeResult {
  const ThreadSnoozeResult(this.until);

  final DateTime? until;
}

/// Asks when [message]'s thread should return, as webmail's snooze dialog does,
/// and tells the server. Null if the sheet was closed with nothing changed.
Future<ThreadSnoozeResult?> showThreadSnooze(
  BuildContext context, {
  required MailboxState mailbox,
  required Message message,
}) => showModalBottomSheet<ThreadSnoozeResult>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  clipBehavior: Clip.antiAlias,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (_) => ThreadSnoozeSheet(mailbox: mailbox, message: message),
);

class ThreadSnoozeSheet extends StatefulWidget {
  const ThreadSnoozeSheet({
    super.key,
    required this.mailbox,
    required this.message,
    this.now = DateTime.now,
  });

  final MailboxState mailbox;
  final Message message;
  final DateTime Function() now;

  @override
  State<ThreadSnoozeSheet> createState() => _ThreadSnoozeSheetState();
}

class _ThreadSnoozeSheetState extends State<ThreadSnoozeSheet> {
  late DateTime? _until = widget.message.snoozedUntil;
  DateTime? _chosen;
  bool _busy = false;
  String? _error;
  late final StreamSubscription<ThreadSnooze> _changes;

  @override
  void initState() {
    super.initState();
    _changes = widget.mailbox.threadSnoozes.listen((change) {
      if (change.mailboxId == widget.message.mailboxId &&
          change.threadId == widget.message.threadId) {
        setState(() => _until = change.snoozedUntil);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_changes.cancel());
    super.dispose();
  }

  Future<void> _pick() async {
    final now = widget.now();
    final soon = now.add(const Duration(hours: 1));
    final until = _until;
    final initial =
        _chosen ??
        (until != null && until.isAfter(now) ? until.toLocal() : soon);
    final furthest = now.add(const Duration(days: 3650));
    final day = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      // A deadline set elsewhere can be further off than this picker would go.
      lastDate: initial.isAfter(furthest) ? initial : furthest,
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    setState(() {
      _chosen = DateTime(day.year, day.month, day.day, time.hour, time.minute);
      _error = null;
    });
  }

  void _submit() {
    final chosen = _chosen;
    if (chosen == null) return;
    if (!chosen.isAfter(widget.now())) {
      setState(() => _error = tr(context, 'snooze.future'));
      return;
    }
    unawaited(_save(chosen));
  }

  Future<void> _save(DateTime? until) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final stored = await widget.mailbox.snoozeThread(widget.message, until);
      if (mounted) Navigator.pop(context, ThreadSnoozeResult(stored));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        // A plain 404 is a server without the route. describeError would call
        // it not a REST Mail server, which it is.
        _error = e.code == 'http_404'
            ? tr(context, 'snooze.failed')
            : describeError(context, e, host: widget.mailbox.backend.host);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final until = _until, chosen = _chosen;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr(context, 'snooze.title'),
              style: rmText(
                17,
                color: c.ink,
                weight: FontWeight.w700,
                tracking: -0.02,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tr(context, 'snooze.description'),
              style: rmText(12.5, color: c.ink3, height: 1.35),
            ),
            if (until != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  trArgs(context, 'snooze.until', {
                    'time': longDate(until.toLocal()),
                  }),
                  style: rmText(14, color: c.ink),
                ),
              ),
            const SizedBox(height: 8),
            RmRow(
              label: tr(context, 'snooze.returnAt'),
              value: chosen == null ? null : longDate(chosen),
              onTap: _busy ? null : () => unawaited(_pick()),
            ),
            if (_error case final error?)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: ErrorText(error),
              ),
            const SizedBox(height: 8),
            RmPrimaryButton(
              label: tr(context, 'snooze.title'),
              busy: _busy,
              onPressed: _busy || chosen == null ? null : _submit,
            ),
            if (until != null) ...[
              const SizedBox(height: 10),
              RmOutlineButton(
                label: tr(context, 'snooze.cancel'),
                onPressed: _busy ? null : () => unawaited(_save(null)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
