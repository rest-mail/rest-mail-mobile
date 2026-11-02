// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RegisterRecoveryEmailRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RegisterRecoveryEmailRequest({
    required this.currentPassword,
    required this.email,
  });

  factory RegisterRecoveryEmailRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'current_password', r'email'},
      listKeys: {},
      context: r'RegisterRecoveryEmailRequest',
    );
    return RegisterRecoveryEmailRequest(
      currentPassword: _$values[r'current_password'].decodeSimpleString(
        context: r'RegisterRecoveryEmailRequest.current_password',
      ),
      email: _$values[r'email'].decodeSimpleString(
        context: r'RegisterRecoveryEmailRequest.email',
      ),
    );
  }

  factory RegisterRecoveryEmailRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RegisterRecoveryEmailRequest');
    return RegisterRecoveryEmailRequest(
      currentPassword: _$map[r'current_password'].decodeJsonString(
        context: r'RegisterRecoveryEmailRequest.current_password',
      ),
      email: _$map[r'email'].decodeJsonString(
        context: r'RegisterRecoveryEmailRequest.email',
      ),
    );
  }

  factory RegisterRecoveryEmailRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'current_password', r'email'},
      listKeys: {},
      context: r'RegisterRecoveryEmailRequest',
    );
    return RegisterRecoveryEmailRequest(
      currentPassword: _$values[r'current_password'].decodeFormString(
        context: r'RegisterRecoveryEmailRequest.current_password',
      ),
      email: _$values[r'email'].decodeFormString(
        context: r'RegisterRecoveryEmailRequest.email',
      ),
    );
  }

  final _i3.String currentPassword;

  final _i3.String email;

  @_i3.override
  _i3.Object? toJson() => {
    r'current_password': currentPassword,
    r'email': email,
  };

  $$RegisterRecoveryEmailRequestCopyWith<RegisterRecoveryEmailRequest>
  get copyWith => _RegisterRecoveryEmailRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RegisterRecoveryEmailRequest &&
        other.currentPassword == this.currentPassword &&
        other.email == this.email;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([currentPassword, email]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'current_password'] = _i1.PropertyValue.scalar(currentPassword);
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
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
      r'Cannot uriEncode RegisterRecoveryEmailRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RegisterRecoveryEmailRequestCopyWith<$Res> {
  factory $$RegisterRecoveryEmailRequestCopyWith(
    RegisterRecoveryEmailRequest value,
  ) = _RegisterRecoveryEmailRequestCopyWith<$Res>;

  $Res call({_i3.String? currentPassword, _i3.String? email});
  _i3.String get currentPassword;
  _i3.String get email;
}

class _RegisterRecoveryEmailRequestCopyWith<$Res>
    implements $$RegisterRecoveryEmailRequestCopyWith<$Res> {
  _RegisterRecoveryEmailRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RegisterRecoveryEmailRequest _value;

  @_i3.override
  _i3.String get currentPassword => _value.currentPassword;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  $Res call({
    _i3.Object? currentPassword = _sentinel,
    _i3.Object? email = _sentinel,
  }) {
    return (RegisterRecoveryEmailRequest(
      currentPassword: _i3.identical(currentPassword, _sentinel)
          ? this.currentPassword
          : (currentPassword as _i3.String),
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
    ) as $Res);
  }
}
