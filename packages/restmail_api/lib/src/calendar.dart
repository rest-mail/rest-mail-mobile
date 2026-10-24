/// A calendar invitation, and its updates, as REST Mail reads them from the
/// iCalendar (RFC 5545) parts of a message: one event of one iTIP method
/// (RFC 5546), REQUEST to invite, CANCEL to call off, REPLY to answer.
class CalendarInvite {
  const CalendarInvite({
    required this.method,
    required this.uid,
    required this.summary,
    this.description,
    this.location,
    this.start,
    this.end,
    this.allDay = false,
    this.organizer,
    this.attendees = const [],
    this.status,
    this.sequence = 0,
  });

  factory CalendarInvite.fromJson(Map<String, dynamic> json) => CalendarInvite(
    method: (json['method'] as String? ?? '').toUpperCase(),
    uid: json['uid'] as String? ?? '',
    summary: json['summary'] as String? ?? '',
    description: _text(json['description']),
    location: _text(json['location']),
    start: _when(json['dtstart']),
    end: _when(json['dtend']),
    allDay: json['all_day'] as bool? ?? false,
    organizer: switch (json['organizer']) {
      final Map<String, dynamic> party
          when (party['address'] as String? ?? '').isNotEmpty =>
        CalendarParty.fromJson(party),
      _ => null,
    },
    attendees: [
      for (final party in json['attendees'] as List? ?? const [])
        if (party is Map<String, dynamic>) CalendarParty.fromJson(party),
    ],
    status: _text(json['status'])?.toUpperCase(),
    sequence: (json['sequence'] as num?)?.toInt() ?? 0,
  );

  /// REQUEST, CANCEL, REPLY, …, in capitals.
  final String method;
  final String uid;
  final String summary;
  final String? description;
  final String? location;

  /// When it starts and ends; null where the event does not say.
  final DateTime? start;
  final DateTime? end;
  final bool allDay;
  final CalendarParty? organizer;
  final List<CalendarParty> attendees;

  /// CONFIRMED, TENTATIVE or CANCELLED, when the event says.
  final String? status;
  final int sequence;

  /// An invitation that can be answered: a request not called off.
  bool get canReply => method == 'REQUEST' && status != 'CANCELLED';

  static List<CalendarInvite> listFromJson(Object? value) => [
    for (final event in value is List ? value : const [])
      if (event is Map<String, dynamic>) CalendarInvite.fromJson(event),
  ];
}

/// An organizer or attendee: an address, and what the event says of them.
class CalendarParty {
  const CalendarParty({
    required this.address,
    this.name,
    this.role,
    this.partStat,
    this.rsvp = false,
  });

  factory CalendarParty.fromJson(Map<String, dynamic> json) => CalendarParty(
    address: json['address'] as String? ?? '',
    name: _text(json['name']),
    role: _text(json['role']),
    partStat: _text(json['partstat'])?.toUpperCase(),
    rsvp: json['rsvp'] as bool? ?? false,
  );

  final String address;
  final String? name;

  /// REQ-PARTICIPANT, OPT-PARTICIPANT, …
  final String? role;

  /// NEEDS-ACTION, ACCEPTED, DECLINED or TENTATIVE.
  final String? partStat;
  final bool rsvp;

  String get label => name ?? address;
}

/// An event an account has received invitations for, all its versions in
/// one: the latest's method, status and summary, and how many there were.
class CalendarEventSummary {
  const CalendarEventSummary({
    required this.uid,
    required this.method,
    required this.summary,
    required this.sequence,
    required this.isCancelled,
    required this.versions,
    this.status,
    this.messageId,
  });

  factory CalendarEventSummary.fromJson(Map<String, dynamic> json) =>
      CalendarEventSummary(
        uid: json['uid'] as String,
        method: (json['method'] as String? ?? '').toUpperCase(),
        summary: json['summary'] as String? ?? '',
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        isCancelled: json['is_cancelled'] as bool? ?? false,
        versions: (json['versions'] as num?)?.toInt() ?? 1,
        status: _text(json['status'])?.toUpperCase(),
        messageId: (json['message_id'] as num?)?.toInt(),
      );

  final String uid;
  final String method;
  final String summary;
  final int sequence;
  final bool isCancelled;

  /// How many versions of it arrived: the invitation and its updates.
  final int versions;
  final String? status;

  /// The message the latest version came in, when it is still there.
  final int? messageId;
}

/// An answer to an invitation, as iTIP's PARTSTAT names it.
enum CalendarResponse {
  accepted('ACCEPTED'),
  declined('DECLINED'),
  tentative('TENTATIVE');

  const CalendarResponse(this.value);

  final String value;

  static CalendarResponse? fromValue(Object? value) {
    for (final response in values) {
      if (response.value == '$value'.toUpperCase()) return response;
    }
    return null;
  }
}

String? _text(Object? value) =>
    value is String && value.trim().isNotEmpty ? value : null;

/// A time the server wrote, or null for none: Go writes a missing one as
/// the zero time, year 1.
DateTime? _when(Object? value) {
  final parsed = value is String ? DateTime.tryParse(value) : null;
  return parsed == null || parsed.year <= 1 ? null : parsed;
}
