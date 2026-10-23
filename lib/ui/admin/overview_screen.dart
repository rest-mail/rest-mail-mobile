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
                    label: 'Being delivered',
                    value: countLabel(stats.queueProcessing),
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
                              width: 64,
                              child: Text(
                                day.date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 22),
              const SectionLabel('Inbound transport'),
              const SizedBox(height: 9),
              if (stats.inboundMx == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'No inbound MX deliveries have been recorded yet.',
                    style: rmText(14, color: c.ink2, height: 1.45),
                  ),
                ),
              RmGroup(
                children: [
                  RmRow(
                    label: 'Deliveries from other servers',
                    value: countLabel(stats.inboundMx),
                  ),
                  RmRow(
                    label: 'Encrypted with TLS',
                    value: countLabel(stats.inboundOverTls),
                    subtitle:
                        '${stats.inboundTlsPercent}% of inbound deliveries',
                  ),
                  RmRow(
                    label: 'Unencrypted',
                    value: countLabel(stats.inboundPlaintext),
                    subtitle:
                        '${stats.inboundPlaintextPercent}% of inbound '
                        'deliveries',
                  ),
                  RmRow(
                    label: 'Unencrypted, sender authentication passed',
                    value: countLabel(stats.plaintextAuthPass),
                  ),
                  RmRow(
                    label: 'Unencrypted, no passing sender authentication',
                    value: countLabel(stats.plaintextAuthFail),
                  ),
                ],
              ),
              if (stats.recent.isNotEmpty) ...[
                const SizedBox(height: 22),
                const SectionLabel('Lately'),
                const SizedBox(height: 9),
                for (final item in stats.recent) ...[
                  _ActivityCard(activity: item),
                  const SizedBox(height: 9),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Activity rows become vertically labelled records, keeping long descriptions
/// and identifiers readable on a phone without horizontal scrolling.
class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final DashboardActivity activity;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final at = activity.at;
    return RmGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: rmText(14.5, color: c.ink, weight: FontWeight.w600),
                ),
                if (at != null) ...[
                  const SizedBox(height: 6),
                  Text(timeLabel(at), style: rmText(13, color: c.ink2)),
                ],
                if (activity.type.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  SelectableText(
                    'Event type: ${activity.type}',
                    style: rmText(12.5, color: c.ink3),
                  ),
                ],
                if (activity.id.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  SelectableText(
                    'ID: ${activity.id}',
                    style: rmText(12.5, color: c.ink3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
