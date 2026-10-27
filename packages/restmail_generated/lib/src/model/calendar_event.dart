// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/calendar_address.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CalendarEvent extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CalendarEvent({
    required this.allDay,
    required this.dtend,
    required this.dtstart,
    required this.method,
    required this.organizer,
    required this.sequence,
    required this.summary,
    required this.uid,
    this.attendees,
    this.description,
    this.dtstamp,
    this.location,
    this.status,
  });

  factory CalendarEvent.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CalendarEvent: contains complex types',
    );
  }

  factory CalendarEvent.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CalendarEvent');
    return CalendarEvent(
      allDay: _$map[r'all_day'].decodeJsonBool(
        context: r'CalendarEvent.all_day',
      ),
      attendees: _$map[r'attendees']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'CalendarEvent.attendees',
          )
          ?.map(_i4.CalendarAddress.fromJson)
          .toList(),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'CalendarEvent.description',
      ),
      dtend: _$map[r'dtend'].decodeJsonDateTime(
        context: r'CalendarEvent.dtend',
      ),
      dtstamp: _$map[r'dtstamp'].decodeJsonNullableDateTime(
        context: r'CalendarEvent.dtstamp',
      ),
      dtstart: _$map[r'dtstart'].decodeJsonDateTime(
        context: r'CalendarEvent.dtstart',
      ),
      location: _$map[r'location'].decodeJsonNullableString(
        context: r'CalendarEvent.location',
      ),
      method: _$map[r'method'].decodeJsonString(
        context: r'CalendarEvent.method',
      ),
      organizer: _i4.CalendarAddress.fromJson(_$map[r'organizer']),
      sequence: _$map[r'sequence'].decodeJsonInt(
        context: r'CalendarEvent.sequence',
      ),
      status: _$map[r'status'].decodeJsonNullableString(
        context: r'CalendarEvent.status',
      ),
      summary: _$map[r'summary'].decodeJsonString(
        context: r'CalendarEvent.summary',
      ),
      uid: _$map[r'uid'].decodeJsonString(context: r'CalendarEvent.uid'),
    );
  }

  factory CalendarEvent.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CalendarEvent: contains complex types',
    );
  }

  final _i3.bool allDay;

  final _i3.List<_i4.CalendarAddress>? attendees;

  final _i3.String? description;

  final _i3.DateTime dtend;

  final _i3.DateTime? dtstamp;

  final _i3.DateTime dtstart;

  final _i3.String? location;

  final _i3.String method;

  final _i4.CalendarAddress organizer;

  final _i3.int sequence;

  final _i3.String? status;

  final _i3.String summary;

  final _i3.String uid;

  @_i3.override
  _i3.Object? toJson() => {
    r'all_day': allDay,
    if (attendees != null)
      r'attendees': attendees?.map((e) => e.toJson()).toList(),
    if (description != null) r'description': description,
    r'dtend': dtend.toTimeZonedIso8601String(),
    if (dtstamp != null) r'dtstamp': dtstamp?.toTimeZonedIso8601String(),
    r'dtstart': dtstart.toTimeZonedIso8601String(),
    if (location != null) r'location': location,
    r'method': method,
    r'organizer': organizer.toJson(),
    r'sequence': sequence,
    if (status != null) r'status': status,
    r'summary': summary,
    r'uid': uid,
  };

  $$CalendarEventCopyWith<CalendarEvent> get copyWith =>
      _CalendarEventCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is CalendarEvent &&
        other.allDay == this.allDay &&
        _$deepEquals.equals(other.attendees, this.attendees) &&
        other.description == this.description &&
        other.dtend == this.dtend &&
        other.dtstamp == this.dtstamp &&
        other.dtstart == this.dtstart &&
        other.location == this.location &&
        other.method == this.method &&
        other.organizer == this.organizer &&
        other.sequence == this.sequence &&
        other.status == this.status &&
        other.summary == this.summary &&
        other.uid == this.uid;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      allDay,
      deepEquals.hash(attendees),
      description,
      dtend,
      dtstamp,
      dtstart,
      location,
      method,
      organizer,
      sequence,
      status,
      summary,
      uid,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CalendarEvent: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CalendarEvent: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CalendarEventCopyWith<$Res> {
  factory $$CalendarEventCopyWith(CalendarEvent value) =
      _CalendarEventCopyWith<$Res>;

  $Res call({
    _i3.bool? allDay,
    _i3.List<_i4.CalendarAddress>? attendees,
    _i3.String? description,
    _i3.DateTime? dtend,
    _i3.DateTime? dtstamp,
    _i3.DateTime? dtstart,
    _i3.String? location,
    _i3.String? method,
    _i4.CalendarAddress? organizer,
    _i3.int? sequence,
    _i3.String? status,
    _i3.String? summary,
    _i3.String? uid,
  });
  _i3.bool get allDay;
  _i3.List<_i4.CalendarAddress>? get attendees;
  _i3.String? get description;
  _i3.DateTime get dtend;
  _i3.DateTime? get dtstamp;
  _i3.DateTime get dtstart;
  _i3.String? get location;
  _i3.String get method;
  _i4.CalendarAddress get organizer;
  _i3.int get sequence;
  _i3.String? get status;
  _i3.String get summary;
  _i3.String get uid;
}

