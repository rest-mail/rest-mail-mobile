import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../state/mailbox_state.dart';
import '../theme/tokens.dart';
import '../util/compose_seed.dart';
import '../util/format.dart';
import 'attachments.dart';
import 'compose_sheet.dart';
import 'mail_actions.dart';
import 'widgets/avatar.dart';
import 'widgets/common.dart';
import 'widgets/message_body.dart';

enum _More { markUnread, flag, spam, notSpam }

/// One message, read in full, with reply, reply all and forward along the
/// bottom.
class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.mailbox,
    required this.message,
  });

  final MailboxState mailbox;

  /// The message as the list had it; the full one is fetched on open.
  final Message message;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late Message _message = widget.message;
  bool _loaded = false;
  ApiException? _error;
  List<Attachment> _attachments = const [];
  bool _allRecipients = false;

  MailboxState get _mailbox => widget.mailbox;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final full = await _mailbox.client.message(widget.message.id);
      if (!mounted) return;
      setState(() {
        _message = full;
        _loaded = true;
      });
      if (!full.isRead) unawaited(_markRead(full));
      if (full.hasAttachments) {
        final attachments = await _mailbox.client.attachments(full.id);
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

  Future<void> _markRead(Message message) async {
    try {
      await _mailbox.setRead(message, true);
      if (mounted) setState(() => _message = _message.copyWith(isRead: true));
    } on ApiException {
      // Left unread; opening it again tries again.
    }
  }

  /// Leaves the screen, then takes the message out of its folder with an
  /// Undo on the screen underneath.
  Future<void> _removeAndLeave(
    Future<void> Function() action,
    String done, {
    bool undoable = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = _message;
    Navigator.pop(context);
    await removeWithUndo(
      messenger: messenger,
      mailbox: _mailbox,
      message: message,
      action: action,
      done: done,
      undoable: undoable,
    );
  }

  Future<void> _delete() async {
    if (!await confirmPermanentDelete(context, _message) || !mounted) return;
    final permanent = _message.folder == StandardFolder.trash;
    await _removeAndLeave(
      () => _mailbox.delete(_message),
      permanent ? 'Deleted' : 'Moved to Trash',
      undoable: !permanent,
    );
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
        case _More.spam:
          await _removeAndLeave(
            () => _mailbox.move(_message, StandardFolder.spam),
            'Moved to Spam',
          );
        case _More.notSpam:
          await _removeAndLeave(
            () => _mailbox.move(_message, StandardFolder.inbox),
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
                  if (m.folder != StandardFolder.archive)
                    RmIconButton(
                      icon: Icons.archive_outlined,
                      tooltip: 'Archive',
                      onPressed: () => unawaited(
                        _removeAndLeave(
                          () => _mailbox.move(_message, StandardFolder.archive),
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
                        child: Text(m.isFlagged ? 'Remove flag' : 'Flag'),
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
                    ErrorText(
                      describeError(error, host: _mailbox.client.server.host),
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
                      client: _mailbox.client,
                      attachments: _attachments,
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
