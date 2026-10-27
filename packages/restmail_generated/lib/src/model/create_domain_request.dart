// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/create_domain_request_dmarc_policy_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/create_domain_request_sending_policy_model.dart'
    as _i5;
import 'package:restmail_generated/src/model/create_domain_request_server_type_model.dart'
    as _i6;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateDomainRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateDomainRequest({
    required this.name,
    this.defaultQuotaBytes,
    this.dmarcPolicy,
    this.sendingPolicy,
    this.serverType,
  });

  factory CreateDomainRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'default_quota_bytes',
        r'dmarc_policy',
        r'name',
        r'sending_policy',
        r'server_type',
      },
      listKeys: {},
      context: r'CreateDomainRequest',
    );
    return CreateDomainRequest(
      defaultQuotaBytes: _$values[r'default_quota_bytes']
          .decodeSimpleNullableInt(
            context: r'CreateDomainRequest.default_quota_bytes',
          ),
      dmarcPolicy: _$values[r'dmarc_policy'] == null
          ? null
          : _i4.CreateDomainRequestDmarcPolicyModel.fromSimple(
              _$values[r'dmarc_policy'],
              explode: explode,
            ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'CreateDomainRequest.name',
      ),
      sendingPolicy: _$values[r'sending_policy'] == null
          ? null
          : _i5.CreateDomainRequestSendingPolicyModel.fromSimple(
              _$values[r'sending_policy'],
              explode: explode,
            ),
      serverType: _$values[r'server_type'] == null
          ? null
          : _i6.CreateDomainRequestServerTypeModel.fromSimple(
              _$values[r'server_type'],
              explode: explode,
            ),
    );
  }

  factory CreateDomainRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateDomainRequest');
    return CreateDomainRequest(
      defaultQuotaBytes: _$map[r'default_quota_bytes'].decodeJsonNullableInt(
        context: r'CreateDomainRequest.default_quota_bytes',
      ),
      dmarcPolicy: _$map[r'dmarc_policy'] == null
          ? null
          : _i4.CreateDomainRequestDmarcPolicyModel.fromJson(
              _$map[r'dmarc_policy'],
            ),
      name: _$map[r'name'].decodeJsonString(
        context: r'CreateDomainRequest.name',
      ),
      sendingPolicy: _$map[r'sending_policy'] == null
          ? null
          : _i5.CreateDomainRequestSendingPolicyModel.fromJson(
              _$map[r'sending_policy'],
            ),
      serverType: _$map[r'server_type'] == null
          ? null
          : _i6.CreateDomainRequestServerTypeModel.fromJson(
              _$map[r'server_type'],
            ),
    );
  }

  factory CreateDomainRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'default_quota_bytes',
        r'dmarc_policy',
        r'name',
        r'sending_policy',
        r'server_type',
      },
      listKeys: {},
      context: r'CreateDomainRequest',
    );
    return CreateDomainRequest(
      defaultQuotaBytes: _$values[r'default_quota_bytes'].decodeFormNullableInt(
        context: r'CreateDomainRequest.default_quota_bytes',
      ),
      dmarcPolicy: _$values[r'dmarc_policy'] == null
          ? null
          : _i4.CreateDomainRequestDmarcPolicyModel.fromForm(
              _$values[r'dmarc_policy'],
              explode: explode,
            ),
      name: _$values[r'name'].decodeFormString(
        context: r'CreateDomainRequest.name',
      ),
      sendingPolicy: _$values[r'sending_policy'] == null
          ? null
          : _i5.CreateDomainRequestSendingPolicyModel.fromForm(
              _$values[r'sending_policy'],
              explode: explode,
            ),
      serverType: _$values[r'server_type'] == null
          ? null
          : _i6.CreateDomainRequestServerTypeModel.fromForm(
              _$values[r'server_type'],
              explode: explode,
            ),
    );
  }

  final _i3.int? defaultQuotaBytes;

  final _i4.CreateDomainRequestDmarcPolicyModel? dmarcPolicy;

  final _i3.String name;

  final _i5.CreateDomainRequestSendingPolicyModel? sendingPolicy;

  final _i6.CreateDomainRequestServerTypeModel? serverType;

  @_i3.override
  _i3.Object? toJson() => {
    r'default_quota_bytes': defaultQuotaBytes,
    r'dmarc_policy': dmarcPolicy?.toJson(),
    r'name': name,
    if (sendingPolicy != null) r'sending_policy': sendingPolicy?.toJson(),
    r'server_type': serverType?.toJson(),
  };

  $$CreateDomainRequestCopyWith<CreateDomainRequest> get copyWith =>
      _CreateDomainRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateDomainRequest &&
        other.defaultQuotaBytes == this.defaultQuotaBytes &&
        other.dmarcPolicy == this.dmarcPolicy &&
        other.name == this.name &&
        other.sendingPolicy == this.sendingPolicy &&
        other.serverType == this.serverType;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      defaultQuotaBytes,
      dmarcPolicy,
      name,
      sendingPolicy,
      serverType,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (defaultQuotaBytes != null) {
      _$result[r'default_quota_bytes'] = _i1.PropertyValue.scalar(
        defaultQuotaBytes!.toString(),
      );
    }
    if (dmarcPolicy != null) {
      _$result[r'dmarc_policy'] = _i1.PropertyValue.scalar(
        dmarcPolicy!.toJson(),
      );
    }
    _$result[r'name'] = _i1.PropertyValue.scalar(name);
    if (sendingPolicy != null) {
      _$result[r'sending_policy'] = _i1.PropertyValue.scalar(
        sendingPolicy!.toJson(),
      );
    }
    if (serverType != null) {
      _$result[r'server_type'] = _i1.PropertyValue.scalar(serverType!.toJson());
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CreateDomainRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateDomainRequestCopyWith<$Res> {
  factory $$CreateDomainRequestCopyWith(CreateDomainRequest value) =
      _CreateDomainRequestCopyWith<$Res>;

  $Res call({
    _i3.int? defaultQuotaBytes,
    _i4.CreateDomainRequestDmarcPolicyModel? dmarcPolicy,
    _i3.String? name,
    _i5.CreateDomainRequestSendingPolicyModel? sendingPolicy,
    _i6.CreateDomainRequestServerTypeModel? serverType,
  });
  _i3.int? get defaultQuotaBytes;
  _i4.CreateDomainRequestDmarcPolicyModel? get dmarcPolicy;
  _i3.String get name;
  _i5.CreateDomainRequestSendingPolicyModel? get sendingPolicy;
  _i6.CreateDomainRequestServerTypeModel? get serverType;
}

class _CreateDomainRequestCopyWith<$Res>
    implements $$CreateDomainRequestCopyWith<$Res> {
  _CreateDomainRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateDomainRequest _value;

  @_i3.override
  _i3.int? get defaultQuotaBytes => _value.defaultQuotaBytes;

  @_i3.override
  _i4.CreateDomainRequestDmarcPolicyModel? get dmarcPolicy =>
      _value.dmarcPolicy;

  @_i3.override
  _i3.String get name => _value.name;

  @_i3.override
  _i5.CreateDomainRequestSendingPolicyModel? get sendingPolicy =>
      _value.sendingPolicy;

  @_i3.override
  _i6.CreateDomainRequestServerTypeModel? get serverType => _value.serverType;

  @_i3.override
  $Res call({
    _i3.Object? defaultQuotaBytes = _sentinel,
    _i3.Object? dmarcPolicy = _sentinel,
    _i3.Object? name = _sentinel,
    _i3.Object? sendingPolicy = _sentinel,
    _i3.Object? serverType = _sentinel,
  }) {
    return (CreateDomainRequest(
      defaultQuotaBytes: _i3.identical(defaultQuotaBytes, _sentinel)
          ? this.defaultQuotaBytes
          : (defaultQuotaBytes as _i3.int?),
      dmarcPolicy: _i3.identical(dmarcPolicy, _sentinel)
          ? this.dmarcPolicy
          : (dmarcPolicy as _i4.CreateDomainRequestDmarcPolicyModel?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String),
      sendingPolicy: _i3.identical(sendingPolicy, _sentinel)
          ? this.sendingPolicy
          : (sendingPolicy as _i5.CreateDomainRequestSendingPolicyModel?),
      serverType: _i3.identical(serverType, _sentinel)
          ? this.serverType
          : (serverType as _i6.CreateDomainRequestServerTypeModel?),
    ) as $Res);
  }
}
