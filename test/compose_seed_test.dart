import 'package:flutter_test/flutter_test.dart';
import 'package:restmail/util/compose_seed.dart';
import 'package:restmail_api/restmail_api.dart';

const _me = {'ada@example.test'};

Message _message({
  String sender = 'bob@example.test',
  String? senderName = 'Bob',
  List<Map<String, String>> to = const [
    {'address': 'ada@example.test'},
  ],
  List<Map<String, String>> cc = const [],
  String subject = 'Lunch',
  String body = 'Thursday?\nAt noon',
}) => Message.fromJson({
  'id': 9,
  'mailbox_id': 1,
  'folder': 'INBOX',
  'sender': sender,
  'sender_name': senderName,
  'recipients_to': to,
  'recipients_cc': cc,
  'subject': subject,
  'body_text': body,
  'message_id': '<m1@example.test>',
  'references': '<m0@example.test>',
  'received_at': '2026-09-10T10:00:00Z',
});

void main() {
  test('a reply goes to the sender, quoting the body', () {
    final seed = replySeed(_message(), ownAddresses: _me);

    expect(seed.to, ['bob@example.test']);
    expect(seed.cc, isEmpty);
    expect(seed.from, 'ada@example.test');
    expect(seed.subject, 'Re: Lunch');
    expect(seed.inReplyTo, '<m1@example.test>');
    expect(seed.references, '<m0@example.test> <m1@example.test>');
    expect(
      seed.body,
      contains('Bob <bob@example.test> wrote:\n> Thursday?\n> At noon'),
    );
  });

  test('Re: is not doubled, whatever its case', () {
    expect(
      replySeed(_message(subject: 'RE: Lunch'), ownAddresses: _me).subject,
      'RE: Lunch',
    );
  });

  test(
    'reply all copies everyone except the user and the sender, once each',
    () {
      final seed = replySeed(
        _message(
          to: const [
            {'address': 'ada@example.test'},
            {'address': 'carol@example.test'},
          ],
          cc: const [
            {'address': 'dave@example.test'},
            {'address': 'Bob@example.test'},
            {'address': 'carol@example.test'},
          ],
        ),
        ownAddresses: _me,
        all: true,
      );

      expect(seed.to, ['bob@example.test']);
      expect(seed.cc, ['carol@example.test', 'dave@example.test']);
    },
  );

  test('replying to something the user sent goes to its recipients', () {
    final seed = replySeed(
      _message(
        sender: 'ada@example.test',
        to: const [
          {'address': 'carol@example.test'},
        ],
      ),
      ownAddresses: _me,
    );

    expect(seed.to, ['carol@example.test']);
    expect(seed.from, 'ada@example.test');
  });

  test('a forward carries the original under a header', () {
    final seed = forwardSeed(_message());

    expect(seed.subject, 'Fwd: Lunch');
    expect(seed.to, isEmpty);
    expect(
      seed.body,
      contains(
        '---------- Forwarded message ----------\nFrom: Bob <bob@example.test>',
      ),
    );
    expect(seed.body, endsWith('Thursday?\nAt noon'));
  });

  test('a signature goes above the quoted text', () {
    final seed = replySeed(
      _message(),
      ownAddresses: _me,
    ).signedWith('Ada\nrest-mail');

    expect(seed.body, startsWith('\n\n-- \nAda\nrest-mail\n\nOn '));
  });

  test('addresses split on commas and semicolons, names and all', () {
    final parsed = parseAddresses(
      'Ada Lovelace <ada@example.test>, bob@example.test; nope',
    );

    expect(parsed.valid, ['ada@example.test', 'bob@example.test']);
    expect(parsed.invalid, ['nope']);
  });
}
