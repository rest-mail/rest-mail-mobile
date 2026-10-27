// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/tls_report_unprocessable_error.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsReportUnprocessable extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsReportUnprocessable({required this.error});

  factory TlsReportUnprocessable.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TlsReportUnprocessable: contains complex types',
    );
  }

  factory TlsReportUnprocessable.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsReportUnprocessable');
    return TlsReportUnprocessable(
      error: _i4.TlsReportUnprocessableError.fromJson(_$map[r'error']),
    );
  }

  factory TlsReportUnprocessable.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TlsReportUnprocessable: contains complex types',
    );
  }

  final _i4.TlsReportUnprocessableError error;

  @_i3.override
  _i3.Object? toJson() => {r'error': error.toJson()};

  $$TlsReportUnprocessableCopyWith<TlsReportUnprocessable> get copyWith =>
      _TlsReportUnprocessableCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsReportUnprocessable && other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TlsReportUnprocessable: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsReportUnprocessable: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsReportUnprocessableCopyWith<$Res> {
  factory $$TlsReportUnprocessableCopyWith(TlsReportUnprocessable value) =
      _TlsReportUnprocessableCopyWith<$Res>;

  $Res call({_i4.TlsReportUnprocessableError? error});
  _i4.TlsReportUnprocessableError get error;
}

class _TlsReportUnprocessableCopyWith<$Res>
    implements $$TlsReportUnprocessableCopyWith<$Res> {
  _TlsReportUnprocessableCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsReportUnprocessable _value;

  @_i3.override
  _i4.TlsReportUnprocessableError get error => _value.error;

  @_i3.override
  $Res call({_i3.Object? error = _sentinel}) {
    return (TlsReportUnprocessable(
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i4.TlsReportUnprocessableError),
    ) as $Res);
  }
}
