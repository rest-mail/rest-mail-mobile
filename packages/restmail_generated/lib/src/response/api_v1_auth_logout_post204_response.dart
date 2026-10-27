// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:meta/meta.dart' as _i1;

@_i1.immutable
class ApiV1AuthLogoutPost204Response {
  const ApiV1AuthLogoutPost204Response({
    required this.contentSecurityPolicy,
    required this.referrerPolicy,
    required this.strictTransportSecurity,
    required this.xContentTypeOptions,
    required this.xFrameOptions,
    this.setCookie,
  });

  final _i2.String contentSecurityPolicy;

  final _i2.String referrerPolicy;

  final _i2.String strictTransportSecurity;

  final _i2.String xContentTypeOptions;

  final _i2.String xFrameOptions;

  final _i2.String? setCookie;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is ApiV1AuthLogoutPost204Response &&
        other.contentSecurityPolicy == this.contentSecurityPolicy &&
        other.referrerPolicy == this.referrerPolicy &&
        other.strictTransportSecurity == this.strictTransportSecurity &&
        other.xContentTypeOptions == this.xContentTypeOptions &&
        other.xFrameOptions == this.xFrameOptions &&
        other.setCookie == this.setCookie;
  }

  @_i2.override
  _i2.int get hashCode {
    return _i2.Object.hashAll([
      contentSecurityPolicy,
      referrerPolicy,
      strictTransportSecurity,
      xContentTypeOptions,
      xFrameOptions,
      setCookie,
    ]);
  }

  $$ApiV1AuthLogoutPost204ResponseCopyWith<ApiV1AuthLogoutPost204Response>
  get copyWith => _ApiV1AuthLogoutPost204ResponseCopyWith(this);
}

abstract class $$ApiV1AuthLogoutPost204ResponseCopyWith<$Res> {
  factory $$ApiV1AuthLogoutPost204ResponseCopyWith(
    ApiV1AuthLogoutPost204Response value,
  ) = _ApiV1AuthLogoutPost204ResponseCopyWith<$Res>;

  $Res call({
    _i2.String? contentSecurityPolicy,
    _i2.String? referrerPolicy,
    _i2.String? strictTransportSecurity,
    _i2.String? xContentTypeOptions,
    _i2.String? xFrameOptions,
    _i2.String? setCookie,
  });
  _i2.String get contentSecurityPolicy;
  _i2.String get referrerPolicy;
  _i2.String get strictTransportSecurity;
  _i2.String get xContentTypeOptions;
  _i2.String get xFrameOptions;
  _i2.String? get setCookie;
}

class _ApiV1AuthLogoutPost204ResponseCopyWith<$Res>
    implements $$ApiV1AuthLogoutPost204ResponseCopyWith<$Res> {
  _ApiV1AuthLogoutPost204ResponseCopyWith(this._value);

  static const _sentinel = _i2.Object();

  final ApiV1AuthLogoutPost204Response _value;

  @_i2.override
  _i2.String get contentSecurityPolicy => _value.contentSecurityPolicy;

  @_i2.override
  _i2.String get referrerPolicy => _value.referrerPolicy;

  @_i2.override
  _i2.String get strictTransportSecurity => _value.strictTransportSecurity;

  @_i2.override
  _i2.String get xContentTypeOptions => _value.xContentTypeOptions;

  @_i2.override
  _i2.String get xFrameOptions => _value.xFrameOptions;

  @_i2.override
  _i2.String? get setCookie => _value.setCookie;

  @_i2.override
  $Res call({
    _i2.Object? contentSecurityPolicy = _sentinel,
    _i2.Object? referrerPolicy = _sentinel,
    _i2.Object? strictTransportSecurity = _sentinel,
    _i2.Object? xContentTypeOptions = _sentinel,
    _i2.Object? xFrameOptions = _sentinel,
    _i2.Object? setCookie = _sentinel,
  }) {
    return (ApiV1AuthLogoutPost204Response(
      contentSecurityPolicy: _i2.identical(contentSecurityPolicy, _sentinel)
          ? this.contentSecurityPolicy
          : (contentSecurityPolicy as _i2.String),
      referrerPolicy: _i2.identical(referrerPolicy, _sentinel)
          ? this.referrerPolicy
          : (referrerPolicy as _i2.String),
      strictTransportSecurity: _i2.identical(strictTransportSecurity, _sentinel)
          ? this.strictTransportSecurity
          : (strictTransportSecurity as _i2.String),
      xContentTypeOptions: _i2.identical(xContentTypeOptions, _sentinel)
          ? this.xContentTypeOptions
          : (xContentTypeOptions as _i2.String),
      xFrameOptions: _i2.identical(xFrameOptions, _sentinel)
          ? this.xFrameOptions
          : (xFrameOptions as _i2.String),
      setCookie: _i2.identical(setCookie, _sentinel)
          ? this.setCookie
          : (setCookie as _i2.String?),
    ) as $Res);
  }
}
