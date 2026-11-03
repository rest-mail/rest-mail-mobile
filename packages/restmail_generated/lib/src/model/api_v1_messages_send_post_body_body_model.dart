// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/api_v1_messages_send_post_body_body_calendar_event_one_of_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/api_v1_messages_send_post_body_body_list_unsubscribe_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiV1MessagesSendPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ApiV1MessagesSendPostBodyBodyModel({
    required this.from,
    required this.to,
    this.bcc,
    this.bodyHtml,
    this.bodyText,
    this.calendarEvent,
    this.cc,
    this.inReplyTo,
    this.listUnsubscribe,
    this.onBehalf,
    this.requireTls,
    this.scheduledAt,
    this.subject,
  });

  factory ApiV1MessagesSendPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ApiV1MessagesSendPostBodyBodyModel: contains complex types',
    );
  }

  factory ApiV1MessagesSendPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ApiV1MessagesSendPostBodyBodyModel',
    );
    return ApiV1MessagesSendPostBodyBodyModel(
      bcc: _$map[r'bcc'].decodeJsonNullableList<_i3.String>(
        context: r'ApiV1MessagesSendPostBodyBodyModel.bcc',
      ),
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'ApiV1MessagesSendPostBodyBodyModel.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'ApiV1MessagesSendPostBodyBodyModel.body_text',
      ),
      calendarEvent: _$map[r'calendar_event'] == null
          ? null
          : _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel.fromJson(
              _$map[r'calendar_event'],
            ),
      cc: _$map[r'cc'].decodeJsonNullableList<_i3.String>(
        context: r'ApiV1MessagesSendPostBodyBodyModel.cc',
      ),
      from: _$map[r'from'].decodeJsonString(
        context: r'ApiV1MessagesSendPostBodyBodyModel.from',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'ApiV1MessagesSendPostBodyBodyModel.in_reply_to',
      ),
      listUnsubscribe: _$map[r'list_unsubscribe'] == null
          ? null
          : _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel.fromJson(
              _$map[r'list_unsubscribe'],
            ),
      onBehalf: _$map[r'on_behalf'].decodeJsonNullableBool(
        context: r'ApiV1MessagesSendPostBodyBodyModel.on_behalf',
      ),
      requireTls: _$map[r'require_tls'].decodeJsonNullableBool(
        context: r'ApiV1MessagesSendPostBodyBodyModel.require_tls',
      ),
      scheduledAt: _$map[r'scheduled_at'].decodeJsonNullableDateTime(
        context: r'ApiV1MessagesSendPostBodyBodyModel.scheduled_at',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'ApiV1MessagesSendPostBodyBodyModel.subject',
      ),
      to: _$map[r'to'].decodeJsonList<_i3.String>(
        context: r'ApiV1MessagesSendPostBodyBodyModel.to',
      ),
    );
  }

  factory ApiV1MessagesSendPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ApiV1MessagesSendPostBodyBodyModel: contains complex types',
    );
  }

  final _i3.List<_i3.String>? bcc;

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel? calendarEvent;

  final _i3.List<_i3.String>? cc;

  final _i3.String from;

  final _i3.String? inReplyTo;

  final _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel?
  listUnsubscribe;

  final _i3.bool? onBehalf;

  final _i3.bool? requireTls;

  final _i3.DateTime? scheduledAt;

  final _i3.String? subject;

  final _i3.List<_i3.String> to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bcc != null) r'bcc': bcc,
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (calendarEvent != null) r'calendar_event': calendarEvent?.toJson(),
    if (cc != null) r'cc': cc,
    r'from': from,
    if (inReplyTo != null) r'in_reply_to': inReplyTo,
    if (listUnsubscribe != null) r'list_unsubscribe': listUnsubscribe?.toJson(),
    if (onBehalf != null) r'on_behalf': onBehalf,
    if (requireTls != null) r'require_tls': requireTls,
    r'scheduled_at': scheduledAt?.toTimeZonedIso8601String(),
    if (subject != null) r'subject': subject,
    r'to': to,
  };

  $$ApiV1MessagesSendPostBodyBodyModelCopyWith<
    ApiV1MessagesSendPostBodyBodyModel
  >
  get copyWith => _ApiV1MessagesSendPostBodyBodyModelCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is ApiV1MessagesSendPostBodyBodyModel &&
        _$deepEquals.equals(other.bcc, this.bcc) &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        other.calendarEvent == this.calendarEvent &&
        _$deepEquals.equals(other.cc, this.cc) &&
        other.from == this.from &&
        other.inReplyTo == this.inReplyTo &&
        other.listUnsubscribe == this.listUnsubscribe &&
        other.onBehalf == this.onBehalf &&
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
      onBehalf,
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
    r'parameterProperties not supported for ApiV1MessagesSendPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ApiV1MessagesSendPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiV1MessagesSendPostBodyBodyModelCopyWith<$Res> {
  factory $$ApiV1MessagesSendPostBodyBodyModelCopyWith(
    ApiV1MessagesSendPostBodyBodyModel value,
  ) = _ApiV1MessagesSendPostBodyBodyModelCopyWith<$Res>;

  $Res call({
    _i3.List<_i3.String>? bcc,
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel? calendarEvent,
    _i3.List<_i3.String>? cc,
    _i3.String? from,
    _i3.String? inReplyTo,
    _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel? listUnsubscribe,
    _i3.bool? onBehalf,
    _i3.bool? requireTls,
    _i3.DateTime? scheduledAt,
    _i3.String? subject,
    _i3.List<_i3.String>? to,
  });
  _i3.List<_i3.String>? get bcc;
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel? get calendarEvent;
  _i3.List<_i3.String>? get cc;
  _i3.String get from;
  _i3.String? get inReplyTo;
  _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel?
  get listUnsubscribe;
  _i3.bool? get onBehalf;
  _i3.bool? get requireTls;
  _i3.DateTime? get scheduledAt;
  _i3.String? get subject;
  _i3.List<_i3.String> get to;
}

