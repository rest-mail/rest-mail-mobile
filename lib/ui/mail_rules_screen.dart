import 'dart:async';

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
        _enabled ? 'Vacation reply is on' : 'Vacation reply is off',
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e.fields) {
          final f when f.containsKey('subject') || f.containsKey('body') =>
            'Add a subject and a message to turn the reply on.',
          final f when f.containsKey('end_date') =>
            "The last day can't be before the first.",
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
              title: 'Vacation reply',
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
                      'Send a vacation reply',
                      style: rmText(
                        14.5,
                        color: c.ink,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RmSwitch(
                    value: _enabled,
                    label: 'Send a vacation reply',
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
          'Each sender gets it once while it is on, not for every message.',
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 22),
        const SectionLabel('Subject'),
        const SizedBox(height: 8),
        TextField(
          controller: _subject,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() => _error = null),
          style: rmText(16, color: c.ink),
          decoration: const InputDecoration(hintText: 'Out of office'),
        ),
        const SizedBox(height: 22),
        const SectionLabel('Message'),
        const SizedBox(height: 8),
        TextField(
          controller: _body,
          minLines: 4,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() => _error = null),
          style: rmText(16, color: c.ink, height: 1.4),
          decoration: const InputDecoration(
            hintText: "I'm away until Monday and will reply then.",
          ),
        ),
        const SizedBox(height: 22),
        const SectionLabel('When'),
        const SizedBox(height: 8),
        RmGroup(
          children: [
            RmRow(
              label: 'First day',
              value: switch (_start) {
                final at? => days.format(at),
                null => 'Now',
              },
              trailing: _start == null
                  ? null
                  : _ClearDate(onClear: () => setState(() => _start = null)),
              onTap: _busy ? null : () => unawaited(_pick(start: true)),
            ),
            RmRow(
              label: 'Last day',
              value: switch (_end) {
                final at? => days.format(at),
                null => 'Until turned off',
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
          label: 'Save',
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
    tooltip: 'Clear',
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
            RmOutlineButton(label: 'Try again', height: 44, onPressed: onRetry),
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
      showToast(context, 'Filters saved');
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
      title: 'Delete the filters?',
      message:
          "This mailbox's mail is delivered to the inbox again, with no "
          'script to file, forward or refuse it.',
      action: 'Delete',
    );
    if (!sure || !mounted) return;
    setState(() => _busy = true);
    try {
      await _client.deleteSieveScript(widget.mailbox.id);
      if (!mounted) return;
      showToast(context, 'Filters deleted');
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
              title: 'Mail filters',
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
          'A Sieve script (RFC 5228) files, forwards or refuses this '
          "mailbox's mail as it arrives. REST Mail checks it before saving "
          'it, so a mistake is caught here, not when mail comes in.',
          style: rmText(13, color: c.ink3, height: 1.4),
        ),
        const SizedBox(height: 18),
        const SectionLabel('Script'),
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
              check.message.isEmpty ? 'The script is valid.' : check.message,
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
                      'Run on new mail',
                      style: rmText(
                        14.5,
                        color: c.ink,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RmSwitch(
                    value: _active,
                    label: 'Run on new mail',
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
                label: 'Check',
                height: 48,
                onPressed: _busy ? null : () => unawaited(_validate()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RmPrimaryButton(
                label: 'Save',
                busy: _busy,
                onPressed: _busy ? null : () => unawaited(_save()),
              ),
            ),
          ],
        ),
        if (_stored) ...[
          const SizedBox(height: 12),
          RmOutlineButton(
            label: 'Delete filters',
            color: c.danger,
            onPressed: _busy ? null : () => unawaited(_delete()),
          ),
        ],
      ],
    );
  }
}
