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

String queueStatusLabel(BuildContext context, QueueStatus status) =>
    switch (status) {
      QueueStatus.pending => tr(context, 'admin.logs.pending'),
      QueueStatus.delivering => tr(context, 'admin.aliases.delivering'),
      QueueStatus.deferred => tr(context, 'admin.logs.deferred'),
      QueueStatus.delivered => tr(context, 'admin.logs.delivered'),
      QueueStatus.bounced => tr(context, 'admin.logs.bounced'),
      QueueStatus.expired => tr(context, 'admin.logs.expired'),
      QueueStatus.unknown => tr(context, 'admin.queue.unknown'),
    };

String attemptsLabel(int n) => n == 1 ? '1 attempt' : '$n attempts';

enum _BulkAction { retry, bounce, delete }

/// Mail on its way out to other servers: what is waiting, what was put off
/// and why, and what bounced. With `queue:manage`, an entry can be retried,
/// bounced or dropped.
class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  QueueFilter _filter = const QueueFilter();
  final _domain = TextEditingController();
  final _sender = TextEditingController();
  final _recipient = TextEditingController();
  final _selected = <int>{};
  var _selecting = false;
  var _allMatching = false;
  var _changing = false;
  var _opening = false;
  QueueStats? _stats;
  late final _list = AdminList<QueueEntry>(
    (offset) => widget.account.client.queue(
      status: _filter.status,
      domain: _filter.domain,
      sender: _filter.sender,
      recipient: _filter.recipient,
      offset: offset,
    ),
  );

  String get _host => widget.account.server.host;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.queue)) {
      unawaited(_reload());
    }
  }

  @override
  void dispose() {
    _list.dispose();
    _domain.dispose();
    _sender.dispose();
    _recipient.dispose();
    super.dispose();
  }

  Future<void> _reload() => Future.wait([_list.reload(), _loadStats()]);

  Future<void> _loadStats() async {
    try {
      final stats = await widget.account.client.queueStats();
      if (mounted) setState(() => _stats = stats);
    } on ApiException {
      // The list says what went wrong.
    }
  }

  Future<void> _open(QueueEntry entry) async {
    if (_selecting) {
      _select(entry.id);
      return;
    }
    if (_opening) return;
    _opening = true;
    QueueEntry fresh;
    try {
      fresh = await widget.account.client.queueEntry(entry.id);
    } on ApiException catch (error) {
      if (mounted) {
        showToast(context, describeAdminError(context, error, host: _host));
      }
      return;
    } finally {
      _opening = false;
    }
    if (!mounted) return;
    final done = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => QueueEntryScreen(account: widget.account, entry: fresh),
      ),
    );
    if (done == null || !mounted) return;
    showToast(context, done);
    unawaited(_reload());
  }

  String? _value(TextEditingController controller) =>
      controller.text.trim().isEmpty ? null : controller.text.trim();

  void _apply({QueueStatus? status, bool useFields = false}) {
    setState(() {
      _filter = QueueFilter(
        status: status,
        domain: useFields ? _value(_domain) : _filter.domain,
        sender: useFields ? _value(_sender) : _filter.sender,
        recipient: useFields ? _value(_recipient) : _filter.recipient,
      );
      _selected.clear();
      _allMatching = false;
    });
    unawaited(_list.reload());
  }

  void _select(int id) {
    if (_allMatching || _changing) return;
    if (!_selected.contains(id) && _selected.length == 1000) {
      showToast(
        context,
        tr(context, 'admin.queue.selectAtMost1000MessagesOrUse'),
      );
      return;
    }
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  Future<void> _bulk(_BulkAction action) async {
    if (_changing || (!_allMatching && _selected.isEmpty)) return;
    final selection = _allMatching
        ? QueueSelection.filter(_filter)
        : QueueSelection.ids(_selected.toList());
    final target = _allMatching
        ? _filter.toJson().isEmpty
              ? tr(context, 'admin.queue.theEntireQueue')
              : trArgs(context, 'admin.queue.allEntriesMatchingValue', {
                  'value':
                      (_filter
                              .toJson()
                              .entries
                              .map((e) => '${e.key}: ${e.value}')
                              .join(', '))
                          .toString(),
                })
        : trArgs(context, 'admin.queue.lengthSelectedMessages', {
            'length': (_selected.length).toString(),
          });
    final verb = switch (action) {
      _BulkAction.retry => tr(context, 'admin.queue.retry'),
      _BulkAction.bounce => tr(context, 'admin.queue.bounce'),
      _BulkAction.delete => tr(context, 'message.delete'),
    };
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'admin.queue.verbTheseMessages', {
        'verb': (verb).toString(),
      }),
      message: trArgs(
        context,
        'admin.queue.verbTargetAcrossAllMatchingPagesValue',
        {
          'verb': (verb).toString(),
          'target': (target).toString(),
          'value': (switch (action) {
            _BulkAction.retry =>
              'Only pending or deferred entries will be retried.',
            _BulkAction.bounce =>
              'Only entries still in flight will be marked bounced.',
            _BulkAction.delete =>
              'They leave the queue without delivery or notification.',
          }).toString(),
        },
      ),
      action: verb,
    );
    if (!sure || !mounted) return;
    setState(() => _changing = true);
    try {
      final client = widget.account.client;
      final result = await switch (action) {
        _BulkAction.retry => client.bulkRetryQueue(selection),
        _BulkAction.bounce => client.bulkBounceQueue(selection),
        _BulkAction.delete => client.bulkDeleteQueue(selection),
      };
      if (!mounted) return;
      setState(() {
        _selected.clear();
        _allMatching = false;
        _selecting = false;
      });
      showToast(
        context,
        trArgs(context, 'admin.queue.affectedQueueEntriesChanged', {
          'affected': (result.affected).toString(),
        }),
      );
      await _reload();
    } on ApiException catch (error) {
      if (mounted) {
        showToast(context, describeAdminError(context, error, host: _host));
      }
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final stats = _stats;
    return AdminPage(
      account: widget.account,
      section: AdminSection.queue,
      title: tr(context, 'admin.section.queue.title'),
      body: (access) => AdminListView(
        list: _list,
        host: _host,
        empty: _filter.status == null
            ? tr(context, 'admin.queue.nothingInTheQueue')
            : trArgs(context, 'admin.logs.nothingValue', {
                'value': (queueStatusLabel(
                  context,
                  _filter.status!,
                ).toLowerCase()).toString(),
              }),
        onRefresh: _reload,
        header: [
          if (stats != null) ...[
            Text(
              '${countLabel(stats.of(QueueStatus.pending))} pending · '
              '${countLabel(stats.of(QueueStatus.deferred))} deferred · '
              '${countLabel(stats.of(QueueStatus.bounced))} bounced',
              style: rmText(13, color: c.ink3),
            ),
            const SizedBox(height: 12),
            Text(
              '${stats.total} total · ${stats.of(QueueStatus.delivering)} delivering · '
              '${stats.of(QueueStatus.delivered)} delivered · ${stats.of(QueueStatus.expired)} expired',
              style: rmText(13, color: c.ink3),
            ),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RmSegmented<QueueStatus?>(
                options: [
                  (null, tr(context, 'contacts.all')),
                  for (final status in QueueStatus.values)
                    if (status != QueueStatus.unknown)
                      (status, queueStatusLabel(context, status)),
                ],
                value: _filter.status,
                onChanged: (status) {
                  if (!_changing) _apply(status: status);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          ExpansionTile(
            title: Text(tr(context, 'admin.queue.filterQueue')),
            children: [
              for (final (label, controller) in [
                (tr(context, 'admin.aliases.domain'), _domain),
                (tr(context, 'admin.queue.sender'), _sender),
                (tr(context, 'compose.recipient'), _recipient),
              ])
                TextField(
                  controller: controller,
                  enabled: !_changing,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(labelText: label),
                ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: _changing
                        ? null
                        : () => _apply(status: _filter.status, useFields: true),
                    child: Text(tr(context, 'admin.bans.applyFilters')),
                  ),
                  TextButton(
                    onPressed: _changing
                        ? null
                        : () {
                            _domain.clear();
                            _sender.clear();
                            _recipient.clear();
                            _apply(useFields: true);
                          },
                    child: Text(tr(context, 'admin.bans.clearFilters')),
                  ),
                ],
              ),
            ],
          ),
          if (access.canWrite(AdminSection.queue)) ...[
            TextButton(
              onPressed: _changing
                  ? null
                  : () => setState(() {
                      _selecting = !_selecting;
                      _selected.clear();
                      _allMatching = false;
                    }),
              child: Text(
                _selecting
                    ? tr(context, 'admin.queue.cancelSelection')
                    : tr(context, 'admin.queue.selectMessages'),
              ),
            ),
            if (_selecting) ...[
              CheckboxListTile(
                value: _allMatching,
                title: Text(tr(context, 'admin.queue.allMatchingEntries')),
                subtitle: Text(
                  tr(context, 'admin.queue.includesEveryMatchingPage'),
                ),
                onChanged: _changing
                    ? null
                    : (value) => setState(() {
                        _allMatching = value ?? false;
                        _selected.clear();
                      }),
              ),
              TextButton(
                onPressed: _changing || _allMatching
                    ? null
                    : () => setState(() {
                        _selected.addAll(
                          _list.items
                              .map((e) => e.id)
                              .where((id) => !_selected.contains(id))
                              .take(1000 - _selected.length),
                        );
                      }),
                child: Text(tr(context, 'admin.queue.selectLoadedMessages')),
              ),
              Text(
                _allMatching
                    ? tr(context, 'admin.queue.allMatchingEntriesSelected')
                    : '${_selected.length} selected',
              ),
              Wrap(
                children: [
                  for (final action in _BulkAction.values)
                    TextButton(
                      onPressed:
                          _changing || (!_allMatching && _selected.isEmpty)
                          ? null
                          : () => unawaited(_bulk(action)),
                      child: Text(
                        '${switch (action) {
                          _BulkAction.retry => 'Retry',
                          _BulkAction.bounce => 'Bounce',
                          _BulkAction.delete => 'Delete',
                        }} messages',
                      ),
                    ),
                ],
              ),
            ],
          ],
        ],
        row: (entry) => Row(
          children: [
            if (_selecting)
              Checkbox(
                value: _allMatching || _selected.contains(entry.id),
                onChanged: _changing || _allMatching
                    ? null
                    : (_) => _select(entry.id),
              ),
            Expanded(
              child: RmRow(
                label: entry.recipient,
                subtitle: [
                  '${queueStatusLabel(context, entry.status)} · ${attemptsLabel(entry.attempts)} · '
                      '${timeLabel(entry.createdAt)}',
                  if (entry.lastError.isNotEmpty) entry.lastError,
                ].join('\n'),
                onTap: () => unawaited(_open(entry)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One queued message, and what can be done with it. Pops with what was
/// done, for the queue to say.
class QueueEntryScreen extends StatefulWidget {
  const QueueEntryScreen({
    super.key,
    required this.account,
    required this.entry,
  });

  final RestAccount account;
  final QueueEntry entry;

  @override
  State<QueueEntryScreen> createState() => _QueueEntryScreenState();
}

class _QueueEntryScreenState extends State<QueueEntryScreen> {
  var _busy = false;

  Future<void> _act(
    Future<void> Function() change,
    String done, {
    ({String title, String message, String action})? confirm,
  }) async {
    setState(() => _busy = true);
    final ok = await runAdminChange(
      context,
      host: widget.account.server.host,
      change: change,
      confirm: confirm,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, done);
    } else {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final entry = widget.entry;
    final client = widget.account.client;
    final next = entry.nextAttempt;
    return AdminPage(
      account: widget.account,
      section: AdminSection.queue,
      title: tr(context, 'admin.queue.queuedMessage'),
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
        children: [
          RmGroup(
            children: [
              RmRow(label: tr(context, 'compose.to'), value: entry.recipient),
              RmRow(label: tr(context, 'compose.from'), value: entry.sender),
              RmRow(
                label: tr(context, 'admin.queue.queueID'),
                value: '${entry.id}',
              ),
              if (entry.messageId case final id?)
                RmRow(
                  label: tr(context, 'admin.queue.messageID'),
                  value: '$id',
                ),
              RmRow(
                label: tr(context, 'admin.logs.destinationDomain'),
                value: entry.domain,
              ),
              if (entry.bodyType.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.logs.bodyType'),
                  value: entry.bodyType,
                ),
              RmRow(
                label: tr(context, 'admin.logs.status'),
                value: queueStatusLabel(context, entry.status),
              ),
              RmRow(
                label: tr(context, 'admin.logs.attempts'),
                value: entry.maxRetries > 0
                    ? '${entry.attempts} of ${entry.maxRetries}'
                    : '${entry.attempts}',
              ),
              RmRow(
                label: tr(context, 'admin.pipelinelog.queued'),
                value: longDate(entry.createdAt),
              ),
              if (entry.lastAttempt case final at?)
                RmRow(
                  label: tr(context, 'admin.logs.lastTry'),
                  value: longDate(at),
                ),
              if (entry.expiresAt case final at?)
                RmRow(
                  label: tr(context, 'admin.logs.expires'),
                  value: longDate(at),
                ),
              if (entry.failureCategory.isNotEmpty)
                RmRow(
                  label: tr(context, 'admin.queue.failureType'),
                  value: entry.failureCategory.replaceAll('_', ' '),
                ),
              if (entry.lastErrorCode != 0)
                RmRow(
                  label: tr(context, 'admin.queue.smtpResponse'),
                  value: '${entry.lastErrorCode}',
                ),
              if (next != null && entry.status.canRetry)
                RmRow(
                  label: tr(context, 'admin.logs.nextTry'),
                  value: longDate(next),
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
          if (access.canWrite(AdminSection.queue) ||
              access.canDelete(AdminSection.queue)) ...[
            const SizedBox(height: 22),
            RmGroup(
              children: [
                if (access.canWrite(AdminSection.queue) &&
                    entry.status.canRetry)
                  RmRow(
                    label: tr(context, 'admin.queue.retryNow'),
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.retryQueueEntry(entry.id),
                              trArgs(context, 'admin.queue.retryingRecipient', {
                                'recipient': (entry.recipient).toString(),
                              }),
                            ),
                          ),
                  ),
                if (access.canWrite(AdminSection.queue) &&
                    entry.status.canRetry)
                  RmRow(
                    label: tr(context, 'admin.queue.bounceToSender'),
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.bounceQueueEntry(entry.id),
                              tr(context, 'admin.logs.bounced'),
                              confirm: (
                                title: tr(
                                  context,
                                  'admin.queue.bounceThisMessage',
                                ),
                                message: trArgs(
                                  context,
                                  'admin.queue.itIsNotTriedAgainAndSender',
                                  {
                                    'sender': (entry.sender).toString(),
                                    'recipient': (entry.recipient).toString(),
                                  },
                                ),
                                action: tr(context, 'admin.queue.bounce'),
                              ),
                            ),
                          ),
                  ),
                if (access.canDelete(AdminSection.queue))
                  RmRow(
                    label: tr(context, 'message.delete'),
                    danger: true,
                    onTap: _busy
                        ? null
                        : () => unawaited(
                            _act(
                              () => client.deleteQueueEntry(entry.id),
                              tr(context, 'message.deleted'),
                              confirm: (
                                title: tr(context, 'quarantine.deleteOne'),
                                message: tr(
                                  context,
                                  'admin.queue.itLeavesTheQueueWithoutBeingDelivered',
                                ),
                                action: tr(context, 'message.delete'),
                              ),
                            ),
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
