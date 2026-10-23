import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'queue_screen.dart';
import 'report_filters.dart';
import 'trace_screen.dart';

/// Everything that went out to other servers, newest first, delivered or
/// not: the outbound queue's history. Only to look at; the queue is where
/// a waiting message is retried.
class DeliveryLogScreen extends StatefulWidget {
  const DeliveryLogScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<DeliveryLogScreen> createState() => _DeliveryLogScreenState();
}

class _DeliveryLogScreenState extends State<DeliveryLogScreen> {
  Map<String, String> _filters = {};
  QueueStatus? get _status =>
      _filters['status'] == null ? null : QueueStatus.parse(_filters['status']);
  late final _list = AdminList<QueueEntry>(
    (offset) => widget.account.client.deliveryLog(
      status: _status,
      offset: offset,
      domain: _filters['domain'],
      sender: _filters['sender'],
      recipient: _filters['recipient'],
      since: reportDate(_filters, 'since'),
      until: reportDate(_filters, 'until'),
      limit: reportInt(_filters, 'limit') ?? 50,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.deliveryLog)) {
      unawaited(_list.reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    account: widget.account,
    section: AdminSection.deliveryLog,
    title: 'Delivery log',
    body: (access) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: _status == null
          ? 'Nothing has gone out yet.'
          : 'Nothing ${queueStatusLabel(_status!).toLowerCase()}.',
      header: [
        ReportFiltersBar(
          host: widget.account.server.host,
          values: _filters,
          fields: [
            ReportField(
              'status',
              'Status',
              choices: [
                ('', 'All'),
                for (final s in QueueStatus.values)
                  if (s != QueueStatus.unknown) (s.name, queueStatusLabel(s)),
              ],
            ),
            const ReportField('domain', 'Destination domain'),
            const ReportField('sender', 'Sender contains'),
            const ReportField('recipient', 'Recipient contains'),
            reportSince,
            reportUntil,
            reportPageSize,
          ],
          onChanged: (values) {
            setState(() => _filters = values);
            unawaited(_list.reload());
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RmSegmented<QueueStatus?>(
              options: const [
                (null, 'All'),
                (QueueStatus.delivered, 'Delivered'),
                (QueueStatus.deferred, 'Deferred'),
                (QueueStatus.bounced, 'Bounced'),
                (QueueStatus.pending, 'Pending'),
                (QueueStatus.delivering, 'Delivering'),
                (QueueStatus.expired, 'Expired'),
              ],
              value: _status,
              onChanged: (status) {
                setState(() => _filters = {..._filters}..remove('status'));
                if (status != null) _filters['status'] = status.name;
                unawaited(_list.reload());
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
      row: (entry) => RmRow(
        label: entry.recipient,
        subtitle: [
          '${queueStatusLabel(entry.status)} · ${timeLabel(entry.createdAt)}',
          'From ${entry.sender}',
          if (entry.lastError.isNotEmpty) entry.lastError,
        ].join('\n'),
        onTap: () => pushScreen(
          context,
          DeliveryScreen(account: widget.account, entry: entry),
        ),
      ),
    ),
  );
}

/// One message sent to another server, and how it went; with
/// `observability:read`, the way into its trace.
class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key, required this.account, required this.entry});

  final RestAccount account;
  final QueueEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final last = entry.lastAttempt, messageId = entry.messageId;
    return AdminPage(
      account: account,
      section: AdminSection.deliveryLog,
      title: 'Delivery',
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: 'To', value: entry.recipient),
              RmRow(label: 'From', value: entry.sender),
              RmRow(label: 'Status', value: queueStatusLabel(entry.status)),
              RmRow(
                label: 'Attempts',
                value: '${entry.attempts} of ${entry.maxRetries}',
              ),
              RmRow(label: 'Sent', value: longDate(entry.createdAt)),
              if (last != null) RmRow(label: 'Last try', value: longDate(last)),
            ],
          ),
          if (entry.lastError.isNotEmpty) ...[
            const SizedBox(height: 22),
            const SectionLabel('Last answer'),
            const SizedBox(height: 9),
            SelectableText(
              entry.lastError,
              style: rmText(14, color: c.ink2, height: 1.45),
            ),
          ],
          if (messageId != null && access.canRead(AdminSection.trace)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                RmRow(
                  label: 'Trace',
                  subtitle: 'Each filter it went through on its way out',
                  onTap: () => pushScreen(
                    context,
                    MessageTraceScreen(account: account, messageId: messageId),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 22),
          RmGroup(
            children: [
              RmRow(label: 'Entry', value: '${entry.id}'),
              if (entry.messageId case final id?)
                RmRow(label: 'Message', value: '$id'),
              RmRow(label: 'Destination domain', value: entry.domain),
              if (entry.bodyType.isNotEmpty)
                RmRow(label: 'Body type', value: entry.bodyType),
              if (entry.lastErrorCode != 0)
                RmRow(label: 'Reply code', value: '${entry.lastErrorCode}'),
              if (entry.failureCategory.isNotEmpty)
                RmRow(label: 'Failure category', value: entry.failureCategory),
              if (entry.nextAttempt case final at?)
                RmRow(label: 'Next try', value: longDate(at)),
              if (entry.expiresAt case final at?)
                RmRow(label: 'Expires', value: longDate(at)),
            ],
          ),
        ],
      ),
    );
  }
}
