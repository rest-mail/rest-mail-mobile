// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateCertificateRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateCertificateRequest({
    required this.certPem,
    required this.domainId,
    required this.keyPem,
    this.autoRenew,
  });

  factory CreateCertificateRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'auto_renew', r'cert_pem', r'domain_id', r'key_pem'},
      listKeys: {},
      context: r'CreateCertificateRequest',
    );
    return CreateCertificateRequest(
      autoRenew: _$values[r'auto_renew'].decodeSimpleNullableBool(
        context: r'CreateCertificateRequest.auto_renew',
      ),
      certPem: _$values[r'cert_pem'].decodeSimpleString(
        context: r'CreateCertificateRequest.cert_pem',
      ),
      domainId: _$values[r'domain_id'].decodeSimpleInt(
        context: r'CreateCertificateRequest.domain_id',
      ),
      keyPem: _$values[r'key_pem'].decodeSimpleString(
        context: r'CreateCertificateRequest.key_pem',
      ),
    );
  }

  factory CreateCertificateRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateCertificateRequest');
    return CreateCertificateRequest(
      autoRenew: _$map[r'auto_renew'].decodeJsonNullableBool(
        context: r'CreateCertificateRequest.auto_renew',
      ),
      certPem: _$map[r'cert_pem'].decodeJsonString(
        context: r'CreateCertificateRequest.cert_pem',
      ),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'CreateCertificateRequest.domain_id',
      ),
      keyPem: _$map[r'key_pem'].decodeJsonString(
        context: r'CreateCertificateRequest.key_pem',
      ),
    );
  }

  factory CreateCertificateRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'auto_renew', r'cert_pem', r'domain_id', r'key_pem'},
      listKeys: {},
      context: r'CreateCertificateRequest',
    );
    return CreateCertificateRequest(
      autoRenew: _$values[r'auto_renew'].decodeFormNullableBool(
        context: r'CreateCertificateRequest.auto_renew',
      ),
      certPem: _$values[r'cert_pem'].decodeFormString(
        context: r'CreateCertificateRequest.cert_pem',
      ),
      domainId: _$values[r'domain_id'].decodeFormInt(
        context: r'CreateCertificateRequest.domain_id',
      ),
      keyPem: _$values[r'key_pem'].decodeFormString(
        context: r'CreateCertificateRequest.key_pem',
      ),
    );
  }

  final _i3.bool? autoRenew;

  final _i3.String certPem;

  final _i3.int domainId;

  final _i3.String keyPem;

  @_i3.override
  _i3.Object? toJson() => {
    r'auto_renew': autoRenew,
    r'cert_pem': certPem,
    r'domain_id': domainId,
    r'key_pem': keyPem,
  };

  $$CreateCertificateRequestCopyWith<CreateCertificateRequest> get copyWith =>
      _CreateCertificateRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateRequest &&
        other.autoRenew == this.autoRenew &&
        other.certPem == this.certPem &&
        other.domainId == this.domainId &&
        other.keyPem == this.keyPem;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([autoRenew, certPem, domainId, keyPem]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (autoRenew != null) {
      _$result[r'auto_renew'] = _i1.PropertyValue.scalar(autoRenew!.toString());
    }
    _$result[r'cert_pem'] = _i1.PropertyValue.scalar(certPem);
    _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId.toString());
    _$result[r'key_pem'] = _i1.PropertyValue.scalar(keyPem);
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
      r'Cannot uriEncode CreateCertificateRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateCertificateRequestCopyWith<$Res> {
  factory $$CreateCertificateRequestCopyWith(CreateCertificateRequest value) =
      _CreateCertificateRequestCopyWith<$Res>;

  $Res call({
    _i3.bool? autoRenew,
    _i3.String? certPem,
    _i3.int? domainId,
    _i3.String? keyPem,
  });
  _i3.bool? get autoRenew;
  _i3.String get certPem;
  _i3.int get domainId;
  _i3.String get keyPem;
}

class _CreateCertificateRequestCopyWith<$Res>
    implements $$CreateCertificateRequestCopyWith<$Res> {
  _CreateCertificateRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateCertificateRequest _value;

  @_i3.override
  _i3.bool? get autoRenew => _value.autoRenew;

  @_i3.override
  _i3.String get certPem => _value.certPem;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.String get keyPem => _value.keyPem;

  @_i3.override
  $Res call({
    _i3.Object? autoRenew = _sentinel,
    _i3.Object? certPem = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? keyPem = _sentinel,
  }) {
    return (CreateCertificateRequest(
      autoRenew: _i3.identical(autoRenew, _sentinel)
          ? this.autoRenew
          : (autoRenew as _i3.bool?),
      certPem: _i3.identical(certPem, _sentinel)
          ? this.certPem
          : (certPem as _i3.String),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      keyPem: _i3.identical(keyPem, _sentinel)
          ? this.keyPem
          : (keyPem as _i3.String),
    ) as $Res);
  }
}
