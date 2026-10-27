// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/mailbox_domain_one_of_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/mailbox_quota_usage_one_of_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Mailbox extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Mailbox({
    required this.active,
    required this.address,
    required this.createdAt,
    required this.displayName,
    required this.domainId,
    required this.id,
    required this.lastLoginAt,
    required this.localPart,
    required this.passwordChangeRequired,
    required this.quotaBytes,
    required this.quotaUsedBytes,
    required this.twoFactorRequired,
    required this.updatedAt,
    this.domain,
    this.lastPasswordChange,
    this.quotaUsage,
  });

  factory Mailbox.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for Mailbox: contains complex types',
    );
  }

  factory Mailbox.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Mailbox');
    return Mailbox(
      active: _$map[r'active'].decodeJsonBool(context: r'Mailbox.active'),
      address: _$map[r'address'].decodeJsonString(context: r'Mailbox.address'),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Mailbox.created_at',
      ),
      displayName: _$map[r'display_name'].decodeJsonString(
        context: r'Mailbox.display_name',
      ),
      domain: _$map[r'domain'] == null
          ? null
          : _i4.MailboxDomainOneOfModel.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'Mailbox.domain_id',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'Mailbox.id'),
      lastLoginAt: _$map[r'last_login_at'].decodeJsonNullableDateTime(
        context: r'Mailbox.last_login_at',
      ),
      lastPasswordChange: _$map[r'last_password_change']
          .decodeJsonNullableDateTime(context: r'Mailbox.last_password_change'),
      localPart: _$map[r'local_part'].decodeJsonString(
        context: r'Mailbox.local_part',
      ),
      passwordChangeRequired: _$map[r'password_change_required'].decodeJsonBool(
        context: r'Mailbox.password_change_required',
      ),
      quotaBytes: _$map[r'quota_bytes'].decodeJsonInt(
        context: r'Mailbox.quota_bytes',
      ),
      quotaUsage: _$map[r'quota_usage'] == null
          ? null
          : _i5.MailboxQuotaUsageOneOfModel.fromJson(_$map[r'quota_usage']),
      quotaUsedBytes: _$map[r'quota_used_bytes'].decodeJsonInt(
        context: r'Mailbox.quota_used_bytes',
      ),
      twoFactorRequired: _$map[r'two_factor_required'].decodeJsonBool(
        context: r'Mailbox.two_factor_required',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Mailbox.updated_at',
      ),
    );
  }

  factory Mailbox.fromForm(_i3.String? value, {required _i3.bool explode}) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for Mailbox: contains complex types',
    );
  }

  final _i3.bool active;

  final _i3.String address;

  final _i3.DateTime createdAt;

  final _i3.String displayName;

  final _i4.MailboxDomainOneOfModel? domain;

  final _i3.int domainId;

  final _i3.int id;

  final _i3.DateTime? lastLoginAt;

  final _i3.DateTime? lastPasswordChange;

  final _i3.String localPart;

  final _i3.bool passwordChangeRequired;

  final _i3.int quotaBytes;

  final _i5.MailboxQuotaUsageOneOfModel? quotaUsage;

  final _i3.int quotaUsedBytes;

  final _i3.bool twoFactorRequired;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'address': address,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'display_name': displayName,
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'id': id,
    r'last_login_at': lastLoginAt?.toTimeZonedIso8601String(),
    r'last_password_change': lastPasswordChange?.toTimeZonedIso8601String(),
    r'local_part': localPart,
    r'password_change_required': passwordChangeRequired,
    r'quota_bytes': quotaBytes,
    if (quotaUsage != null) r'quota_usage': quotaUsage?.toJson(),
    r'quota_used_bytes': quotaUsedBytes,
    r'two_factor_required': twoFactorRequired,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$MailboxCopyWith<Mailbox> get copyWith => _MailboxCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Mailbox &&
        other.active == this.active &&
        other.address == this.address &&
        other.createdAt == this.createdAt &&
        other.displayName == this.displayName &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.id == this.id &&
        other.lastLoginAt == this.lastLoginAt &&
        other.lastPasswordChange == this.lastPasswordChange &&
        other.localPart == this.localPart &&
        other.passwordChangeRequired == this.passwordChangeRequired &&
        other.quotaBytes == this.quotaBytes &&
        other.quotaUsage == this.quotaUsage &&
        other.quotaUsedBytes == this.quotaUsedBytes &&
        other.twoFactorRequired == this.twoFactorRequired &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      address,
      createdAt,
      displayName,
      domain,
      domainId,
      id,
      lastLoginAt,
      lastPasswordChange,
      localPart,
      passwordChangeRequired,
      quotaBytes,
      quotaUsage,
      quotaUsedBytes,
      twoFactorRequired,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for Mailbox: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode Mailbox: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MailboxCopyWith<$Res> {
  factory $$MailboxCopyWith(Mailbox value) = _MailboxCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.String? address,
    _i3.DateTime? createdAt,
    _i3.String? displayName,
    _i4.MailboxDomainOneOfModel? domain,
    _i3.int? domainId,
    _i3.int? id,
    _i3.DateTime? lastLoginAt,
    _i3.DateTime? lastPasswordChange,
    _i3.String? localPart,
    _i3.bool? passwordChangeRequired,
    _i3.int? quotaBytes,
    _i5.MailboxQuotaUsageOneOfModel? quotaUsage,
    _i3.int? quotaUsedBytes,
    _i3.bool? twoFactorRequired,
    _i3.DateTime? updatedAt,
  });
  _i3.bool get active;
  _i3.String get address;
  _i3.DateTime get createdAt;
  _i3.String get displayName;
  _i4.MailboxDomainOneOfModel? get domain;
  _i3.int get domainId;
  _i3.int get id;
  _i3.DateTime? get lastLoginAt;
  _i3.DateTime? get lastPasswordChange;
  _i3.String get localPart;
  _i3.bool get passwordChangeRequired;
  _i3.int get quotaBytes;
  _i5.MailboxQuotaUsageOneOfModel? get quotaUsage;
  _i3.int get quotaUsedBytes;
  _i3.bool get twoFactorRequired;
  _i3.DateTime get updatedAt;
}