class _CalendarEventCopyWith<$Res> implements $$CalendarEventCopyWith<$Res> {
  _CalendarEventCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CalendarEvent _value;

  @_i3.override
  _i3.bool get allDay => _value.allDay;

  @_i3.override
  _i3.List<_i4.CalendarAddress>? get attendees => _value.attendees;

  @_i3.override
  _i3.String? get description => _value.description;

  @_i3.override
  _i3.DateTime get dtend => _value.dtend;

  @_i3.override
  _i3.DateTime? get dtstamp => _value.dtstamp;

  @_i3.override
  _i3.DateTime get dtstart => _value.dtstart;

  @_i3.override
  _i3.String? get location => _value.location;

  @_i3.override
  _i3.String get method => _value.method;

  @_i3.override
  _i4.CalendarAddress get organizer => _value.organizer;

  @_i3.override
  _i3.int get sequence => _value.sequence;

  @_i3.override
  _i3.String? get status => _value.status;

  @_i3.override
  _i3.String get summary => _value.summary;

  @_i3.override
  _i3.String get uid => _value.uid;

  @_i3.override
  $Res call({
    _i3.Object? allDay = _sentinel,
    _i3.Object? attendees = _sentinel,
    _i3.Object? description = _sentinel,
    _i3.Object? dtend = _sentinel,
    _i3.Object? dtstamp = _sentinel,
    _i3.Object? dtstart = _sentinel,
    _i3.Object? location = _sentinel,
    _i3.Object? method = _sentinel,
    _i3.Object? organizer = _sentinel,
    _i3.Object? sequence = _sentinel,
    _i3.Object? status = _sentinel,
    _i3.Object? summary = _sentinel,
    _i3.Object? uid = _sentinel,
  }) {
    return (CalendarEvent(
      allDay: _i3.identical(allDay, _sentinel)
          ? this.allDay
          : (allDay as _i3.bool),
      attendees: _i3.identical(attendees, _sentinel)
          ? this.attendees
          : (attendees as _i3.List<_i4.CalendarAddress>?),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      dtend: _i3.identical(dtend, _sentinel)
          ? this.dtend
          : (dtend as _i3.DateTime),
      dtstamp: _i3.identical(dtstamp, _sentinel)
          ? this.dtstamp
          : (dtstamp as _i3.DateTime?),
      dtstart: _i3.identical(dtstart, _sentinel)
          ? this.dtstart
          : (dtstart as _i3.DateTime),
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i3.String?),
      method: _i3.identical(method, _sentinel)
          ? this.method
          : (method as _i3.String),
      organizer: _i3.identical(organizer, _sentinel)
          ? this.organizer
          : (organizer as _i4.CalendarAddress),
      sequence: _i3.identical(sequence, _sentinel)
          ? this.sequence
          : (sequence as _i3.int),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String?),
      summary: _i3.identical(summary, _sentinel)
          ? this.summary
          : (summary as _i3.String),
      uid: _i3.identical(uid, _sentinel) ? this.uid : (uid as _i3.String),
    ) as $Res);
  }
}
