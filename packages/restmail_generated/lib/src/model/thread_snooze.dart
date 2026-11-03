// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ThreadSnooze extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ThreadSnooze({required this.snoozedUntil, required this.threadId});

  factory ThreadSnooze.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'snoozed_until', r'thread_id'},
      listKeys: {},
      context: r'ThreadSnooze',
    );
    return ThreadSnooze(
      snoozedUntil: _$values[r'snoozed_until'].decodeSimpleNullableDateTime(
        context: r'ThreadSnooze.snoozed_until',
      ),
      threadId: _$values[r'thread_id'].decodeSimpleString(
        context: r'ThreadSnooze.thread_id',
      ),
    );
  }

  factory ThreadSnooze.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ThreadSnooze');
    return ThreadSnooze(
      snoozedUntil: _$map[r'snoozed_until'].decodeJsonNullableDateTime(
        context: r'ThreadSnooze.snoozed_until',
      ),
      threadId: _$map[r'thread_id'].decodeJsonString(
        context: r'ThreadSnooze.thread_id',
      ),
    );
  }

  factory ThreadSnooze.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'snoozed_until', r'thread_id'},
      listKeys: {},
      context: r'ThreadSnooze',
    );
    return ThreadSnooze(
      snoozedUntil: _$values[r'snoozed_until'].decodeFormNullableDateTime(
        context: r'ThreadSnooze.snoozed_until',
      ),
      threadId: _$values[r'thread_id'].decodeFormString(
        context: r'ThreadSnooze.thread_id',
      ),
    );
  }

  final _i3.DateTime? snoozedUntil;

  final _i3.String threadId;

  @_i3.override
  _i3.Object? toJson() => {
    r'snoozed_until': snoozedUntil?.toTimeZonedIso8601String(),
    r'thread_id': threadId,
  };

  $$ThreadSnoozeCopyWith<ThreadSnooze> get copyWith =>
      _ThreadSnoozeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ThreadSnooze &&
        other.snoozedUntil == this.snoozedUntil &&
        other.threadId == this.threadId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([snoozedUntil, threadId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (snoozedUntil != null) {
      _$result[r'snoozed_until'] = _i1.PropertyValue.scalar(
        snoozedUntil!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'thread_id'] = _i1.PropertyValue.scalar(threadId);
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
      r'Cannot uriEncode ThreadSnooze: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ThreadSnoozeCopyWith<$Res> {
  factory $$ThreadSnoozeCopyWith(ThreadSnooze value) =
      _ThreadSnoozeCopyWith<$Res>;

  $Res call({_i3.DateTime? snoozedUntil, _i3.String? threadId});
  _i3.DateTime? get snoozedUntil;
  _i3.String get threadId;
}

class _ThreadSnoozeCopyWith<$Res> implements $$ThreadSnoozeCopyWith<$Res> {
  _ThreadSnoozeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ThreadSnooze _value;

  @_i3.override
  _i3.DateTime? get snoozedUntil => _value.snoozedUntil;

  @_i3.override
  _i3.String get threadId => _value.threadId;

  @_i3.override
  $Res call({
    _i3.Object? snoozedUntil = _sentinel,
    _i3.Object? threadId = _sentinel,
  }) {
    return (ThreadSnooze(
      snoozedUntil: _i3.identical(snoozedUntil, _sentinel)
          ? this.snoozedUntil
          : (snoozedUntil as _i3.DateTime?),
      threadId: _i3.identical(threadId, _sentinel)
          ? this.threadId
          : (threadId as _i3.String),
    ) as $Res);
  }
}
