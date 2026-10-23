import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../l10n/voice.dart';
import '../../theme/packs.dart';
import '../../theme/tokens.dart';
import '../../util/html_sanitizer.dart';
import '../../util/quote_split.dart';

/// A message's body: its HTML, sanitized and drawn as Flutter widgets, or
/// its plain text. Remote images stay blocked until the reader asks. Quoted
/// history at the end (a reply's earlier messages) is folded behind "Show
/// quoted text"; what the sender wrote now is always shown.
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
  bool _showQuote = false;
  QuoteSplit? _split;
  SanitizedHtml? _sanitized;
  SanitizedHtml? _sanitizedQuote;

  @override
  void didUpdateWidget(MessageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.id != widget.message.id ||
        oldWidget.message.bodyHtml != widget.message.bodyHtml ||
        oldWidget.message.bodyText != widget.message.bodyText) {
      _allowRemote = false;
      _showQuote = false;
      _split = null;
      _sanitized = null;
      _sanitizedQuote = null;
    }
  }

  Widget _toggle(BuildContext context) {
    final c = context.rm;
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => setState(() => _showQuote = !_showQuote),
        icon: Icon(
          _showQuote ? Icons.expand_less_rounded : Icons.more_horiz_rounded,
          size: 18,
          color: c.accent,
        ),
        label: Text(
          _showQuote ? 'Hide quoted text' : 'Show quoted text',
          style: rmText(13, color: c.accent, weight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final text = rmText(
      15.5,
      color: c.ink,
      height: 1.62,
      family: typefaceFamily(context.rmv.readerType),
    );
    final html = widget.message.bodyHtml;
    if (html == null) {
      final split = _split ??= splitPlainQuote(widget.message.bodyText ?? '');
      final quote = split.quote;
      if (quote == null) return SelectableText(split.body, style: text);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(split.body, style: text),
          const SizedBox(height: 10),
          _toggle(context),
          if (_showQuote) ...[
            const SizedBox(height: 6),
            SelectableText(quote, style: text.copyWith(color: c.ink2)),
          ],
        ],
      );
    }
    final split = _split ??= splitHtmlQuote(html);
    final quote = split.quote;
    final sanitized = _sanitized ??= sanitizeHtml(
      split.body,
      allowRemoteImages: _allowRemote,
    );
    final sanitizedQuote = quote == null
        ? null
        : _sanitizedQuote ??= sanitizeHtml(
            quote,
            allowRemoteImages: _allowRemote,
          );
    final blocked =
        sanitized.blockedImages + (sanitizedQuote?.blockedImages ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (blocked > 0)
          _RemoteImagesNotice(
            count: blocked,
            onLoad: () => setState(() {
              _allowRemote = true;
              _sanitized = null;
              _sanitizedQuote = null;
            }),
          ),
        _html(context, sanitized.html, text),
        if (sanitizedQuote != null) ...[
          const SizedBox(height: 10),
          _toggle(context),
          if (_showQuote) ...[
            const SizedBox(height: 6),
            _html(context, sanitizedQuote.html, text.copyWith(color: c.ink2)),
          ],
        ],
      ],
    );
  }

  Widget _html(BuildContext context, String html, TextStyle text) {
    final c = context.rm;
    return HtmlWidget(
      html,
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
                  ? tr(context, 'message.imageBlocked')
                  : trArgs(context, 'message.imagesBlocked', {
                      'count': '$count',
                    }),
              style: rmText(13, color: c.ink2),
            ),
          ),
          TextButton(
            onPressed: onLoad,
            child: Text(
              tr(context, 'message.loadImages'),
              style: rmText(13, color: c.accent, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
