// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/login_request_client_model.dart'
    as _i4;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoginRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoginRequest({
    required this.email,
    required this.password,
    this.client,
    this.recoveryCode,
    this.totpCode,
  });

  factory LoginRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'client',
        r'email',
        r'password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'LoginRequest',
    );
    return LoginRequest(
      client: _$values[r'client'] == null
          ? null
          : _i4.LoginRequestClientModel.fromSimple(
              _$values[r'client'],
              explode: explode,
            ),
      email: _$values[r'email'].decodeSimpleString(
        context: r'LoginRequest.email',
      ),
      password: _$values[r'password'].decodeSimpleString(
        context: r'LoginRequest.password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeSimpleNullableString(
        context: r'LoginRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeSimpleNullableString(
        context: r'LoginRequest.totp_code',
      ),
    );
  }

  factory LoginRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LoginRequest');
    return LoginRequest(
      client: _$map[r'client'] == null
          ? null
          : _i4.LoginRequestClientModel.fromJson(_$map[r'client']),
      email: _$map[r'email'].decodeJsonString(context: r'LoginRequest.email'),
      password: _$map[r'password'].decodeJsonString(
        context: r'LoginRequest.password',
      ),
      recoveryCode: _$map[r'recovery_code'].decodeJsonNullableString(
        context: r'LoginRequest.recovery_code',
      ),
      totpCode: _$map[r'totp_code'].decodeJsonNullableString(
        context: r'LoginRequest.totp_code',
      ),
    );
  }

  factory LoginRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'client',
        r'email',
        r'password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'LoginRequest',
    );
    return LoginRequest(
      client: _$values[r'client'] == null
          ? null
          : _i4.LoginRequestClientModel.fromForm(
              _$values[r'client'],
              explode: explode,
            ),
      email: _$values[r'email'].decodeFormString(
        context: r'LoginRequest.email',
      ),
      password: _$values[r'password'].decodeFormString(
        context: r'LoginRequest.password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeFormNullableString(
        context: r'LoginRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeFormNullableString(
        context: r'LoginRequest.totp_code',
      ),
    );
  }

  final _i4.LoginRequestClientModel? client;

  final _i3.String email;

  final _i3.String password;

  final _i3.String? recoveryCode;

  final _i3.String? totpCode;

  @_i3.override
  _i3.Object? toJson() => {
    if (client != null) r'client': client?.toJson(),
    r'email': email,
    r'password': password,
    if (recoveryCode != null) r'recovery_code': recoveryCode,
    if (totpCode != null) r'totp_code': totpCode,
  };

  $$LoginRequestCopyWith<LoginRequest> get copyWith =>
      _LoginRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoginRequest &&
        other.client == this.client &&
        other.email == this.email &&
        other.password == this.password &&
        other.recoveryCode == this.recoveryCode &&
        other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      client,
      email,
      password,
      recoveryCode,
      totpCode,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (client != null) {
      _$result[r'client'] = _i1.PropertyValue.scalar(client!.toJson());
    }
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    _$result[r'password'] = _i1.PropertyValue.scalar(password);
    if (recoveryCode != null) {
      _$result[r'recovery_code'] = _i1.PropertyValue.scalar(recoveryCode!);
    }
    if (totpCode != null) {
      _$result[r'totp_code'] = _i1.PropertyValue.scalar(totpCode!);
    }
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
      r'Cannot uriEncode LoginRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$LoginRequestCopyWith<$Res> {
  factory $$LoginRequestCopyWith(LoginRequest value) =
      _LoginRequestCopyWith<$Res>;

  $Res call({
    _i4.LoginRequestClientModel? client,
    _i3.String? email,
    _i3.String? password,
    _i3.String? recoveryCode,
    _i3.String? totpCode,
  });
  _i4.LoginRequestClientModel? get client;
  _i3.String get email;
  _i3.String get password;
  _i3.String? get recoveryCode;
  _i3.String? get totpCode;
}

class _LoginRequestCopyWith<$Res> implements $$LoginRequestCopyWith<$Res> {
  _LoginRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final LoginRequest _value;

  @_i3.override
  _i4.LoginRequestClientModel? get client => _value.client;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.String get password => _value.password;

  @_i3.override
  _i3.String? get recoveryCode => _value.recoveryCode;

  @_i3.override
  _i3.String? get totpCode => _value.totpCode;

  @_i3.override
  $Res call({
    _i3.Object? client = _sentinel,
    _i3.Object? email = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? recoveryCode = _sentinel,
    _i3.Object? totpCode = _sentinel,
  }) {
    return (LoginRequest(
      client: _i3.identical(client, _sentinel)
          ? this.client
          : (client as _i4.LoginRequestClientModel?),
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      password: _i3.identical(password, _sentinel)
          ? this.password
          : (password as _i3.String),
      recoveryCode: _i3.identical(recoveryCode, _sentinel)
          ? this.recoveryCode
          : (recoveryCode as _i3.String?),
      totpCode: _i3.identical(totpCode, _sentinel)
          ? this.totpCode
          : (totpCode as _i3.String?),
    ) as $Res);
  }
}
