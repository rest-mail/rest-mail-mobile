// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/certificate_details.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DataCertificateDetails extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DataCertificateDetails({required this.data});

  factory DataCertificateDetails.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DataCertificateDetails: contains complex types',
    );
  }

  factory DataCertificateDetails.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DataCertificateDetails');
    return DataCertificateDetails(
      data: _i4.CertificateDetails.fromJson(_$map[r'data']),
    );
  }

  factory DataCertificateDetails.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DataCertificateDetails: contains complex types',
    );
  }

  final _i4.CertificateDetails data;

  @_i3.override
  _i3.Object? toJson() => {r'data': data.toJson()};

  $$DataCertificateDetailsCopyWith<DataCertificateDetails> get copyWith =>
      _DataCertificateDetailsCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DataCertificateDetails && other.data == this.data;
  }

  @_i3.override
  _i3.int get hashCode => data.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DataCertificateDetails: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DataCertificateDetails: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DataCertificateDetailsCopyWith<$Res> {
  factory $$DataCertificateDetailsCopyWith(DataCertificateDetails value) =
      _DataCertificateDetailsCopyWith<$Res>;

  $Res call({_i4.CertificateDetails? data});
  _i4.CertificateDetails get data;
}

class _DataCertificateDetailsCopyWith<$Res>
    implements $$DataCertificateDetailsCopyWith<$Res> {
  _DataCertificateDetailsCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DataCertificateDetails _value;

  @_i3.override
  _i4.CertificateDetails get data => _value.data;

  @_i3.override
  $Res call({_i3.Object? data = _sentinel}) {
    return (DataCertificateDetails(
      data: _i3.identical(data, _sentinel)
          ? this.data
          : (data as _i4.CertificateDetails),
    ) as $Res);
  }
}
