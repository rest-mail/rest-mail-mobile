// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SetDkimKeyBody extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SetDkimKeyBody({required this.privateKey, required this.selector});

  factory SetDkimKeyBody.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'private_key', r'selector'},
      listKeys: {},
      context: r'SetDkimKeyBody',
    );
    return SetDkimKeyBody(
      privateKey: _$values[r'private_key'].decodeSimpleString(
        context: r'SetDkimKeyBody.private_key',
      ),
      selector: _$values[r'selector'].decodeSimpleString(
        context: r'SetDkimKeyBody.selector',
      ),
    );
  }

  factory SetDkimKeyBody.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SetDkimKeyBody');
    return SetDkimKeyBody(
      privateKey: _$map[r'private_key'].decodeJsonString(
        context: r'SetDkimKeyBody.private_key',
      ),
      selector: _$map[r'selector'].decodeJsonString(
        context: r'SetDkimKeyBody.selector',
      ),
    );
  }

  factory SetDkimKeyBody.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'private_key', r'selector'},
      listKeys: {},
      context: r'SetDkimKeyBody',
    );
    return SetDkimKeyBody(
      privateKey: _$values[r'private_key'].decodeFormString(
        context: r'SetDkimKeyBody.private_key',
      ),
      selector: _$values[r'selector'].decodeFormString(
        context: r'SetDkimKeyBody.selector',
      ),
    );
  }

  final _i3.String privateKey;

  final _i3.String selector;

  @_i3.override
  _i3.Object? toJson() => {r'private_key': privateKey, r'selector': selector};

  $$SetDkimKeyBodyCopyWith<SetDkimKeyBody> get copyWith =>
      _SetDkimKeyBodyCopyWith(this);

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetDkimKeyBody &&
        other.privateKey == this.privateKey &&
        other.selector == this.selector;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([privateKey, selector]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'private_key'] = _i1.PropertyValue.scalar(privateKey);
    _$result[r'selector'] = _i1.PropertyValue.scalar(selector);
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
      r'Cannot uriEncode SetDkimKeyBody: complex types cannot be URI-encoded',
    );
  }
}

abstract class $$SetDkimKeyBodyCopyWith<$Res> {
  factory $$SetDkimKeyBodyCopyWith(SetDkimKeyBody value) =
      _SetDkimKeyBodyCopyWith<$Res>;

  $Res call({_i3.String? privateKey, _i3.String? selector});
  _i3.String get privateKey;
  _i3.String get selector;
}

class _SetDkimKeyBodyCopyWith<$Res> implements $$SetDkimKeyBodyCopyWith<$Res> {
  _SetDkimKeyBodyCopyWith(this._value);

  static const _sentinel = _i3.Object();

  final SetDkimKeyBody _value;

  @_i3.override
  _i3.String get privateKey => _value.privateKey;

  @_i3.override
  _i3.String get selector => _value.selector;

  @_i3.override
  $Res call({
    _i3.Object? privateKey = _sentinel,
    _i3.Object? selector = _sentinel,
  }) {
    return (SetDkimKeyBody(
      privateKey: _i3.identical(privateKey, _sentinel)
          ? this.privateKey
          : (privateKey as _i3.String),
      selector: _i3.identical(selector, _sentinel)
          ? this.selector
          : (selector as _i3.String),
    ) as $Res);
  }
}
