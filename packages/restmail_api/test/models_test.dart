import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

Map<String, dynamic> _message([Map<String, dynamic> overrides = const {}]) => {
  'id': 1,
  'mailbox_id': 2,
  'folder': 'INBOX',
  'sender': 'bob@example.test',
  'subject': 'Hi',
  'is_read': false,
  'is_flagged': false,
  'is_starred': false,
  'is_draft': false,
  'is_deleted': false,
  'received_at': '2026-09-10T20:00:00Z',
  'created_at': '2026-09-10T20:00:00Z',
  'updated_at': '2026-09-10T20:00:00Z',
  ...overrides,
};

void main() {
  group('Recipient.listFromJson', () {
    test('reads address objects', () {
      final list = Recipient.listFromJson([
        {'address': 'ada@example.test', 'name': 'Ada'},
        {'address': 'bob@example.test', 'name': ''},
      ]);
      expect(list.map((r) => (r.address, r.name)), [
        ('ada@example.test', 'Ada'),
        ('bob@example.test', null),
      ]);
    });

    test('reads bare address strings', () {
      expect(
        Recipient.listFromJson(['ada@example.test']).single.address,
        'ada@example.test',
      );
    });

    test('reads an array JSON-encoded inside a string', () {
      expect(
        Recipient.listFromJson(
          '[{"address":"ada@example.test"}]',
        ).single.address,
        'ada@example.test',
      );
    });

    test('treats null as nobody', () {
      expect(Recipient.listFromJson(null), isEmpty);
    });
  });

  group('Message', () {
    test('parses the fields a list row needs', () {
      final message = Message.fromJson(
        _message({
          'sender_name': 'Bob',
          'recipients_to': [
            {'address': 'ada@example.test'},
          ],
          'body_text': 'Line one\n\n  line two',
          'date_header': null,
        }),
      );
      expect(message.senderLabel, 'Bob');
      expect(message.to.single.address, 'ada@example.test');
      expect(message.preview, 'Line one line two');
      expect(message.date, message.receivedAt);
      expect(message.receivedAt.isUtc, isFalse);
    });

    test('prefers the Date header over the arrival time', () {
      final message = Message.fromJson(
        _message({'date_header': '2026-09-09T08:00:00Z'}),
      );
      expect(message.date.toUtc(), DateTime.utc(2026, 9, 9, 8));
    });

    test('copyWith changes only what it is given', () {
      final message = Message.fromJson(_message()).copyWith(isRead: true);
      expect(message.isRead, isTrue);
      expect(message.folder, 'INBOX');
      expect(message.isFlagged, isFalse);
    });
  });

  test('OutgoingMessage leaves Bcc off a draft', () {
    const draft = OutgoingMessage(
      from: 'ada@example.test',
      to: ['bob@example.test'],
      bcc: ['eve@example.test'],
      subject: 'Hi',
    );
    expect(draft.toDraftJson().containsKey('bcc'), isFalse);
    expect(draft.toSendJson()['bcc'], ['eve@example.test']);
  });

  test('SearchQuery sends only the filters that are set', () {
    expect(
      const SearchQuery(
        text: '  invoice ',
        hasAttachment: true,
      ).toQueryParameters(),
      {'q': 'invoice', 'has:attachment': 'true'},
    );
  });
}
