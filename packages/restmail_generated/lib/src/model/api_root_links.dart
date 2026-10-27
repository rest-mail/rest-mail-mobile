// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ApiRootLinks extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ApiRootLinks({
    required this.docs,
    required this.health,
    required this.login,
  });

  factory ApiRootLinks.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'docs', r'health', r'login'},
      listKeys: {},
      context: r'ApiRootLinks',
    );
    return ApiRootLinks(
      docs: _$values[r'docs'].decodeSimpleString(context: r'ApiRootLinks.docs'),
      health: _$values[r'health'].decodeSimpleString(
        context: r'ApiRootLinks.health',
      ),
      login: _$values[r'login'].decodeSimpleString(
        context: r'ApiRootLinks.login',
      ),
    );
  }

  factory ApiRootLinks.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ApiRootLinks');
    return ApiRootLinks(
      docs: _$map[r'docs'].decodeJsonString(context: r'ApiRootLinks.docs'),
      health: _$map[r'health'].decodeJsonString(
        context: r'ApiRootLinks.health',
      ),
      login: _$map[r'login'].decodeJsonString(context: r'ApiRootLinks.login'),
    );
  }

  factory ApiRootLinks.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'docs', r'health', r'login'},
      listKeys: {},
      context: r'ApiRootLinks',
    );
    return ApiRootLinks(
      docs: _$values[r'docs'].decodeFormString(context: r'ApiRootLinks.docs'),
      health: _$values[r'health'].decodeFormString(
        context: r'ApiRootLinks.health',
      ),
      login: _$values[r'login'].decodeFormString(
        context: r'ApiRootLinks.login',
      ),
    );
  }

  final _i3.String docs;

  final _i3.String health;

  final _i3.String login;

  @_i3.override
  _i3.Object? toJson() => {r'docs': docs, r'health': health, r'login': login};

  $$ApiRootLinksCopyWith<ApiRootLinks> get copyWith =>
      _ApiRootLinksCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ApiRootLinks &&
        other.docs == this.docs &&
        other.health == this.health &&
        other.login == this.login;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([docs, health, login]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'docs'] = _i1.PropertyValue.scalar(docs);
    _$result[r'health'] = _i1.PropertyValue.scalar(health);
    _$result[r'login'] = _i1.PropertyValue.scalar(login);
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
      r'Cannot uriEncode ApiRootLinks: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ApiRootLinksCopyWith<$Res> {
  factory $$ApiRootLinksCopyWith(ApiRootLinks value) =
      _ApiRootLinksCopyWith<$Res>;

  $Res call({_i3.String? docs, _i3.String? health, _i3.String? login});
  _i3.String get docs;
  _i3.String get health;
  _i3.String get login;
}

class _ApiRootLinksCopyWith<$Res> implements $$ApiRootLinksCopyWith<$Res> {
  _ApiRootLinksCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ApiRootLinks _value;

  @_i3.override
  _i3.String get docs => _value.docs;

  @_i3.override
  _i3.String get health => _value.health;

  @_i3.override
  _i3.String get login => _value.login;

  @_i3.override
  $Res call({
    _i3.Object? docs = _sentinel,
    _i3.Object? health = _sentinel,
    _i3.Object? login = _sentinel,
  }) {
    return (ApiRootLinks(
      docs: _i3.identical(docs, _sentinel) ? this.docs : (docs as _i3.String),
      health: _i3.identical(health, _sentinel)
          ? this.health
          : (health as _i3.String),
      login: _i3.identical(login, _sentinel)
          ? this.login
          : (login as _i3.String),
    ) as $Res);
  }
}
