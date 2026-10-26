import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../l10n/voice.dart';
import '../state/app_scope.dart';
import '../state/interface_prefs.dart';
import '../state/mailbox_state.dart';
import '../theme/packs.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/format.dart';
import 'attachments.dart';
import 'compose_sheet.dart';
import 'invitations.dart';
import 'labels_sheet.dart';
import 'mail_actions.dart';
import 'message_source_screen.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/message_body.dart';
import 'widgets/trust_receipt.dart';
import 'widgets/trust_badge.dart';
import 'widgets/message_row.dart';

enum _More {
  markUnread,
  flag,
  note,
  labels,
  spam,
  notSpam,
  block,
  source,
  forwardOriginal,
}

/// One message, read in full, with reply, reply all and forward along the
/// bottom. On Gmail, with its labels, and the rest of its conversation
/// below.
class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.mailbox,
    required this.message,
    this.others = const [],
  });

  final MailboxState mailbox;

  /// The message as the list had it; the full one is fetched on open.
  final Message message;

  /// The rest of its conversation in the folder on screen, which opening
  /// marks read and archive, delete, spam and labels act on too, as the
  /// list showed them as one row.
  final List<Message> others;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late Message _message = widget.message;
  bool _loaded = false;
  ApiException? _error;
  List<Attachment> _attachments = const [];
  bool _allRecipients = false;

  /// A private note, kept on this phone, under this account and message.
  String? _note;
  bool _noteRequested = false;

  /// Every message in its conversation, wherever filed, oldest first.
  List<Message> _conversation = const [];

  MailboxState get _mailbox => widget.mailbox;

  /// Gmail: labels rather than folders, and a star rather than a flag.
  bool get _labels => _mailbox.backend.hasLabels;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_noteRequested) return;
    _noteRequested = true;
    unawaited(_loadNote());
  }

  String get _noteKey {
    final account = _mailbox.account?.address ?? _mailbox.backend.host;
    return 'note:$account:${widget.message.id}';
  }

  Future<void> _loadNote() async {
    final raw = await AppScope.read(context).store.read(_noteKey);
    if (!mounted) return;
    setState(() {
      final note = raw?.trim();
      _note = note == null || note.isEmpty ? null : note;
    });
  }

  Future<void> _editNote() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _NoteEditor(initial: _note),
    );
    if (result == null || !mounted) return;
    final trimmed = result.trim();
    final store = AppScope.read(context).store;
    if (trimmed.isEmpty) {
      await store.delete(_noteKey);
    } else {
      await store.write(_noteKey, trimmed);
    }
    if (mounted) setState(() => _note = trimmed.isEmpty ? null : trimmed);
  }

  Future<void> _load() async {
    try {
      final full = await _mailbox.backend.message(widget.message.id);
      if (!mounted) return;
      setState(() {
        _message = full;
        _loaded = true;
      });
      if (!full.isRead) unawaited(_markRead(full));
      for (final other in widget.others) {
        if (!other.isRead) unawaited(_markRead(other, shown: false));
      }
      if (_mailbox.backend.groupsThreads) unawaited(_loadConversation());
      if (full.hasAttachments) {
        final attachments = await _mailbox.backend.attachments(full.id);
        if (mounted) setState(() => _attachments = attachments);
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loaded = true;
        });
      }
    }
  }

  Future<void> _markRead(Message message, {bool shown = true}) async {
    try {
      await _mailbox.setRead(message, true);
      if (mounted && shown) {
        setState(() => _message = _message.copyWith(isRead: true));
      }
    } on ApiException {
      // Left unread; opening it again tries again.
    }
  }

  Future<void> _loadConversation() async {
    try {
      final all = await _mailbox.backend.conversation(widget.message.id);
      if (mounted) setState(() => _conversation = all);
    } on ApiException {
      // The message alone, then.
    }
  }

  /// Leaves the screen, then takes the message, and the rest of its
  /// conversation here, out of the folder with an Undo on the screen
  /// underneath.
  Future<void> _removeAndLeave(
    Future<void> Function(Message message, List<Message> others) action,
    String done, {
    bool undoable = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final undo = tr(context, 'common.undo');
    final message = _message;
    final others = widget.others;
    Navigator.pop(context);
    await removeWithUndo(
      messenger: messenger,
      mailbox: _mailbox,
      message: message,
      others: others,
      action: () => action(message, others),
      done: done,
      undoLabel: undo,
      undoable: undoable,
    );
  }

  Future<void> _delete() async {
    if (!await confirmPermanentDelete(context, _message) || !mounted) return;
    final permanent = _message.folder == StandardFolder.trash;
    await _removeAndLeave(
      (message, others) => _mailbox.delete(message, others: others),
      tr(context, permanent ? 'message.deleted' : 'message.movedToTrash'),
      undoable: !permanent,
    );
  }

  /// Gmail: picks the labels it carries. Taking off the one for the folder
  /// it's in takes it out of that folder, with an Undo.
  Future<void> _editLabels() async {
    final current = _message.labels.toSet();
    final chosen = await pickLabels(
      context,
      labels: [
        for (final f in _mailbox.folders)
          if (f.isLabel) f.name,
      ],
      selected: current,
    );
    if (chosen == null || !mounted) return;
    final add = chosen.difference(current);
    final remove = current.difference(chosen);
    if (add.isEmpty && remove.isEmpty) return;
    if (remove.contains(_message.folder)) {
      await _removeAndLeave(
        (message, others) => _mailbox.setLabels(
          message,
          add: add,
          remove: remove,
          others: others,
        ),
        trArgs(context, 'message.removedFrom', {
          'folder': folderLabelOf(context, _message.folder),
        }),
      );
      return;
    }
    await _mailbox.setLabels(
      _message,
      add: add,
      remove: remove,
      others: widget.others,
    );
    if (mounted) {
      setState(
        () => _message = _message.copyWith(
          labels: [
            for (final f in _mailbox.folders)
              if (chosen.contains(f.name)) f.name,
          ],
        ),
      );
    }
  }

  CalendarResponse? _answered;
  bool _answering = false;

  /// Answers the message's invitation from the account it is in.
  Future<void> _answer(CalendarResponse response) async {
    final account = _mailbox.account;
    final organizer = _message.calendarEvents.first.organizer;
    if (account == null || _answering) return;
    setState(() => _answering = true);
    try {
      await _mailbox.backend.respondToCalendar(
        _message.id,
        response: response,
        from: account.address,
      );
      if (!mounted) return;
      setState(() => _answered = response);
      showToast(
        context,
        trArgs(context, 'invite.sent', {
          'organizer': organizer?.label ?? _message.senderLabel,
        }),
      );
    } on ApiException catch (e) {
      if (mounted) {
        showToast(
          context,
          describeError(context, e, host: _mailbox.backend.host),
        );
      }
    } finally {
      if (mounted) setState(() => _answering = false);
    }
  }

  Future<void> _more(_More action) async {
    try {
      switch (action) {
        case _More.markUnread:
          await _mailbox.setRead(_message, false);
          if (mounted) Navigator.pop(context);
        case _More.flag:
          final flagged = !_message.isFlagged;
          await _mailbox.setFlagged(_message, flagged);
          if (mounted) {
            setState(() => _message = _message.copyWith(isFlagged: flagged));
          }
        case _More.note:
          await _editNote();
        case _More.labels:
          await _editLabels();
        case _More.spam:
          await _removeAndLeave(
            (message, others) =>
                _mailbox.move(message, StandardFolder.spam, others: others),
            tr(context, 'message.movedToSpam'),
          );
        case _More.notSpam:
          await _removeAndLeave(
            (message, others) =>
                _mailbox.move(message, StandardFolder.inbox, others: others),
            tr(context, 'message.movedToInbox'),
          );
        case _More.block:
          await _blockSender();
        case _More.forwardOriginal:
          await _forwardOriginal();
        case _More.source:
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => MessageSourceScreen(
                backend: _mailbox.backend,
                message: _message,
              ),
            ),
          );
      }
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, describeError(context, e));
      }
    }
  }

  /// Whether the sender can be blocked: the server keeps contacts, and the
  /// mail is someone else's.
  bool get _canBlock {
    final account = _mailbox.account;
    final sender = _message.sender.trim();
    return _mailbox.backend.hasContacts &&
        account != null &&
        sender.isNotEmpty &&
        sender.toLowerCase() != account.address.toLowerCase();
  }

  /// Refuses the sender's mail from now on, after asking.
  Future<void> _blockSender() async {
    final account = _mailbox.account;
    if (account == null) return;
    final sender = _message.sender.trim();
    final sure = await confirmAction(
      context,
      title: trArgs(context, 'message.blockTitle', {'sender': sender}),
      message: tr(context, 'message.blockBody'),
      action: tr(context, 'message.blockAction'),
    );
    if (!sure || !mounted) return;
    await _mailbox.backend.blockSender(account.id, sender);
    if (mounted) {
      showToast(
        context,
        trArgs(context, 'message.blocked', {'sender': sender}),
      );
    }
  }

  /// Forwards the original message from the server, carrying its
  /// attachments. Where the backend cannot, the action is not shown.
  Future<void> _forwardOriginal() async {
    final account = _mailbox.account;
    if (account == null || !_mailbox.backend.canServerForward) return;
    final recipients = await showDialog<String>(
      context: context,
      builder: (_) => const _ForwardOriginalDialog(),
    );
    if (recipients == null || !mounted) return;
    final to = recipients
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (to.isEmpty) return;
    try {
      await _mailbox.backend.forwardMessage(
        _message.id,
        from: account.address,
        to: to,
      );
      if (mounted) {
        showToast(context, tr(context, 'message.forwardedOriginal'));
      }
    } on ApiException catch (e) {
      if (mounted) {
        showToast(
          context,
          describeError(context, e, host: _mailbox.backend.host),
        );
      }
    }
  }

  void _compose(ComposeSeed seed) =>
      unawaited(openCompose(context, mailbox: _mailbox, seed: seed));

  String _recipientLine() {
    final own = _mailbox.ownAddresses;
    String name(Recipient r) {
      if (own.contains(r.address.toLowerCase())) {
        return tr(context, 'message.me');
      }
      if (!_allRecipients) return r.displayName;
      return r.name == null ? r.address : '${r.name} <${r.address}>';
    }

    final to = _message.to.map(name).join(', ');
    final cc = _message.cc.map(name).join(', ');
    return [
      if (to.isNotEmpty) trArgs(context, 'message.to', {'names': to}),
      if (cc.isNotEmpty) trArgs(context, 'message.cc', {'names': cc}),
      if (_allRecipients) longDate(_message.date),
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final v = context.rmv;
    final family = typefaceFamily(v.readerType);
    final m = _message;
    final i = AppScope.of(context).settings.interface;
    final trust = trustFromHeaders(m.headers);
    final warningsOnly =
        i.choice(senderTrustPanel, trustShowForOption) == 'warnings';
    final showTrust =
        i.isOn(senderTrustPanel) && (!warningsOnly || trust.isWarning);
    final showReceipt =
        showTrust && i.choice(senderTrustPanel, trustDetailOption) == 'receipt';
    final error = _error;
    final isDraft = m.isDraft || m.folder == StandardFolder.drafts;
    final own = _mailbox.ownAddresses;
    final othersOnIt = [...m.to, ...m.cc].any(
      (r) =>
          !own.contains(r.address.toLowerCase()) &&
          r.address.toLowerCase() != m.sender.toLowerCase(),
    );
    final canArchive = _labels
        ? m.folder == StandardFolder.inbox
        : m.folder != StandardFolder.archive;
    void archive() => unawaited(
      _removeAndLeave(
        (message, others) =>
            _mailbox.move(message, StandardFolder.archive, others: others),
        tr(context, 'message.archived'),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.line)),
              ),
              child: Row(
                children: [
                  RmIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: tr(context, 'common.back'),
                    color: c.accent,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  // On Gmail, archiving is taking a message out of the inbox.
                  if (canArchive)
                    v.actions == ActionStyle.icons
                        ? RmIconButton(
                            icon: Icons.archive_outlined,
                            tooltip: tr(context, 'message.archive'),
                            onPressed: archive,
                          )
                        : _WordAction(
                            label: tr(context, 'message.archive'),
                            keyHint: v.actions == ActionStyle.keyed
                                ? 'e'
                                : null,
                            onPressed: archive,
                          ),
                  v.actions == ActionStyle.icons
                      ? RmIconButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: tr(context, 'message.delete'),
                          onPressed: () => unawaited(_delete()),
                        )
                      : _WordAction(
                          label: tr(context, 'message.delete'),
                          keyHint: v.actions == ActionStyle.keyed ? 'x' : null,
                          onPressed: () => unawaited(_delete()),
                        ),
                  PopupMenuButton<_More>(
                    tooltip: tr(context, 'message.more'),
                    icon: Icon(Icons.more_vert_rounded, size: 20, color: c.ink),
                    onSelected: (action) => unawaited(_more(action)),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _More.markUnread,
                        child: Text(tr(context, 'message.markUnread')),
                      ),
                      PopupMenuItem(
                        value: _More.flag,
                        child: Text(
                          tr(context, switch ((_labels, m.isFlagged)) {
                            (true, true) => 'message.removeStar',
                            (true, false) => 'message.star',
                            (false, true) => 'message.removeFlag',
                            (false, false) => 'message.flag',
                          }),
                        ),
                      ),
                      PopupMenuItem(
                        value: _More.note,
                        child: Text(
                          tr(
                            context,
                            _note == null
                                ? 'message.addNote'
                                : 'message.editNote',
                          ),
                        ),
                      ),
                      if (_labels)
                        PopupMenuItem(
                          value: _More.labels,
                          child: Text(tr(context, 'message.labels')),
                        ),
                      if (m.folder == StandardFolder.spam)
                        PopupMenuItem(
                          value: _More.notSpam,
                          child: Text(tr(context, 'message.notSpam')),
                        )
                      else
                        PopupMenuItem(
                          value: _More.spam,
                          child: Text(tr(context, 'message.moveToSpam')),
                        ),
                      if (_canBlock)
                        PopupMenuItem(
                          value: _More.block,
                          child: Text(tr(context, 'message.block')),
                        ),
                      if (_mailbox.backend.canServerForward)
                        PopupMenuItem(
                          value: _More.forwardOriginal,
                          child: Text(tr(context, 'message.forwardOriginal')),
                        ),
                      // Last, so the items above keep their places.
                      if (_mailbox.backend.hasMessageSource)
                        PopupMenuItem(
                          value: _More.source,
                          child: Text(tr(context, 'message.viewSource')),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                children: [
                  SelectableText(
                    m.subject.isEmpty
                        ? tr(context, 'message.noSubject')
                        : m.subject,
                    style: rmText(
                      v.readerType == Typeface.serif ? 26 : 24,
                      color: c.ink,
                      weight: v.readerType == Typeface.serif
                          ? FontWeight.w500
                          : FontWeight.w800,
                      height: 1.15,
                      tracking: v.readerType == Typeface.serif ? -0.01 : -0.035,
                      family: family,
                    ),
                  ),
                  if (m.labels.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final label in m.labels) _LabelChip(label),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.line)),
                    ),
                    child: Row(
                      children: [
                        if (v.identity != Identity.none) ...[
                          RmAvatar(
                            name: m.senderLabel,
                            seed: m.sender,
                            radius: v.identity == Identity.squircle
                                ? BorderRadius.circular(12)
                                : null,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.senderLabel,
                                style: rmText(
                                  15,
                                  color: c.ink,
                                  weight: FontWeight.w700,
                                  tracking: -0.01,
                                  family: family,
                                ),
                              ),
                              const SizedBox(height: 2),
                              SelectableText(
                                m.sender,
                                style: rmText(
                                  12.5,
                                  color: c.ink3,
                                  family: family,
                                ),
                              ),
                              if (showTrust && !showReceipt)
                                RmTrustLine(headers: m.headers),
                            ],
                          ),
                        ),
                        Text(
                          timeLabel(m.date),
                          style: rmText(12, color: c.ink3, family: family),
                        ),
                      ],
                    ),
                  ),
                  if (showReceipt) RmTrustReceipt(verdict: trust),
                  InkWell(
                    onTap: () =>
                        setState(() => _allRecipients = !_allRecipients),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
                      child: Text(
                        _recipientLine(),
                        maxLines: _allRecipients ? null : 1,
                        overflow: _allRecipients ? null : TextOverflow.ellipsis,
                        style: rmText(
                          12.5,
                          color: c.ink3,
                          height: 1.5,
                          family: family,
                        ),
                      ),
                    ),
                  ),
                  if (_note != null) _NoteCard(note: _note!, onEdit: _editNote),
                  // The server answers a message's first event, so that one
                  // is shown: an invitation, or its cancellation.
                  if (m.calendarEvents.firstOrNull?.method
                      case 'REQUEST' || 'CANCEL'
                      when _loaded &&
                          error == null &&
                          _mailbox.backend.hasCalendar)
                    InvitationCard(
                      event: m.calendarEvents.first,
                      answered:
                          _answered ??
                          answerOf(
                            m.calendarEvents.first,
                            _mailbox.account?.address ?? '',
                          ),
                      busy: _answering,
                      onAnswer: m.calendarEvents.first.canReply
                          ? (response) => unawaited(_answer(response))
                          : null,
                    ),
                  if (!_loaded)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(
                        child: SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else if (error != null)
                    ErrorText(
                      describeError(
                        context,
                        error,
                        host: _mailbox.backend.host,
                      ),
                    )
                  else
                    MessageBody(
                      message: m,
                      onOpenLink: (uri) =>
                          unawaited(openLink(context, _mailbox, uri)),
                    ),
                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    AttachmentSummary(
                      backend: _mailbox.backend,
                      attachments: _attachments,
                    ),
                  ],
                  if (_conversation.length > 1) ...[
                    const SizedBox(height: 26),
                    SectionLabel(
                      trArgs(context, 'message.conversation', {
                        'count': '${_conversation.length}',
                      }),
                    ),
                    const SizedBox(height: 8),
                    for (final other in _conversation)
                      if (other.id != m.id)
                        MessageRow(
                          message: other,
                          dense: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => MessageScreen(
                                mailbox: _mailbox,
                                message: other,
                              ),
                            ),
                          ),
                        ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: c.bg,
                border: Border(top: BorderSide(color: c.line)),
              ),
              child: isDraft
                  ? RmPrimaryButton(
                      label: tr(context, 'message.editDraft'),
                      height: 44,
                      radius: 11,
                      fontSize: 14.5,
                      onPressed: () => _compose(draftSeed(m)),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: RmPrimaryButton(
                            label: tr(context, 'message.reply'),
                            height: 44,
                            radius: 11,
                            fontSize: 14.5,
                            onPressed: () => _compose(
                              replySeed(
                                m,
                                ownAddresses: own,
                                languageCode: Localizations.localeOf(context)
                                    .languageCode,
                              ),
                            ),
                          ),
                        ),
                        if (othersOnIt) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: RmOutlineButton(
                              label: tr(context, 'message.replyAll'),
                              height: 44,
                              radius: 11,
                              fontSize: 14.5,
                              color: c.ink,
                              onPressed: () => _compose(
                                replySeed(
                                  m,
                                  ownAddresses: own,
                                  all: true,
                                  languageCode: Localizations.localeOf(context)
                                      .languageCode,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        v.actions == ActionStyle.icons
                            ? RmOutlineIconButton(
                                icon: Icons.arrow_forward_rounded,
                                tooltip: tr(context, 'message.forward'),
                                onPressed: () => _compose(
                                  forwardSeed(
                                    m,
                                    languageCode: Localizations.localeOf(
                                      context,
                                    ).languageCode,
                                  ),
                                ),
                              )
                            : RmOutlineButton(
                                label: v.actions == ActionStyle.keyed
                                    ? '[f] ${tr(context, 'message.forward')}'
                                    : tr(context, 'message.forward'),
                                height: 44,
                                radius: 11,
                                fontSize: 14.5,
                                color: c.ink,
                                onPressed: () => _compose(
                                  forwardSeed(
                                    m,
                                    languageCode: Localizations.localeOf(
                                      context,
                                    ).languageCode,
                                  ),
                                ),
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The sheet a private note is written in. It owns its controller, so the
/// field survives the sheet's closing animation.
class _NoteEditor extends StatefulWidget {
  const _NoteEditor({required this.initial});

  final String? initial;

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late final _text = TextEditingController(text: widget.initial ?? '');

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
              child: Text(
                tr(context, 'note.title'),
                style: rmText(
                  17,
                  color: c.ink,
                  weight: FontWeight.w700,
                  tracking: -0.02,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: Text(
                tr(context, 'note.privacy'),
                style: rmText(12.5, color: c.ink3, height: 1.35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                controller: _text,
                autofocus: true,
                minLines: 3,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: rmText(15, color: c.ink, height: 1.45),
                decoration: InputDecoration(hintText: tr(context, 'note.hint')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Row(
                children: [
                  if (widget.initial != null)
                    TextButton(
                      onPressed: () => Navigator.pop(context, ''),
                      child: Text(
                        tr(context, 'common.remove'),
                        style: rmText(14, color: c.danger),
                      ),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      tr(context, 'common.cancel'),
                      style: rmText(14, color: c.ink2),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _text.text),
                    child: Text(
                      tr(context, 'common.save'),
                      style: rmText(
                        14,
                        color: c.accent,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A note only this phone has: not sent, not part of the message.
class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onEdit});

  final String note;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sticky_note_2_outlined, size: 18, color: c.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(context, 'note.label').toUpperCase(),
                  style: rmText(
                    10.5,
                    color: c.ink3,
                    weight: FontWeight.w700,
                    tracking: 0.06,
                  ),
                ),
                const SizedBox(height: 3),
                Text(note, style: rmText(13.5, color: c.ink2, height: 1.4)),
              ],
            ),
          ),
          IconButton(
            tooltip: tr(context, 'message.editNote'),
            icon: Icon(Icons.edit_outlined, size: 18, color: c.ink3),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

/// One of a Gmail message's labels, under its subject.
class _LabelChip extends StatelessWidget {
  const _LabelChip(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        folderLabelOf(context, name),
        style: rmText(12, color: c.ink2, weight: FontWeight.w600),
      ),
    );
  }
}

/// An action bar entry for packs whose action axis is not icons: a word,
/// letter-spaced small caps for `words`, or a key hint plus the word for
/// `keyed`.
class _WordAction extends StatelessWidget {
  const _WordAction({
    required this.label,
    required this.onPressed,
    this.keyHint,
  });

  final String label;
  final String? keyHint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final words = keyHint == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (keyHint != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: c.line),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyHint!,
                  style: rmText(
                    9,
                    color: c.ink3,
                    family: typefaceFamily(Typeface.mono),
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              words ? label.toUpperCase() : label,
              style: rmText(
                words ? 10.5 : 12,
                color: c.ink2,
                weight: FontWeight.w600,
                tracking: words ? 0.14 : 0,
                family: typefaceFamily(context.rmv.readerType),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The sheet that collects the recipients for a server-side forward. It owns
/// its controller, so the field survives the dialog's closing animation.
class _ForwardOriginalDialog extends StatefulWidget {
  const _ForwardOriginalDialog();

  @override
  State<_ForwardOriginalDialog> createState() => _ForwardOriginalDialogState();
}

class _ForwardOriginalDialogState extends State<_ForwardOriginalDialog> {
  final _to = TextEditingController();

  @override
  void dispose() {
    _to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr(context, 'message.forwardOriginal')),
      content: TextField(
        controller: _to,
        decoration: InputDecoration(hintText: tr(context, 'message.forwardTo')),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr(context, 'common.cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _to.text),
          child: Text(tr(context, 'message.forward')),
        ),
      ],
    );
  }
}
