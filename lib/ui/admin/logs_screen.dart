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
  QueueStatus? _status;
  late final _list = AdminList<QueueEntry>(
    (offset) =>
        widget.account.client.deliveryLog(status: _status, offset: offset),
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
              ],
              value: _status,
              onChanged: (status) {
                setState(() => _status = status);
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
              RmRow(label: 'Attempts', value: '${entry.attempts}'),
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
        ],
      ),
    );
  }
}
