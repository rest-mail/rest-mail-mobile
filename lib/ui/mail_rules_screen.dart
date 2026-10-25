import 'dart:async';

import '../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_state.dart';
import '../theme/tokens.dart';
import 'widgets/common.dart';

/// A mailbox's vacation reply: on or off, its subject and message, and the
/// days it is sent between. For the session's own mailbox, or one it holds
/// mail rights on, which [mailbox] is.
class VacationReplyScreen extends StatefulWidget {
  const VacationReplyScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<VacationReplyScreen> createState() => _VacationReplyScreenState();
}

class _VacationReplyScreenState extends State<VacationReplyScreen> {
  final _subject = TextEditingController();
  final _body = TextEditingController();
  bool _enabled = false;
  DateTime? _start;
  DateTime? _end;
  bool _loaded = false;
  Object? _loadError;
  bool _busy = false;
  String? _error;

  RestmailClient get _client => widget.account.client;
  String get _host => widget.account.host;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loaded = false;
      _loadError = null;
    });
    try {
      final reply = await _client.vacation(widget.mailbox.id);
      if (!mounted) return;
      setState(() {
        _enabled = reply.enabled;
        _subject.text = reply.subject;
        _body.text = reply.body;
        _start = reply.startDate;
        _end = reply.endDate;
        _loaded = true;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loaded = true;
      });
    }
  }

  Future<void> _pick({required bool start}) async {
    final now = DateTime.now();
    final current = start ? _start : _end;
    final day = await showDatePicker(
      context: context,
      initialDate: current ?? (start ? now : (_start ?? now)),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (day == null || !mounted) return;
    setState(() {
      _error = null;
      if (start) {
        _start = day;
      } else {
        // The whole last day: the reply is sent until it ends.
        _end = DateTime(day.year, day.month, day.day, 23, 59, 59);
      }
    });
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _client.setVacation(
        widget.mailbox.id,
        enabled: _enabled,
        subject: _subject.text.trim(),
        body: _body.text.trim(),
        startDate: _start,
        endDate: _end,
      );
      if (!mounted) return;
      showToast(
        context,
        _enabled
            ? tr(context, 'mailrules.vacationReplyIsOn')
            : tr(context, 'mailrules.vacationReplyIsOff'),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e.fields) {
          final f when f.containsKey('subject') || f.containsKey('body') => tr(
            context,
            'mailrules.addASubjectAndAMessageTo',
          ),
          final f when f.containsKey('end_date') => tr(
            context,
            'mailrules.theLastDayCanTBeBefore',
          ),
          _ => describeError(context, e, host: _host),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailrules.vacationReply'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(child: _content(context, c)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, RmColors c) {
    if (!_loaded) {
      return Center(
        child: SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
        ),
      );
    }
    if (_loadError case final error?) {
      return _LoadFailed(
        message: describeError(context, error, host: _host),
        onRetry: () => unawaited(_load()),
      );
    }
    final error = _error;
    final days = DateFormat.yMMMd();
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
      children: [
        RmGroup(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(context, 'mailrules.sendAVacationReply'),
                      style: rmText(
                        14.5,
                        color: c.ink,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RmSwitch(
                    value: _enabled,
                    label: tr(context, 'mailrules.sendAVacationReply'),
                    onChanged: (on) => setState(() {
                      _enabled = on;
                      _error = null;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          tr(context, 'mailrules.eachSenderGetsItOnceWhileIt'),
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(context, 'compose.subject')),
        const SizedBox(height: 8),
        TextField(
          controller: _subject,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _error = null),
          style: rmText(16, color: c.ink),
          decoration: InputDecoration(
            hintText: tr(context, 'mailrules.outOfOffice'),
          ),
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(context, 'admin.logs.message')),
        const SizedBox(height: 8),
        TextField(
          controller: _body,
          minLines: 4,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() => _error = null),
          style: rmText(16, color: c.ink, height: 1.4),
          decoration: InputDecoration(
            hintText: tr(context, 'mailrules.iMAwayUntilMondayAndWill'),
          ),
        ),
        const SizedBox(height: 22),
        SectionLabel(tr(context, 'admin.audit.when')),
        const SizedBox(height: 8),
        RmGroup(
          children: [
            RmRow(
              label: tr(context, 'mailrules.firstDay'),
              value: switch (_start) {
                final at? => days.format(at),
                null => tr(context, 'mailrules.now'),
              },
              trailing: _start == null
                  ? null
                  : _ClearDate(onClear: () => setState(() => _start = null)),
              onTap: _busy ? null : () => unawaited(_pick(start: true)),
            ),
            RmRow(
              label: tr(context, 'mailrules.lastDay'),
              value: switch (_end) {
                final at? => days.format(at),
                null => tr(context, 'mailrules.untilTurnedOff'),
              },
              trailing: _end == null
                  ? null
                  : _ClearDate(onClear: () => setState(() => _end = null)),
              onTap: _busy ? null : () => unawaited(_pick(start: false)),
            ),
          ],
        ),
        if (error != null) ...[const SizedBox(height: 16), ErrorText(error)],
        const SizedBox(height: 26),
        RmPrimaryButton(
          label: tr(context, 'common.save'),
          busy: _busy,
          onPressed: _busy ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}

class _ClearDate extends StatelessWidget {
  const _ClearDate({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tr(context, 'admin.suppressions.clear'),
    icon: Icon(Icons.close_rounded, size: 18, color: context.rm.ink3),
    onPressed: onClear,
  );
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: rmText(14, color: c.ink2, height: 1.4),
            ),
            const SizedBox(height: 14),
            RmOutlineButton(
              label: tr(context, 'health.retry'),
              height: 44,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// A mailbox's Sieve script (RFC 5228), which files, forwards or refuses its
/// mail: shown, edited, checked, saved and deleted. The server checks every
/// script before it saves it, and says why one would not run.
class MailFiltersScreen extends StatefulWidget {
  const MailFiltersScreen({
    super.key,
    required this.account,
    required this.mailbox,
  });

  final RestAccount account;
  final Account mailbox;

  @override
  State<MailFiltersScreen> createState() => _MailFiltersScreenState();
}

class _MailFiltersScreenState extends State<MailFiltersScreen> {
  final _script = TextEditingController();
  bool _active = true;
  bool _stored = false;
  bool _loaded = false;
  Object? _loadError;
  bool _busy = false;

  /// The last check's answer, or the refusal of the last save.
  SieveValidation? _check;

  RestmailClient get _client => widget.account.client;
  String get _host => widget.account.host;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _script.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loaded = false;
      _loadError = null;
    });
    try {
      final script = await _client.sieveScript(widget.mailbox.id);
      if (!mounted) return;
      setState(() {
        _script.text = script.script;
        _active = script.stored ? script.active : true;
        _stored = script.stored;
        _loaded = true;
        _check = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loaded = true;
      });
    }
  }

  Future<void> _validate() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final check = await _client.validateSieveScript(
        widget.mailbox.id,
        _script.text,
      );
      if (mounted) setState(() => _check = check);
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeError(context, e, host: _host));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _check = null;
    });
    try {
      await _client.putSieveScript(
        widget.mailbox.id,
        _script.text,
        active: _active,
      );
      if (!mounted) return;
      showToast(context, tr(context, 'mailrules.filtersSaved'));
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (e.code == 'invalid_sieve') {
          _check = SieveValidation(valid: false, message: e.message);
        }
      });
      if (e.code != 'invalid_sieve') {
        showToast(context, describeError(context, e, host: _host));
      }
    }
  }

  Future<void> _delete() async {
    if (_busy) return;
    final sure = await confirmAction(
      context,
      title: tr(context, 'mailrules.deleteTheFilters'),
      message: tr(context, 'mailrules.thisMailboxSMailIsDeliveredTo'),
      action: tr(context, 'message.delete'),
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await _client.deleteSieveScript(widget.mailbox.id);
      if (!mounted) return;
      showToast(context, tr(context, 'mailrules.filtersDeleted'));
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, describeError(context, e, host: _host));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: tr(context, 'mailrules.mailFilters'),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(child: _content(context, c)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, RmColors c) {
    if (!_loaded) {
      return Center(
        child: SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent),
        ),
      );
    }
    if (_loadError case final error?) {
      return _LoadFailed(
        message: describeError(context, error, host: _host),
        onRetry: () => unawaited(_load()),
      );
    }
    final check = _check;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
      children: [
        Text(
          tr(context, 'mailrules.aSieveScriptRFC5228FilesForwards'),
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 18),
        SectionLabel(tr(context, 'mailrules.script')),
        const SizedBox(height: 8),
        TextField(
          controller: _script,
          minLines: 10,
          maxLines: 24,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.multiline,
          onChanged: (_) => setState(() => _check = null),
          style: rmText(13.5, color: c.ink, height: 1.4, family: 'monospace'),
          decoration: const InputDecoration(
            hintText:
                'require "fileinto";\n'
                'if header :contains "subject" "invoice" {\n'
                '  fileinto "Invoices";\n'
                '}',
          ),
        ),
        if (check != null) ...[
          const SizedBox(height: 12),
          if (check.valid)
            Text(
              check.message.isEmpty
                  ? tr(context, 'mailrules.theScriptIsValid')
                  : check.message,
              style: rmText(13.5, color: c.accent, weight: FontWeight.w600),
            )
          else
            ErrorText(check.message),
        ],
        const SizedBox(height: 18),
        RmGroup(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(context, 'mailrules.runOnNewMail'),
                      style: rmText(
                        14.5,
                        color: c.ink,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RmSwitch(
                    value: _active,
                    label: tr(context, 'mailrules.runOnNewMail'),
                    onChanged: (on) => setState(() => _active = on),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: RmOutlineButton(
                label: tr(context, 'mailrules.check'),
                height: 48,
                onPressed: _busy ? null : () => unawaited(_validate()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RmPrimaryButton(
                label: tr(context, 'common.save'),
                busy: _busy,
                onPressed: _busy ? null : () => unawaited(_save()),
              ),
            ),
          ],
        ),
        if (_stored) ...[
          const SizedBox(height: 12),
          RmOutlineButton(
            label: tr(context, 'mailrules.deleteFilters'),
            color: c.danger,
            onPressed: _busy ? null : () => unawaited(_delete()),
          ),
        ],
      ],
    );
  }
}
