// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiKeyPermission extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ApiKeyPermission({this.capability, this.scope});

  factory ApiKeyPermission.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'capability', r'scope'},
      listKeys: {},
      context: r'ApiKeyPermission',
    );
    return ApiKeyPermission(
      capability: _$values[r'capability'].decodeSimpleNullableString(
        context: r'ApiKeyPermission.capability',
      ),
      scope: _$values[r'scope'].decodeSimpleNullableString(
        context: r'ApiKeyPermission.scope',
      ),
    );
  }

  factory ApiKeyPermission.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ApiKeyPermission');
    return ApiKeyPermission(
      capability: _$map[r'capability'].decodeJsonNullableString(
        context: r'ApiKeyPermission.capability',
      ),
      scope: _$map[r'scope'].decodeJsonNullableString(
        context: r'ApiKeyPermission.scope',
      ),
    );
  }

  factory ApiKeyPermission.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'capability', r'scope'},
      listKeys: {},
      context: r'ApiKeyPermission',
    );
    return ApiKeyPermission(
      capability: _$values[r'capability'].decodeFormNullableString(
        context: r'ApiKeyPermission.capability',
      ),
      scope: _$values[r'scope'].decodeFormNullableString(
        context: r'ApiKeyPermission.scope',
      ),
    );
  }

  final _i3.String? capability;

  final _i3.String? scope;

  @_i3.override
  _i3.Object? toJson() => {
    if (capability != null) r'capability': capability,
    if (scope != null) r'scope': scope,
  };

  $$ApiKeyPermissionCopyWith<ApiKeyPermission> get copyWith =>
      _ApiKeyPermissionCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ApiKeyPermission &&
        other.capability == this.capability &&
        other.scope == this.scope;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([capability, scope]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (capability != null) {
      _$result[r'capability'] = _i1.PropertyValue.scalar(capability!);
    }
    if (scope != null) {
      _$result[r'scope'] = _i1.PropertyValue.scalar(scope!);
    }
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
      r'Cannot uriEncode ApiKeyPermission: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiKeyPermissionCopyWith<$Res> {
  factory $$ApiKeyPermissionCopyWith(ApiKeyPermission value) =
      _ApiKeyPermissionCopyWith<$Res>;

  $Res call({_i3.String? capability, _i3.String? scope});
  _i3.String? get capability;
  _i3.String? get scope;
}

class _ApiKeyPermissionCopyWith<$Res>
    implements $$ApiKeyPermissionCopyWith<$Res> {
  _ApiKeyPermissionCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiKeyPermission _value;

  @_i3.override
  _i3.String? get capability => _value.capability;

  @_i3.override
  _i3.String? get scope => _value.scope;

  @_i3.override
  $Res call({
    _i3.Object? capability = _sentinel,
    _i3.Object? scope = _sentinel,
  }) {
    return (ApiKeyPermission(
      capability: _i3.identical(capability, _sentinel)
          ? this.capability
          : (capability as _i3.String?),
      scope: _i3.identical(scope, _sentinel)
          ? this.scope
          : (scope as _i3.String?),
    ) as $Res);
  }
}
