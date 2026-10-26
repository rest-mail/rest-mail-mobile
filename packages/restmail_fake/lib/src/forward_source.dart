import 'dart:convert';

import 'model.dart';

String _date(DateTime value) {
  final d = value.toUtc();
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  String two(int n) => '$n'.padLeft(2, '0');
  return '${days[d.weekday - 1]}, ${two(d.day)} ${months[d.month - 1]} ${d.year} ${two(d.hour)}:${two(d.minute)}:${two(d.second)} +0000';
}

({String text, String? html}) forwardedBodies(
  String note,
  FakeMessage original,
) {
  final header =
      '---------- Forwarded message ----------\nFrom: ${original.sender}\nSubject: ${original.subject}';
  final text =
      '${note.isEmpty ? '' : '$note\n\n'}$header\n\n${original.bodyText}';
  const escape = HtmlEscape();
  final html = original.bodyHtml == null || original.bodyHtml!.isEmpty
      ? null
      : '${note.isEmpty ? '' : '<p>${escape.convert(note).replaceAll('\n', '<br>')}</p>\n'}'
            '<p>---------- Forwarded message ----------<br>\n'
            'From: ${escape.convert(original.sender)}<br>\n'
            'Subject: ${escape.convert(original.subject)}</p>\n${original.bodyHtml}';
  return (text: text, html: html);
}

/// A MIME source for the fake's forwarded copy, including binary, empty and
/// inline parts. The production server's cryptographic signing is separate.
String forwardedSource(FakeMessage message) {
  final boundary =
      'fake-forward-${base64Url.encode(utf8.encode(message.messageId)).replaceAll('=', '')}';
  final bodyBoundary = '$boundary-body';
  String quote(String value) =>
      value.replaceAll('\r', '').replaceAll('\n', '').replaceAll('"', '\\"');
  final lines = <String>[
    'From: ${message.sender}',
    'To: ${message.to.map((r) => r.address).join(', ')}',
    'Subject: ${message.subject}',
    'Date: ${_date(message.receivedAt)}',
    'Message-ID: ${message.messageId}',
    'MIME-Version: 1.0',
    'Content-Type: multipart/mixed; boundary="$boundary"',
    '',
    '--$boundary',
  ];
  void encodedBody(List<int> bytes) {
    final encoded = base64.encode(bytes);
    for (var i = 0; i < encoded.length; i += 76) {
      final end = i + 76 < encoded.length ? i + 76 : encoded.length;
      lines.add(encoded.substring(i, end));
    }
  }

  void body(String type, String text) {
    lines.addAll([
      'Content-Type: $type; charset=utf-8',
      'Content-Transfer-Encoding: base64',
      '',
    ]);
    encodedBody(utf8.encode(text));
  }

  if (message.bodyHtml case final html?) {
    lines.addAll([
      'Content-Type: multipart/alternative; boundary="$bodyBoundary"',
      '',
      '--$bodyBoundary',
    ]);
    body('text/plain', message.bodyText);
    lines.add('--$bodyBoundary');
    body('text/html', html);
    lines.add('--$bodyBoundary--');
  } else {
    body('text/plain', message.bodyText);
  }
  for (final part in message.attachments) {
    lines.addAll([
      '--$boundary',
      'Content-Type: ${part.contentType}; name="${quote(part.filename)}"',
      'Content-Disposition: ${part.disposition}; filename="${quote(part.filename)}"',
      if (part.contentId case final cid?) 'Content-ID: <${quote(cid)}>',
      'Content-Transfer-Encoding: base64',
      '',
    ]);
    encodedBody(part.bytes);
  }
  lines.add('--$boundary--');
  return lines.join('\r\n');
}
