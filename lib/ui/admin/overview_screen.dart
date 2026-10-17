import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

/// The server at a glance: what it holds, what is waiting, the last week's
/// mail, and how much of what arrives comes over TLS. Nothing here changes
/// anything.
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  ServerStats? _stats;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.overview)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    try {
      final stats = await widget.account.client.stats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final stats = _stats, error = _error;
    return AdminPage(
      account: widget.account,
      section: AdminSection.overview,
      title: 'Overview',
      body: (_) {
        if (error != null) {
          return AdminMessage(
            describeAdminError(error, host: widget.account.server.host),
            onRetry: () => unawaited(_load()),
          );
        }
        if (stats == null) {
          return const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final busiest = stats.volume.map((d) => d.count).fold(0, max);
        return RefreshIndicator(
          color: c.accent,
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            children: [
              RmGroup(
                children: [
                  RmRow(label: 'Domains', value: countLabel(stats.domains)),
                  RmRow(label: 'Mailboxes', value: countLabel(stats.mailboxes)),
                  RmRow(
                    label: 'Waiting to go out',
                    value: countLabel(stats.queuePending),
                  ),
                  RmRow(
                    label: 'Given up on',
                    value: countLabel(stats.queueFailed),
                  ),
                ],
              ),
              if (stats.volume.isNotEmpty) ...[
                const SizedBox(height: 22),
                const SectionLabel('Messages a day'),
                const SizedBox(height: 9),
                RmGroup(
                  children: [
                    for (final day in stats.volume)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                day.date,
                                style: rmText(13, color: c.ink2),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: busiest == 0
                                      ? 0
                                      : day.count / busiest,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: c.accent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 52,
                              child: Text(
                                countLabel(day.count),
                                textAlign: TextAlign.end,
                                style: rmText(13, color: c.ink3),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
              if (stats.inboundMx > 0) ...[
                const SizedBox(height: 22),
                const SectionLabel('Arriving over TLS'),
                const SizedBox(height: 9),
                Text(
                  '${(stats.inboundOverTls * 100 / stats.inboundMx).round()}% '
                  'of ${countLabel(stats.inboundMx)} deliveries from other '
                  'servers came encrypted.',
                  style: rmText(14, color: c.ink2, height: 1.45),
                ),
              ],
              if (stats.recent.isNotEmpty) ...[
                const SizedBox(height: 22),
                const SectionLabel('Lately'),
                const SizedBox(height: 9),
                RmGroup(
                  children: [
                    for (final item in stats.recent)
                      RmRow(
                        label: item.description,
                        value: switch (item.at) {
                          final at? => timeLabel(at),
                          null => null,
                        },
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
