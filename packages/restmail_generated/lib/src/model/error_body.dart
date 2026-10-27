// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ErrorBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ErrorBody({required this.code, required this.message, this.details});

  factory ErrorBody.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ErrorBody: contains complex types',
    );
  }

  factory ErrorBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ErrorBody');
    return ErrorBody(
      code: _$map[r'code'].decodeJsonString(context: r'ErrorBody.code'),
      details: _$map[r'details'].decodeJsonNullableMap(
        (v) => v,
        context: r'ErrorBody.details',
      ),
      message: _$map[r'message'].decodeJsonString(
        context: r'ErrorBody.message',
      ),
    );
  }

  factory ErrorBody.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ErrorBody: contains complex types',
    );
  }

  final _i3.String code;

  final _i3.Map<_i3.String, _i3.Object?>? details;

  final _i3.String message;

  @_i3.override
  _i3.Object? toJson() => {
    r'code': code,
    if (details != null)
      r'details': details?.map(
        (k, v) => _i3.MapEntry(
          k,
          _i1.encodeUnknownJson(v, context: r'ErrorBody.details'),
        ),
      ),
    r'message': message,
  };

  $$ErrorBodyCopyWith<ErrorBody> get copyWith => _ErrorBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ErrorBody &&
        other.code == this.code &&
        _$deepEquals.equals(other.details, this.details) &&
        other.message == this.message;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([code, deepEquals.hash(details), message]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ErrorBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ErrorBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ErrorBodyCopyWith<$Res> {
  factory $$ErrorBodyCopyWith(ErrorBody value) = _ErrorBodyCopyWith<$Res>;

  $Res call({
    _i3.String? code,
    _i3.Map<_i3.String, _i3.Object?>? details,
    _i3.String? message,
  });
  _i3.String get code;
  _i3.Map<_i3.String, _i3.Object?>? get details;
  _i3.String get message;
}

class _ErrorBodyCopyWith<$Res> implements $$ErrorBodyCopyWith<$Res> {
  _ErrorBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ErrorBody _value;

  @_i3.override
  _i3.String get code => _value.code;

  @_i3.override
  _i3.Map<_i3.String, _i3.Object?>? get details => _value.details;

  @_i3.override
  _i3.String get message => _value.message;

  @_i3.override
  $Res call({
    _i3.Object? code = _sentinel,
    _i3.Object? details = _sentinel,
    _i3.Object? message = _sentinel,
  }) {
    return (ErrorBody(
      code: _i3.identical(code, _sentinel) ? this.code : (code as _i3.String),
      details: _i3.identical(details, _sentinel)
          ? this.details
          : (details as _i3.Map<_i3.String, _i3.Object?>?),
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String),
    ) as $Res);
  }
}
