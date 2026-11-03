import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/voice.dart';
import '../../theme/tokens.dart';

String waitingLabel(BuildContext context, DateTime since, {DateTime? now}) {
  final elapsed = (now ?? DateTime.now()).difference(since);
  final minutes = max(0, (elapsed.inMilliseconds / 60000).round());
  final hours = (minutes / 60).round();
  final days = (hours / 24).round();
  final (key, count) = minutes < 60
      ? ('awaiting.minutes', minutes)
      : hours < 48
      ? ('awaiting.hours', hours)
      : days < 14
      ? ('awaiting.days', days)
      : ('awaiting.weeks', (days / 7).round());
  return trArgs(context, key, {'count': '$count'});
}

class WaitingChip extends StatelessWidget {
  const WaitingChip({super.key, this.since, this.now});

  final DateTime? since;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final since = this.since;
    if (since == null) return const SizedBox.shrink();
    final current = now ?? DateTime.now();
    final colors = context.rm;
    final color = current.difference(since) > const Duration(days: 3)
        ? colors.accent
        : colors.ink2;
    return Semantics(
      liveRegion: true,
      child: Tooltip(
        message: tr(context, 'awaiting.explanation'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.38)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 12, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  waitingLabel(context, since, now: current),
                  style: rmText(11, color: color, weight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
