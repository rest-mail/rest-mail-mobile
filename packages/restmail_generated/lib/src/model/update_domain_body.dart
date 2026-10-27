// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/update_domain_body_dmarc_policy_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/update_domain_body_sending_policy_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UpdateDomainBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UpdateDomainBody({
    this.active,
    this.defaultQuotaBytes,
    this.dmarcPolicy,
    this.sendingPolicy,
  });

  factory UpdateDomainBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'active',
        r'default_quota_bytes',
        r'dmarc_policy',
        r'sending_policy',
      },
      listKeys: {},
      context: r'UpdateDomainBody',
    );
    return UpdateDomainBody(
      active: _$values[r'active'].decodeSimpleNullableBool(
        context: r'UpdateDomainBody.active',
      ),
      defaultQuotaBytes: _$values[r'default_quota_bytes']
          .decodeSimpleNullableInt(
            context: r'UpdateDomainBody.default_quota_bytes',
          ),
      dmarcPolicy: _$values[r'dmarc_policy'] == null
          ? null
          : _i4.UpdateDomainBodyDmarcPolicyModel.fromSimple(
              _$values[r'dmarc_policy'],
              explode: explode,
            ),
      sendingPolicy: _$values[r'sending_policy'] == null
          ? null
          : _i5.UpdateDomainBodySendingPolicyModel.fromSimple(
              _$values[r'sending_policy'],
              explode: explode,
            ),
    );
  }

  factory UpdateDomainBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UpdateDomainBody');
    return UpdateDomainBody(
      active: _$map[r'active'].decodeJsonNullableBool(
        context: r'UpdateDomainBody.active',
      ),
      defaultQuotaBytes: _$map[r'default_quota_bytes'].decodeJsonNullableInt(
        context: r'UpdateDomainBody.default_quota_bytes',
      ),
      dmarcPolicy: _$map[r'dmarc_policy'] == null
          ? null
          : _i4.UpdateDomainBodyDmarcPolicyModel.fromJson(
              _$map[r'dmarc_policy'],
            ),
      sendingPolicy: _$map[r'sending_policy'] == null
          ? null
          : _i5.UpdateDomainBodySendingPolicyModel.fromJson(
              _$map[r'sending_policy'],
            ),
    );
  }

  factory UpdateDomainBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'active',
        r'default_quota_bytes',
        r'dmarc_policy',
        r'sending_policy',
      },
      listKeys: {},
      context: r'UpdateDomainBody',
    );
    return UpdateDomainBody(
      active: _$values[r'active'].decodeFormNullableBool(
        context: r'UpdateDomainBody.active',
      ),
      defaultQuotaBytes: _$values[r'default_quota_bytes'].decodeFormNullableInt(
        context: r'UpdateDomainBody.default_quota_bytes',
      ),
      dmarcPolicy: _$values[r'dmarc_policy'] == null
          ? null
          : _i4.UpdateDomainBodyDmarcPolicyModel.fromForm(
              _$values[r'dmarc_policy'],
              explode: explode,
            ),
      sendingPolicy: _$values[r'sending_policy'] == null
          ? null
          : _i5.UpdateDomainBodySendingPolicyModel.fromForm(
              _$values[r'sending_policy'],
              explode: explode,
            ),
    );
  }

  final _i3.bool? active;

  final _i3.int? defaultQuotaBytes;

  final _i4.UpdateDomainBodyDmarcPolicyModel? dmarcPolicy;

  final _i5.UpdateDomainBodySendingPolicyModel? sendingPolicy;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'default_quota_bytes': defaultQuotaBytes,
    r'dmarc_policy': dmarcPolicy?.toJson(),
    r'sending_policy': sendingPolicy?.toJson(),
  };

  $$UpdateDomainBodyCopyWith<UpdateDomainBody> get copyWith =>
      _UpdateDomainBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateDomainBody &&
        other.active == this.active &&
        other.defaultQuotaBytes == this.defaultQuotaBytes &&
        other.dmarcPolicy == this.dmarcPolicy &&
        other.sendingPolicy == this.sendingPolicy;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      defaultQuotaBytes,
      dmarcPolicy,
      sendingPolicy,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (active != null) {
      _$result[r'active'] = _i1.PropertyValue.scalar(active!.toString());
    }
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
    if (sendingPolicy != null) {
      _$result[r'sending_policy'] = _i1.PropertyValue.scalar(
        sendingPolicy!.toJson(),
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode UpdateDomainBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UpdateDomainBodyCopyWith<$Res> {
  factory $$UpdateDomainBodyCopyWith(UpdateDomainBody value) =
      _UpdateDomainBodyCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.int? defaultQuotaBytes,
    _i4.UpdateDomainBodyDmarcPolicyModel? dmarcPolicy,
    _i5.UpdateDomainBodySendingPolicyModel? sendingPolicy,
  });
  _i3.bool? get active;
  _i3.int? get defaultQuotaBytes;
  _i4.UpdateDomainBodyDmarcPolicyModel? get dmarcPolicy;
  _i5.UpdateDomainBodySendingPolicyModel? get sendingPolicy;
}

class _UpdateDomainBodyCopyWith<$Res>
    implements $$UpdateDomainBodyCopyWith<$Res> {
  _UpdateDomainBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UpdateDomainBody _value;

  @_i3.override
  _i3.bool? get active => _value.active;

  @_i3.override
  _i3.int? get defaultQuotaBytes => _value.defaultQuotaBytes;

  @_i3.override
  _i4.UpdateDomainBodyDmarcPolicyModel? get dmarcPolicy => _value.dmarcPolicy;

  @_i3.override
  _i5.UpdateDomainBodySendingPolicyModel? get sendingPolicy =>
      _value.sendingPolicy;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? defaultQuotaBytes = _sentinel,
    _i3.Object? dmarcPolicy = _sentinel,
    _i3.Object? sendingPolicy = _sentinel,
  }) {
    return (UpdateDomainBody(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool?),
      defaultQuotaBytes: _i3.identical(defaultQuotaBytes, _sentinel)
          ? this.defaultQuotaBytes
          : (defaultQuotaBytes as _i3.int?),
      dmarcPolicy: _i3.identical(dmarcPolicy, _sentinel)
          ? this.dmarcPolicy
          : (dmarcPolicy as _i4.UpdateDomainBodyDmarcPolicyModel?),
      sendingPolicy: _i3.identical(sendingPolicy, _sentinel)
          ? this.sendingPolicy
          : (sendingPolicy as _i5.UpdateDomainBodySendingPolicyModel?),
    ) as $Res);
  }
}
