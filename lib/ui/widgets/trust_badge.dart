import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../l10n/voice.dart';
import '../../theme/tokens.dart';

/// The one-line statement about who sent a message.
///
/// Renders nothing when the message carries no authentication results, so a
/// missing header never looks like a verdict.
class RmTrustBadge extends StatelessWidget {
  const RmTrustBadge({super.key, required this.verdict, this.compact = false});

  final TrustVerdict verdict;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (verdict.isUnchecked) return const SizedBox.shrink();
    final c = context.rm;
    final colour = switch (verdict.state) {
      TrustState.signed => c.good,
      TrustState.mismatch => c.danger,
      TrustState.forwarded => c.tintAmber,
      TrustState.unsigned => c.ink3,
      _ => c.accent,
    };
    final icon = switch (verdict.state) {
      TrustState.signed => Icons.verified_user_outlined,
      TrustState.mismatch => Icons.gpp_bad_outlined,
      TrustState.forwarded => Icons.forward,
      TrustState.unsigned => Icons.gpp_maybe_outlined,
      _ => Icons.shield_outlined,
    };
    final label = trustLabelOf(context, verdict);
    return Tooltip(
      message: trustDetailOf(context, verdict),
      child: Semantics(
        label: trArgs(context, 'trust.verification', {'label': label}),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 2 : 3,
          ),
          decoration: BoxDecoration(
            color: Color.lerp(c.bg, colour, 0.10),
            border: Border.all(color: Color.lerp(c.bg, colour, 0.35)!),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: compact ? 11 : 12, color: colour),
              const SizedBox(width: 4),
              Text(
                label,
                style: rmText(
                  compact ? 10.5 : 11,
                  color: colour,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The badge with the space above it, or nothing at all.
class RmTrustLine extends StatelessWidget {
  const RmTrustLine({super.key, required this.headers});

  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) {
    final verdict = trustFromHeaders(headers);
    if (verdict.isUnchecked) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RmTrustBadge(verdict: verdict, compact: true),
      ),
    );
  }
}
