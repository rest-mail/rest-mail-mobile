// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/ban_protocol_model.dart' as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Ban extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Ban({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.ip,
    required this.protocol,
    required this.reason,
    this.expiresAt,
  });

  factory Ban.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'created_at',
        r'created_by',
        r'expires_at',
        r'id',
        r'ip',
        r'protocol',
        r'reason',
      },
      listKeys: {},
      context: r'Ban',
    );
    return Ban(
      createdAt: _$values[r'created_at'].decodeSimpleDateTime(
        context: r'Ban.created_at',
      ),
      createdBy: _$values[r'created_by'].decodeSimpleString(
        context: r'Ban.created_by',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleNullableDateTime(
        context: r'Ban.expires_at',
      ),
      id: _$values[r'id'].decodeSimpleInt(context: r'Ban.id'),
      ip: _$values[r'ip'].decodeSimpleString(context: r'Ban.ip'),
      protocol: _i4.BanProtocolModel.fromSimple(
        _$values[r'protocol'],
        explode: explode,
      ),
      reason: _$values[r'reason'].decodeSimpleString(context: r'Ban.reason'),
    );
  }

  factory Ban.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Ban');
    return Ban(
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'Ban.created_at',
      ),
      createdBy: _$map[r'created_by'].decodeJsonString(
        context: r'Ban.created_by',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'Ban.expires_at',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'Ban.id'),
      ip: _$map[r'ip'].decodeJsonString(context: r'Ban.ip'),
      protocol: _i4.BanProtocolModel.fromJson(_$map[r'protocol']),
      reason: _$map[r'reason'].decodeJsonString(context: r'Ban.reason'),
    );
  }

  factory Ban.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'created_at',
        r'created_by',
        r'expires_at',
        r'id',
        r'ip',
        r'protocol',
        r'reason',
      },
      listKeys: {},
      context: r'Ban',
    );
    return Ban(
      createdAt: _$values[r'created_at'].decodeFormDateTime(
        context: r'Ban.created_at',
      ),
      createdBy: _$values[r'created_by'].decodeFormString(
        context: r'Ban.created_by',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormNullableDateTime(
        context: r'Ban.expires_at',
      ),
      id: _$values[r'id'].decodeFormInt(context: r'Ban.id'),
      ip: _$values[r'ip'].decodeFormString(context: r'Ban.ip'),
      protocol: _i4.BanProtocolModel.fromForm(
        _$values[r'protocol'],
        explode: explode,
      ),
      reason: _$values[r'reason'].decodeFormString(context: r'Ban.reason'),
    );
  }

  final _i3.DateTime createdAt;

  final _i3.String createdBy;

  final _i3.DateTime? expiresAt;

  final _i3.int id;

  final _i3.String ip;

  final _i4.BanProtocolModel protocol;

  final _i3.String reason;

  @_i3.override
  _i3.Object? toJson() => {
    r'created_at': createdAt.toTimeZonedIso8601String(),
    r'created_by': createdBy,
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'id': id,
    r'ip': ip,
    r'protocol': protocol.toJson(),
    r'reason': reason,
  };

  $$BanCopyWith<Ban> get copyWith => _BanCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Ban &&
        other.createdAt == this.createdAt &&
        other.createdBy == this.createdBy &&
        other.expiresAt == this.expiresAt &&
        other.id == this.id &&
        other.ip == this.ip &&
        other.protocol == this.protocol &&
        other.reason == this.reason;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      createdAt,
      createdBy,
      expiresAt,
      id,
      ip,
      protocol,
      reason,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'created_at'] = _i1.PropertyValue.scalar(
      createdAt.toTimeZonedIso8601String(),
    );
    _$result[r'created_by'] = _i1.PropertyValue.scalar(createdBy);
    if (expiresAt != null) {
      _$result[r'expires_at'] = _i1.PropertyValue.scalar(
        expiresAt!.toTimeZonedIso8601String(),
      );
    }
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
    _$result[r'ip'] = _i1.PropertyValue.scalar(ip);
    _$result[r'protocol'] = _i1.PropertyValue.scalar(protocol.toJson());
    _$result[r'reason'] = _i1.PropertyValue.scalar(reason);
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
      r'Cannot uriEncode Ban: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$BanCopyWith<$Res> {
  factory $$BanCopyWith(Ban value) = _BanCopyWith<$Res>;

  $Res call({
    _i3.DateTime? createdAt,
    _i3.String? createdBy,
    _i3.DateTime? expiresAt,
    _i3.int? id,
    _i3.String? ip,
    _i4.BanProtocolModel? protocol,
    _i3.String? reason,
  });
  _i3.DateTime get createdAt;
  _i3.String get createdBy;
  _i3.DateTime? get expiresAt;
  _i3.int get id;
  _i3.String get ip;
  _i4.BanProtocolModel get protocol;
  _i3.String get reason;
}

class _BanCopyWith<$Res> implements $$BanCopyWith<$Res> {
  _BanCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Ban _value;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i3.String get createdBy => _value.createdBy;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.String get ip => _value.ip;

  @_i3.override
  _i4.BanProtocolModel get protocol => _value.protocol;

  @_i3.override
  _i3.String get reason => _value.reason;

  @_i3.override
  $Res call({
    _i3.Object? createdAt = _sentinel,
    _i3.Object? createdBy = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? ip = _sentinel,
    _i3.Object? protocol = _sentinel,
    _i3.Object? reason = _sentinel,
  }) {
    return (Ban(
      createdAt: _i3.identical(createdAt, _sentinel)
          ? this.createdAt
          : (createdAt as _i3.DateTime),
      createdBy: _i3.identical(createdBy, _sentinel)
          ? this.createdBy
          : (createdBy as _i3.String),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String),
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol as _i4.BanProtocolModel),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String),
    ) as $Res);
  }
}
