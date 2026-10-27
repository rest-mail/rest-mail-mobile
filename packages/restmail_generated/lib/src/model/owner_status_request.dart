// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class OwnerStatusRequest extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const OwnerStatusRequest({this.challenge, this.publicKey, this.signature});

  factory OwnerStatusRequest.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'challenge', r'public_key', r'signature'},
      listKeys: {},
      context: r'OwnerStatusRequest',
    );
    return OwnerStatusRequest(
      challenge: _$values[r'challenge'].decodeSimpleNullableString(
        context: r'OwnerStatusRequest.challenge',
      ),
      publicKey: _$values[r'public_key'].decodeSimpleNullableString(
        context: r'OwnerStatusRequest.public_key',
      ),
      signature: _$values[r'signature'].decodeSimpleNullableString(
        context: r'OwnerStatusRequest.signature',
      ),
    );
  }

  factory OwnerStatusRequest.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'OwnerStatusRequest');
    return OwnerStatusRequest(
      challenge: _$map[r'challenge'].decodeJsonNullableString(
        context: r'OwnerStatusRequest.challenge',
      ),
      publicKey: _$map[r'public_key'].decodeJsonNullableString(
        context: r'OwnerStatusRequest.public_key',
      ),
      signature: _$map[r'signature'].decodeJsonNullableString(
        context: r'OwnerStatusRequest.signature',
      ),
    );
  }

  factory OwnerStatusRequest.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'challenge', r'public_key', r'signature'},
      listKeys: {},
      context: r'OwnerStatusRequest',
    );
    return OwnerStatusRequest(
      challenge: _$values[r'challenge'].decodeFormNullableString(
        context: r'OwnerStatusRequest.challenge',
      ),
      publicKey: _$values[r'public_key'].decodeFormNullableString(
        context: r'OwnerStatusRequest.public_key',
      ),
      signature: _$values[r'signature'].decodeFormNullableString(
        context: r'OwnerStatusRequest.signature',
      ),
    );
  }

  final _i3.String? challenge;

  final _i3.String? publicKey;

  final _i3.String? signature;

  @_i3.override
  _i3.Object? toJson() => {
    if (challenge != null) r'challenge': challenge,
    if (publicKey != null) r'public_key': publicKey,
    if (signature != null) r'signature': signature,
  };

  $$OwnerStatusRequestCopyWith<OwnerStatusRequest> get copyWith =>
      _OwnerStatusRequestCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is OwnerStatusRequest &&
        other.challenge == this.challenge &&
        other.publicKey == this.publicKey &&
        other.signature == this.signature;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([challenge, publicKey, signature]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (challenge != null) {
      _$result[r'challenge'] = _i1.PropertyValue.scalar(challenge!);
    }
    if (publicKey != null) {
      _$result[r'public_key'] = _i1.PropertyValue.scalar(publicKey!);
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
      r'Cannot uriEncode OwnerStatusRequest: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$OwnerStatusRequestCopyWith<$Res> {
  factory $$OwnerStatusRequestCopyWith(OwnerStatusRequest value) =
      _OwnerStatusRequestCopyWith<$Res>;

  $Res call({
    _i3.String? challenge,
    _i3.String? publicKey,
    _i3.String? signature,
  });
  _i3.String? get challenge;
  _i3.String? get publicKey;
  _i3.String? get signature;
}

class _OwnerStatusRequestCopyWith<$Res>
    implements $$OwnerStatusRequestCopyWith<$Res> {
  _OwnerStatusRequestCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final OwnerStatusRequest _value;

  @_i3.override
  _i3.String? get challenge => _value.challenge;

  @_i3.override
  _i3.String? get publicKey => _value.publicKey;

  @_i3.override
  _i3.String? get signature => _value.signature;

  @_i3.override
  $Res call({
    _i3.Object? challenge = _sentinel,
    _i3.Object? publicKey = _sentinel,
    _i3.Object? signature = _sentinel,
  }) {
    return (OwnerStatusRequest(
      challenge: _i3.identical(challenge, _sentinel)
          ? this.challenge
          : (challenge as _i3.String?),
      publicKey: _i3.identical(publicKey, _sentinel)
          ? this.publicKey
          : (publicKey as _i3.String?),
      signature: _i3.identical(signature, _sentinel)
          ? this.signature
          : (signature as _i3.String?),
    ) as $Res);
  }
}
