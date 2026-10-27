// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RecoverRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RecoverRequest({
    this.client,
    this.email,
    this.newPassword,
    this.recoveryCode,
    this.totpCode,
  });

  factory RecoverRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'client',
        r'email',
        r'new_password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'RecoverRequest',
    );
    return RecoverRequest(
      client: _$values[r'client'].decodeSimpleNullableString(
        context: r'RecoverRequest.client',
      ),
      email: _$values[r'email'].decodeSimpleNullableString(
        context: r'RecoverRequest.email',
      ),
      newPassword: _$values[r'new_password'].decodeSimpleNullableString(
        context: r'RecoverRequest.new_password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeSimpleNullableString(
        context: r'RecoverRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeSimpleNullableString(
        context: r'RecoverRequest.totp_code',
      ),
    );
  }

  factory RecoverRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RecoverRequest');
    return RecoverRequest(
      client: _$map[r'client'].decodeJsonNullableString(
        context: r'RecoverRequest.client',
      ),
      email: _$map[r'email'].decodeJsonNullableString(
        context: r'RecoverRequest.email',
      ),
      newPassword: _$map[r'new_password'].decodeJsonNullableString(
        context: r'RecoverRequest.new_password',
      ),
      recoveryCode: _$map[r'recovery_code'].decodeJsonNullableString(
        context: r'RecoverRequest.recovery_code',
      ),
      totpCode: _$map[r'totp_code'].decodeJsonNullableString(
        context: r'RecoverRequest.totp_code',
      ),
    );
  }

  factory RecoverRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'client',
        r'email',
        r'new_password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'RecoverRequest',
    );
    return RecoverRequest(
      client: _$values[r'client'].decodeFormNullableString(
        context: r'RecoverRequest.client',
      ),
      email: _$values[r'email'].decodeFormNullableString(
        context: r'RecoverRequest.email',
      ),
      newPassword: _$values[r'new_password'].decodeFormNullableString(
        context: r'RecoverRequest.new_password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeFormNullableString(
        context: r'RecoverRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeFormNullableString(
        context: r'RecoverRequest.totp_code',
      ),
    );
  }

  final _i3.String? client;

  final _i3.String? email;

  final _i3.String? newPassword;

  final _i3.String? recoveryCode;

  final _i3.String? totpCode;

  @_i3.override
  _i3.Object? toJson() => {
    if (client != null) r'client': client,
    if (email != null) r'email': email,
    if (newPassword != null) r'new_password': newPassword,
    if (recoveryCode != null) r'recovery_code': recoveryCode,
    if (totpCode != null) r'totp_code': totpCode,
  };

  $$RecoverRequestCopyWith<RecoverRequest> get copyWith =>
      _RecoverRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoverRequest &&
        other.client == this.client &&
        other.email == this.email &&
        other.newPassword == this.newPassword &&
        other.recoveryCode == this.recoveryCode &&
        other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      client,
      email,
      newPassword,
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
      _$result[r'client'] = _i1.PropertyValue.scalar(client!);
    }
    if (email != null) {
      _$result[r'email'] = _i1.PropertyValue.scalar(email!);
    }
    if (newPassword != null) {
      _$result[r'new_password'] = _i1.PropertyValue.scalar(newPassword!);
    }
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
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode RecoverRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RecoverRequestCopyWith<$Res> {
  factory $$RecoverRequestCopyWith(RecoverRequest value) =
      _RecoverRequestCopyWith<$Res>;

  $Res call({
    _i3.String? client,
    _i3.String? email,
    _i3.String? newPassword,
    _i3.String? recoveryCode,
    _i3.String? totpCode,
  });
  _i3.String? get client;
  _i3.String? get email;
  _i3.String? get newPassword;
  _i3.String? get recoveryCode;
  _i3.String? get totpCode;
}

class _RecoverRequestCopyWith<$Res> implements $$RecoverRequestCopyWith<$Res> {
  _RecoverRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RecoverRequest _value;

  @_i3.override
  _i3.String? get client => _value.client;

  @_i3.override
  _i3.String? get email => _value.email;

  @_i3.override
  _i3.String? get newPassword => _value.newPassword;

  @_i3.override
  _i3.String? get recoveryCode => _value.recoveryCode;

  @_i3.override
  _i3.String? get totpCode => _value.totpCode;

  @_i3.override
  $Res call({
    _i3.Object? client = _sentinel,
    _i3.Object? email = _sentinel,
    _i3.Object? newPassword = _sentinel,
    _i3.Object? recoveryCode = _sentinel,
    _i3.Object? totpCode = _sentinel,
  }) {
    return (RecoverRequest(
      client: _i3.identical(client, _sentinel)
          ? this.client
          : (client as _i3.String?),
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String?),
      newPassword: _i3.identical(newPassword, _sentinel)
          ? this.newPassword
          : (newPassword as _i3.String?),
      recoveryCode: _i3.identical(recoveryCode, _sentinel)
          ? this.recoveryCode
          : (recoveryCode as _i3.String?),
      totpCode: _i3.identical(totpCode, _sentinel)
          ? this.totpCode
          : (totpCode as _i3.String?),
    ) as $Res);
  }
}
