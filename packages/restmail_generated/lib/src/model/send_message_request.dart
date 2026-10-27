// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/send_message_request_calendar_event_one_of_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/send_message_request_list_unsubscribe_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SendMessageRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SendMessageRequest({
    this.bcc,
    this.bodyHtml,
    this.bodyText,
    this.calendarEvent,
    this.cc,
    this.from,
    this.inReplyTo,
    this.listUnsubscribe,
    this.requireTls,
    this.scheduledAt,
    this.subject,
    this.to,
  });

  factory SendMessageRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SendMessageRequest: contains complex types',
    );
  }

  factory SendMessageRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SendMessageRequest');
    return SendMessageRequest(
      bcc: _$map[r'bcc'].decodeJsonNullableList<_i3.String>(
        context: r'SendMessageRequest.bcc',
      ),
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'SendMessageRequest.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'SendMessageRequest.body_text',
      ),
      calendarEvent: _$map[r'calendar_event'] == null
          ? null
          : _i4.SendMessageRequestCalendarEventOneOfModel.fromJson(
              _$map[r'calendar_event'],
            ),
      cc: _$map[r'cc'].decodeJsonNullableList<_i3.String>(
        context: r'SendMessageRequest.cc',
      ),
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'SendMessageRequest.from',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'SendMessageRequest.in_reply_to',
      ),
      listUnsubscribe: _$map[r'list_unsubscribe'] == null
          ? null
          : _i5.SendMessageRequestListUnsubscribeOneOfModel.fromJson(
              _$map[r'list_unsubscribe'],
            ),
      requireTls: _$map[r'require_tls'].decodeJsonNullableBool(
        context: r'SendMessageRequest.require_tls',
      ),
      scheduledAt: _$map[r'scheduled_at'].decodeJsonNullableDateTime(
        context: r'SendMessageRequest.scheduled_at',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'SendMessageRequest.subject',
      ),
      to: _$map[r'to'].decodeJsonNullableList<_i3.String>(
        context: r'SendMessageRequest.to',
      ),
    );
  }

  factory SendMessageRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SendMessageRequest: contains complex types',
    );
  }

  final _i3.List<_i3.String>? bcc;

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i4.SendMessageRequestCalendarEventOneOfModel? calendarEvent;

  final _i3.List<_i3.String>? cc;

  final _i3.String? from;

  final _i3.String? inReplyTo;

  final _i5.SendMessageRequestListUnsubscribeOneOfModel? listUnsubscribe;

  final _i3.bool? requireTls;

  final _i3.DateTime? scheduledAt;

  final _i3.String? subject;

  final _i3.List<_i3.String>? to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bcc != null) r'bcc': bcc,
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (calendarEvent != null) r'calendar_event': calendarEvent?.toJson(),
    if (cc != null) r'cc': cc,
    if (from != null) r'from': from,
    if (inReplyTo != null) r'in_reply_to': inReplyTo,
    if (listUnsubscribe != null) r'list_unsubscribe': listUnsubscribe?.toJson(),
    if (requireTls != null) r'require_tls': requireTls,
    r'scheduled_at': scheduledAt?.toTimeZonedIso8601String(),
    if (subject != null) r'subject': subject,
    if (to != null) r'to': to,
  };

  $$SendMessageRequestCopyWith<SendMessageRequest> get copyWith =>
      _SendMessageRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is SendMessageRequest &&
        _$deepEquals.equals(other.bcc, this.bcc) &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        other.calendarEvent == this.calendarEvent &&
        _$deepEquals.equals(other.cc, this.cc) &&
        other.from == this.from &&
        other.inReplyTo == this.inReplyTo &&
        other.listUnsubscribe == this.listUnsubscribe &&
        other.requireTls == this.requireTls &&
        other.scheduledAt == this.scheduledAt &&
        other.subject == this.subject &&
        _$deepEquals.equals(other.to, this.to);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(bcc),
      bodyHtml,
      bodyText,
      calendarEvent,
      deepEquals.hash(cc),
      from,
      inReplyTo,
      listUnsubscribe,
      requireTls,
      scheduledAt,
      subject,
      deepEquals.hash(to),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SendMessageRequest: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SendMessageRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SendMessageRequestCopyWith<$Res> {
  factory $$SendMessageRequestCopyWith(SendMessageRequest value) =
      _SendMessageRequestCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? bcc,
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i4.SendMessageRequestCalendarEventOneOfModel? calendarEvent,
    _i3.List<_i3.String>? cc,
    _i3.String? from,
    _i3.String? inReplyTo,
    _i5.SendMessageRequestListUnsubscribeOneOfModel? listUnsubscribe,
    _i3.bool? requireTls,
    _i3.DateTime? scheduledAt,
    _i3.String? subject,
    _i3.List<_i3.String>? to,
  });
  _i3.List<_i3.String>? get bcc;
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i4.SendMessageRequestCalendarEventOneOfModel? get calendarEvent;
  _i3.List<_i3.String>? get cc;
  _i3.String? get from;
  _i3.String? get inReplyTo;
  _i5.SendMessageRequestListUnsubscribeOneOfModel? get listUnsubscribe;
  _i3.bool? get requireTls;
  _i3.DateTime? get scheduledAt;
  _i3.String? get subject;
  _i3.List<_i3.String>? get to;
}

