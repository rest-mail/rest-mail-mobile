// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OwnerTokenRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OwnerTokenRequest({
    this.address,
    this.challenge,
    this.lifetimeSeconds,
    this.publicKey,
    this.purpose,
    this.signature,
  });

  factory OwnerTokenRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'address',
        r'challenge',
        r'lifetime_seconds',
        r'public_key',
        r'purpose',
        r'signature',
      },
      listKeys: {},
      context: r'OwnerTokenRequest',
    );
    return OwnerTokenRequest(
      address: _$values[r'address'].decodeSimpleNullableString(
        context: r'OwnerTokenRequest.address',
      ),
      challenge: _$values[r'challenge'].decodeSimpleNullableString(
        context: r'OwnerTokenRequest.challenge',
      ),
      lifetimeSeconds: _$values[r'lifetime_seconds'].decodeSimpleNullableInt(
        context: r'OwnerTokenRequest.lifetime_seconds',
      ),
      publicKey: _$values[r'public_key'].decodeSimpleNullableString(
        context: r'OwnerTokenRequest.public_key',
      ),
      purpose: _$values[r'purpose'].decodeSimpleNullableString(
        context: r'OwnerTokenRequest.purpose',
      ),
      signature: _$values[r'signature'].decodeSimpleNullableString(
        context: r'OwnerTokenRequest.signature',
      ),
    );
  }

  factory OwnerTokenRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OwnerTokenRequest');
    return OwnerTokenRequest(
      address: _$map[r'address'].decodeJsonNullableString(
        context: r'OwnerTokenRequest.address',
      ),
      challenge: _$map[r'challenge'].decodeJsonNullableString(
        context: r'OwnerTokenRequest.challenge',
      ),
      lifetimeSeconds: _$map[r'lifetime_seconds'].decodeJsonNullableInt(
        context: r'OwnerTokenRequest.lifetime_seconds',
      ),
      publicKey: _$map[r'public_key'].decodeJsonNullableString(
        context: r'OwnerTokenRequest.public_key',
      ),
      purpose: _$map[r'purpose'].decodeJsonNullableString(
        context: r'OwnerTokenRequest.purpose',
      ),
      signature: _$map[r'signature'].decodeJsonNullableString(
        context: r'OwnerTokenRequest.signature',
      ),
    );
  }

  factory OwnerTokenRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'address',
        r'challenge',
        r'lifetime_seconds',
        r'public_key',
        r'purpose',
        r'signature',
      },
      listKeys: {},
      context: r'OwnerTokenRequest',
    );
    return OwnerTokenRequest(
      address: _$values[r'address'].decodeFormNullableString(
        context: r'OwnerTokenRequest.address',
      ),
      challenge: _$values[r'challenge'].decodeFormNullableString(
        context: r'OwnerTokenRequest.challenge',
      ),
      lifetimeSeconds: _$values[r'lifetime_seconds'].decodeFormNullableInt(
        context: r'OwnerTokenRequest.lifetime_seconds',
      ),
      publicKey: _$values[r'public_key'].decodeFormNullableString(
        context: r'OwnerTokenRequest.public_key',
      ),
      purpose: _$values[r'purpose'].decodeFormNullableString(
        context: r'OwnerTokenRequest.purpose',
      ),
      signature: _$values[r'signature'].decodeFormNullableString(
        context: r'OwnerTokenRequest.signature',
      ),
    );
  }

  final _i3.String? address;

  final _i3.String? challenge;

  final _i3.int? lifetimeSeconds;

  final _i3.String? publicKey;

  final _i3.String? purpose;

  final _i3.String? signature;

  @_i3.override
  _i3.Object? toJson() => {
    if (address != null) r'address': address,
    if (challenge != null) r'challenge': challenge,
    if (lifetimeSeconds != null) r'lifetime_seconds': lifetimeSeconds,
    if (publicKey != null) r'public_key': publicKey,
    if (purpose != null) r'purpose': purpose,
    if (signature != null) r'signature': signature,
  };

  $$OwnerTokenRequestCopyWith<OwnerTokenRequest> get copyWith =>
      _OwnerTokenRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerTokenRequest &&
        other.address == this.address &&
        other.challenge == this.challenge &&
        other.lifetimeSeconds == this.lifetimeSeconds &&
        other.publicKey == this.publicKey &&
        other.purpose == this.purpose &&
        other.signature == this.signature;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      address,
      challenge,
      lifetimeSeconds,
      publicKey,
      purpose,
      signature,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (address != null) {
      _$result[r'address'] = _i1.PropertyValue.scalar(address!);
    }
    if (challenge != null) {
      _$result[r'challenge'] = _i1.PropertyValue.scalar(challenge!);
    }
    if (lifetimeSeconds != null) {
      _$result[r'lifetime_seconds'] = _i1.PropertyValue.scalar(
        lifetimeSeconds!.toString(),
      );
    }
    if (publicKey != null) {
      _$result[r'public_key'] = _i1.PropertyValue.scalar(publicKey!);
    }
    if (purpose != null) {
      _$result[r'purpose'] = _i1.PropertyValue.scalar(purpose!);
    }
    if (signature != null) {
      _$result[r'signature'] = _i1.PropertyValue.scalar(signature!);
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
      r'Cannot uriEncode OwnerTokenRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OwnerTokenRequestCopyWith<$Res> {
  factory $$OwnerTokenRequestCopyWith(OwnerTokenRequest value) =
      _OwnerTokenRequestCopyWith<$Res>;

  $Res call({
    _i3.String? address,
    _i3.String? challenge,
    _i3.int? lifetimeSeconds,
    _i3.String? publicKey,
    _i3.String? purpose,
    _i3.String? signature,
  });
  _i3.String? get address;
  _i3.String? get challenge;
  _i3.int? get lifetimeSeconds;
  _i3.String? get publicKey;
  _i3.String? get purpose;
  _i3.String? get signature;
}

