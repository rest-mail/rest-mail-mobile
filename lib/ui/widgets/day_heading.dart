import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

/// A day's heading in the message list, when date separator rows are on.
class RmDayHeading extends StatelessWidget {
  const RmDayHeading({super.key, required this.label, this.count});

  final String label;

  /// Shown when the "how many messages that day" option is on.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final count = this.count;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: c.surface,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: rmText(
                10.5,
                color: c.ink3,
                weight: FontWeight.w700,
                tracking: 0.09,
              ),
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: rmText(10.5, color: c.ink3, weight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}
