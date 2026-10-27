// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/create_grant_request_holder_one_of_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CreateGrantRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CreateGrantRequest({
    this.expiresAt,
    this.holder,
    this.mode,
    this.role,
    this.scope,
  });

  factory CreateGrantRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CreateGrantRequest: contains complex types',
    );
  }

  factory CreateGrantRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CreateGrantRequest');
    return CreateGrantRequest(
      expiresAt: _$map[r'expires_at'].decodeJsonNullableDateTime(
        context: r'CreateGrantRequest.expires_at',
      ),
      holder: _$map[r'holder'] == null
          ? null
          : _i4.CreateGrantRequestHolderOneOfModel.fromJson(_$map[r'holder']),
      mode: _$map[r'mode'].decodeJsonNullableString(
        context: r'CreateGrantRequest.mode',
      ),
      role: _$map[r'role'].decodeJsonNullableString(
        context: r'CreateGrantRequest.role',
      ),
      scope: _$map[r'scope'].decodeJsonNullableString(
        context: r'CreateGrantRequest.scope',
      ),
    );
  }

  factory CreateGrantRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CreateGrantRequest: contains complex types',
    );
  }

  final _i3.DateTime? expiresAt;

  final _i4.CreateGrantRequestHolderOneOfModel? holder;

  final _i3.String? mode;

  final _i3.String? role;

  final _i3.String? scope;

  @_i3.override
  _i3.Object? toJson() => {
    r'expires_at': expiresAt?.toTimeZonedIso8601String(),
    if (holder != null) r'holder': holder?.toJson(),
    if (mode != null) r'mode': mode,
    if (role != null) r'role': role,
    if (scope != null) r'scope': scope,
  };

  $$CreateGrantRequestCopyWith<CreateGrantRequest> get copyWith =>
      _CreateGrantRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateGrantRequest &&
        other.expiresAt == this.expiresAt &&
        other.holder == this.holder &&
        other.mode == this.mode &&
        other.role == this.role &&
        other.scope == this.scope;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([expiresAt, holder, mode, role, scope]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CreateGrantRequest: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CreateGrantRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$CreateGrantRequestCopyWith<$Res> {
  factory $$CreateGrantRequestCopyWith(CreateGrantRequest value) =
      _CreateGrantRequestCopyWith<$Res>;

  $Res call({
    _i3.DateTime? expiresAt,
    _i4.CreateGrantRequestHolderOneOfModel? holder,
    _i3.String? mode,
    _i3.String? role,
    _i3.String? scope,
  });
  _i3.DateTime? get expiresAt;
  _i4.CreateGrantRequestHolderOneOfModel? get holder;
  _i3.String? get mode;
  _i3.String? get role;
  _i3.String? get scope;
}

class _CreateGrantRequestCopyWith<$Res>
    implements $$CreateGrantRequestCopyWith<$Res> {
  _CreateGrantRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final CreateGrantRequest _value;

  @_i3.override
  _i3.DateTime? get expiresAt => _value.expiresAt;

  @_i3.override
  _i4.CreateGrantRequestHolderOneOfModel? get holder => _value.holder;

  @_i3.override
  _i3.String? get mode => _value.mode;

  @_i3.override
  _i3.String? get role => _value.role;

  @_i3.override
  _i3.String? get scope => _value.scope;

  @_i3.override
  $Res call({
    _i3.Object? expiresAt = _sentinel,
    _i3.Object? holder = _sentinel,
    _i3.Object? mode = _sentinel,
    _i3.Object? role = _sentinel,
    _i3.Object? scope = _sentinel,
  }) {
    return (CreateGrantRequest(
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime?),
      holder: _i3.identical(holder, _sentinel)
          ? this.holder
          : (holder as _i4.CreateGrantRequestHolderOneOfModel?),
      mode: _i3.identical(mode, _sentinel) ? this.mode : (mode as _i3.String?),
      role: _i3.identical(role, _sentinel) ? this.role : (role as _i3.String?),
      scope: _i3.identical(scope, _sentinel)
          ? this.scope
          : (scope as _i3.String?),
    ) as $Res);
  }
}
