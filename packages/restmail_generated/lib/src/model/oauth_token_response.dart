// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OauthTokenResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OauthTokenResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory OauthTokenResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'access_token', r'expires_in', r'token_type'},
      listKeys: {},
      context: r'OauthTokenResponse',
    );
    return OauthTokenResponse(
      accessToken: _$values[r'access_token'].decodeSimpleString(
        context: r'OauthTokenResponse.access_token',
      ),
      expiresIn: _$values[r'expires_in'].decodeSimpleInt(
        context: r'OauthTokenResponse.expires_in',
      ),
      tokenType: _$values[r'token_type'].decodeSimpleString(
        context: r'OauthTokenResponse.token_type',
      ),
    );
  }

  factory OauthTokenResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OauthTokenResponse');
    return OauthTokenResponse(
      accessToken: _$map[r'access_token'].decodeJsonString(
        context: r'OauthTokenResponse.access_token',
      ),
      expiresIn: _$map[r'expires_in'].decodeJsonInt(
        context: r'OauthTokenResponse.expires_in',
      ),
      tokenType: _$map[r'token_type'].decodeJsonString(
        context: r'OauthTokenResponse.token_type',
      ),
    );
  }

  factory OauthTokenResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'access_token', r'expires_in', r'token_type'},
      listKeys: {},
      context: r'OauthTokenResponse',
    );
    return OauthTokenResponse(
      accessToken: _$values[r'access_token'].decodeFormString(
        context: r'OauthTokenResponse.access_token',
      ),
      expiresIn: _$values[r'expires_in'].decodeFormInt(
        context: r'OauthTokenResponse.expires_in',
      ),
      tokenType: _$values[r'token_type'].decodeFormString(
        context: r'OauthTokenResponse.token_type',
      ),
    );
  }

  final _i3.String accessToken;

  final _i3.int expiresIn;

  final _i3.String tokenType;

  @_i3.override
  _i3.Object? toJson() => {
    r'access_token': accessToken,
    r'expires_in': expiresIn,
    r'token_type': tokenType,
  };

  $$OauthTokenResponseCopyWith<OauthTokenResponse> get copyWith =>
      _OauthTokenResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OauthTokenResponse &&
        other.accessToken == this.accessToken &&
        other.expiresIn == this.expiresIn &&
        other.tokenType == this.tokenType;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([accessToken, expiresIn, tokenType]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'access_token'] = _i1.PropertyValue.scalar(accessToken);
    _$result[r'expires_in'] = _i1.PropertyValue.scalar(expiresIn.toString());
    _$result[r'token_type'] = _i1.PropertyValue.scalar(tokenType);
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
      r'Cannot uriEncode OauthTokenResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OauthTokenResponseCopyWith<$Res> {
  factory $$OauthTokenResponseCopyWith(OauthTokenResponse value) =
      _OauthTokenResponseCopyWith<$Res>;

  $Res call({
    _i3.String? accessToken,
    _i3.int? expiresIn,
    _i3.String? tokenType,
  });
  _i3.String get accessToken;
  _i3.int get expiresIn;
  _i3.String get tokenType;
}

class _OauthTokenResponseCopyWith<$Res>
    implements $$OauthTokenResponseCopyWith<$Res> {
  _OauthTokenResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OauthTokenResponse _value;

  @_i3.override
  _i3.String get accessToken => _value.accessToken;

  @_i3.override
  _i3.int get expiresIn => _value.expiresIn;

  @_i3.override
  _i3.String get tokenType => _value.tokenType;

  @_i3.override
  $Res call({
    _i3.Object? accessToken = _sentinel,
    _i3.Object? expiresIn = _sentinel,
    _i3.Object? tokenType = _sentinel,
  }) {
    return (OauthTokenResponse(
      accessToken: _i3.identical(accessToken, _sentinel)
          ? this.accessToken
          : (accessToken as _i3.String),
      expiresIn: _i3.identical(expiresIn, _sentinel)
          ? this.expiresIn
          : (expiresIn as _i3.int),
      tokenType: _i3.identical(tokenType, _sentinel)
          ? this.tokenType
          : (tokenType as _i3.String),
    ) as $Res);
  }
}
