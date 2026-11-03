// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/message.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AwaitingThread extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AwaitingThread({
    required this.awaitingSince,
    required this.lastMessage,
    required this.threadId,
  });

  factory AwaitingThread.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for AwaitingThread: contains complex types',
    );
  }

  factory AwaitingThread.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AwaitingThread');
    return AwaitingThread(
      awaitingSince: _$map[r'awaiting_since'].decodeJsonDateTime(
        context: r'AwaitingThread.awaiting_since',
      ),
      lastMessage: _i4.Message.fromJson(_$map[r'last_message']),
      threadId: _$map[r'thread_id'].decodeJsonString(
        context: r'AwaitingThread.thread_id',
      ),
    );
  }

  factory AwaitingThread.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for AwaitingThread: contains complex types',
    );
  }

  final _i3.DateTime awaitingSince;

  final _i4.Message lastMessage;

  final _i3.String threadId;

  @_i3.override
  _i3.Object? toJson() => {
    r'awaiting_since': awaitingSince.toTimeZonedIso8601String(),
    r'last_message': lastMessage.toJson(),
    r'thread_id': threadId,
  };

  $$AwaitingThreadCopyWith<AwaitingThread> get copyWith =>
      _AwaitingThreadCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AwaitingThread &&
        other.awaitingSince == this.awaitingSince &&
        other.lastMessage == this.lastMessage &&
        other.threadId == this.threadId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([awaitingSince, lastMessage, threadId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for AwaitingThread: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode AwaitingThread: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AwaitingThreadCopyWith<$Res> {
  factory $$AwaitingThreadCopyWith(AwaitingThread value) =
      _AwaitingThreadCopyWith<$Res>;

  $Res call({
    _i3.DateTime? awaitingSince,
    _i4.Message? lastMessage,
    _i3.String? threadId,
  });
  _i3.DateTime get awaitingSince;
  _i4.Message get lastMessage;
  _i3.String get threadId;
}

class _AwaitingThreadCopyWith<$Res> implements $$AwaitingThreadCopyWith<$Res> {
  _AwaitingThreadCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AwaitingThread _value;

  @_i3.override
  _i3.DateTime get awaitingSince => _value.awaitingSince;

  @_i3.override
  _i4.Message get lastMessage => _value.lastMessage;

  @_i3.override
  _i3.String get threadId => _value.threadId;

  @_i3.override
  $Res call({
    _i3.Object? awaitingSince = _sentinel,
    _i3.Object? lastMessage = _sentinel,
    _i3.Object? threadId = _sentinel,
  }) {
    return (AwaitingThread(
      awaitingSince: _i3.identical(awaitingSince, _sentinel)
          ? this.awaitingSince
          : (awaitingSince as _i3.DateTime),
      lastMessage: _i3.identical(lastMessage, _sentinel)
          ? this.lastMessage
          : (lastMessage as _i4.Message),
      threadId: _i3.identical(threadId, _sentinel)
          ? this.threadId
          : (threadId as _i3.String),
    ) as $Res);
  }
}
