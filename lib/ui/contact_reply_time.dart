import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/mail_backend.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'widgets/common.dart';

const _minute = 60, _hour = 3600, _day = 86400;

/// How quickly a contact usually replies, in the current language, or null
/// when there is nothing to show: the account's setting is off, or its history
/// holds too few replies. Rounded to the largest unit it reaches, as the
/// webmail rounds it.
String? contactReplyTimeLabel(BuildContext context, int? seconds) {
  if (seconds == null || seconds <= 0) return null;
  if (seconds < _minute) return tr(context, 'contacts.replyTimeUnderMinute');
  final (divisor, one, many) = seconds >= _day
      ? (_day, 'contacts.replyTimeDay', 'contacts.replyTimeDays')
      : seconds >= _hour
      ? (_hour, 'contacts.replyTimeHour', 'contacts.replyTimeHours')
      : (_minute, 'contacts.replyTimeMinute', 'contacts.replyTimeMinutes');
  final amount = (seconds / divisor).round();
  return amount == 1
      ? tr(context, one)
      : trArgs(context, many, {'count': countLabel(amount)});
}

/// The figure beside a contact, and on a long press where it comes from.
/// Takes no space when there is nothing to show.
class ContactReplyTime extends StatelessWidget {
  const ContactReplyTime({super.key, required this.seconds});

  final int? seconds;

  @override
  Widget build(BuildContext context) {
    final label = contactReplyTimeLabel(context, seconds);
    if (label == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Tooltip(
        message: tr(context, 'contacts.replyTimeNote'),
        child: Text(
          label,
          style: rmText(12, color: context.rm.ink3, height: 1.35),
        ),
      ),
    );
  }
}

/// The figure beside a message's sender: looked up among the account's
/// contacts by exact address. Nothing shows until it answers, or if it fails.
/// Give it a key of the account and the address.
class SenderReplyTime extends StatefulWidget {
  const SenderReplyTime({
    super.key,
    required this.backend,
    required this.accountId,
    required this.email,
  });

  final MailBackend backend;
  final int accountId;
  final String email;

  @override
  State<SenderReplyTime> createState() => _SenderReplyTimeState();
}

class _SenderReplyTimeState extends State<SenderReplyTime> {
  int? _seconds;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final email = widget.email.toLowerCase();
    try {
      final found = await widget.backend.suggestContacts(
        widget.accountId,
        widget.email,
      );
      if (!mounted) return;
      final contact = found
          .where((row) => row.email.toLowerCase() == email)
          .firstOrNull;
      setState(() => _seconds = contact?.usualReplySeconds);
    } on ApiException {
      // The figure only helps: none when it cannot be had.
    }
  }

  @override
  Widget build(BuildContext context) => ContactReplyTime(seconds: _seconds);
}

/// The account's opt-in, off by default, read from and saved to the server.
/// Give it a key of the account: it holds one account's answer.
class ContactReplyTimeSettings extends StatefulWidget {
  const ContactReplyTimeSettings({
    super.key,
    required this.backend,
    required this.accountId,
  });

  final MailBackend backend;
  final int accountId;

  @override
  State<ContactReplyTimeSettings> createState() =>
      _ContactReplyTimeSettingsState();
}

class _ContactReplyTimeSettingsState extends State<ContactReplyTimeSettings> {
  /// Null until the server answers: unknown, so it cannot be changed.
  bool? _enabled;
  bool _saving = false;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final enabled = await widget.backend.contactReplyTimeEnabled(
        widget.accountId,
      );
      if (mounted) setState(() => _enabled = enabled);
    } on ApiException {
      if (mounted) {
        setState(() => _errorKey = 'contacts.replyTimeLoadFailed');
      }
    }
  }

  Future<void> _save(bool value) async {
    setState(() {
      _saving = true;
      _errorKey = null;
    });
    try {
      final saved = await widget.backend.setContactReplyTimeEnabled(
        widget.accountId,
        value,
      );
      if (mounted) setState(() => _enabled = saved);
    } on ApiException {
      if (mounted) {
        setState(() => _errorKey = 'contacts.replyTimeSaveFailed');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final enabled = _enabled, errorKey = _errorKey;
    final toggle = tr(context, 'contacts.replyTimeToggle');
    final status = enabled == null && errorKey == null
        ? tr(context, 'contacts.replyTimeLoading')
        : _saving
        ? tr(context, 'contacts.replyTimeSaving')
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(tr(context, 'contacts.replyTimeSetting')),
        const SizedBox(height: 9),
        RmGroup(
          children: [
            RmRow(
              label: toggle,
              subtitle: tr(context, 'contacts.replyTimeHelp'),
              trailing: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: RmSwitch(
                  value: enabled ?? false,
                  label: toggle,
                  onChanged: enabled == null || _saving
                      ? null
                      : (value) => unawaited(_save(value)),
                ),
              ),
            ),
          ],
        ),
        if (status != null) ...[
          const SizedBox(height: 8),
          Semantics(
            liveRegion: true,
            child: Text(status, style: rmText(12.5, color: c.ink3)),
          ),
        ],
        if (errorKey != null) ...[
          const SizedBox(height: 8),
          ErrorText(tr(context, errorKey)),
        ],
      ],
    );
  }
}
