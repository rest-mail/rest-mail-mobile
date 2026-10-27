// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/grant_response.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DataGrantResponseList extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DataGrantResponseList({required this.data});

  factory DataGrantResponseList.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DataGrantResponseList: contains complex types',
    );
  }

  factory DataGrantResponseList.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DataGrantResponseList');
    return DataGrantResponseList(
      data: _$map[r'data']
          .decodeJsonList<_i3.Object?>(context: r'DataGrantResponseList.data')
          .map(_i4.GrantResponse.fromJson)
          .toList(),
    );
  }

  factory DataGrantResponseList.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DataGrantResponseList: contains complex types',
    );
  }

  final _i3.List<_i4.GrantResponse> data;

  @_i3.override
  _i3.Object? toJson() => {r'data': data.map((e) => e.toJson()).toList()};

  $$DataGrantResponseListCopyWith<DataGrantResponseList> get copyWith =>
      _DataGrantResponseListCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is DataGrantResponseList &&
        _$deepEquals.equals(other.data, this.data);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(data);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DataGrantResponseList: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DataGrantResponseList: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DataGrantResponseListCopyWith<$Res> {
  factory $$DataGrantResponseListCopyWith(DataGrantResponseList value) =
      _DataGrantResponseListCopyWith<$Res>;

  $Res call({_i3.List<_i4.GrantResponse>? data});
  _i3.List<_i4.GrantResponse> get data;
}

class _DataGrantResponseListCopyWith<$Res>
    implements $$DataGrantResponseListCopyWith<$Res> {
  _DataGrantResponseListCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DataGrantResponseList _value;

  @_i3.override
  _i3.List<_i4.GrantResponse> get data => _value.data;

  @_i3.override
  $Res call({_i3.Object? data = _sentinel}) {
    return (DataGrantResponseList(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i3.List<_i4.GrantResponse>),
    ) as $Res);
  }
}
