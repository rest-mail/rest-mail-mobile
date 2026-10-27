// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RestmailDeliverBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RestmailDeliverBody({
    this.bodyHtml,
    this.bodyText,
    this.date,
    this.from,
    this.headers,
    this.inReplyTo,
    this.messageId,
    this.rawMessage,
    this.recipients,
    this.references,
    this.sender,
    this.subject,
    this.to,
  });

  factory RestmailDeliverBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for RestmailDeliverBody: contains complex types',
    );
  }

  factory RestmailDeliverBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RestmailDeliverBody');
    return RestmailDeliverBody(
      bodyHtml: _$map[r'body_html'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.body_html',
      ),
      bodyText: _$map[r'body_text'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.body_text',
      ),
      date: _$map[r'date'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.date',
      ),
      from: _$map[r'from'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.from',
      ),
      headers: _$map[r'headers'].decodeJsonNullableMap(
        (v) => v,
        context: r'RestmailDeliverBody.headers',
      ),
      inReplyTo: _$map[r'in_reply_to'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.in_reply_to',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.message_id',
      ),
      rawMessage: _$map[r'raw_message'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.raw_message',
      ),
      recipients: _$map[r'recipients'].decodeJsonNullableList<_i3.String>(
        context: r'RestmailDeliverBody.recipients',
      ),
      references: _$map[r'references'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.references',
      ),
      sender: _$map[r'sender'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.sender',
      ),
      subject: _$map[r'subject'].decodeJsonNullableString(
        context: r'RestmailDeliverBody.subject',
      ),
      to: _$map[r'to'].decodeJsonNullableList<_i3.String>(
        context: r'RestmailDeliverBody.to',
      ),
    );
  }

  factory RestmailDeliverBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for RestmailDeliverBody: contains complex types',
    );
  }

  final _i3.String? bodyHtml;

  final _i3.String? bodyText;

  final _i3.String? date;

  final _i3.String? from;

  final _i3.Map<_i3.String, _i3.Object?>? headers;

  final _i3.String? inReplyTo;

  final _i3.String? messageId;

  final _i3.String? rawMessage;

  final _i3.List<_i3.String>? recipients;

  final _i3.String? references;

  final _i3.String? sender;

  final _i3.String? subject;

  final _i3.List<_i3.String>? to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bodyHtml != null) r'body_html': bodyHtml,
    if (bodyText != null) r'body_text': bodyText,
    if (date != null) r'date': date,
    if (from != null) r'from': from,
    if (headers != null)
      r'headers': headers?.map(
        (k, v) => _i3.MapEntry(
          k,
          _i1.encodeUnknownJson(v, context: r'RestmailDeliverBody.headers'),
        ),
      ),
    if (inReplyTo != null) r'in_reply_to': inReplyTo,
    if (messageId != null) r'message_id': messageId,
    if (rawMessage != null) r'raw_message': rawMessage,
    r'recipients': recipients,
    if (references != null) r'references': references,
    if (sender != null) r'sender': sender,
    if (subject != null) r'subject': subject,
    r'to': to,
  };

  $$RestmailDeliverBodyCopyWith<RestmailDeliverBody> get copyWith =>
      _RestmailDeliverBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is RestmailDeliverBody &&
        other.bodyHtml == this.bodyHtml &&
        other.bodyText == this.bodyText &&
        other.date == this.date &&
        other.from == this.from &&
        _$deepEquals.equals(other.headers, this.headers) &&
        other.inReplyTo == this.inReplyTo &&
        other.messageId == this.messageId &&
        other.rawMessage == this.rawMessage &&
        _$deepEquals.equals(other.recipients, this.recipients) &&
        other.references == this.references &&
        other.sender == this.sender &&
        other.subject == this.subject &&
        _$deepEquals.equals(other.to, this.to);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      bodyHtml,
      bodyText,
      date,
      from,
      deepEquals.hash(headers),
      inReplyTo,
      messageId,
      rawMessage,
      deepEquals.hash(recipients),
      references,
      sender,
      subject,
      deepEquals.hash(to),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for RestmailDeliverBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode RestmailDeliverBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RestmailDeliverBodyCopyWith<$Res> {
  factory $$RestmailDeliverBodyCopyWith(RestmailDeliverBody value) =
      _RestmailDeliverBodyCopyWith<$Res>;

  $Res call({
    _i3.String? bodyHtml,
    _i3.String? bodyText,
    _i3.String? date,
    _i3.String? from,
    _i3.Map<_i3.String, _i3.Object?>? headers,
    _i3.String? inReplyTo,
    _i3.String? messageId,
    _i3.String? rawMessage,
    _i3.List<_i3.String>? recipients,
    _i3.String? references,
    _i3.String? sender,
    _i3.String? subject,
    _i3.List<_i3.String>? to,
  });
  _i3.String? get bodyHtml;
  _i3.String? get bodyText;
  _i3.String? get date;
  _i3.String? get from;
  _i3.Map<_i3.String, _i3.Object?>? get headers;
  _i3.String? get inReplyTo;
  _i3.String? get messageId;
  _i3.String? get rawMessage;
  _i3.List<_i3.String>? get recipients;
  _i3.String? get references;
  _i3.String? get sender;
  _i3.String? get subject;
  _i3.List<_i3.String>? get to;
}