class _SendMessageRequestCopyWith<$Res>
    implements $$SendMessageRequestCopyWith<$Res> {
  _SendMessageRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SendMessageRequest _value;

  @_i3.override
  _i3.List<_i3.String>? get bcc => _value.bcc;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i4.SendMessageRequestCalendarEventOneOfModel? get calendarEvent =>
      _value.calendarEvent;

  @_i3.override
  _i3.List<_i3.String>? get cc => _value.cc;

  @_i3.override
  _i3.String? get from => _value.from;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i5.SendMessageRequestListUnsubscribeOneOfModel? get listUnsubscribe =>
      _value.listUnsubscribe;

  @_i3.override
  _i3.bool? get requireTls => _value.requireTls;

  @_i3.override
  _i3.DateTime? get scheduledAt => _value.scheduledAt;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  _i3.List<_i3.String>? get to => _value.to;

  @_i3.override
  $Res call({
    _i3.Object? bcc = _sentinel,
    _i3.Object? bodyHtml = _sentinel,
    _i3.Object? bodyText = _sentinel,
    _i3.Object? calendarEvent = _sentinel,
    _i3.Object? cc = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? listUnsubscribe = _sentinel,
    _i3.Object? requireTls = _sentinel,
    _i3.Object? scheduledAt = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (SendMessageRequest(
      bcc: _i3.identical(bcc, _sentinel)
          ? this.bcc
          : (bcc as _i3.List<_i3.String>?),
      bodyHtml: _i3.identical(bodyHtml, _sentinel)
          ? this.bodyHtml
          : (bodyHtml as _i3.String?),
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      calendarEvent: _i3.identical(calendarEvent, _sentinel)
          ? this.calendarEvent
          : (calendarEvent as _i4.SendMessageRequestCalendarEventOneOfModel?),
      cc: _i3.identical(cc, _sentinel)
          ? this.cc
          : (cc as _i3.List<_i3.String>?),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String?),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      listUnsubscribe: _i3.identical(listUnsubscribe, _sentinel)
          ? this.listUnsubscribe
          : (listUnsubscribe
                as _i5.SendMessageRequestListUnsubscribeOneOfModel?),
      requireTls: _i3.identical(requireTls, _sentinel)
          ? this.requireTls
          : (requireTls as _i3.bool?),
      scheduledAt: _i3.identical(scheduledAt, _sentinel)
          ? this.scheduledAt
          : (scheduledAt as _i3.DateTime?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
      to: _i3.identical(to, _sentinel)
          ? this.to
          : (to as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