class _ApiV1MessagesSendPostBodyBodyModelCopyWith<$Res>
    implements $$ApiV1MessagesSendPostBodyBodyModelCopyWith<$Res> {
  _ApiV1MessagesSendPostBodyBodyModelCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiV1MessagesSendPostBodyBodyModel _value;

  @_i3.override
  _i3.List<_i3.String>? get bcc => _value.bcc;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel? get calendarEvent =>
      _value.calendarEvent;

  @_i3.override
  _i3.List<_i3.String>? get cc => _value.cc;

  @_i3.override
  _i3.String get from => _value.from;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel?
  get listUnsubscribe => _value.listUnsubscribe;

  @_i3.override
  _i3.bool? get onBehalf => _value.onBehalf;

  @_i3.override
  _i3.bool? get requireTls => _value.requireTls;

  @_i3.override
  _i3.DateTime? get scheduledAt => _value.scheduledAt;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  _i3.List<_i3.String> get to => _value.to;

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
    _i3.Object? onBehalf = _sentinel,
    _i3.Object? requireTls = _sentinel,
    _i3.Object? scheduledAt = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (ApiV1MessagesSendPostBodyBodyModel(
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
          : (calendarEvent
                as _i4.ApiV1MessagesSendPostBodyBodyCalendarEventOneOfModel?),
      cc: _i3.identical(cc, _sentinel)
          ? this.cc
          : (cc as _i3.List<_i3.String>?),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      listUnsubscribe: _i3.identical(listUnsubscribe, _sentinel)
          ? this.listUnsubscribe
          : (listUnsubscribe
                as _i5.ApiV1MessagesSendPostBodyBodyListUnsubscribeOneOfModel?),
      onBehalf: _i3.identical(onBehalf, _sentinel)
          ? this.onBehalf
          : (onBehalf as _i3.bool?),
      requireTls: _i3.identical(requireTls, _sentinel)
          ? this.requireTls
          : (requireTls as _i3.bool?),
      scheduledAt: _i3.identical(scheduledAt, _sentinel)
          ? this.scheduledAt
          : (scheduledAt as _i3.DateTime?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
      to: _i3.identical(to, _sentinel) ? this.to : (to as _i3.List<_i3.String>),
    ) as $Res);
  }
}
