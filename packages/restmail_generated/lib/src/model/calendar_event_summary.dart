// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CalendarEventSummary extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CalendarEventSummary({
    required this.isCancelled,
    required this.method,
    required this.sequence,
    required this.status,
    required this.summary,
    required this.uid,
    required this.versions,
    this.messageId,
  });

  factory CalendarEventSummary.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'is_cancelled',
        r'message_id',
        r'method',
        r'sequence',
        r'status',
        r'summary',
        r'uid',
        r'versions',
      },
      listKeys: {},
      context: r'CalendarEventSummary',
    );
    return CalendarEventSummary(
      isCancelled: _$values[r'is_cancelled'].decodeSimpleBool(
        context: r'CalendarEventSummary.is_cancelled',
      ),
      messageId: _$values[r'message_id'].decodeSimpleNullableInt(
        context: r'CalendarEventSummary.message_id',
      ),
      method: _$values[r'method'].decodeSimpleString(
        context: r'CalendarEventSummary.method',
      ),
      sequence: _$values[r'sequence'].decodeSimpleInt(
        context: r'CalendarEventSummary.sequence',
      ),
      status: _$values[r'status'].decodeSimpleString(
        context: r'CalendarEventSummary.status',
      ),
      summary: _$values[r'summary'].decodeSimpleString(
        context: r'CalendarEventSummary.summary',
      ),
      uid: _$values[r'uid'].decodeSimpleString(
        context: r'CalendarEventSummary.uid',
      ),
      versions: _$values[r'versions'].decodeSimpleInt(
        context: r'CalendarEventSummary.versions',
      ),
    );
  }

  factory CalendarEventSummary.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CalendarEventSummary');
    return CalendarEventSummary(
      isCancelled: _$map[r'is_cancelled'].decodeJsonBool(
        context: r'CalendarEventSummary.is_cancelled',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableInt(
        context: r'CalendarEventSummary.message_id',
      ),
      method: _$map[r'method'].decodeJsonString(
        context: r'CalendarEventSummary.method',
      ),
      sequence: _$map[r'sequence'].decodeJsonInt(
        context: r'CalendarEventSummary.sequence',
      ),
      status: _$map[r'status'].decodeJsonString(
        context: r'CalendarEventSummary.status',
      ),
      summary: _$map[r'summary'].decodeJsonString(
        context: r'CalendarEventSummary.summary',
      ),
      uid: _$map[r'uid'].decodeJsonString(context: r'CalendarEventSummary.uid'),
      versions: _$map[r'versions'].decodeJsonInt(
        context: r'CalendarEventSummary.versions',
      ),
    );
  }

  factory CalendarEventSummary.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'is_cancelled',
        r'message_id',
        r'method',
        r'sequence',
        r'status',
        r'summary',
        r'uid',
        r'versions',
      },
      listKeys: {},
      context: r'CalendarEventSummary',
    );
    return CalendarEventSummary(
      isCancelled: _$values[r'is_cancelled'].decodeFormBool(
        context: r'CalendarEventSummary.is_cancelled',
      ),
      messageId: _$values[r'message_id'].decodeFormNullableInt(
        context: r'CalendarEventSummary.message_id',
      ),
      method: _$values[r'method'].decodeFormString(
        context: r'CalendarEventSummary.method',
      ),
      sequence: _$values[r'sequence'].decodeFormInt(
        context: r'CalendarEventSummary.sequence',
      ),
      status: _$values[r'status'].decodeFormString(
        context: r'CalendarEventSummary.status',
      ),
      summary: _$values[r'summary'].decodeFormString(
        context: r'CalendarEventSummary.summary',
      ),
      uid: _$values[r'uid'].decodeFormString(
        context: r'CalendarEventSummary.uid',
      ),
      versions: _$values[r'versions'].decodeFormInt(
        context: r'CalendarEventSummary.versions',
      ),
    );
  }

  final _i3.bool isCancelled;

  final _i3.int? messageId;

  final _i3.String method;

  final _i3.int sequence;

  final _i3.String status;

  final _i3.String summary;

  final _i3.String uid;

  final _i3.int versions;

  @_i3.override
  _i3.Object? toJson() => {
    r'is_cancelled': isCancelled,
    r'message_id': messageId,
    r'method': method,
    r'sequence': sequence,
    r'status': status,
    r'summary': summary,
    r'uid': uid,
    r'versions': versions,
  };

  $$CalendarEventSummaryCopyWith<CalendarEventSummary> get copyWith =>
      _CalendarEventSummaryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CalendarEventSummary &&
        other.isCancelled == this.isCancelled &&
        other.messageId == this.messageId &&
        other.method == this.method &&
        other.sequence == this.sequence &&
        other.status == this.status &&
        other.summary == this.summary &&
        other.uid == this.uid &&
        other.versions == this.versions;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      isCancelled,
      messageId,
      method,
      sequence,
      status,
      summary,
      uid,
      versions,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'is_cancelled'] = _i1.PropertyValue.scalar(
      isCancelled.toString(),
    );
    if (messageId != null) {
      _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId!.toString());
    }
    _$result[r'method'] = _i1.PropertyValue.scalar(method);
    _$result[r'sequence'] = _i1.PropertyValue.scalar(sequence.toString());
    _$result[r'status'] = _i1.PropertyValue.scalar(status);
    _$result[r'summary'] = _i1.PropertyValue.scalar(summary);
    _$result[r'uid'] = _i1.PropertyValue.scalar(uid);
    _$result[r'versions'] = _i1.PropertyValue.scalar(versions.toString());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CalendarEventSummary: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CalendarEventSummaryCopyWith<$Res> {
  factory $$CalendarEventSummaryCopyWith(CalendarEventSummary value) =
      _CalendarEventSummaryCopyWith<$Res>;

  $Res call({
    _i3.bool? isCancelled,
    _i3.int? messageId,
    _i3.String? method,
    _i3.int? sequence,
    _i3.String? status,
    _i3.String? summary,
    _i3.String? uid,
    _i3.int? versions,
  });
  _i3.bool get isCancelled;
  _i3.int? get messageId;
  _i3.String get method;
  _i3.int get sequence;
  _i3.String get status;
  _i3.String get summary;
  _i3.String get uid;
  _i3.int get versions;
}

