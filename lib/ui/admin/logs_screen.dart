import 'dart:async';

import '../../l10n/voice.dart';

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
    title: tr(context, 'admin.section.deliveryLog.title'),
    body: (access) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: _status == null
          ? tr(context, 'admin.logs.nothingHasGoneOutYet')
          : trArgs(context, 'admin.logs.nothingValue', {
              'value': (queueStatusLabel(
                context,
                _status!,
              ).toLowerCase()).toString(),
            }),
      header: [
        ReportFiltersBar(
          host: widget.account.server.host,
          values: _filters,
          fields: [
            ReportField(
              'status',
              tr(context, 'admin.logs.status'),
              choices: [
                ('', tr(context, 'contacts.all')),
                for (final s in QueueStatus.values)
                  if (s != QueueStatus.unknown)
                    (s.name, queueStatusLabel(context, s)),
              ],
            ),
            ReportField('domain', tr(context, 'admin.logs.destinationDomain')),
            ReportField('sender', tr(context, 'admin.logs.senderContains')),
            ReportField(
              'recipient',
              tr(context, 'admin.logs.recipientContains'),
            ),
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
              options: [
                (null, tr(context, 'contacts.all')),
                (QueueStatus.delivered, tr(context, 'admin.logs.delivered')),
                (QueueStatus.deferred, tr(context, 'admin.logs.deferred')),
                (QueueStatus.bounced, tr(context, 'admin.logs.bounced')),
                (QueueStatus.pending, tr(context, 'admin.logs.pending')),
                (
                  QueueStatus.delivering,
                  tr(context, 'admin.aliases.delivering'),
                ),
                (QueueStatus.expired, tr(context, 'admin.logs.expired')),
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
          '${queueStatusLabel(context, entry.status)} · ${timeLabel(entry.createdAt)}',
          trArgs(context, 'admin.logs.fromSender', {
            'sender': (entry.sender).toString(),
          }),
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
      title: tr(context, 'admin.logs.delivery'),
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: tr(context, 'compose.to'), value: entry.recipient),
              RmRow(label: tr(context, 'compose.from'), value: entry.sender),
              RmRow(
                label: tr(context, 'admin.logs.status'),
                value: queueStatusLabel(context, entry.status),
              ),
              RmRow(
                label: tr(context, 'admin.logs.attempts'),
                value: trArgs(context, 'ui.attemptsOfMaxRetries', {
                  'attempts': (entry.attempts).toString(),
                  'maxRetries': (entry.maxRetries).toString(),
                }),
              ),
              RmRow(
                label: tr(context, 'folder.sent'),
                value: longDate(entry.createdAt),
              ),
              if (last != null)
                RmRow(
                  label: tr(context, 'admin.logs.lastTry'),
                  value: longDate(last),
                ),
            ],
          ),
          if (entry.lastError.isNotEmpty) ...[
            const SizedBox(height: 22),
            SectionLabel(tr(context, 'admin.logs.lastAnswer')),
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
                  label: tr(context, 'admin.logs.trace'),
                  subtitle: tr(
                    context,
                    'admin.logs.eachFilterItWentThroughOnIts',
                  ),
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
              RmRow(
                label: tr(context, 'admin.logs.entry'),
                value: '${entry.id}',
              ),
              if (entry.messageId case final id?)
                RmRow(label: tr(context, 'admin.logs.message'), value: '$id'),
              RmRow(
                label: tr(context, 'admin.logs.destinationDomain'),
                value: entry.domain,
              ),
              if (entry.bodyType.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.logs.bodyType'),
                  value: entry.bodyType,
                ),
              if (entry.lastErrorCode != 0)
                RmRow(
                  label: tr(context, 'admin.logs.replyCode'),
                  value: '${entry.lastErrorCode}',
                ),
              if (entry.failureCategory.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.logs.failureCategory'),
                  value: entry.failureCategory,
                ),
              if (entry.nextAttempt case final at?)
                RmRow(
                  label: tr(context, 'admin.logs.nextTry'),
                  value: longDate(at),
                ),
              if (entry.expiresAt case final at?)
                RmRow(
                  label: tr(context, 'admin.logs.expires'),
                  value: longDate(at),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
