import 'dart:convert';

import 'package:restmail_api/restmail_api.dart';
import 'package:test/test.dart';

Stream<List<int>> _chunks(List<List<int>> parts) => Stream.fromIterable(parts);

List<int> _bytes(String text) => utf8.encode(text);

void main() {
  test('splits events on blank lines, across chunk boundaries', () async {
    final events = await decodeServerSentEvents(
      _chunks([
        _bytes('id: 1\nevent: new_mes'),
        _bytes('sage\ndata: {"a":1}\n'),
        _bytes('\n: keepalive\n\n'),
        _bytes('data: one\r\ndata: two\r\n\r\n'),
      ]),
    ).toList();

    expect(events.map((e) => (e.id, e.event, e.data)), [
      ('1', 'new_message', '{"a":1}'),
      // The id carries over, as the spec's last-event-id buffer does.
      ('1', 'message', 'one\ntwo'),
    ]);
  });

  test('keeps a multi-byte character split between chunks', () async {
    final bytes = _bytes('data: Grüße\n\n');
    final split = bytes.indexOf(0xC3) + 1; // between the two bytes of ü
    final events = await decodeServerSentEvents(
      _chunks([bytes.sublist(0, split), bytes.sublist(split)]),
    ).toList();
    expect(events.single.data, 'Grüße');
  });

  test('an event with no data is not dispatched', () async {
    final events = await decodeServerSentEvents(
      _chunks([_bytes('event: folder_update\n\n')]),
    ).toList();
    expect(events, isEmpty);
  });

  group('MailEvent', () {
    test('reads the JSON payload', () {
      final event = MailEvent.fromServerSentEvent(
        const ServerSentEvent(
          event: MailEventType.newMessage,
          data: '{"message_id": 42, "folder": "INBOX", "subject": "Hi"}',
          id: '9',
        ),
      )!;
      expect(event.type, MailEventType.newMessage);
      expect(event.messageId, 42);
      expect(event.folder, 'INBOX');
      expect(event.id, '9');
    });

    test('is null for a payload that is not a JSON object', () {
      expect(
        MailEvent.fromServerSentEvent(
          const ServerSentEvent(event: 'x', data: 'hello'),
        ),
        isNull,
      );
    });
  });
}
