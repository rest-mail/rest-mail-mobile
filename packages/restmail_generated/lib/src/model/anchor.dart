// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class Anchor extends _i1.ObjectParameterEncodable implements _i1.UriEncodable {
  const Anchor({required this.hash, required this.seq});

  factory Anchor.fromSimple(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'hash', r'seq'},
      listKeys: {},
      context: r'Anchor',
    );
    return Anchor(
      hash: _$values[r'hash'].decodeSimpleString(context: r'Anchor.hash'),
      seq: _$values[r'seq'].decodeSimpleInt(context: r'Anchor.seq'),
    );
  }

  factory Anchor.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'Anchor');
    return Anchor(
      hash: _$map[r'hash'].decodeJsonString(context: r'Anchor.hash'),
      seq: _$map[r'seq'].decodeJsonInt(context: r'Anchor.seq'),
    );
  }

  factory Anchor.fromForm(_i3.String? value, {required _i3.bool explode}) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'hash', r'seq'},
      listKeys: {},
      context: r'Anchor',
    );
    return Anchor(
      hash: _$values[r'hash'].decodeFormString(context: r'Anchor.hash'),
      seq: _$values[r'seq'].decodeFormInt(context: r'Anchor.seq'),
    );
  }

  final _i3.String hash;

  final _i3.int seq;

  @_i3.override
  _i3.Object? toJson() => {r'hash': hash, r'seq': seq};

  $$AnchorCopyWith<Anchor> get copyWith => _AnchorCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is Anchor && other.hash == this.hash && other.seq == this.seq;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([hash, seq]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'hash'] = _i1.PropertyValue.scalar(hash);
    _$result[r'seq'] = _i1.PropertyValue.scalar(seq.toString());
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
      r'Cannot uriEncode Anchor: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$AnchorCopyWith<$Res> {
  factory $$AnchorCopyWith(Anchor value) = _AnchorCopyWith<$Res>;

  $Res call({_i3.String? hash, _i3.int? seq});
  _i3.String get hash;
  _i3.int get seq;
}

class _AnchorCopyWith<$Res> implements $$AnchorCopyWith<$Res> {
  _AnchorCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final Anchor _value;

  @_i3.override
  _i3.String get hash => _value.hash;

  @_i3.override
  _i3.int get seq => _value.seq;

  @_i3.override
  $Res call({_i3.Object? hash = _sentinel, _i3.Object? seq = _sentinel}) {
    return (Anchor(
      hash: _i3.identical(hash, _sentinel) ? this.hash : (hash as _i3.String),
      seq: _i3.identical(seq, _sentinel) ? this.seq : (seq as _i3.int),
    ) as $Res);
  }
}
