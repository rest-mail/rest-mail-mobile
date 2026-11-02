// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:meta/meta.dart' as _i1;

@_i1.immutable
class ApiV1AttachmentsIdGet304Response {
  const ApiV1AttachmentsIdGet304Response({
    required this.contentDisposition,
    required this.contentSecurityPolicy,
    required this.referrerPolicy,
    required this.strictTransportSecurity,
    required this.xContentTypeOptions,
    required this.xFrameOptions,
    this.eTag,
    this.lastModified,
  });

  final _i2.String contentDisposition;

  final _i2.String contentSecurityPolicy;

  final _i2.String referrerPolicy;

  final _i2.String strictTransportSecurity;

  final _i2.String xContentTypeOptions;

  final _i2.String xFrameOptions;

  final _i2.String? eTag;

  final _i2.String? lastModified;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is ApiV1AttachmentsIdGet304Response &&
        other.contentDisposition == this.contentDisposition &&
        other.contentSecurityPolicy == this.contentSecurityPolicy &&
        other.referrerPolicy == this.referrerPolicy &&
        other.strictTransportSecurity == this.strictTransportSecurity &&
        other.xContentTypeOptions == this.xContentTypeOptions &&
        other.xFrameOptions == this.xFrameOptions &&
        other.eTag == this.eTag &&
        other.lastModified == this.lastModified;
  }

  @_i2.override
  _i2.int get hashCode {
    return _i2.Object.hashAll([
      contentDisposition,
      contentSecurityPolicy,
      referrerPolicy,
      strictTransportSecurity,
      xContentTypeOptions,
      xFrameOptions,
      eTag,
      lastModified,
    ]);
  }

  $$ApiV1AttachmentsIdGet304ResponseCopyWith<ApiV1AttachmentsIdGet304Response>
  get copyWith => _ApiV1AttachmentsIdGet304ResponseCopyWith(this);
}

abstract class $$ApiV1AttachmentsIdGet304ResponseCopyWith<$Res> {
  factory $$ApiV1AttachmentsIdGet304ResponseCopyWith(
    ApiV1AttachmentsIdGet304Response value,
  ) = _ApiV1AttachmentsIdGet304ResponseCopyWith<$Res>;

  $Res call({
    _i2.String? contentDisposition,
    _i2.String? contentSecurityPolicy,
    _i2.String? referrerPolicy,
    _i2.String? strictTransportSecurity,
    _i2.String? xContentTypeOptions,
    _i2.String? xFrameOptions,
    _i2.String? eTag,
    _i2.String? lastModified,
  });
  _i2.String get contentDisposition;
  _i2.String get contentSecurityPolicy;
  _i2.String get referrerPolicy;
  _i2.String get strictTransportSecurity;
  _i2.String get xContentTypeOptions;
  _i2.String get xFrameOptions;
  _i2.String? get eTag;
  _i2.String? get lastModified;
}

class _ApiV1AttachmentsIdGet304ResponseCopyWith<$Res>
    implements $$ApiV1AttachmentsIdGet304ResponseCopyWith<$Res> {
  _ApiV1AttachmentsIdGet304ResponseCopyWith(this._value);

  static const _sentinel = _i2.Object();

  final ApiV1AttachmentsIdGet304Response _value;

  @_i2.override
  _i2.String get contentDisposition => _value.contentDisposition;

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
  _i2.String? get eTag => _value.eTag;

  @_i2.override
  _i2.String? get lastModified => _value.lastModified;

  @_i2.override
  $Res call({
    _i2.Object? contentDisposition = _sentinel,
    _i2.Object? contentSecurityPolicy = _sentinel,
    _i2.Object? referrerPolicy = _sentinel,
    _i2.Object? strictTransportSecurity = _sentinel,
    _i2.Object? xContentTypeOptions = _sentinel,
    _i2.Object? xFrameOptions = _sentinel,
    _i2.Object? eTag = _sentinel,
    _i2.Object? lastModified = _sentinel,
  }) {
    return (ApiV1AttachmentsIdGet304Response(
      contentDisposition: _i2.identical(contentDisposition, _sentinel)
          ? this.contentDisposition
          : (contentDisposition as _i2.String),
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
      eTag: _i2.identical(eTag, _sentinel) ? this.eTag : (eTag as _i2.String?),
      lastModified: _i2.identical(lastModified, _sentinel)
          ? this.lastModified
          : (lastModified as _i2.String?),
    ) as $Res);
  }
}