class _MailboxCopyWith<$Res> implements $$MailboxCopyWith<$Res> {
  _MailboxCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Mailbox _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get displayName => _value.displayName;

  @_i3.override
  _i4.MailboxDomainOneOfModel? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.DateTime? get lastLoginAt => _value.lastLoginAt;

  @_i3.override
  _i3.DateTime? get lastPasswordChange => _value.lastPasswordChange;

  @_i3.override
  _i3.String get localPart => _value.localPart;

  @_i3.override
  _i3.bool get passwordChangeRequired => _value.passwordChangeRequired;

  @_i3.override
  _i3.int get quotaBytes => _value.quotaBytes;

  @_i3.override
  _i5.MailboxQuotaUsageOneOfModel? get quotaUsage => _value.quotaUsage;

  @_i3.override
  _i3.int get quotaUsedBytes => _value.quotaUsedBytes;

  @_i3.override
  _i3.bool get twoFactorRequired => _value.twoFactorRequired;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? address = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? lastLoginAt = _sentinel,
    _i3.Object? lastPasswordChange = _sentinel,
    _i3.Object? localPart = _sentinel,
    _i3.Object? passwordChangeRequired = _sentinel,
    _i3.Object? quotaBytes = _sentinel,
    _i3.Object? quotaUsage = _sentinel,
    _i3.Object? quotaUsedBytes = _sentinel,
    _i3.Object? twoFactorRequired = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Mailbox(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String),
      domain: _i3.identical(domain, _sentinel)
          ? this.domain
          : (domain as _i4.MailboxDomainOneOfModel?),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      lastLoginAt: _i3.identical(lastLoginAt, _sentinel)
          ? this.lastLoginAt
          : (lastLoginAt as _i3.DateTime?),
      lastPasswordChange: _i3.identical(lastPasswordChange, _sentinel)
          ? this.lastPasswordChange
          : (lastPasswordChange as _i3.DateTime?),
      localPart: _i3.identical(localPart, _sentinel)
          ? this.localPart
          : (localPart as _i3.String),
      passwordChangeRequired: _i3.identical(passwordChangeRequired, _sentinel)
          ? this.passwordChangeRequired
          : (passwordChangeRequired as _i3.bool),
      quotaBytes: _i3.identical(quotaBytes, _sentinel)
          ? this.quotaBytes
          : (quotaBytes as _i3.int),
      quotaUsage: _i3.identical(quotaUsage, _sentinel)
          ? this.quotaUsage
          : (quotaUsage as _i5.MailboxQuotaUsageOneOfModel?),
      quotaUsedBytes: _i3.identical(quotaUsedBytes, _sentinel)
          ? this.quotaUsedBytes
          : (quotaUsedBytes as _i3.int),
      twoFactorRequired: _i3.identical(twoFactorRequired, _sentinel)
          ? this.twoFactorRequired
          : (twoFactorRequired as _i3.bool),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
