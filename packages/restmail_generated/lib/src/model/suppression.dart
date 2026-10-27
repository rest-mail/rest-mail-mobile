// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/suppression_failure_category_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/suppression_reason_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Suppression extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const Suppression({
    required this.address,
    required this.createdAt,
    required this.domainId,
    required this.expiresAt,
    required this.failureCategory,
    required this.id,
    required this.lastError,
    required this.messageId,
    required this.reason,
    required this.updatedAt,
  });

  factory Suppression.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'address',
        r'created_at',
        r'domain_id',
        r'expires_at',
        r'failure_category',
        r'id',
        r'last_error',
        r'message_id',
        r'reason',
        r'updated_at',
      },
      listKeys: {},
      context: r'Suppression',
    );
    return Suppression(
      address: _$values[r'address'].decodeSimpleString(
        context: r'Suppression.address',
      ),
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'Suppression.created_at',
      ),
      domainId: _$values[r'domain_id'].decodeSimpleInt(
        context: r'Suppression.domain_id',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'Suppression.expires_at',
      ),
      failureCategory: _i4.SuppressionFailureCategoryModel.fromSimple(
        _$values[r'failure_category'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'Suppression.id'),
      lastError: _$values[r'last_error'].decodeSimpleString(
        context: r'Suppression.last_error',
      ),
      messageId: _$values[r'message_id'].decodeSimpleNullableInt(
        context: r'Suppression.message_id',
      ),
      reason: _i5.SuppressionReasonModel.fromSimple(
        _$values[r'reason'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeSimpleDateTime(
        context: r'Suppression.updated_at',
      ),
    );
  }

  factory Suppression.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Suppression');
    return Suppression(
      address: _$map[r'address'].decodeJsonString(
        context: r'Suppression.address',
      ),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Suppression.created_at',
      ),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'Suppression.domain_id',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'Suppression.expires_at',
      ),
      failureCategory: _i4.SuppressionFailureCategoryModel.fromJson(
        _$map[r'failure_category'],
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'Suppression.id'),
      lastError: _$map[r'last_error'].decodeJsonString(
        context: r'Suppression.last_error',
      ),
      messageId: _$map[r'message_id'].decodeJsonNullableInt(
        context: r'Suppression.message_id',
      ),
      reason: _i5.SuppressionReasonModel.fromJson(_$map[r'reason']),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'Suppression.updated_at',
      ),
    );
  }

  factory Suppression.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'address',
        r'created_at',
        r'domain_id',
        r'expires_at',
        r'failure_category',
        r'id',
        r'last_error',
        r'message_id',
        r'reason',
        r'updated_at',
      },
      listKeys: {},
      context: r'Suppression',
    );
    return Suppression(
      address: _$values[r'address'].decodeFormString(
        context: r'Suppression.address',
      ),
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'Suppression.created_at',
      ),
      domainId: _$values[r'domain_id'].decodeFormInt(
        context: r'Suppression.domain_id',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'Suppression.expires_at',
      ),
      failureCategory: _i4.SuppressionFailureCategoryModel.fromForm(
        _$values[r'failure_category'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeFormInt(context: r'Suppression.id'),
      lastError: _$values[r'last_error'].decodeFormString(
        context: r'Suppression.last_error',
      ),
      messageId: _$values[r'message_id'].decodeFormNullableInt(
        context: r'Suppression.message_id',
      ),
      reason: _i5.SuppressionReasonModel.fromForm(
        _$values[r'reason'],
        explode: explode,
      ),
      updatedAt: _$values[r'updated_at'].decodeFormDateTime(
        context: r'Suppression.updated_at',
      ),
    );
  }

  final _i3.String address;

  final _i3.DateTime createdAt;

  final _i3.int domainId;

  final _i3.DateTime expiresAt;

  final _i4.SuppressionFailureCategoryModel failureCategory;

  final _i3.int id;

  final _i3.String lastError;

  final _i3.int? messageId;

  final _i5.SuppressionReasonModel reason;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'domain_id': domainId,
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
    r'failure_category': failureCategory.toJson(),
    r'id': id,
    r'last_error': lastError,
    r'message_id': messageId,
    r'reason': reason.toJson(),
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$SuppressionCopyWith<Suppression> get copyWith => _SuppressionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Suppression &&
        other.address == this.address &&
        other.createdAt == this.createdAt &&
        other.domainId == this.domainId &&
        other.expiresAt == this.expiresAt &&
        other.failureCategory == this.failureCategory &&
        other.id == this.id &&
        other.lastError == this.lastError &&
        other.messageId == this.messageId &&
        other.reason == this.reason &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      address,
      createdAt,
      domainId,
      expiresAt,
      failureCategory,
      id,
      lastError,
      messageId,
      reason,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'domain_id'] = _i1.PropertyValue.scalar(domainId.toString());
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
    _$result[r'failure_category'] = _i1.PropertyValue.scalar(
      failureCategory.toJson(),
    );
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'last_error'] = _i1.PropertyValue.scalar(lastError);
    if (messageId != null) {
      _$result[r'message_id'] = _i1.PropertyValue.scalar(messageId!.toString());
    }
    _$result[r'reason'] = _i1.PropertyValue.scalar(reason.toJson());
    _$result[r'updated_at'] = _i1.PropertyValue.scalar(
      updatedAt.toTimeZonedIso8601String(),
    );
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
      r'Cannot uriEncode Suppression: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SuppressionCopyWith<$Res> {
  factory $$SuppressionCopyWith(Suppression value) = _SuppressionCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.DateTime? createdAt,
    _i3.int? domainId,
    _i3.DateTime? expiresAt,
    _i4.SuppressionFailureCategoryModel? failureCategory,
    _i3.int? id,
    _i3.String? lastError,
    _i3.int? messageId,
    _i5.SuppressionReasonModel? reason,
    _i3.DateTime? updatedAt,
  });
  _i3.String get address;
  _i3.DateTime get createdAt;
  _i3.int get domainId;
  _i3.DateTime get expiresAt;
  _i4.SuppressionFailureCategoryModel get failureCategory;
  _i3.int get id;
  _i3.String get lastError;
  _i3.int? get messageId;
  _i5.SuppressionReasonModel get reason;
  _i3.DateTime get updatedAt;
}

class _SuppressionCopyWith<$Res> implements $$SuppressionCopyWith<$Res> {
  _SuppressionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Suppression _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  _i4.SuppressionFailureCategoryModel get failureCategory =>
      _value.failureCategory;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get lastError => _value.lastError;

  @_i3.override
  _i3.int? get messageId => _value.messageId;

  @_i3.override
  _i5.SuppressionReasonModel get reason => _value.reason;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? failureCategory = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? lastError = _sentinel,
    _i3.Object? messageId = _sentinel,
    _i3.Object? reason = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (Suppression(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      domainId: _i3.identical(domainId, _sentinel)
          ? this.domainId
          : (domainId as _i3.int),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
      failureCategory: _i3.identical(failureCategory, _sentinel)
          ? this.failureCategory
          : (failureCategory as _i4.SuppressionFailureCategoryModel),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      lastError: _i3.identical(lastError, _sentinel)
          ? this.lastError
          : (lastError as _i3.String),
      messageId: _i3.identical(messageId, _sentinel)
          ? this.messageId
          : (messageId as _i3.int?),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i5.SuppressionReasonModel),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