class _RestmailDeliverBodyCopyWith<$Res>
    implements $$RestmailDeliverBodyCopyWith<$Res> {
  _RestmailDeliverBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RestmailDeliverBody _value;

  @_i3.override
  _i3.String? get bodyHtml => _value.bodyHtml;

  @_i3.override
  _i3.String? get bodyText => _value.bodyText;

  @_i3.override
  _i3.String? get date => _value.date;

  @_i3.override
  _i3.String? get from => _value.from;

  @_i3.override
  _i3.Map<_i3.String, _i3.Object?>? get headers => _value.headers;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i3.String? get messageId => _value.messageId;

  @_i3.override
  _i3.String? get rawMessage => _value.rawMessage;

  @_i3.override
  _i3.List<_i3.String>? get recipients => _value.recipients;

  @_i3.override
  _i3.String? get references => _value.references;

  @_i3.override
  _i3.String? get sender => _value.sender;

  @_i3.override
  _i3.String? get subject => _value.subject;

  @_i3.override
  _i3.List<_i3.String>? get to => _value.to;

  @_i3.override
  $Res call({
    _i3.Object? bodyHtml = _sentinel,
    _i3.Object? bodyText = _sentinel,
    _i3.Object? date = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? headers = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? rawMessage = _sentinel,
    _i3.Object? recipients = _sentinel,
    _i3.Object? references = _sentinel,
    _i3.Object? sender = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (RestmailDeliverBody(
      bodyHtml: _i3.identical(bodyHtml, _sentinel)
          ? this.bodyHtml
          : (bodyHtml as _i3.String?),
      bodyText: _i3.identical(bodyText, _sentinel)
          ? this.bodyText
          : (bodyText as _i3.String?),
      date: _i3.identical(date, _sentinel) ? this.date : (date as _i3.String?),
      from: _i3.identical(from, _sentinel) ? this.from : (from as _i3.String?),
      headers: _i3.identical(headers, _sentinel)
          ? this.headers
          : (headers as _i3.Map<_i3.String, _i3.Object?>?),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String?),
      rawMessage: _i3.identical(rawMessage, _sentinel)
          ? this.rawMessage
          : (rawMessage as _i3.String?),
      recipients: _i3.identical(recipients, _sentinel)
          ? this.recipients
          : (recipients as _i3.List<_i3.String>?),
      references: _i3.identical(references, _sentinel)
          ? this.references
          : (references as _i3.String?),
      sender: _i3.identical(sender, _sentinel)
          ? this.sender
          : (sender as _i3.String?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String?),
      to: _i3.identical(to, _sentinel)
          ? this.to
          : (to as _i3.List<_i3.String>?),
    ) as $Res);
  }
}
