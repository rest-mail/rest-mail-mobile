import 'dart:convert';

/// One event off a `text/event-stream` body.
class ServerSentEvent {
  const ServerSentEvent({required this.event, required this.data, this.id});

  final String event;
  final String data;

  /// The last `id:` the stream sent. A reconnect that names it in
  /// `Last-Event-ID` has the server replay whatever came after.
  final String? id;
}

/// Decodes a `text/event-stream` body per the WHATWG event-stream format.
///
/// Comment lines — rest-mail sends one every 30 seconds as a keepalive — and
/// `retry:` are skipped.
Stream<ServerSentEvent> decodeServerSentEvents(Stream<List<int>> body) async* {
  String? id;
  var event = '';
  final data = StringBuffer();
  var hasData = false;
  final lines = body
      .transform(const Utf8Decoder(allowMalformed: true))
      .transform(const LineSplitter());
  await for (final line in lines) {
    if (line.isEmpty) {
      if (hasData) {
        yield ServerSentEvent(
          event: event.isEmpty ? 'message' : event,
          data: data.toString(),
          id: id,
        );
      }
      event = '';
      data.clear();
      hasData = false;
      continue;
    }
    if (line.startsWith(':')) continue;
    final colon = line.indexOf(':');
    final field = colon < 0 ? line : line.substring(0, colon);
    var value = colon < 0 ? '' : line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);
    switch (field) {
      case 'event':
        event = value;
      case 'data':
        if (hasData) data.write('\n');
        data.write(value);
        hasData = true;
      case 'id':
        if (!value.contains('\u0000')) id = value;
    }
  }
}

/// The events rest-mail pushes on a mailbox's stream.
abstract final class MailEventType {
  /// `{message_id, folder, sender, subject}`
  static const newMessage = 'new_message';

  /// `{message_id, folder, is_read, is_flagged, is_starred, is_draft}`
  static const messageUpdated = 'message_updated';

  /// `{message_id}`
  static const messageDeleted = 'message_deleted';

  /// `{folder, unread_count?}`
  static const folderUpdate = 'folder_update';
}

/// A change to a mailbox, pushed while its event stream is open.
class MailEvent {
  const MailEvent({required this.type, required this.data, this.id});

  /// Reads a rest-mail event, whose `data:` is a JSON object. Anything else is
  /// not one of its events and gives null.
  static MailEvent? fromServerSentEvent(ServerSentEvent sse) {
    try {
      final decoded = jsonDecode(sse.data);
      if (decoded is Map<String, dynamic>) {
        return MailEvent(type: sse.event, data: decoded, id: sse.id);
      }
    } on FormatException {
      // Not JSON, so not an event this client knows.
    }
    return null;
  }

  /// One of [MailEventType], or a type this client does not know yet.
  final String type;
  final Map<String, dynamic> data;
  final String? id;

  int? get messageId => switch (data['message_id']) {
    final num id => id.toInt(),
    _ => null,
  };

  String? get folder => switch (data['folder']) {
    final String folder => folder,
    _ => null,
  };
}
