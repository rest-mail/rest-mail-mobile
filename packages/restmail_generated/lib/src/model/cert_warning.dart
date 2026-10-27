// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/cert_warning_status_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CertWarning extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CertWarning({
    required this.certId,
    required this.daysUntil,
    required this.domain,
    required this.issuer,
    required this.notAfter,
    required this.status,
  });

  factory CertWarning.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'cert_id',
        r'days_until',
        r'domain',
        r'issuer',
        r'not_after',
        r'status',
      },
      listKeys: {},
      context: r'CertWarning',
    );
    return CertWarning(
      certId: _$values[r'cert_id'].decodeSimpleInt(
        context: r'CertWarning.cert_id',
      ),
      daysUntil: _$values[r'days_until'].decodeSimpleInt(
        context: r'CertWarning.days_until',
      ),
      domain: _$values[r'domain'].decodeSimpleString(
        context: r'CertWarning.domain',
      ),
      issuer: _$values[r'issuer'].decodeSimpleString(
        context: r'CertWarning.issuer',
      ),
      notAfter: _$values[r'not_after'].decodeSimpleDateTime(
        context: r'CertWarning.not_after',
      ),
      status: _i4.CertWarningStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  factory CertWarning.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CertWarning');
    return CertWarning(
      certId: _$map[r'cert_id'].decodeJsonInt(context: r'CertWarning.cert_id'),
      daysUntil: _$map[r'days_until'].decodeJsonInt(
        context: r'CertWarning.days_until',
      ),
      domain: _$map[r'domain'].decodeJsonString(context: r'CertWarning.domain'),
      issuer: _$map[r'issuer'].decodeJsonString(context: r'CertWarning.issuer'),
      notAfter: _$map[r'not_after'].decodeJsonDateTime(
        context: r'CertWarning.not_after',
      ),
      status: _i4.CertWarningStatusModel.fromJson(_$map[r'status']),
    );
  }

  factory CertWarning.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'cert_id',
        r'days_until',
        r'domain',
        r'issuer',
        r'not_after',
        r'status',
      },
      listKeys: {},
      context: r'CertWarning',
    );
    return CertWarning(
      certId: _$values[r'cert_id'].decodeFormInt(
        context: r'CertWarning.cert_id',
      ),
      daysUntil: _$values[r'days_until'].decodeFormInt(
        context: r'CertWarning.days_until',
      ),
      domain: _$values[r'domain'].decodeFormString(
        context: r'CertWarning.domain',
      ),
      issuer: _$values[r'issuer'].decodeFormString(
        context: r'CertWarning.issuer',
      ),
      notAfter: _$values[r'not_after'].decodeFormDateTime(
        context: r'CertWarning.not_after',
      ),
      status: _i4.CertWarningStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
    );
  }

  final _i3.int certId;

  final _i3.int daysUntil;

  final _i3.String domain;

  final _i3.String issuer;

  final _i3.DateTime notAfter;

  final _i4.CertWarningStatusModel status;

  @_i3.override
  _i3.Object? toJson() => {
    r'cert_id': certId,
    r'days_until': daysUntil,
    r'domain': domain,
    r'issuer': issuer,
    r'not_after': notAfter.toTimeZonedIso8601String(),
    r'status': status.toJson(),
  };

  $$CertWarningCopyWith<CertWarning> get copyWith => _CertWarningCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CertWarning &&
        other.certId == this.certId &&
        other.daysUntil == this.daysUntil &&
        other.domain == this.domain &&
        other.issuer == this.issuer &&
        other.notAfter == this.notAfter &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      certId,
      daysUntil,
      domain,
      issuer,
      notAfter,
      status,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'cert_id'] = _i1.PropertyValue.scalar(certId.toString());
    _$result[r'days_until'] = _i1.PropertyValue.scalar(daysUntil.toString());
    _$result[r'domain'] = _i1.PropertyValue.scalar(domain);
    _$result[r'issuer'] = _i1.PropertyValue.scalar(issuer);
    _$result[r'not_after'] = _i1.PropertyValue.scalar(
      notAfter.toTimeZonedIso8601String(),
    );
    _$result[r'status'] = _i1.PropertyValue.scalar(status.toJson());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CertWarning: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CertWarningCopyWith<$Res> {
  factory $$CertWarningCopyWith(CertWarning value) = _CertWarningCopyWith<$Res>;

  $Res call({
    _i3.int? certId,
    _i3.int? daysUntil,
    _i3.String? domain,
    _i3.String? issuer,
    _i3.DateTime? notAfter,
    _i4.CertWarningStatusModel? status,
  });
  _i3.int get certId;
  _i3.int get daysUntil;
  _i3.String get domain;
  _i3.String get issuer;
  _i3.DateTime get notAfter;
  _i4.CertWarningStatusModel get status;
}

class _CertWarningCopyWith<$Res> implements $$CertWarningCopyWith<$Res> {
  _CertWarningCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CertWarning _value;

  @_i3.override
  _i3.int get certId => _value.certId;

  @_i3.override
  _i3.int get daysUntil => _value.daysUntil;

  @_i3.override
  _i3.String get domain => _value.domain;

  @_i3.override
  _i3.String get issuer => _value.issuer;

  @_i3.override
  _i3.DateTime get notAfter => _value.notAfter;

  @_i3.override
  _i4.CertWarningStatusModel get status => _value.status;

  @_i3.override
  $Res call({
    _i3.Object? certId = _sentinel,
    _i3.Object? daysUntil = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? issuer = _sentinel,
    _i3.Object? notAfter = _sentinel,
    _i3.Object? status = _sentinel,
  }) {
    return (CertWarning(
      certId: _i3.identical(certId, _sentinel)
          ? this.certId
          : (certId as _i3.int),
      daysUntil: _i3.identical(daysUntil, _sentinel)
          ? this.daysUntil
          : (daysUntil as _i3.int),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i3.String),
      issuer: _i3.identical(issuer, _sentinel)
          ? this.issuer
          : (issuer as _i3.String),
      notAfter: _i3.identical(notAfter, _sentinel)
          ? this.notAfter
          : (notAfter as _i3.DateTime),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i4.CertWarningStatusModel),
    ) as $Res);
  }
}
