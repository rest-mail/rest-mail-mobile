import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/format.dart';
import 'attachments.dart';
import 'compose_sheet.dart';
import 'labels_sheet.dart';
import 'mail_actions.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/message_body.dart';
import 'widgets/message_row.dart';

enum _More { markUnread, flag, labels, spam, notSpam }

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
      undoable: undoable,
    );
  }

  Future<void> _delete() async {
    if (!await confirmPermanentDelete(context, _message) || !mounted) return;
    final permanent = _message.folder == StandardFolder.trash;
    await _removeAndLeave(
      (message, others) => _mailbox.delete(message, others: others),
      permanent ? 'Deleted' : 'Moved to Trash',
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
        'Removed from ${folderLabel(_message.folder)}',
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
        case _More.labels:
          await _editLabels();
        case _More.spam:
          await _removeAndLeave(
            (message, others) =>
                _mailbox.move(message, StandardFolder.spam, others: others),
            'Moved to Spam',
          );
        case _More.notSpam:
          await _removeAndLeave(
            (message, others) =>
                _mailbox.move(message, StandardFolder.inbox, others: others),
            'Moved to Inbox',
          );
      }
    } on ApiException catch (e) {
      if (mounted) showToast(context, describeError(e));
    }
  }

  void _compose(ComposeSeed seed) =>
      unawaited(openCompose(context, mailbox: _mailbox, seed: seed));

  String _recipientLine() {
    final own = _mailbox.ownAddresses;
    String name(Recipient r) {
      if (own.contains(r.address.toLowerCase())) return 'me';
      if (!_allRecipients) return r.displayName;
      return r.name == null ? r.address : '${r.name} <${r.address}>';
    }

    final to = _message.to.map(name).join(', ');
    final cc = _message.cc.map(name).join(', ');
    return [
      if (to.isNotEmpty) 'to $to',
      if (cc.isNotEmpty) 'cc $cc',
      if (_allRecipients) longDate(_message.date),
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final m = _message;
    final error = _error;
    final isDraft = m.isDraft || m.folder == StandardFolder.drafts;
    final own = _mailbox.ownAddresses;
    final othersOnIt = [...m.to, ...m.cc].any(
      (r) =>
          !own.contains(r.address.toLowerCase()) &&
          r.address.toLowerCase() != m.sender.toLowerCase(),
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
                    tooltip: 'Back',
                    color: c.accent,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  // On Gmail, archiving is taking a message out of the inbox.
                  if (_labels
                      ? m.folder == StandardFolder.inbox
                      : m.folder != StandardFolder.archive)
                    RmIconButton(
                      icon: Icons.archive_outlined,
                      tooltip: 'Archive',
                      onPressed: () => unawaited(
                        _removeAndLeave(
                          (message, others) => _mailbox.move(
                            message,
                            StandardFolder.archive,
                            others: others,
                          ),
                          'Archived',
                        ),
                      ),
                    ),
                  RmIconButton(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Delete',
                    onPressed: () => unawaited(_delete()),
                  ),
                  PopupMenuButton<_More>(
                    tooltip: 'More',
                    icon: Icon(Icons.more_vert_rounded, size: 20, color: c.ink),
                    onSelected: (action) => unawaited(_more(action)),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: _More.markUnread,
                        child: Text('Mark as unread'),
                      ),
                      PopupMenuItem(
                        value: _More.flag,
                        child: Text(switch ((_labels, m.isFlagged)) {
                          (true, true) => 'Remove star',
                          (true, false) => 'Star',
                          (false, true) => 'Remove flag',
                          (false, false) => 'Flag',
                        }),
                      ),
                      if (_labels)
                        const PopupMenuItem(
                          value: _More.labels,
                          child: Text('Labels…'),
                        ),
                      if (m.folder == StandardFolder.spam)
                        const PopupMenuItem(
                          value: _More.notSpam,
                          child: Text('Not spam'),
                        )
                      else
                        const PopupMenuItem(
                          value: _More.spam,
                          child: Text('Move to Spam'),
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
                    m.subject.isEmpty ? '(no subject)' : m.subject,
                    style: rmText(
                      24,
                      color: c.ink,
                      weight: FontWeight.w800,
                      height: 1.15,
                      tracking: -0.035,
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
                        RmAvatar(name: m.senderLabel, seed: m.sender),
                        const SizedBox(width: 12),
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
                                ),
                              ),
                              const SizedBox(height: 2),
                              SelectableText(
                                m.sender,
                                style: rmText(12.5, color: c.ink3),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          timeLabel(m.date),
                          style: rmText(12, color: c.ink3),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        setState(() => _allRecipients = !_allRecipients),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
                      child: Text(
                        _recipientLine(),
                        maxLines: _allRecipients ? null : 1,
                        overflow: _allRecipients ? null : TextOverflow.ellipsis,
                        style: rmText(12.5, color: c.ink3, height: 1.5),
                      ),
                    ),
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
                    ErrorText(describeError(error, host: _mailbox.backend.host))
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
                      '${_conversation.length} messages in this conversation',
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
                      label: 'Edit draft',
                      height: 44,
                      radius: 11,
                      fontSize: 14.5,
                      onPressed: () => _compose(draftSeed(m)),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: RmPrimaryButton(
                            label: 'Reply',
                            height: 44,
                            radius: 11,
                            fontSize: 14.5,
                            onPressed: () =>
                                _compose(replySeed(m, ownAddresses: own)),
                          ),
                        ),
                        if (othersOnIt) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: RmOutlineButton(
                              label: 'Reply all',
                              height: 44,
                              radius: 11,
                              fontSize: 14.5,
                              color: c.ink,
                              onPressed: () => _compose(
                                replySeed(m, ownAddresses: own, all: true),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        RmOutlineIconButton(
                          icon: Icons.arrow_forward_rounded,
                          tooltip: 'Forward',
                          onPressed: () => _compose(forwardSeed(m)),
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
        folderLabel(name),
        style: rmText(12, color: c.ink2, weight: FontWeight.w600),
      ),
    );
  }
}
