import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// A message body cut in two: what the sender wrote now, and the quoted
/// history after it, which the reader folds away. [quote] is null when
/// there is no quoted tail to fold, and then [body] is the whole message.
class QuoteSplit {
  const QuoteSplit(this.body, [this.quote]);

  final String body;
  final String? quote;
}

/// An attribution line: "On …, Ann wrote:" and its usual translations.
final _attribution = RegExp(
  r'(wrote|schrieb|escribió|a écrit|ha scritto|escreveu|schreef|napisał)\s*:\s*$',
  caseSensitive: false,
);

/// Outlook's separator above a forwarded or replied-to message.
final _originalMessage = RegExp(
  r'^\s*-{2,}\s*(original message|ursprüngliche nachricht|mensaje original)\s*-{2,}\s*$',
  caseSensitive: false,
);

bool _quoted(String line) => line.trimLeft().startsWith('>');

/// Splits plain text at its quoted tail: the `>` lines that run to the end
/// (with the attribution line above them), or everything from an
/// "-----Original Message-----" separator on. Quoting in the middle, with
/// new text after it (an inline reply), is not a tail and is left alone, and
/// so is a message that would be left with nothing of its own.
QuoteSplit splitPlainQuote(String text) {
  final lines = text.split('\n');
  var end = lines.length;
  while (end > 0 && lines[end - 1].trim().isEmpty) {
    end--;
  }
  if (end == 0) return QuoteSplit(text);

  int? start;
  for (var i = 0; i < end; i++) {
    if (_originalMessage.hasMatch(lines[i])) {
      start = i;
      break;
    }
  }
  if (start == null && _quoted(lines[end - 1])) {
    var s = end - 1;
    while (s > 0 && (_quoted(lines[s - 1]) || lines[s - 1].trim().isEmpty)) {
      s--;
    }
    while (s < end && lines[s].trim().isEmpty) {
      s++;
    }
    // The attribution above it, which may wrap onto a second line.
    var a = s;
    while (a > 0 && lines[a - 1].trim().isEmpty) {
      a--;
    }
    if (a > 0 && _attribution.hasMatch(lines[a - 1])) {
      a--;
      if (a > 0 &&
          lines[a].trim().length < 12 &&
          lines[a - 1].trim().isNotEmpty &&
          !_quoted(lines[a - 1])) {
        a--; // "On Mon, 3 Oct 2026 at 10:00, Ann <ann@example.com>" + "wrote:"
      }
      s = a;
    }
    start = s;
  }
  if (start == null) return QuoteSplit(text);
  final body = lines.sublist(0, start).join('\n').trimRight();
  if (body.trim().isEmpty) return QuoteSplit(text);
  return QuoteSplit(body, lines.sublist(start, end).join('\n'));
}

bool _blank(Node node) {
  if (node is Text) return node.text.trim().isEmpty;
  if (node is Element) {
    if (node.localName == 'br') return true;
    if (node.localName == 'img' || node.localName == 'hr') return false;
    return node.nodes.every(_blank);
  }
  return true;
}

bool _hasClass(Element e, String name) =>
    (e.attributes['class'] ?? '').split(RegExp(r'\s+')).contains(name);

/// A container a mail client puts the quoted message in.
bool _quoteContainer(Node node) {
  if (node is! Element) return false;
  if (node.localName == 'blockquote') return true;
  if (_hasClass(node, 'gmail_quote') ||
      _hasClass(node, 'yahoo_quoted') ||
      _hasClass(node, 'moz-cite-prefix')) {
    return true;
  }
  // A wrapper whose only content is a quote (Apple Mail's <div><br>
  // <blockquote type="cite">…).
  final inner = node.nodes.where((n) => !_blank(n)).toList();
  return inner.length == 1 && _quoteContainer(inner.single);
}

bool _outlookHeader(Node node) =>
    node is Element &&
    (node.id == 'divRplyFwdMsg' || node.id == 'appendonsend');

String _outer(Iterable<Node> nodes) => [
  for (final n in nodes)
    if (n is Element) n.outerHtml else if (n is Text) n.text,
].join();

/// Splits raw message HTML at its quoted tail: a trailing quote container
/// (blockquote, Gmail's gmail_quote, Apple Mail's cite) with the
/// attribution just above it, or everything from Outlook's reply header on.
/// Run before sanitizing: the class and id that mark a quote are what the
/// sanitizer strips. Not a tail, or nothing left above it: no split.
QuoteSplit splitHtmlQuote(String html) {
  final body = html_parser.parse(html).body;
  if (body == null) return QuoteSplit(html);
  final nodes = body.nodes.toList();

  int? start;
  final outlook = nodes.indexWhere(_outlookHeader);
  if (outlook >= 0) {
    start = outlook;
    // The rule Outlook draws above its header belongs to the quote.
    var p = start - 1;
    while (p >= 0 && _blank(nodes[p])) {
      p--;
    }
    if (p >= 0 &&
        nodes[p] is Element &&
        (nodes[p] as Element).localName == 'hr') {
      start = p;
    }
  } else {
    var last = nodes.length - 1;
    while (last >= 0 && _blank(nodes[last])) {
      last--;
    }
    if (last >= 0 && _quoteContainer(nodes[last])) {
      start = last;
      var p = start - 1;
      while (p >= 0 && _blank(nodes[p])) {
        p--;
      }
      if (p >= 0 && _attribution.hasMatch(nodes[p].text?.trim() ?? '')) {
        start = p;
      }
    }
  }
  if (start == null) return QuoteSplit(html);
  final mine = nodes.sublist(0, start);
  if (mine.every(_blank)) return QuoteSplit(html);
  return QuoteSplit(_outer(mine).trim(), _outer(nodes.sublist(start)).trim());
}
