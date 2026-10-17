import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../theme/tokens.dart';
import '../../util/format.dart';
import 'avatar.dart';

/// A message in a list: who, when, what, and a taste of the body. Unread
/// ones are heavier and carry the accent dot.
class MessageRow extends StatelessWidget {
  const MessageRow({
    super.key,
    required this.message,
    required this.onTap,
    this.dense = false,
    this.count = 1,
  });

  final Message message;
  final VoidCallback onTap;

  /// One line of preview and no badges, for search results.
  final bool dense;

  /// How many messages the row's conversation has, shown when more than one.
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final unread = !message.isRead;
    final subject = message.subject.isEmpty ? '(no subject)' : message.subject;
    return Semantics(
      button: true,
      label: [
        if (unread) 'Unread',
        'From ${message.senderLabel}',
        if (count > 1) '$count messages',
        subject,
        timeLabel(message.date),
        if (message.hasAttachments) 'Has attachments',
      ].join('. '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: dense ? 14 : 15,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RmAvatar(name: message.senderLabel, seed: message.sender),
              const SizedBox(width: 13),
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
                                  ),
                                ),
                              ),
                              if (count > 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    '$count',
                                    style: rmText(
                                      12.5,
                                      color: c.ink3,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (message.isFlagged)
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
                      ),
                    ),
                    if (message.preview.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        message.preview,
                        maxLines: dense ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: rmText(
                          dense ? 13 : 13.5,
                          color: c.ink3,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (!dense && (message.hasAttachments || unread))
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            if (message.hasAttachments) const _AttachmentChip(),
                            if (message.hasAttachments && unread)
                              const SizedBox(width: 6),
                            if (unread)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: c.accent,
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
            'Attachment',
            style: rmText(11.5, color: c.ink3, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
