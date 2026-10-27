// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/sample_calendar_address.dart'
    as _i4;
import 'package:restmail_generated/src/model/sample_calendar_event_organizer_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleCalendarEvent extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleCalendarEvent({
    this.allDay,
    this.attendees,
    this.description,
    this.dtend,
    this.dtstamp,
    this.dtstart,
    this.location,
    this.method,
    this.organizer,
    this.sequence,
    this.status,
    this.summary,
    this.uid,
  });

  factory SampleCalendarEvent.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SampleCalendarEvent: contains complex types',
    );
  }

  factory SampleCalendarEvent.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleCalendarEvent');
    return SampleCalendarEvent(
      allDay: _$map[r'all_day'].decodeJsonNullableBool(
        context: r'SampleCalendarEvent.all_day',
      ),
      attendees: _$map[r'attendees']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'SampleCalendarEvent.attendees',
          )
          ?.map(_i4.SampleCalendarAddress.fromJson)
          .toList(),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.description',
      ),
      dtend: _$map[r'dtend'].decodeJsonNullableDateTime(
        context: r'SampleCalendarEvent.dtend',
      ),
      dtstamp: _$map[r'dtstamp'].decodeJsonNullableDateTime(
        context: r'SampleCalendarEvent.dtstamp',
      ),
      dtstart: _$map[r'dtstart'].decodeJsonNullableDateTime(
        context: r'SampleCalendarEvent.dtstart',
      ),
      location: _$map[r'location'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.location',
      ),
      method: _$map[r'method'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.method',
      ),
      organizer: _$map[r'organizer'] == null
          ? null
          : _i5.SampleCalendarEventOrganizerOneOfModel.fromJson(
              _$map[r'organizer'],
            ),
      sequence: _$map[r'sequence'].decodeJsonNullableInt(
        context: r'SampleCalendarEvent.sequence',
      ),
      status: _$map[r'status'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.status',
      ),
      summary: _$map[r'summary'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.summary',
      ),
      uid: _$map[r'uid'].decodeJsonNullableString(
        context: r'SampleCalendarEvent.uid',
      ),
    );
  }

  factory SampleCalendarEvent.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SampleCalendarEvent: contains complex types',
    );
  }

  final _i3.bool? allDay;

  final _i3.List<_i4.SampleCalendarAddress>? attendees;

  final _i3.String? description;

  final _i3.DateTime? dtend;

  final _i3.DateTime? dtstamp;

  final _i3.DateTime? dtstart;

  final _i3.String? location;

  final _i3.String? method;

  final _i5.SampleCalendarEventOrganizerOneOfModel? organizer;

  final _i3.int? sequence;

  final _i3.String? status;

  final _i3.String? summary;

  final _i3.String? uid;

  @_i3.override
  _i3.Object? toJson() => {
    r'all_day': allDay,
    r'attendees': attendees?.map((e) => e.toJson()).toList(),
    r'description': description,
    r'dtend': dtend?.toTimeZonedIso8601String(),
    r'dtstamp': dtstamp?.toTimeZonedIso8601String(),
    r'dtstart': dtstart?.toTimeZonedIso8601String(),
    r'location': location,
    r'method': method,
    if (organizer != null) r'organizer': organizer?.toJson(),
    r'sequence': sequence,
    r'status': status,
    r'summary': summary,
    r'uid': uid,
  };

  $$SampleCalendarEventCopyWith<SampleCalendarEvent> get copyWith =>
      _SampleCalendarEventCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is SampleCalendarEvent &&
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
    const deepEquals = _i6.DeepCollectionEquality();
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
    r'parameterProperties not supported for SampleCalendarEvent: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SampleCalendarEvent: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleCalendarEventCopyWith<$Res> {
  factory $$SampleCalendarEventCopyWith(SampleCalendarEvent value) =
      _SampleCalendarEventCopyWith<$Res>;

  $Res call({
    _i3.bool? allDay,
    _i3.List<_i4.SampleCalendarAddress>? attendees,
    _i3.String? description,
    _i3.DateTime? dtend,
    _i3.DateTime? dtstamp,
    _i3.DateTime? dtstart,
    _i3.String? location,
    _i3.String? method,
    _i5.SampleCalendarEventOrganizerOneOfModel? organizer,
    _i3.int? sequence,
    _i3.String? status,
    _i3.String? summary,
    _i3.String? uid,
  });
  _i3.bool? get allDay;
  _i3.List<_i4.SampleCalendarAddress>? get attendees;
  _i3.String? get description;
  _i3.DateTime? get dtend;
  _i3.DateTime? get dtstamp;
  _i3.DateTime? get dtstart;
  _i3.String? get location;
  _i3.String? get method;
  _i5.SampleCalendarEventOrganizerOneOfModel? get organizer;
  _i3.int? get sequence;
  _i3.String? get status;
  _i3.String? get summary;
  _i3.String? get uid;
}

class _SampleCalendarEventCopyWith<$Res>
    implements $$SampleCalendarEventCopyWith<$Res> {
  _SampleCalendarEventCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleCalendarEvent _value;

  @_i3.override
  _i3.bool? get allDay => _value.allDay;

  @_i3.override
  _i3.List<_i4.SampleCalendarAddress>? get attendees => _value.attendees;

  @_i3.override
  _i3.String? get description => _value.description;

  @_i3.override
  _i3.DateTime? get dtend => _value.dtend;

  @_i3.override
  _i3.DateTime? get dtstamp => _value.dtstamp;

  @_i3.override
  _i3.DateTime? get dtstart => _value.dtstart;

  @_i3.override
  _i3.String? get location => _value.location;

  @_i3.override
  _i3.String? get method => _value.method;

  @_i3.override
  _i5.SampleCalendarEventOrganizerOneOfModel? get organizer => _value.organizer;

  @_i3.override
  _i3.int? get sequence => _value.sequence;

  @_i3.override
  _i3.String? get status => _value.status;

  @_i3.override
  _i3.String? get summary => _value.summary;

  @_i3.override
  _i3.String? get uid => _value.uid;

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
    return (SampleCalendarEvent(
      allDay: _i3.identical(allDay, _sentinel)
          ? this.allDay
          : (allDay as _i3.bool?),
      attendees: _i3.identical(attendees, _sentinel)
          ? this.attendees
          : (attendees as _i3.List<_i4.SampleCalendarAddress>?),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      dtend: _i3.identical(dtend, _sentinel)
          ? this.dtend
          : (dtend as _i3.DateTime?),
      dtstamp: _i3.identical(dtstamp, _sentinel)
          ? this.dtstamp
          : (dtstamp as _i3.DateTime?),
      dtstart: _i3.identical(dtstart, _sentinel)
          ? this.dtstart
          : (dtstart as _i3.DateTime?),
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i3.String?),
      method: _i3.identical(method, _sentinel)
          ? this.method
          : (method as _i3.String?),
      organizer: _i3.identical(organizer, _sentinel)
          ? this.organizer
          : (organizer as _i5.SampleCalendarEventOrganizerOneOfModel?),
      sequence: _i3.identical(sequence, _sentinel)
          ? this.sequence
          : (sequence as _i3.int?),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String?),
      summary: _i3.identical(summary, _sentinel)
          ? this.summary
          : (summary as _i3.String?),
      uid: _i3.identical(uid, _sentinel) ? this.uid : (uid as _i3.String?),
    ) as $Res);
  }
}
