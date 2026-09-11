import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../theme/tokens.dart';
import '../../util/html_sanitizer.dart';

/// A message's body: its HTML, sanitized and drawn as Flutter widgets, or
/// its plain text. Remote images stay blocked until the reader asks.
class MessageBody extends StatefulWidget {
  const MessageBody({
    super.key,
    required this.message,
    required this.onOpenLink,
  });

  final Message message;
  final ValueChanged<Uri> onOpenLink;

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody> {
  bool _allowRemote = false;
  SanitizedHtml? _sanitized;

  @override
  void didUpdateWidget(MessageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.id != widget.message.id ||
        oldWidget.message.bodyHtml != widget.message.bodyHtml) {
      _allowRemote = false;
      _sanitized = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final text = rmText(15.5, color: c.ink, height: 1.62);
    final html = widget.message.bodyHtml;
    if (html == null) {
      return SelectableText(widget.message.bodyText ?? '', style: text);
    }
    final sanitized = _sanitized ??= sanitizeHtml(
      html,
      allowRemoteImages: _allowRemote,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sanitized.blockedImages > 0)
          _RemoteImagesNotice(
            count: sanitized.blockedImages,
            onLoad: () => setState(() {
              _allowRemote = true;
              _sanitized = null;
            }),
          ),
        HtmlWidget(
          sanitized.html,
          textStyle: text,
          onTapUrl: (url) {
            if (Uri.tryParse(url) case final uri?) widget.onOpenLink(uri);
            return true;
          },
          customStylesBuilder: (element) => switch (element.localName) {
            'a' => {'color': cssColor(c.accent), 'text-decoration': 'none'},
            'blockquote' => {
              'border-left': '3px solid ${cssColor(c.line)}',
              'margin': '0 0 0 4px',
              'padding-left': '12px',
              'color': cssColor(c.ink2),
            },
            'pre' ||
            'code' => {'font-family': 'monospace', 'white-space': 'pre-wrap'},
            'td' || 'th' => {'padding': '4px 8px', 'vertical-align': 'top'},
            'hr' => {'border-top': '1px solid ${cssColor(c.line)}'},
            _ => null,
          },
        ),
      ],
    );
  }
}

class _RemoteImagesNotice extends StatelessWidget {
  const _RemoteImagesNotice({required this.count, required this.onLoad});

  final int count;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.image_not_supported_outlined, size: 18, color: c.ink3),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 1
                  ? '1 remote image blocked'
                  : '$count remote images blocked',
              style: rmText(13, color: c.ink2),
            ),
          ),
          TextButton(
            onPressed: onLoad,
            child: Text(
              'Load',
              style: rmText(13, color: c.accent, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