class _CalendarEventSummaryCopyWith<$Res>
    implements $$CalendarEventSummaryCopyWith<$Res> {
  _CalendarEventSummaryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CalendarEventSummary _value;

  @_i3.override
  _i3.bool get isCancelled => _value.isCancelled;

  @_i3.override
  _i3.int? get messageId => _value.messageId;

  @_i3.override
  _i3.String get method => _value.method;

  @_i3.override
  _i3.int get sequence => _value.sequence;

  @_i3.override
  _i3.String get status => _value.status;

  @_i3.override
  _i3.String get summary => _value.summary;

  @_i3.override
  _i3.String get uid => _value.uid;

  @_i3.override
  _i3.int get versions => _value.versions;

  @_i3.override
  $Res call({
    _i3.Object? isCancelled = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? method = _sentinel,
    _i3.Object? sequence = _sentinel,
    _i3.Object? status = _sentinel,
    _i3.Object? summary = _sentinel,
    _i3.Object? uid = _sentinel,
    _i3.Object? versions = _sentinel,
  }) {
    return (CalendarEventSummary(
      isCancelled: _i3.identical(isCancelled, _sentinel)
          ? this.isCancelled
          : (isCancelled as _i3.bool),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.int?),
      method: _i3.identical(method, _sentinel)
          ? this.method
          : (method as _i3.String),
      sequence: _i3.identical(sequence, _sentinel)
          ? this.sequence
          : (sequence as _i3.int),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i3.String),
      summary: _i3.identical(summary, _sentinel)
          ? this.summary
          : (summary as _i3.String),
      uid: _i3.identical(uid, _sentinel) ? this.uid : (uid as _i3.String),
      versions: _i3.identical(versions, _sentinel)
          ? this.versions
          : (versions as _i3.int),
    ) as $Res);
  }
}
