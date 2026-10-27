// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/grant_actor.dart' as _i5;
import 'package:restmail_generated/src/model/grant_holder.dart' as _i6;
import 'package:restmail_generated/src/model/grant_response_activation_one_of_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/grant_response_mode_model.dart'
    as _i7;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class GrantResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const GrantResponse({
    required this.activation,
    required this.expiresAt,
    required this.grantedAt,
    required this.grantedBy,
    required this.holder,
    required this.id,
    required this.mode,
    required this.role,
    required this.roleId,
    required this.scope,
  });

  factory GrantResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for GrantResponse: contains complex types',
    );
  }

  factory GrantResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'GrantResponse');
    return GrantResponse(
      activation: _$map[r'activation'] == null
          ? null
          : _i4.GrantResponseActivationOneOfModel.fromJson(
              _$map[r'activation'],
            ),
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'GrantResponse.expires_at',
      ),
      grantedAt: _$map[r'granted_at'].decodeJsonDateTime(
        context: r'GrantResponse.granted_at',
      ),
      grantedBy: _i5.GrantActor.fromJson(_$map[r'granted_by']),
      holder: _i6.GrantHolder.fromJson(_$map[r'holder']),
      id: _$map[r'id'].decodeJsonInt(context: r'GrantResponse.id'),
      mode: _i7.GrantResponseModeModel.fromJson(_$map[r'mode']),
      role: _$map[r'role'].decodeJsonString(context: r'GrantResponse.role'),
      roleId: _$map[r'role_id'].decodeJsonInt(
        context: r'GrantResponse.role_id',
      ),
      scope: _$map[r'scope'].decodeJsonString(context: r'GrantResponse.scope'),
    );
  }

  factory GrantResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for GrantResponse: contains complex types',
    );
  }

  final _i4.GrantResponseActivationOneOfModel activation;

  final _i3.DateTime? expiresAt;

  final _i3.DateTime grantedAt;

  final _i5.GrantActor grantedBy;

  final _i6.GrantHolder holder;

  final _i3.int id;

  final _i7.GrantResponseModeModel mode;

  final _i3.String role;

  final _i3.int roleId;

  final _i3.String scope;

  @_i3.override
  _i3.Object? toJson() => {
    r'activation': activation?.toJson(),
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    r'granted_at': grantedAt.toTimeZonedIso8601String(),
    r'granted_by': grantedBy.toJson(),
    r'holder': holder.toJson(),
    r'id': id,
    r'mode': mode.toJson(),
    r'role': role,
    r'role_id': roleId,
    r'scope': scope,
  };

  $$GrantResponseCopyWith<GrantResponse> get copyWith =>
      _GrantResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GrantResponse &&
        other.activation == this.activation &&
        other.expiresAt == this.expiresAt &&
        other.grantedAt == this.grantedAt &&
        other.grantedBy == this.grantedBy &&
        other.holder == this.holder &&
        other.id == this.id &&
        other.mode == this.mode &&
        other.role == this.role &&
        other.roleId == this.roleId &&
        other.scope == this.scope;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      activation,
      expiresAt,
      grantedAt,
      grantedBy,
      holder,
      id,
      mode,
      role,
      roleId,
      scope,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for GrantResponse: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode GrantResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$GrantResponseCopyWith<$Res> {
  factory $$GrantResponseCopyWith(GrantResponse value) =
      _GrantResponseCopyWith<$Res>;

  $Res call({
    _i4.GrantResponseActivationOneOfModel? activation,
    _i3.DateTime? expiresAt,
    _i3.DateTime? grantedAt,
    _i5.GrantActor? grantedBy,
    _i6.GrantHolder? holder,
    _i3.int? id,
    _i7.GrantResponseModeModel? mode,
    _i3.String? role,
    _i3.int? roleId,
    _i3.String? scope,
  });
  _i4.GrantResponseActivationOneOfModel get activation;
  _i3.DateTime? get expiresAt;
  _i3.DateTime get grantedAt;
  _i5.GrantActor get grantedBy;
  _i6.GrantHolder get holder;
  _i3.int get id;
  _i7.GrantResponseModeModel get mode;
  _i3.String get role;
  _i3.int get roleId;
  _i3.String get scope;
}

class _GrantResponseCopyWith<$Res> implements $$GrantResponseCopyWith<$Res> {
  _GrantResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final GrantResponse _value;

  @_i3.override
  _i4.GrantResponseActivationOneOfModel get activation => _value.activation;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i3.DateTime get grantedAt => _value.grantedAt;

  @_i3.override
  _i5.GrantActor get grantedBy => _value.grantedBy;

  @_i3.override
  _i6.GrantHolder get holder => _value.holder;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i7.GrantResponseModeModel get mode => _value.mode;

  @_i3.override
  _i3.String get role => _value.role;

  @_i3.override
  _i3.int get roleId => _value.roleId;

  @_i3.override
  _i3.String get scope => _value.scope;

  @_i3.override
  $Res call({
    _i3.Object? activation = _sentinel,
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? grantedAt = _sentinel,
    _i3.Object? grantedBy = _sentinel,
    _i3.Object? holder = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? mode = _sentinel,
    _i3.Object? role = _sentinel,
    _i3.Object? roleId = _sentinel,
    _i3.Object? scope = _sentinel,
  }) {
    return (GrantResponse(
      activation: _i3.identical(activation, _sentinel)
          ? this.activation
          : (activation as _i4.GrantResponseActivationOneOfModel),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      grantedAt: _i3.identical(grantedAt, _sentinel)
          ? this.grantedAt
          : (grantedAt as _i3.DateTime),
      grantedBy: _i3.identical(grantedBy, _sentinel)
          ? this.grantedBy
          : (grantedBy as _i5.GrantActor),
      holder: _i3.identical(holder, _sentinel)
          ? this.holder
          : (holder as _i6.GrantHolder),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
      mode: _i3.identical(mode, _sentinel)
          ? this.mode
          : (mode as _i7.GrantResponseModeModel),
      role: _i3.identical(role, _sentinel) ? this.role : (role as _i3.String),
      roleId: _i3.identical(roleId, _sentinel)
          ? this.roleId
          : (roleId as _i3.int),
      scope: _i3.identical(scope, _sentinel)
          ? this.scope
          : (scope as _i3.String),
    ) as $Res);
  }
}
