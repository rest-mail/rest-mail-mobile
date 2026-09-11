import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// What rest-mail's webmail lets through (its HtmlMessageBody), so a message
/// reads the same in both clients: structure, links and images; no styling,
/// scripts, forms or frames. Anything else is unwrapped and its text kept.
const _allowedTags = {
  'p', 'br', 'b', 'i', 'u', 'strong', 'em', 's', 'sub', 'sup', 'small', //
  'a', 'ul', 'ol', 'li', 'dl', 'dt', 'dd',
  'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
  'blockquote', 'pre', 'code', 'hr', 'img',
  'table', 'thead', 'tbody', 'tfoot', 'tr', 'th', 'td', 'caption',
  'span', 'div',
};

/// Removed along with everything inside them, rather than unwrapped.
const _droppedTags = {
  'script', 'style', 'link', 'meta', 'base', 'title', 'head', 'template', //
  'noscript', 'iframe', 'frame', 'object', 'embed', 'applet', 'form',
  'input', 'button', 'select', 'textarea', 'svg', 'math', 'canvas',
  'audio', 'video',
};

/// `style` and `class` are left out on purpose: they are how a message
/// exfiltrates (`background:url(...)`) or dresses itself up as the app.
const _allowedAttributes = {'href', 'src', 'alt', 'title', 'width', 'height'};

const _blockTags = {
  'p', 'div', 'li', 'tr', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', //
  'pre', 'table', 'ul', 'ol', 'dl', 'dt', 'dd', 'hr',
};

final _dataImage = RegExp(
  r'^data:image/(png|jpe?g|gif|webp);base64,[a-z0-9+/=\s]+$',
  caseSensitive: false,
);

class SanitizedHtml {
  const SanitizedHtml(this.html, {required this.blockedImages});

  final String html;

  /// Images that would have been fetched from the network and were left out.
  final int blockedImages;
}

/// Cuts untrusted message HTML down to [_allowedTags] and
/// [_allowedAttributes].
///
/// Links survive only as http, https or mailto. Images survive only as
/// inline data, unless [allowRemoteImages] — the reader's explicit "load
/// images" — in which case remote ones are kept, and moved to https so the
/// fetch cannot be read or rewritten on the way.
SanitizedHtml sanitizeHtml(String input, {bool allowRemoteImages = false}) {
  final body = html_parser.parse(input).body;
  if (body == null) return const SanitizedHtml('', blockedImages: 0);
  final blocked = _clean(body, allowRemoteImages);
  return SanitizedHtml(body.innerHtml.trim(), blockedImages: blocked);
}

/// The text of an HTML body with its paragraphs and line breaks, for
/// quoting in a reply.
String htmlToPlainText(String input) {
  final body = html_parser.parse(input).body;
  if (body == null) return '';
  final out = StringBuffer();
  void walk(Node node) {
    for (final child in node.nodes) {
      if (child is Text) {
        out.write(child.text.replaceAll(RegExp(r'\s+'), ' '));
      } else if (child is Element) {
        final tag = child.localName;
        if (_droppedTags.contains(tag)) continue;
        if (tag == 'br') {
          out.write('\n');
          continue;
        }
        final block = _blockTags.contains(tag);
        if (block) out.write('\n');
        walk(child);
        if (block) out.write('\n');
      }
    }
  }

  walk(body);
  return out
      .toString()
      .split('\n')
      .map((line) => line.trim())
      .join('\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

int _clean(Node parent, bool allowRemoteImages) {
  var blocked = 0;
  for (final node in parent.nodes.toList()) {
    if (node is Element) {
      final tag = node.localName ?? '';
      if (_droppedTags.contains(tag)) {
        node.remove();
        continue;
      }
      blocked += _clean(node, allowRemoteImages);
      if (!_allowedTags.contains(tag)) {
        _unwrap(node);
        continue;
      }
      blocked += _cleanAttributes(node, allowRemoteImages);
      if (tag == 'img' && !node.attributes.containsKey('src')) node.remove();
    } else if (node is! Text) {
      node.remove(); // comments and the like
    }
  }
  return blocked;
}

int _cleanAttributes(Element element, bool allowRemoteImages) {
  final original = Map<Object, String>.of(element.attributes);
  element.attributes.clear();
  var blocked = 0;
  for (final MapEntry(:key, :value) in original.entries) {
    final name = key.toString().toLowerCase();
    if (!_allowedAttributes.contains(name)) continue;
    switch (name) {
      case 'href':
        if (_safeLink(value) case final href?) {
          element.attributes['href'] = href;
        }
      case 'src':
        final src = value.trim();
        if (_dataImage.hasMatch(src)) {
          element.attributes['src'] = src;
        } else if (_remote(src) case final remote?) {
          if (allowRemoteImages) {
            element.attributes['src'] = remote;
          } else {
            blocked++;
          }
        }
      default:
        element.attributes[name] = value;
    }
  }
  return blocked;
}

void _unwrap(Element element) {
  final parent = element.parentNode;
  if (parent == null) return;
  for (final child in element.nodes.toList()) {
    parent.insertBefore(child, element);
  }
  element.remove();
}

String? _safeLink(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null) return null;
  return switch (uri.scheme.toLowerCase()) {
    'http' || 'https' || 'mailto' => uri.toString(),
    _ => null,
  };
}

/// An image address fetched over the network, as https; null for anything
/// else (`cid:`, `file:`, `javascript:` and relative paths are all dropped).
String? _remote(String src) {
  final lower = src.toLowerCase();
  if (lower.startsWith('https://')) return src;
  if (lower.startsWith('http://')) {
    return 'https://${src.substring('http://'.length)}';
  }
  if (lower.startsWith('//')) return 'https:$src';
  return null;
}
