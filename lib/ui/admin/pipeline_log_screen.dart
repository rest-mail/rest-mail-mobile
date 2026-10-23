import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';
import 'trace_screen.dart';
import 'report_filters.dart';

String _directionLabel(String direction) =>
    direction == 'inbound' ? 'Coming in' : 'Going out';

/// Every message the filters handled, newest first, mail turned away before
/// it became a message too. Each entry holds its whole trace, so opening
/// one needs nothing more from the server.
class PipelineLogScreen extends StatefulWidget {
  const PipelineLogScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<PipelineLogScreen> createState() => _PipelineLogScreenState();
}

class _PipelineLogScreenState extends State<PipelineLogScreen> {
  Map<String, String> _filters = {};
  String? get _outcome => _filters['outcome'];
  late final _list = AdminList<MessageTrace>(
    (offset) => widget.account.client.pipelineLog(
      outcome: _outcome,
      offset: offset,
      pipelineId: reportInt(_filters, 'pipeline_id'),
      direction: _filters['direction'],
      action: _filters['action'],
      rfcMessageId: _filters['rfc_message_id'],
      reasonCode: _filters['reason_code'],
      limit: reportInt(_filters, 'limit') ?? 50,
    ),
  );

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.pipelineLog)) {
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
    section: AdminSection.pipelineLog,
    title: 'Pipeline log',
    body: (_) => AdminListView(
      list: _list,
      host: widget.account.server.host,
      empty: switch (_outcome) {
        final outcome? =>
          'Nothing ${traceOutcomeLabel(outcome).toLowerCase()}.',
        null => 'No mail has been through the filters yet.',
      },
      header: [
        ReportFiltersBar(
          host: widget.account.server.host,
          values: _filters,
          intro: 'Leave fields empty to include all messages. Message-ID and reason code match exactly.',
          fields: const [
            ReportField('pipeline_id', 'Pipeline number', number: true),
            ReportField(
              'direction',
              'Direction',
              choices: [
                ('', 'Both'),
                ('inbound', 'Coming in'),
                ('outbound', 'Going out'),
              ],
            ),
            ReportField(
              'action',
              'Final action',
              choices: [
                ('', 'All'),
                ('continue', 'Passed'),
                ('reject', 'Turned away'),
                ('quarantine', 'Quarantined'),
                ('discard', 'Dropped'),
                ('defer', 'Put off'),
              ],
            ),
            ReportField(
              'outcome',
              'Outcome',
              choices: [
                ('', 'All'),
                ('delivered', 'Delivered'),
                ('queued', 'Queued'),
                ('rejected', 'Turned away'),
                ('quarantined', 'Quarantined'),
                ('discarded', 'Dropped'),
                ('deferred', 'Put off'),
              ],
            ),
            ReportField('rfc_message_id', 'Message-ID'),
            ReportField('reason_code', 'Reason code'),
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
            child: RmSegmented<String?>(
              options: const [
                (null, 'All'),
                ('delivered', 'Delivered'),
                ('rejected', 'Turned away'),
                ('quarantined', 'Quarantined'),
                ('queued', 'Queued'),
                ('discarded', 'Dropped'),
                ('deferred', 'Put off'),
              ],
              value: _outcome,
              onChanged: (outcome) {
                setState(() => _filters = {..._filters}..remove('outcome'));
                if (outcome != null) _filters['outcome'] = outcome;
                unawaited(_list.reload());
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
      row: (trace) {
        final inbound = trace.direction == 'inbound';
        // Who it was from coming in, and who it was for going out.
        final who = inbound ? trace.mailFrom : trace.rcptTo;
        return RmRow(
          label: who.isNotEmpty ? who : 'No address',
          subtitle: [
            '${_directionLabel(trace.direction)} · '
                '${traceOutcomeLabel(trace.outcome)} · '
                '${timeLabel(trace.createdAt)}',
            if (inbound && trace.rcptTo.isNotEmpty) 'To ${trace.rcptTo}',
            if (!inbound && trace.mailFrom.isNotEmpty) 'From ${trace.mailFrom}',
            if (trace.reasonCode.isNotEmpty && trace.reasonCode != 'other')
              reasonLabel(trace.reasonCode),
          ].join('\n'),
          onTap: () => pushScreen(
            context,
            PipelineTraceScreen(account: widget.account, trace: trace),
          ),
        );
      },
    ),
  );
}

/// One entry of the pipeline log: its trace, as the log holds it.
class PipelineTraceScreen extends StatelessWidget {
  const PipelineTraceScreen({
    super.key,
    required this.account,
    required this.trace,
  });

  final RestAccount account;
  final MessageTrace trace;

  @override
  Widget build(BuildContext context) => AdminPage(
    account: account,
    section: AdminSection.pipelineLog,
    title: switch (trace.messageId) {
      final id? => 'Message $id',
      null => 'Trace',
    },
    body: (_) => TraceDetails(trace: trace),
  );
}

/// How far back the analytics count.
enum _Window {
  day('A day', Duration(days: 1)),
  week('A week', Duration(days: 7));

  const _Window(this.label, this.duration);

  final String label;
  final Duration duration;
}

/// What the filters did with the last day's or week's mail, as the server
/// counts it: how mail arrived, how each message ended, why mail was turned
/// away, how senders fared on SPF, DKIM and DMARC, and what each filter
/// decided. Only to look at.
class PipelineAnalyticsScreen extends StatefulWidget {
  const PipelineAnalyticsScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<PipelineAnalyticsScreen> createState() =>
      _PipelineAnalyticsScreenState();
}

class _PipelineAnalyticsScreenState extends State<PipelineAnalyticsScreen> {
  var _window = _Window.day;
  Map<String, String> _filters = {};
  var _live = false;
  PipelineAnalytics? _analytics;
  ApiException? _error;

  /// The window the shown numbers are for; a slower answer for another one
  /// is dropped.
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities)
        .canRead(AdminSection.pipelineAnalytics)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;
    try {
      final analytics = await widget.account.client.pipelineAnalytics(
        window: _window.duration,
        windowText: _filters['window'],
        since: reportDate(_filters, 'since'),
      );
      if (mounted && generation == _generation) {
        setState(() {
          _analytics = analytics;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted && generation == _generation) setState(() => _error = e);
    }
  }

  void _show(_Window window) {
    setState(() {
      _window = window;
      _filters = {};
      _analytics = null;
      _error = null;
    });
    unawaited(_load());
  }

  /// A heading and a card of counted rows, or nothing when there are none.
  List<Widget> _counted(
    String title,
    List<({String label, String? subtitle, num count})> rows,
  ) => [
    if (rows.isNotEmpty) ...[
      const SizedBox(height: 22),
      SectionLabel(title),
      const SizedBox(height: 9),
      RmGroup(
        children: [
          for (final row in rows)
            RmRow(
              label: row.label,
              subtitle: row.subtitle,
              value: row.count % 1 == 0 && row.count.abs() <= 9007199254740991
                  ? countLabel(row.count.toInt())
                  : '${row.count}',
            ),
        ],
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final analytics = _analytics, error = _error;
    final PipelineFunnel? funnel = _live ? analytics?.liveTotals : analytics;
    return AdminPage(
      account: widget.account,
      section: AdminSection.pipelineAnalytics,
      title: 'Pipeline analytics',
      body: (_) => RefreshIndicator(
        color: c.accent,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            ReportFiltersBar(
              host: widget.account.server.host,
              values: _filters,
              title: 'Custom period',
              intro: 'Choose a Go duration such as 90m or 1h30m, or a start time with a timezone. A start time takes precedence.',
              fields: [
                ReportField(
                  'window',
                  'Look back',
                  hint: '90m',
                  validate: positiveGoDuration,
                ),
                reportSince,
              ],
              onChanged: (values) {
                setState(() {
                  _filters = values;
                  _analytics = null;
                  _error = null;
                });
                unawaited(_load());
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RmSegmented<_Window?>(
                options: [for (final w in _Window.values) (w, w.label)],
                value: _filters.isEmpty ? _window : null,
                onChanged: (window) {
                  if (window != null) _show(window);
                },
              ),
            ),
            if (error != null)
              AdminMessage(
                describeAdminError(
                  context,
                  error,
                  host: widget.account.server.host,
                ),
                onRetry: () => unawaited(_load()),
              )
            else if (analytics == null)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else ...[
              if (analytics.liveTotals != null)
                SwitchListTile(
                  title: const Text('Since process start'),
                  subtitle: const Text(
                    'Cumulative live counters, independent of the selected period',
                  ),
                  value: _live,
                  onChanged: (value) => setState(() => _live = value),
                ),
              const SizedBox(height: 12),
              Text(
                _live
                    ? 'Cumulative since this server process started'
                    : '${longDate(analytics.since)} to ${longDate(analytics.until)}${analytics.windowLabel.isEmpty ? '' : ' · ${analytics.windowLabel}'}',
                style: rmText(13, color: c.ink3),
              ),
              if (funnel == null || funnel.isEmpty)
                AdminMessage(
                  _live
                      ? 'No live counters are available.'
                      : 'No mail went through the filters since ${longDate(analytics.since)}.',
                )
              else ...[
                ..._counted('How it ended', [
                  for (final o in funnel.outcomes)
                    (
                      label: traceOutcomeLabel(o.outcome),
                      subtitle: _directionLabel(o.direction),
                      count: o.count,
                    ),
                ]),
                ..._counted('Arrived from other servers', [
                  for (final r in funnel.received)
                    (
                      label: r.transport == 'tls'
                          ? 'Over TLS'
                          : 'No encryption',
                      subtitle: null,
                      count: r.count,
                    ),
                ]),
                ..._counted('Why mail was turned away', [
                  for (final r in funnel.rejectReasons)
                    (
                      label: reasonLabel(r.reason),
                      subtitle: null,
                      count: r.count,
                    ),
                ]),
                ..._counted('Sender checks', [
                  for (final v in funnel.senderChecks)
                    (
                      label: '${v.mechanism.toUpperCase()}: ${v.result}',
                      subtitle: null,
                      count: v.count,
                    ),
                ]),
                ..._counted('What each filter did', [
                  for (final d in funnel.decisions)
                    (
                      label: d.filter,
                      subtitle: traceActionLabel(d.action),
                      count: d.count,
                    ),
                ]),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
