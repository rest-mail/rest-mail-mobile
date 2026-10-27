// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/domain.dart' as _i4;
import 'package:restmail_generated/src/model/mtasts_policy_mode_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class MtastsPolicy extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const MtastsPolicy({
    required this.active,
    required this.createdAt,
    required this.domainId,
    required this.id,
    required this.maxAge,
    required this.mode,
    required this.mxHosts,
    required this.updatedAt,
    this.domain,
  });

  factory MtastsPolicy.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for MtastsPolicy: contains complex types',
    );
  }

  factory MtastsPolicy.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'MtastsPolicy');
    return MtastsPolicy(
      active: _$map[r'active'].decodeJsonBool(context: r'MtastsPolicy.active'),
      createdAt: _$map[r'created_at'].decodeJsonDateTime(
        context: r'MtastsPolicy.created_at',
      ),
      domain: _$map[r'domain'] == null
          ? null
          : _i4.Domain.fromJson(_$map[r'domain']),
      domainId: _$map[r'domain_id'].decodeJsonInt(
        context: r'MtastsPolicy.domain_id',
      ),
      id: _$map[r'id'].decodeJsonInt(context: r'MtastsPolicy.id'),
      maxAge: _$map[r'max_age'].decodeJsonInt(context: r'MtastsPolicy.max_age'),
      mode: _i5.MtastsPolicyModeModel.fromJson(_$map[r'mode']),
      mxHosts: _$map[r'mx_hosts'].decodeJsonString(
        context: r'MtastsPolicy.mx_hosts',
      ),
      updatedAt: _$map[r'updated_at'].decodeJsonDateTime(
        context: r'MtastsPolicy.updated_at',
      ),
    );
  }

  factory MtastsPolicy.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for MtastsPolicy: contains complex types',
    );
  }

  final _i3.bool active;

  final _i3.DateTime createdAt;

  final _i4.Domain? domain;

  final _i3.int domainId;

  final _i3.int id;

  final _i3.int maxAge;

  final _i5.MtastsPolicyModeModel mode;

  final _i3.String mxHosts;

  final _i3.DateTime updatedAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'active': active,
    r'created_at': createdAt.toTimeZonedIso8601String(),
    if (domain != null) r'domain': domain?.toJson(),
    r'domain_id': domainId,
    r'id': id,
    r'max_age': maxAge,
    r'mode': mode.toJson(),
    r'mx_hosts': mxHosts,
    r'updated_at': updatedAt.toTimeZonedIso8601String(),
  };

  $$MtastsPolicyCopyWith<MtastsPolicy> get copyWith =>
      _MtastsPolicyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MtastsPolicy &&
        other.active == this.active &&
        other.createdAt == this.createdAt &&
        other.domain == this.domain &&
        other.domainId == this.domainId &&
        other.id == this.id &&
        other.maxAge == this.maxAge &&
        other.mode == this.mode &&
        other.mxHosts == this.mxHosts &&
        other.updatedAt == this.updatedAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      active,
      createdAt,
      domain,
      domainId,
      id,
      maxAge,
      mode,
      mxHosts,
      updatedAt,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for MtastsPolicy: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode MtastsPolicy: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MtastsPolicyCopyWith<$Res> {
  factory $$MtastsPolicyCopyWith(MtastsPolicy value) =
      _MtastsPolicyCopyWith<$Res>;

  $Res call({
    _i3.bool? active,
    _i3.DateTime? createdAt,
    _i4.Domain? domain,
    _i3.int? domainId,
    _i3.int? id,
    _i3.int? maxAge,
    _i5.MtastsPolicyModeModel? mode,
    _i3.String? mxHosts,
    _i3.DateTime? updatedAt,
  });
  _i3.bool get active;
  _i3.DateTime get createdAt;
  _i4.Domain? get domain;
  _i3.int get domainId;
  _i3.int get id;
  _i3.int get maxAge;
  _i5.MtastsPolicyModeModel get mode;
  _i3.String get mxHosts;
  _i3.DateTime get updatedAt;
}

class _MtastsPolicyCopyWith<$Res> implements $$MtastsPolicyCopyWith<$Res> {
  _MtastsPolicyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final MtastsPolicy _value;

  @_i3.override
  _i3.bool get active => _value.active;

  @_i3.override
  _i3.DateTime get createdAt => _value.createdAt;

  @_i3.override
  _i4.Domain? get domain => _value.domain;

  @_i3.override
  _i3.int get domainId => _value.domainId;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  _i3.int get maxAge => _value.maxAge;

  @_i3.override
  _i5.MtastsPolicyModeModel get mode => _value.mode;

  @_i3.override
  _i3.String get mxHosts => _value.mxHosts;

  @_i3.override
  _i3.DateTime get updatedAt => _value.updatedAt;

  @_i3.override
  $Res call({
    _i3.Object? active = _sentinel,
    _i3.Object? createdAt = _sentinel,
    _i3.Object? domain = _sentinel,
    _i3.Object? domainId = _sentinel,
    _i3.Object? id = _sentinel,
    _i3.Object? maxAge = _sentinel,
    _i3.Object? mode = _sentinel,
    _i3.Object? mxHosts = _sentinel,
    _i3.Object? updatedAt = _sentinel,
  }) {
    return (MtastsPolicy(
      active: _i3.identical(active, _sentinel)
          ? this.active
          : (active as _i3.bool),
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
      maxAge: _i3.identical(maxAge, _sentinel)
          ? this.maxAge
          : (maxAge as _i3.int),
      mode: _i3.identical(mode, _sentinel)
          ? this.mode
          : (mode as _i5.MtastsPolicyModeModel),
      mxHosts: _i3.identical(mxHosts, _sentinel)
          ? this.mxHosts
          : (mxHosts as _i3.String),
      updatedAt: _i3.identical(updatedAt, _sentinel)
          ? this.updatedAt
          : (updatedAt as _i3.DateTime),
    ) as $Res);
  }
}
