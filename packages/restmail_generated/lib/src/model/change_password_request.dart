// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ChangePasswordRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'current_password', r'new_password'},
      listKeys: {},
      context: r'ChangePasswordRequest',
    );
    return ChangePasswordRequest(
      currentPassword: _$values[r'current_password'].decodeSimpleString(
        context: r'ChangePasswordRequest.current_password',
      ),
      newPassword: _$values[r'new_password'].decodeSimpleString(
        context: r'ChangePasswordRequest.new_password',
      ),
    );
  }

  factory ChangePasswordRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ChangePasswordRequest');
    return ChangePasswordRequest(
      currentPassword: _$map[r'current_password'].decodeJsonString(
        context: r'ChangePasswordRequest.current_password',
      ),
      newPassword: _$map[r'new_password'].decodeJsonString(
        context: r'ChangePasswordRequest.new_password',
      ),
    );
  }

  factory ChangePasswordRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'current_password', r'new_password'},
      listKeys: {},
      context: r'ChangePasswordRequest',
    );
    return ChangePasswordRequest(
      currentPassword: _$values[r'current_password'].decodeFormString(
        context: r'ChangePasswordRequest.current_password',
      ),
      newPassword: _$values[r'new_password'].decodeFormString(
        context: r'ChangePasswordRequest.new_password',
      ),
    );
  }

  final _i3.String currentPassword;

  final _i3.String newPassword;

  @_i3.override
  _i3.Object? toJson() => {
    r'current_password': currentPassword,
    r'new_password': newPassword,
  };

  $$ChangePasswordRequestCopyWith<ChangePasswordRequest> get copyWith =>
      _ChangePasswordRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePasswordRequest &&
        other.currentPassword == this.currentPassword &&
        other.newPassword == this.newPassword;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([currentPassword, newPassword]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'current_password'] = _i1.PropertyValue.scalar(currentPassword);
    _$result[r'new_password'] = _i1.PropertyValue.scalar(newPassword);
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
      r'Cannot uriEncode ChangePasswordRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ChangePasswordRequestCopyWith<$Res> {
  factory $$ChangePasswordRequestCopyWith(ChangePasswordRequest value) =
      _ChangePasswordRequestCopyWith<$Res>;

  $Res call({_i3.String? currentPassword, _i3.String? newPassword});
  _i3.String get currentPassword;
  _i3.String get newPassword;
}

class _ChangePasswordRequestCopyWith<$Res>
    implements $$ChangePasswordRequestCopyWith<$Res> {
  _ChangePasswordRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ChangePasswordRequest _value;

  @_i3.override
  _i3.String get currentPassword => _value.currentPassword;

  @_i3.override
  _i3.String get newPassword => _value.newPassword;

  @_i3.override
  $Res call({
    _i3.Object? currentPassword = _sentinel,
    _i3.Object? newPassword = _sentinel,
  }) {
    return (ChangePasswordRequest(
      currentPassword: _i3.identical(currentPassword, _sentinel)
          ? this.currentPassword
          : (currentPassword as _i3.String),
      newPassword: _i3.identical(newPassword, _sentinel)
          ? this.newPassword
          : (newPassword as _i3.String),
    ) as $Res);
  }
}
