// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class UserInfo extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const UserInfo({
    required this.displayName,
    required this.email,
    required this.id,
  });

  factory UserInfo.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'display_name', r'email', r'id'},
      listKeys: {},
      context: r'UserInfo',
    );
    return UserInfo(
      displayName: _$values[r'display_name'].decodeSimpleString(
        context: r'UserInfo.display_name',
      ),
      email: _$values[r'email'].decodeSimpleString(context: r'UserInfo.email'),
      id: _$values[r'id'].decodeSimpleInt(context: r'UserInfo.id'),
    );
  }

  factory UserInfo.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'UserInfo');
    return UserInfo(
      displayName: _$map[r'display_name'].decodeJsonString(
        context: r'UserInfo.display_name',
      ),
      email: _$map[r'email'].decodeJsonString(context: r'UserInfo.email'),
      id: _$map[r'id'].decodeJsonInt(context: r'UserInfo.id'),
    );
  }

  factory UserInfo.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'display_name', r'email', r'id'},
      listKeys: {},
      context: r'UserInfo',
    );
    return UserInfo(
      displayName: _$values[r'display_name'].decodeFormString(
        context: r'UserInfo.display_name',
      ),
      email: _$values[r'email'].decodeFormString(context: r'UserInfo.email'),
      id: _$values[r'id'].decodeFormInt(context: r'UserInfo.id'),
    );
  }

  final _i3.String displayName;

  final _i3.String email;

  final _i3.int id;

  @_i3.override
  _i3.Object? toJson() => {
    r'display_name': displayName,
    r'email': email,
    r'id': id,
  };

  $$UserInfoCopyWith<UserInfo> get copyWith => _UserInfoCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UserInfo &&
        other.displayName == this.displayName &&
        other.email == this.email &&
        other.id == this.id;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([displayName, email, id]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'display_name'] = _i1.PropertyValue.scalar(displayName);
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    _$result[r'id'] = _i1.PropertyValue.scalar(id.toString());
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
      r'Cannot uriEncode UserInfo: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$UserInfoCopyWith<$Res> {
  factory $$UserInfoCopyWith(UserInfo value) = _UserInfoCopyWith<$Res>;

  $Res call({_i3.String? displayName, _i3.String? email, _i3.int? id});
  _i3.String get displayName;
  _i3.String get email;
  _i3.int get id;
}

class _UserInfoCopyWith<$Res> implements $$UserInfoCopyWith<$Res> {
  _UserInfoCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final UserInfo _value;

  @_i3.override
  _i3.String get displayName => _value.displayName;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.int get id => _value.id;

  @_i3.override
  $Res call({
    _i3.Object? displayName = _sentinel,
    _i3.Object? email = _sentinel,
    _i3.Object? id = _sentinel,
  }) {
    return (UserInfo(
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String),
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int),
    ) as $Res);
  }
}
