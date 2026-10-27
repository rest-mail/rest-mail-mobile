// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OwnerChallenge extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OwnerChallenge({required this.challenge, required this.expiresAt});

  factory OwnerChallenge.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'challenge', r'expires_at'},
      listKeys: {},
      context: r'OwnerChallenge',
    );
    return OwnerChallenge(
      challenge: _$values[r'challenge'].decodeSimpleString(
        context: r'OwnerChallenge.challenge',
      ),
      expiresAt: _$values[r'expires_at'].decodeSimpleDateTime(
        context: r'OwnerChallenge.expires_at',
      ),
    );
  }

  factory OwnerChallenge.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OwnerChallenge');
    return OwnerChallenge(
      challenge: _$map[r'challenge'].decodeJsonString(
        context: r'OwnerChallenge.challenge',
      ),
      expiresAt: _$map[r'expires_at'].decodeJsonDateTime(
        context: r'OwnerChallenge.expires_at',
      ),
    );
  }

  factory OwnerChallenge.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'challenge', r'expires_at'},
      listKeys: {},
      context: r'OwnerChallenge',
    );
    return OwnerChallenge(
      challenge: _$values[r'challenge'].decodeFormString(
        context: r'OwnerChallenge.challenge',
      ),
      expiresAt: _$values[r'expires_at'].decodeFormDateTime(
        context: r'OwnerChallenge.expires_at',
      ),
    );
  }

  final _i3.String challenge;

  final _i3.DateTime expiresAt;

  @_i3.override
  _i3.Object? toJson() => {
    r'challenge': challenge,
    r'expires_at': expiresAt.toTimeZonedIso8601String(),
  };

  $$OwnerChallengeCopyWith<OwnerChallenge> get copyWith =>
      _OwnerChallengeCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerChallenge &&
        other.challenge == this.challenge &&
        other.expiresAt == this.expiresAt;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([challenge, expiresAt]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'challenge'] = _i1.PropertyValue.scalar(challenge);
    _$result[r'expires_at'] = _i1.PropertyValue.scalar(
      expiresAt.toTimeZonedIso8601String(),
    );
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
      r'Cannot uriEncode OwnerChallenge: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OwnerChallengeCopyWith<$Res> {
  factory $$OwnerChallengeCopyWith(OwnerChallenge value) =
      _OwnerChallengeCopyWith<$Res>;

  $Res call({_i3.String? challenge, _i3.DateTime? expiresAt});
  _i3.String get challenge;
  _i3.DateTime get expiresAt;
}

class _OwnerChallengeCopyWith<$Res> implements $$OwnerChallengeCopyWith<$Res> {
  _OwnerChallengeCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OwnerChallenge _value;

  @_i3.override
  _i3.String get challenge => _value.challenge;

  @_i3.override
  _i3.DateTime get expiresAt => _value.expiresAt;

  @_i3.override
  $Res call({
    _i3.Object? challenge = _sentinel,
    _i3.Object? expiresAt = _sentinel,
  }) {
    return (OwnerChallenge(
      challenge: _i3.identical(challenge, _sentinel)
          ? this.challenge
          : (challenge as _i3.String),
      expiresAt: _i3.identical(expiresAt, _sentinel)
          ? this.expiresAt
          : (expiresAt as _i3.DateTime),
    ) as $Res);
  }
}
