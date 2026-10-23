import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String traceOutcomeLabel(String outcome) => switch (outcome) {
  'delivered' => 'Delivered',
  'queued' => 'Sent on its way',
  'rejected' => 'Turned away',
  'quarantined' => 'Held in quarantine',
  'discarded' => 'Dropped',
  'deferred' => 'Put off',
  _ => outcome,
};

/// Why mail was turned away, held or put off, from the server's reason
/// code.
String reasonLabel(String code) => switch (code) {
  'spam_threshold' => 'Scored as spam',
  'dmarc_reject' => 'Failed DMARC',
  'dmarc_quarantine' => 'Failed DMARC, held',
  'spf_fail' => 'Failed SPF',
  'greylist_defer' => 'Greylisted',
  'size_exceeded' => 'Too large',
  'rate_limited' => 'Sent too fast',
  'virus_detected' => 'Carried a virus',
  'recipient_unknown' => 'No such recipient',
  'header_invalid' => 'Broken headers',
  'custom_reject' => 'Turned away by a filter',
  'other' => 'Other',
  _ => code,
};

String traceActionLabel(String action) => switch (action) {
  'continue' => 'Passed',
  'reject' => 'Turned away',
  'quarantine' => 'Quarantined',
  'discard' => 'Dropped',
  'defer' => 'Put off',
  _ => action,
};

/// What a filter found, in a line; none when it said nothing.
String? _stageNote(TraceStage stage) {
  if (stage.skipped) {
    return stage.skipReason.isEmpty
        ? 'Skipped'
        : 'Skipped: ${stage.skipReason}';
  }
  if (stage.error.isNotEmpty) return stage.error;
  final note = [
    stage.result,
    stage.detail,
  ].where((s) => s.isNotEmpty).join(' · ');
  return note.isEmpty ? null : note;
}

/// Finds a message's trace by the number the server stores it under, for a
/// message not reached from the delivery log.
class TraceLookupScreen extends StatefulWidget {
  const TraceLookupScreen({super.key, required this.account});

  final RestAccount account;

  @override
  State<TraceLookupScreen> createState() => _TraceLookupScreenState();
}

class _TraceLookupScreenState extends State<TraceLookupScreen> {
  final _number = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  int? get _id => int.tryParse(_number.text.trim());

  void _open() {
    final id = _id;
    if (id == null) return;
    pushScreen(
      context,
      MessageTraceScreen(account: widget.account, messageId: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return AdminPage(
      account: widget.account,
      section: AdminSection.trace,
      title: 'Message trace',
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
        children: [
          Text(
            [
              'Each filter a message went through, and what it found.',
              if (access.canRead(AdminSection.deliveryLog))
                'Open one from the delivery log, or enter the number the '
                    'server keeps it under.'
              else
                'Enter the number the server keeps it under.',
            ].join(' '),
            style: rmText(15, color: c.ink2, height: 1.45),
          ),
          const SizedBox(height: 18),
          const SectionLabel('Message number'),
          const SizedBox(height: 8),
          TextField(
            controller: _number,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _open(),
            style: rmText(16, color: c.ink),
            decoration: const InputDecoration(hintText: '1042'),
          ),
          const SizedBox(height: 26),
          RmPrimaryButton(
            label: 'Show trace',
            onPressed: _id == null ? null : _open,
          ),
        ],
      ),
    );
  }
}

/// How one message went through the filters: where it came from, how it
/// ended, and each step on the way.
class MessageTraceScreen extends StatefulWidget {
  const MessageTraceScreen({
    super.key,
    required this.account,
    required this.messageId,
  });

  final RestAccount account;
  final int messageId;

