// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/forward_refusal_body.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ForwardRefusalResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ForwardRefusalResponse({required this.error});

  factory ForwardRefusalResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ForwardRefusalResponse: contains complex types',
    );
  }

  factory ForwardRefusalResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ForwardRefusalResponse');
    return ForwardRefusalResponse(
      error: _i4.ForwardRefusalBody.fromJson(_$map[r'error']),
    );
  }

  factory ForwardRefusalResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ForwardRefusalResponse: contains complex types',
    );
  }

  final _i4.ForwardRefusalBody error;

  @_i3.override
  _i3.Object? toJson() => {r'error': error.toJson()};

  $$ForwardRefusalResponseCopyWith<ForwardRefusalResponse> get copyWith =>
      _ForwardRefusalResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ForwardRefusalResponse && other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ForwardRefusalResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ForwardRefusalResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ForwardRefusalResponseCopyWith<$Res> {
  factory $$ForwardRefusalResponseCopyWith(ForwardRefusalResponse value) =
      _ForwardRefusalResponseCopyWith<$Res>;

  $Res call({_i4.ForwardRefusalBody? error});
  _i4.ForwardRefusalBody get error;
}

class _ForwardRefusalResponseCopyWith<$Res>
    implements $$ForwardRefusalResponseCopyWith<$Res> {
  _ForwardRefusalResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ForwardRefusalResponse _value;

  @_i3.override
  _i4.ForwardRefusalBody get error => _value.error;

  @_i3.override
  $Res call({_i3.Object? error = _sentinel}) {
    return (ForwardRefusalResponse(
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i4.ForwardRefusalBody),
    ) as $Res);
  }
}
