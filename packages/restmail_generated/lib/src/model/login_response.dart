// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/entry.dart' as _i4;
import 'package:restmail_generated/src/model/user_info.dart' as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoginResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoginResponse({
    required this.expiresIn,
    required this.user,
    this.accessToken,
    this.capabilities,
    this.refreshExpiresIn,
    this.refreshToken,
    this.scopedCapabilities,
    this.setupRequired,
  });

  factory LoginResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoginResponse: contains complex types',
    );
  }

  factory LoginResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LoginResponse');
    return LoginResponse(
      accessToken: _$map[r'access_token'].decodeJsonNullableString(
        context: r'LoginResponse.access_token',
      ),
      capabilities: _$map[r'capabilities'].decodeJsonNullableList<_i3.String>(
        context: r'LoginResponse.capabilities',
      ),
      expiresIn: _$map[r'expires_in'].decodeJsonInt(
        context: r'LoginResponse.expires_in',
      ),
      refreshExpiresIn: _$map[r'refresh_expires_in'].decodeJsonNullableInt(
        context: r'LoginResponse.refresh_expires_in',
      ),
      refreshToken: _$map[r'refresh_token'].decodeJsonNullableString(
        context: r'LoginResponse.refresh_token',
      ),
      scopedCapabilities: _$map[r'scoped_capabilities']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'LoginResponse.scoped_capabilities',
          )
          ?.map(_i4.Entry.fromJson)
          .toList(),
      setupRequired: _$map[r'setup_required']
          .decodeJsonNullableList<_i3.String>(
            context: r'LoginResponse.setup_required',
          ),
      user: _i5.UserInfo.fromJson(_$map[r'user']),
    );
  }

  factory LoginResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoginResponse: contains complex types',
    );
  }

  final _i3.String? accessToken;

  final _i3.List<_i3.String>? capabilities;

  final _i3.int expiresIn;

  final _i3.int? refreshExpiresIn;

  final _i3.String? refreshToken;

  final _i3.List<_i4.Entry>? scopedCapabilities;

  final _i3.List<_i3.String>? setupRequired;

  final _i5.UserInfo user;

  @_i3.override
  _i3.Object? toJson() => {
    if (accessToken != null) r'access_token': accessToken,
    if (capabilities != null) r'capabilities': capabilities,
    r'expires_in': expiresIn,
    if (refreshExpiresIn != null) r'refresh_expires_in': refreshExpiresIn,
    if (refreshToken != null) r'refresh_token': refreshToken,
    if (scopedCapabilities != null)
      r'scoped_capabilities': scopedCapabilities
          ?.map((e) => e.toJson())
          .toList(),
    if (setupRequired != null) r'setup_required': setupRequired,
    r'user': user.toJson(),
  };

  $$LoginResponseCopyWith<LoginResponse> get copyWith =>
      _LoginResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is LoginResponse &&
        other.accessToken == this.accessToken &&
        _$deepEquals.equals(other.capabilities, this.capabilities) &&
        other.expiresIn == this.expiresIn &&
        other.refreshExpiresIn == this.refreshExpiresIn &&
        other.refreshToken == this.refreshToken &&
        _$deepEquals.equals(
          other.scopedCapabilities,
          this.scopedCapabilities,
        ) &&
        _$deepEquals.equals(other.setupRequired, this.setupRequired) &&
        other.user == this.user;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      accessToken,
      deepEquals.hash(capabilities),
      expiresIn,
      refreshExpiresIn,
      refreshToken,
      deepEquals.hash(scopedCapabilities),
      deepEquals.hash(setupRequired),
      user,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoginResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoginResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$LoginResponseCopyWith<$Res> {
  factory $$LoginResponseCopyWith(LoginResponse value) =
      _LoginResponseCopyWith<$Res>;

  $Res call({
    _i3.String? accessToken,
    _i3.List<_i3.String>? capabilities,
    _i3.int? expiresIn,
    _i3.int? refreshExpiresIn,
    _i3.String? refreshToken,
    _i3.List<_i4.Entry>? scopedCapabilities,
    _i3.List<_i3.String>? setupRequired,
    _i5.UserInfo? user,
  });
  _i3.String? get accessToken;
  _i3.List<_i3.String>? get capabilities;
  _i3.int get expiresIn;
  _i3.int? get refreshExpiresIn;
  _i3.String? get refreshToken;
  _i3.List<_i4.Entry>? get scopedCapabilities;
  _i3.List<_i3.String>? get setupRequired;
  _i5.UserInfo get user;
}

class _LoginResponseCopyWith<$Res> implements $$LoginResponseCopyWith<$Res> {
  _LoginResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final LoginResponse _value;

  @_i3.override
  _i3.String? get accessToken => _value.accessToken;

  @_i3.override
  _i3.List<_i3.String>? get capabilities => _value.capabilities;

  @_i3.override
  _i3.int get expiresIn => _value.expiresIn;

  @_i3.override
  _i3.int? get refreshExpiresIn => _value.refreshExpiresIn;

  @_i3.override
  _i3.String? get refreshToken => _value.refreshToken;

  @_i3.override
  _i3.List<_i4.Entry>? get scopedCapabilities => _value.scopedCapabilities;

  @_i3.override
  _i3.List<_i3.String>? get setupRequired => _value.setupRequired;

  @_i3.override
  _i5.UserInfo get user => _value.user;

  @_i3.override
  $Res call({
    _i3.Object? accessToken = _sentinel,
    _i3.Object? capabilities = _sentinel,
    _i3.Object? expiresIn = _sentinel,
    _i3.Object? refreshExpiresIn = _sentinel,
    _i3.Object? refreshToken = _sentinel,
    _i3.Object? scopedCapabilities = _sentinel,
    _i3.Object? setupRequired = _sentinel,
    _i3.Object? user = _sentinel,
  }) {
    return (LoginResponse(
      accessToken: _i3.identical(accessToken, _sentinel)
          ? this.accessToken
          : (accessToken as _i3.String?),
      capabilities: _i3.identical(capabilities, _sentinel)
          ? this.capabilities
          : (capabilities as _i3.List<_i3.String>?),
      expiresIn: _i3.identical(expiresIn, _sentinel)
          ? this.expiresIn
          : (expiresIn as _i3.int),
      refreshExpiresIn: _i3.identical(refreshExpiresIn, _sentinel)
          ? this.refreshExpiresIn
          : (refreshExpiresIn as _i3.int?),
      refreshToken: _i3.identical(refreshToken, _sentinel)
          ? this.refreshToken
          : (refreshToken as _i3.String?),
      scopedCapabilities: _i3.identical(scopedCapabilities, _sentinel)
          ? this.scopedCapabilities
          : (scopedCapabilities as _i3.List<_i4.Entry>?),
      setupRequired: _i3.identical(setupRequired, _sentinel)
          ? this.setupRequired
          : (setupRequired as _i3.List<_i3.String>?),
      user: _i3.identical(user, _sentinel) ? this.user : (user as _i5.UserInfo),
    ) as $Res);
  }
}
