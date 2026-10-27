// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/forward_refusal_body_details_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ForwardRefusalBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ForwardRefusalBody({
    required this.code,
    required this.message,
    this.details,
  });

  factory ForwardRefusalBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ForwardRefusalBody: contains complex types',
    );
  }

  factory ForwardRefusalBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ForwardRefusalBody');
    return ForwardRefusalBody(
      code: _$map[r'code'].decodeJsonString(
        context: r'ForwardRefusalBody.code',
      ),
      details: _$map[r'details'] == null
          ? null
          : _i4.ForwardRefusalBodyDetailsOneOfModel.fromJson(_$map[r'details']),
      message: _$map[r'message'].decodeJsonString(
        context: r'ForwardRefusalBody.message',
      ),
    );
  }

  factory ForwardRefusalBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ForwardRefusalBody: contains complex types',
    );
  }

  final _i3.String code;

  final _i4.ForwardRefusalBodyDetailsOneOfModel? details;

  final _i3.String message;

  @_i3.override
  _i3.Object? toJson() => {
    r'code': code,
    if (details != null) r'details': details?.toJson(),
    r'message': message,
  };

  $$ForwardRefusalBodyCopyWith<ForwardRefusalBody> get copyWith =>
      _ForwardRefusalBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ForwardRefusalBody &&
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
    r'parameterProperties not supported for ForwardRefusalBody: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ForwardRefusalBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ForwardRefusalBodyCopyWith<$Res> {
  factory $$ForwardRefusalBodyCopyWith(ForwardRefusalBody value) =
      _ForwardRefusalBodyCopyWith<$Res>;

  $Res call({
    _i3.String? code,
    _i4.ForwardRefusalBodyDetailsOneOfModel? details,
    _i3.String? message,
  });
  _i3.String get code;
  _i4.ForwardRefusalBodyDetailsOneOfModel? get details;
  _i3.String get message;
}

class _ForwardRefusalBodyCopyWith<$Res>
    implements $$ForwardRefusalBodyCopyWith<$Res> {
  _ForwardRefusalBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ForwardRefusalBody _value;

  @_i3.override
  _i3.String get code => _value.code;

  @_i3.override
  _i4.ForwardRefusalBodyDetailsOneOfModel? get details => _value.details;

  @_i3.override
  _i3.String get message => _value.message;

  @_i3.override
  $Res call({
    _i3.Object? code = _sentinel,
    _i3.Object? details = _sentinel,
    _i3.Object? message = _sentinel,
  }) {
    return (ForwardRefusalBody(
      code: _i3.identical(code, _sentinel) ? this.code : (code as _i3.String),
      details: _i3.identical(details, _sentinel)
          ? this.details
          : (details as _i4.ForwardRefusalBodyDetailsOneOfModel?),
      message: _i3.identical(message, _sentinel)
          ? this.message
          : (message as _i3.String),
    ) as $Res);
  }
}