  @override
  State<MessageTraceScreen> createState() => _MessageTraceScreenState();
}

class _MessageTraceScreenState extends State<MessageTraceScreen> {
  MessageTrace? _trace;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    if (AdminAccess(widget.account.capabilities).canRead(AdminSection.trace)) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final trace = await widget.account.client.messageTrace(widget.messageId);
      if (mounted) setState(() => _trace = trace);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trace = _trace, error = _error;
    return AdminPage(
      account: widget.account,
      section: AdminSection.trace,
      title: 'Message ${widget.messageId}',
      body: (_) {
        if (error != null) {
          return AdminMessage(
            error.statusCode == 404
                ? 'There is no trace for message ${widget.messageId}. Mail '
                      'that was turned away never became a message, and '
                      'traces are kept for a while only.'
                : describeAdminError(
                    context,
                    error,
                    host: widget.account.server.host,
                  ),
            onRetry: error.statusCode == 404 ? null : () => unawaited(_load()),
          );
        }
        if (trace == null) {
          return const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return TraceDetails(trace: trace);
      },
    );
  }
}

/// How one message went through the filters: where it came from, how it
/// ended, and each step on the way.
class TraceDetails extends StatelessWidget {
  const TraceDetails({super.key, required this.trace});

  final MessageTrace trace;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final score = trace.spamScore;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
      children: [
        RmGroup(
          children: [
            RmRow(label: 'Outcome', value: traceOutcomeLabel(trace.outcome)),
            if (trace.reasonCode.isNotEmpty)
              RmRow(label: 'Why', value: reasonLabel(trace.reasonCode)),
            RmRow(
              label: 'Direction',
              value: trace.direction == 'inbound' ? 'Coming in' : 'Going out',
            ),
            if (trace.mailFrom.isNotEmpty)
              RmRow(label: 'From', value: trace.mailFrom),
            if (trace.rcptTo.isNotEmpty)
              RmRow(label: 'To', value: trace.rcptTo),
            if (trace.clientIp.isNotEmpty)
              RmRow(label: 'Sent by', value: trace.clientIp),
            if (trace.transport.isNotEmpty)
              RmRow(
                label: 'Over',
                value: trace.transport == 'tls' ? 'TLS' : 'No encryption',
              ),
            if (score != null)
              RmRow(label: 'Spam score', value: score.toStringAsFixed(1)),
            RmRow(label: 'Took', value: '${trace.durationMs} ms'),
            RmRow(label: 'When', value: longDate(trace.createdAt)),
          ],
        ),
        if (trace.stages.isNotEmpty) ...[
          const SizedBox(height: 22),
          const SectionLabel('Filters, in order'),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final stage in trace.stages)
                RmRow(
                  label: stage.filter,
                  subtitle: [
                    ?_stageNote(stage),
                    if (stage.filterType.isNotEmpty) stage.filterType,
                    '${stage.durationMilliseconds} ms',
                  ].join(' · '),
                  onTap: () => pushScreen(
                    context,
                    Scaffold(
                      body: SafeArea(
                        child: Column(
                          children: [
                            RmTopBar(
                              title: stage.filter,
                              onBack: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(20),
                                children: [
                                  Text(
                                    '${stage.filterType} · ${stage.durationMilliseconds} ms',
                                  ),
                                  Text(
                                    stage.skipped
                                        ? 'Skipped: ${stage.skipReason}'
                                        : traceActionLabel(stage.action),
                                  ),
                                  if (stage.error.isNotEmpty) Text(stage.error),
                                  const SizedBox(height: 16),
                                  SelectableText(prettyJson(stage.log)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  value: stage.skipped ? null : traceActionLabel(stage.action),
                ),
            ],
          ),
        ],
        const SizedBox(height: 22),
        RmGroup(
          children: [
            RmRow(label: 'Trace number', value: '${trace.id}'),
            RmRow(label: 'Pipeline number', value: '${trace.pipelineId}'),
            if (trace.messageId case final id?)
              RmRow(label: 'Stored message', value: '$id'),
            RmRow(
              label: 'Final action',
              value: traceActionLabel(trace.finalAction),
            ),
            RmRow(
              label: 'Sampling retained',
              value: trace.sampled ? 'Yes' : 'No',
            ),
            if (trace.expiresAt case final at?)
              RmRow(label: 'Retained until', value: longDate(at)),
          ],
        ),
        if (trace.rfcMessageId.isNotEmpty) ...[
          const SizedBox(height: 22),
          const SectionLabel('Message-ID'),
          const SizedBox(height: 9),
          SelectableText(
            trace.rfcMessageId,
            style: rmText(13, color: c.ink2, height: 1.45),
          ),
        ],
      ],
    );
  }
}
