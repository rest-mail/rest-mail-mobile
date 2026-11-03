// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/thread_due_due_source_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ThreadDue extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ThreadDue({
    required this.due,
    required this.dueSource,
    required this.threadId,
  });

  factory ThreadDue.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'due', r'due_source', r'thread_id'},
      listKeys: {},
      context: r'ThreadDue',
    );
    return ThreadDue(
      due: _$values[r'due'].decodeSimpleNullableDateTime(
        context: r'ThreadDue.due',
      ),
      dueSource: _$values[r'due_source'] == null
          ? null
          : _i4.ThreadDueDueSourceModel.fromSimple(
              _$values[r'due_source'],
              explode: explode,
            ),
      threadId: _$values[r'thread_id'].decodeSimpleString(
        context: r'ThreadDue.thread_id',
      ),
    );
  }

  factory ThreadDue.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ThreadDue');
    return ThreadDue(
      due: _$map[r'due'].decodeJsonNullableDateTime(context: r'ThreadDue.due'),
      dueSource: _$map[r'due_source'] == null
          ? null
          : _i4.ThreadDueDueSourceModel.fromJson(_$map[r'due_source']),
      threadId: _$map[r'thread_id'].decodeJsonString(
        context: r'ThreadDue.thread_id',
      ),
    );
  }

  factory ThreadDue.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'due', r'due_source', r'thread_id'},
      listKeys: {},
      context: r'ThreadDue',
    );
    return ThreadDue(
      due: _$values[r'due'].decodeFormNullableDateTime(
        context: r'ThreadDue.due',
      ),
      dueSource: _$values[r'due_source'] == null
          ? null
          : _i4.ThreadDueDueSourceModel.fromForm(
              _$values[r'due_source'],
              explode: explode,
            ),
      threadId: _$values[r'thread_id'].decodeFormString(
        context: r'ThreadDue.thread_id',
      ),
    );
  }

  final _i3.DateTime? due;

  final _i4.ThreadDueDueSourceModel? dueSource;

  final _i3.String threadId;

  @_i3.override
  _i3.Object? toJson() => {
    r'due': due?.toTimeZonedIso8601String(),
    r'due_source': dueSource?.toJson(),
    r'thread_id': threadId,
  };

  $$ThreadDueCopyWith<ThreadDue> get copyWith => _ThreadDueCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ThreadDue &&
        other.due == this.due &&
        other.dueSource == this.dueSource &&
        other.threadId == this.threadId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([due, dueSource, threadId]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (due != null) {
      _$result[r'due'] = _i1.PropertyValue.scalar(
        due!.toTimeZonedIso8601String(),
      );
    }
    if (dueSource != null) {
      _$result[r'due_source'] = _i1.PropertyValue.scalar(dueSource!.toJson());
    }
    _$result[r'thread_id'] = _i1.PropertyValue.scalar(threadId);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ThreadDue: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ThreadDueCopyWith<$Res> {
  factory $$ThreadDueCopyWith(ThreadDue value) = _ThreadDueCopyWith<$Res>;

  $Res call({
    _i3.DateTime? due,
    _i4.ThreadDueDueSourceModel? dueSource,
    _i3.String? threadId,
  });
  _i3.DateTime? get due;
  _i4.ThreadDueDueSourceModel? get dueSource;
  _i3.String get threadId;
}

class _ThreadDueCopyWith<$Res> implements $$ThreadDueCopyWith<$Res> {
  _ThreadDueCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ThreadDue _value;

  @_i3.override
  _i3.DateTime? get due => _value.due;

  @_i3.override
  _i4.ThreadDueDueSourceModel? get dueSource => _value.dueSource;

  @_i3.override
  _i3.String get threadId => _value.threadId;

  @_i3.override
  $Res call({
    _i3.Object? due = _sentinel,
    _i3.Object? dueSource = _sentinel,
    _i3.Object? threadId = _sentinel,
  }) {
    return (ThreadDue(
      due: _i3.identical(due, _sentinel) ? this.due : (due as _i3.DateTime?),
      dueSource: _i3.identical(dueSource, _sentinel)
          ? this.dueSource
          : (dueSource as _i4.ThreadDueDueSourceModel?),
      threadId: _i3.identical(threadId, _sentinel)
          ? this.threadId
          : (threadId as _i3.String),
    ) as $Res);
  }
}
