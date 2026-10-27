// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class AuthResult extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const AuthResult({
    required this.method,
    required this.result,
    this.domain,
    this.property,
  });

  factory AuthResult.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'domain', r'method', r'property', r'result'},
      listKeys: {},
      context: r'AuthResult',
    );
    return AuthResult(
      domain: _$values[r'domain'].decodeSimpleNullableString(
        context: r'AuthResult.domain',
      ),
      method: _$values[r'method'].decodeSimpleString(
        context: r'AuthResult.method',
      ),
      property: _$values[r'property'].decodeSimpleNullableString(
        context: r'AuthResult.property',
      ),
      result: _$values[r'result'].decodeSimpleString(
        context: r'AuthResult.result',
      ),
    );
  }

  factory AuthResult.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'AuthResult');
    return AuthResult(
      domain: _$map[r'domain'].decodeJsonNullableString(
        context: r'AuthResult.domain',
      ),
      method: _$map[r'method'].decodeJsonString(context: r'AuthResult.method'),
      property: _$map[r'property'].decodeJsonNullableString(
        context: r'AuthResult.property',
      ),
      result: _$map[r'result'].decodeJsonString(context: r'AuthResult.result'),
    );
  }

  factory AuthResult.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'domain', r'method', r'property', r'result'},
      listKeys: {},
      context: r'AuthResult',
    );
    return AuthResult(
      domain: _$values[r'domain'].decodeFormNullableString(
        context: r'AuthResult.domain',
      ),
      method: _$values[r'method'].decodeFormString(
        context: r'AuthResult.method',
      ),
      property: _$values[r'property'].decodeFormNullableString(
        context: r'AuthResult.property',
      ),
      result: _$values[r'result'].decodeFormString(
        context: r'AuthResult.result',
      ),
    );
  }

  final _i3.String? domain;

  final _i3.String method;

  final _i3.String? property;

  final _i3.String result;

  @_i3.override
  _i3.Object? toJson() => {
    if (domain != null) r'domain': domain,
    r'method': method,
    if (property != null) r'property': property,
    r'result': result,
  };

  $$AuthResultCopyWith<AuthResult> get copyWith => _AuthResultCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AuthResult &&
        other.domain == this.domain &&
        other.method == this.method &&
        other.property == this.property &&
        other.result == this.result;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([domain, method, property, result]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (domain != null) {
      _$result[r'domain'] = _i1.PropertyValue.scalar(domain!);
    }
    _$result[r'method'] = _i1.PropertyValue.scalar(method);
    if (property != null) {
      _$result[r'property'] = _i1.PropertyValue.scalar(property!);
    }
    _$result[r'result'] = _i1.PropertyValue.scalar(result);
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
      r'Cannot uriEncode AuthResult: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AuthResultCopyWith<$Res> {
  factory $$AuthResultCopyWith(AuthResult value) = _AuthResultCopyWith<$Res>;

  $Res call({
    _i3.String? domain,
    _i3.String? method,
    _i3.String? property,
    _i3.String? result,
  });
  _i3.String? get domain;
  _i3.String get method;
  _i3.String? get property;
  _i3.String get result;
}

class _AuthResultCopyWith<$Res> implements $$AuthResultCopyWith<$Res> {
  _AuthResultCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final AuthResult _value;

  @_i3.override
  _i3.String? get domain => _value.domain;

  @_i3.override
  _i3.String get method => _value.method;

  @_i3.override
  _i3.String? get property => _value.property;

  @_i3.override
  _i3.String get result => _value.result;

  @_i3.override
  $Res call({
    _i3.Object? domain = _sentinel,
    _i3.Object? method = _sentinel,
    _i3.Object? property = _sentinel,
    _i3.Object? result = _sentinel,
  }) {
    return (AuthResult(
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String?),
      method: _i3.identical(method, _sentinel)
          ? this.method
          : (method as _i3.String),
      property: _i3.identical(property, _sentinel)
          ? this.property
          : (property as _i3.String?),
      result: _i3.identical(result, _sentinel)
          ? this.result
          : (result as _i3.String),
    ) as $Res);
  }
}
