// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RegisterDeviceRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RegisterDeviceRequest({
    required this.platform,
    required this.token,
    this.appId,
    this.environment,
  });

  factory RegisterDeviceRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'app_id', r'environment', r'platform', r'token'},
      listKeys: {},
      context: r'RegisterDeviceRequest',
    );
    return RegisterDeviceRequest(
      appId: _$values[r'app_id'].decodeSimpleNullableString(
        context: r'RegisterDeviceRequest.app_id',
      ),
      environment: _$values[r'environment'].decodeSimpleNullableString(
        context: r'RegisterDeviceRequest.environment',
      ),
      platform: _$values[r'platform'].decodeSimpleString(
        context: r'RegisterDeviceRequest.platform',
      ),
      token: _$values[r'token'].decodeSimpleString(
        context: r'RegisterDeviceRequest.token',
      ),
    );
  }

  factory RegisterDeviceRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RegisterDeviceRequest');
    return RegisterDeviceRequest(
      appId: _$map[r'app_id'].decodeJsonNullableString(
        context: r'RegisterDeviceRequest.app_id',
      ),
      environment: _$map[r'environment'].decodeJsonNullableString(
        context: r'RegisterDeviceRequest.environment',
      ),
      platform: _$map[r'platform'].decodeJsonString(
        context: r'RegisterDeviceRequest.platform',
      ),
      token: _$map[r'token'].decodeJsonString(
        context: r'RegisterDeviceRequest.token',
      ),
    );
  }

  factory RegisterDeviceRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'app_id', r'environment', r'platform', r'token'},
      listKeys: {},
      context: r'RegisterDeviceRequest',
    );
    return RegisterDeviceRequest(
      appId: _$values[r'app_id'].decodeFormNullableString(
        context: r'RegisterDeviceRequest.app_id',
      ),
      environment: _$values[r'environment'].decodeFormNullableString(
        context: r'RegisterDeviceRequest.environment',
      ),
      platform: _$values[r'platform'].decodeFormString(
        context: r'RegisterDeviceRequest.platform',
      ),
      token: _$values[r'token'].decodeFormString(
        context: r'RegisterDeviceRequest.token',
      ),
    );
  }

  final _i3.String? appId;

  final _i3.String? environment;

  final _i3.String platform;

  final _i3.String token;

  @_i3.override
  _i3.Object? toJson() => {
    if (appId != null) r'app_id': appId,
    if (environment != null) r'environment': environment,
    r'platform': platform,
    r'token': token,
  };

  $$RegisterDeviceRequestCopyWith<RegisterDeviceRequest> get copyWith =>
      _RegisterDeviceRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterDeviceRequest &&
        other.appId == this.appId &&
        other.environment == this.environment &&
        other.platform == this.platform &&
        other.token == this.token;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([appId, environment, platform, token]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (appId != null) {
      _$result[r'app_id'] = _i1.PropertyValue.scalar(appId!);
    }
    if (environment != null) {
      _$result[r'environment'] = _i1.PropertyValue.scalar(environment!);
    }
    _$result[r'platform'] = _i1.PropertyValue.scalar(platform);
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
      r'Cannot uriEncode RegisterDeviceRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RegisterDeviceRequestCopyWith<$Res> {
  factory $$RegisterDeviceRequestCopyWith(RegisterDeviceRequest value) =
      _RegisterDeviceRequestCopyWith<$Res>;

  $Res call({
    _i3.String? appId,
    _i3.String? environment,
    _i3.String? platform,
    _i3.String? token,
  });
  _i3.String? get appId;
  _i3.String? get environment;
  _i3.String get platform;
  _i3.String get token;
}

class _RegisterDeviceRequestCopyWith<$Res>
    implements $$RegisterDeviceRequestCopyWith<$Res> {
  _RegisterDeviceRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RegisterDeviceRequest _value;

  @_i3.override
  _i3.String? get appId => _value.appId;

  @_i3.override
  _i3.String? get environment => _value.environment;

  @_i3.override
  _i3.String get platform => _value.platform;

  @_i3.override
  _i3.String get token => _value.token;

  @_i3.override
  $Res call({
    _i3.Object? appId = _sentinel,
    _i3.Object? environment = _sentinel,
    _i3.Object? platform = _sentinel,
    _i3.Object? token = _sentinel,
  }) {
    return (RegisterDeviceRequest(
      appId: _i3.identical(appId, _sentinel)
          ? this.appId
          : (appId as _i3.String?),
      environment: _i3.identical(environment, _sentinel)
          ? this.environment
          : (environment as _i3.String?),
      platform: _i3.identical(platform, _sentinel)
          ? this.platform
          : (platform as _i3.String),
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String),
    ) as $Res);
  }
}
