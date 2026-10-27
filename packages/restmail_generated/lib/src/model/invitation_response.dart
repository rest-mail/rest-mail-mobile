// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class InvitationResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const InvitationResponse({required this.expiresAt, required this.token});

  factory InvitationResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'expires_at', r'token'},
      listKeys: {},
      context: r'InvitationResponse',
    );
    return InvitationResponse(
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'InvitationResponse.expires_at',
      ),
      token: _$values[r'token'].decodeSimpleString(
        context: r'InvitationResponse.token',
      ),
    );
  }

  factory InvitationResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'InvitationResponse');
    return InvitationResponse(
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'InvitationResponse.expires_at',
      ),
      token: _$map[r'token'].decodeJsonString(
        context: r'InvitationResponse.token',
      ),
    );
  }

  factory InvitationResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'expires_at', r'token'},
      listKeys: {},
      context: r'InvitationResponse',
    );
    return InvitationResponse(
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'InvitationResponse.expires_at',
      ),
      token: _$values[r'token'].decodeFormString(
        context: r'InvitationResponse.token',
      ),
    );
  }

  final _i3.DateTime expiresAt;

  final _i3.String token;

  @_i3.override
  _i3.Object? toJson() => {
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
    r'token': token,
  };

  $$InvitationResponseCopyWith<InvitationResponse> get copyWith =>
      _InvitationResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is InvitationResponse &&
        other.expiresAt == this.expiresAt &&
        other.token == this.token;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([expiresAt, token]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
    _$result[r'token'] = _i1.PropertyValue.scalar(token);
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
      r'Cannot uriEncode InvitationResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$InvitationResponseCopyWith<$Res> {
  factory $$InvitationResponseCopyWith(InvitationResponse value) =
      _InvitationResponseCopyWith<$Res>;

  $Res call({_i3.DateTime? expiresAt, _i3.String? token});
  _i3.DateTime get expiresAt;
  _i3.String get token;
}

class _InvitationResponseCopyWith<$Res>
    implements $$InvitationResponseCopyWith<$Res> {
  _InvitationResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final InvitationResponse _value;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.String get token => _value.token;

  @_i3.override
  $Res call({
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? token = _sentinel,
  }) {
    return (InvitationResponse(
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String),
    ) as $Res);
  }
}
