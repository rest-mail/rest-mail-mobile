import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/app_scope.dart';
import '../state/interface_prefs.dart';
import '../state/mail_backend.dart';
import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import 'widgets/common.dart';

/// Opens the compose sheet over the current screen, signed per the settings.
Future<void> openCompose(
  BuildContext context, {
  required MailboxState mailbox,
  ComposeSeed seed = const ComposeSeed(),
}) {
  final settings = AppScope.read(context).settings;
  final signs = switch (seed.kind) {
    ComposeKind.fresh => true,
    ComposeKind.reply || ComposeKind.forward => settings.signReplies,
    ComposeKind.draft => false,
  };
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Closing goes through the sheet's own close, which offers to keep a
    // draft; a stray tap on the scrim or a drag must not throw text away.
    isDismissible: false,
    enableDrag: false,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ComposeSheet(
      mailbox: mailbox,
      seed: signs ? seed.signedWith(settings.signature) : seed,
    ),
  );
}

enum _CloseChoice { save, discard, keepEditing }

class ComposeSheet extends StatefulWidget {
  const ComposeSheet({super.key, required this.mailbox, required this.seed});

  final MailboxState mailbox;
  final ComposeSeed seed;

  @override
  State<ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<ComposeSheet>
    with SingleTickerProviderStateMixin {
  /// How long the message waits before it is really sent, so it can be
  /// taken back.
  static const _undoSeconds = 5;

  late final _to = TextEditingController(text: widget.seed.to.join(', '));
  late final _cc = TextEditingController(text: widget.seed.cc.join(', '));
  final _bcc = TextEditingController();
  late final _subject = TextEditingController(text: widget.seed.subject);
  late final _body = TextEditingController(text: widget.seed.body);
  final _toFocus = FocusNode();
  final _bodyFocus = FocusNode();

  late String _from = _initialFrom();
  late bool _showCc = widget.seed.cc.isNotEmpty;
  late bool _showFrom = _mailbox.accounts.length > 1;
  late int? _draftId = widget.seed.draftId;
  late final String _pristine;
  bool _interfaceApplied = false;
  bool _expanded = false;
  bool _sending = false;
  bool _saving = false;
  bool _counting = false;
  bool _showLater = false;
  String? _error;
  ({List<String> to, List<String> cc, List<String> bcc})? _pendingSend;
  late final AnimationController _undo;

  MailboxState get _mailbox => widget.mailbox;
  MailBackend get _backend => _mailbox.backend;
  bool get _busy => _sending || _saving || _counting;
  bool get _dirty => _snapshot() != _pristine;

  @override
  void initState() {
    super.initState();
    _undo =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: _undoSeconds),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) unawaited(_commitSend());
        });
    _pristine = _snapshot();
    // With someone to write to already, start in the body, above any quote.
    final startInBody = widget.seed.to.isNotEmpty;
    if (startInBody) _body.selection = const TextSelection.collapsed(offset: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) (startInBody ? _bodyFocus : _toFocus).requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_interfaceApplied) return;
    _interfaceApplied = true;
    // The composer's panels decide what is open when it first appears; the
    // user can still ask for Cc while writing when they are off.
    final prefs = AppScope.read(context).settings.interface;
    if (prefs.isOn(composerCcPanel)) _showCc = true;
    if (prefs.isOn(composerFromPanel)) _showFrom = true;
    _showLater =
        prefs.isOn(composerLaterPanel) &&
        _backend.canScheduleSend &&
        widget.seed.kind != ComposeKind.draft;
  }

  @override
  void dispose() {
    for (final controller in [_to, _cc, _bcc, _subject, _body]) {
      controller.dispose();
    }
    _toFocus.dispose();
    _bodyFocus.dispose();
    _undo.dispose();
    super.dispose();
  }

  String _initialFrom() {
    final own = [for (final a in _mailbox.accounts) a.address];
    final wanted = widget.seed.from?.toLowerCase();
    return own.where((a) => a.toLowerCase() == wanted).firstOrNull ??
        _mailbox.account?.address ??
        own.firstOrNull ??
        '';
  }

  String _snapshot() => [
    _from,
    _to.text,
    _cc.text,
    _bcc.text,
    _subject.text,
    _body.text,
  ].join('\u0000');

  String get _title => switch (widget.seed.kind) {
    ComposeKind.fresh => 'New message',
    ComposeKind.reply => 'Reply',
    ComposeKind.forward => 'Forward',
    ComposeKind.draft => 'Draft',
  };

  OutgoingMessage _message({
    required List<String> to,
    List<String> cc = const [],
    List<String> bcc = const [],
  }) => OutgoingMessage(
    from: _from,
    to: to,
    cc: cc,
    bcc: bcc,
    subject: _subject.text.trim(),
    bodyText: _body.text,
    inReplyTo: widget.seed.inReplyTo,
    references: widget.seed.references,
  );

  void _send() {
    if (_busy) return;
    final to = parseAddresses(_to.text),
        cc = parseAddresses(_cc.text),
        bcc = parseAddresses(_bcc.text);
    final invalid = [...to.invalid, ...cc.invalid, ...bcc.invalid];
    if (invalid.isNotEmpty) {
      setState(() => _error = 'Not an address: ${invalid.first}');
      return;
    }
    if (to.valid.isEmpty && cc.valid.isEmpty && bcc.valid.isEmpty) {
      setState(() => _error = 'Add someone to send it to.');
      return;
    }
    setState(() {
      _error = null;
      _counting = true;
      _pendingSend = (to: to.valid, cc: cc.valid, bcc: bcc.valid);
    });
    _undo.forward(from: 0);
  }

  /// Takes the send back while the message is still waiting.
  void _undoSend() {
    _undo.reset();
    setState(() {
      _counting = false;
      _pendingSend = null;
    });
  }

  Future<void> _commitSend() async {
    final pending = _pendingSend;
    if (pending == null) return;
    setState(() {
      _pendingSend = null;
      _counting = false;
      _sending = true;
      _error = null;
    });
    final message = _message(to: pending.to, cc: pending.cc, bcc: pending.bcc);
    try {
      final draftId = _draftId;
      if (draftId != null && pending.bcc.isEmpty) {
        await _backend.updateDraft(draftId, message);
        await _backend.sendDraft(draftId);
      } else {
        // The draft endpoints have no Bcc, so a draft that gained one is
        // sent as a new message and the draft put in Trash.
        await _backend.send(message);
        if (draftId != null) {
          unawaited(
            _backend
                .deleteMessage(draftId)
                .then<void>((_) {}, onError: (Object _) {}),
          );
        }
      }
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Message sent')));
      unawaited(_mailbox.refresh());
    } on ApiException catch (e) {
      if (!mounted) return;
      _undo.reset();
      setState(() {
        _sending = false;
        _error = describeError(e, host: _backend.host);
      });
    }
  }

  /// Holds the message with the server until a time the user picks.
  Future<void> _schedule() async {
    if (_busy) return;
    final to = parseAddresses(_to.text),
        cc = parseAddresses(_cc.text),
        bcc = parseAddresses(_bcc.text);
    final invalid = [...to.invalid, ...cc.invalid, ...bcc.invalid];
    if (invalid.isNotEmpty) {
      setState(() => _error = 'Not an address: ${invalid.first}');
      return;
    }
    if (to.valid.isEmpty && cc.valid.isEmpty && bcc.valid.isEmpty) {
      setState(() => _error = 'Add someone to send it to.');
      return;
    }
    final at = await _pickSendTime();
    if (at == null || !mounted) return;
    if (at.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
      setState(() => _error = 'Pick a time at least a minute from now.');
      return;
    }
    final when =
        '${MaterialLocalizations.of(context).formatMediumDate(at)} at '
        '${TimeOfDay.fromDateTime(at).format(context)}';
    setState(() {
      _saving = true;
      _error = null;
    });
    final message = _message(to: to.valid, cc: cc.valid, bcc: bcc.valid);
    try {
      final scheduled = await _backend.schedule(message, at);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Scheduled for $when'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => unawaited(
              _backend.cancelScheduledSend(scheduled.id).catchError((Object _) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Could not cancel the scheduled message.'),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = describeError(e, host: _backend.host);
      });
    }
  }

  Future<DateTime?> _pickSendTime() {
    final now = DateTime.now();
    DateTime tomorrowMorning() => DateTime(now.year, now.month, now.day + 1, 8);
    DateTime mondayMorning() {
      var day = DateTime(now.year, now.month, now.day);
      do {
        day = day.add(const Duration(days: 1));
      } while (day.weekday != DateTime.monday);
      return DateTime(day.year, day.month, day.day, 8);
    }

    return showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      builder: (sheet) {
        final label = MaterialLocalizations.of(sheet);
        String when(DateTime time) =>
            '${label.formatMediumDate(time)} · '
            '${TimeOfDay.fromDateTime(time).format(sheet)}';
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: Text(
                  'Send later',
                  style: rmText(
                    17,
                    color: context.rm.ink,
                    weight: FontWeight.w700,
                    tracking: -0.02,
                  ),
                ),
              ),
              RmGroup(
                children: [
                  RmRow(
                    label: 'In an hour',
                    subtitle: when(now.add(const Duration(hours: 1))),
                    onTap: () =>
                        Navigator.pop(sheet, now.add(const Duration(hours: 1))),
                  ),
                  RmRow(
                    label: 'Tomorrow morning',
                    subtitle: when(tomorrowMorning()),
                    onTap: () => Navigator.pop(sheet, tomorrowMorning()),
                  ),
                  RmRow(
                    label: 'Monday morning',
                    subtitle: when(mondayMorning()),
                    onTap: () => Navigator.pop(sheet, mondayMorning()),
                  ),
                  RmRow(
                    label: 'Pick a date and time',
                    onTap: () async {
                      final date = await showDatePicker(
                        context: sheet,
                        initialDate: now.add(const Duration(hours: 1)),
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                      );
                      if (date == null || !sheet.mounted) return;
                      final time = await showTimePicker(
                        context: sheet,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (time == null || !sheet.mounted) return;
                      Navigator.pop(
                        sheet,
                        DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveDraft() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    // Whatever is not yet a whole address is left off the draft.
    final draft = _message(
      to: parseAddresses(_to.text).valid,
      cc: parseAddresses(_cc.text).valid,
    );
    try {
      final draftId = _draftId;
      final saved = draftId == null
          ? await _backend.saveDraft(draft)
          : await _backend.updateDraft(draftId, draft);
      _draftId = saved.id;
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Draft saved')));
      unawaited(_mailbox.refresh());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = describeError(e, host: _backend.host);
      });
    }
  }

  Future<void> _close() async {
    if (_busy) return;
    if (!_dirty) {
      Navigator.pop(context);
      return;
    }
    final c = context.rm;
    final choice = await showDialog<_CloseChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _draftId == null
              ? 'Keep this as a draft?'
              : 'Save changes to the draft?',
        ),
        content: const Text('A saved draft waits in Drafts for you to finish.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _CloseChoice.discard),
            child: Text(
              'Discard',
              style: rmText(14.5, color: c.danger, weight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _CloseChoice.keepEditing),
            child: Text(
              'Keep editing',
              style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _CloseChoice.save),
            child: Text(
              'Save draft',
              style: rmText(14.5, color: c.accent, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (choice) {
      case _CloseChoice.discard:
        Navigator.pop(context);
      case _CloseChoice.save:
        await _saveDraft();
      case _CloseChoice.keepEditing || null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final accounts = _mailbox.accounts;
    final error = _error;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_close());
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: LayoutBuilder(
          builder: (context, box) {
            // Most of the screen, as the design has it, until there is
            // typing to do or the user asks for all of it.
            final height = _expanded || keyboard > 0
                ? box.maxHeight
                : min(box.maxHeight, (box.maxHeight + keyboard) * 0.62);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: const Cubic(0.2, 0.8, 0.2, 1),
              height: height,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(4, 8, 10, 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.line)),
                    ),
                    child: Row(
                      children: [
                        RmIconButton(
                          icon: _expanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          tooltip: _expanded ? 'Shrink' : 'Expand',
                          color: c.ink2,
                          onPressed: () =>
                              setState(() => _expanded = !_expanded),
                        ),
                        Expanded(
                          child: Text(
                            _title,
                            style: rmText(
                              15,
                              color: c.ink,
                              weight: FontWeight.w700,
                              tracking: -0.02,
                            ),
                          ),
                        ),
                        RmIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Close',
                          color: c.ink2,
                          onPressed: _busy ? null : () => unawaited(_close()),
                        ),
                        const SizedBox(width: 4),
                        if (_showLater)
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _busy
                                ? null
                                : () => unawaited(_schedule()),
                            child: Text(
                              'Later',
                              style: rmText(
                                13,
                                color: c.accent,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        _SendButton(
                          busy: _sending || _counting,
                          onPressed: _busy ? null : _send,
                        ),
                      ],
                    ),
                  ),
                  if (error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: c.danger.withValues(alpha: 0.08),
                      child: Text(
                        error,
                        style: rmText(
                          13,
                          color: c.danger,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_showFrom)
                    _FieldRow(
                      label: 'From',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _from,
                          isExpanded: true,
                          isDense: true,
                          dropdownColor: c.bg,
                          style: rmText(15, color: c.ink),
                          items: [
                            for (final account in accounts)
                              DropdownMenuItem(
                                value: account.address,
                                child: Text(
                                  account.address,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: _counting
                              ? null
                              : (address) =>
                                    setState(() => _from = address ?? _from),
                        ),
                      ),
                    ),
                  _FieldRow(
                    label: 'To',
                    trailing: _showCc
                        ? null
                        : TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _counting
                                ? null
                                : () => setState(() => _showCc = true),
                            child: Text(
                              'Cc',
                              style: rmText(
                                13,
                                color: c.accent,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                    child: _AddressField(
                      controller: _to,
                      focusNode: _toFocus,
                      hint: 'Recipient',
                      enabled: !_counting,
                    ),
                  ),
                  if (_showCc) ...[
                    _FieldRow(
                      label: 'Cc',
                      child: _AddressField(
                        controller: _cc,
                        hint: '',
                        enabled: !_counting,
                      ),
                    ),
                    _FieldRow(
                      label: 'Bcc',
                      child: _AddressField(
                        controller: _bcc,
                        hint: '',
                        enabled: !_counting,
                      ),
                    ),
                  ],
                  _FieldRow(
                    label: 'Subject',
                    child: TextField(
                      controller: _subject,
                      enabled: !_counting,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      style: rmText(15, color: c.ink, weight: FontWeight.w600),
                      decoration: bareInput(context, 'Subject'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _body,
                      focusNode: _bodyFocus,
                      enabled: !_counting,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.top,
                      style: rmText(15.5, color: c.ink, height: 1.6),
                      decoration: bareInput(context, 'Write…', size: 15.5)
                          .copyWith(
                            contentPadding: const EdgeInsets.fromLTRB(
                              16,
                              14,
                              16,
                              14,
                            ),
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border(top: BorderSide(color: c.line)),
                    ),
                    child: _counting
                        ? AnimatedBuilder(
                            animation: _undo,
                            builder: (context, _) {
                              final left = (_undoSeconds * (1 - _undo.value))
                                  .ceil()
                                  .clamp(1, _undoSeconds);
                              return Row(
                                children: [
                                  Icon(
                                    Icons.schedule_send_rounded,
                                    size: 14,
                                    color: c.ink3,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Sending in ${left}s',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: rmText(
                                        11.5,
                                        color: c.ink3,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: _undoSend,
                                    child: Text(
                                      'Undo',
                                      style: rmText(
                                        12.5,
                                        color: c.accent,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 14,
                                color: c.ink3,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Sending as $_from',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: rmText(
                                    11.5,
                                    color: c.ink3,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.child, this.trailing});

  final String label;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Text(
              label,
              style: rmText(13, color: c.ink3, weight: FontWeight.w600),
            ),
          ),
          Expanded(child: child),
          ?trailing,
        ],
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    focusNode: focusNode,
    enabled: enabled,
    keyboardType: TextInputType.emailAddress,
    autocorrect: false,
    enableSuggestions: false,
    textInputAction: TextInputAction.next,
    style: rmText(15, color: context.rm.ink),
    decoration: bareInput(context, hint),
  );
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final shape = BorderRadius.circular(9);
    return Opacity(
      opacity: onPressed == null && !busy ? 0.5 : 1,
      child: Material(
        color: c.accent,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: busy
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Send',
                    style: rmText(
                      14,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
