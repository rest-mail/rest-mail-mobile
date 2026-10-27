// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LinkAccountRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LinkAccountRequest({
    required this.address,
    required this.password,
    this.displayName,
    this.recoveryCode,
    this.totpCode,
  });

  factory LinkAccountRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'address',
        r'display_name',
        r'password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'LinkAccountRequest',
    );
    return LinkAccountRequest(
      address: _$values[r'address'].decodeSimpleString(
        context: r'LinkAccountRequest.address',
      ),
      displayName: _$values[r'display_name'].decodeSimpleNullableString(
        context: r'LinkAccountRequest.display_name',
      ),
      password: _$values[r'password'].decodeSimpleString(
        context: r'LinkAccountRequest.password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeSimpleNullableString(
        context: r'LinkAccountRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeSimpleNullableString(
        context: r'LinkAccountRequest.totp_code',
      ),
    );
  }

  factory LinkAccountRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LinkAccountRequest');
    return LinkAccountRequest(
      address: _$map[r'address'].decodeJsonString(
        context: r'LinkAccountRequest.address',
      ),
      displayName: _$map[r'display_name'].decodeJsonNullableString(
        context: r'LinkAccountRequest.display_name',
      ),
      password: _$map[r'password'].decodeJsonString(
        context: r'LinkAccountRequest.password',
      ),
      recoveryCode: _$map[r'recovery_code'].decodeJsonNullableString(
        context: r'LinkAccountRequest.recovery_code',
      ),
      totpCode: _$map[r'totp_code'].decodeJsonNullableString(
        context: r'LinkAccountRequest.totp_code',
      ),
    );
  }

  factory LinkAccountRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'address',
        r'display_name',
        r'password',
        r'recovery_code',
        r'totp_code',
      },
      listKeys: {},
      context: r'LinkAccountRequest',
    );
    return LinkAccountRequest(
      address: _$values[r'address'].decodeFormString(
        context: r'LinkAccountRequest.address',
      ),
      displayName: _$values[r'display_name'].decodeFormNullableString(
        context: r'LinkAccountRequest.display_name',
      ),
      password: _$values[r'password'].decodeFormString(
        context: r'LinkAccountRequest.password',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeFormNullableString(
        context: r'LinkAccountRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeFormNullableString(
        context: r'LinkAccountRequest.totp_code',
      ),
    );
  }

  final _i3.String address;

  final _i3.String? displayName;

  final _i3.String password;

  final _i3.String? recoveryCode;

  final _i3.String? totpCode;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': address,
    if (displayName != null) r'display_name': displayName,
    r'password': password,
    if (recoveryCode != null) r'recovery_code': recoveryCode,
    if (totpCode != null) r'totp_code': totpCode,
  };

  $$LinkAccountRequestCopyWith<LinkAccountRequest> get copyWith =>
      _LinkAccountRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LinkAccountRequest &&
        other.address == this.address &&
        other.displayName == this.displayName &&
        other.password == this.password &&
        other.recoveryCode == this.recoveryCode &&
        other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      address,
      displayName,
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
    _$result[r'address'] = _i1.PropertyValue.scalar(address);
    if (displayName != null) {
      _$result[r'display_name'] = _i1.PropertyValue.scalar(displayName!);
    }
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
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LinkAccountRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$LinkAccountRequestCopyWith<$Res> {
  factory $$LinkAccountRequestCopyWith(LinkAccountRequest value) =
      _LinkAccountRequestCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? displayName,
    _i3.String? password,
    _i3.String? recoveryCode,
    _i3.String? totpCode,
  });
  _i3.String get address;
  _i3.String? get displayName;
  _i3.String get password;
  _i3.String? get recoveryCode;
  _i3.String? get totpCode;
}

class _LinkAccountRequestCopyWith<$Res>
    implements $$LinkAccountRequestCopyWith<$Res> {
  _LinkAccountRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final LinkAccountRequest _value;

  @_i3.override
  _i3.String get address => _value.address;

  @_i3.override
  _i3.String? get displayName => _value.displayName;

  @_i3.override
  _i3.String get password => _value.password;

  @_i3.override
  _i3.String? get recoveryCode => _value.recoveryCode;

  @_i3.override
  _i3.String? get totpCode => _value.totpCode;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? displayName = _sentinel,
    _i3.Object? password = _sentinel,
    _i3.Object? recoveryCode = _sentinel,
    _i3.Object? totpCode = _sentinel,
  }) {
    return (LinkAccountRequest(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String),
      displayName: _i3.identical(displayName, _sentinel)
          ? this.displayName
          : (displayName as _i3.String?),
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
