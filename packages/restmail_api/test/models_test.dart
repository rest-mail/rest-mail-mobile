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

  group('admin records, as the server writes them', () {
    test('an audit entry, its target as strings, a null actor id', () {
      final entry = AuditEntry.fromJson({
        'seq': 57,
        'occurred_at': '2026-10-16T21:04:05.123456789Z',
        'actor_kind': 'anonymous',
        'actor_id': null,
        'actor_name': 'root@example.test',
        'credential_id': null,
        'session_id': '',
        'action': 'auth.sign_in',
        'outcome': 'denied',
        'error_code': 'unauthorized',
        'method': 'POST',
        'route': '/api/v1/auth/login',
        'status': 401,
        'target': {'id': '3'},
        'ip': '203.0.113.7',
        'user_agent': 'curl/8',
        'request_id': 'r1',
        'prev_hash': 'a' * 64,
        'hash': 'b' * 64,
      });
      expect(entry.seq, 57);
      expect(entry.actorId, isNull);
      expect(entry.outcome, 'denied');
      expect(entry.target, {'id': '3'});
      expect(entry.occurredAt.isUtc, isFalse);
    });

    test('a broken chain says where; a whole one leaves it out', () {
      final broken = AuditCheck.fromJson({
        'ok': false,
        'checked': 11,
        'first_seq': 1,
        'last_seq': 11,
        'last_hash': 'c' * 64,
        'broken_at_seq': 12,
        'reason': 'hash mismatch',
      });
      expect(
        (broken.ok, broken.brokenAtSeq, broken.reason),
        (false, 12, 'hash mismatch'),
      );
      final whole = AuditCheck.fromJson({
        'ok': true,
        'checked': 0,
        'first_seq': 0,
        'last_seq': 0,
        'last_hash': '0' * 64,
      });
      expect((whole.ok, whole.brokenAtSeq, whole.note), (true, null, ''));
    });

    test('a trace reads its stages and their logs; null stages are none', () {
      final trace = MessageTrace.fromJson({
        'id': 9,
        'message_id': 1042,
        'direction': 'inbound',
        'transport': 'tls',
        'pipeline_id': 2,
        'final_action': 'continue',
        'outcome': 'delivered',
        'spam_score': 1,
        'duration_ms': 31,
        'stages': [
          {
            'filter_name': 'spf_check',
            'filter_type': 'action',
            'action': 'continue',
            'log': {'filter': 'spf_check', 'result': 'pass'},
            'duration_ms': 4000000,
          },
          {
            'filter_name': 'greylist',
            'filter_type': 'action',
            'action': 'continue',
            'skipped': true,
            'skip_reason': 'sender is known',
            'log': {'filter': 'greylist', 'result': ''},
          },
        ],
        'sampled': true,
        'created_at': '2026-10-16T21:04:05Z',
      });
      expect(trace.spamScore, 1.0);
      expect(trace.stages.map((s) => (s.filter, s.result, s.skipped)), [
        ('spf_check', 'pass', false),
        ('greylist', '', true),
      ]);
      expect(
        MessageTrace.fromJson({
          'id': 1,
          'direction': 'outbound',
          'stages': null,
          'created_at': '2026-10-16T21:04:05Z',
        }).stages,
        isEmpty,
      );
    });

    test("a certificate's domain, when the server loads it", () {
      Map<String, dynamic> cert(Object? domain) => {
        'id': 4,
        'domain_id': 7,
        'issuer': "CN=R11,O=Let's Encrypt,C=US",
        'not_before': '2026-09-01T00:00:00Z',
        'not_after': '2026-12-01T00:00:00Z',
        'auto_renew': true,
        'domain': domain,
      };
      expect(
        TlsCertificate.fromJson(cert({'id': 7, 'name': 'a.test'})).domain,
        'a.test',
      );
      expect(TlsCertificate.fromJson(cert(null)).domain, '');
    });

    test("a pipeline's filters, in order", () {
      final pipeline = Pipeline.fromJson({
        'id': 1,
        'domain_id': 7,
        'direction': 'outbound',
        'active': true,
        'filters': [
          {'name': 'dkim_sign', 'type': 'transform', 'enabled': true},
          {
            'name': 'arc_seal',
            'type': 'transform',
            'enabled': false,
            'unskippable': true,
          },
        ],
        'created_at': '2026-10-16T21:04:05Z',
        'updated_at': '2026-10-16T21:04:05Z',
        'domain': {'id': 0, 'name': ''},
      });
      expect(pipeline.filters.map((f) => (f.name, f.enabled, f.unskippable)), [
        ('dkim_sign', true, false),
        ('arc_seal', false, true),
      ]);
    });
  });
}
