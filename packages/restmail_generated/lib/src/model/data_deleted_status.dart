// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/deleted_status.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DataDeletedStatus extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DataDeletedStatus({required this.data});

  factory DataDeletedStatus.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DataDeletedStatus: contains complex types',
    );
  }

  factory DataDeletedStatus.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DataDeletedStatus');
    return DataDeletedStatus(data: _i4.DeletedStatus.fromJson(_$map[r'data']));
  }

  factory DataDeletedStatus.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DataDeletedStatus: contains complex types',
    );
  }

  final _i4.DeletedStatus data;

  @_i3.override
  _i3.Object? toJson() => {r'data': data.toJson()};

  $$DataDeletedStatusCopyWith<DataDeletedStatus> get copyWith =>
      _DataDeletedStatusCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DataDeletedStatus && other.data == this.data;
  }

  @_i3.override
  _i3.int get hashCode => data.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DataDeletedStatus: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DataDeletedStatus: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DataDeletedStatusCopyWith<$Res> {
  factory $$DataDeletedStatusCopyWith(DataDeletedStatus value) =
      _DataDeletedStatusCopyWith<$Res>;

  $Res call({_i4.DeletedStatus? data});
  _i4.DeletedStatus get data;
}

class _DataDeletedStatusCopyWith<$Res>
    implements $$DataDeletedStatusCopyWith<$Res> {
  _DataDeletedStatusCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DataDeletedStatus _value;

  @_i3.override
  _i4.DeletedStatus get data => _value.data;

  @_i3.override
  $Res call({_i3.Object? data = _sentinel}) {
    return (DataDeletedStatus(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i4.DeletedStatus),
    ) as $Res);
  }
}
