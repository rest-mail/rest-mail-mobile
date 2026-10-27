// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FolderSummary extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FolderSummary({
    required this.name,
    required this.total,
    required this.unread,
  });

  factory FolderSummary.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'name', r'total', r'unread'},
      listKeys: {},
      context: r'FolderSummary',
    );
    return FolderSummary(
      name: _$values[r'name'].decodeSimpleString(
        context: r'FolderSummary.name',
      ),
      total: _$values[r'total'].decodeSimpleInt(
        context: r'FolderSummary.total',
      ),
      unread: _$values[r'unread'].decodeSimpleInt(
        context: r'FolderSummary.unread',
      ),
    );
  }

  factory FolderSummary.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FolderSummary');
    return FolderSummary(
      name: _$map[r'name'].decodeJsonString(context: r'FolderSummary.name'),
      total: _$map[r'total'].decodeJsonInt(context: r'FolderSummary.total'),
      unread: _$map[r'unread'].decodeJsonInt(context: r'FolderSummary.unread'),
    );
  }

  factory FolderSummary.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'name', r'total', r'unread'},
      listKeys: {},
      context: r'FolderSummary',
    );
    return FolderSummary(
      name: _$values[r'name'].decodeFormString(context: r'FolderSummary.name'),
      total: _$values[r'total'].decodeFormInt(context: r'FolderSummary.total'),
      unread: _$values[r'unread'].decodeFormInt(
        context: r'FolderSummary.unread',
      ),
    );
  }

  final _i3.String name;

  final _i3.int total;

  final _i3.int unread;

  @_i3.override
  _i3.Object? toJson() => {r'name': name, r'total': total, r'unread': unread};

  $$FolderSummaryCopyWith<FolderSummary> get copyWith =>
      _FolderSummaryCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FolderSummary &&
        other.name == this.name &&
        other.total == this.total &&
        other.unread == this.unread;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([name, total, unread]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    _$result[r'total'] = _i1.PropertyValue.scalar(total.toString());
    _$result[r'unread'] = _i1.PropertyValue.scalar(unread.toString());
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
      r'Cannot uriEncode FolderSummary: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$FolderSummaryCopyWith<$Res> {
  factory $$FolderSummaryCopyWith(FolderSummary value) =
      _FolderSummaryCopyWith<$Res>;

  $Res call({_i3.String? name, _i3.int? total, _i3.int? unread});
  _i3.String get name;
  _i3.int get total;
  _i3.int get unread;
}

class _FolderSummaryCopyWith<$Res> implements $$FolderSummaryCopyWith<$Res> {
  _FolderSummaryCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final FolderSummary _value;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i3.int get total => _value.total;

  @_i3.override
  _i3.int get unread => _value.unread;

  @_i3.override
  $Res call({
    _i3.Object? name = _sentinel,
    _i3.Object? total = _sentinel,
    _i3.Object? unread = _sentinel,
  }) {
    return (FolderSummary(
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      total: _i3.identical(total, _sentinel) ? this.total : (total as _i3.int),
      unread: _i3.identical(unread, _sentinel)
          ? this.unread
          : (unread as _i3.int),
    ) as $Res);
  }
}
