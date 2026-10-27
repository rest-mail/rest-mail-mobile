// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Pagination extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const Pagination({required this.hasMore, this.cursor, this.total});

  factory Pagination.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'cursor', r'has_more', r'total'},
      listKeys: {},
      context: r'Pagination',
    );
    return Pagination(
      cursor: _$values[r'cursor'].decodeSimpleNullableString(
        context: r'Pagination.cursor',
      ),
      hasMore: _$values[r'has_more'].decodeSimpleBool(
        context: r'Pagination.has_more',
      ),
      total: _$values[r'total'].decodeSimpleNullableInt(
        context: r'Pagination.total',
      ),
    );
  }

  factory Pagination.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Pagination');
    return Pagination(
      cursor: _$map[r'cursor'].decodeJsonNullableString(
        context: r'Pagination.cursor',
      ),
      hasMore: _$map[r'has_more'].decodeJsonBool(
        context: r'Pagination.has_more',
      ),
      total: _$map[r'total'].decodeJsonNullableInt(
        context: r'Pagination.total',
      ),
    );
  }

  factory Pagination.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'cursor', r'has_more', r'total'},
      listKeys: {},
      context: r'Pagination',
    );
    return Pagination(
      cursor: _$values[r'cursor'].decodeFormNullableString(
        context: r'Pagination.cursor',
      ),
      hasMore: _$values[r'has_more'].decodeFormBool(
        context: r'Pagination.has_more',
      ),
      total: _$values[r'total'].decodeFormNullableInt(
        context: r'Pagination.total',
      ),
    );
  }

  final _i3.String? cursor;

  final _i3.bool hasMore;

  final _i3.int? total;

  @_i3.override
  _i3.Object? toJson() => {
    if (cursor != null) r'cursor': cursor,
    r'has_more': hasMore,
    if (total != null) r'total': total,
  };

  $$PaginationCopyWith<Pagination> get copyWith => _PaginationCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Pagination &&
        other.cursor == this.cursor &&
        other.hasMore == this.hasMore &&
        other.total == this.total;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([cursor, hasMore, total]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (cursor != null) {
      _$result[r'cursor'] = _i1.PropertyValue.scalar(cursor!);
    }
    _$result[r'has_more'] = _i1.PropertyValue.scalar(hasMore.toString());
    if (total != null) {
      _$result[r'total'] = _i1.PropertyValue.scalar(total!.toString());
    }
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
      r'Cannot uriEncode Pagination: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$PaginationCopyWith<$Res> {
  factory $$PaginationCopyWith(Pagination value) = _PaginationCopyWith<$Res>;

  $Res call({_i3.String? cursor, _i3.bool? hasMore, _i3.int? total});
  _i3.String? get cursor;
  _i3.bool get hasMore;
  _i3.int? get total;
}

class _PaginationCopyWith<$Res> implements $$PaginationCopyWith<$Res> {
  _PaginationCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Pagination _value;

  @_i3.override
  _i3.String? get cursor => _value.cursor;

  @_i3.override
  _i3.bool get hasMore => _value.hasMore;

  @_i3.override
  _i3.int? get total => _value.total;

  @_i3.override
  $Res call({
    _i3.Object? cursor = _sentinel,
    _i3.Object? hasMore = _sentinel,
    _i3.Object? total = _sentinel,
  }) {
    return (Pagination(
      cursor: _i3.identical(cursor, _sentinel)
          ? this.cursor
          : (cursor as _i3.String?),
      hasMore: _i3.identical(hasMore, _sentinel)
          ? this.hasMore
          : (hasMore as _i3.bool),
      total: _i3.identical(total, _sentinel) ? this.total : (total as _i3.int?),
    ) as $Res);
  }
}
