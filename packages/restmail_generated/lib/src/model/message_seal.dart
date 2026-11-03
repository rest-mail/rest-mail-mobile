// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:restmail_generated/src/model/message_seal_algorithm_model.dart'
    as _i4;
import 'package:restmail_generated/src/model/message_seal_state_model.dart'
    as _i5;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class MessageSeal extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const MessageSeal({
    required this.algorithm,
    required this.state,
    this.computedHash,
    this.sealedHash,
  });

  factory MessageSeal.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'algorithm', r'computed_hash', r'sealed_hash', r'state'},
      listKeys: {},
      context: r'MessageSeal',
    );
    return MessageSeal(
      algorithm: _i4.MessageSealAlgorithmModel.fromSimple(
        _$values[r'algorithm'],
        explode: explode,
      ),
      computedHash: _$values[r'computed_hash'].decodeSimpleNullableString(
        context: r'MessageSeal.computed_hash',
      ),
      sealedHash: _$values[r'sealed_hash'].decodeSimpleNullableString(
        context: r'MessageSeal.sealed_hash',
      ),
      state: _i5.MessageSealStateModel.fromSimple(
        _$values[r'state'],
        explode: explode,
      ),
    );
  }

  factory MessageSeal.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'MessageSeal');
    return MessageSeal(
      algorithm: _i4.MessageSealAlgorithmModel.fromJson(_$map[r'algorithm']),
      computedHash: _$map[r'computed_hash'].decodeJsonNullableString(
        context: r'MessageSeal.computed_hash',
      ),
      sealedHash: _$map[r'sealed_hash'].decodeJsonNullableString(
        context: r'MessageSeal.sealed_hash',
      ),
      state: _i5.MessageSealStateModel.fromJson(_$map[r'state']),
    );
  }

  factory MessageSeal.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'algorithm', r'computed_hash', r'sealed_hash', r'state'},
      listKeys: {},
      context: r'MessageSeal',
    );
    return MessageSeal(
      algorithm: _i4.MessageSealAlgorithmModel.fromForm(
        _$values[r'algorithm'],
        explode: explode,
      ),
      computedHash: _$values[r'computed_hash'].decodeFormNullableString(
        context: r'MessageSeal.computed_hash',
      ),
      sealedHash: _$values[r'sealed_hash'].decodeFormNullableString(
        context: r'MessageSeal.sealed_hash',
      ),
      state: _i5.MessageSealStateModel.fromForm(
        _$values[r'state'],
        explode: explode,
      ),
    );
  }

  final _i4.MessageSealAlgorithmModel algorithm;

  final _i3.String? computedHash;

  final _i3.String? sealedHash;

  final _i5.MessageSealStateModel state;

  @_i3.override
  _i3.Object? toJson() => {
    r'algorithm': algorithm.toJson(),
    if (computedHash != null) r'computed_hash': computedHash,
    if (sealedHash != null) r'sealed_hash': sealedHash,
    r'state': state.toJson(),
  };

  $$MessageSealCopyWith<MessageSeal> get copyWith => _MessageSealCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is MessageSeal &&
        other.algorithm == this.algorithm &&
        other.computedHash == this.computedHash &&
        other.sealedHash == this.sealedHash &&
        other.state == this.state;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([algorithm, computedHash, sealedHash, state]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'algorithm'] = _i1.PropertyValue.scalar(algorithm.toJson());
    if (computedHash != null) {
      _$result[r'computed_hash'] = _i1.PropertyValue.scalar(computedHash!);
    }
    if (sealedHash != null) {
      _$result[r'sealed_hash'] = _i1.PropertyValue.scalar(sealedHash!);
    }
    _$result[r'state'] = _i1.PropertyValue.scalar(state.toJson());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode MessageSeal: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$MessageSealCopyWith<$Res> {
  factory $$MessageSealCopyWith(MessageSeal value) = _MessageSealCopyWith<$Res>;

  $Res call({
    _i4.MessageSealAlgorithmModel? algorithm,
    _i3.String? computedHash,
    _i3.String? sealedHash,
    _i5.MessageSealStateModel? state,
  });
  _i4.MessageSealAlgorithmModel get algorithm;
  _i3.String? get computedHash;
  _i3.String? get sealedHash;
  _i5.MessageSealStateModel get state;
}

class _MessageSealCopyWith<$Res> implements $$MessageSealCopyWith<$Res> {
  _MessageSealCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final MessageSeal _value;

  @_i3.override
  _i4.MessageSealAlgorithmModel get algorithm => _value.algorithm;

  @_i3.override
  _i3.String? get computedHash => _value.computedHash;

  @_i3.override
  _i3.String? get sealedHash => _value.sealedHash;

  @_i3.override
  _i5.MessageSealStateModel get state => _value.state;

  @_i3.override
  $Res call({
    _i3.Object? algorithm = _sentinel,
    _i3.Object? computedHash = _sentinel,
    _i3.Object? sealedHash = _sentinel,
    _i3.Object? state = _sentinel,
  }) {
    return (MessageSeal(
      algorithm: _i3.identical(algorithm, _sentinel)
          ? this.algorithm
          : (algorithm as _i4.MessageSealAlgorithmModel),
      computedHash: _i3.identical(computedHash, _sentinel)
          ? this.computedHash
          : (computedHash as _i3.String?),
      sealedHash: _i3.identical(sealedHash, _sentinel)
          ? this.sealedHash
          : (sealedHash as _i3.String?),
      state: _i3.identical(state, _sentinel)
          ? this.state
          : (state as _i5.MessageSealStateModel),
    ) as $Res);
  }
}
