// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/address.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Headers extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Headers({
    required this.date,
    required this.from,
    required this.messageId,
    required this.subject,
    required this.to,
    this.bcc,
    this.cc,
    this.extra,
    this.inReplyTo,
    this.raw,
    this.references,
  });

  factory Headers.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Headers: contains complex types',
    );
  }

  factory Headers.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Headers');
    return Headers(
      bcc: _$map[r'bcc']
          .decodeJsonNullableList<_i3.Object?>(context: r'Headers.bcc')
          ?.map(_i4.Address.fromJson)
          .toList(),
      cc: _$map[r'cc']
          .decodeJsonNullableList<_i3.Object?>(context: r'Headers.cc')
          ?.map(_i4.Address.fromJson)
          .toList(),
      date: _$map[r'date'].decodeJsonString(context: r'Headers.date'),
      extra: _$map[r'extra'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'Headers.extra'),
        context: r'Headers.extra',
      ),
      from: _$map[r'from']
          .decodeJsonList<_i3.Object?>(context: r'Headers.from')
          .map(_i4.Address.fromJson)
          .toList(),
      inReplyTo: _$map[r'in-reply-to'].decodeJsonNullableString(
        context: r'Headers.in-reply-to',
      ),
      messageId: _$map[r'message-id'].decodeJsonString(
        context: r'Headers.message-id',
      ),
      raw: _$map[r'raw'].decodeJsonNullableMap(
        (v) => v.decodeJsonList<_i3.String>(context: r'Headers.raw'),
        context: r'Headers.raw',
      ),
      references: _$map[r'references'].decodeJsonNullableList<_i3.String>(
        context: r'Headers.references',
      ),
      subject: _$map[r'subject'].decodeJsonString(context: r'Headers.subject'),
      to: _$map[r'to']
          .decodeJsonList<_i3.Object?>(context: r'Headers.to')
          .map(_i4.Address.fromJson)
          .toList(),
    );
  }

  factory Headers.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Headers: contains complex types',
    );
  }

  final _i3.List<_i4.Address>? bcc;

  final _i3.List<_i4.Address>? cc;

  final _i3.String date;

  final _i3.Map<_i3.String, _i3.String>? extra;

  final _i3.List<_i4.Address> from;

  final _i3.String? inReplyTo;

  final _i3.String messageId;

  final _i3.Map<_i3.String, _i3.List<_i3.String>>? raw;

  final _i3.List<_i3.String>? references;

  final _i3.String subject;

  final _i3.List<_i4.Address> to;

  @_i3.override
  _i3.Object? toJson() => {
    if (bcc != null) r'bcc': bcc?.map((e) => e.toJson()).toList(),
    if (cc != null) r'cc': cc?.map((e) => e.toJson()).toList(),
    r'date': date,
    if (extra != null) r'extra': extra,
    r'from': from.map((e) => e.toJson()).toList(),
    if (inReplyTo != null) r'in-reply-to': inReplyTo,
    r'message-id': messageId,
    if (raw != null) r'raw': raw,
    if (references != null) r'references': references,
    r'subject': subject,
    r'to': to.map((e) => e.toJson()).toList(),
  };

  $$HeadersCopyWith<Headers> get copyWith => _HeadersCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is Headers &&
        _$deepEquals.equals(other.bcc, this.bcc) &&
        _$deepEquals.equals(other.cc, this.cc) &&
        other.date == this.date &&
        _$deepEquals.equals(other.extra, this.extra) &&
        _$deepEquals.equals(other.from, this.from) &&
        other.inReplyTo == this.inReplyTo &&
        other.messageId == this.messageId &&
        _$deepEquals.equals(other.raw, this.raw) &&
        _$deepEquals.equals(other.references, this.references) &&
        other.subject == this.subject &&
        _$deepEquals.equals(other.to, this.to);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(bcc),
      deepEquals.hash(cc),
      date,
      deepEquals.hash(extra),
      deepEquals.hash(from),
      inReplyTo,
      messageId,
      deepEquals.hash(raw),
      deepEquals.hash(references),
      subject,
      deepEquals.hash(to),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Headers: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Headers: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$HeadersCopyWith<$Res> {
  factory $$HeadersCopyWith(Headers value) = _HeadersCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.Address>? bcc,
    _i3.List<_i4.Address>? cc,
    _i3.String? date,
    _i3.Map<_i3.String, _i3.String>? extra,
    _i3.List<_i4.Address>? from,
    _i3.String? inReplyTo,
    _i3.String? messageId,
    _i3.Map<_i3.String, _i3.List<_i3.String>>? raw,
    _i3.List<_i3.String>? references,
    _i3.String? subject,
    _i3.List<_i4.Address>? to,
  });
  _i3.List<_i4.Address>? get bcc;
  _i3.List<_i4.Address>? get cc;
  _i3.String get date;
  _i3.Map<_i3.String, _i3.String>? get extra;
  _i3.List<_i4.Address> get from;
  _i3.String? get inReplyTo;
  _i3.String get messageId;
  _i3.Map<_i3.String, _i3.List<_i3.String>>? get raw;
  _i3.List<_i3.String>? get references;
  _i3.String get subject;
  _i3.List<_i4.Address> get to;
}

