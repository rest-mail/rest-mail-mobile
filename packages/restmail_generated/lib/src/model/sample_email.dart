// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/sample_attachment.dart' as _i4;
import 'package:restmail_generated/src/model/sample_calendar_event.dart' as _i6;
import 'package:restmail_generated/src/model/sample_email_body_one_of_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/sample_email_envelope_one_of_model.dart'
    as _i7;
import 'package:restmail_generated/src/model/sample_email_headers_one_of_model.dart'
    as _i8;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SampleEmail extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SampleEmail({
    this.attachments,
    this.body,
    this.calendarEvents,
    this.envelope,
    this.headers,
    this.inline,
    this.metadata,
  });

  factory SampleEmail.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SampleEmail: contains complex types',
    );
  }

  factory SampleEmail.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SampleEmail');
    return SampleEmail(
      attachments: _$map[r'attachments']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'SampleEmail.attachments',
          )
          ?.map(_i4.SampleAttachment.fromJson)
          .toList(),
      body: _$map[r'body'] == null
          ? null
          : _i5.SampleEmailBodyOneOfModel.fromJson(_$map[r'body']),
      calendarEvents: _$map[r'calendar_events']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'SampleEmail.calendar_events',
          )
          ?.map(_i6.SampleCalendarEvent.fromJson)
          .toList(),
      envelope: _$map[r'envelope'] == null
          ? null
          : _i7.SampleEmailEnvelopeOneOfModel.fromJson(_$map[r'envelope']),
      headers: _$map[r'headers'] == null
          ? null
          : _i8.SampleEmailHeadersOneOfModel.fromJson(_$map[r'headers']),
      inline: _$map[r'inline']
          .decodeJsonNullableList<_i3.Object?>(context: r'SampleEmail.inline')
          ?.map(_i4.SampleAttachment.fromJson)
          .toList(),
      metadata: _$map[r'metadata'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'SampleEmail.metadata'),
        context: r'SampleEmail.metadata',
      ),
    );
  }

  factory SampleEmail.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SampleEmail: contains complex types',
    );
  }

  final _i3.List<_i4.SampleAttachment>? attachments;

  final _i5.SampleEmailBodyOneOfModel? body;

  final _i3.List<_i6.SampleCalendarEvent>? calendarEvents;

  final _i7.SampleEmailEnvelopeOneOfModel? envelope;

  final _i8.SampleEmailHeadersOneOfModel? headers;

  final _i3.List<_i4.SampleAttachment>? inline;

  final _i3.Map<_i3.String, _i3.String>? metadata;

  @_i3.override
  _i3.Object? toJson() => {
    r'attachments': attachments?.map((e) => e.toJson()).toList(),
    if (body != null) r'body': body?.toJson(),
    r'calendar_events': calendarEvents?.map((e) => e.toJson()).toList(),
    if (envelope != null) r'envelope': envelope?.toJson(),
    if (headers != null) r'headers': headers?.toJson(),
    r'inline': inline?.map((e) => e.toJson()).toList(),
    r'metadata': metadata,
  };

  $$SampleEmailCopyWith<SampleEmail> get copyWith => _SampleEmailCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is SampleEmail &&
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
    r'parameterProperties not supported for SampleEmail: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SampleEmail: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SampleEmailCopyWith<$Res> {
  factory $$SampleEmailCopyWith(SampleEmail value) = _SampleEmailCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.SampleAttachment>? attachments,
    _i5.SampleEmailBodyOneOfModel? body,
    _i3.List<_i6.SampleCalendarEvent>? calendarEvents,
    _i7.SampleEmailEnvelopeOneOfModel? envelope,
    _i8.SampleEmailHeadersOneOfModel? headers,
    _i3.List<_i4.SampleAttachment>? inline,
    _i3.Map<_i3.String, _i3.String>? metadata,
  });
  _i3.List<_i4.SampleAttachment>? get attachments;
  _i5.SampleEmailBodyOneOfModel? get body;
  _i3.List<_i6.SampleCalendarEvent>? get calendarEvents;
  _i7.SampleEmailEnvelopeOneOfModel? get envelope;
  _i8.SampleEmailHeadersOneOfModel? get headers;
  _i3.List<_i4.SampleAttachment>? get inline;
  _i3.Map<_i3.String, _i3.String>? get metadata;
}

class _SampleEmailCopyWith<$Res> implements $$SampleEmailCopyWith<$Res> {
  _SampleEmailCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SampleEmail _value;

  @_i3.override
  _i3.List<_i4.SampleAttachment>? get attachments => _value.attachments;

  @_i3.override
  _i5.SampleEmailBodyOneOfModel? get body => _value.body;

  @_i3.override
  _i3.List<_i6.SampleCalendarEvent>? get calendarEvents =>
      _value.calendarEvents;

  @_i3.override
  _i7.SampleEmailEnvelopeOneOfModel? get envelope => _value.envelope;

  @_i3.override
  _i8.SampleEmailHeadersOneOfModel? get headers => _value.headers;

  @_i3.override
  _i3.List<_i4.SampleAttachment>? get inline => _value.inline;

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
    return (SampleEmail(
      attachments: _i3.identical(attachments, _sentinel)
          ? this.attachments
          : (attachments as _i3.List<_i4.SampleAttachment>?),
      body: _i3.identical(body, _sentinel)
          ? this.body
          : (body as _i5.SampleEmailBodyOneOfModel?),
      calendarEvents: _i3.identical(calendarEvents, _sentinel)
          ? this.calendarEvents
          : (calendarEvents as _i3.List<_i6.SampleCalendarEvent>?),
      envelope: _i3.identical(envelope, _sentinel)
          ? this.envelope
          : (envelope as _i7.SampleEmailEnvelopeOneOfModel?),
      headers: _i3.identical(headers, _sentinel)
          ? this.headers
          : (headers as _i8.SampleEmailHeadersOneOfModel?),
      inline: _i3.identical(inline, _sentinel)
          ? this.inline
          : (inline as _i3.List<_i4.SampleAttachment>?),
      metadata: _i3.identical(metadata, _sentinel)
          ? this.metadata
          : (metadata as _i3.Map<_i3.String, _i3.String>?),
    ) as $Res);
  }
}
