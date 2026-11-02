// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OauthError extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OauthError({required this.error, required this.errorDescription});

  factory OauthError.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'error', r'error_description'},
      listKeys: {},
      context: r'OauthError',
    );
    return OauthError(
      error: _$values[r'error'].decodeSimpleString(
        context: r'OauthError.error',
      ),
      errorDescription: _$values[r'error_description'].decodeSimpleString(
        context: r'OauthError.error_description',
      ),
    );
  }

  factory OauthError.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OauthError');
    return OauthError(
      error: _$map[r'error'].decodeJsonString(context: r'OauthError.error'),
      errorDescription: _$map[r'error_description'].decodeJsonString(
        context: r'OauthError.error_description',
      ),
    );
  }

  factory OauthError.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'error', r'error_description'},
      listKeys: {},
      context: r'OauthError',
    );
    return OauthError(
      error: _$values[r'error'].decodeFormString(context: r'OauthError.error'),
      errorDescription: _$values[r'error_description'].decodeFormString(
        context: r'OauthError.error_description',
      ),
    );
  }

  final _i3.String error;

  final _i3.String errorDescription;

  @_i3.override
  _i3.Object? toJson() => {
    r'error': error,
    r'error_description': errorDescription,
  };

  $$OauthErrorCopyWith<OauthError> get copyWith => _OauthErrorCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OauthError &&
        other.error == this.error &&
        other.errorDescription == this.errorDescription;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([error, errorDescription]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'error'] = _i1.PropertyValue.scalar(error);
    _$result[r'error_description'] = _i1.PropertyValue.scalar(errorDescription);
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
      r'Cannot uriEncode OauthError: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OauthErrorCopyWith<$Res> {
  factory $$OauthErrorCopyWith(OauthError value) = _OauthErrorCopyWith<$Res>;

  $Res call({_i3.String? error, _i3.String? errorDescription});
  _i3.String get error;
  _i3.String get errorDescription;
}

class _OauthErrorCopyWith<$Res> implements $$OauthErrorCopyWith<$Res> {
  _OauthErrorCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OauthError _value;

  @_i3.override
  _i3.String get error => _value.error;

  @_i3.override
  _i3.String get errorDescription => _value.errorDescription;

  @_i3.override
  $Res call({
    _i3.Object? error = _sentinel,
    _i3.Object? errorDescription = _sentinel,
  }) {
    return (OauthError(
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error as _i3.String),
      errorDescription: _i3.identical(errorDescription, _sentinel)
          ? this.errorDescription
          : (errorDescription as _i3.String),
    ) as $Res);
  }
}