class _OwnerTokenRequestCopyWith<$Res>
    implements $$OwnerTokenRequestCopyWith<$Res> {
  _OwnerTokenRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OwnerTokenRequest _value;

  @_i3.override
  _i3.String? get address => _value.address;

  @_i3.override
  _i3.String? get challenge => _value.challenge;

  @_i3.override
  _i3.int? get lifetimeSeconds => _value.lifetimeSeconds;

  @_i3.override
  _i3.String? get publicKey => _value.publicKey;

  @_i3.override
  _i3.String? get purpose => _value.purpose;

  @_i3.override
  _i3.String? get signature => _value.signature;

  @_i3.override
  $Res call({
    _i3.Object? address = _sentinel,
    _i3.Object? challenge = _sentinel,
    _i3.Object? lifetimeSeconds = _sentinel,
    _i3.Object? publicKey = _sentinel,
    _i3.Object? purpose = _sentinel,
    _i3.Object? signature = _sentinel,
  }) {
    return (OwnerTokenRequest(
      address: _i3.identical(address, _sentinel)
          ? this.address
          : (address as _i3.String?),
      challenge: _i3.identical(challenge, _sentinel)
          ? this.challenge
          : (challenge as _i3.String?),
      lifetimeSeconds: _i3.identical(lifetimeSeconds, _sentinel)
          ? this.lifetimeSeconds
          : (lifetimeSeconds as _i3.int?),
      publicKey: _i3.identical(publicKey, _sentinel)
          ? this.publicKey
          : (publicKey as _i3.String?),
      purpose: _i3.identical(purpose, _sentinel)
          ? this.purpose
          : (purpose as _i3.String?),
      signature: _i3.identical(signature, _sentinel)
          ? this.signature
          : (signature as _i3.String?),
    ) as $Res);
  }
}
