// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RedeemRecoveryEmailRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RedeemRecoveryEmailRequest({
    required this.newPassword,
    required this.token,
  });

  factory RedeemRecoveryEmailRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'new_password', r'token'},
      listKeys: {},
      context: r'RedeemRecoveryEmailRequest',
    );
    return RedeemRecoveryEmailRequest(
      newPassword: _$values[r'new_password'].decodeSimpleString(
        context: r'RedeemRecoveryEmailRequest.new_password',
      ),
      token: _$values[r'token'].decodeSimpleString(
        context: r'RedeemRecoveryEmailRequest.token',
      ),
    );
  }

  factory RedeemRecoveryEmailRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RedeemRecoveryEmailRequest');
    return RedeemRecoveryEmailRequest(
      newPassword: _$map[r'new_password'].decodeJsonString(
        context: r'RedeemRecoveryEmailRequest.new_password',
      ),
      token: _$map[r'token'].decodeJsonString(
        context: r'RedeemRecoveryEmailRequest.token',
      ),
    );
  }

  factory RedeemRecoveryEmailRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'new_password', r'token'},
      listKeys: {},
      context: r'RedeemRecoveryEmailRequest',
    );
    return RedeemRecoveryEmailRequest(
      newPassword: _$values[r'new_password'].decodeFormString(
        context: r'RedeemRecoveryEmailRequest.new_password',
      ),
      token: _$values[r'token'].decodeFormString(
        context: r'RedeemRecoveryEmailRequest.token',
      ),
    );
  }

  final _i3.String newPassword;

  final _i3.String token;

  @_i3.override
  _i3.Object? toJson() => {r'new_password': newPassword, r'token': token};

  $$RedeemRecoveryEmailRequestCopyWith<RedeemRecoveryEmailRequest>
  get copyWith => _RedeemRecoveryEmailRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RedeemRecoveryEmailRequest &&
        other.newPassword == this.newPassword &&
        other.token == this.token;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([newPassword, token]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'new_password'] = _i1.PropertyValue.scalar(newPassword);
    _$result[r'token'] = _i1.PropertyValue.scalar(token);
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
      r'Cannot uriEncode RedeemRecoveryEmailRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RedeemRecoveryEmailRequestCopyWith<$Res> {
  factory $$RedeemRecoveryEmailRequestCopyWith(
    RedeemRecoveryEmailRequest value,
  ) = _RedeemRecoveryEmailRequestCopyWith<$Res>;

  $Res call({_i3.String? newPassword, _i3.String? token});
  _i3.String get newPassword;
  _i3.String get token;
}

class _RedeemRecoveryEmailRequestCopyWith<$Res>
    implements $$RedeemRecoveryEmailRequestCopyWith<$Res> {
  _RedeemRecoveryEmailRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RedeemRecoveryEmailRequest _value;

  @_i3.override
  _i3.String get newPassword => _value.newPassword;

  @_i3.override
  _i3.String get token => _value.token;

  @_i3.override
  $Res call({
    _i3.Object? newPassword = _sentinel,
    _i3.Object? token = _sentinel,
  }) {
    return (RedeemRecoveryEmailRequest(
      newPassword: _i3.identical(newPassword, _sentinel)
          ? this.newPassword
          : (newPassword as _i3.String),
      token: _i3.identical(token, _sentinel)
          ? this.token
          : (token as _i3.String),
    ) as $Res);
  }
}
