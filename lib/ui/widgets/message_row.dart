import '../../l10n/voice.dart';

import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../theme/packs.dart';
import '../../theme/tokens.dart';
import '../../util/format.dart';
import 'avatar.dart';

/// A message in a list: who, when, what, and a taste of the body. Unread
/// ones are heavier, plus whatever the active pack's unread axis adds.
class MessageRow extends StatelessWidget {
  const MessageRow({
    super.key,
    required this.message,
    required this.onTap,
    this.dense = false,
    this.count = 1,
    this.previewLines = 2,
    this.showAttachment = true,
    this.showCount = true,
    this.showFlag = true,
  });

  final Message message;
  final VoidCallback onTap;

  /// One line of preview and no badges, for search results.
  final bool dense;

  /// How many messages the row's conversation has, shown when more than one.
  final int count;

  /// Lines of body under the subject; none hides it.
  final int previewLines;

  final bool showAttachment;
  final bool showCount;
  final bool showFlag;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final v = context.rmv;
    final family = typefaceFamily(v.listType);
    final unread = !message.isRead;
    final subject = message.subject.isEmpty
        ? tr(context, 'message.noSubject')
        : message.subject;
    final rail = v.unread == UnreadSignal.rail && unread;
    final attachment = showAttachment && message.hasAttachments;
    final showTheCount = showCount && count > 1;
    final side = BorderSide(color: c.line);
    return Semantics(
      button: true,
      label: [
        if (unread) tr(context, 'mailboxes.unread'),
        trArgs(context, 'messagerow.fromSenderLabel', {
          'senderLabel': (message.senderLabel).toString(),
        }),
        if (showTheCount)
          trArgs(context, 'ui.countMessages', {'count': (count).toString()}),
        subject,
        timeLabel(message.date),
        if (message.hasAttachments) tr(context, 'messagerow.hasAttachments'),
      ].join('. '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: v.surface == Surface.cards
              ? const EdgeInsets.fromLTRB(10, 4, 10, 4)
              : null,
          padding: EdgeInsets.symmetric(
            horizontal: v.surface == Surface.cards ? 12 : 16,
            vertical: dense ? 14 : 15,
          ),
          decoration: BoxDecoration(
            color: v.surface == Surface.dense && unread
                ? c.accentSoft
                : v.surface == Surface.cards
                ? c.surface
                : null,
            borderRadius: v.surface == Surface.cards
                ? BorderRadius.circular(14)
                : null,
            border: switch (v.surface) {
              Surface.dividers => Border(
                bottom: side,
                left: rail
                    ? BorderSide(color: c.mark, width: 3)
                    : BorderSide.none,
              ),
              Surface.rules || Surface.dense => Border(
                top: side,
                left: rail
                    ? BorderSide(color: c.mark, width: 3)
                    : BorderSide.none,
              ),
              Surface.cards => Border.all(color: c.line),
            },
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (v.identity != Identity.none) ...[
                RmAvatar(
                  name: message.senderLabel,
                  seed: message.sender,
                  radius: v.identity == Identity.squircle
                      ? BorderRadius.circular(12)
                      : null,
                ),
                const SizedBox(width: 13),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Flexible(
                                child: Text(
                                  message.senderLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: rmText(
                                    dense ? 14.5 : 15,
                                    color: c.ink,
                                    weight: unread
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    tracking: -0.015,
                                    family: family,
                                  ),
                                ),
                              ),
                              if (showTheCount)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    '$count',
                                    style: rmText(
                                      12.5,
                                      color: c.ink3,
                                      weight: FontWeight.w600,
                                      family: family,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (showFlag && message.isFlagged)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.flag_rounded,
                              size: 13,
                              color: c.tintAmber,
                            ),
                          ),
                        Text(
                          timeLabel(message.date),
                          style: rmText(
                            12,
                            color: c.ink3,
                            weight: FontWeight.w500,
                            family: family,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: rmText(
                        dense ? 14 : 14.5,
                        color: c.ink,
                        weight: unread ? FontWeight.w700 : FontWeight.w500,
                        height: 1.3,
                        family: family,
                      ),
                    ),
                    if (previewLines > 0 && message.preview.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        message.preview,
                        maxLines: dense ? 1 : previewLines,
                        overflow: TextOverflow.ellipsis,
                        style: rmText(
                          dense ? 13 : 13.5,
                          color: c.ink3,
                          height: 1.4,
                          family: family,
                        ),
                      ),
                    ],
                    if (!dense &&
                        (attachment ||
                            (unread && v.unread == UnreadSignal.dot)))
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            if (attachment) const _AttachmentChip(),
                            if (attachment &&
                                unread &&
                                v.unread == UnreadSignal.dot)
                              const SizedBox(width: 6),
                            if (unread && v.unread == UnreadSignal.dot)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: c.mark,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentChip extends StatelessWidget {
  const _AttachmentChip();

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_file_rounded, size: 11, color: c.ink3),
          const SizedBox(width: 3),
          Text(
            tr(context, 'messagerow.attachment'),
            style: rmText(
              11.5,
              color: c.ink3,
              weight: FontWeight.w600,
              family: typefaceFamily(context.rmv.listType),
            ),
          ),
        ],
      ),
    );
  }
}
