// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/quarantine_deleted.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DataQuarantineDeleted extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DataQuarantineDeleted({required this.data});

  factory DataQuarantineDeleted.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DataQuarantineDeleted: contains complex types',
    );
  }

  factory DataQuarantineDeleted.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DataQuarantineDeleted');
    return DataQuarantineDeleted(
      data: _i4.QuarantineDeleted.fromJson(_$map[r'data']),
    );
  }

  factory DataQuarantineDeleted.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DataQuarantineDeleted: contains complex types',
    );
  }

  final _i4.QuarantineDeleted data;

  @_i3.override
  _i3.Object? toJson() => {r'data': data.toJson()};

  $$DataQuarantineDeletedCopyWith<DataQuarantineDeleted> get copyWith =>
      _DataQuarantineDeletedCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DataQuarantineDeleted && other.data == this.data;
  }

  @_i3.override
  _i3.int get hashCode => data.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DataQuarantineDeleted: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DataQuarantineDeleted: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DataQuarantineDeletedCopyWith<$Res> {
  factory $$DataQuarantineDeletedCopyWith(DataQuarantineDeleted value) =
      _DataQuarantineDeletedCopyWith<$Res>;

  $Res call({_i4.QuarantineDeleted? data});
  _i4.QuarantineDeleted get data;
}

class _DataQuarantineDeletedCopyWith<$Res>
    implements $$DataQuarantineDeletedCopyWith<$Res> {
  _DataQuarantineDeletedCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DataQuarantineDeleted _value;

  @_i3.override
  _i4.QuarantineDeleted get data => _value.data;

  @_i3.override
  $Res call({_i3.Object? data = _sentinel}) {
    return (DataQuarantineDeleted(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i4.QuarantineDeleted),
    ) as $Res);
  }
}
