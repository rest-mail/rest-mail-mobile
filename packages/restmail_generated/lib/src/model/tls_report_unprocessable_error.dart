// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/tls_report_unprocessable_error_code_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/validation_details.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TlsReportUnprocessableError extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const TlsReportUnprocessableError({
    required this.code,
    required this.message,
    this.details,
  });

  factory TlsReportUnprocessableError.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for TlsReportUnprocessableError: contains complex types',
    );
  }

  factory TlsReportUnprocessableError.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'TlsReportUnprocessableError');
    return TlsReportUnprocessableError(
      code: _i4.TlsReportUnprocessableErrorCodeModel.fromJson(_$map[r'code']),
      details: _$map[r'details'] == null
          ? null
          : _i5.ValidationDetails.fromJson(_$map[r'details']),
      message: _$map[r'message'].decodeJsonString(
        context: r'TlsReportUnprocessableError.message',
      ),
    );
  }

  factory TlsReportUnprocessableError.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for TlsReportUnprocessableError: contains complex types',
    );
  }

  final _i4.TlsReportUnprocessableErrorCodeModel code;

  final _i5.ValidationDetails? details;

  final _i3.String message;

  @_i3.override
  _i3.Object? toJson() => {
    r'code': code.toJson(),
    if (details != null) r'details': details?.toJson(),
    r'message': message,
  };

  $$TlsReportUnprocessableErrorCopyWith<TlsReportUnprocessableError>
  get copyWith => _TlsReportUnprocessableErrorCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TlsReportUnprocessableError &&
        other.code == this.code &&
        other.details == this.details &&
        other.message == this.message;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([code, details, message]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for TlsReportUnprocessableError: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode TlsReportUnprocessableError: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$TlsReportUnprocessableErrorCopyWith<$Res> {
  factory $$TlsReportUnprocessableErrorCopyWith(
    TlsReportUnprocessableError value,
  ) = _TlsReportUnprocessableErrorCopyWith<$Res>;

  $Res call({
    _i4.TlsReportUnprocessableErrorCodeModel? code,
    _i5.ValidationDetails? details,
    _i3.String? message,
  });
  _i4.TlsReportUnprocessableErrorCodeModel get code;
  _i5.ValidationDetails? get details;
  _i3.String get message;
}

class _TlsReportUnprocessableErrorCopyWith<$Res>
    implements $$TlsReportUnprocessableErrorCopyWith<$Res> {
  _TlsReportUnprocessableErrorCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final TlsReportUnprocessableError _value;

  @_i3.override
  _i4.TlsReportUnprocessableErrorCodeModel get code => _value.code;

  @_i3.override
  _i5.ValidationDetails? get details => _value.details;

  @_i3.override
  _i3.String get message => _value.message;

  @_i3.override
  $Res call({
    _i3.Object? code = _sentinel,
    _i3.Object? details = _sentinel,
    _i3.Object? message = _sentinel,
  }) {
    return (TlsReportUnprocessableError(
      code: _i3.identical(code, _sentinel)
          ? this.code
          : (code as _i4.TlsReportUnprocessableErrorCodeModel),
      details: _i3.identical(details, _sentinel)
          ? this.details
          : (details as _i5.ValidationDetails?),
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String),
    ) as $Res);
  }
}
