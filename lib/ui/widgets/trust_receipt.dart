import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../l10n/voice.dart';
import '../../theme/tokens.dart';

enum ReceiptSealState { intact, mismatch, notSealed, checking, unavailable }

/// The checks behind a trust verdict, when the reader is set to show them.
class RmTrustReceipt extends StatelessWidget {
  const RmTrustReceipt({
    super.key,
    required this.verdict,
    this.sealState,
    this.sealedHash,
  });

  final TrustVerdict verdict;
  final ReceiptSealState? sealState;
  final String? sealedHash;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final auth = verdict.auth;
    final currentSealState =
        sealState ??
        (sealedHash?.isNotEmpty == true ? ReceiptSealState.checking : null);
    if (auth == null && currentSealState == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final check in auth?.checks ?? <AuthCheck>[])
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(check.method, style: rmText(11, color: c.ink3)),
                  ),
                  Expanded(
                    child: Text(
                      _line(check),
                      style: rmText(
                        11,
                        color: _colour(c, check.result),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (currentSealState case final state?)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: state == ReceiptSealState.mismatch
                          ? c.danger
                          : c.ink3,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tr(context, switch (state) {
                          ReceiptSealState.intact => 'trust.seal.intact',
                          ReceiptSealState.mismatch => 'trust.seal.mismatch',
                          ReceiptSealState.notSealed => 'trust.seal.notSealed',
                          ReceiptSealState.checking => 'trust.seal.checking',
                          ReceiptSealState.unavailable =>
                            'trust.seal.unavailable',
                        }),
                        style: rmText(11, color: c.ink, height: 1.4),
                      ),
                    ),
                    if (sealedHash case final hash? when hash.isNotEmpty)
                      Tooltip(
                        message: hash,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            hash.length > 12
                                ? '${hash.substring(0, 8)}…${hash.substring(hash.length - 4)}'
                                : hash,
                            style: rmText(11, color: c.ink3),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 3),
          Text(
            trustDetailOf(context, verdict),
            style: rmText(11, color: c.ink3, height: 1.4),
          ),
          if (currentSealState != null)
            Text(
              tr(context, 'trust.seal.detail'),
              style: rmText(11, color: c.ink3, height: 1.4),
            ),
        ],
      ),
    );
  }

  String _line(AuthCheck check) {
    final domain = check.domain;
    if (domain == null) return check.result;
    return '${check.result} · ${check.identity ?? 'domain'}=$domain';
  }

  Color _colour(RmColors c, String result) {
    if (result == 'pass') return c.good;
    if (result == 'fail' || result == 'softfail') return c.danger;
    return c.ink2;
  }
}
