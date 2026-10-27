// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DisableRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DisableRequest({this.recoveryCode, this.totpCode});

  factory DisableRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'recovery_code', r'totp_code'},
      listKeys: {},
      context: r'DisableRequest',
    );
    return DisableRequest(
      recoveryCode: _$values[r'recovery_code'].decodeSimpleNullableString(
        context: r'DisableRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeSimpleNullableString(
        context: r'DisableRequest.totp_code',
      ),
    );
  }

  factory DisableRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DisableRequest');
    return DisableRequest(
      recoveryCode: _$map[r'recovery_code'].decodeJsonNullableString(
        context: r'DisableRequest.recovery_code',
      ),
      totpCode: _$map[r'totp_code'].decodeJsonNullableString(
        context: r'DisableRequest.totp_code',
      ),
    );
  }

  factory DisableRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'recovery_code', r'totp_code'},
      listKeys: {},
      context: r'DisableRequest',
    );
    return DisableRequest(
      recoveryCode: _$values[r'recovery_code'].decodeFormNullableString(
        context: r'DisableRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeFormNullableString(
        context: r'DisableRequest.totp_code',
      ),
    );
  }

  final _i3.String? recoveryCode;

  final _i3.String? totpCode;

  @_i3.override
  _i3.Object? toJson() => {
    if (recoveryCode != null) r'recovery_code': recoveryCode,
    if (totpCode != null) r'totp_code': totpCode,
  };

  $$DisableRequestCopyWith<DisableRequest> get copyWith =>
      _DisableRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableRequest &&
        other.recoveryCode == this.recoveryCode &&
        other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([recoveryCode, totpCode]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
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
      r'Cannot uriEncode DisableRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$DisableRequestCopyWith<$Res> {
  factory $$DisableRequestCopyWith(DisableRequest value) =
      _DisableRequestCopyWith<$Res>;

  $Res call({_i3.String? recoveryCode, _i3.String? totpCode});
  _i3.String? get recoveryCode;
  _i3.String? get totpCode;
}

class _DisableRequestCopyWith<$Res> implements $$DisableRequestCopyWith<$Res> {
  _DisableRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final DisableRequest _value;

  @_i3.override
  _i3.String? get recoveryCode => _value.recoveryCode;

  @_i3.override
  _i3.String? get totpCode => _value.totpCode;

  @_i3.override
  $Res call({
    _i3.Object? recoveryCode = _sentinel,
    _i3.Object? totpCode = _sentinel,
  }) {
    return (DisableRequest(
      recoveryCode: _i3.identical(recoveryCode, _sentinel)
          ? this.recoveryCode
          : (recoveryCode as _i3.String?),
      totpCode: _i3.identical(totpCode, _sentinel)
          ? this.totpCode
          : (totpCode as _i3.String?),
    ) as $Res);
  }
}
