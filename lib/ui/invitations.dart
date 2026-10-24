import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'message_screen.dart';
import 'widgets/common.dart';

/// What an answer is called on its button.
String calendarResponseLabel(BuildContext context, CalendarResponse response) =>
    tr(context, switch (response) {
      CalendarResponse.accepted => 'invite.accept',
      CalendarResponse.tentative => 'invite.tentative',
      CalendarResponse.declined => 'invite.decline',
    });

/// The answer [address] gave [event] already, as its attendee line says.
CalendarResponse? answerOf(CalendarInvite event, String address) {
  for (final attendee in event.attendees) {
    if (attendee.address.toLowerCase() == address.toLowerCase()) {
      return CalendarResponse.fromValue(attendee.partStat);
    }
  }
  return null;
}

/// When an event is, on one line: its day and start, and its end.
String eventWhen(CalendarInvite event) {
  final start = event.start?.toLocal(), end = event.end?.toLocal();
  if (start == null) return '';
  if (end == null || !end.isAfter(start)) return longDate(start);
  final sameDay =
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;
  return sameDay
      ? '${longDate(start)} – ${timeLabel(end, now: end)}'
      : '${longDate(start)} – ${longDate(end)}';
}

/// The invitation a message carries, or its cancellation: what, when,
/// where and who from, and for an invitation, the three answers.
class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.event,
    required this.answered,
    required this.busy,
    required this.onAnswer,
  });

  final CalendarInvite event;

  /// The answer given, here or before; highlighted.
  final CalendarResponse? answered;
  final bool busy;
  final ValueChanged<CalendarResponse>? onAnswer;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final cancelled = event.method == 'CANCEL' || event.status == 'CANCELLED';
    final when = eventWhen(event), answered = this.answered;
    final organizer = event.organizer;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: cancelled ? c.danger : c.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                cancelled ? Icons.event_busy_outlined : Icons.event_outlined,
                size: 18,
                color: cancelled ? c.danger : c.accent,
              ),
              const SizedBox(width: 8),
              Text(
                tr(context, cancelled ? 'invite.cancelled' : 'invite.title'),
                style: rmText(
                  12,
                  color: cancelled ? c.danger : c.accent,
                  weight: FontWeight.w700,
                  tracking: 0.05,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.summary,
            style: rmText(16, color: c.ink, weight: FontWeight.w700),
          ),
          if (when.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(when, style: rmText(13.5, color: c.ink2)),
          ],
          if (event.location case final location?) ...[
            const SizedBox(height: 2),
            Text(location, style: rmText(13.5, color: c.ink2)),
          ],
          if (organizer != null) ...[
            const SizedBox(height: 2),
            Text(
              trArgs(context, 'invite.from', {'name': organizer.label}),
              style: rmText(12.5, color: c.ink3),
            ),
          ],
          if (cancelled) ...[
            const SizedBox(height: 8),
            Text(
              tr(context, 'invite.cancelledNote'),
              style: rmText(12.5, color: c.ink2, height: 1.4),
            ),
          ] else if (onAnswer case final answer?) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                for (final (i, response) in const [
                  CalendarResponse.accepted,
                  CalendarResponse.tentative,
                  CalendarResponse.declined,
                ].indexed) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Semantics(
                      selected: response == answered,
                      child: RmOutlineButton(
                        label: calendarResponseLabel(context, response),
                        height: 40,
                        color: response == answered ? c.accent : null,
                        onPressed: busy ? null : () => answer(response),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (answered != null) ...[
              const SizedBox(height: 8),
              Text(
                tr(context, 'invite.answered.${answered.name}'),
                style: rmText(12.5, color: c.ink3),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// The events the account has invitations for, each once, its latest
/// version: opening one opens the message it came in. REST Mail only.
class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({
    super.key,
    required this.mailbox,
    required this.accountId,
  });

  final MailboxState mailbox;
  final int accountId;

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  List<CalendarEventSummary>? _events;
  ApiException? _error;

  MailboxState get _mailbox => widget.mailbox;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final events = await _mailbox.backend.calendarEvents(widget.accountId);
      if (mounted) {
        setState(() {
          _events = events;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _open(CalendarEventSummary event) async {
    final id = event.messageId;
    if (id == null) {
      showToast(context, tr(context, 'invites.gone'));
      return;
    }
    try {
      final message = await _mailbox.backend.message(id);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => MessageScreen(mailbox: _mailbox, message: message),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      showToast(
        context,
        e.statusCode == 404
            ? tr(context, 'invites.gone')
            : describeError(context, e, host: _mailbox.backend.host),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final events = _events, error = _error;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'invites.title'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: switch ((events, error)) {
                (_, final ApiException e) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          describeError(
                            context,
                            e,
                            host: _mailbox.backend.host,
                          ),
                          textAlign: TextAlign.center,
                          style: rmText(14, color: c.ink2, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        RmOutlineButton(
                          label: tr(context, 'invites.retry'),
                          height: 44,
                          onPressed: () => unawaited(_load()),
                        ),
                      ],
                    ),
                  ),
                ),
                (null, _) => Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.accent,
                    ),
                  ),
                ),
                (final List<CalendarEventSummary> list, _) => RefreshIndicator(
                  color: c.accent,
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                    children: [
                      if (list.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Text(
                            tr(context, 'invites.empty'),
                            textAlign: TextAlign.center,
                            style: rmText(
                              14.5,
                              color: c.ink2,
                              weight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        RmGroup(
                          children: [
                            for (final event in list)
                              RmRow(
                                label: event.summary.isEmpty
                                    ? tr(context, 'invite.title')
                                    : event.summary,
                                subtitle: event.isCancelled
                                    ? tr(context, 'invite.cancelled')
                                    : event.versions > 1
                                    ? trArgs(context, 'invites.versions', {
                                        'count': countLabel(event.versions),
                                      })
                                    : null,
                                danger: event.isCancelled,
                                onTap: () => unawaited(_open(event)),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
