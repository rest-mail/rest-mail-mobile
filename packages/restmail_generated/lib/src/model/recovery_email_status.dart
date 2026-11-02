// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class RecoveryEmailStatus extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const RecoveryEmailStatus({required this.email, required this.verified});

  factory RecoveryEmailStatus.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'email', r'verified'},
      listKeys: {},
      context: r'RecoveryEmailStatus',
    );
    return RecoveryEmailStatus(
      email: _$values[r'email'].decodeSimpleString(
        context: r'RecoveryEmailStatus.email',
      ),
      verified: _$values[r'verified'].decodeSimpleBool(
        context: r'RecoveryEmailStatus.verified',
      ),
    );
  }

  factory RecoveryEmailStatus.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'RecoveryEmailStatus');
    return RecoveryEmailStatus(
      email: _$map[r'email'].decodeJsonString(
        context: r'RecoveryEmailStatus.email',
      ),
      verified: _$map[r'verified'].decodeJsonBool(
        context: r'RecoveryEmailStatus.verified',
      ),
    );
  }

  factory RecoveryEmailStatus.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'email', r'verified'},
      listKeys: {},
      context: r'RecoveryEmailStatus',
    );
    return RecoveryEmailStatus(
      email: _$values[r'email'].decodeFormString(
        context: r'RecoveryEmailStatus.email',
      ),
      verified: _$values[r'verified'].decodeFormBool(
        context: r'RecoveryEmailStatus.verified',
      ),
    );
  }

  final _i3.String email;

  final _i3.bool verified;

  @_i3.override
  _i3.Object? toJson() => {r'email': email, r'verified': verified};

  $$RecoveryEmailStatusCopyWith<RecoveryEmailStatus> get copyWith =>
      _RecoveryEmailStatusCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RecoveryEmailStatus &&
        other.email == this.email &&
        other.verified == this.verified;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([email, verified]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'email'] = _i1.PropertyValue.scalar(email);
    _$result[r'verified'] = _i1.PropertyValue.scalar(verified.toString());
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
      r'Cannot uriEncode RecoveryEmailStatus: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$RecoveryEmailStatusCopyWith<$Res> {
  factory $$RecoveryEmailStatusCopyWith(RecoveryEmailStatus value) =
      _RecoveryEmailStatusCopyWith<$Res>;

  $Res call({_i3.String? email, _i3.bool? verified});
  _i3.String get email;
  _i3.bool get verified;
}

class _RecoveryEmailStatusCopyWith<$Res>
    implements $$RecoveryEmailStatusCopyWith<$Res> {
  _RecoveryEmailStatusCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final RecoveryEmailStatus _value;

  @_i3.override
  _i3.String get email => _value.email;

  @_i3.override
  _i3.bool get verified => _value.verified;

  @_i3.override
  $Res call({_i3.Object? email = _sentinel, _i3.Object? verified = _sentinel}) {
    return (RecoveryEmailStatus(
      email: _i3.identical(email, _sentinel)
          ? this.email
          : (email as _i3.String),
      verified: _i3.identical(verified, _sentinel)
          ? this.verified
          : (verified as _i3.bool),
    ) as $Res);
  }
}
