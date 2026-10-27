// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:meta/meta.dart' as _i1;
import 'package:restmail_generated/src/model/error_response.dart' as _i3;

@_i1.immutable
class ApiV1AdminGrantsGet403Response {
  const ApiV1AdminGrantsGet403Response({
    required this.contentSecurityPolicy,
    required this.referrerPolicy,
    required this.strictTransportSecurity,
    required this.xContentTypeOptions,
    required this.xFrameOptions,
    required this.body,
  });

  final _i2.String contentSecurityPolicy;

  final _i2.String referrerPolicy;

  final _i2.String strictTransportSecurity;

  final _i2.String xContentTypeOptions;

  final _i2.String xFrameOptions;

  final _i3.ErrorResponse body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is ApiV1AdminGrantsGet403Response &&
        other.contentSecurityPolicy == this.contentSecurityPolicy &&
        other.referrerPolicy == this.referrerPolicy &&
        other.strictTransportSecurity == this.strictTransportSecurity &&
        other.xContentTypeOptions == this.xContentTypeOptions &&
        other.xFrameOptions == this.xFrameOptions &&
        other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode {
    return _i2.Object.hashAll([
      contentSecurityPolicy,
      referrerPolicy,
      strictTransportSecurity,
      xContentTypeOptions,
      xFrameOptions,
      body,
    ]);
  }

  $$ApiV1AdminGrantsGet403ResponseCopyWith<ApiV1AdminGrantsGet403Response>
  get copyWith => _ApiV1AdminGrantsGet403ResponseCopyWith(this);
}

abstract class $$ApiV1AdminGrantsGet403ResponseCopyWith<$Res> {
  factory $$ApiV1AdminGrantsGet403ResponseCopyWith(
    ApiV1AdminGrantsGet403Response value,
  ) = _ApiV1AdminGrantsGet403ResponseCopyWith<$Res>;

  $Res call({
    _i2.String? contentSecurityPolicy,
    _i2.String? referrerPolicy,
    _i2.String? strictTransportSecurity,
    _i2.String? xContentTypeOptions,
    _i2.String? xFrameOptions,
    _i3.ErrorResponse? body,
  });
  _i2.String get contentSecurityPolicy;
  _i2.String get referrerPolicy;
  _i2.String get strictTransportSecurity;
  _i2.String get xContentTypeOptions;
  _i2.String get xFrameOptions;
  _i3.ErrorResponse get body;
}

class _ApiV1AdminGrantsGet403ResponseCopyWith<$Res>
    implements $$ApiV1AdminGrantsGet403ResponseCopyWith<$Res> {
  _ApiV1AdminGrantsGet403ResponseCopyWith(this._value);

  static const _sentinel = _i2.Object();

  final ApiV1AdminGrantsGet403Response _value;

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
  _i3.ErrorResponse get body => _value.body;

  @_i2.override
  $Res call({
    _i2.Object? contentSecurityPolicy = _sentinel,
    _i2.Object? referrerPolicy = _sentinel,
    _i2.Object? strictTransportSecurity = _sentinel,
    _i2.Object? xContentTypeOptions = _sentinel,
    _i2.Object? xFrameOptions = _sentinel,
    _i2.Object? body = _sentinel,
  }) {
    return (ApiV1AdminGrantsGet403Response(
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
      body: _i2.identical(body, _sentinel)
          ? this.body
          : (body as _i3.ErrorResponse),
    ) as $Res);
  }
}
