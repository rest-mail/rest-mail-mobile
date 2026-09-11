import 'dart:convert';
import 'dart:typed_data';

import 'model.dart';

/// Who the fake knows, and how they sign in. Every mailbox has the same
/// password.
abstract final class FakeAccounts {
  static const host = 'restmail.test';
  static const email = 'dana@restmail.test';
  static const password = 'restmail';

  /// A second mailbox on the same server, for linking.
  static const otherEmail = 'dana@oakline.test';

  /// For [FakeScenario.twoFactor].
  static const totpCode = '123456';
  static const recoveryCode = 'RECOVER-1234';
}

const _dana = FakeRecipient(FakeAccounts.email, 'Dana Ruiz');
const _tom = FakeRecipient('tom@ryeworks.test', 'Tom Rye');

/// A file of [size] bytes that starts like a real one of its kind.
List<int> _file(String header, int size) =>
    Uint8List(size)..setAll(0, utf8.encode(header));

/// A week of Dana's mail, oldest first, dated back from [now]. All of it is
/// made up.
List<FakeMessage> danaMail(DateTime now) {
  DateTime ago(Duration d) => now.subtract(d);
  return [
    FakeMessage(
      folder: 'Archive',
      sender: _tom.address,
      senderName: _tom.name,
      to: const [_dana],
      subject: 'Offsite dates',
      bodyText: 'Pencilled in the 14th and 15th. Shout if either clashes.',
      receivedAt: ago(const Duration(days: 12)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'Receipts',
      sender: 'billing@hosting.test',
      senderName: 'Hosting',
      to: const [_dana],
      subject: 'Receipt for August',
      bodyText: 'Paid in full. Thank you.',
      receivedAt: ago(const Duration(days: 11)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'hello@weekly.test',
      senderName: 'Mail Weekly',
      to: const [_dana],
      subject: 'Issue 742: the case against background sync',
      bodyText:
          'Issue 742: writing a mail client in 2026, the case against '
          'background sync, and a 400-line mail parser.',
      // Here to exercise the sanitizer: a remote image stays blocked until
      // the reader asks, and the script never survives.
      bodyHtml:
          '<h2>Issue 742</h2>'
          '<p>This week: <b>writing a mail client in 2026</b>, the case '
          'against background sync, and a 400-line mail parser that handles '
          'most of the real world.</p>'
          '<p><img src="https://weekly.test/banner.png" alt="Banner" '
          'width="600" height="200"></p>'
          '<p><a href="https://weekly.test/742">Read it online</a></p>'
          '<script>track()</script>',
      receivedAt: ago(const Duration(days: 6)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'lena@studio.test',
      senderName: 'Lena Park',
      to: const [_dana],
      subject: 'Brand colours for the landing page',
      bodyText:
          'Three options attached. I lean towards the second, but the blue '
          'from the app works too.',
      receivedAt: ago(const Duration(days: 4)),
      isRead: true,
      attachments: [
        for (final n in [1, 2, 3])
          FakeAttachment(
            filename: 'option-$n.png',
            contentType: 'image/png',
            bytes: _file('\x89PNG\r\n', 180 * 1024),
          ),
      ],
    ),
    FakeMessage(
      folder: 'Spam',
      sender: 'prize@winner.test',
      senderName: 'Prize Desk',
      to: const [_dana],
      subject: 'You have won!!!',
      bodyText: 'Click to claim.',
      receivedAt: ago(const Duration(days: 3)),
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'security@restmail.test',
      senderName: 'rest-mail security',
      to: const [_dana],
      subject: 'New sign-in from Firefox on Linux',
      bodyText:
          'If this was not you, revoke the session from Settings and change '
          'your password.',
      receivedAt: ago(const Duration(days: 2)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'Sent',
      sender: FakeAccounts.email,
      senderName: 'Dana Ruiz',
      to: const [FakeRecipient('nadia@oakline.test', 'Nadia Osei')],
      subject: 'sync latency on flaky networks',
      bodyText:
          'Can you look at reconnect times on 3G? They spike when the tower '
          'drops us.',
      receivedAt: ago(const Duration(days: 1, hours: 2)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: _tom.address,
      senderName: _tom.name,
      to: const [_dana],
      subject: 'lunch thursday?',
      bodyText:
          'There is a new place two blocks from the office that does a proper '
          'tortilla. 12:30?',
      receivedAt: ago(const Duration(hours: 26)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'Drafts',
      sender: FakeAccounts.email,
      senderName: 'Dana Ruiz',
      to: const [FakeRecipient('lena@studio.test', 'Lena Park')],
      subject: 'Re: Brand colours for the landing page',
      bodyText: 'The second one, but can we try it a touch lighter?',
      receivedAt: ago(const Duration(hours: 5)),
      isRead: true,
      isDraft: true,
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'billing@hosting.test',
      senderName: 'Hosting',
      to: const [_dana],
      subject: 'Invoice 8fa2c paid — €240.00',
      bodyText: 'Your plan renews on 10 October 2026. No action needed.',
      receivedAt: ago(const Duration(hours: 2)),
      isRead: true,
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'builds@ci.restmail.test',
      senderName: 'Build bot',
      to: const [_dana],
      subject: 'main is green again — 2,114 tests passed',
      bodyText:
          'The flaky IDLE test is quarantined and the nightly artifacts are '
          'published.',
      receivedAt: ago(const Duration(minutes: 52)),
    ),
    FakeMessage(
      folder: 'INBOX',
      sender: 'nadia@oakline.test',
      senderName: 'Nadia Osei',
      to: const [_dana],
      cc: const [_tom],
      subject: 'Re: sync latency on flaky networks',
      bodyText:
          'Morning — I pushed backoff/jitter-cap last night.\n\n'
          'Short version: retries no longer stampede when a tower drops us. '
          'Median reconnect went from 4.2 s to 900 ms across the sample, and '
          'the worst case is bounded now instead of unbounded.\n\n'
          'Numbers are in the attached bench. Want to pair on the socket '
          'teardown path tomorrow?',
      receivedAt: ago(const Duration(minutes: 18)),
      attachments: [
        FakeAttachment(
          filename: 'backoff-bench.pdf',
          contentType: 'application/pdf',
          bytes: _file('%PDF-1.4\n', 412 * 1024),
        ),
      ],
    ),
  ];
}

/// The second mailbox's mail.
List<FakeMessage> otherMail(DateTime now) => [
  FakeMessage(
    folder: 'INBOX',
    sender: 'ops@oakline.test',
    senderName: 'Oakline ops',
    to: const [FakeRecipient(FakeAccounts.otherEmail, 'Dana at Oakline')],
    subject: 'Rota for next week',
    bodyText: 'You are on call Tuesday and Wednesday.',
    receivedAt: now.subtract(const Duration(hours: 3)),
  ),
];