class _HeadersCopyWith<$Res> implements $$HeadersCopyWith<$Res> {
  _HeadersCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Headers _value;

  @_i3.override
  _i3.List<_i4.Address>? get bcc => _value.bcc;

  @_i3.override
  _i3.List<_i4.Address>? get cc => _value.cc;

  @_i3.override
  _i3.String get date => _value.date;

  @_i3.override
  _i3.Map<_i3.String, _i3.String>? get extra => _value.extra;

  @_i3.override
  _i3.List<_i4.Address> get from => _value.from;

  @_i3.override
  _i3.String? get inReplyTo => _value.inReplyTo;

  @_i3.override
  _i3.String get messageId => _value.messageId;

  @_i3.override
  _i3.Map<_i3.String, _i3.List<_i3.String>>? get raw => _value.raw;

  @_i3.override
  _i3.List<_i3.String>? get references => _value.references;

  @_i3.override
  _i3.String get subject => _value.subject;

  @_i3.override
  _i3.List<_i4.Address> get to => _value.to;

  @_i3.override
  $Res call({
    _i3.Object? bcc = _sentinel,
    _i3.Object? cc = _sentinel,
    _i3.Object? date = _sentinel,
    _i3.Object? extra = _sentinel,
    _i3.Object? from = _sentinel,
    _i3.Object? inReplyTo = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? raw = _sentinel,
    _i3.Object? references = _sentinel,
    _i3.Object? subject = _sentinel,
    _i3.Object? to = _sentinel,
  }) {
    return (Headers(
      bcc: _i3.identical(bcc, _sentinel)
          ? this.bcc
          : (bcc as _i3.List<_i4.Address>?),
      cc: _i3.identical(cc, _sentinel)
          ? this.cc
          : (cc as _i3.List<_i4.Address>?),
      date: _i3.identical(date, _sentinel) ? this.date : (date as _i3.String),
      extra: _i3.identical(extra, _sentinel)
          ? this.extra
          : (extra as _i3.Map<_i3.String, _i3.String>?),
      from: _i3.identical(from, _sentinel)
          ? this.from
          : (from as _i3.List<_i4.Address>),
      inReplyTo: _i3.identical(inReplyTo, _sentinel)
          ? this.inReplyTo
          : (inReplyTo as _i3.String?),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.String),
      raw: _i3.identical(raw, _sentinel)
          ? this.raw
          : (raw as _i3.Map<_i3.String, _i3.List<_i3.String>>?),
      references: _i3.identical(references, _sentinel)
          ? this.references
          : (references as _i3.List<_i3.String>?),
      subject: _i3.identical(subject, _sentinel)
          ? this.subject
          : (subject as _i3.String),
      to: _i3.identical(to, _sentinel)
          ? this.to
          : (to as _i3.List<_i4.Address>),
    ) as $Res);
  }
}
