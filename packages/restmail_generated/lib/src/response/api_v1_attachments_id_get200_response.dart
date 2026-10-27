// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:meta/meta.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i3;

@_i1.immutable
class ApiV1AttachmentsIdGet200Response {
  const ApiV1AttachmentsIdGet200Response({
    required this.acceptRanges,
    required this.contentDisposition,
    required this.contentLength,
    required this.contentSecurityPolicy,
    required this.referrerPolicy,
    required this.strictTransportSecurity,
    required this.xContentTypeOptions,
    required this.xFrameOptions,
    required this.body,
  });

  final _i2.String acceptRanges;

  final _i2.String contentDisposition;

  final _i2.int contentLength;

  final _i2.String contentSecurityPolicy;

  final _i2.String referrerPolicy;

  final _i2.String strictTransportSecurity;

  final _i2.String xContentTypeOptions;

  final _i2.String xFrameOptions;

  final _i3.TonikFile body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is ApiV1AttachmentsIdGet200Response &&
        other.acceptRanges == this.acceptRanges &&
        other.contentDisposition == this.contentDisposition &&
        other.contentLength == this.contentLength &&
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
      acceptRanges,
      contentDisposition,
      contentLength,
      contentSecurityPolicy,
      referrerPolicy,
      strictTransportSecurity,
      xContentTypeOptions,
      xFrameOptions,
      body,
    ]);
  }

  $$ApiV1AttachmentsIdGet200ResponseCopyWith<ApiV1AttachmentsIdGet200Response>
  get copyWith => _ApiV1AttachmentsIdGet200ResponseCopyWith(this);
}

abstract class $$ApiV1AttachmentsIdGet200ResponseCopyWith<$Res> {
  factory $$ApiV1AttachmentsIdGet200ResponseCopyWith(
    ApiV1AttachmentsIdGet200Response value,
  ) = _ApiV1AttachmentsIdGet200ResponseCopyWith<$Res>;

  $Res call({
    _i2.String? acceptRanges,
    _i2.String? contentDisposition,
    _i2.int? contentLength,
    _i2.String? contentSecurityPolicy,
    _i2.String? referrerPolicy,
    _i2.String? strictTransportSecurity,
    _i2.String? xContentTypeOptions,
    _i2.String? xFrameOptions,
    _i3.TonikFile? body,
  });
  _i2.String get acceptRanges;
  _i2.String get contentDisposition;
  _i2.int get contentLength;
  _i2.String get contentSecurityPolicy;
  _i2.String get referrerPolicy;
  _i2.String get strictTransportSecurity;
  _i2.String get xContentTypeOptions;
  _i2.String get xFrameOptions;
  _i3.TonikFile get body;
}

class _ApiV1AttachmentsIdGet200ResponseCopyWith<$Res>
    implements $$ApiV1AttachmentsIdGet200ResponseCopyWith<$Res> {
  _ApiV1AttachmentsIdGet200ResponseCopyWith(this._value);

  static const _sentinel = _i2.Object();

  final ApiV1AttachmentsIdGet200Response _value;

  @_i2.override
  _i2.String get acceptRanges => _value.acceptRanges;

  @_i2.override
  _i2.String get contentDisposition => _value.contentDisposition;

  @_i2.override
  _i2.int get contentLength => _value.contentLength;

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
  _i3.TonikFile get body => _value.body;

  @_i2.override
  $Res call({
    _i2.Object? acceptRanges = _sentinel,
    _i2.Object? contentDisposition = _sentinel,
    _i2.Object? contentLength = _sentinel,
    _i2.Object? contentSecurityPolicy = _sentinel,
    _i2.Object? referrerPolicy = _sentinel,
    _i2.Object? strictTransportSecurity = _sentinel,
    _i2.Object? xContentTypeOptions = _sentinel,
    _i2.Object? xFrameOptions = _sentinel,
    _i2.Object? body = _sentinel,
  }) {
    return (ApiV1AttachmentsIdGet200Response(
      acceptRanges: _i2.identical(acceptRanges, _sentinel)
          ? this.acceptRanges
          : (acceptRanges as _i2.String),
      contentDisposition: _i2.identical(contentDisposition, _sentinel)
          ? this.contentDisposition
          : (contentDisposition as _i2.String),
      contentLength: _i2.identical(contentLength, _sentinel)
          ? this.contentLength
          : (contentLength as _i2.int),
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
          : (body as _i3.TonikFile),
    ) as $Res);
  }
}
