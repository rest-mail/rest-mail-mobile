// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/queue_entry.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class QueueList extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const QueueList({
    required this.items,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory QueueList.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for QueueList: contains complex types',
    );
  }

  factory QueueList.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'QueueList');
    return QueueList(
      items: _$map[r'items']
          .decodeJsonList<_i3.Object?>(context: r'QueueList.items')
          .map(_i4.QueueEntry.fromJson)
          .toList(),
      limit: _$map[r'limit'].decodeJsonInt(context: r'QueueList.limit'),
      offset: _$map[r'offset'].decodeJsonInt(context: r'QueueList.offset'),
      total: _$map[r'total'].decodeJsonInt(context: r'QueueList.total'),
    );
  }

  factory QueueList.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for QueueList: contains complex types',
    );
  }

  final _i3.List<_i4.QueueEntry> items;

  final _i3.int limit;

  final _i3.int offset;

  final _i3.int total;

  @_i3.override
  _i3.Object? toJson() => {
    r'items': items.map((e) => e.toJson()).toList(),
    r'limit': limit,
    r'offset': offset,
    r'total': total,
  };

  $$QueueListCopyWith<QueueList> get copyWith => _QueueListCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is QueueList &&
        _$deepEquals.equals(other.items, this.items) &&
        other.limit == this.limit &&
        other.offset == this.offset &&
        other.total == this.total;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(items), limit, offset, total]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for QueueList: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode QueueList: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$QueueListCopyWith<$Res> {
  factory $$QueueListCopyWith(QueueList value) = _QueueListCopyWith<$Res>;

  $Res call({
    _i3.List<_i4.QueueEntry>? items,
    _i3.int? limit,
    _i3.int? offset,
    _i3.int? total,
  });
  _i3.List<_i4.QueueEntry> get items;
  _i3.int get limit;
  _i3.int get offset;
  _i3.int get total;
}

class _QueueListCopyWith<$Res> implements $$QueueListCopyWith<$Res> {
  _QueueListCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final QueueList _value;

  @_i3.override
  _i3.List<_i4.QueueEntry> get items => _value.items;

  @_i3.override
  _i3.int get limit => _value.limit;

  @_i3.override
  _i3.int get offset => _value.offset;

  @_i3.override
  _i3.int get total => _value.total;

  @_i3.override
  $Res call({
    _i3.Object? items = _sentinel,
    _i3.Object? limit = _sentinel,
    _i3.Object? offset = _sentinel,
    _i3.Object? total = _sentinel,
  }) {
    return (QueueList(
      items: _i3.identical(items, _sentinel)
          ? this.items
          : (items as _i3.List<_i4.QueueEntry>),
      limit: _i3.identical(limit, _sentinel) ? this.limit : (limit as _i3.int),
      offset: _i3.identical(offset, _sentinel)
          ? this.offset
          : (offset as _i3.int),
      total: _i3.identical(total, _sentinel) ? this.total : (total as _i3.int),
    ) as $Res);
  }
}
