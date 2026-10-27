// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ActivateRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ActivateRequest({
    this.minutes,
    this.reason,
    this.recoveryCode,
    this.totpCode,
  });

  factory ActivateRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'minutes', r'reason', r'recovery_code', r'totp_code'},
      listKeys: {},
      context: r'ActivateRequest',
    );
    return ActivateRequest(
      minutes: _$values[r'minutes'].decodeSimpleNullableInt(
        context: r'ActivateRequest.minutes',
      ),
      reason: _$values[r'reason'].decodeSimpleNullableString(
        context: r'ActivateRequest.reason',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeSimpleNullableString(
        context: r'ActivateRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeSimpleNullableString(
        context: r'ActivateRequest.totp_code',
      ),
    );
  }

  factory ActivateRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ActivateRequest');
    return ActivateRequest(
      minutes: _$map[r'minutes'].decodeJsonNullableInt(
        context: r'ActivateRequest.minutes',
      ),
      reason: _$map[r'reason'].decodeJsonNullableString(
        context: r'ActivateRequest.reason',
      ),
      recoveryCode: _$map[r'recovery_code'].decodeJsonNullableString(
        context: r'ActivateRequest.recovery_code',
      ),
      totpCode: _$map[r'totp_code'].decodeJsonNullableString(
        context: r'ActivateRequest.totp_code',
      ),
    );
  }

  factory ActivateRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'minutes', r'reason', r'recovery_code', r'totp_code'},
      listKeys: {},
      context: r'ActivateRequest',
    );
    return ActivateRequest(
      minutes: _$values[r'minutes'].decodeFormNullableInt(
        context: r'ActivateRequest.minutes',
      ),
      reason: _$values[r'reason'].decodeFormNullableString(
        context: r'ActivateRequest.reason',
      ),
      recoveryCode: _$values[r'recovery_code'].decodeFormNullableString(
        context: r'ActivateRequest.recovery_code',
      ),
      totpCode: _$values[r'totp_code'].decodeFormNullableString(
        context: r'ActivateRequest.totp_code',
      ),
    );
  }

  final _i3.int? minutes;

  final _i3.String? reason;

  final _i3.String? recoveryCode;

  final _i3.String? totpCode;

  @_i3.override
  _i3.Object? toJson() => {
    r'minutes': minutes,
    if (reason != null) r'reason': reason,
    if (recoveryCode != null) r'recovery_code': recoveryCode,
    if (totpCode != null) r'totp_code': totpCode,
  };

  $$ActivateRequestCopyWith<ActivateRequest> get copyWith =>
      _ActivateRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ActivateRequest &&
        other.minutes == this.minutes &&
        other.reason == this.reason &&
        other.recoveryCode == this.recoveryCode &&
        other.totpCode == this.totpCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([minutes, reason, recoveryCode, totpCode]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (minutes != null) {
      _$result[r'minutes'] = _i1.PropertyValue.scalar(minutes!.toString());
    }
    if (reason != null) {
      _$result[r'reason'] = _i1.PropertyValue.scalar(reason!);
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
      r'Cannot uriEncode ActivateRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$ActivateRequestCopyWith<$Res> {
  factory $$ActivateRequestCopyWith(ActivateRequest value) =
      _ActivateRequestCopyWith<$Res>;

  $Res call({
    _i3.int? minutes,
    _i3.String? reason,
    _i3.String? recoveryCode,
    _i3.String? totpCode,
  });
  _i3.int? get minutes;
  _i3.String? get reason;
  _i3.String? get recoveryCode;
  _i3.String? get totpCode;
}

class _ActivateRequestCopyWith<$Res>
    implements $$ActivateRequestCopyWith<$Res> {
  _ActivateRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final ActivateRequest _value;

  @_i3.override
  _i3.int? get minutes => _value.minutes;

  @_i3.override
  _i3.String? get reason => _value.reason;

  @_i3.override
  _i3.String? get recoveryCode => _value.recoveryCode;

  @_i3.override
  _i3.String? get totpCode => _value.totpCode;

  @_i3.override
  $Res call({
    _i3.Object? minutes = _sentinel,
    _i3.Object? reason = _sentinel,
    _i3.Object? recoveryCode = _sentinel,
    _i3.Object? totpCode = _sentinel,
  }) {
    return (ActivateRequest(
      minutes: _i3.identical(minutes, _sentinel)
          ? this.minutes
          : (minutes as _i3.int?),
      reason: _i3.identical(reason, _sentinel)
          ? this.reason
          : (reason as _i3.String?),
      recoveryCode: _i3.identical(recoveryCode, _sentinel)
          ? this.recoveryCode
          : (recoveryCode as _i3.String?),
      totpCode: _i3.identical(totpCode, _sentinel)
          ? this.totpCode
          : (totpCode as _i3.String?),
    ) as $Res);
  }
}
