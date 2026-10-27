// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/domain.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Certificate extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const Certificate({
    required this.autoRenew,
    required this.createdAt,
    required this.domainId,
    required this.id,
    required this.issuer,
    required this.notAfter,
    required this.notBefore,
    required this.updatedAt,
    this.domain,
  });

  factory Certificate.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Certificate: contains complex types',
    );
  }

  factory Certificate.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Certificate');
    return Certificate(
      autoRenew: _$map[r'auto_renew'].decodeJsonBool(
        context: r'Certificate.auto_renew',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Certificate.created_at',
      ),
      domain: _$map[r'domain'] == null
          ? null
          : _i4.Domain.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'Certificate.domain_id',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'Certificate.id'),
      issuer: _$map[r'issuer'].decodeJsonString(context: r'Certificate.issuer'),
      notAfter: _$map[r'not_after'].decodeJsonDateTime(
        context: r'Certificate.not_after',
      ),
      notBefore: _$map[r'not_before'].decodeJsonDateTime(
        context: r'Certificate.not_before',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Certificate.updated_at',
      ),
    );
  }

  factory Certificate.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Certificate: contains complex types',
    );
  }

  final _i3.bool autoRenew;

  final _i3.DateTime createdAt;

  final _i4.Domain? domain;

  final _i3.int domainId;

  final _i3.int id;

  final _i3.String issuer;

  final _i3.DateTime notAfter;

  final _i3.DateTime notBefore;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'auto_renew': autoRenew,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'id': id,
    r'issuer': issuer,
    r'not_after': notAfter.toTimeZonedIso8601String(),
    r'not_before': notBefore.toTimeZonedIso8601String(),
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$CertificateCopyWith<Certificate> get copyWith => _CertificateCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Certificate &&
        other.autoRenew == this.autoRenew &&
        other.createdAt == this.createdAt &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.id == this.id &&
        other.issuer == this.issuer &&
        other.notAfter == this.notAfter &&
        other.notBefore == this.notBefore &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      autoRenew,
      createdAt,
      domain,
      domainId,
      id,
      issuer,
      notAfter,
      notBefore,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Certificate: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Certificate: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CertificateCopyWith<$Res> {
  factory $$CertificateCopyWith(Certificate value) = _CertificateCopyWith<$Res>;

  $Res call({
    _i3.bool? autoRenew,
    _i3.DateTime? createdAt,
    _i4.Domain? domain,
    _i3.int? domainId,
    _i3.int? id,
    _i3.String? issuer,
    _i3.DateTime? notAfter,
    _i3.DateTime? notBefore,
    _i3.DateTime? updatedAt,
  });
  _i3.bool get autoRenew;
  _i3.DateTime get createdAt;
  _i4.Domain? get domain;
  _i3.int get domainId;
  _i3.int get id;
  _i3.String get issuer;
  _i3.DateTime get notAfter;
  _i3.DateTime get notBefore;
  _i3.DateTime get updatedAt;
}

class _CertificateCopyWith<$Res> implements $$CertificateCopyWith<$Res> {
  _CertificateCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Certificate _value;

  @_i3.override
  _i3.bool get autoRenew => _value.autoRenew;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i4.Domain? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get issuer => _value.issuer;

  @_i3.override
  _i3.DateTime get notAfter => _value.notAfter;

  @_i3.override
  _i3.DateTime get notBefore => _value.notBefore;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? autoRenew = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? issuer = _sentinel,
    _i3.Object? notAfter = _sentinel,
    _i3.Object? notBefore = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Certificate(
      autoRenew: _i3.identical(autoRenew, _sentinel)
          ? this.autoRenew
          : (autoRenew as _i3.bool),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i4.Domain?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      issuer: _i3.identical(issuer, _sentinel)
          ? this.issuer
          : (issuer as _i3.String),
      notAfter: _i3.identical(notAfter, _sentinel)
          ? this.notAfter
          : (notAfter as _i3.DateTime),
      notBefore: _i3.identical(notBefore, _sentinel)
          ? this.notBefore
          : (notBefore as _i3.DateTime),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
