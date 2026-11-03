import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

String threadDueLabel(BuildContext context, DateTime due, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final local = due.toLocal();
  final difference = due.difference(current);
  if (difference.isNegative) {
    final minutes = (-difference.inMilliseconds / 60000).round();
    final hours = (-difference.inMilliseconds / 3600000).round();
    final (key, count) = minutes < 60
        ? ('threadDue.pastMinutes', minutes)
        : hours < 48
        ? ('threadDue.pastHours', hours)
        : ('threadDue.pastDays', (hours / 24).round());
    return trArgs(context, key, {'count': '$count'});
  }
  final today = current.toLocal();
  final hours = (difference.inMilliseconds / 3600000).round();
  final days = (hours / 24).round();
  final sameDay =
      local.year == today.year &&
      local.month == today.month &&
      local.day == today.day;
  final label = sameDay
      ? DateFormat.Hm().format(local)
      : days <= 1
      ? tr(context, 'threadDue.tomorrow')
      : days < 7
      ? DateFormat.E().format(local)
      : DateFormat.MMMd().format(local);
  return trArgs(context, 'threadDue.due', {'date': label});
}

class ThreadDueControl extends StatefulWidget {
  const ThreadDueControl({
    super.key,
    required this.message,
    required this.onSave,
  });

  final Message message;
  final Future<ThreadDue> Function(DateTime?) onSave;

  @override
  State<ThreadDueControl> createState() => _ThreadDueControlState();
}

class _ThreadDueControlState extends State<ThreadDueControl> {
  late DateTime? _value = _localInput(widget.message.due);
  late DateTime? _due = widget.message.due;
  late String? _source = widget.message.dueSource;
  bool _pending = false;
  ApiException? _error;

  DateTime? _localInput(DateTime? due) {
    if (due == null) return null;
    final local = due.toLocal();
    return DateTime(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
    );
  }

  Future<void> _choose() async {
    final initial = _value ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(0),
      lastDate: DateTime(9999, 12, 31),
      helpText: tr(context, 'threadDue.label'),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      helpText: tr(context, 'threadDue.label'),
    );
    if (time == null || !mounted) return;
    setState(
      () => _value = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _save(DateTime? due) async {
    setState(() {
      _pending = true;
      _error = null;
    });
    try {
      final saved = await widget.onSave(due);
      if (!mounted) return;
      setState(() {
        _due = saved.due;
        _source = saved.source;
        if (due == null) _value = null;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final due = _due;
    final source = _source;
    final sourceLabel = source == 'user'
        ? tr(context, 'threadDue.user')
        : source;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (due != null) ...[
            Tooltip(
              message: sourceLabel == null
                  ? tr(context, 'threadDue.deadline')
                  : trArgs(context, 'threadDue.deadlineSource', {
                      'source': sourceLabel,
                    }),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  [threadDueLabel(context, due), ?sourceLabel].join(' · '),
                  style: TextStyle(
                    color: due.isBefore(DateTime.now())
                        ? context.rm.danger
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Text(DateFormat.yMMMd().add_Hm().format(due.toLocal())),
          ],
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                key: const ValueKey('threadDue.choose'),
                onPressed: _pending ? null : _choose,
                icon: const Icon(Icons.event_outlined),
                label: Text(
                  _value == null
                      ? tr(context, 'threadDue.label')
                      : '${tr(context, 'threadDue.label')}: ${DateFormat.yMMMd().add_Hm().format(_value!)}',
                ),
              ),
              TextButton(
                onPressed: _pending || _value == null
                    ? null
                    : () => _save(_value),
                child: Text(
                  tr(context, _pending ? 'threadDue.saving' : 'threadDue.set'),
                ),
              ),
              if (due != null)
                TextButton(
                  onPressed: _pending ? null : () => _save(null),
                  child: Text(tr(context, 'threadDue.clear')),
                ),
            ],
          ),
          if (_error case final error?)
            Semantics(
              liveRegion: true,
              child: Text(
                error.code == 'http_404'
                    ? tr(context, 'threadDue.error')
                    : describeError(context, error),
                style: TextStyle(color: context.rm.danger),
              ),
            ),
        ],
      ),
    );
  }
}
