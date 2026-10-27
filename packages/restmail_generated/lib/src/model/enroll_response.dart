// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class EnrollResponse extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const EnrollResponse({
    required this.otpauthUrl,
    required this.recoveryCodes,
    required this.secret,
  });

  factory EnrollResponse.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'otpauth_url', r'recovery_codes', r'secret'},
      listKeys: {r'recovery_codes'},
      context: r'EnrollResponse',
    );
    return EnrollResponse(
      otpauthUrl: _$values[r'otpauth_url'].decodeSimpleUri(
        context: r'EnrollResponse.otpauth_url',
      ),
      recoveryCodes: _$values[r'recovery_codes'].decodeSimpleStringList(
        context: r'EnrollResponse.recovery_codes',
      ),
      secret: _$values[r'secret'].decodeSimpleString(
        context: r'EnrollResponse.secret',
      ),
    );
  }

  factory EnrollResponse.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'EnrollResponse');
    return EnrollResponse(
      otpauthUrl: _$map[r'otpauth_url'].decodeJsonUri(
        context: r'EnrollResponse.otpauth_url',
      ),
      recoveryCodes: _$map[r'recovery_codes'].decodeJsonList<_i3.String>(
        context: r'EnrollResponse.recovery_codes',
      ),
      secret: _$map[r'secret'].decodeJsonString(
        context: r'EnrollResponse.secret',
      ),
    );
  }

  factory EnrollResponse.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'otpauth_url', r'recovery_codes', r'secret'},
      listKeys: {r'recovery_codes'},
      context: r'EnrollResponse',
    );
    return EnrollResponse(
      otpauthUrl: _$values[r'otpauth_url'].decodeFormUri(
        context: r'EnrollResponse.otpauth_url',
      ),
      recoveryCodes: _$values[r'recovery_codes'].decodeFormStringList(
        context: r'EnrollResponse.recovery_codes',
      ),
      secret: _$values[r'secret'].decodeFormString(
        context: r'EnrollResponse.secret',
      ),
    );
  }

  final _i3.Uri otpauthUrl;

  final _i3.List<_i3.String> recoveryCodes;

  final _i3.String secret;

  @_i3.override
  _i3.Object? toJson() => {
    r'otpauth_url': otpauthUrl.toString(),
    r'recovery_codes': recoveryCodes,
    r'secret': secret,
  };

  $$EnrollResponseCopyWith<EnrollResponse> get copyWith =>
      _EnrollResponseCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is EnrollResponse &&
        other.otpauthUrl == this.otpauthUrl &&
        _$deepEquals.equals(other.recoveryCodes, this.recoveryCodes) &&
        other.secret == this.secret;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      otpauthUrl,
      deepEquals.hash(recoveryCodes),
      secret,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'otpauth_url'] = _i1.PropertyValue.scalar(otpauthUrl.toString());
    _$result[r'recovery_codes'] = _i1.PropertyValue.array(recoveryCodes);
    _$result[r'secret'] = _i1.PropertyValue.scalar(secret);
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
      r'Cannot uriEncode EnrollResponse: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$EnrollResponseCopyWith<$Res> {
  factory $$EnrollResponseCopyWith(EnrollResponse value) =
      _EnrollResponseCopyWith<$Res>;

  $Res call({
    _i3.Uri? otpauthUrl,
    _i3.List<_i3.String>? recoveryCodes,
    _i3.String? secret,
  });
  _i3.Uri get otpauthUrl;
  _i3.List<_i3.String> get recoveryCodes;
  _i3.String get secret;
}

class _EnrollResponseCopyWith<$Res> implements $$EnrollResponseCopyWith<$Res> {
  _EnrollResponseCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final EnrollResponse _value;

  @_i3.override
  _i3.Uri get otpauthUrl => _value.otpauthUrl;

  @_i3.override
  _i3.List<_i3.String> get recoveryCodes => _value.recoveryCodes;

  @_i3.override
  _i3.String get secret => _value.secret;

  @_i3.override
  $Res call({
    _i3.Object? otpauthUrl = _sentinel,
    _i3.Object? recoveryCodes = _sentinel,
    _i3.Object? secret = _sentinel,
  }) {
    return (EnrollResponse(
      otpauthUrl: _i3.identical(otpauthUrl, _sentinel)
          ? this.otpauthUrl
          : (otpauthUrl as _i3.Uri),
      recoveryCodes: _i3.identical(recoveryCodes, _sentinel)
          ? this.recoveryCodes
          : (recoveryCodes as _i3.List<_i3.String>),
      secret: _i3.identical(secret, _sentinel)
          ? this.secret
          : (secret as _i3.String),
    ) as $Res);
  }
}
