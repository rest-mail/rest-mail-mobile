import 'package:restmail_api/restmail_api.dart';

import 'format.dart';
import 'html_sanitizer.dart';

enum ComposeKind { fresh, reply, forward, draft }

/// What the compose sheet opens with.
class ComposeSeed {
  const ComposeSeed({
    this.kind = ComposeKind.fresh,
    this.from,
    this.to = const [],
    this.cc = const [],
    this.subject = '',
    this.body = '',
    this.inReplyTo,
    this.references,
    this.draftId,
  });

  final ComposeKind kind;

  /// Which of the user's addresses to send from; null for the current one.
  final String? from;
  final List<String> to;
  final List<String> cc;
  final String subject;
  final String body;
  final String? inReplyTo;
  final String? references;

  /// Set when editing a saved draft, so saving updates it and sending sends it.
  final int? draftId;

  /// The body with [signature] ahead of any quoted text, behind the standard
  /// `-- ` separator mail clients recognise.
  ComposeSeed signedWith(String signature) {
    final sign = signature.trim();
    if (sign.isEmpty) return this;
    return ComposeSeed(
      kind: kind,
      from: from,
      to: to,
      cc: cc,
      subject: subject,
      body: '\n\n-- \n$sign$body',
      inReplyTo: inReplyTo,
      references: references,
      draftId: draftId,
    );
  }
}

/// A reply to [original]'s sender, or with [all], to everyone on it except
/// the user. Replying to something the user sent goes to its recipients.
ComposeSeed replySeed(
  Message original, {
  required Set<String> ownAddresses,
  bool all = false,
}) {
  final fromMe = ownAddresses.contains(original.sender.toLowerCase());
  final to = fromMe
      ? [for (final r in original.to) r.address]
      : [original.sender];
  final cc = <String>[];
  if (all) {
    final seen = {...ownAddresses, for (final a in to) a.toLowerCase()};
    for (final r in [...original.to, ...original.cc]) {
      if (seen.add(r.address.toLowerCase())) cc.add(r.address);
    }
  }
  final receivedAs = [...original.to, ...original.cc]
      .map((r) => r.address)
      .where((a) => ownAddresses.contains(a.toLowerCase()))
      .firstOrNull;
  return ComposeSeed(
    kind: ComposeKind.reply,
    from: fromMe ? original.sender : receivedAs,
    to: to,
    cc: cc,
    subject: withPrefix('Re:', original.subject),
    body: '\n\n${attribution(original)}\n${quote(plainBodyOf(original))}',
    inReplyTo: original.messageId,
    references: _references(original),
  );
}

ComposeSeed forwardSeed(Message original) => ComposeSeed(
  kind: ComposeKind.forward,
  subject: withPrefix('Fwd:', original.subject),
  body: [
    '',
    '',
    '---------- Forwarded message ----------',
    'From: ${senderLine(original)}',
    'Date: ${longDate(original.date)}',
    'Subject: ${original.subject}',
    if (original.to.isNotEmpty)
      'To: ${original.to.map((r) => r.address).join(', ')}',
    '',
    plainBodyOf(original),
  ].join('\n'),
);

ComposeSeed draftSeed(Message draft) => ComposeSeed(
  kind: ComposeKind.draft,
  from: draft.sender.isEmpty ? null : draft.sender,
  to: [for (final r in draft.to) r.address],
  cc: [for (final r in draft.cc) r.address],
  subject: draft.subject,
  body: plainBodyOf(draft),
  inReplyTo: draft.inReplyTo,
  references: draft.references,
  draftId: draft.id,
);

/// `Re:` or `Fwd:` in front of a subject, unless it is already there.
String withPrefix(String prefix, String subject) {
  final trimmed = subject.trim();
  final lower = trimmed.toLowerCase();
  final already = prefix == 'Re:'
      ? lower.startsWith('re:')
      : lower.startsWith('fwd:') || lower.startsWith('fw:');
  return already ? trimmed : '$prefix $trimmed'.trim();
}

String senderLine(Message message) => message.senderName == null
    ? message.sender
    : '${message.senderName} <${message.sender}>';

String attribution(Message message) =>
    'On ${longDate(message.date)}, ${senderLine(message)} wrote:';

String quote(String text) =>
    text.split('\n').map((line) => line.isEmpty ? '>' : '> $line').join('\n');

String plainBodyOf(Message message) =>
    message.bodyText ?? htmlToPlainText(message.bodyHtml ?? '');

String? _references(Message original) {
  final chain = [
    original.references,
    original.messageId,
  ].whereType<String>().where((id) => id.trim().isNotEmpty).join(' ').trim();
  return chain.isEmpty ? null : chain;
}

final _address = RegExp(r'^[^@\s<>,;]+@[^@\s<>,;]+\.[^@\s<>,;]+$');

/// Splits what was typed into a To, Cc or Bcc field into addresses. Commas
/// or semicolons separate them, and any may be written `Name <address>`.
/// Anything left over that is not an address comes back as [invalid].
({List<String> valid, List<String> invalid}) parseAddresses(String input) {
  final valid = <String>[], invalid = <String>[];
  for (final part in input.split(RegExp(r'[,;]'))) {
    final text = part.trim();
    if (text.isEmpty) continue;
    final angled = RegExp(r'<([^>]*)>').firstMatch(text)?.group(1)?.trim();
    final candidates = angled != null ? [angled] : text.split(RegExp(r'\s+'));
    for (final candidate in candidates) {
      if (_address.hasMatch(candidate)) {
        valid.add(candidate);
      } else {
        invalid.add(candidate);
      }
    }
  }
  return (valid: valid, invalid: invalid);
}
