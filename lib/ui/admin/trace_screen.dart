import 'dart:async';

import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/admin_access.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import '../widgets/common.dart';
import 'admin_widgets.dart';

String traceOutcomeLabel(BuildContext context, String outcome) =>
    switch (outcome) {
      'delivered' => tr(context, 'admin.logs.delivered'),
      'queued' => tr(context, 'admin.trace.sentOnItsWay'),
      'rejected' => tr(context, 'admin.pipelinelog.turnedAway'),
      'quarantined' => tr(context, 'admin.trace.heldInQuarantine'),
      'discarded' => tr(context, 'admin.pipelinelog.dropped'),
      'deferred' => tr(context, 'admin.pipelinelog.putOff'),
      _ => outcome,
    };

/// Why mail was turned away, held or put off, from the server's reason
/// code.
String reasonLabel(BuildContext context, String code) => switch (code) {
  'spam_threshold' => tr(context, 'quarantine.reason.spam'),
  'dmarc_reject' => tr(context, 'quarantine.reason.dmarc'),
  'dmarc_quarantine' => tr(context, 'admin.trace.failedDMARCHeld'),
  'spf_fail' => tr(context, 'quarantine.reason.spf'),
  'greylist_defer' => tr(context, 'quarantine.reason.greylist'),
  'size_exceeded' => tr(context, 'quarantine.reason.size'),
  'rate_limited' => tr(context, 'quarantine.reason.rate'),
  'virus_detected' => tr(context, 'quarantine.reason.virus'),
  'recipient_unknown' => tr(context, 'admin.trace.noSuchRecipient'),
  'header_invalid' => tr(context, 'quarantine.reason.headers'),
  'custom_reject' => tr(context, 'admin.trace.turnedAwayByAFilter'),
  'other' => tr(context, 'admin.trace.other'),
  _ => code,
};

String traceActionLabel(BuildContext context, String action) =>
    switch (action) {
      'continue' => tr(context, 'admin.pipelinelog.passed'),
      'reject' => tr(context, 'admin.pipelinelog.turnedAway'),
      'quarantine' => tr(context, 'admin.pipelinelog.quarantined'),
      'discard' => tr(context, 'admin.pipelinelog.dropped'),
      'defer' => tr(context, 'admin.pipelinelog.putOff'),
      _ => action,
    };

/// What a filter found, in a line; none when it said nothing.
String? _stageNote(BuildContext context, TraceStage stage) {
  if (stage.skipped) {
    return stage.skipReason.isEmpty
        ? tr(context, 'admin.trace.skipped')
        : trArgs(context, 'admin.trace.skippedSkipReason', {
            'skipReason': (stage.skipReason).toString(),
          });
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
      title: tr(context, 'admin.section.trace.title'),
      body: (access) => ListView(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
        children: [
          Text(
            [
              tr(context, 'admin.trace.eachFilterAMessageWentThroughAnd'),
              if (access.canRead(AdminSection.deliveryLog))
                tr(context, 'admin.trace.openOneFromTheDeliveryLogOr')
              else
                tr(context, 'admin.trace.enterTheNumberTheServerKeepsIt'),
            ].join(' '),
            style: rmText(15, color: c.ink2, height: 1.45),
          ),
          const SizedBox(height: 18),
          SectionLabel(tr(context, 'admin.trace.messageNumber')),
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
            label: tr(context, 'admin.trace.showTrace'),
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
      title: trArgs(context, 'admin.trace.messageMessageId', {
        'messageId': (widget.messageId).toString(),
      }),
      body: (_) {
        if (error != null) {
          return AdminMessage(
            error.statusCode == 404
                ? trArgs(
                    context,
                    'admin.trace.thereIsNoTraceForMessageMessageId',
                    {'messageId': (widget.messageId).toString()},
                  )
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
            RmRow(
              label: tr(context, 'admin.audit.outcome'),
              value: traceOutcomeLabel(context, trace.outcome),
            ),
            if (trace.reasonCode.isNotEmpty)
              RmRow(
                label: tr(context, 'quarantine.why'),
                value: reasonLabel(context, trace.reasonCode),
              ),
            RmRow(
              label: tr(context, 'admin.filtereditors.direction'),
              value: trace.direction == 'inbound'
                  ? tr(context, 'admin.pipelinelog.comingIn')
                  : tr(context, 'admin.pipelinelog.goingOut'),
            ),
            if (trace.mailFrom.isNotEmpty)
              RmRow(label: tr(context, 'compose.from'), value: trace.mailFrom),
            if (trace.rcptTo.isNotEmpty)
              RmRow(label: tr(context, 'compose.to'), value: trace.rcptTo),
            if (trace.clientIp.isNotEmpty)
              RmRow(
                label: tr(context, 'admin.trace.sentBy'),
                value: trace.clientIp,
              ),
            if (trace.transport.isNotEmpty)
              RmRow(
                label: tr(context, 'admin.trace.over'),
                value: trace.transport == 'tls'
                    ? 'TLS'
                    : tr(context, 'admin.pipelinelog.noEncryption'),
              ),
            if (score != null)
              RmRow(
                label: tr(context, 'quarantine.score'),
                value: score.toStringAsFixed(1),
              ),
            RmRow(
              label: tr(context, 'admin.trace.took'),
              value: '${trace.durationMs} ms',
            ),
            RmRow(
              label: tr(context, 'admin.audit.when'),
              value: longDate(trace.createdAt),
            ),
          ],
        ),
        if (trace.stages.isNotEmpty) ...[
          const SizedBox(height: 22),
          SectionLabel(tr(context, 'admin.pipelines.filtersInOrder')),
          const SizedBox(height: 9),
          RmGroup(
            children: [
              for (final stage in trace.stages)
                RmRow(
                  label: stage.filter,
                  subtitle: [
                    ?_stageNote(context, stage),
                    if (stage.filterType.isNotEmpty) stage.filterType,
                    '${stage.durationMs} ms',
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
                                    '${stage.filterType} · ${stage.durationMs} ms',
                                  ),
                                  Text(
                                    stage.skipped
                                        ? trArgs(
                                            context,
                                            'admin.trace.skippedSkipReason',
                                            {
                                              'skipReason': (stage.skipReason)
                                                  .toString(),
                                            },
                                          )
                                        : traceActionLabel(
                                            context,
                                            stage.action,
                                          ),
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
                  value: stage.skipped
                      ? null
                      : traceActionLabel(context, stage.action),
                ),
            ],
          ),
        ],
        const SizedBox(height: 22),
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'admin.trace.traceNumber'),
              value: '${trace.id}',
            ),
            RmRow(
              label: tr(context, 'admin.pipelinelog.pipelineNumber'),
              value: '${trace.pipelineId}',
            ),
            if (trace.messageId case final id?)
              RmRow(
                label: tr(context, 'admin.trace.storedMessage'),
                value: '$id',
              ),
            RmRow(
              label: tr(context, 'admin.pipelinelog.finalAction'),
              value: traceActionLabel(context, trace.finalAction),
            ),
            RmRow(
              label: tr(context, 'admin.trace.samplingRetained'),
              value: trace.sampled
                  ? tr(context, 'admin.keys.yes')
                  : tr(context, 'admin.keys.no'),
            ),
            if (trace.expiresAt case final at?)
              RmRow(
                label: tr(context, 'admin.trace.retainedUntil'),
                value: longDate(at),
              ),
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
