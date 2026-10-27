// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/attachment.dart' as _i4;
import 'package:restmail_generated/src/model/body.dart' as _i5;
import 'package:restmail_generated/src/model/calendar_event.dart' as _i6;
import 'package:restmail_generated/src/model/envelope.dart' as _i7;
import 'package:restmail_generated/src/model/headers.dart' as _i8;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class EmailJson extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const EmailJson({
    required this.body,
    required this.envelope,
    required this.headers,
    this.attachments,
    this.calendarEvents,
    this.inline,
    this.metadata,
  });

  factory EmailJson.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for EmailJson: contains complex types',
    );
  }

  factory EmailJson.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'EmailJson');
    return EmailJson(
      attachments: _$map[r'attachments']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'EmailJson.attachments',
          )
          ?.map(_i4.Attachment.fromJson)
          .toList(),
      body: _i5.Body.fromJson(_$map[r'body']),
      calendarEvents: _$map[r'calendar_events']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'EmailJson.calendar_events',
          )
          ?.map(_i6.CalendarEvent.fromJson)
          .toList(),
      envelope: _i7.Envelope.fromJson(_$map[r'envelope']),
      headers: _i8.Headers.fromJson(_$map[r'headers']),
      inline: _$map[r'inline']
          .decodeJsonNullableList<_i3.Object?>(context: r'EmailJson.inline')
          ?.map(_i4.Attachment.fromJson)
          .toList(),
      metadata: _$map[r'metadata'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'EmailJson.metadata'),
        context: r'EmailJson.metadata',
      ),
    );
  }

  factory EmailJson.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for EmailJson: contains complex types',
    );
  }

  final _i3.List<_i4.Attachment>? attachments;

  final _i5.Body body;

  final _i3.List<_i6.CalendarEvent>? calendarEvents;

  final _i7.Envelope envelope;

  final _i8.Headers headers;

  final _i3.List<_i4.Attachment>? inline;

  final _i3.Map<_i3.String, _i3.String>? metadata;

  @_i3.override
  _i3.Object? toJson() => {
    if (attachments != null)
      r'attachments': attachments?.map((e) => e.toJson()).toList(),
    r'body': body.toJson(),
    if (calendarEvents != null)
      r'calendar_events': calendarEvents?.map((e) => e.toJson()).toList(),
    r'envelope': envelope.toJson(),
    r'headers': headers.toJson(),
    if (inline != null) r'inline': inline?.map((e) => e.toJson()).toList(),
    if (metadata != null) r'metadata': metadata,
  };

  $$EmailJsonCopyWith<EmailJson> get copyWith => _EmailJsonCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is EmailJson &&
        _$deepEquals.equals(other.attachments, this.attachments) &&
        other.body == this.body &&
        _$deepEquals.equals(other.calendarEvents, this.calendarEvents) &&
        other.envelope == this.envelope &&
        other.headers == this.headers &&
        _$deepEquals.equals(other.inline, this.inline) &&
        _$deepEquals.equals(other.metadata, this.metadata);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i9.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(attachments),
      body,
      deepEquals.hash(calendarEvents),
      envelope,
      headers,
      deepEquals.hash(inline),
      deepEquals.hash(metadata),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for EmailJson: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode EmailJson: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$EmailJsonCopyWith<$Res> {
  factory $$EmailJsonCopyWith(EmailJson value) = _EmailJsonCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.Attachment>? attachments,
    _i5.Body? body,
    _i3.List<_i6.CalendarEvent>? calendarEvents,
    _i7.Envelope? envelope,
    _i8.Headers? headers,
    _i3.List<_i4.Attachment>? inline,
    _i3.Map<_i3.String, _i3.String>? metadata,
  });
  _i3.List<_i4.Attachment>? get attachments;
  _i5.Body get body;
  _i3.List<_i6.CalendarEvent>? get calendarEvents;
  _i7.Envelope get envelope;
  _i8.Headers get headers;
  _i3.List<_i4.Attachment>? get inline;
  _i3.Map<_i3.String, _i3.String>? get metadata;
}

class _EmailJsonCopyWith<$Res> implements $$EmailJsonCopyWith<$Res> {
  _EmailJsonCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final EmailJson _value;

  @_i3.override
  _i3.List<_i4.Attachment>? get attachments => _value.attachments;

  @_i3.override
  _i5.Body get body => _value.body;

  @_i3.override
  _i3.List<_i6.CalendarEvent>? get calendarEvents => _value.calendarEvents;

  @_i3.override
  _i7.Envelope get envelope => _value.envelope;

  @_i3.override
  _i8.Headers get headers => _value.headers;

  @_i3.override
  _i3.List<_i4.Attachment>? get inline => _value.inline;

  @_i3.override
  _i3.Map<_i3.String, _i3.String>? get metadata => _value.metadata;

  @_i3.override
  $Res call({
    _i3.Object? attachments = _sentinel,
    _i3.Object? body = _sentinel,
    _i3.Object? calendarEvents = _sentinel,
    _i3.Object? envelope = _sentinel,
    _i3.Object? headers = _sentinel,
    _i3.Object? inline = _sentinel,
    _i3.Object? metadata = _sentinel,
  }) {
    return (EmailJson(
      attachments: _i3.identical(attachments, _sentinel)
          ? this.attachments
          : (attachments as _i3.List<_i4.Attachment>?),
      body: _i3.identical(body, _sentinel) ? this.body : (body as _i5.Body),
      calendarEvents: _i3.identical(calendarEvents, _sentinel)
          ? this.calendarEvents
          : (calendarEvents as _i3.List<_i6.CalendarEvent>?),
      envelope: _i3.identical(envelope, _sentinel)
          ? this.envelope
          : (envelope as _i7.Envelope),
      headers: _i3.identical(headers, _sentinel)
          ? this.headers
          : (headers as _i8.Headers),
      inline: _i3.identical(inline, _sentinel)
          ? this.inline
          : (inline as _i3.List<_i4.Attachment>?),
      metadata: _i3.identical(metadata, _sentinel)
          ? this.metadata
          : (metadata as _i3.Map<_i3.String, _i3.String>?),
    ) as $Res);
  }
}
